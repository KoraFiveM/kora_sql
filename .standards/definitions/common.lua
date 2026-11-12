---@meta

---@meta

Citizen = {}

---Creates a coroutine to handle code asynchronously. The coroutine will be executed on the next tick.
---@param threadFunction fun(threadId?: integer) The function to run in the coroutine. ``threadId`` is the id of the thread.
---@return integer clearId Used to clear the coroutine before it gets executed.
---@see Citizen.CreateThreadNow if you want to execute the coroutine immediately.
---@see Citizen.ClearTimeout if you want to clear the coroutine before it gets executed.
function Citizen.CreateThread(threadFunction) end

CreateThread = Citizen.CreateThread

---Creates a coroutine to handle code asynchronously, executing immediately.
---@param threadFunction fun(threadId?: integer) The function to run in the coroutine immediately. ``threadId`` is the id of the thread.
---@return boolean; Returns true if the coroutine was yielded.
---@see Citizen.CreateThread if you want to execute the coroutine on the next tick.
function Citizen.CreateThreadNow(threadFunction) end

---Executes a coroutine after the given time has passed in milliseconds.
---@param msec number The time in milliseconds after which the callback should be executed.
---@param callback fun(threadId?: integer) The callback function to execute after the timeout in a new coroutine. The threadId is the id of the thread.
---@return integer clearId Used to clear the coroutine before it gets executed.
---@see Citizen.ClearTimeout if you want to clear the coroutine before it gets executed.
function Citizen.SetTimeout(msec, callback) end

SetTimeout = Citizen.SetTimeout

---Cancels a coroutine before it gets executed.
---@param id integer The time in milliseconds after which the callback should be executed.
---@return boolean removed Returns true if the coroutine was cancelled.
function Citizen.ClearTimeout(id) end

ClearTimeout = Citizen.ClearTimeout

---Yields a coroutine, pausing execution for the given time in milliseconds
---@param msec number The number of milliseconds to wait.
function Citizen.Wait(msec) end

Wait = Citizen.Wait

---Outputs the message to trace listeners, including the console and log file.
---@param message string | number
function Citizen.Trace(message) end

---Yields a coroutine until a promise has been resolved.
---@param promise promise
---@return unknown
function Citizen.Await(promise) end

---Can invoke a native from a hex, It should primarily be used for undocumented natives or in situations where the provided documentation is incorrect.
---@param hash number The hash of the native function to invoke.
---@return ...; The return value of the native function.
function Citizen.InvokeNative(hash, ...) end

---Invokes a native game function with support for more complex return types.
---@param nativeHash string The hash of the native function to invoke.
---@return ...; The return value of the native function.
function Citizen.InvokeNative2(nativeHash, ...) end

---Loads a game native function for later invocation.
---@param nativeNative string The name of the native function to load.
---@return function | nil; The native function if it was successfully loaded, nil otherwise.
function Citizen.LoadNative(nativeNative) end

---Gets the function handle of the native hash.
---@param nativeHash number The hash of the native.
---@return fun(...): ... ; The native function. This will always return a function, even if the native is invalid.
function Citizen.GetNative(nativeHash) end

---Retrieves an initialized float value from a pointer. Same as `Citizen.PointerValueInt`, but this assumes the pointer is initialized.
---@param pointer integer; The pointer to the address in the memory.
---@return userdata; The data retrieved by the pointer.
function Citizen.PointerValueIntInitialized(pointer) end

---Retrieves an initialized integer value from a pointer. Same as `Citizen.PointerValueFloat`, but this assumes the pointer is initialized.
---@param pointer integer; The pointer to the address in the memory.
---@return userdata; The data retrieved by the pointer.
function Citizen.PointerValueFloatInitialized(pointer) end

---Retrieves an integer value from a pointer.
---@return userdata; The data retrieved by the pointer.
function Citizen.PointerValueInt() end

---Retrieves a float value from a pointer.
---@return userdata; The data retrieved by the pointer.
function Citizen.PointerValueFloat() end

---Retrieves a vector value from a pointer.
---@return userdata; The data retrieved by the pointer.
function Citizen.PointerValueVector() end

---Specifies that a result should be returned regardless of success.
---@return any; The result.
function Citizen.ReturnResultAnyway() end

---Converts the result of a native invocation to an integer.
---@return integer; The result as an integer.
function Citizen.ResultAsInteger() end

---Converts the result of a native invocation to a long integer.
---@return integer; The result as a long integer.
function Citizen.ResultAsLong() end

---Converts the result of a native invocation to a float.
---@return number; The result as a float.
function Citizen.ResultAsFloat() end

---Converts the result of a native invocation to a string.
---@return string; The result as a string.
function Citizen.ResultAsString() end

---Converts the result of a native invocation to a vector.
---@return vector; The result as a vector.
function Citizen.ResultAsVector() end

---@see Citizen.ResultAsObject2 Because this is unused in all native loaders.
function Citizen.ResultAsObject() end

---Converts the result of a native invocation to an object. In most of the instances where this is used, it is passed as the first argument to the ``msgpack.unpack`` function.
---@return table; The result as an object.
---@param msgpack_unpack function
---```LUA
---Citizen.ResultAsObject2(msgpack.unpack)
---```
function Citizen.ResultAsObject2(msgpack_unpack) end
---@meta

---[lua-rapidjson](https://github.com/citizenfx/lua-rapidjson/tree/grit)
json = {}

---@alias json_options
---Created string will contain newlines and indentations.
---| 'indent'
---Alias of "indent".
---| 'pretty'
---Sort keys of a table prior to encoding.
---| 'sort_keys'
---If enabled use lua_pushnil, otherwise the json.null sentinel.
---| 'null'
---Write null instead of throwing a LUA_RAPIDJSON_ERROR_DEPTH_LIMIT error when the encoding depth exceeds 'max_depth'.
---| 'nesting'
---Encode integers as unsigned integers/values.
---| 'unsigned'
---Allow writing of Infinity, -Infinity and NaN.
---| 'nan'
---Alias of "nan".
---| 'inf'
---Encode integers as 32-bit values.
---| 'bit32'
---Use sprintf instead of rapidjson's native Grisu2.
---| 'lua_format_float'
---Massage Grisu2 by rounding at maxDecimalsPlaces.
---| 'lua_round_float'
---Format arrays on a single line.
---| 'single_line'
---Empty tables encoded as array.
---| 'empty_table_as_array'
---Allow tables to be encoded as arrays iff all keys are positive integers, inserting "nil"s when encoding to satisfy the array type.
---| 'with_hole'
---Maximum table recursion depth.
---| 'max_depth'
---Index for indentation (0 = ' ', 1 = '\t', 2 = '\n', 3 = '\r').
---| 'indent_char'
---Number of indent characters for each indentation level.
---| 'indent_count'
---Alias of "indent_count".
---| 'level'
---The maximum number of decimal places for double output.
---| 'decimal_count'
---["default", "extended"] - Preset parsing configuration. "extended" enables all fields (see rapidjson::ParseFlag).
---| 'decoder_preset'
---| 'sentinel'

---Return the current value of the global encoding/decoding option.
---@param option json_options
function json.getoption(option) end

---Set a global encoding/decoding option.
---@param option json_options
---@param value any
function json.setoption(option, value) end

---@type lightuserdata
json.null = nil
json.sentinel = json.null

---@class json_encode_state
---When set, the created string will contain newlines and indentation. Otherwise it will be one long line.
---@field indent? boolean
---Alias of indent.
---@field pretty? boolean
---Set `true` to sort the JSON object keys.
---@field sort_keys? boolean
---The initial level of indentation used when indent is set. For each level two spaces are added; when absent it defaults to 0.
---Empty tables encoded as array.
---@field empty_table_as_array? boolean
---Allow tables to be encoded as arrays iff all keys are positive integers, inserting "nil"s when encoding to satisfy the array type.
---@field with_hole? boolean
---Maximum table recursion depth.
---@field indent_amt? integer
---An array to specify the ordering of keys in the encoded output. If an object has keys which are not in this array they are written after the sorted keys.
---@field keyorder? table
---A function to call when the encoder cannot encode a given value.
---@field exception? fun(reason: 'reference cycle' | 'custom encoder failed' | 'unsupported type' | 'error encoding number', value: string): string?, string?

---Create a string representing an object.
---@param object any
---@param state? json_encode_state
---@return string
function json.encode(object, state) end

---Decode a JSON encoded string.
---@param string string
---@param position? integer Decode string starting at position or 1 if omitted.
---@param null? any An optional value to return for null values, defaulting to onil.
---@param objectmeta? table A metatable to assign to a decoded object instead of the builtin rapidjson table.
---@param arraymeta? table A metatable to assign to a decoded array instead of the builtin rapidjson table.
---@return any? object, integer? errPos, string? errMessage
function json.decode(string, position, null, objectmeta, arraymeta) end

---@return table
---Returns a metatable with the 'object' __jsontype field.
function json.object() end

---@return table
---Returns a metatable with the 'array' __jsontype field.
function json.array() end

---Return true if the provided table has metatable with an 'object' __jsontype field.
---@param value table
---@return boolean
function json.isobject(value) end

---Return true if the provided table has metatable with an 'array' __jsontype field.
---@param value table
---@return boolean
function json.isarray(value) end

---@meta

---[citizenfx/lua-cmsgpack](https://github.com/citizenfx/lua-cmsgpack/tree/grit)
msgpack = {}

---@alias msgpack_options
---| 'float'
---| 'double'
---| 'integer'
---| 'unsigne'
---| 'string_compat'
---| 'string_binary'
---| 'always_as_map'
---| 'without_hole'
---| 'with_hole'
---| 'empty_table_as_array'
---| 'sentinel'
---| 'ignore_invalid'
---| 'small_lua'
---| 'full64bits'
---| 'long_double'

---Return the value of a global encoding/decoding option. See [citizenfx/lua-cmsgpack#configuration](https://github.com/citizenfx/lua-cmsgpack/tree/grit#configuration).
---@param option msgpack_options
function msgpack.getoption(option) end

---Set a global encoding/decoding option. See [citizenfx/lua-cmsgpack#configuration](https://github.com/citizenfx/lua-cmsgpack/tree/grit#configuration).
---@param option msgpack_options
---@param value any
function msgpack.setoption(option, value) end

---@type lightuserdata
msgpack.null = nil
msgpack.sentinel = msgpack.null

---Receives any number of arguments and pack their values.
---See [citizenfx/lua-cmsgpack#packing](https://github.com/citizenfx/lua-cmsgpack/tree/grit#packing).
---@return string
function msgpack.pack(...) end

---Receives any number of arguments and pack their values as an array, handling intermediate nil values.
---See [citizenfx/lua-cmsgpack#packing](https://github.com/citizenfx/lua-cmsgpack/tree/grit#packing).
---@return string
function msgpack.pack_args(...) end

---Create, and place onto the Lua stack, a new userdata that can be used to pack Lua values.
---See [citizenfx/lua-cmsgpack#packing](https://github.com/citizenfx/lua-cmsgpack/tree/grit#packing).
---@return userdata
function msgpack.new() end

---See [citizenfx/lua-cmsgpack#unpacking](https://github.com/citizenfx/lua-cmsgpack/tree/grit#unpacking).
---@param encoded_string string
---@param offset number? Offset within the encoded string to start decoding.
---@param limit number? Number of Lua objects to decode, 0 to decode the entire string.
---@param end_position number? Length of the encoded substring (starting at offset).
---@return any
function msgpack.unpack(encoded_string, offset, limit, end_position) end

---Unpack all elements, up to a potential limit, from a msgpack encoded string.
---Returning (1) the position in the string where the decoding ended, 0 for
---completion; and (2) and all decoded objects (up to limit).
---@param encoded_string string
---@param position number? Offset within the encoded string to start decoding.
---@param limit number? Number of Lua objects to decode, 0 to decode the entire string.
---@param end_position number? Length of the encoded substring (starting at offset).
---@return number position
---@return any element
function msgpack.next(encoded_string, position, limit, end_position) end

---Register an extension-type with a pack and unpack methods, and a unique identifier.
---See [citizenfx/lua-cmsgpack#extensions](https://github.com/citizenfx/lua-cmsgpack/tree/grit#extensions).
---@param encoder table
function msgpack.extend(encoder) end

---Get the extension-type definition for encoding/decoding tables/userdata definitions.
---See [citizenfx/lua-cmsgpack#extensions](https://github.com/citizenfx/lua-cmsgpack/tree/grit#extensions).
---@return table
function msgpack.extend_get(ext_id) end

---Explicitly remove the extension definition for all type identifiers provided.
---See [citizenfx/lua-cmsgpack#extensions](https://github.com/citizenfx/lua-cmsgpack/tree/grit#extensions).
---@vararg string
function msgpack.extend_clear(...) end

---Associate the name of a Lua type to an encoder table.
---@param type_string string
---@param ext_id number?
function msgpack.settype(type_string, ext_id) end

---Get the encoder table associated to the name of a Lua type.
---@param type_string string
---@return table
function msgpack.gettype(type_string) end

---Setoption that only processes: "string", "string_compat", "string_binary".
---@param string_value string
function msgpack.set_string(string_value) end

---Setoption that only processes: "without_hole", "with_hole", "always_as_map".
---@param array_value string
function msgpack.set_array(array_value) end

---Setoption that only processes: "signed", "unsigned".
---@param integer_value string
function msgpack.set_integer(integer_value) end

---Setoption that only processes: "float", "double".
---@param number_value string
function msgpack.set_number(number_value) end

---@meta

-- https://github.com/citizenfx/lua/blob/luaglm-dev/cfx/README.md
-- https://github.com/citizenfx/lua/blob/luaglm-dev/cfx/EXTENDED.md
-- investigation into custom types and functions is slowly ongoing

---@class vector2
---@field x number
---@field y number
---@field r number
---@field g number
---@field [1] number
---@field [2] number
---@field xy vector2
---@operator add(vector2|number): vector2
---@operator sub(vector2|number): vector2
---@operator mul(vector2|number): vector2
---@operator div(vector2|number): vector2
---@operator unm: vector2
---@operator len: number
---@field n 2

---@class vector3 : vector2
---@field z number
---@field b number
---@field [3] number
---@field xyz vector3
---@operator add(vector3|number): vector3
---@operator sub(vector3|number): vector3
---@operator mul(vector3|number): vector3
---@operator div(vector3|number): vector3
---@operator unm: vector3
---@field n 3

---@class vector4 : vector3
---@field w number
---@field a number
---@field [4] number
---@field xyzw vector4
---@operator add(vector4|number): vector4
---@operator sub(vector4|number): vector4
---@operator mul(vector4|number): vector4
---@operator div(vector4|number): vector4
---@operator unm: vector4
---@field n 4

---@alias vector vector2 | vector3 | vector4
---@class quat : vector4
---@class matrix<T>: { [number]: T }

---Compute the Jenkins hash of the input string.\
---If 'ignore_casing' is true, the byte data is hashed as is. Otherwise, each\
---ASCII character is tolower'd prior to hashing.
---```
--- joaat("Hello, World!")
--- 1395890823
---```
---@param input any
---@param ignore_casing? boolean
---@return number
function joaat(input, ignore_casing) end

---Creates a new empty table.
---@param narr number a hint for how many elements the table will contain in a sequence.
---@param nrec number a hint for how many other elements the table will have.
---@return table
function table.create(narr, nrec) end

---Restore the table to its initial value (removing its contents) while retaining its internal pointer.
---@param t table
---@return table
function table.wipe(t) end

---An efficient table shallow-copy implementation using memcpy.
--- @generic T
--- @param t T
--- @param t2? table a preallocated destination table
--- @return T
function table.clone(t, t2) end

---Return the type of table being used, either "empty", "array", "hash", or "mixed".\
---Once an array becomes mixed or has its values nil'd it will remain "mixed" or "hash".
---@param t table
---@return 'empty' | 'array' | 'hash' | 'mixed'
function table.type(t) end

---Joins strings together with a delimiter.
---@param delimiter string
---@return string
function string.strjoin(delimiter, ...) end

---Trim characters off the beginning and end of a string.
---@param input string
---@param chars? string
---@return string
function string.strtrim(input, chars) end

---Returns a concatenation of all number/string arguments passed.
---@return string
function string.strconcat(...) end

---Splits a string using a delimiter (optionally: into a specified number of pieces).
---@param delimiter string
---@param string string
---@param pieces? number
---@return ...
function string.strsplit(delimiter, string, pieces) end

--- Converts all arguments to strings.
---@return string ...
function string.tostringall(...) end

utf8.strlenutf8 = utf8.len

---String comparison accounting for UTF-8 chars. Returning a negative integer,\
---zero, or a positive integer if the first string is less than, equal to, or\
---greater than the second string.
---@param stringLH string
---@param stringRH string
function utf8.strcmputf8i(stringLH, stringRH) end

--- Return all arguments with non-number/boolean/string values changed to nil.
---@return number | boolean | string | nil ...
function scrub(...) end

---@param x number
---@return number
---@overload fun(x: number, y: number): vector2
---@overload fun(x: number, y: number, z: number): vector3
---@overload fun(x: number, y: number, z: number, w: number): vector4
---@overload fun(q: quat): vector4
function vector(x) end

---@param x number
---@param y number
---@return vector2
---@overload fun(n: number): vector2
function vector2(x, y) end

---@param x number
---@param y number
---@param z number
---@return vector3
---@overload fun(n: number): vector3
function vector3(x, y, z) end

---@param x number
---@param y number
---@param z number
---@param w number
---@return vector4
---@overload fun(n: number): vector4
---@overload fun(q: quat): vector4
function vector4(x, y, z, w) end

vec = vector
vec2 = vector2
vec3 = vector3
vec4 = vector4

---@generic T: vector
---@param x T
---@param y T
---@param z? T
---@param w? T
---@return matrix<T>
function mat(x, y, z, w) end

---@return matrix<vector2>
function mat2(...) end

mat2x2 = mat2
mat3x2 = mat2
mat4x2 = mat2

---@return matrix<vector3>
function mat3(...) end

mat2x3 = mat3
mat3x3 = mat3
mat4x3 = mat3

---@return matrix<vector4>
function mat4(...) end

mat2x4 = mat4
mat3x4 = mat4
mat4x4 = mat4

---Returns the dot product of x and y.
---@param x number
---@param y number
---@return number
---@overload fun(x: vector2, y: vector2): number
---@overload fun(x: vector3, y: vector3): number
---@overload fun(x: vector4, y: vector4): number
---@overload fun(x: quat, y: quat): number
function dot(x, y) end

---Returns the cross product of x and y.
---@param x vector2
---@param y vector2
---@return number
---@overload fun(x: vector3, y: vector3): vector3
---@overload fun(x: quat, y: quat): quat
---@overload fun(x: vector3 | quat, y: vector3 | quat): vector3
function cross(x, y) end

---Returns the quaternion inverse, or inverse of a squared matrix.
---@generic T: matrix | quat
---@param v T
---@return T
function inverse(v) end

---Returns a vector in the same direction as x but with length of 1.
---@generic T: vector | quat
---@param v T
---@return T
function norm(v) end

---Returns spherical interpolation between two vectors.
---@param x vector
---@param y vector
---@param t number
---@return vector
---@overload fun(x: quat, y: quat, t: number): quat
function slerp(x, y, t) end

---@nodiscard
---@param fn function
---When assigned to a to-be-closed variable it will call the function once the variable falls out of scope.
function defer(fn) end

---@todo
each = pairs

---@param w number
---@param x number
---@param y number
---@param z number
---@return quat
---@overload fun(): quat
---@overload fun(xyz: vector3, target: vector3): quat
---@overload fun(angle: number, axis: vector3): quat
---@overload fun(matrix: matrix): quat
function quat(w, x, y, z) end

---Returns the current time in nanoseconds.
---@return number
function os.nanotime() end

---Returns the current time in microseconds
---@return number
function os.microtime() end

---@class KoraExports
---@field [string] table<string, function>
---@overload fun(name: string, callback: function)
exports = {}
---@class KoraEventHandler
---@field name string
---@field key integer
---@param name string
---@param callback function
---@return KoraEventHandler
function AddEventHandler(name, callback) end
---@param handler KoraEventHandler
function RemoveEventHandler(handler) end
---@param name string
---@param callback? function
function RegisterNetEvent(name, callback) end
---@param name string
---@param ... any
function TriggerEvent(name, ...) end
---@class StateBag
---@field set fun(self: StateBag, key: string, value: any, replicated?: boolean)
---@field [string] any
---@class EntityInterface
---@field state StateBag
---@param entity integer
---@return EntityInterface
function Entity(entity) end
---@param src integer|string
---@return EntityInterface
function Player(src) end
---@type StateBag
GlobalState = {}

---@type {new: fun(): promise}
promise = {}
