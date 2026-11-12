---@meta
-- Snapshot of kora_lib/types.lua, filtered by documented realm markers.
-- Annotation-only kora_lib public API. This file is shipped for LuaLS indexing
-- but is never loaded as a client, server, or shared runtime script.

---@class promise
---@field state string
---@field resolve fun(self: promise, value: any)
---@field reject fun(self: promise, error: any)
---@field next fun(self: promise, onResolved?: fun(value: any), onRejected?: fun(error: any)): promise
---@field catch fun(self: promise, onRejected: fun(error: any)): promise

---@class QBCoords
---@field x number
---@field y number
---@field z number
---@field w? number
---@field heading? number

---@class QBSpatialVector
---@field x number
---@field y number
---@field z? number
---@field w? number
---@field heading? number

---@class QBRateLimit
---@field max integer Maximum accepted calls in the sliding window (1–10000).
---@field window integer Sliding-window length in milliseconds (1–86400000).

---@class QBRandomPickOptions
---@field count? integer Number of independent picks. Defaults to 1.
---@field maxIndex? integer Highest eligible array index. Defaults to the array length.

---@alias QBScreenshotEncoding 'jpg'|'png'|'webp'

---@class QBScreenshotOptions
---@field encoding? QBScreenshotEncoding Defaults to `Config.screenshot.defaultEncoding`.
---@field quality? number Image encoder quality from 0 to 1.
---@field maxWidth? integer|false Default output width ceiling; false leaves it unbounded.
---@field maxHeight? integer|false Default output height ceiling; false leaves it unbounded.
---@field includeNui? boolean Accepted for screenshot-basic compatibility; separate CEF layers cannot be captured.
---@field fileName? string Server-only destination path. Never accept this from a client event.
---@field timeout? integer Server-only request timeout in milliseconds; must be greater than 1000.

---@class QBRegistrationOptions
---@field rateLimit? QBRateLimit|false Client-to-server registrations only; omitted/false is unlimited.

---@class QBResourcesRegistry
---@field track fun(resource: string, id: any)
---@field untrack fun(id: any): string?
---@field owner fun(id: any): string?

---@class QBResourceAwaitOptions
---@field timeout? number Defaults to 10000 milliseconds.
---@field interval? number Defaults to 100 milliseconds.

---@class QBCooldownHandle
---@field use fun(key: any): boolean
---@field remaining fun(key: any): integer
---@field reset fun(key?: any)

---@class QBKeybindOptions
---@field name string Stable command name without whitespace.
---@field description string FiveM settings label.
---@field defaultKey? string Primary key, or empty for unbound.
---@field defaultMapper? string Defaults to `keyboard`.
---@field secondaryKey? string Alternate key registered as `~!+command`.
---@field secondaryMapper? string Defaults to the primary mapper.
---@field disabled? boolean Initial disabled state.
---@field onPressed? fun(handle: QBKeybindHandle)
---@field onReleased? fun(handle: QBKeybindHandle)

---@class QBKeybindHandle
---@field name string
---@field description string
---@field defaultKey string
---@field defaultMapper string
---@field secondaryKey? string
---@field secondaryMapper string
---@field resource string
---@field disable fun(toggle: boolean): boolean
---@field isDisabled fun(): boolean
---@field isPressed fun(): boolean
---@field getCurrentBinding fun(): string?
---@field remove fun(): boolean

---@class QBCommandSuggestion
---@field value string
---@field label? string
---@field help? string

---@class QBCommandSuggestionContext
---@field command string
---@field argumentIndex integer
---@field query string
---@field args string[]

---@class QBCommandArgument
---@field name string
---@field help string
---@field values? (string|number|QBCommandSuggestion)[]
---@field provider? fun(source: integer, context: QBCommandSuggestionContext): (string|number|QBCommandSuggestion)[]

---@class QBCommandKeybindOptions
---@field description? string Defaults to command help/name.
---@field defaultKey? string
---@field defaultMapper? string Defaults to `keyboard`.
---@field secondaryKey? string
---@field secondaryMapper? string

---@class QBCommandOptions
---@field permission? string Defaults to `user`.
---@field checkPermission? fun(source: integer, permission: string): boolean
---@field notify? fun(source: integer, message: string, type: string)
---@field resource? string
---@field keybind? QBCommandKeybindOptions

---@class QBCommandInfo
---@field name string
---@field help string
---@field permission string
---@field keybind? QBCommandKeybindOptions

---@class QBVehicleDeleteOptions
---@field timeout? integer Network-control timeout in milliseconds; defaults to 1000.

---@class QBVehicleNormalizePlateOptions
---@field maxLength? integer Defaults to 8.
---@field whitespace? 'collapse'|'remove'|'preserve'
---@field characters? 'alphanumeric'|'any'

---@class QBCleanTextOptions
---@field maxLength? integer
---@field whitespace? 'collapse'|'preserve'
---@field controlCharacters? 'remove'|'preserve'
---@field empty? 'nil'|'allow'

---@class KoraNearestOptions
---@field coordsOf fun(entry: any): QBSpatialVector
---@field radius? number Maximum distance to count as a match. Unbounded if omitted.
---@field bucketOf? fun(entry: any): any
---@field bucket? any Value `bucketOf` must match. Required alongside `bucketOf`.

---@class KoraRateLimiter
---@field consume fun(self: KoraRateLimiter, key: any, now: number): boolean, number?

---@class QBStreamLoadOptions
---@field timeout? integer Defaults to 10000 milliseconds.
---@field shouldContinue? fun(): boolean Cancels the wait when it returns false.

---@class QBVehicleSetPropertiesOptions
---@field timeout? integer Network-control timeout in milliseconds; defaults to 1000.

---@class QBVehicleProperties
---@field model? integer
---@field plate? string
---@field plateIndex? integer
---@field bodyHealth? number
---@field engineHealth? number
---@field tankHealth? number
---@field fuelLevel? number
---@field dirtLevel? number
---@field oilLevel? number
---@field color1? integer|integer[]|{r: integer, g: integer, b: integer}
---@field color2? integer|integer[]|{r: integer, g: integer, b: integer}
---@field pearlescentColor? integer
---@field dashboardColor? integer
---@field wheelColor? integer
---@field wheels? integer
---@field wheelSize? number
---@field wheelWidth? number
---@field tireHealth? table<integer|string, number>
---@field tireBurstState? table<integer|string, boolean>
---@field tireBurstCompletely? table<integer|string, boolean>
---@field windowTint? integer
---@field windowStatus? table<integer|string, boolean>
---@field doorStatus? table<integer|string, boolean>
---@field neonEnabled? boolean[]
---@field neonColor? integer[]|{r: integer, g: integer, b: integer}
---@field interiorColor? integer
---@field extras? table<integer|string, boolean>
---@field tyreSmokeColor? integer[]|{r: integer, g: integer, b: integer}
---@field xenonColor? integer|integer[]|{r: integer, g: integer, b: integer}
---@field modTurbo? boolean
---@field modSmokeEnabled? boolean
---@field modXenon? boolean
---@field modFrontWheels? integer
---@field modBackWheels? integer
---@field modCustomTiresF? boolean
---@field modCustomTiresR? boolean
---@field modLivery? integer
---@field liveryRoof? integer
---@field modSpoilers? integer
---@field modFrontBumper? integer
---@field modRearBumper? integer
---@field modSideSkirt? integer
---@field modExhaust? integer
---@field modFrame? integer
---@field modGrille? integer
---@field modHood? integer
---@field modFender? integer
---@field modRightFender? integer
---@field modRoof? integer
---@field modEngine? integer
---@field modBrakes? integer
---@field modTransmission? integer
---@field modHorns? integer
---@field modSuspension? integer
---@field modArmor? integer
---@field modKit17? integer
---@field modKit19? integer
---@field modKit21? integer
---@field modPlateHolder? integer
---@field modVanityPlate? integer
---@field modTrimA? integer
---@field modOrnaments? integer
---@field modDashboard? integer
---@field modDial? integer
---@field modDoorSpeaker? integer
---@field modSeats? integer
---@field modSteeringWheel? integer
---@field modShifterLeavers? integer
---@field modAPlate? integer
---@field modSpeakers? integer
---@field modTrunk? integer
---@field modHydrolic? integer
---@field modEngineBlock? integer
---@field modAirFilter? integer
---@field modStruts? integer
---@field modArchCover? integer
---@field modAerials? integer
---@field modTrimB? integer
---@field modTank? integer
---@field modWindows? integer
---@field modKit47? integer
---@field modKit49? integer

---@alias QBTextUIPosition 'left-center'|'right-center'|'top-center'|'bottom-center'
---@class QBTextUIOptions
---@field key? string
---@field icon? string
---@field position? QBTextUIPosition
---@field iconColor? string
---@field iconAnimation? 'spin'|'spinPulse'|'spinReverse'|'pulse'|'beat'|'fade'|'beatFade'|'bounce'|'shake'
---@field alignIcon? 'top'|'center'
---@field style? string|table<string, string|number>

---@class QBStateChange
---@field entity integer Entity resolved from the bag name, or 0 for global/player/unavailable bags.
---@field bagName string
---@field key string
---@field value any
---@field reserved integer
---@field replicated boolean

---@alias QBWorldEntityType 'ped'|'vehicle'|'object'|'player'
---@class QBWorldQueryOptions
---@field models? (integer|string)[]
---@field predicate? fun(entity: integer, coords: QBCoords, distance: number): boolean
---@field includeInvisible? boolean Client only.
---@field includeOwnPed? boolean Client only.
---@field excludeEntities? integer[]
---@field radius? number Used by `getClosestEntity`.

---@class QBWorldMatch
---@field entity integer
---@field coords QBCoords
---@field distance number

---@class QBWorldGroundOptions
---@field height? number
---@field attempts? integer
---@field retryDelay? integer

---@class QBWorldNearbyPlayerOptions
---@field maxDistance number
---@field sameBucket? boolean
---@field allowSelf? boolean

---@class QBTeleportOptions
---@field fade? boolean|number

---@class QBWaypointTeleportOptions: QBTeleportOptions
---@field entity? integer
---@field launchHeight? number
---@field collisionTimeout? integer
---@field groundAttempts? integer
---@field groundRetryDelay? integer

---@class QBBlipsCreateOptions
---@field sprite? integer
---@field color? integer
---@field scale? number
---@field name? string Location/name shown after GTA's native category heading.
---@field label? string Backwards-compatible explicit map-label override.
---@field shortRange? boolean
---@field category? integer|string Fixed category name/legacy alias or numeric native category. Defaults to Other.
---@field display? integer Native display mode restored after show. Defaults to Config.blips.defaultDisplay.
---@field route? boolean
---@field info? QBBlipInfo

---@class QBBlipCategory
---@field key string Canonical fixed category key/name, or `native:<id>` for a numeric compatibility category.
---@field name string Canonical category name, or `Category <id>` for a numeric compatibility category.
---@field label string Pause-map/UI category label.
---@field id integer Native SetBlipCategory id.
---@field visible boolean Player's persisted client visibility preference.
---@field count integer Number of currently registered kora_lib blips in the category.

---@class QBRegisteredBlip
---@field handle integer Actual native blip handle returned by Kora.blips.create.
---@field resource string Resource that created the blip.
---@field category integer Native category id.
---@field categoryKey string Canonical fixed category key/name, or `native:<id>` for a numeric compatibility category.
---@field name string Normalized location/name within the category.
---@field label string Location label passed to GTA, or an explicit legacy override.
---@field sprite integer
---@field color integer
---@field display integer Configured display mode restored after show.
---@field route boolean
---@field visible boolean Effective visibility after individual/category state.

---@class QBBlipInfoRow
---@field kind 'text'|'icon'|'name'|'header'|'wrappedText'
---@field label? string|number Left-hand text. Omit for a wrapped-text row.
---@field value? string|number Right-hand or wrapped text.
---@field icon? integer Icon id for an `icon` row.
---@field color? integer Icon color for an `icon` row.
---@field checked? boolean Whether an `icon` row is checked.

---@class QBBlipInfo
---@field title string
---@field verified? boolean Display the verified title mark.
---@field image? {dictionary: string, texture: string} Pause-menu texture dictionary and texture name.
---@field rp? string|number Optional RP title metadata.
---@field money? string|number Optional money title metadata.
---@field rows? QBBlipInfoRow[] Detail rows displayed below the title.

---@class QBControlsOptions
---@field inputGroup? integer
---@field disablePlayerFiring? boolean
---@field ignoreWeaponWheel? boolean

---@class QBControlLease
---@field inputGroup integer
---@field controls integer[]
---@field disablePlayerFiring boolean

---@class QBEntitiesCreateOptions
---@field preset? 'frozen'|'static'|'invincible'
---@field heading? number
---@field freeze? boolean
---@field blockNonTempEvents? boolean
---@field invincible? boolean

---@class QBEntitiesScopedOptions : QBEntitiesCreateOptions
---@field radius number Spawn radius in metres; must be greater than zero.

---@class QBScopedEntityHandle
---@field id integer Stable scoped-registration id.
---@field resource string Resource that created the scoped entity.
---@field entity? integer Current local entity handle, or nil while outside the scope.
---@field remove fun() Deletes the active entity and unregisters the scope.
---@field isSpawned fun(): boolean Whether the scope currently owns a live entity.

---@class QBAnimPlayOptions
---@field duration? integer
---@field flag? integer
---@field blendInSpeed? number
---@field blendOutSpeed? number
---@field playbackRate? number
---@field lockX? boolean
---@field lockY? boolean
---@field lockZ? boolean
---@field onFinish? fun(entity: integer)

---@class QBAnimHandle
---@field entity integer
---@field dict string
---@field clip string
---@field generation integer

---@class QBAnimAttachOptions
---@field softPin? boolean
---@field collision? boolean
---@field vertexIndex? integer
---@field fixedRot? boolean

---@class QBFxPtfxDef
---@field dict string
---@field name string
---@field bone? string
---@field entity? integer
---@field coords? QBCoords
---@field offset? QBCoords
---@field rot? QBCoords
---@field scale? number
---@field duration? integer
---@field looped? boolean

---@class QBFxPtfxHandle
---@field looped boolean
---@field particleId? integer

---@class QBFxScreenHandle
---@field id integer
---@field name string

---@class QBProgressBarDisable
---@field move? boolean
---@field moveMode? 'freeze'|'controls' Defaults to Config.progressbar.defaultMoveMode ('controls'); controls matches ox_lib movement blocking, freeze uses FreezeEntityPosition (skipped while airborne).
---@field controlProfile? 'kora_lib'|'ox' Exact disabled-control set; defaults to kora_lib.
---@field sprint? boolean
---@field combat? boolean
---@field car? boolean
---@field mouse? boolean

---@class QBProgressBarAnim
---@field dict string
---@field clip string
---@field flag? integer
---@field blendIn? number
---@field blendOut? number
---@field stopBlendOut? number Cleanup blend-out override for compatibility providers.
---@field duration? integer
---@field playbackRate? number
---@field lockX? boolean
---@field lockY? boolean
---@field lockZ? boolean

---@class QBProgressBarScenario
---@field name string
---@field playEnter? boolean

---@class QBProgressBarProp
---@field model string|integer
---@field bone? string|integer
---@field offset? QBCoords
---@field coords? QBCoords Legacy `prop`/`proptwo` attachment offset.
---@field rotation? QBCoords
---@field softPinning? boolean
---@field collision? boolean
---@field rotationOrder? integer
---@field syncRotation? boolean

---@class QBProgressBarPayload
---@field label string
---@field duration integer
---@field maxDuration? integer|false Override duration cap; false allows any positive duration.
---@field canCancel? boolean Enables cancellation with X or Escape (Config.progressbar.cancelControls).
---@field cancelControls? integer[]|false Override local cancel controls; false delegates cancellation to a compatibility command.
---@field useWhileDead? boolean
---@field allowRagdoll? boolean
---@field allowCuffed? boolean
---@field allowFalling? boolean
---@field allowSwimming? boolean
---@field presentation? 'bar'|'circle'
---@field position? 'middle'|'bottom'
---@field disable? QBProgressBarDisable
---@field anim? QBProgressBarAnim
---@field strictAnim? boolean Raise when the animation dictionary cannot load; used by strict compatibility providers.
---@field scenario? QBProgressBarScenario
---@field props? QBProgressBarProp[]
---@field prop? QBProgressBarProp
---@field proptwo? QBProgressBarProp
---@field emote? string
---@field maxProps? integer|false Override local prop cap; false allows all validated props.

---@class QBActionsResult
---@field token any
---@field completed boolean
---@field proof? string
---@field authorization? string

---@class QBActionsOptions
---@field begin fun(...: any): any, string?, string? Returns action token, optional failure reason, and optional minigame proof authorization.
---@field complete fun(result: QBActionsResult, ...: any): any
---@field label string
---@field duration? integer
---@field minigame? QBMinigameType
---@field canCancel? boolean
---@field disable? QBProgressBarDisable
---@field anim? QBProgressBarAnim

---@class QBNotifyPayload
---@field title? string
---@field message? string At least one of title or message is required.
---@field type? 'success'|'error'|'warning'|'info'
---@field duration? integer
---@field position? 'top-left'|'top-center'|'top-right'|'bottom-left'|'bottom-center'|'bottom-right'|'center-left'|'center-right'|'top'|'bottom'
---@field icon? string
---@field id? string|number Replaces an existing toast with the same id.
---@field iconColor? string CSS icon colour.
---@field iconAnimation? 'spin'|'spinPulse'|'spinReverse'|'pulse'|'beat'|'fade'|'beatFade'|'bounce'|'shake'
---@field alignIcon? 'top'|'center'
---@field style? table<string, any> Trusted scalar root styles and vetted title/description child styles.
---@field showDuration? boolean Set false to hide the lifetime indicator.

---@class QBDrawingTextOptions
---@field font? integer
---@field scale? number
---@field color? {r: integer, g: integer, b: integer, a: integer}
---@field maxDistance? number
---@field outline? boolean

---@class QBMenuItem
---@field id string
---@field label string
---@field description? string
---@field icon? string
---@field image? string
---@field disabled? boolean
---@field values? (string|{label: string, description?: string})[] Side-scroll values.
---@field defaultIndex? integer One-based selected value.
---@field checked? boolean Render as a checkable row.
---@field progress? number Progress from 0 through 100.
---@field colorScheme? string Progress colour.
---@field iconColor? string Icon CSS colour.
---@field iconAnimation? 'spin'|'spinPulse'|'spinReverse'|'pulse'|'beat'|'fade'|'beatFade'|'bounce'|'shake'
---@field iconWidth? number Percentage width used by radial icons.
---@field iconHeight? number Percentage height used by radial icons.
---@field readOnly? boolean Keep an informational row non-interactive.
---@field arrow? boolean Show or suppress a navigation affordance.
---@field metadata? (string|{label: string, value?: any, progress?: number, colorScheme?: string})[]
---@field close? boolean Keep the menu open after confirmation when false.
---@field submenu? {title?: string, items: QBMenuItem[]}

---@class QBMenuResult
---@field selectedId? string
---@field path? string[]
---@field valueIndex? integer One-based selected side-scroll value.
---@field checked? boolean Current checked state.
---@field cancelled? boolean
---@field keyPressed? 'Escape'|'Backspace' Root-level dismissal key.

---@class QBRadialMenuOptions
---@field radius? number

---@class QBAlertOptions
---@field message string
---@field title? string
---@field image? string
---@field confirmLabel? string
---@field cancelLabel? string
---@field cancellable? boolean
---@field showCancel? boolean Show the Cancel button independently of Escape dismissal.
---@field showClose? boolean Show the corner close control.
---@field dismissOnBackdrop? boolean Allow backdrop dismissal.
---@field destructive? boolean
---@field centered? boolean
---@field size? 'xs'|'sm'|'md'|'lg'|'xl'
---@field overflow? boolean

---@class QBAlertResult
---@field confirmed boolean

---@alias QBInputType 'text'|'password'|'textarea'|'number'|'checkbox'|'select'|'multiselect'|'range'|'combobox'|'date'|'date-range'|'time'|'color'
---@class QBInputOption
---@field value string|number
---@field label string
---@field disabled? boolean

---@class QBInputField
---@field id string
---@field label string
---@field type QBInputType
---@field description? string
---@field placeholder? string
---@field default? any
---@field required? boolean
---@field disabled? boolean
---@field min? number
---@field max? number
---@field minLength? integer
---@field maxLength? integer
---@field pattern? string
---@field dateMin? string|number Minimum date/date-range constraint accepted by `Date`.
---@field dateMax? string|number Maximum date/date-range constraint accepted by `Date`.
---@field returnString? boolean Keep date values as ISO strings; false returns local epoch milliseconds.
---@field dateFormat? string Date output pattern when returnString is true.
---@field precision? integer Number decimal precision.
---@field colorFormat? 'hex'|'hexa'|'rgb'|'rgba'|'hsl'|'hsla'
---@field timeFormat? '12'|'24'
---@field clearable? boolean
---@field searchable? boolean
---@field maxSelectedValues? integer
---@field autosize? boolean
---@field minRows? integer
---@field maxRows? integer
---@field icon? string
---@field iconColor? string
---@field step? number Number/range increment; defaults to 1.
---@field copyButton? boolean|{label?: string} text fields only: show a "Copy Text" button right of the input.
---@field keypad? boolean Render a compact numeric keypad for textual PIN entry.
---@field numericOnly? boolean Strip non-digit input in the browser.
---@field presets? {label?: string, value: number}[] Quick amount values.
---@field rows? integer
---@field options? QBInputOption[]
---@field optionsByValue? table<string, QBInputOption[]> Select options keyed by dependsOn's selected value.
---@field dependsOn? string Id of the select field that controls optionsByValue.
---@field visibleWhen? {fieldId: string, equals: string|number|boolean} Render only when another field equals this value.

---@class QBInputResult
---@field values? table<string, any>
---@field cancelled? boolean

---@alias QBAppTone 'neutral'|'primary'|'success'|'warning'|'destructive'
---@alias QBAppActionVariant 'primary'|'secondary'|'outline'|'ghost'|'destructive'

---@class QBAppAction
---@field id string
---@field label string
---@field icon? string
---@field variant? QBAppActionVariant
---@field state? boolean Current boolean state for a toggle action, rendered as an On/Off indicator.
---@field disabled? boolean
---@field data? any
---@field fields? QBInputField[] Fields collected inline by AppShell before this action runs.
---@field confirm? string Acknowledgement shown before submitting this action.
---@field closeBeforeAction? boolean Close and release AppShell before invoking the action handler.
---@field hold? boolean Press-and-hold button: onAction runs with context.hold = 'start' on press and 'end' on release (also when the app closes mid-hold); no click is sent.

---@class QBAppStat
---@field label string
---@field value string|number
---@field description? string
---@field icon? string
---@field tone? QBAppTone

---@class QBAppProgressItem
---@field label string
---@field value number Current value, from zero through max.
---@field max number Positive maximum value.
---@field description? string
---@field detail? string Secondary value copy, for example "1,240 / 2,000 XP".
---@field icon? string
---@field tone? QBAppTone

---@class QBAppTableColumn
---@field key string
---@field label string
---@field align? 'left'|'center'|'right'
---@field sortable? boolean

---@class QBAppRichValue
---@field value? string|number|boolean
---@field label? string
---@field description? string
---@field icon? string
---@field tone? QBAppTone
---@field badge? boolean

---@alias QBAppTableValue string|number|boolean|QBAppRichValue

---@class QBAppMetadataItem
---@field label string
---@field value string|number|boolean
---@field tone? QBAppTone

---@alias QBAppImageAspect 'square'|'wide'
---@alias QBAppImageFit 'cover'|'contain'|'fill'|'none'|'scale-down'

---@class QBAppListItem
---@field id string
---@field label string
---@field description? string
---@field icon? string
---@field badge? string|number
---@field tone? QBAppTone
---@field action? string|QBAppAction Action routed to the registered onAction handler.
---@field data? any
---@field image? string
---@field imageFit? QBAppImageFit Overrides the list block image fit.
---@field imageAspect? QBAppImageAspect Overrides the list block image aspect.
---@field metadata? QBAppMetadataItem[]
---@field actions? QBAppAction[]
---@field children? QBAppListItem[]

---@class QBAppDetailItem
---@field label string
---@field value? string|number|boolean
---@field description? string
---@field icon? string
---@field tone? QBAppTone

---@class QBAppTimelineItem
---@field id string
---@field title string
---@field description? string
---@field timestamp? string
---@field icon? string
---@field tone? QBAppTone
---@field metadata? QBAppMetadataItem[]
---@field actions? QBAppAction[]

---@class QBAppPoint
---@field x number
---@field y number

---@class QBAppMapCalibrationPoint
---@field world QBAppPoint
---@field image QBAppPoint

---@class QBAppMapTiles
---@field url string URL template containing {z}, {x}, and {y}; cross-resource cfx-nui URLs are supported.
---@field tileSize? number Defaults to 256.
---@field grid? QBAppPoint Tile counts at maxZoom.
---@field calibration? {a: QBAppMapCalibrationPoint, b: QBAppMapCalibrationPoint} Two-point world-to-image calibration.

---@class QBAppMapMarker: QBAppPoint
---@field id string
---@field label string
---@field description? string
---@field heading? number
---@field tone? QBAppTone
---@field icon? string
---@field action? string
---@field data? any
---@field expiresAt? number
---@field fadeDuration? number Marker-specific fade window before expiresAt; overrides the block default.

---@alias QBAppBlockType 'text'|'stats'|'progress'|'table'|'list'|'actions'|'form'|'details'|'timeline'|'map'|'empty'|'chat'

---@class QBAppBlock
---@field type QBAppBlockType
---@field title? string
---@field text? string Text block body.
---@field description? string Form or empty-state description.
---@field icon? string Empty-state icon.
---@field items? QBAppStat[]|QBAppProgressItem[]|QBAppListItem[]|QBAppDetailItem[]|QBAppTimelineItem[] Block items.
---@field actions? QBAppAction[] Action-block buttons.
---@field columns? QBAppTableColumn[]|integer Table columns, 1-3 details columns, or 1-4 maximum list grid columns.
---@field rows? table<string, QBAppTableValue>[] Table rows.
---@field empty? string Empty list/table label.
---@field action? string|QBAppAction Table/map action id, or the always-visible form action.
---@field idKey? string Table row key copied into action context.itemId.
---@field id? string Stable block identity used for drafts and local collection state.
---@field layout? 'list'|'grid'|'cards' List presentation.
---@field cardStyle? 'compact'|'media' Grid/card presentation; compact is the default, media uses a full-width image above the content.
---@field imageFit? QBAppImageFit List image fit; defaults to cover, individual items may override it.
---@field imageAspect? QBAppImageAspect List thumbnail shape; defaults to 'square', 'wide' shows a 16:9 thumbnail (compact list/grid rows only), individual items may override it.
---@field searchable? boolean Enable client-side filtering.
---@field searchPlaceholder? string
---@field pageSize? integer Enable client-side paging when positive.
---@field scrollable? boolean Let a list block own vertical overflow inside fixed content.
---@field fields? QBInputField[] Always-visible form fields.
---@field submitLabel? string Always-visible form submit label.
---@field tiles? QBAppMapTiles Map tile URL/projection definition.
---@field markers? QBAppMapMarker[] Map markers.
---@field selectedId? string Selected map marker.
---@field minZoom? number
---@field maxZoom? number
---@field initialZoom? number
---@field follow? boolean
---@field captureWheel? boolean Mouse wheel zooms the map and does not scroll the page behind it. Default true.
---@field recenter? QBAppPoint
---@field now? number
---@field fadeDuration? number
---@field messages? QBAppChatMessage[] Chat block messages, oldest first.
---@field composer? QBAppChatComposer Chat block message box; omit for a read-only conversation.

---@class QBAppChatMessage
---@field id string Stable message id (used for scroll and unread tracking).
---@field author string
---@field text string Rendered as plain text, never HTML.
---@field timestamp? string
---@field mine? boolean Right-aligned bubble for the viewer's own messages.
---@field unread? boolean A "New" divider is drawn before the first unread message.
---@field badge? string Small label next to the author (for example 'Staff').
---@field tone? QBAppTone

---@class QBAppChatComposer
---@field action QBAppAction Plain action; onAction gets context.value = { message = string }.
---@field placeholder? string
---@field maxLength? integer
---@field disabled? boolean
---@field note? string Shown instead of the input when disabled (for example 'This report is closed.').

---@class QBAppContent
---@field title? string
---@field description? string
---@field actions? QBAppAction[]
---@field blocks? QBAppBlock[]
---@field scrollable? boolean Set false to keep the content frame fixed.

---@class QBAppTab
---@field id string
---@field label string
---@field badge? string|number
---@field content? QBAppContent

---@class QBAppNavigationItem
---@field id string
---@field label string
---@field description? string
---@field icon? string
---@field badge? string|number
---@field group? string
---@field disabled? boolean
---@field defaultTab? string
---@field tabs? QBAppTab[]
---@field content? QBAppContent

---@class QBAppDefinition
---@field id string Namespaced stable id.
---@field title string
---@field description? string
---@field icon? string
---@field navigation QBAppNavigationItem[]
---@field layout? 'standard'|'compact'
---@field defaultView? string
---@field width? number Pixels; clamped to 720-1600 in standard layout and 420-1600 in compact layout.
---@field height? number Pixels; clamped to 420-960.
---@field footer? string
---@field draggable? boolean The header is a drag handle; the panel is clamped to the screen and double-clicking the header resets it. Defaults to Config.ui.apps.draggableDefault (false).
---@field rememberPosition? boolean Remember the dragged position per player in NUI localStorage (draggable apps only).
---@field positionKey? string Storage key suffix for the remembered position; defaults to the app id.
---@field accent? string #RRGGBB primary colour applied while this app is open; omitted apps retain the player's /theme colour.
---@field onAction? fun(actionId: string, context: QBAppActionContext): QBAppActionResult?
---@field onChange? fun(actionId: string, context: QBAppActionContext): table? Receives form drafts; returns a partial definition update without submitting.

---@class QBAppOpenOptions
---@field data? any Private session data supplied back to onAction/onChange; not rendered.
---@field viewId? string
---@field tabId? string

---@class QBAppActionContext
---@field appId string
---@field viewId? string
---@field tabId? string
---@field itemId? string
---@field value? any
---@field data? any The data supplied to openApp.
---@field hold? 'start'|'end' Set only for `hold = true` actions; the handler's return value is ignored.

---@class QBAppActionResult
---@field update? table Partial QBAppDefinition to merge and render immediately.
---@field close? boolean Close the app after the action.
---@field navigate? {viewId: string, tabId?: string, replace?: boolean} Navigate without rebuilding the definition.
---@field notice? {tone: QBAppTone, message: string} Show an in-shell notice (or a notification when the action closes AppShell).

---@class QBAppResult
---@field closed boolean
---@field reason string
---@field viewId? string
---@field tabId? string

---@class QBInteractOption
---@field label string
---@field icon? string
---@field action? fun()
---@field event? string
---@field type? 'client'|'server'
---@field args? any[]
---@field canInteract? fun(): boolean
---@field job? string|string[]|table<string, integer>
---@field gang? string|string[]|table<string, integer>
---@field citizenid? string|string[]|table<string, boolean>
---@field item? string|string[]
---@field distance? number

---@class QBInteractTargetOptions
---@field options QBInteractOption[]
---@field distance? number

---@class QBInteractSize
---@field x number
---@field y number
---@field z number

---@class QBZoneCommonOptions
---@field debug? boolean
---@field data? any Arbitrary caller-owned passthrough.
---@field onEnter? fun(zone: QBZoneHandle)
---@field onExit? fun(zone: QBZoneHandle)
---@field inside? fun(zone: QBZoneHandle, coords: QBCoords)
---@field trackPlayer? boolean Set false for predicate-only zones that use contains() but do not need enter/exit tracking.

---@class QBZoneBoxOptions : QBZoneCommonOptions
---@field coords QBCoords
---@field size QBInteractSize|QBCoords
---@field rotation? number Degrees around the Z axis.
---@field ignoreZ? boolean Ignore the box Z extent. Defaults false.

---@class QBZoneSphereOptions : QBZoneCommonOptions
---@field coords QBCoords
---@field radius number
---@field includeBoundary? boolean Defaults true.

---@class QBZoneCircleOptions : QBZoneSphereOptions

---@class QBZonePointOptions : QBZoneCommonOptions
---@field coords QBCoords
---@field radius? number Defaults to Config.zones.defaultPointRadius.
---@field includeBoundary? boolean Defaults true.

---@class QBZonePolyOptions : QBZoneCommonOptions
---@field points QBCoords[]
---@field thickness? number
---@field minZ? number Poly floor; must be supplied with maxZ.
---@field maxZ? number Poly ceiling; must be supplied with minZ.
---@field ignoreZ? boolean Ignore the poly height band. Defaults false.

---@alias QBZoneOptions QBZoneBoxOptions|QBZoneSphereOptions|QBZoneCircleOptions|QBZonePointOptions|QBZonePolyOptions
---@alias QBZoneCreatorOptions QBZoneBoxOptions|QBZoneSphereOptions|QBZonePolyOptions

---@class QBZoneHandle
---@field id integer
---@field type 'box'|'sphere'|'circle'|'poly'
---@field resource string
---@field data any Caller-supplied opts.data value.
---@field remove fun(): boolean
---@field contains fun(coords: QBCoords): boolean
---@field isInside fun(): boolean
---@field setDebug fun(enabled: boolean): boolean

---@class QBZoneCreatorResult
---@field type 'box'|'sphere'|'poly'
---@field opts QBZoneCreatorOptions

---@class QBRewardItem
---@field chance? number
---@field amount? number|{min: number, max: number}

---@class QBRewardOptions
---@field mode? 'weighted'|'percent'
---@field rolls? integer
---@field allowNone? boolean

---@alias QBMinigameType 'lockpick'|'skillbar'|'circuit'|'mash'|'fishing'|'pinpad'|'quiz'|'wordguess'|'wordscramble'|'keys'|'hacking'
---@class QBMinigameOptions
---@field duration? integer
---@field difficulty? number|string
---@field rounds? integer
---@field [string] any Game-specific fields are documented in modules/minigames/docs.md.

---@class QBMinigameResult
---@field success boolean
---@field attempts integer
---@field proof? string
---@field cancelled? true
---@field faults? integer
---@field reason? string

---@class QBStatusEffectDef
---@field duration? integer
---@field stacking? 'replace'|'extend'|'stack'
---@field severityLevels? integer
---@field fx? {screen?: string, ptfx?: QBFxPtfxDef}
---@field anim? {dict: string, clip: string}
---@field movement? {speedMultiplier?: number}

---@class QBStatusApplyOptions
---@field duration? integer
---@field severity? integer

---@class QBStatusActiveEntry
---@field name string
---@field severity? integer
---@field expiresAt? integer

---@class QBDiscordResponse
---@field status integer
---@field body? string
---@field headers? table<string, string>
---@field data? any
---@field error? string

---@alias QBDiscordCallback fun(ok: boolean, response: QBDiscordResponse)

---@class QBDiscordEmbedField
---@field name string
---@field value string
---@field inline? boolean

---@class QBDiscordEmbedOptions
---@field title? string
---@field description? string
---@field url? string
---@field color? integer|string
---@field timestamp? boolean|integer|string
---@field footer? string|{text: string, icon_url?: string}
---@field author? string|{name: string, url?: string, icon_url?: string}
---@field image? string|{url: string}
---@field thumbnail? string|{url: string}
---@field fields? QBDiscordEmbedField[]

---@class QBStreamResult
---@field [integer] any

---@alias QBLookupNamespace 'vehicle'|'ped'|'object'|'weapon'|'weapon_component'|'pickup'
---@alias QBLookupModelNamespace 'vehicle'|'ped'|'object'
---@alias QBLookupFailure 'catalog_pending'|'not_found'|'ambiguous'
---@alias QBLookupSource 'base'|'custom'|'base+custom'

---@class QBLookupMetadata
---@field class? string Vehicle class.
---@field manufacturer? string Vehicle manufacturer key.
---@field type? string Vehicle type.
---@field seats? integer Vehicle seat count.
---@field pedType? string Ped type.
---@field modelName? string Weapon or pickup model name.
---@field damageType? string Weapon damage type.
---@field weaponNames? string[] Weapons that own a component.
---@field componentType? string Weapon-component type.
---@field attachBone? string Weapon-component attachment bone.

---@class QBLookupRecord
---@field namespace QBLookupNamespace
---@field hash integer Unsigned 32-bit hash.
---@field signedHash integer Signed 32-bit representation.
---@field hexHash string Eight-digit hexadecimal representation.
---@field name string Canonical spawn/archetype/hash-key name.
---@field label? string English display label.
---@field labelKey? string GXT label key.
---@field category? string
---@field dlc? string
---@field source QBLookupSource
---@field resources? string[] Sorted custom resources contributing this entry.
---@field metadata? QBLookupMetadata Namespace-specific curated metadata.

---@class KoraLibCompat
---@field provideExport fun(providedResource: string, exportName: string, func: function|table) [shared]

---@class kora_lib
---@field actions KoraLibActions
---@field anim KoraLibAnim
---@field blips KoraLibBlips
---@field camera KoraLibCamera
---@field cache KoraLibCache
---@field callback KoraLibCallback
---@field compat KoraLibCompat
---@field closest KoraLibClosest
---@field commands KoraLibCommands
---@field config KoraLibConfig
---@field controls KoraLibControls
---@field discord KoraLibDiscord
---@field distance KoraLibDistance
---@field drawing KoraLibDrawing
---@field entities KoraLibEntities
---@field freecam KoraLibFreecam
---@field events KoraLibEvents
---@field fx KoraLibFx
---@field interact KoraLibInteract
---@field instructional KoraLibInstructional
---@field keybind KoraLibKeybind
---@field logging KoraLibLogging
---@field lookup KoraLibLookup
---@field loops KoraLibLoops
---@field minigames KoraLibMinigames
---@field notify KoraLibNotify
---@field nui KoraLibNui
---@field ox KoraLibOx Private provider for the optional ox_lib bridge; native resources should use Kora.nui.
---@field permissions KoraLibPermissions
---@field placement KoraLibPlacement
---@field print KoraLibPrint
---@field progressbar KoraLibProgressbar
---@field raycast KoraLibRaycast
---@field random KoraLibRandom
---@field require KoraLibRequire
---@field resources KoraLibResources
---@field rewards KoraLibRewards
---@field screenshot KoraLibScreenshot
---@field sound KoraLibSound
---@field skills KoraLibSkills
---@field state KoraLibState
---@field status KoraLibStatus
---@field stream KoraLibStream
---@field teleport KoraLibTeleport
---@field textui KoraLibTextUI
---@field theme KoraLibTheme
---@field timers KoraLibTimers
---@field util KoraLibUtil
---@field vehicle KoraLibVehicle
---@field visuals KoraLibVisuals
---@field world KoraLibWorld
---@field zones KoraLibZones
---@field lang fun(key: string, ...: any): string [shared]
---@field locale KoraLibLocale

---@class KoraLibLocale
---@field getLanguage fun(): string [shared]
---@field getLanguages fun(): string[] [shared]
---@field translate fun(resource: string, key: string, ...: any): any [shared]

---@class KoraLibActions

---@class KoraLibAnim

---@class KoraLibBlips
---@field getCategoryIds fun(): table<string, integer> [shared]
---@field hideCategory fun(category: string|integer): boolean [client; returns whether preference changed]
---@field showCategory fun(category: string|integer): boolean [client; returns whether preference changed]

---@class QBCameraDefinition
---@field label? string
---@field location? string
---@field coords QBCoords Camera position.
---@field target? QBCoords Point the lens at this world position.
---@field rotation? QBCoords Camera rotation in degrees.
---@field fov? number

---@class QBCameraOptions
---@field mode? 'cctv'|'recording'|'helicam'|'operator'
---@field title? string
---@field subtitle? string
---@field cameraLabel? string
---@field cameras? QBCameraDefinition[]
---@field camera? QBCameraDefinition
---@field recording? boolean
---@field controls? boolean
---@field timestamp? boolean
---@field viewMode? integer GTA follow-camera mode to restore on close.

---@class KoraLibCamera

---@class QBConfigFieldOptions
---@field label? string
---@field description? string
---@field scope? 'shared'|'client'|'server'
---@field live? boolean
---@field min? number
---@field max? number
---@field step? number
---@field minLength? integer
---@field maxLength? integer
---@field pattern? string
---@field options? table[]
---@field sensitive? boolean Excluded from kora_lib's in-game editor.

---@class KoraLibConfig
---@field define fun(values: table, options?: {scope?: 'shared'|'client'|'server', fileName?: string}): table [shared; consumer-local]
---@field adopt fun(values: table, options?: {scope?: 'shared'|'client'|'server', fileName?: string}): table [shared; consumer-local]
---@field extend fun(values: table, options?: {scope?: 'shared'|'client'|'server'}): table [shared; consumer-local]
---@field onChange fun(path: string, handler: fun(value: any, previous: any): boolean?|nil) [client/server; consumer-local]
---@field boolean fun(value: boolean, options?: QBConfigFieldOptions): table [shared]
---@field string fun(value: string, options?: QBConfigFieldOptions): table [shared]
---@field integer fun(value: integer, options?: QBConfigFieldOptions): table [shared]
---@field number fun(value: number, options?: QBConfigFieldOptions): table [shared]
---@field enum fun(value: string|number, options: QBConfigFieldOptions): table [shared]
---@field color fun(value: string, options?: QBConfigFieldOptions): table [shared]
---@field vector2 fun(value: any, options?: QBConfigFieldOptions): table [shared]
---@field vector3 fun(value: any, options?: QBConfigFieldOptions): table [shared]
---@field vector4 fun(value: any, options?: QBConfigFieldOptions): table [shared]
---@field object fun(value: table, options?: QBConfigFieldOptions): table [shared]
---@field list fun(value: table, item?: table, options?: QBConfigFieldOptions): table [shared]
---@field map fun(value: table, item?: table, options?: QBConfigFieldOptions): table [shared]
---@field optional fun(value: any, inner: table, options?: QBConfigFieldOptions): table [shared]
---@field get fun(resource?: string, path?: string|string[]): any, string? [client/server; consumer-local]
---@field bind fun(resource: string, path: string|string[]|nil, handler: fun(value: any, previous: any, change: table)): fun() [client/server; consumer-local]
---@field whenReady fun(resources: string[], handler: fun()) [client/server; consumer-local]
---@field onValidate fun(handler: fun(proposed: table, previous: table, path: string[]): boolean?, string?) [server; consumer-local]
---@field onApply fun(handler: fun(configured: table, active: table, path: string[]): boolean?) [server; consumer-local]
---@field register fun(definition: table): boolean [server; kora_lib internal]
---@field catalog fun(): table[] [server]
---@field read fun(resource: string): table|nil [server]
---@field commit fun(resource: string, request: table): table [server]
---@field reset fun(resource: string, request: table): table [server]

---@class KoraLibCache

---@class KoraLibCallback
---@field assertName fun(name: string) [shared]
---@field register fun(name: string, handler: fun(...: any): any, opts?: QBRegistrationOptions) [client/server; opts is server client-to-server only]
---@field unregister fun(name: string): boolean [client/server]
---@field trigger fun(targetOrName: integer|string, nameOrArg?: any, ...: any): any [client: name,...; server: target,name,...]

---@class KoraLibClosest
---@field player fun(srcOrCoords: integer|QBCoords, coordsOrDistance?: QBCoords|number, distance?: number): {id: integer?, distance: number?} [client/server]
---@field vehicle fun(srcOrCoords: integer|QBCoords, coordsOrDistance?: QBCoords|number, distance?: number): {id: integer?, distance: number?} [client/server]
---@field ped fun(srcOrCoords: integer|QBCoords, coordsOrDistance?: QBCoords|number, distance?: number): {id: integer?, distance: number?} [client/server]
---@field object fun(srcOrCoords: integer|QBCoords, coordsOrDistance?: QBCoords|number, distance?: number): {id: integer?, distance: number?} [client/server]

---@class KoraLibCommands
---@field add fun(name: string, help: string, args: QBCommandArgument[]?, argsRequired: boolean?, handler: fun(source: integer, args: string[], raw: string), opts?: QBCommandOptions) [server]
---@field remove fun(name: string) [server]
---@field refresh fun(src: integer) [server]
---@field list fun(): QBCommandInfo[] [server]
---@field suggest fun(src: integer, name: string, argumentIndex: integer, query?: string, parsedArgs?: string[]): QBCommandSuggestion[] [server]

---@class KoraLibControls

---@class KoraLibDiscord
---@field createEmbed fun(options: QBDiscordEmbedOptions): table [server]
---@field sendWebhook fun(url: string?, payload: string|table, callback?: QBDiscordCallback): boolean [server]
---@field botEnabled fun(): boolean [server]
---@field botRequest fun(method: string, route: string, payload?: table, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field getGuild fun(guildId: string, callback?: QBDiscordCallback): boolean [server]
---@field getMember fun(guildId: string, userId: string, callback?: QBDiscordCallback): boolean [server]
---@field updateMember fun(guildId: string, userId: string, attributes: table, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field fetchGuildRoles fun(guildId: string, callback?: QBDiscordCallback): boolean [server]
---@field setMemberRoles fun(guildId: string, userId: string, roleIds: string[], callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field addMemberRole fun(guildId: string, userId: string, roleId: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field removeMemberRole fun(guildId: string, userId: string, roleId: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field createRole fun(guildId: string, role: table, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field updateRole fun(guildId: string, roleId: string, role: table, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field deleteRole fun(guildId: string, roleId: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field getChannels fun(guildId: string, callback?: QBDiscordCallback): boolean [server]
---@field getChannel fun(channelId: string, callback?: QBDiscordCallback): boolean [server]
---@field createChannel fun(guildId: string, channel: table, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field updateChannel fun(channelId: string, attributes: table, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field deleteChannel fun(channelId: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field sendMessage fun(channelId: string, payload: string|table, callback?: QBDiscordCallback): boolean [server]
---@field editMessage fun(channelId: string, messageId: string, payload: string|table, callback?: QBDiscordCallback): boolean [server]
---@field deleteMessage fun(channelId: string, messageId: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field getGuildRoles fun(guildId?: string): table<string, table> [server]
---@field getRole fun(role: string, guildId?: string): table? [server]
---@field refreshMember fun(id: integer|string, callback?: fun(ok: boolean, roles: string[]|string)): boolean [server]
---@field getRoles fun(id: integer|string): string[] [server]
---@field hasRole fun(id: integer|string, role: string): boolean [server]
---@field hasRoles fun(id: integer|string, roles: string[], requireAll?: boolean): boolean [server]
---@field hasAnyRole fun(id: integer|string, roles: string[]): boolean [server]
---@field hasAllRoles fun(id: integer|string, roles: string[]): boolean [server]
---@field giveRole fun(id: integer|string, role: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field removeRole fun(id: integer|string, role: string, callback?: QBDiscordCallback, auditReason?: string): boolean [server]
---@field syncRoles fun(callback?: fun(ok: boolean, result: any)): boolean [server]

---@class KoraLibDistance
---@field player fun(srcOrCoords: integer|QBCoords, coordsOrDistance?: QBCoords|number, distance?: number): boolean [client/server]
---@field playerNearAny fun(src: integer, list: any[], opts: {radius?: number, coordsOf: fun(entry: any): QBCoords}): boolean, any [server]
---@field coords fun(coords1: QBCoords, coords2: QBCoords, distance: number): boolean [client/server]
---@field entity fun(srcOrEntity: integer, entityOrDistance: integer|number, distance?: number): boolean [client/server]
---@field x fun(srcOrPoint: integer|QBCoords, pointOrDistance: QBCoords|number, distance?: number): boolean [client/server]
---@field y fun(srcOrPoint: integer|QBCoords, pointOrDistance: QBCoords|number, distance?: number): boolean [client/server]
---@field xy fun(srcOrPoint: integer|QBCoords, pointOrDistance: QBCoords|number, distance?: number): boolean [client/server]

---@class KoraLibDrawing

---@class KoraLibEntities
---@field createVehicle fun(model: string|integer, coords: QBCoords, vehicleType?: QBServerVehicleType): integer|false, string? [server]

---@class KoraLibEvents
---@field assertName fun(name: string) [shared]
---@field register fun(name: string, handler: fun(src: integer, ...: any), opts?: QBRegistrationOptions) [server]
---@field unregister fun(name: string): boolean [server]
---@field push fun(target: integer, name: string, ...: any) [server]

---@class KoraLibFx

---@class KoraLibInteract

---@class KoraLibKeybind

---@class KoraLibLogging
---@field event fun(category: string, src: integer, data?: table) [server]
---@field getStats fun(): table [server]

---@class KoraLibLookup
---@field get fun(namespace: QBLookupNamespace, value: integer|string): QBLookupRecord?, QBLookupFailure?, QBLookupRecord[]? [shared]
---@field model fun(value: integer|string, kind?: QBLookupModelNamespace): QBLookupRecord?, QBLookupFailure?, QBLookupRecord[]? [shared]
---@field weapon fun(value: integer|string): QBLookupRecord?, QBLookupFailure?, QBLookupRecord[]? [shared]
---@field weaponComponent fun(value: integer|string): QBLookupRecord?, QBLookupFailure?, QBLookupRecord[]? [shared]
---@field pickup fun(value: integer|string): QBLookupRecord?, QBLookupFailure?, QBLookupRecord[]? [shared]
---@field preload fun(namespaces?: QBLookupNamespace|QBLookupNamespace[]): boolean [shared]
---@field ready fun(): boolean [shared]
---@field awaitReady fun(timeout?: integer): boolean, string? [shared]

---@class KoraLibLoops
---@field controlled fun(call: fun(): any, tries?: integer|false, timeout?: integer|false, backoff?: boolean|integer): any, string? [shared]

---@class KoraLibMinigames
---@field play fun(gameType: QBMinigameType, opts?: QBMinigameOptions, authorization?: string, owner?: string): QBMinigameResult [client; waits for the round to finish]
---@field playAsync fun(gameType: QBMinigameType, opts?: QBMinigameOptions, authorization?: string, owner?: string): promise [client; internal composition primitive]
---@field playSkillCheck fun(skill: string, gameType: QBMinigameType, opts?: QBMinigameOptions, authorization?: string): QBMinigameResult [client; waits for the round to finish]
---@field authorizeProof fun(src: integer, gameType: QBMinigameType, trustedOpts?: QBMinigameOptions): string [server]
---@field authorizeSkillCheck fun(src: integer, skill: string, gameType: QBMinigameType, trustedOpts?: QBMinigameOptions): string [server]
---@field consumeProof fun(src: integer, token: string, gameType: QBMinigameType, authorization: string): boolean [server]
---@field triangleWave fun(elapsedMs: number, speedHz: number): number [shared]

---@class KoraLibNotify
---@field send fun(payloadOrSource: QBNotifyPayload|integer, payload?: QBNotifyPayload) [client/server]
---@field sendToAll fun(payload: QBNotifyPayload) [server]
---@field assert fun(payload: QBNotifyPayload) [shared]
---@field withDefaults fun(payload: QBNotifyPayload): QBNotifyPayload [shared]
---@field normalizeType fun(notifyType: any): any [shared]
---@field normalize fun(payload: QBNotifyPayload): QBNotifyPayload [shared]

---@class QBMenuPosition
---@field horizontal? 'left'|'center'|'right'
---@field vertical? 'top'|'center'|'bottom'
---@field offsetX? positive integer Pixels from the selected horizontal edge.
---@field offsetY? positive integer Pixels from the selected vertical edge.

---@class QBMenuOptions
---@field position? QBMenuPosition
---@field maxWidth? positive integer Pixels.
---@field maxHeight? positive integer Pixels.
---@field canClose? boolean Set false to prevent Escape/backdrop dismissal.
---@field startIndex? positive integer Initially selected one-based row.
---@field presentation? 'dialog'|'panel' Panel is compact and non-modal.

---@class KoraLibNui
---@field acquireFocus fun(mouse: boolean, keyboard: boolean, keepInput?: boolean, owner?: string): function [client; internal composition primitive]
---@field releaseFocus fun(release: function) [client; internal composition primitive]
---@field requestAsync fun(action: string, data?: any, timeout?: integer|false, owner?: string, focused?: boolean, onEvent?: fun(event: string, data: any)): promise [client; internal composition primitive]
---@field cancelRequest fun(request: promise, result?: any, rejection?: string): boolean [client; internal composition primitive]
---@field updateRequest fun(request: promise, action: string, data: any): boolean [client; internal composition primitive]
---@field copyToClipboard fun(text: string): promise|boolean [client] true when copied, false on failure

---@class KoraLibOx
---@field alertDialog fun(data: table, timeout: integer|false|nil, owner: string): 'confirm'|'cancel'|nil [client; ox_lib provider]
---@field closeAlertDialog fun(reason: string|nil, owner: string) [client; ox_lib provider]
---@field setClipboard fun(value: string, owner: string) [client; ox_lib provider]
---@field registerContext fun(context: table|table[], owner: string) [client; ox_lib provider]
---@field showContext fun(id: string, owner: string) [client; ox_lib provider]
---@field getOpenContextMenu fun(owner: string): string? [client; ox_lib provider]
---@field hideContext fun(onExit: boolean|nil, owner: string) [client; ox_lib provider]
---@field inputDialog fun(heading: string, rows: table[], options: table|nil, owner: string): any[]? [client; ox_lib provider]
---@field closeInputDialog fun(owner: string) [client; ox_lib provider]
---@field setNuiFocus fun(allowInput: boolean|nil, disableCursor: boolean|nil, owner: string) [client; ox_lib provider]
---@field resetNuiFocus fun(owner: string) [client; ox_lib provider]
---@field registerMenu fun(data: table, callback: function|nil, owner: string) [client; ox_lib provider]
---@field showMenu fun(id: string, startIndex: integer|nil, owner: string) [client; ox_lib provider]
---@field hideMenu fun(onExit: boolean|nil, owner: string) [client; ox_lib provider]
---@field setMenuOptions fun(id: string, options: table, index: integer|nil, owner: string) [client; ox_lib provider]
---@field getOpenMenu fun(owner: string): string? [client; ox_lib provider]
---@field notify fun(data: table, owner: string) [client; ox_lib provider]
---@field defaultNotify fun(data: table, owner: string) [client; ox_lib provider]
---@field progressBar fun(data: table, owner: string): boolean [client; ox_lib provider]
---@field progressCircle fun(data: table, owner: string): boolean [client; ox_lib provider]
---@field cancelProgress fun(owner: string) [client; ox_lib provider]
---@field progressActive fun(owner: string): boolean [client; ox_lib provider]
---@field registerRadial fun(radial: table, owner: string) [client; ox_lib provider]
---@field getCurrentRadialId fun(owner: string): string? [client; ox_lib provider]
---@field hideRadial fun(owner: string) [client; ox_lib provider]
---@field addRadialItem fun(items: table|table[], parentMenuId: string|nil, owner: string) [client; ox_lib provider]
---@field removeRadialItem fun(id: string, parentMenuId: string|nil, owner: string) [client; ox_lib provider]
---@field clearRadialItems fun(owner: string) [client; ox_lib provider]
---@field disableRadial fun(state: boolean, owner: string) [client; ox_lib provider]
---@field showRadialMenu fun(id: string, owner: string) [client; ox_lib provider]
---@field skillCheck fun(difficulty: string|table|table[], inputs: string[]|nil, owner: string): boolean [client; ox_lib provider]
---@field cancelSkillCheck fun(owner: string) [client; ox_lib provider]
---@field skillCheckActive fun(owner: string): boolean [client; ox_lib provider]
---@field showTextUI fun(text: string, options: table|nil, owner: string) [client; ox_lib provider]
---@field hideTextUI fun(owner: string) [client; ox_lib provider]
---@field isTextUIOpen fun(owner: string): boolean, string? [client; ox_lib provider]
---@field getLocaleKey fun(owner?: string): string [shared; ox_lib provider]
---@field setLocale fun(key: string, localeData?: table|string, owner?: string) [client; ox_lib provider; string second arg preserves the legacy owner form]
---@field disposeOwner fun(owner: string) [client,server; ox_lib provider]

---@class KoraLibSkills
---@field isAvailable fun(): boolean [client,server]
---@field get fun(...: any): table|nil [client: (skill?: string); server: (src: integer, skill?: string)]
---@field getAll fun(...: any): table|nil [client: (); server: (src: integer)]
---@field hasLevel fun(...: any): boolean [client: (skill: string, level: integer); server: (src: integer, skill: string, level: integer)]
---@field add fun(src: integer, skill: string, amount: number, location?: vector3|table, distance?: number): boolean, string|nil [server]
---@field adjustMinigame fun(...: any): table|nil [client: (skill: string, gameType: string, options?: table); server: (src: integer, skill: string, gameType: string, resolvedOptions: table)]

---@class QBPermissionOptions
---@field prefix? string ACE object prefix, such as `kora_core` for `qbcore.admin`.
---@field discordRoles? table<string, string|string[]> Permission/level to Discord role name/ID mappings.

---@class QBPermissionCheck
---@field level string The level this ACE object would grant.
---@field object string The ACE object passed to IsPlayerAceAllowed.
---@field raw string tostring() of what the native returned, so a non-boolean is visible.
---@field type string type() of what the native returned.
---@field allowed boolean Normalized result.

---@class KoraLibPermissions
---@field getLevel fun(src: integer, levels: string[], prefixOrOptions?: string|QBPermissionOptions): string [server]
---@field hasLevel fun(src: integer, required: string, levels: string[], prefixOrOptions?: string|QBPermissionOptions): boolean [server]
---@field hasPermission fun(src: integer, permission: string, prefixOrOptions?: string|QBPermissionOptions): boolean [server]
---@field explain fun(src: integer, levels: string[], prefixOrOptions?: string|QBPermissionOptions): QBPermissionCheck[], string [server] -- diagnostics only; nothing gates on this

---@class QBPlacementRotation
---@field pitch number
---@field roll number
---@field yaw number

---@class QBPlacementResult
---@field model string|integer
---@field coords QBCoords
---@field heading number
---@field rotation QBPlacementRotation

---@class KoraLibPlacement
---@field cancel fun(): boolean, string? [client] Cancels only the invoking resource's placement; settles its pending result as nil.

---@class QBPlacementOptions
---@field coords? QBCoords Initial transform for moving an existing placement.
---@field rotation? QBPlacementRotation
---@field bounds? {points: QBCoords[], minZ: number, maxZ: number} Allowed polygon; local placement is constrained but the server must validate again.
---@field raycast? boolean Enables surface snapping from the scripted camera; R toggles it and manual movement disables it.
---@field numericInput? boolean N opens shared numeric position/rotation fields.
---@field copy? boolean Defaults to true; false uses a gameplay confirmation without copying a Lua snippet.

---@class QBFreecamOptions
---@field coords? QBCoords
---@field rotation? QBCoords
---@field fov? number
---@field maxDistance? number Radius centred on the initial freecam position.
---@field zone? QBZoneHandle
---@field focusCoords? QBCoords
---@field movementMode? 'camera'|'grid'
---@field moveSpeed? number Metres per second before the fast multiplier.
---@field lookSensitivity? number Degrees per raw mouse-look unit.
---@field fastMultiplier? number Movement multiplier while sprint is held.
---@field transitionMs? number Script-camera blend duration.
---@field upControl? integer Optional GTA control ID for direct vertical movement.
---@field downControl? integer Optional GTA control ID for direct vertical movement.
---@field freezePlayer? boolean Defaults to true.

---@class QBFreecamHandle
---@field stop fun(reason?: string): boolean
---@field isActive fun(): boolean
---@field getCoords fun(): QBCoords|nil
---@field getRotation fun(): {pitch: number, roll: number, yaw: number}|nil
---@field getCamera fun(): integer|nil Native scripted-camera handle for raycasts and other camera natives.
---@field getMovementMode fun(): 'camera'|'grid'|nil
---@field setMovementMode fun(mode: 'camera'|'grid'): boolean
---@field setFocus fun(coords: QBCoords|nil): boolean

---@class KoraLibFreecam

---@class QBInstructionalButton
---@field label string
---@field group? string rows sharing a group collapse into one row labelled by the group
---@field control? integer
---@field command? string
---@field keybind? QBKeybindHandle

---@class QBInstructionalHandle
---@field setButtons fun(buttons: QBInstructionalButton[]): boolean
---@field hide fun(): boolean
---@field isVisible fun(): boolean

---@class KoraLibInstructional

---@class KoraLibPrint
---@field debug fun(...: any) [shared]
---@field info fun(...: any) [shared]
---@field error fun(...: any) [shared]
---@field warn fun(...: any) [shared]
---@field success fun(...: any) [shared]

---@class KoraLibProgressbar
---@field validate fun(payload: QBProgressBarPayload): true [client; validates without starting a bar]

---@class KoraLibRaycast
---@field fromCoords fun(startCoords: QBCoords, endCoords: QBCoords, flags?: integer, ignoreEntity?: integer): boolean, QBCoords?, integer?, QBCoords? [client; returns hit, coords, entityHit, surfaceNormal]
---@field fromCamera fun(maxDistance: number, flags?: integer, ignoreEntity?: integer): boolean, QBCoords?, integer?, QBCoords? [client; kora_lib order differs from ox_lib]
---@field getCoords fun(data?: QBRaycastCoordsOptions): QBRaycastCoordsResult? [client; blocks until confirmed or cancelled]
---@field start fun(startCoords: QBCoords, endCoords: QBCoords, flags?: integer, ignoreEntity?: integer): integer [client; returns a ray handle for await/poll]
---@field startFromCamera fun(maxDistance: number, flags?: integer, ignoreEntity?: integer): integer [client; returns a ray handle for await/poll]
---@field poll fun(rayHandle: integer): boolean, boolean, QBCoords?, integer?, QBCoords? [client; settled, hit, coords, entityHit, surfaceNormal]

---@class QBRaycastCoordsOptions
---@field type? 'object' Omit for the default orb marker.
---@field object? string|integer Preview model; required when type is object.
---@field heading? number Initial preview heading. Defaults to 180.
---@field maxDistance? number Maximum camera ray distance. Defaults to 50 metres.
---@field flags? integer Shape-test flags. Defaults to all intersections.

---@class QBRaycastCoordsResult
---@field coords { x: number, y: number, z: number, w?: number } Two-decimal coordinates; w is present for object previews.
---@field object string|integer|false Preview model, or false for the orb picker.

---@class KoraLibRandom
---@field pick fun(list: any[], options?: QBRandomPickOptions): any|any[] [shared]

---@class KoraLibRequire
---@field load fun(resource: string, paths: string|string[]): any [shared; an array returns one value per path]
---@field current fun(paths: string|string[]): any [shared; an array returns one value per path]
---@field ["local"] fun(paths: string|string[]): any [shared; bracket-form alias of current]

---@class KoraLibResources
---@field isStarted fun(resourceName: string): boolean [shared]
---@field awaitStarted fun(resourceName: string, options?: QBResourceAwaitOptions): boolean, string? [shared]
---@field serverRegistry fun(onDispose: fun(id: any)): QBResourcesRegistry [server]

---@class KoraLibRewards
---@field generate fun(items: QBRewardItem[], opts?: QBRewardOptions): table[] [shared]

---@class KoraLibScreenshot
---@field capture fun(options?: QBScreenshotOptions, timeout?: integer): promise|any [client] Resolves to a data URI.
---@field upload fun(url: string, field?: string, options?: QBScreenshotOptions, timeout?: integer): promise|any [client] Captures then uploads the image.
---@field requestScreenshot fun(options?: QBScreenshotOptions|fun(data: string?), callback?: fun(data: string?)) [client] screenshot-basic-compatible callback export.
---@field requestScreenshotUpload fun(url: string, field: string, options?: QBScreenshotOptions|fun(response: string?), callback?: fun(response: string?)) [client] screenshot-basic-compatible callback export.
---@field requestClient fun(player: integer, options?: QBScreenshotOptions, callback?: fun(err: string|false, result?: string)): string [server] Requests a one-time client upload.

---@class QBSoundOptions
---@field network? boolean Play for nearby players too, rather than only locally. Defaults to false.
---@field range? number Audible range in metres, world sounds only. Defaults to Config.sound.defaultRange.
---@field bank? string Audio bank to request (and wait for) before playing.
---@field releaseAfter? number Milliseconds before the sound id is auto-released. Defaults to Config.sound.defaultReleaseAfter.

---@class KoraLibSound

---@class KoraLibState
---@field awaitGlobal fun(key: string, timeoutMs?: integer, pollIntervalMs?: integer): any, string? [shared]
---@field onChange fun(keyFilter: string?, bagFilter: string?, handler: fun(change: QBStateChange)): integer [client/server]
---@field offChange fun(listenerId: integer): boolean [client/server]

---@class KoraLibStatus
---@field assertName fun(name: string) [shared]
---@field registerEffect fun(name: string, def: QBStatusEffectDef) [shared]
---@field getEffectDef fun(name: string): QBStatusEffectDef? [shared]
---@field apply fun(targetOrName: integer|string, nameOrOpts?: string|QBStatusApplyOptions, opts?: QBStatusApplyOptions): boolean, string? [client/server]
---@field remove fun(targetOrName: integer|string, name?: string): boolean [client/server]
---@field isActive fun(targetOrName: integer|string, name?: string): boolean [client/server]
---@field getActive fun(target?: integer): QBStatusActiveEntry[] [client/server]

---@class KoraLibStream

---@class KoraLibTeleport

---@class KoraLibTextUI

---@class KoraLibTheme
---@field accentColor fun(): string [shared] Forwarded to qbtheme:getPrimaryColor().
---@field tokens fun(overrides?: string|table<string, string>): table<string, string> [shared] Forwarded to qbtheme:getTokens().
---@field push fun(): table<string, string> [client] Reapplies kora_theme to kora_lib's NUI.
---@field getFonts fun(): { body: KoraLibThemeFont, heading: KoraLibThemeFont, mono: KoraLibThemeFont } [shared] Forwarded to qbtheme:getFonts().
---@field onFontsChanged fun(handler: fun(fonts: table)): fun() [client] Runs handler after an admin changes the server fonts; returns an unsubscribe function.

---@class KoraLibThemeFont
---@field id string Catalog id (`poppins`), `default` or `custom`.
---@field label string Display name.
---@field stack string Resolved CSS font-family stack.
---@field source 'config'|'theme.json'|'default' Where the choice came from.

---@class QBDebounced
---@field cancel fun(): boolean Drops a pending run without firing it.
---@field isPending fun(): boolean

---@class QBThrottled
---@field reset fun() Clears the cooldown so the next call passes through.
---@field remaining fun(): integer Milliseconds until the next call is allowed; 0 when ready.

---@class KoraLibTimers
---@field setInterval fun(fn: fun(), interval: integer): integer [shared]
---@field setTimeout fun(fn: fun(), delay: integer): integer [shared]
---@field clearInterval fun(id: integer): boolean [shared]
---@field clearTimeout fun(id: integer): boolean [shared]
---@field debounce fun(fn: fun(...), wait: integer): QBDebounced [shared]
---@field throttle fun(fn: fun(...), interval: integer): QBThrottled [shared]
---@field cooldown fun(interval: integer): QBCooldownHandle [shared]
---@field count fun(): integer [shared]

---@class KoraLibUtil
---@field deepClone fun(value: any): any [shared]
---@field fnv1a fun(value: string): string [shared]
---@field isCallable fun(value: any): boolean [shared]
---@field trim fun(value: any): any [shared]
---@field cleanText fun(value: any, options?: QBCleanTextOptions): string|nil, string? [shared]
---@field truncateUtf8 fun(value: string, maximum: integer): string|nil, string? [shared]
---@field isFiniteNumber fun(value: any): boolean [shared]
---@field isInteger fun(value: any): boolean [shared]
---@field decodeJson fun(value: string): any, string? [shared]
---@field clamp fun(value: number, min: number, max: number): number [shared]
---@field round fun(value: number, decimals?: integer): number [shared]
---@field randomFloat fun(min: number, max: number): number [shared]
---@field weightedChoice fun(list: {[1]: any, [2]: number}[]): any [shared]
---@field tableContains fun(t: table, value: any): boolean [shared]
---@field lerp fun(a: number, b: number, t: number): number [shared]
---@field vecAdd fun(a: QBSpatialVector, b: QBSpatialVector): QBCoords [shared]
---@field vecSub fun(a: QBSpatialVector, b: QBSpatialVector): QBCoords [shared]
---@field vecScale fun(v: QBSpatialVector, scalar: number): QBCoords [shared]
---@field vecLength fun(v: QBSpatialVector): number [shared]
---@field vecDistance fun(a: QBSpatialVector, b: QBSpatialVector): number [shared]
---@field vecDistance2d fun(a: QBSpatialVector, b: QBSpatialVector): number [shared]
---@field vecNormalize fun(v: QBSpatialVector): QBCoords [shared]
---@field headingToDirection fun(heading: number): QBCoords [shared]
---@field directionToHeading fun(v: QBSpatialVector): number [shared]
---@field bearing fun(origin: QBSpatialVector, target: QBSpatialVector): number [shared]
---@field nearest fun(list: any[], position: QBSpatialVector, opts: KoraNearestOptions): any, number? [shared]
---@field rateLimiter fun(max: integer, window: number): KoraRateLimiter [shared]

---@class KoraLibVehicle
---@field normalizePlate fun(value: any, options?: QBVehicleNormalizePlateOptions): string|nil, string? [shared]

---@class KoraLibVisuals

---@class KoraLibWorld
---@field getNearbyEntities fun(entityType: QBWorldEntityType, coords: QBCoords, radius: number, options?: QBWorldQueryOptions): QBWorldMatch[] [client/server]
---@field getClosestEntity fun(entityType: QBWorldEntityType, coords: QBCoords, options?: QBWorldQueryOptions): integer|false, QBCoords?, number? [client/server]
---@field isSpawnClear fun(coords: QBCoords, radius: number, options?: QBWorldQueryOptions): boolean [client/server]
---@field resolveNetworkEntity fun(src: integer, networkId: integer, options?: QBWorldNetworkEntityOptions): integer|nil, string? [server]
---@field resolveNearbyPlayer fun(src: integer, targetSrc: integer, options: QBWorldNearbyPlayerOptions): integer|nil, number|string [server]

---@class KoraLibZones

---@class KoraWorkspace: kora_lib
---@field shared KoraSharedRegistry
---@field sql KoraSql
---@type KoraWorkspace
Kora = {}
