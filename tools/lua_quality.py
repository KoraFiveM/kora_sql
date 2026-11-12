#!/usr/bin/env python3
"""Kora local Lua checks. No downloads, source execution, or implicit formatting."""
import argparse
import fnmatch
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

REVISION = '2026-11-12.1'
REALMS = ('client', 'server', 'shared', 'manifest', 'test')


def read_json(path):
    return json.loads(path.read_text(encoding='utf-8'))


def run(command, **kwargs):
    return subprocess.run(command, check=False, timeout=120, **kwargs)


def executable(name, version):
    value = os.environ.get('KORA_' + name.upper().replace('-', '_'), name)
    path = shutil.which(value)
    if not path:
        raise ValueError(f'Missing {name} {version}; see .standards/README.md for installation.')
    result = run([path, '--version'], capture_output=True, text=True)
    if result.returncode or not re.fullmatch(r'(?:stylua\s+)?' + re.escape(version), (result.stdout + result.stderr).strip()):
        raise ValueError(f'{name} must be version {version}: {result.stdout}{result.stderr}')
    return path


def excluded(relative, config):
    return any(fnmatch.fnmatchcase(relative, pattern) for pattern in config['exclude'])


def inventory(root, config):
    result = {}
    for realm in REALMS:
        for pattern in config['realms'][realm]:
            matches = sorted(root.glob(pattern))
            if not matches:
                raise ValueError(f'Stale {realm} source entry: {pattern}')
            for path in matches:
                if not path.is_file() or path.suffix != '.lua':
                    raise ValueError(f'Not a Lua source file: {pattern}')
                relative = path.relative_to(root).as_posix()
                if excluded(relative, config):
                    raise ValueError(f'Source entry is also excluded: {relative}')
                if relative in result and result[relative] != realm:
                    raise ValueError(f'Ambiguous realm for {relative}')
                if not path.resolve().is_relative_to(root):
                    raise ValueError(f'Source escapes checkout: {relative}')
                result[relative] = realm
    # New Lua files must be assigned deliberately; never infer a realm at check time.
    for directory, dirs, names in os.walk(root, followlinks=False):
        base = Path(directory).relative_to(root)
        dirs[:] = [d for d in dirs if not excluded((base / d).as_posix() + '/', config)]
        for name in names:
            relative = (base / name).as_posix()
            if name.endswith('.lua') and not excluded(relative, config) and relative not in result:
                raise ValueError(f'Unclassified Lua source: {relative}; assign its realm in .standards/resource.json')
    return result


def select(root, sources, targets):
    if not targets:
        return sorted(sources)
    selected = set()
    for target in targets:
        path = (root / target).resolve()
        if not path.is_relative_to(root):
            raise ValueError(f'Target escapes checkout: {target}')
        relative = path.relative_to(root).as_posix()
        matches = [s for s in sources if s == relative or s.startswith(relative.rstrip('/') + '/') or relative == '.']
        if not matches:
            raise ValueError(f'No eligible Lua sources for target: {target}')
        selected.update(matches)
    return sorted(selected)


def definitions(root, realm):
    base = root / '.standards/definitions'
    names = ['manifest.lua'] if realm == 'manifest' else ['common.lua', 'native-shared.lua', 'kora-' + realm + '.lua', 'kora-extensions-shared.lua']
    if realm in ('client', 'server'):
        names += ['native-' + realm + '.lua', realm + '.lua']
    if realm == 'server':
        names += ['kora-extensions-server.lua']
    if realm == 'client':
        names += ['aliases-client.lua']
    if realm == 'test':
        names = ['common.lua', 'test.lua']
    paths = [base / name for name in names]
    for path in paths:
        if not path.is_file():
            raise ValueError(f'Missing definitions: {path}')
    return paths


def lint(root, sources, selected, realm_filter, binary):
    failed = False
    jobs = []
    for realm in REALMS:
        targets = [s for s in selected if sources[s] == realm or (realm in ('client', 'server') and sources[s] == 'shared')]
        if realm_filter and realm != realm_filter:
            continue
        if not targets:
            continue
        if realm == 'test':
            # Separate test programs deliberately redefine the same mock globals.
            # Follow literal local imports, never merge unrelated test entrypoints.
            for target in targets:
                context = {target}
                pending = [target]
                while pending:
                    current = pending.pop()
                    text = (root / current).read_text(encoding='utf-8')
                    imports = re.findall(r"(?:dofile|loadfile)\s*\(\s*['\"]([^'\"]+\.lua)['\"]", text)
                    imports += [name.replace('.', '/') + '.lua' for name in
                                re.findall(r"require\s*\(?\s*['\"]([^'\"]+)['\"]", text)]
                    for name in imports:
                        dependency = (root / name).resolve()
                        if not dependency.is_relative_to(root):
                            print(f'{current}: [test] unindexed-import: {name}; '
                                  'external test dependency is outside this checkout')
                            failed = True
                            continue
                        relative = dependency.relative_to(root).as_posix()
                        if relative in sources and relative not in context:
                            context.add(relative)
                            pending.append(relative)
                jobs.append((realm, [target], sorted(context)))
        else:
            # A shared-only pass catches realm APIs accidentally added to shared code.
            context = [s for s, r in sources.items() if r == realm or (realm in ('client', 'server') and r == 'shared')]
            jobs.append((realm, targets, context))
    for realm, targets, context in jobs:
        with tempfile.TemporaryDirectory(prefix='kora-lua-' + realm + '-') as temporary:
            work = Path(temporary)
            workspace = work / 'src'
            library = work / 'definitions'
            library.mkdir()
            for path in definitions(root, realm):
                shutil.copyfile(path, library / path.name)
            for local_realm in ([realm, 'shared'] if realm in ('client', 'server') else [realm]):
                local_defs = root / '.standards' / ('definitions-' + local_realm)
                if local_defs.exists():
                    shutil.copytree(local_defs, library / ('resource-' + local_realm))
            for name in context:
                dest = workspace / name
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(root / name, dest)
            config = {
                'runtime.version': 'Lua 5.4',
                'runtime.nonstandardSymbol': ['`', '+=', '-=', '*=', '/=', '<<=', '>>=', '&=', '|=', '^='],
                'workspace.library': [str(library)],
                'workspace.checkThirdParty': False,
                'workspace.useGitIgnore': False,
                'diagnostics.libraryFiles': 'Disable',
                'diagnostics.globals': [],
                'diagnostics.severity': {
                    'unused-local': 'Warning', 'unused-function': 'Warning', 'unused-label': 'Warning',
                },
            }
            config_path = work / 'config.json'
            config_path.write_text(json.dumps(config), encoding='utf-8')
            print(f'LuaLS [{realm}] ({len(context)} context files)', flush=True)
            # Analyze the full context, report selected files. Definitions/mocks from other realms never enter it.
            result = run([binary, '--check=' + str(workspace), '--checklevel=Warning',
                          '--configpath=' + str(config_path), '--logpath=' + str(work / 'logs'),
                          '--metapath=' + str(work / 'meta'), '--check_format=json',
                          '--check_out_path=' + str(work / 'check.json')],
                         capture_output=True, text=True)
            report = work / 'check.json'
            if not report.exists():
                print(result.stdout + result.stderr)
                raise ValueError(f'LuaLS did not produce diagnostics for {realm} (exit {result.returncode})')
            diagnostics = read_json(report)
            # LuaLS serializes an empty diagnostic map as [] in JSON mode.
            if diagnostics == []:
                diagnostics = {}
            if not isinstance(diagnostics, dict):
                raise ValueError(f'Invalid LuaLS diagnostic report for {realm}')
            count = 0
            for uri, entries in diagnostics.items():
                # LuaLS stores URI keys; spaces and other filename characters are percent encoded.
                from urllib.parse import unquote, urlparse
                file_path = Path(unquote(urlparse(uri).path))
                try:
                    relative = file_path.relative_to(workspace).as_posix()
                except ValueError:
                    continue
                if relative not in targets:
                    continue
                for entry in entries:
                    if entry.get('severity', 1) > 2:
                        continue
                    pos = entry['range']['start']
                    print(f"{relative}:{pos['line'] + 1}:{pos['character'] + 1}: [{realm}] "
                          f"{entry.get('code', 'diagnostic')}: {entry['message']}")
                    count += 1
            print(f'{realm}: {count} errors/warnings')
            failed |= count > 0
            if result.returncode not in (0, 1):
                raise ValueError(f'LuaLS failed (exit {result.returncode}): {result.stderr}')
    return int(failed)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['check', 'format', 'lint', 'list'])
    parser.add_argument('files', nargs='*', help='checkout-relative files/directories; format requires explicit targets')
    parser.add_argument('--realm', choices=REALMS, help='lint only this realm')
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    root = args.root.resolve()
    try:
        config = read_json(root / '.standards/resource.json')
        lock = read_json(root / '.standards/versions.json')
        if lock['standardsRevision'] != REVISION or config['standardsRevision'] != REVISION:
            raise ValueError('Standards runner/config revision mismatch; update the tooling snapshot together')
        sources = inventory(root, config)
        selected = select(root, sources, args.files)
        if args.realm:
            selected = [s for s in selected if sources[s] == args.realm or
                        (args.realm in ('client', 'server') and sources[s] == 'shared')]
        if not selected:
            raise ValueError('No Lua files selected')
        if args.action == 'list':
            for name in selected:
                print(sources[name] + '\t' + name)
            return 0
        if args.action == 'format' and not args.files:
            raise ValueError('format requires explicit file or directory targets')
        # Validate both tools before running check, so missing lint cannot masquerade as a format-only pass.
        formatter = executable('stylua', lock['stylua']) if args.action in ('format', 'check') else None
        luals = executable('lua-language-server', lock['luaLS']) if args.action in ('lint', 'check') else None
        failed = 0
        if formatter:
            command = [formatter, '--config-path', str(root / '.stylua.toml')]
            if args.action == 'check':
                command += ['--check']
            # Batch to avoid command-line limits without shell interpolation.
            for offset in range(0, len(selected), 100):
                failed |= int(run(command + ['--'] + selected[offset:offset + 100], cwd=root).returncode != 0)
        if luals:
            failed |= lint(root, sources, selected, args.realm, luals)
        return failed
    except (ValueError, OSError, KeyError, subprocess.TimeoutExpired) as error:
        print(f'Lua tooling error: {error}', file=sys.stderr)
        return 2


if __name__ == '__main__':
    sys.exit(main())
