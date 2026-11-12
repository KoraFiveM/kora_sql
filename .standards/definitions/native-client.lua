---@meta
-- Kora Framework integration. Copyright © 2026 Kora Framework.
-- Generated signatures from the pinned fivem-lls-addon; see PROVENANCE.md and LICENSE-FIVEM.

---@param value number
---@return number
function Absf(value) end

---@param value integer
---@return integer
function Absi(value) end

---@param p0 number
---@return number
function Acos(p0) end

---@param mode string
function ActivateAudioSlowmoMode(mode) end

---@param camTo integer
---@param camFrom integer
---@param duration integer
---@param easeLocation integer
---@param easeRotation integer
---@param easeFove integer
function ActivateCamWithInterpAndFovCurve(camTo, camFrom, duration, easeLocation, easeRotation, easeFove) end

---@param netID integer
---@param toggle boolean
function ActivateDamageTrackerOnNetworkId(netID, toggle) end

---@param player integer
---@param toggle boolean
function ActivateDamageTrackerOnPlayer(player, toggle) end

---@param menuhash integer | string
---@param togglePause boolean
---@param component integer
function ActivateFrontendMenu(menuhash, togglePause, component) end

---@param interior integer
---@param entitySetName string
function ActivateInteriorEntitySet(interior, entitySetName) end

---@param entity integer
function ActivatePhysics(entity) end


function ActivateRockstarEditor() end


function ActivateTimecycleEditor() end

---@param captionString string
---@param condensedCaptionString string
function ActivityFeedCreate(captionString, condensedCaptionString) end

---@param ped integer
---@param weaponHash integer | string
---@param ammo integer
function AddAmmoToPed(ped, weaponHash, ammo) end

---@param ped integer
---@param ammoType integer | string
---@param ammo integer
function AddAmmoToPedByType(ped, ammoType, ammo) end

---@param ped integer
---@param amount integer
function AddArmourToPed(ped, amount) end

---@param submixId integer
---@param outputSubmixId integer
function AddAudioSubmixOutput(submixId, outputSubmixId) end

---@param modelNameHash integer
function AddAuthorizedParachuteModel(modelNameHash) end

---@param modelNameHash integer
function AddAuthorizedParachutePackModel(modelNameHash) end

---@param x number
---@param y number
---@param z number
---@param width number
---@param height number
---@return integer
function AddBlipForArea(x, y, z, width, height) end

---@param x number
---@param y number
---@param z number
---@return integer
function AddBlipForCoord(x, y, z) end

---@param entity integer
---@return integer
function AddBlipForEntity(entity) end

---@param pickup integer
---@return integer
function AddBlipForPickup(pickup) end

---@param posX number
---@param posY number
---@param posZ number
---@param radius number
---@return integer
function AddBlipForRadius(posX, posY, posZ, radius) end

---@param camera integer
---@param x number
---@param y number
---@param z number
---@param xRot number
---@param yRot number
---@param zRot number
---@param length integer
---@param p8 integer
---@param transitionType integer
function AddCamSplineNode(camera, x, y, z, xRot, yRot, zRot, length, p8, transitionType) end

---@param cam integer
---@param cam2 integer
---@param length integer
---@param p3 integer
function AddCamSplineNodeUsingCamera(cam, cam2, length, p3) end

---@param cam integer
---@param cam2 integer
---@param p2 integer
---@param p3 integer
function AddCamSplineNodeUsingCameraFrame(cam, cam2, p2, p3) end

---@param cam integer
---@param p1 integer
---@param p2 integer
function AddCamSplineNodeUsingGameplayFrame(cam, p1, p2) end

---@param playerX number
---@param playerY number
---@param playerZ number
---@param radiusX number
---@param radiusY number
---@param radiusZ number
---@param p6 boolean
---@param p7 boolean
---@param p8 boolean
---@param p9 boolean
function AddCoverBlockingArea(playerX, playerY, playerZ, radiusX, radiusY, radiusZ, p6, p7, p8, p9) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 boolean
---@return integer
function AddCoverPoint(p0, p1, p2, p3, p4, p5, p6, p7) end

---@param decalType integer
---@param posX number
---@param posY number
---@param posZ number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param sideX number
---@param sideY number
---@param sideZ number
---@param width number
---@param height number
---@param rCoef number
---@param gCoef number
---@param bCoef number
---@param opacity number
---@param timeout number
---@param isLongRange boolean
---@param isDynamic boolean
---@param useComplexColn boolean
---@return integer
function AddDecal(decalType, posX, posY, posZ, dirX, dirY, dirZ, sideX, sideY, sideZ, width, height, rCoef, gCoef, bCoef, opacity, timeout, isLongRange, isDynamic, useComplexColn) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@return any
function AddDispatchSpawnBlockingAngledArea(x1, y1, z1, x2, y2, z2, width) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return any
function AddDispatchSpawnBlockingArea(x1, y1, x2, y2) end

---@param doorHash integer | string
---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param p5 boolean
---@param scriptDoor boolean
---@param isLocal boolean
function AddDoorToSystem(doorHash, modelHash, x, y, z, p5, scriptDoor, isLocal) end

---@param entity integer
---@param icon string
---@return any
function AddEntityIcon(entity, icon) end

---@param entity integer
---@param groupName string
---@param fadeIn number
function AddEntityToAudioMixGroup(entity, groupName, fadeIn) end

---@param x number
---@param y number
---@param z number
---@param explosionType integer
---@param damageScale number
---@param isAudible boolean
---@param isInvisible boolean
---@param cameraShake number
function AddExplosion(x, y, z, explosionType, damageScale, isAudible, isInvisible, cameraShake) end

---@param x number
---@param y number
---@param z number
---@param explosionType integer
---@param explosionFx integer | string
---@param damageScale number
---@param isAudible boolean
---@param isInvisible boolean
---@param cameraShake number
function AddExplosionWithUserVfx(x, y, z, explosionType, explosionFx, damageScale, isAudible, isInvisible, cameraShake) end

---@param xLow number
---@param yLow number
---@param xHigh number
---@param yHigh number
---@param height number
---@return integer
function AddExtraCalmingQuad(xLow, yLow, xHigh, yHigh, height) end

---@param configName string
---@param defaultHealth number
---@param defaultArmor number
---@param defaultEndurance number
---@param fatiguedHealthThreshold number
---@param injuredHealthThreshold number
---@param dyingHealthThreshold number
---@param hurtHealthThreshold number
---@param dogTakedownThreshold number
---@param writheFromBulletThreshold number
---@param meleeCardinalFatalAttack boolean
---@param invincible boolean
function AddHealthConfig(configName, defaultHealth, defaultArmor, defaultEndurance, fatiguedHealthThreshold, injuredHealthThreshold, dyingHealthThreshold, hurtHealthThreshold, dogTakedownThreshold, writheFromBulletThreshold, meleeCardinalFatalAttack, invincible) end

---@param x number
---@param y number
---@param z number
---@param p3 number
---@param p4 any
---@return integer
function AddHospitalRestart(x, y, z, p3, p4) end

---@param speakerConversationIndex integer
---@param context string
---@param subtitle string
---@param listenerNumber integer
---@param volumeType integer
---@param isRandom boolean
---@param interruptible boolean
---@param ducksRadio boolean
---@param ducksScore boolean
---@param audibility integer
---@param headset boolean
---@param dontInterruptForSpecialAbility boolean
---@param isPadSpeakerRoute boolean
function AddLineToConversation(speakerConversationIndex, context, subtitle, listenerNumber, volumeType, isRandom, interruptible, ducksRadio, ducksScore, audibility, headset, dontInterruptForSpecialAbility, isPadSpeakerRoute) end

---@param name string
---@return integer
function AddMinimapOverlay(name) end

---@param name string
---@param depth integer
---@return integer
function AddMinimapOverlayWithDepth(name, depth) end

---@param modelHash integer | string
---@return boolean
function AddModelToCreatorBudget(modelHash) end

---@param x number
---@param y number
---@param z number
---@param width number
---@param length number
---@param height number
---@param heading number
---@param bPermanent boolean
---@param flags integer
---@return any
function AddNavmeshBlockingObject(x, y, z, width, length, height, heading, bPermanent, flags) end

---@param x number
---@param y number
---@param radius number
function AddNavmeshRequiredRegion(x, y, radius) end

---@param addToBrief boolean
function AddNextMessageToPreviousBriefs(addToBrief) end

---@param x number
---@param y number
---@param z number
---@param groundLvl number
---@param width number
---@param transparency number
---@return integer
function AddOilDecal(x, y, z, groundLvl, width, transparency) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param explosionType integer
---@param damageScale number
---@param isAudible boolean
---@param isInvisible boolean
---@param cameraShake number
function AddOwnedExplosion(ped, x, y, z, explosionType, damageScale, isAudible, isInvisible, cameraShake) end

---@param id1 integer
---@param id2 integer
function AddPatrolRouteLink(id1, id2) end

---@param id integer
---@param guardScenario string
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param waitTime integer
function AddPatrolRouteNode(id, guardScenario, x1, y1, z1, x2, y2, z2, waitTime) end

---@param ped integer
---@param collection integer | string
---@param overlay integer | string
function AddPedDecorationFromHashes(ped, collection, overlay) end

---@param ped integer
---@param collection integer | string
---@param overlay integer | string
function AddPedDecorationFromHashesInCorona(ped, collection, overlay) end

---@param speakerConversationIndex integer
---@param ped integer
---@param voiceName string
function AddPedToConversation(speakerConversationIndex, ped, voiceName) end

---@param x number
---@param y number
---@param z number
---@param groundLvl number
---@param width number
---@param transparency number
---@return integer
function AddPetrolDecal(x, y, z, groundLvl, width, transparency) end

---@param x number
---@param y number
---@param z number
---@param p3 number
function AddPetrolTrailDecalInfo(x, y, z, p3) end

---@param pickup integer
---@param roomName string
function AddPickupToInteriorRoomByName(pickup, roomName) end

---@param x number
---@param y number
---@param z number
function AddPointToGpsCustomRoute(x, y, z) end

---@param x number
---@param y number
---@param z number
function AddPointToGpsMultiRoute(x, y, z) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 any
---@return any
function AddPoliceRestart(p0, p1, p2, p3, p4) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param p6 number
---@param p7 number
---@param p8 boolean
---@return integer
function AddPopMultiplierArea(x1, y1, z1, x2, y2, z2, p6, p7, p8) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param pedMultiplier number
---@param vehicleMultiplier number
---@param p6 boolean
---@param p7 boolean
---@return integer
function AddPopMultiplierSphere(x, y, z, radius, pedMultiplier, vehicleMultiplier, p6, p7) end

---@param name string
---@return any, integer
function AddRelationshipGroup(name) end

---@param origTxd string
---@param origTxn string
---@param newTxd string
---@param newTxn string
function AddReplaceTexture(origTxd, origTxn, newTxd, newTxn) end

---@param value any
function AddReplayStatValue(value) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param speed number
---@param p5 boolean
---@return integer
function AddRoadNodeSpeedZone(x, y, z, radius, speed, p5) end

---@param x number
---@param y number
---@param z number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param maxLength number
---@param ropeType integer
---@param initLength number
---@param minLength number
---@param lengthChangeRate number
---@param onlyPPU boolean
---@param collisionOn boolean
---@param lockFromFront boolean
---@param timeMultiplier number
---@param breakable boolean
---@return integer, any
function AddRope(x, y, z, rotX, rotY, rotZ, maxLength, ropeType, initLength, minLength, lengthChangeRate, onlyPPU, collisionOn, lockFromFront, timeMultiplier, breakable) end

---@param posMinX number
---@param posMinY number
---@param posMinZ number
---@param posMaxX number
---@param posMaxY number
---@param posMaxZ number
---@param network boolean
---@param cancelActive boolean
---@param blockPeds boolean
---@param blockVehicles boolean
---@return integer
function AddScenarioBlockingArea(posMinX, posMinY, posMinZ, posMaxX, posMaxY, posMaxZ, network, cancelActive, blockPeds, blockVehicles) end

---@param name string
---@param model integer | string
---@param p2 number
---@param p3 number
function AddScriptToRandomPed(name, model, p2, p3) end

---@param eventType integer
---@param x number
---@param y number
---@param z number
---@param duration number
---@return integer
function AddShockingEventAtPosition(eventType, x, y, z, duration) end

---@param eventType integer
---@param entity integer
---@param duration number
---@return integer
function AddShockingEventForEntity(eventType, entity, duration) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param x3 number
---@param y3 number
---@param z3 number
---@param x4 number
---@param y4 number
---@param z4 number
---@param camX number
---@param camY number
---@param camZ number
---@param unk1 integer
---@param unk2 integer
---@param unk3 integer
---@return integer
function AddStuntJump(x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, camX, camY, camZ, unk1, unk2, unk3) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param radius1 number
---@param x3 number
---@param y3 number
---@param z3 number
---@param x4 number
---@param y4 number
---@param z4 number
---@param radius2 number
---@param camX number
---@param camY number
---@param camZ number
---@param unk1 integer
---@param unk2 integer
---@param unk3 integer
---@return integer
function AddStuntJumpAngled(x1, y1, z1, x2, y2, z2, radius1, x3, y3, z3, x4, y4, z4, radius2, camX, camY, camZ, unk1, unk2, unk3) end

---@param x number
---@param y number
---@param z number
function AddTacticalAnalysisPoint(x, y, z) end

---@param modifierName1 string
---@param modifierName2 string
function AddTcmodifierOverride(modifierName1, modifierName2) end

---@param value number
---@param decimalPlaces integer
function AddTextComponentFloat(value, decimalPlaces) end

---@param value integer
---@param commaSeparated boolean
function AddTextComponentFormattedInteger(value, commaSeparated) end

---@param value integer
function AddTextComponentInteger(value) end

---@param blip integer
function AddTextComponentSubstringBlipName(blip) end

---@param string string
function AddTextComponentSubstringKeyboardDisplay(string) end

---@param p0 string
---@param p1 integer
function AddTextComponentSubstringPhoneNumber(p0, p1) end

---@param text string
function AddTextComponentSubstringPlayerName(text) end

---@param labelName string
function AddTextComponentSubstringTextLabel(labelName) end

---@param gxtEntryHash integer | string
function AddTextComponentSubstringTextLabelHashKey(gxtEntryHash) end

---@param timestamp integer
---@param format integer
function AddTextComponentSubstringTime(timestamp, format) end

---@param website string
function AddTextComponentSubstringWebsite(website) end

---@param entryKey string
---@param entryText string
function AddTextEntry(entryKey, entryText) end

---@param entryKey integer | string
---@param entryText string
function AddTextEntryByHash(entryKey, entryText) end

---@param hours integer
---@param minutes integer
---@param seconds integer
function AddToClockTime(hours, minutes, seconds) end

---@param p0 any
---@param p1 any
---@return boolean
function AddToItemset(p0, p1) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@return any
function AddVehicleCombatAngledAvoidanceArea(p0, p1, p2, p3, p4, p5, p6) end

---@param vehicle integer
---@param ped integer
---@param boneIndex integer
---@param x1 number
---@param x2 number
---@param x3 number
---@param y1 number
---@param y2 number
---@param y3 number
---@param z1 number
---@param z2 number
---@param z3 number
---@param scale number
---@param p13 any
---@param alpha integer
---@return boolean
function AddVehicleCrewEmblem(vehicle, ped, boneIndex, x1, x2, x3, y1, y2, y3, z1, z2, z3, scale, p13, alpha) end

---@param vehicle integer
function AddVehiclePhoneExplosiveDevice(vehicle) end

---@param p0 any
---@param p1 number
---@param p2 any
---@param p3 boolean
---@param p4 boolean
---@param p5 boolean
---@param p6 any
function AddVehicleStuckCheckWithWarp(p0, p1, p2, p3, p4, p5, p6) end

---@param ped integer
---@param x number
---@param y number
---@param z number
function AddVehicleSubtaskAttackCoord(ped, x, y, z) end

---@param ped integer
---@param ped2 integer
function AddVehicleSubtaskAttackPed(ped, ped2) end

---@param vehicle integer
function AddVehicleUpsidedownCheck(vehicle) end


function AdjustNextPosSizeAsNormalized_16_9() end

---@param hour integer
---@param minute integer
---@param second integer
function AdvanceClockTimeTo(hour, minute, second) end

---@param vehicle integer
function AllowAmbientVehiclesToAvoidAdverseConditions(vehicle) end

---@param allow boolean
function AllowDisplayOfMultiplayerCashText(allow) end

---@param toggle boolean
function AllowMissionCreatorWarp(toggle) end


function AllowPauseMenuWhenDeadThisFrame() end


function AllowPlayerSwitchAscent() end


function AllowPlayerSwitchDescent() end


function AllowPlayerSwitchOutro() end


function AllowPlayerSwitchPan() end

---@param toggle boolean
function AllowSonarBlips(toggle) end

---@param p0 number
---@param distance number
function AnimateGameplayCamZoom(p0, distance) end

---@param cam integer
---@param p1 string
---@param p2 string
---@param p3 string
---@param amplitude number
function AnimatedShakeCam(cam, p1, p2, p3, amplitude) end

---@param p0 string
---@param p1 string
---@param p2 string
---@param p3 number
function AnimatedShakeScriptGlobal(p0, p1, p2, p3) end

---@param effectName string
---@return number
function AnimpostfxGetUnk(effectName) end

---@param effectName string
---@return boolean
function AnimpostfxIsRunning(effectName) end

---@param effectName string
---@param duration integer
---@param looped boolean
function AnimpostfxPlay(effectName, duration, looped) end

---@param effectName string
function AnimpostfxStop(effectName) end


function AnimpostfxStopAll() end

---@param effectName string
function AnimpostfxStopAndDoUnk(effectName) end


function AppClearBlock() end


function AppCloseApp() end


function AppCloseBlock() end

---@return boolean
function AppDataValid() end

---@param appName string
---@return boolean
function AppDeleteAppData(appName) end

---@return integer
function AppGetDeletedFileStatus() end

---@param property string
---@return number
function AppGetFloat(property) end

---@param property string
---@return integer
function AppGetInt(property) end

---@param property string
---@return string
function AppGetString(property) end

---@return boolean
function AppHasLinkedSocialClubAccount() end

---@param appName string
---@return boolean
function AppHasSyncedData(appName) end


function AppSaveData() end

---@param appName string
function AppSetApp(appName) end

---@param blockName string
function AppSetBlock(blockName) end

---@param property string
---@param value number
function AppSetFloat(property, value) end

---@param property string
---@param value integer
function AppSetInt(property, value) end

---@param property string
---@param value string
function AppSetString(property, value) end

---@param ped integer
---@param damageAmount integer
---@param armorFirst boolean
function ApplyDamageToPed(ped, damageAmount, armorFirst) end

---@param entity integer
---@param forceType integer
---@param x number
---@param y number
---@param z number
---@param offX number
---@param offY number
---@param offZ number
---@param nComponent integer
---@param bLocalForce boolean
---@param bLocalOffset boolean
---@param bScaleByMass boolean
---@param bPlayAudio boolean
---@param bScaleByTimeWarp boolean
function ApplyForceToEntity(entity, forceType, x, y, z, offX, offY, offZ, nComponent, bLocalForce, bLocalOffset, bScaleByMass, bPlayAudio, bScaleByTimeWarp) end

---@param entity integer
---@param forceType integer
---@param x number
---@param y number
---@param z number
---@param nComponent integer
---@param bLocalForce boolean
---@param bScaleByMass boolean
---@param bApplyToChildren boolean
function ApplyForceToEntityCenterOfMass(entity, forceType, x, y, z, nComponent, bLocalForce, bScaleByMass, bApplyToChildren) end

---@param posX number
---@param posY number
---@param posZ number
---@param vecX number
---@param vecY number
---@param vecZ number
---@param impulse number
function ApplyImpulseToCloth(posX, posY, posZ, vecX, vecY, vecZ, impulse) end

---@param ped integer
---@param boneIndex integer
---@param xRot number
---@param yRot number
---@param zRot number
---@param woundType string
function ApplyPedBlood(ped, boneIndex, xRot, yRot, zRot, woundType) end

---@param ped integer
---@param p1 any
---@param p2 number
---@param p3 number
---@return any
function ApplyPedBloodByZone(ped, p1, p2, p3) end

---@param ped integer
---@param p1 any
---@param p2 number
---@param p3 number
---@param p4 any
function ApplyPedBloodDamageByZone(ped, p1, p2, p3, p4) end

---@param ped integer
---@param component integer
---@param u number
---@param v number
---@param rotation number
---@param scale number
---@param forcedFrame integer
---@param preAge number
---@param bloodName string
function ApplyPedBloodSpecific(ped, component, u, v, rotation, scale, forcedFrame, preAge, bloodName) end

---@param ped integer
---@param damageZone integer
---@param xOffset number
---@param yOffset number
---@param heading number
---@param scale number
---@param alpha number
---@param variation integer
---@param fadeIn boolean
---@param decalName string
function ApplyPedDamageDecal(ped, damageZone, xOffset, yOffset, heading, scale, alpha, variation, fadeIn, decalName) end

---@param ped integer
---@param damagePack string
---@param damage number
---@param mult number
function ApplyPedDamagePack(ped, damagePack, damage, mult) end

---@param numEntries integer
---@param msPerCycle integer
---@return boolean
function ApplyWeatherCycles(numEntries, msPerCycle) end

---@return boolean
function AreAllNavmeshRegionsLoaded() end

---@param vehicle integer
---@return boolean
function AreAllVehicleWindowsIntact(vehicle) end

---@param vehicle integer
---@return boolean
function AreAnyVehicleSeatsFree(vehicle) end

---@param aircraft integer
---@return boolean
function AreBombBayDoorsOpen(aircraft) end

---@param garageHash integer | string
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@param p4 any
---@return boolean
function AreEntitiesEntirelyInsideGarage(garageHash, p1, p2, p3, p4) end

---@param vehicle integer
---@return boolean
function AreHeliStubWingsDeployed(vehicle) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
function AreNodesLoadedForArea(x1, y1, x2, y2) end

---@param vehicle integer
---@return boolean
function AreOutriggerLegsDeployed(vehicle) end

---@param vehicle integer
---@param checkForZeroHealth boolean
---@return boolean
function ArePlaneControlPanelsIntact(vehicle, checkForZeroHealth) end

---@param plane integer
---@return boolean
function ArePlanePropellersIntact(plane) end

---@param plane integer
---@return boolean
function ArePlaneWingsIntact(plane) end

---@param player integer
---@return boolean
function ArePlayerFlashingStarsAboutToDrop(player) end

---@param player integer
---@return boolean
function ArePlayerStarsGreyedOut(player) end

---@return boolean
function AreProfileSettingsValid() end

---@param string1 string
---@param string2 string
---@return boolean
function AreStringsEqual(string1, string2) end

---@param value number
---@return number
function Asin(value) end


function AssistedMovementCloseRoute() end


function AssistedMovementFlushRoute() end

---@param route string
---@return boolean
function AssistedMovementIsRouteLoaded(route) end

---@param dist number
function AssistedMovementOverrideLoadDistanceThisFrame(dist) end

---@param route string
function AssistedMovementRemoveRoute(route) end

---@param route string
function AssistedMovementRequestRoute(route) end

---@param route string
---@param props integer
function AssistedMovementSetRouteProperties(route, props) end

---@param p0 number
---@return number
function Atan(p0) end

---@param p0 number
---@param p1 number
---@return number
function Atan2(p0, p1) end

---@param cam integer
---@param entity integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param isRelative boolean
function AttachCamToEntity(cam, entity, xOffset, yOffset, zOffset, isRelative) end

---@param cam integer
---@param ped integer
---@param boneIndex integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param isRelative boolean
function AttachCamToPedBone(cam, ped, boneIndex, xOffset, yOffset, zOffset, isRelative) end

---@param cam integer
---@param vehicle integer
---@param boneIndex integer
---@param relativeRotation boolean
---@param rotX number
---@param rotY number
---@param rotZ number
---@param offX number
---@param offY number
---@param offZ number
---@param fixedDirection boolean
function AttachCamToVehicleBone(cam, vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection) end

---@param handler integer
---@param container integer
function AttachContainerToHandlerFrame(handler, container) end

---@param ropeId integer
---@param ent1 integer
---@param ent2 integer
---@param ent1_x number
---@param ent1_y number
---@param ent1_z number
---@param ent2_x number
---@param ent2_y number
---@param ent2_z number
---@param length number
---@param p10 boolean
---@param p11 boolean
---@param boneName1 string
---@param boneName2 string
function AttachEntitiesToRope(ropeId, ent1, ent2, ent1_x, ent1_y, ent1_z, ent2_x, ent2_y, ent2_z, length, p10, p11, boneName1, boneName2) end

---@param entity1 integer
---@param entity2 integer
---@param entityBone integer
---@param entityBone2 integer
---@param p4 boolean
---@param p5 boolean
function AttachEntityBoneToEntityBone(entity1, entity2, entityBone, entityBone2, p4, p5) end

---@param entity1 integer
---@param entity2 integer
---@param entityBone integer
---@param entityBone2 integer
---@param p4 boolean
---@param p5 boolean
function AttachEntityBoneToEntityBonePhysically(entity1, entity2, entityBone, entityBone2, p4, p5) end

---@param vehicle integer
---@param entity integer
---@param p2 integer
---@param x number
---@param y number
---@param z number
function AttachEntityToCargobob(vehicle, entity, p2, x, y, z) end

---@param entity1 integer
---@param entity2 integer
---@param boneIndex integer
---@param xPos number
---@param yPos number
---@param zPos number
---@param xRot number
---@param yRot number
---@param zRot number
---@param p9 boolean
---@param useSoftPinning boolean
---@param collision boolean
---@param isPed boolean
---@param rotationOrder integer
---@param syncRot boolean
function AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, rotationOrder, syncRot) end

---@param entity1 integer
---@param entity2 integer
---@param boneIndex1 integer
---@param boneIndex2 integer
---@param xPos1 number
---@param yPos1 number
---@param zPos1 number
---@param xPos2 number
---@param yPos2 number
---@param zPos2 number
---@param xRot number
---@param yRot number
---@param zRot number
---@param breakForce number
---@param fixedRot boolean
---@param p15 boolean
---@param collision boolean
---@param teleport boolean
---@param p18 integer
function AttachEntityToEntityPhysically(entity1, entity2, boneIndex1, boneIndex2, xPos1, yPos1, zPos1, xPos2, yPos2, zPos2, xRot, yRot, zRot, breakForce, fixedRot, p15, collision, teleport, p18) end

---@param pickupObject integer
---@param ped integer
function AttachPortablePickupToPed(pickupObject, ped) end

---@param ropeId integer
---@param entity integer
---@param x number
---@param y number
---@param z number
---@param p5 boolean
function AttachRopeToEntity(ropeId, entity, x, y, z, p5) end

---@param sceneID integer
---@param entity integer
---@param boneIndex integer
function AttachSynchronizedSceneToEntity(sceneID, entity, boneIndex) end

---@param entity integer
function AttachTvAudioToEntity(entity) end

---@param vehicle integer
---@param trailer integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param coordsX number
---@param coordsY number
---@param coordsZ number
---@param rotationX number
---@param rotationY number
---@param rotationZ number
---@param disableColls number
function AttachVehicleOnToTrailer(vehicle, trailer, offsetX, offsetY, offsetZ, coordsX, coordsY, coordsZ, rotationX, rotationY, rotationZ, disableColls) end

---@param cargobob integer
---@param vehicle integer
---@param vehicleBoneIndex integer
---@param x number
---@param y number
---@param z number
function AttachVehicleToCargobob(cargobob, vehicle, vehicleBoneIndex, x, y, z) end

---@param towTruck integer
---@param vehicle integer
---@param rear boolean
---@param hookOffsetX number
---@param hookOffsetY number
---@param hookOffsetZ number
function AttachVehicleToTowTruck(towTruck, vehicle, rear, hookOffsetX, hookOffsetY, hookOffsetZ) end

---@param vehicle integer
---@param trailer integer
---@param radius number
function AttachVehicleToTrailer(vehicle, trailer, radius) end

---@return boolean
function AudioIsScriptedMusicPlaying() end

---@param event integer
---@param amountReceived integer
---@return boolean, integer
function BadSportPlayerLeftDetected(event, amountReceived) end

---@param p0 any
---@param p1 any
function BeginReplayStats(p0, p1) end

---@param scaleform integer
---@param methodName string
---@return boolean
function BeginScaleformMovieMethod(scaleform, methodName) end

---@param functionName string
---@return boolean
function BeginScaleformMovieMethodOnFrontend(functionName) end

---@param functionName string
---@return boolean
function BeginScaleformMovieMethodOnFrontendHeader(functionName) end

---@param hudComponent integer
---@param methodName string
---@return boolean
function BeginScaleformScriptHudMovieMethod(hudComponent, methodName) end


function BeginSrl() end

---@return boolean
function BeginTakeHighQualityPhoto() end

---@return boolean
function BeginTakeMissionCreatorPhoto() end

---@param string string
function BeginTextCommandBusyspinnerOn(string) end

---@param text string
function BeginTextCommandClearPrint(text) end

---@param inputType string
function BeginTextCommandDisplayHelp(inputType) end

---@param text string
function BeginTextCommandDisplayText(text) end

---@param text string
function BeginTextCommandGetWidth(text) end

---@param text string
function BeginTextCommandIsMessageDisplayed(text) end

---@param labelName string
function BeginTextCommandIsThisHelpMessageBeingDisplayed(labelName) end

---@param entry string
function BeginTextCommandLineCount(entry) end

---@param p0 string
function BeginTextCommandObjective(p0) end

---@param gxtEntry string
function BeginTextCommandOverrideButtonText(gxtEntry) end

---@param GxtEntry string
function BeginTextCommandPrint(GxtEntry) end

---@param textLabel string
function BeginTextCommandScaleformString(textLabel) end

---@param textLabel string
function BeginTextCommandSetBlipName(textLabel) end

---@param text string
function BeginTextCommandThefeedPost(text) end

---@param contextName string
function BgEndContext(contextName) end

---@param contextHash integer | string
function BgEndContextHash(contextHash) end

---@param contextName string
function BgStartContext(contextName) end

---@param contextHash integer | string
function BgStartContextHash(contextHash) end

---@param vehicle integer
function BlipSiren(vehicle) end

---@param ped integer
---@param shouldBlock boolean
---@param suppressOutgoingNetworkSpeech boolean
function BlockAllSpeechFromPed(ped, shouldBlock, suppressOutgoingNetworkSpeech) end

---@param blocked boolean
function BlockDeathJingle(blocked) end

---@param name integer | string
---@param eventType integer
function BlockDecisionMakerEvent(name, eventType) end

---@param dispatchService integer
---@param toggle boolean
function BlockDispatchServiceResourceCreation(dispatchService, toggle) end

---@param ped integer
---@param toggle boolean
function BlockPedDeadBodyShockingEvents(ped, toggle) end

---@param groupName string
---@param contextBlockTarget integer
function BlockSpeechContextGroup(groupName, contextBlockTarget) end

---@param entity integer
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 number
---@param p9 any
---@param p10 boolean
function BreakEntityGlass(entity, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) end

---@param p0 integer
---@param p1 any
---@param p2 boolean
function BreakObjectFragmentChild(p0, p1, p2) end

---@param vehicle integer
---@param wheelIndex integer
---@param leaveDebrisTrail boolean
---@param deleteWheel boolean
---@param unknownFlag boolean
---@param putOnFire boolean
function BreakOffVehicleWheel(vehicle, wheelIndex, leaveDebrisTrail, deleteWheel, unknownFlag, putOnFire) end

---@param vehicle integer
---@param distance number
---@param duration integer
---@param bControlVerticalVelocity boolean
function BringVehicleToHalt(vehicle, distance, duration, bControlVerticalVelocity) end

---@return boolean
function BusyspinnerIsDisplaying() end

---@return boolean
function BusyspinnerIsOn() end


function BusyspinnerOff() end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
function CalculateTravelDistanceBetweenPoints(x1, y1, z1, x2, y2, z2) end

---@param miniMap integer
---@param fnName string
---@return boolean
function CallMinimapScaleformFunction(miniMap, fnName) end

---@param scaleform integer
---@param method string
function CallScaleformMovieMethod(scaleform, method) end

---@param scaleform integer
---@param methodName string
---@param param1 number
---@param param2 number
---@param param3 number
---@param param4 number
---@param param5 number
function CallScaleformMovieMethodWithNumber(scaleform, methodName, param1, param2, param3, param4, param5) end

---@param scaleform integer
---@param methodName string
---@param floatParam1 number
---@param floatParam2 number
---@param floatParam3 number
---@param floatParam4 number
---@param floatParam5 number
---@param stringParam1 string
---@param stringParam2 string
---@param stringParam3 string
---@param stringParam4 string
---@param stringParam5 string
function CallScaleformMovieMethodWithNumberAndString(scaleform, methodName, floatParam1, floatParam2, floatParam3, floatParam4, floatParam5, stringParam1, stringParam2, stringParam3, stringParam4, stringParam5) end

---@param scaleform integer
---@param methodName string
---@param param1 string
---@param param2 string
---@param param3 string
---@param param4 string
---@param param5 string
function CallScaleformMovieMethodWithString(scaleform, methodName, param1, param2, param3, param4, param5) end

---@param boat integer
---@return boolean
function CanAnchorBoatHere(boat) end

---@param boat integer
---@return boolean
function CanAnchorBoatHereIgnorePlayers(boat) end

---@param cargobob integer
---@param entity integer
---@return boolean
function CanCargobobPickUpEntity(cargobob, entity) end

---@return boolean
function CanCreateRandomBikeRider() end

---@return boolean
function CanCreateRandomCops() end

---@return boolean
function CanCreateRandomDriver() end

---@param unk boolean
---@return boolean
function CanCreateRandomPed(unk) end

---@param ped integer
---@return boolean
function CanKnockPedOffVehicle(ped) end

---@return boolean
function CanPayGoon() end

---@param player integer
---@param ped integer
---@return boolean
function CanPedHearPlayer(player, ped) end

---@param ped integer
---@param target integer
---@return boolean
function CanPedInCombatSeeTarget(ped, target) end

---@param ped integer
---@return boolean
function CanPedRagdoll(ped) end

---@param ped1 integer
---@param ped2 integer
---@return boolean
function CanPedSeeHatedPed(ped1, ped2) end

---@return boolean
function CanPhoneBeSeenOnScreen() end

---@param player integer
---@return boolean
function CanPlayerStartMission(player) end

---@param ped_amt integer
---@param vehicle_amt integer
---@param object_amt integer
---@param pickup_amt integer
---@return boolean
function CanRegisterMissionEntities(ped_amt, vehicle_amt, object_amt, pickup_amt) end

---@param amount integer
---@return boolean
function CanRegisterMissionObjects(amount) end

---@param amount integer
---@return boolean
function CanRegisterMissionPeds(amount) end

---@param amount integer
---@return boolean
function CanRegisterMissionPickups(amount) end

---@param amount integer
---@return boolean
function CanRegisterMissionVehicles(amount) end

---@return boolean
function CanRequestAssetsForCutsceneEntity() end

---@param cutsceneEntName string
---@param modelHash integer | string
---@return boolean
function CanSetEnterStateForRegisteredEntity(cutsceneEntName, modelHash) end

---@param p0 boolean
---@return boolean
function CanSetExitStateForCamera(p0) end

---@param cutsceneEntName string
---@param modelHash integer | string
---@return boolean
function CanSetExitStateForRegisteredEntity(cutsceneEntName, modelHash) end

---@param vehicle integer
---@param seatIndex integer
---@return boolean
function CanShuffleSeat(vehicle, seatIndex) end

---@param weaponHash integer | string
---@return boolean
function CanUseWeaponOnParachute(weaponHash) end

---@param vehicle integer
---@return boolean
function CanVehicleReceiveCbRadio(vehicle) end


function CancelAllPoliceReports() end

---@param eventName string
---@return boolean
function CancelMusicEvent(eventName) end


function CancelOnscreenKeyboard() end


function CancelStuntJump() end

---@param interiorID integer
---@param toggle boolean
function CapInterior(interiorID, toggle) end


function CascadeShadowsClearShadowSampleType() end

---@param toggle boolean
function CascadeShadowsEnableEntityTracker(toggle) end


function CascadeShadowsInitSession() end

---@param p0 boolean
function CascadeShadowsSetAircraftMode(p0) end

---@param p0 any
---@param p1 boolean
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 boolean
---@param p7 number
function CascadeShadowsSetCascadeBounds(p0, p1, p2, p3, p4, p5, p6, p7) end

---@param p0 number
function CascadeShadowsSetCascadeBoundsScale(p0) end

---@param p0 boolean
function CascadeShadowsSetDynamicDepthMode(p0) end

---@param p0 number
function CascadeShadowsSetDynamicDepthValue(p0) end

---@param p0 number
function CascadeShadowsSetEntityTrackerScale(p0) end

---@param type string
function CascadeShadowsSetShadowSampleType(type) end

---@param value number
---@return integer
function Ceil(value) end

---@param active boolean
---@param bGoFirstPerson boolean
function CellCamActivate(active, bGoFirstPerson) end

---@param toggle boolean
function CellCamActivateSelfieMode(toggle) end

---@param entity integer
---@return boolean
function CellCamIsCharVisibleNoFaceCheck(entity) end

---@param direction integer
function CellCamMoveFinger(direction) end

---@param p0 number
function CellCamSetDistance(p0) end

---@param p0 number
function CellCamSetHeadHeight(p0) end

---@param p0 number
function CellCamSetHeadPitch(p0) end

---@param p0 number
function CellCamSetHeadRoll(p0) end

---@param p0 number
function CellCamSetHorizontalOffset(p0) end

---@param toggle boolean
function CellCamSetLean(toggle) end

---@param p0 number
function CellCamSetRoll(p0) end

---@param p0 number
function CellCamSetVerticalOffset(p0) end

---@param cash integer
---@param bank integer
function ChangeFakeMpCash(cash, bank) end

---@param player integer
---@param ped integer
---@param b2 boolean
---@param resetDamage boolean
function ChangePlayerPed(player, ped, b2, resetDamage) end

---@param minimum number
---@param maximum number
function ClampGameplayCamPitch(minimum, maximum) end

---@param minimum number
---@param maximum number
function ClampGameplayCamYaw(minimum, maximum) end

---@param p0 any
function CleanItemset(p0) end


function CleanupAsyncInstall() end

---@param p0 integer
---@param p1 boolean
function ClearAdditionalText(p0, p1) end


function ClearAllBlipRoutes() end


function ClearAllBrokenGlass() end


function ClearAllHelpMessages() end

---@param ped integer
function ClearAllPedProps(ped) end

---@param ped integer
function ClearAllPedVehicleForcedSeatUsage(ped) end

---@param zoneListName string
---@param forceUpdate boolean
function ClearAmbientZoneListState(zoneListName, forceUpdate) end

---@param zoneName string
---@param forceUpdate boolean
function ClearAmbientZoneState(zoneName, forceUpdate) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param p7 boolean
---@param p8 boolean
---@param p9 boolean
---@param p10 boolean
---@param p11 boolean
function ClearAngledAreaOfVehicles(x1, y1, z1, x2, y2, z2, width, p7, p8, p9, p10, p11) end

---@param X number
---@param Y number
---@param Z number
---@param radius number
---@param p4 boolean
---@param ignoreCopCars boolean
---@param ignoreObjects boolean
---@param p7 boolean
function ClearArea(X, Y, Z, radius, p4, ignoreCopCars, ignoreObjects, p7) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param p4 boolean
---@param p5 boolean
---@param p6 boolean
---@param p7 boolean
function ClearAreaLeaveVehicleHealth(x, y, z, radius, p4, p5, p6, p7) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param createNetEvent boolean
function ClearAreaOfCops(x, y, z, radius, createNetEvent) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param flags integer
function ClearAreaOfObjects(x, y, z, radius, flags) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param createNetEvent boolean
function ClearAreaOfPeds(x, y, z, radius, createNetEvent) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param createNetEvent boolean
function ClearAreaOfProjectiles(x, y, z, radius, createNetEvent) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param p4 boolean
---@param p5 boolean
---@param p6 boolean
---@param p7 boolean
---@param p8 boolean
function ClearAreaOfVehicles(x, y, z, radius, p4, p5, p6, p7, p8) end

---@param address integer
---@param offset integer
function ClearBit(address, offset) end


function ClearBrief() end


function ClearCloudHat() end

---@param radioStation string
function ClearCustomRadioTrackList(radioStation) end

---@param name integer | string
---@param eventType integer
function ClearDecisionMakerEventResponse(name, eventType) end


function ClearDrawOrigin() end

---@param ped integer
function ClearDrivebyTaskUnderneathDrivingTask(ped) end


function ClearDynamicPauseMenuErrorMessage() end

---@param entity integer
function ClearEntityLastDamageEntity(entity) end

---@param entity integer
function ClearEntityLastWeaponDamage(entity) end


function ClearExtraTimecycleModifier() end

---@param ped integer
function ClearFacialClipsetOverride(ped) end

---@param ped integer
function ClearFacialIdleAnimOverride(ped) end

---@param hudIndex integer
---@param p1 boolean
function ClearFloatingHelp(hudIndex, p1) end


function ClearFocus() end

---@param garageHash integer | string
---@param isNetwork boolean
function ClearGarageArea(garageHash, isNetwork) end


function ClearGpsCustomRoute() end

---@param index integer
function ClearGpsDisabledZoneAtIndex(index) end


function ClearGpsFlags() end


function ClearGpsMultiRoute() end


function ClearGpsPlayerWaypoint() end


function ClearGpsRaceTrack() end


function ClearHdArea() end

---@param toggle boolean
function ClearHelp(toggle) end

---@param entity integer
function ClearInteriorForEntity(entity) end


function ClearLastDrivenVehicle() end


function ClearLaunchParams() end

---@param vehicle integer
function ClearNitrous(vehicle) end

---@param garageHash integer | string
---@param vehicles boolean
---@param peds boolean
---@param objects boolean
---@param isNetwork boolean
function ClearObjectsInsideGarage(garageHash, vehicles, peds, objects, isNetwork) end


function ClearOverrideWeather() end

---@param ped integer
---@param stance integer
---@param p2 number
function ClearPedAlternateMovementAnim(ped, stance, p2) end

---@param ped integer
---@param p1 number
function ClearPedAlternateWalkAnim(ped, p1) end

---@param ped integer
function ClearPedBloodDamage(ped) end

---@param ped integer
---@param p1 integer
function ClearPedBloodDamageByZone(ped, p1) end

---@param ped integer
function ClearPedCoverClipsetOverride(ped) end

---@param ped integer
---@param p1 integer
---@param p2 string
function ClearPedDamageDecalByZone(ped, p1, p2) end

---@param ped integer
function ClearPedDecorations(ped) end

---@param ped integer
function ClearPedDecorationsLeaveScars(ped) end

---@param ped integer
function ClearPedDriveByClipsetOverride(ped) end

---@param ped integer
function ClearPedEnvDirt(ped) end


function ClearPedInPauseMenu() end

---@param ped integer
function ClearPedLastDamageBone(ped) end

---@param ped integer
function ClearPedLastWeaponDamage(ped) end


function ClearPedNonCreationArea() end

---@param ped integer
function ClearPedParachutePackVariation(ped) end

---@param ped integer
---@param propId integer
function ClearPedProp(ped, propId) end

---@param ped integer
function ClearPedScriptTaskIfRunningThreatResponseNonTempTask(ped) end

---@param ped integer
function ClearPedScubaGearVariation(ped) end

---@param ped integer
function ClearPedSecondaryTask(ped) end

---@param ped integer
function ClearPedStoredHatProp(ped) end

---@param ped integer
function ClearPedTasks(ped) end

---@param ped integer
function ClearPedTasksImmediately(ped) end

---@param ped integer
function ClearPedWetness(ped) end

---@param player integer
function ClearPlayerHasDamagedAtLeastOneNonAnimalPed(player) end

---@param player integer
function ClearPlayerHasDamagedAtLeastOnePed(player) end

---@param player integer
function ClearPlayerParachuteModelOverride(player) end

---@param player integer
function ClearPlayerParachutePackModelOverride(player) end

---@param player integer
function ClearPlayerParachuteVariationOverride(player) end

---@param player integer
function ClearPlayerReserveParachuteModelOverride(player) end

---@param player integer
function ClearPlayerWantedLevel(player) end

---@param scheduleId integer
function ClearPopscheduleOverrideVehicleModel(scheduleId) end


function ClearPrints() end


function ClearRaceGalleryBlips() end

---@param ped integer
---@param flags integer
function ClearRagdollBlockingFlags(ped, flags) end

---@param relationship integer
---@param group1 integer | string
---@param group2 integer | string
function ClearRelationshipBetweenGroups(relationship, group1, group2) end


function ClearReminderMessage() end


function ClearReplayStats() end


function ClearRestartCustomPosition() end

---@param entity integer
function ClearRoomForEntity(entity) end


function ClearRoomForGameViewport() end

---@param taskSequenceId integer
function ClearSequenceTask(taskSequenceId) end


function ClearSmallPrints() end


function ClearTacticalAnalysisPoints() end

---@param p0 string
function ClearThisPrint(p0) end


function ClearTimecycleModifier() end

---@param tvChannel integer
function ClearTvChannelPlaylist(tvChannel) end

---@param vehicle integer
function ClearVehicleCustomPrimaryColour(vehicle) end

---@param vehicle integer
function ClearVehicleCustomSecondaryColour(vehicle) end


function ClearVehicleGeneratorAreaOfInterest() end


function ClearVehiclePhoneExplosiveDevice() end

---@param vehicle integer
function ClearVehicleRouteHistory(vehicle) end

---@param vehicle integer
function ClearVehicleTasks(vehicle) end

---@param vehicle integer
function ClearVehicleXenonLightsCustomColor(vehicle) end

---@param transitionTimeInMs integer
function ClearWeatherTypeNowPersistNetwork(transitionTimeInMs) end


function ClearWeatherTypePersist() end

---@param ped integer
---@param isNetwork boolean
---@param bScriptHostPed boolean
---@param copyHeadBlendFlag boolean
---@return integer
function ClonePed(ped, isNetwork, bScriptHostPed, copyHeadBlendFlag) end

---@param ped integer
---@param heading number
---@param isNetwork boolean
---@param bScriptHostPed boolean
---@param p4 any
---@return integer
function ClonePedEx(ped, heading, isNetwork, bScriptHostPed, p4) end

---@param ped integer
---@param targetPed integer
function ClonePedToTarget(ped, targetPed) end

---@param ped integer
---@param targetPed integer
---@param p2 any
function ClonePedToTargetEx(ped, targetPed, p2) end

---@param sourceModifierName string
---@param clonedModifierName string
---@return integer
function CloneTimecycleModifier(sourceModifierName, clonedModifierName) end

---@param vehicle integer
function CloseBombBayDoors(vehicle) end


function CloseMultiplayerChat() end


function ClosePatrolRoute() end

---@param taskSequenceId integer
function CloseSequenceTask(taskSequenceId) end


function CloseSocialClubMenu() end


function CloudCheckAvailability() end

---@param p0 string
---@return integer
function CloudDeleteMemberFile(p0) end

---@param handle integer
---@return boolean
function CloudDidRequestSucceed(handle) end

---@return boolean
function CloudGetAvailabilityCheckResult() end

---@param handle integer
---@return boolean
function CloudHasRequestCompleted(handle) end

---@return boolean
function CloudIsCheckingAvailability() end

---@param tex integer
function CommitRuntimeTexture(tex) end

---@param str1 string
---@param str2 string
---@param matchCase boolean
---@param maxLength integer
---@return integer
function CompareStrings(str1, str2, matchCase, maxLength) end

---@param vehicle integer
---@param state integer
function ControlLandingGear(vehicle, state) end

---@param ped integer
---@return boolean
function ControlMountedWeapon(ped) end

---@param posixTime integer
---@return any
function ConvertPosixTime(posixTime) end

---@param src any
---@param size integer
---@return any
function CopyMemory(src, size) end

---@param sourceVehicle integer
---@param targetVehicle integer
function CopyVehicleDamages(sourceVehicle, targetVehicle) end

---@param value number
---@return number
function Cos(value) end

---@param srcCoord1X number
---@param srcCoord1Y number
---@param srcCoord1Z number
---@param srcCoord2X number
---@param srcCoord2Y number
---@param srcCoord2Z number
---@param fWidth number
---@param weaponPositionX number
---@param weaponPositionY number
---@param weaponPositionZ number
---@param weaponHash integer | string
---@return integer
function CreateAirDefenceAngledArea(srcCoord1X, srcCoord1Y, srcCoord1Z, srcCoord2X, srcCoord2Y, srcCoord2Z, fWidth, weaponPositionX, weaponPositionY, weaponPositionZ, weaponHash) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param weaponPositionX number
---@param weaponPositionY number
---@param weaponPositionZ number
---@param weaponHash integer | string
---@return integer
function CreateAirDefenceSphere(x, y, z, radius, weaponPositionX, weaponPositionY, weaponPositionZ, weaponHash) end

---@param pickupHash integer | string
---@param posX number
---@param posY number
---@param posZ number
---@param flags integer
---@param value integer
---@param modelHash integer | string
---@param returnHandle boolean
---@param p8 boolean
---@return integer
function CreateAmbientPickup(pickupHash, posX, posY, posZ, flags, value, modelHash, returnHandle, p8) end

---@param name string
---@return integer
function CreateAudioSubmix(name) end

---@param camName string
---@param active boolean
---@return integer
function CreateCam(camName, active) end

---@param camName string
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param fov number
---@param active boolean
---@param rotationOrder integer
---@return integer
function CreateCamWithParams(camName, posX, posY, posZ, rotX, rotY, rotZ, fov, active, rotationOrder) end

---@param camHash integer | string
---@param active boolean
---@return integer
function CreateCamera(camHash, active) end

---@param camHash integer | string
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param fov number
---@param active boolean
---@param rotationOrder integer
---@return integer
function CreateCameraWithParams(camHash, posX, posY, posZ, rotX, rotY, rotZ, fov, active, rotationOrder) end

---@param type integer
---@param posX1 number
---@param posY1 number
---@param posZ1 number
---@param posX2 number
---@param posY2 number
---@param posZ2 number
---@param diameter number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param reserved integer
---@return integer
function CreateCheckpoint(type, posX1, posY1, posZ1, posX2, posY2, posZ2, diameter, red, green, blue, alpha, reserved) end

---@param p0 any
---@param p1 integer
---@param p2 any
---@param entity integer
function CreateCinematicShot(p0, p1, p2, entity) end

---@param xMin number
---@param yMin number
---@param zMin number
---@param xMax number
---@param yMax number
---@param zMax number
---@return integer
function CreateDryVolume(xMin, yMin, zMin, xMax, yMax, zMax) end

---@param url string
---@param width integer
---@param height integer
---@return integer
function CreateDui(url, width, height) end

---@param ped integer
---@param username string
---@param crewIsPrivate boolean
---@param crewIsRockstar boolean
---@param crewName string
---@param crewRank integer
---@return integer
function CreateFakeMpGamerTag(ped, username, crewIsPrivate, crewIsRockstar, crewName, crewRank) end

---@param x number
---@param y number
---@param z number
---@param p3 any
---@param modelHash integer | string
---@param p5 boolean
function CreateForcedObject(x, y, z, p3, modelHash, p5) end

---@param unused integer
---@return integer
function CreateGroup(unused) end

---@param dispatchService integer
---@param x number
---@param y number
---@param z number
---@param numUnits integer
---@param radius number
---@return boolean, integer
function CreateIncident(dispatchService, x, y, z, numUnits, radius) end

---@param dispatchService integer
---@param ped integer
---@param numUnits integer
---@param radius number
---@return boolean, integer
function CreateIncidentWithEntity(dispatchService, ped, numUnits, radius) end

---@param distri boolean
---@return integer
function CreateItemset(distri) end

---@param variation integer
---@param x number
---@param y number
---@param z number
---@param direction boolean
---@return integer
function CreateMissionTrain(variation, x, y, z, direction) end

---@param phoneType integer
function CreateMobilePhone(phoneType) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param model integer | string
---@param surviveMapReload boolean
function CreateModelHide(x, y, z, radius, model, surviveMapReload) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param model integer | string
---@param surviveMapReload boolean
function CreateModelHideExcludingScriptObjects(x, y, z, radius, model, surviveMapReload) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param originalModel integer | string
---@param newModel integer | string
---@param bSurviveMapReload boolean
function CreateModelSwap(x, y, z, radius, originalModel, newModel, bSurviveMapReload) end

---@param x number
---@param y number
---@param z number
---@param value integer
---@param amount integer
---@param model integer | string
function CreateMoneyPickups(x, y, z, value, amount, model) end

---@param player integer
---@param username string
---@param crewIsPrivate boolean
---@param crewIsRockstar boolean
---@param crewName string
---@param crewRank integer
---@param crewR integer
---@param crewG integer
---@param crewB integer
function CreateMpGamerTagWithCrewColor(player, username, crewIsPrivate, crewIsRockstar, crewName, crewRank, crewR, crewG, crewB) end


function CreateNewScriptedConversation() end

---@param startImmediately boolean
---@param messageId integer
function CreateNmMessage(startImmediately, messageId) end

---@param pickupHash any
---@param posX number
---@param posY number
---@param posZ number
---@param flags integer
---@param value integer
---@param modelHash any
---@param p7 boolean
---@param p8 boolean
---@return any
function CreateNonNetworkedAmbientPickup(pickupHash, posX, posY, posZ, flags, value, modelHash, p7, p8) end

---@param pickupHash integer | string
---@param x number
---@param y number
---@param z number
---@param placeOnGround boolean
---@param modelHash integer | string
---@return integer
function CreateNonNetworkedPortablePickup(pickupHash, x, y, z, placeOnGround, modelHash) end

---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param isNetwork boolean
---@param netMissionEntity boolean
---@param doorFlag boolean
---@return integer
function CreateObject(modelHash, x, y, z, isNetwork, netMissionEntity, doorFlag) end

---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param isNetwork boolean
---@param netMissionEntity boolean
---@param doorFlag boolean
---@return integer
function CreateObjectNoOffset(modelHash, x, y, z, isNetwork, netMissionEntity, doorFlag) end

---@param ped integer
---@param p1 boolean
---@param p2 boolean
---@return integer
function CreateParachuteBagObject(ped, p1, p2) end


function CreatePatrolRoute() end

---@param pedType integer
---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param heading number
---@param isNetwork boolean
---@param bScriptHostPed boolean
---@return integer
function CreatePed(pedType, modelHash, x, y, z, heading, isNetwork, bScriptHostPed) end

---@param vehicle integer
---@param pedType integer
---@param modelHash integer | string
---@param seat integer
---@param isNetwork boolean
---@param bScriptHostPed boolean
---@return integer
function CreatePedInsideVehicle(vehicle, pedType, modelHash, seat, isNetwork, bScriptHostPed) end

---@param cargobob integer
---@param state integer
function CreatePickUpRopeForCargobob(cargobob, state) end

---@param pickupHash integer | string
---@param posX number
---@param posY number
---@param posZ number
---@param p4 integer
---@param value integer
---@param p6 boolean
---@param modelHash integer | string
---@return integer
function CreatePickup(pickupHash, posX, posY, posZ, p4, value, p6, modelHash) end

---@param pickupHash integer | string
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param flag integer
---@param amount integer
---@param p9 any
---@param p10 boolean
---@param modelHash integer | string
---@return integer
function CreatePickupRotate(pickupHash, posX, posY, posZ, rotX, rotY, rotZ, flag, amount, p9, p10, modelHash) end

---@param pickupHash integer | string
---@param x number
---@param y number
---@param z number
---@param placeOnGround boolean
---@param modelHash integer | string
---@return integer
function CreatePortablePickup(pickupHash, x, y, z, placeOnGround, modelHash) end

---@param posX number
---@param posY number
---@param posZ number
---@return integer
function CreateRandomPed(posX, posY, posZ) end

---@param vehicle integer
---@param returnHandle boolean
---@return integer
function CreateRandomPedAsDriver(vehicle, returnHandle) end

---@param txd integer
---@param txn string
---@param width integer
---@param height integer
---@return integer
function CreateRuntimeTexture(txd, txn, width, height) end

---@param txd integer
---@param txn string
---@param duiHandle string
---@return integer
function CreateRuntimeTextureFromDuiHandle(txd, txn, duiHandle) end

---@param txd integer
---@param txn string
---@param fileName string
---@return integer
function CreateRuntimeTextureFromImage(txd, txn, fileName) end

---@param name string
---@return integer
function CreateRuntimeTxd(name) end

---@param x number
---@param y number
---@param z number
---@param heading number
---@param p4 number
---@param p5 number
---@param modelHash integer | string
---@param p7 integer
---@param p8 integer
---@param p9 integer
---@param p10 integer
---@param p11 boolean
---@param p12 boolean
---@param p13 boolean
---@param p14 boolean
---@param p15 boolean
---@param p16 integer
---@return integer
function CreateScriptVehicleGenerator(x, y, z, heading, p4, p5, modelHash, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16) end

---@param x number
---@param y number
---@param z number
---@param roll number
---@param pitch number
---@param yaw number
---@param p6 integer
---@return integer
function CreateSynchronizedScene(x, y, z, roll, pitch, yaw, p6) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param object integer | string
---@return integer
function CreateSynchronizedScene_2(x, y, z, radius, object) end

---@param modifierName string
---@return integer
function CreateTimecycleModifier(modifierName) end

---@return integer
function CreateTrackedPoint() end

---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param heading number
---@param isNetwork boolean
---@param netMissionEntity boolean
---@return integer
function CreateVehicle(modelHash, x, y, z, heading, isNetwork, netMissionEntity) end

---@param weaponHash integer | string
---@param ammoCount integer
---@param x number
---@param y number
---@param z number
---@param bCreateDefaultComponents boolean
---@param scale number
---@param customModelHash integer
---@return integer
function CreateWeaponObject(weaponHash, ammoCount, x, y, z, bCreateDefaultComponents, scale, customModelHash) end

---@param p0 number
function CustomMenuCoordinates(p0) end

---@param value boolean
---@return any
function DataarrayAddBool(value) end

---@return any, any
function DataarrayAddDict() end

---@param value number
---@return any
function DataarrayAddFloat(value) end

---@param value integer
---@return any
function DataarrayAddInt(value) end

---@param value string
---@return any
function DataarrayAddString(value) end

---@param valueX number
---@param valueY number
---@param valueZ number
---@return any
function DataarrayAddVector(valueX, valueY, valueZ) end

---@param arrayIndex integer
---@return boolean, any
function DataarrayGetBool(arrayIndex) end

---@return integer, any
function DataarrayGetCount() end

---@param arrayIndex integer
---@return any, any
function DataarrayGetDict(arrayIndex) end

---@param arrayIndex integer
---@return number, any
function DataarrayGetFloat(arrayIndex) end

---@param arrayIndex integer
---@return integer, any
function DataarrayGetInt(arrayIndex) end

---@param arrayIndex integer
---@return string, any
function DataarrayGetString(arrayIndex) end

---@param arrayIndex integer
---@return integer, any
function DataarrayGetType(arrayIndex) end

---@param arrayIndex integer
---@return vector3, any
function DataarrayGetVector(arrayIndex) end

---@param key string
---@return any, any
function DatadictCreateArray(key) end

---@param key string
---@return any, any
function DatadictCreateDict(key) end

---@param key string
---@return any, any
function DatadictGetArray(key) end

---@param key string
---@return boolean, any
function DatadictGetBool(key) end

---@param key string
---@return any, any
function DatadictGetDict(key) end

---@param key string
---@return number, any
function DatadictGetFloat(key) end

---@param key string
---@return integer, any
function DatadictGetInt(key) end

---@param key string
---@return string, any
function DatadictGetString(key) end

---@param key string
---@return integer, any
function DatadictGetType(key) end

---@param key string
---@return vector3, any
function DatadictGetVector(key) end

---@param key string
---@param value boolean
---@return any
function DatadictSetBool(key, value) end

---@param key string
---@param value number
---@return any
function DatadictSetFloat(key, value) end

---@param key string
---@param value integer
---@return any
function DatadictSetInt(key, value) end

---@param key string
---@param value string
---@return any
function DatadictSetString(key, value) end

---@param key string
---@param valueX number
---@param valueY number
---@param valueZ number
---@return any
function DatadictSetVector(key, valueX, valueY, valueZ) end


function DatafileClearWatchList() end


function DatafileCreate() end


function DatafileDelete() end

---@param p0 any
---@return boolean
function DatafileDeleteRequestedFile(p0) end


function DatafileFlushMissionHeader() end

---@return string
function DatafileGetFileDict() end

---@param p0 any
---@return boolean
function DatafileHasLoadedFileData(p0) end

---@param p0 any
---@return boolean
function DatafileHasValidFileData(p0) end

---@return boolean
function DatafileIsSavePending() end

---@param index integer
---@return boolean
function DatafileIsValidRequestId(index) end

---@param filename string
---@return boolean
function DatafileLoadOfflineUgc(filename) end

---@param p0 any
---@return boolean
function DatafileSelectActiveFile(p0) end

---@param p0 integer
---@return boolean
function DatafileSelectCreatorStats(p0) end

---@param p0 integer
---@return boolean
function DatafileSelectUgcData(p0) end

---@param p0 integer
---@return boolean
function DatafileSelectUgcPlayerData(p0) end

---@param p0 integer
---@param p1 boolean
---@return boolean
function DatafileSelectUgcStats(p0, p1) end

---@param filename string
---@return boolean
function DatafileStartSaveToCloud(filename) end


function DatafileStoreMissionHeader() end

---@return boolean, boolean
function DatafileUpdateSaveToCloud() end

---@param id integer
function DatafileWatchRequestId(id) end

---@param mode string
function DeactivateAudioSlowmoMode(mode) end

---@param interior integer
---@param entitySetName string
function DeactivateInteriorEntitySet(interior, entitySetName) end

---@param entity integer
---@param propertyName string
---@return boolean
function DecorExistOn(entity, propertyName) end

---@param entity integer
---@param propertyName string
---@return boolean
function DecorGetBool(entity, propertyName) end

---@param entity integer
---@param propertyName string
---@return number
function DecorGetFloat(entity, propertyName) end

---@param entity integer
---@param propertyName string
---@return integer
function DecorGetInt(entity, propertyName) end

---@param propertyName string
---@param type integer
---@return boolean
function DecorIsRegisteredAsType(propertyName, type) end

---@param propertyName string
---@param type integer
function DecorRegister(propertyName, type) end


function DecorRegisterLock() end

---@param entity integer
---@param propertyName string
---@return boolean
function DecorRemove(entity, propertyName) end

---@param entity integer
---@param propertyName string
---@param value boolean
---@return boolean
function DecorSetBool(entity, propertyName, value) end

---@param entity integer
---@param propertyName string
---@param value number
---@return boolean
function DecorSetFloat(entity, propertyName, value) end

---@param entity integer
---@param propertyName string
---@param value integer
---@return boolean
function DecorSetInt(entity, propertyName, value) end

---@param entity integer
---@param propertyName string
---@param timestamp integer
---@return boolean
function DecorSetTime(entity, propertyName, timestamp) end


function DeleteAllTrains() end

---@param checkpoint integer
function DeleteCheckpoint(checkpoint) end

---@param ropeId integer
function DeleteChildRope(ropeId) end

---@param entity integer
function DeleteEntity(entity) end

---@param incidentId integer
function DeleteIncident(incidentId) end

---@param train integer
function DeleteMissionTrain(train) end

---@param object integer
function DeleteObject(object) end

---@param patrolRoute string
function DeletePatrolRoute(patrolRoute) end

---@param ped integer
function DeletePed(ped) end

---@param ropeId integer
function DeleteRope(ropeId) end

---@param vehicleGenerator integer
function DeleteScriptVehicleGenerator(vehicleGenerator) end

---@param p0 integer
function DeleteStuntJump(p0) end

---@param vehicle integer
function DeleteVehicle(vehicle) end


function DeleteWaypointsFromThisPlayer() end

---@param amount integer
---@return boolean
function DepositVc(amount) end

---@param bScriptHostCam boolean
function DestroyAllCams(bScriptHostCam) end

---@param cam integer
---@param bScriptHostCam boolean
function DestroyCam(cam, bScriptHostCam) end

---@param duiObject integer
function DestroyDui(duiObject) end

---@param p0 any
function DestroyItemset(p0) end


function DestroyMobilePhone() end

---@param point integer
function DestroyTrackedPoint(point) end

---@param cam integer
function DetachCam(cam) end

---@param vehicle integer
function DetachContainerFromHandlerFrame(vehicle) end

---@param entity integer
---@param dynamic boolean
---@param collision boolean
function DetachEntity(entity, dynamic, collision) end

---@param vehicle integer
---@param entity integer
---@return any
function DetachEntityFromCargobob(vehicle, entity) end

---@param pickupObject integer
function DetachPortablePickupFromPed(pickupObject) end

---@param ropeId integer
---@param entity integer
function DetachRopeFromEntity(ropeId, entity) end

---@param sceneID integer
function DetachSynchronizedScene(sceneID) end

---@param vehicle integer
---@return boolean
function DetachVehicleFromAnyCargobob(vehicle) end

---@param vehicle integer
---@return boolean
function DetachVehicleFromAnyTowTruck(vehicle) end

---@param cargobob integer
---@param vehicle integer
function DetachVehicleFromCargobob(cargobob, vehicle) end

---@param towTruck integer
---@param vehicle integer
function DetachVehicleFromTowTruck(towTruck, vehicle) end

---@param vehicle integer
function DetachVehicleFromTrailer(vehicle) end


function DetonateVehiclePhoneExplosiveDevice() end


function DisableAimCamThisUpdate() end

---@param padIndex integer
function DisableAllControlActions(padIndex) end

---@param entity integer
function DisableCamCollisionForEntity(entity) end

---@param entity integer
function DisableCamCollisionForObject(entity) end


function DisableCinematicBonnetCameraThisUpdate() end

---@param padIndex integer
---@param control integer
---@param disable boolean
function DisableControlAction(padIndex, control, disable) end


function DisableEditorRuntime() end


function DisableFrontendThisFrame() end

---@param ped integer
function DisableHeadBlendPaletteColor(ped) end

---@param hospitalIndex integer
---@param toggle boolean
function DisableHospitalRestart(hospitalIndex, toggle) end

---@param state boolean
function DisableIdleCamera(state) end

---@param vehicle integer
---@param propeller integer
function DisableIndividualPlanePropeller(vehicle, propeller) end

---@param padIndex integer
function DisableInputGroup(padIndex) end

---@param interiorID integer
---@param toggle boolean
function DisableInterior(interiorID, toggle) end


function DisableMoonCycleOverride() end

---@param disable boolean
function DisableMultiplayerChat(disable) end

---@param posMinX number
---@param posMinY number
---@param posMinZ number
---@param posMaxX number
---@param posMaxY number
---@param posMaxZ number
---@param bDisable boolean
function DisableNavmeshInArea(posMinX, posMinY, posMinZ, posMaxX, posMaxY, posMaxZ, bDisable) end


function DisableOcclusionThisFrame() end


function DisableOnFootFirstPersonViewThisUpdate() end

---@param ped integer
function DisablePedHeatscaleOverride(ped) end

---@param ped integer
---@param shouldDisable boolean
function DisablePedPainAudio(ped, shouldDisable) end

---@param vehicle integer
---@param p1 boolean
---@param p2 boolean
function DisablePlaneAileron(vehicle, p1, p2) end

---@param player integer
---@param toggle boolean
function DisablePlayerFiring(player, toggle) end

---@param player integer
function DisablePlayerVehicleRewards(player) end

---@param policeIndex integer
---@param toggle boolean
function DisablePoliceRestart(policeIndex, toggle) end

---@param rawKeyIndex integer
---@return boolean
function DisableRawKeyThisFrame(rawKeyIndex) end


function DisableRockstarEditorCameraChanges() end


function DisableScreenblurFade() end

---@param p0 any
function DisableScriptAmbientEffects(p0) end

---@param brainSet integer
function DisableScriptBrainSet(brainSet) end

---@param p0 integer
function DisableStuntJumpSet(p0) end


function DisableSwitchOutroFx() end

---@param toggle boolean
function DisableVehicleDistantlights(toggle) end

---@param vehicle integer
---@param toggle boolean
function DisableVehicleNeonLights(vehicle, toggle) end

---@param state boolean
function DisableVehiclePassengerIdleCamera(state) end

---@param vehicle integer
function DisableVehicleTurretMovementThisFrame(vehicle) end

---@param disabled boolean
---@param weaponHash integer | string
---@param vehicle integer
---@param owner integer
function DisableVehicleWeapon(disabled, weaponHash, vehicle, owner) end

---@param vehicle integer
function DisableVehicleWorldCollision(vehicle) end

---@param state boolean
function DisableWorldhorizonRendering(state) end

---@param display boolean
function DisplayAmmoThisFrame(display) end

---@param toggle boolean
function DisplayAreaName(toggle) end

---@param display boolean
function DisplayCash(display) end

---@param pTextLabel string
---@param bCurvedWindow boolean
function DisplayHelpTextThisFrame(pTextLabel, bCurvedWindow) end

---@param toggle boolean
function DisplayHud(toggle) end


function DisplayHudWhenDeadThisFrame() end


function DisplayHudWhenPausedThisFrame() end

---@param keyboardType integer
---@param windowTitle string
---@param description string
---@param defaultText string
---@param defaultConcat1 string
---@param defaultConcat2 string
---@param defaultConcat3 string
---@param maxInputLength integer
function DisplayOnscreenKeyboard(keyboardType, windowTitle, description, defaultText, defaultConcat1, defaultConcat2, defaultConcat3, maxInputLength) end

---@param keyboardType integer
---@param windowTitle string
---@param description string
---@param defaultText string
---@param defaultConcat1 string
---@param defaultConcat2 string
---@param defaultConcat3 string
---@param defaultConcat4 string
---@param defaultConcat5 string
---@param defaultConcat6 string
---@param defaultConcat7 string
---@param maxInputLength integer
function DisplayOnscreenKeyboardWithLongerInitialString(keyboardType, windowTitle, description, defaultText, defaultConcat1, defaultConcat2, defaultConcat3, defaultConcat4, defaultConcat5, defaultConcat6, defaultConcat7, maxInputLength) end

---@param toggle boolean
function DisplayPlayerNameTagsOnBlips(toggle) end

---@param toggle boolean
function DisplayRadar(toggle) end


function DisplaySniperScopeThisFrame() end

---@param unk boolean
function DisplaySystemSigninUi(unk) end

---@param shouldPlay boolean
function DistantCopCarSirens(shouldPlay) end


function DoAutoSave() end

---@param duration integer
function DoScreenFadeIn(duration) end

---@param duration integer
function DoScreenFadeOut(duration) end

---@param zoneId integer
---@return boolean
function DoesAirDefenseZoneExist(zoneId) end

---@param animDict string
---@return boolean
function DoesAnimDictExist(animDict) end

---@param blip integer
---@return boolean
function DoesBlipExist(blip) end

---@param blip integer
---@return boolean
function DoesBlipHaveGpsRoute(blip) end

---@param cam integer
---@return boolean
function DoesCamExist(cam) end

---@param cargobob integer
---@return boolean
function DoesCargobobHavePickUpRope(cargobob) end

---@param cargobob integer
---@return boolean
function DoesCargobobHavePickupMagnet(cargobob) end

---@param ped integer
---@param speechName string
---@param allowBackupPVGs boolean
---@return boolean
function DoesContextExistForThisPed(ped, speechName, allowBackupPVGs) end

---@param cutsceneEntName string
---@param modelHash integer | string
---@return boolean
function DoesCutsceneEntityExist(cutsceneEntName, modelHash) end

---@param entity integer
---@param p2 boolean
---@return boolean
function DoesEntityBelongToThisScript(entity, p2) end

---@param entity integer
---@return boolean
function DoesEntityExist(entity) end

---@param entity integer
---@return boolean
function DoesEntityHaveAnimDirector(entity) end

---@param entity integer
---@return boolean
function DoesEntityHaveDrawable(entity) end

---@param entity integer
---@return boolean
function DoesEntityHavePhysics(entity) end

---@param entity integer
---@return boolean
function DoesEntityHaveSkeletonData(entity) end

---@param vehicle integer
---@param extraId integer
---@return boolean
function DoesExtraExist(vehicle, extraId) end

---@param groupId integer
---@return boolean
function DoesGroupExist(groupId) end

---@param briefValue integer
---@return boolean
function DoesLatestBriefStringExist(briefValue) end

---@param p0 any
---@return boolean
function DoesNavmeshBlockingObjectExist(p0) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param hash integer | string
---@param p5 boolean
---@return boolean
function DoesObjectOfTypeExistAtCoords(x, y, z, radius, hash, p5) end

---@param ptfxHandle integer
---@return boolean
function DoesParticleFxLoopedExist(ptfxHandle) end

---@param ped integer
---@return boolean
function DoesPedHaveAiBlip(ped) end

---@param pickup integer
---@return boolean
function DoesPickupExist(pickup) end

---@param pickupObject integer
---@return boolean
function DoesPickupObjectExist(pickupObject) end

---@param pickupHash integer | string
---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function DoesPickupOfTypeExistInArea(pickupHash, x, y, z, radius) end

---@return boolean
function DoesPlayerVehHaveRadio() end

---@param id integer
---@return boolean
function DoesPopMultiplierAreaExist(id) end

---@param id integer
---@return boolean
function DoesPopMultiplierSphereExist(id) end

---@param object integer
---@return boolean
function DoesRayfireMapObjectExist(object) end

---@param groupHash integer | string
---@return boolean
function DoesRelationshipGroupExist(groupHash) end

---@param ropeId integer
---@return boolean
function DoesRopeBelongToThisScript(ropeId) end

---@param ropeId integer
---@return boolean
function DoesRopeExist(ropeId) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean
function DoesScenarioBlockingAreaExist(x1, y1, z1, x2, y2, z2) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param b boolean
---@return boolean
function DoesScenarioExistInArea(x, y, z, radius, b) end

---@param scenarioGroup string
---@return boolean
function DoesScenarioGroupExist(scenarioGroup) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 string
---@param p4 number
---@param p5 boolean
---@return boolean
function DoesScenarioOfTypeExistInArea(p0, p1, p2, p3, p4, p5) end

---@param scriptName string
---@return boolean
function DoesScriptExist(scriptName) end

---@param vehicleGenerator integer
---@return boolean
function DoesScriptVehicleGeneratorExist(vehicleGenerator) end

---@param scriptHash integer | string
---@return boolean
function DoesScriptWithNameHashExist(scriptHash) end

---@param x number
---@param y number
---@param z number
---@return boolean
function DoesScriptedCoverPointExistAtCoords(x, y, z) end

---@param componentHash integer | string
---@param restrictionTagHash integer | string
---@param componentId integer
---@return boolean
function DoesShopPedApparelHaveRestrictionTag(componentHash, restrictionTagHash, componentId) end

---@param gxt string
---@return boolean
function DoesTextBlockExist(gxt) end

---@param gxt string
---@return boolean
function DoesTextLabelExist(gxt) end

---@param textureId integer
---@return boolean
function DoesTextureExist(textureId) end

---@param modifierName string
---@param varName string
---@return boolean
function DoesTimecycleModifierHasVar(modifierName, varName) end

---@param vehicle integer
---@return boolean
function DoesVehicleAllowRappel(vehicle) end

---@param decorator string
---@return boolean
function DoesVehicleExistWithDecorator(decorator) end

---@param vehicle integer
---@param p1 integer
---@return boolean
function DoesVehicleHaveCrewEmblem(vehicle, p1) end

---@param vehicle integer
---@return boolean
function DoesVehicleHaveLandingGear(vehicle) end

---@param vehicle integer
---@return boolean
function DoesVehicleHaveRoof(vehicle) end

---@param vehicle integer
---@return boolean
function DoesVehicleHaveSearchlight(vehicle) end

---@param vehicle integer
---@return boolean
function DoesVehicleHaveStuckVehicleCheck(vehicle) end

---@param vehicle integer
---@return boolean
function DoesVehicleHaveWeapons(vehicle) end

---@param vehicle integer
---@param tyreIndex integer
---@return boolean
function DoesVehicleTyreExist(vehicle, tyreIndex) end

---@param vehicle integer
---@return boolean
function DoesVehicleUseFuel(vehicle) end

---@param weaponHash integer | string
---@param componentHash integer | string
---@return boolean
function DoesWeaponTakeWeaponComponent(weaponHash, componentHash) end

---@param p0 boolean
function DontRenderInGameUi(p0) end


function DontTiltMinimapThisFrame() end

---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param locked boolean
---@param xRotMult number
---@param yRotMult number
---@param zRotMult number
function DoorControl(modelHash, x, y, z, locked, xRotMult, yRotMult, zRotMult) end

---@param x number
---@param y number
---@param z number
---@param modelHash integer | string
---@return boolean, integer
function DoorSystemFindExistingDoor(x, y, z, modelHash) end

---@return table
function DoorSystemGetActive() end

---@param doorHash integer | string
---@return number
function DoorSystemGetAutomaticDistance(doorHash) end

---@param doorHash integer | string
---@return integer
function DoorSystemGetDoorPendingState(doorHash) end

---@param doorHash integer | string
---@return integer
function DoorSystemGetDoorState(doorHash) end

---@param doorHash integer | string
---@return boolean
function DoorSystemGetIsPhysicsLoaded(doorHash) end

---@param doorHash integer | string
---@return number
function DoorSystemGetOpenRatio(doorHash) end

---@return integer
function DoorSystemGetSize() end

---@param doorHash integer | string
---@param distance number
---@param requestDoor boolean
---@param forceUpdate boolean
function DoorSystemSetAutomaticDistance(doorHash, distance, requestDoor, forceUpdate) end

---@param doorHash integer | string
---@param rate number
---@param requestDoor boolean
---@param forceUpdate boolean
function DoorSystemSetAutomaticRate(doorHash, rate, requestDoor, forceUpdate) end

---@param doorHash integer | string
---@param state integer
---@param requestDoor boolean
---@param forceUpdate boolean
function DoorSystemSetDoorState(doorHash, state, requestDoor, forceUpdate) end

---@param doorHash integer | string
---@param toggle boolean
function DoorSystemSetHoldOpen(doorHash, toggle) end

---@param doorHash integer | string
---@param ajar number
---@param requestDoor boolean
---@param forceUpdate boolean
function DoorSystemSetOpenRatio(doorHash, ajar, requestDoor, forceUpdate) end

---@param doorHash integer | string
---@param removed boolean
---@param requestDoor boolean
---@param forceUpdate boolean
function DoorSystemSetSpringRemoved(doorHash, removed, requestDoor, forceUpdate) end

---@param binkMovie integer
---@param posX number
---@param posY number
---@param scaleX number
---@param scaleY number
---@param rotation number
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function DrawBinkMovie(binkMovie, posX, posY, scaleX, scaleY, rotation, r, g, b, a) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawBox(x1, y1, z1, x2, y2, z2, red, green, blue, alpha) end

---@param posX number
---@param posY number
---@param posZ number
---@param size number
---@param alpha integer
---@param red integer
---@param green integer
---@param blue integer
---@param intensity number
---@param zBias number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param viewThreshold number
---@param innerAngle number
---@param outerAngle number
---@param flags integer
function DrawCorona(posX, posY, posZ, size, alpha, red, green, blue, intensity, zBias, dirX, dirY, dirZ, viewThreshold, innerAngle, outerAngle, flags) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function DrawDebugBox(x1, y1, z1, x2, y2, z2, r, g, b, a) end

---@param x number
---@param y number
---@param z number
---@param size number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawDebugCross(x, y, z, size, red, green, blue, alpha) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function DrawDebugLine(x1, y1, z1, x2, y2, z2, r, g, b, a) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param r1 integer
---@param g1 integer
---@param b1 integer
---@param r2 integer
---@param g2 integer
---@param b2 integer
---@param alpha1 integer
---@param alpha2 integer
function DrawDebugLineWithTwoColours(x1, y1, z1, x2, y2, z2, r1, g1, b1, r2, g2, b2, alpha1, alpha2) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawDebugSphere(x, y, z, radius, red, green, blue, alpha) end

---@param text string
---@param x number
---@param y number
---@param z number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawDebugText(text, x, y, z, red, green, blue, alpha) end

---@param text string
---@param x number
---@param y number
---@param z number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawDebugText_2d(text, x, y, z, red, green, blue, alpha) end

---@param matrixPtr integer
---@param id string
---@return boolean
function DrawGizmo(matrixPtr, id) end

---@param posX number
---@param posY number
---@param posZ number
---@param radius number
---@param colorR integer
---@param colorG integer
---@param colorB integer
---@param intensity number
---@param invert boolean
---@param marker boolean
function DrawGlowSphere(posX, posY, posZ, radius, colorR, colorG, colorB, intensity, invert, marker) end


function DrawHudOverFadeThisFrame() end

---@param textureDict string
---@param textureName string
---@param screenX number
---@param screenY number
---@param width number
---@param height number
---@param heading number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawInteractiveSprite(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha) end


function DrawLight() end

---@param posX number
---@param posY number
---@param posZ number
---@param colorR integer
---@param colorG integer
---@param colorB integer
---@param range number
---@param intensity number
function DrawLightWithRange(posX, posY, posZ, colorR, colorG, colorB, range, intensity) end

---@param x number
---@param y number
---@param z number
---@param r integer
---@param g integer
---@param b integer
---@param range number
---@param intensity number
---@param shadow number
function DrawLightWithRangeAndShadow(x, y, z, r, g, b, range, intensity, shadow) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawLine(x1, y1, z1, x2, y2, z2, red, green, blue, alpha) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param width number
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function DrawLine_2d(x1, y1, x2, y2, width, r, g, b, a) end

---@param p0 boolean
---@param p1 boolean
function DrawLowQualityPhotoToPhone(p0, p1) end

---@param type integer
---@param posX number
---@param posY number
---@param posZ number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param bobUpAndDown boolean
---@param faceCamera boolean
---@param rotationOrder integer
---@param rotate boolean
---@param textureDict string
---@param textureName string
---@param drawOnEnts boolean
function DrawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, rotationOrder, rotate, textureDict, textureName, drawOnEnts) end

---@param type integer
---@param posX number
---@param posY number
---@param posZ number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param bobUpAndDown boolean
---@param faceCamera boolean
---@param rotationOrder integer
---@param rotate boolean
---@param textureDict string
---@param textureName string
---@param drawOnEnts boolean
---@param p24 boolean
function DrawMarker_2(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, red, green, blue, alpha, bobUpAndDown, faceCamera, rotationOrder, rotate, textureDict, textureName, drawOnEnts, p24) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param x3 number
---@param y3 number
---@param z3 number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawPoly(x1, y1, z1, x2, y2, z2, x3, y3, z3, red, green, blue, alpha) end

---@param x number
---@param y number
---@param width number
---@param height number
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function DrawRect(x, y, width, height, r, g, b, a) end

---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation number
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function DrawRectRotated(x, y, width, height, rotation, r, g, b, a) end

---@param scaleformHandle integer
---@param x number
---@param y number
---@param width number
---@param height number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param unk integer
function DrawScaleformMovie(scaleformHandle, x, y, width, height, red, green, blue, alpha, unk) end

---@param scaleform integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param unk integer
function DrawScaleformMovieFullscreen(scaleform, red, green, blue, alpha, unk) end

---@param scaleform1 integer
---@param scaleform2 integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawScaleformMovieFullscreenMasked(scaleform1, scaleform2, red, green, blue, alpha) end

---@param scaleform integer
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param p7 number
---@param sharpness number
---@param p9 number
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@param p13 any
function DrawScaleformMovie_3d(scaleform, posX, posY, posZ, rotX, rotY, rotZ, p7, sharpness, p9, scaleX, scaleY, scaleZ, p13) end

---@param scaleform integer
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param p7 number
---@param p8 number
---@param p9 number
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@param p13 any
function DrawScaleformMovie_3dSolid(scaleform, posX, posY, posZ, rotX, rotY, rotZ, p7, p8, p9, scaleX, scaleY, scaleZ, p13) end

---@param p0 string
---@param ped integer
---@param p2 integer
---@param posX number
---@param posY number
---@param posZ number
---@return boolean
function DrawShowroom(p0, ped, p2, posX, posY, posZ) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param r integer
---@param g integer
---@param b integer
---@param opacity number
function DrawSphere(x, y, z, radius, r, g, b, opacity) end

---@param posX number
---@param posY number
---@param posZ number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param colorR integer
---@param colorG integer
---@param colorB integer
---@param distance number
---@param brightness number
---@param hardness number
---@param radius number
---@param falloff number
function DrawSpotLight(posX, posY, posZ, dirX, dirY, dirZ, colorR, colorG, colorB, distance, brightness, hardness, radius, falloff) end

---@param posX number
---@param posY number
---@param posZ number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param colorR integer
---@param colorG integer
---@param colorB integer
---@param distance number
---@param brightness number
---@param roundness number
---@param radius number
---@param falloff number
---@param shadowId integer
function DrawSpotLightWithShadow(posX, posY, posZ, dirX, dirY, dirZ, colorR, colorG, colorB, distance, brightness, roundness, radius, falloff, shadowId) end

---@param textureDict string
---@param textureName string
---@param screenX number
---@param screenY number
---@param width number
---@param height number
---@param heading number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawSprite(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param x3 number
---@param y3 number
---@param z3 number
---@param red1 number
---@param green1 number
---@param blue1 number
---@param alpha1 integer
---@param red2 number
---@param green2 number
---@param blue2 number
---@param alpha2 integer
---@param red3 number
---@param green3 number
---@param blue3 number
---@param alpha3 integer
---@param textureDict string
---@param textureName string
---@param u1 number
---@param v1 number
---@param w1 number
---@param u2 number
---@param v2 number
---@param w2 number
---@param u3 number
---@param v3 number
---@param w3 number
function DrawSpritePoly_2(x1, y1, z1, x2, y2, z2, x3, y3, z3, red1, green1, blue1, alpha1, red2, green2, blue2, alpha2, red3, green3, blue3, alpha3, textureDict, textureName, u1, v1, w1, u2, v2, w2, u3, v3, w3) end

---@param textureDict string
---@param textureName string
---@param x number
---@param y number
---@param width number
---@param height number
---@param u1 number
---@param v1 number
---@param u2 number
---@param v2 number
---@param heading number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawSpriteUv(textureDict, textureName, x, y, width, height, u1, v1, u2, v2, heading, red, green, blue, alpha) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param x3 number
---@param y3 number
---@param z3 number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param textureDict string
---@param textureName string
---@param u1 number
---@param v1 number
---@param w1 number
---@param u2 number
---@param v2 number
---@param w2 number
---@param u3 number
---@param v3 number
---@param w3 number
function DrawTexturedPoly(x1, y1, z1, x2, y2, z2, x3, y3, z3, red, green, blue, alpha, textureDict, textureName, u1, v1, w1, u2, v2, w2, u3, v3, w3) end

---@param xPos number
---@param yPos number
---@param xScale number
---@param yScale number
---@param rotation number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function DrawTvChannel(xPos, yPos, xScale, yScale, rotation, red, green, blue, alpha) end

---@param ped integer
function DropAmbientProp(ped) end

---@param vehicle integer
---@param x number
---@param y number
---@param z number
function EjectJb700Roof(vehicle, x, y, z) end

---@param vehicle integer
---@param avoidObstacles boolean
function EnableAircraftObstacleAvoidance(vehicle, avoidObstacles) end

---@param toggle boolean
function EnableAlienBloodVfx(toggle) end

---@param padIndex integer
function EnableAllControlActions(padIndex) end

---@param toggle boolean
function EnableClownBloodVfx(toggle) end

---@param padIndex integer
---@param control integer
---@param enable boolean
function EnableControlAction(padIndex, control, enable) end


function EnableCrosshairThisFrame() end

---@param dispatchService integer
---@param toggle boolean
function EnableDispatchService(dispatchService, toggle) end


function EnableEditorRuntime() end

---@param entity integer
function EnableEntityUnk(entity) end

---@param mapObjectHash integer | string
function EnableExteriorCullModelThisFrame(mapObjectHash) end

---@param plane integer
---@param propeller integer
function EnableIndividualPlanePropeller(plane, propeller) end

---@param toggle boolean
function EnableLaserSightRendering(toggle) end

---@param phase number
function EnableMoonCycleOverride(phase) end

---@param toggle boolean
function EnableMovieKeyframeWait(toggle) end

---@param toggle boolean
function EnableMovieSubtitles(toggle) end

---@param garageHash integer | string
---@param toggle boolean
function EnableSavingInGarage(garageHash, toggle) end

---@param brainSet integer
function EnableScriptBrainSet(brainSet) end

---@param mapObjectHash integer | string
function EnableScriptCullModelThisFrame(mapObjectHash) end

---@param player integer
---@param toggle boolean
function EnableSpecialAbility(player, toggle) end

---@param vehicle integer
---@param enable boolean
function EnableStallWarningSounds(vehicle, enable) end


function EnableStuntJumpAudio() end

---@param p0 integer
function EnableStuntJumpSet(p0) end


function EnableSwitchPauseBeforeDescent() end

---@param ped integer
---@param toggle boolean
---@param p2 boolean
function EnableTennisMode(ped, toggle, p2) end

---@param vehicle integer
---@param toggle boolean
function EnableVehicleExhaustPops(vehicle, toggle) end

---@param vehicle integer
---@param enableFanbeltDamage boolean
function EnableVehicleFanbeltDamage(vehicle, enableFanbeltDamage) end

---@param findHandle integer
function EndFindObject(findHandle) end

---@param findHandle integer
function EndFindPed(findHandle) end

---@param findHandle integer
function EndFindPickup(findHandle) end

---@param findHandle integer
function EndFindVehicle(findHandle) end


function EndPetrolTrailDecals() end


function EndReplayStats() end


function EndScaleformMovieMethod() end

---@return integer
function EndScaleformMovieMethodReturnValue() end


function EndSrl() end

---@param busySpinnerType integer
function EndTextCommandBusyspinnerOn(busySpinnerType) end


function EndTextCommandClearPrint() end

---@param shape integer
---@param loop boolean
---@param beep boolean
---@param duration integer
function EndTextCommandDisplayHelp(shape, loop, beep, duration) end

---@param x number
---@param y number
function EndTextCommandDisplayText(x, y) end

---@param p0 boolean
---@return number
function EndTextCommandGetWidth(p0) end

---@return boolean
function EndTextCommandIsMessageDisplayed() end

---@param hudIndex integer
---@return boolean
function EndTextCommandIsThisHelpMessageBeingDisplayed(hudIndex) end

---@param x number
---@param y number
---@return integer
function EndTextCommandLineCount(x, y) end

---@param p0 boolean
function EndTextCommandObjective(p0) end

---@param buttonIndex integer
function EndTextCommandOverrideButtonText(buttonIndex) end

---@param duration integer
---@param drawImmediately boolean
function EndTextCommandPrint(duration, drawImmediately) end


function EndTextCommandScaleformString() end

---@param blip integer
function EndTextCommandSetBlipName(blip) end

---@param textureDict string
---@param textureName string
---@param rpBonus integer
---@param colorOverlay integer
---@param titleLabel string
---@return integer
function EndTextCommandThefeedPostAward(textureDict, textureName, rpBonus, colorOverlay, titleLabel) end

---@param chTitle string
---@param clanTxd string
---@param clanTxn string
---@param isImportant boolean
---@param showSubtitle boolean
---@return integer
function EndTextCommandThefeedPostCrewRankup(chTitle, clanTxd, clanTxn, isImportant, showSubtitle) end

---@param crewTypeIsPrivate boolean
---@param crewTagContainsRockstar boolean
---@param rank integer
---@param hasFounderStatus boolean
---@param isImportant boolean
---@param clanHandle integer
---@param r integer
---@param g integer
---@param b integer
---@return integer, integer
function EndTextCommandThefeedPostCrewtag(crewTypeIsPrivate, crewTagContainsRockstar, rank, hasFounderStatus, isImportant, clanHandle, r, g, b) end

---@param crewTypeIsPrivate boolean
---@param crewTagContainsRockstar boolean
---@param rank integer
---@param isLeader boolean
---@param isImportant boolean
---@param clanHandle integer
---@param gamerStr string
---@param r integer
---@param g integer
---@param b integer
---@return integer, integer
function EndTextCommandThefeedPostCrewtagWithGameName(crewTypeIsPrivate, crewTagContainsRockstar, rank, isLeader, isImportant, clanHandle, gamerStr, r, g, b) end

---@param textureDict string
---@param textureName string
---@param flash boolean
---@param iconType integer
---@param sender string
---@param subject string
---@return integer
function EndTextCommandThefeedPostMessagetext(textureDict, textureName, flash, iconType, sender, subject) end

---@param txdName string
---@param textureName string
---@param flash boolean
---@param iconType integer
---@param sender string
---@param subject string
---@return integer
function EndTextCommandThefeedPostMessagetextGxtEntry(txdName, textureName, flash, iconType, sender, subject) end

---@param picTxd string
---@param picTxn string
---@param flash boolean
---@param iconType integer
---@param nameStr string
---@param subtitleStr string
---@param durationMultiplier number
---@return integer
function EndTextCommandThefeedPostMessagetextTu(picTxd, picTxn, flash, iconType, nameStr, subtitleStr, durationMultiplier) end

---@param picTxd string
---@param picTxn string
---@param flash boolean
---@param iconType integer
---@param nameStr string
---@param subtitleStr string
---@param duration number
---@param crewPackedStr string
---@return integer
function EndTextCommandThefeedPostMessagetextWithCrewTag(picTxd, picTxn, flash, iconType, nameStr, subtitleStr, duration, crewPackedStr) end

---@param picTxd string
---@param picTxn string
---@param flash boolean
---@param iconType1 integer
---@param nameStr string
---@param subtitleStr string
---@param duration number
---@param crewPackedStr string
---@param iconType2 integer
---@param textColor integer
---@return integer
function EndTextCommandThefeedPostMessagetextWithCrewTagAndAdditionalIcon(picTxd, picTxn, flash, iconType1, nameStr, subtitleStr, duration, crewPackedStr, iconType2, textColor) end

---@param isImportant boolean
---@param showInBrief boolean
---@return integer
function EndTextCommandThefeedPostMpticker(isImportant, showInBrief) end

---@param eType integer
---@param iIcon integer
---@param sTitle string
---@return integer
function EndTextCommandThefeedPostReplayIcon(eType, iIcon, sTitle) end

---@param type integer
---@param button string
---@param text string
---@return integer
function EndTextCommandThefeedPostReplayInput(type, button, text) end

---@param statTitle string
---@param iconEnum integer
---@param stepVal boolean
---@param barValue integer
---@param isImportant boolean
---@param picTxd string
---@param picTxn string
---@return integer
function EndTextCommandThefeedPostStats(statTitle, iconEnum, stepVal, barValue, isImportant, picTxd, picTxn) end

---@param isImportant boolean
---@param showInBrief boolean
---@return integer
function EndTextCommandThefeedPostTicker(isImportant, showInBrief) end

---@param isImportant boolean
---@param showInBrief boolean
---@return integer
function EndTextCommandThefeedPostTickerForced(isImportant, showInBrief) end

---@param isImportant boolean
---@param showInBrief boolean
---@return integer
function EndTextCommandThefeedPostTickerWithTokens(isImportant, showInBrief) end

---@param chTitle string
---@param iconType integer
---@param chSubtitle string
---@return any
function EndTextCommandThefeedPostUnlock(chTitle, iconType, chSubtitle) end

---@param chTitle string
---@param iconType integer
---@param chSubtitle string
---@param isImportant boolean
---@return any
function EndTextCommandThefeedPostUnlockTu(chTitle, iconType, chSubtitle, isImportant) end

---@param chTitle string
---@param iconType integer
---@param chSubtitle string
---@param isImportant boolean
---@param titleColor integer
---@param p5 boolean
---@return any
function EndTextCommandThefeedPostUnlockTuWithColor(chTitle, iconType, chSubtitle, isImportant, titleColor, p5) end

---@param ch1TXD string
---@param ch1TXN string
---@param val1 integer
---@param ch2TXD string
---@param ch2TXN string
---@param val2 integer
---@return integer
function EndTextCommandThefeedPostVersusTu(ch1TXD, ch1TXN, val1, ch2TXD, ch2TXN, val2) end


function EndTextCommandUnparsedScaleformString() end


function EnterCursorMode() end

---@param data string
---@param objectId integer
---@param tree string
---@return integer
function ExperimentalLoadCloneCreate(data, objectId, tree) end

---@param entity integer
---@param data string
function ExperimentalLoadCloneSync(entity, data) end

---@param entity integer
---@return string
function ExperimentalSaveCloneCreate(entity) end

---@param entity integer
---@return string
function ExperimentalSaveCloneSync(entity) end

---@param ped integer
---@param weaponHash integer | string
function ExplodePedHead(ped, weaponHash) end

---@param ped integer
---@param weaponHash integer | string
---@param p2 boolean
function ExplodeProjectiles(ped, weaponHash, p2) end

---@param vehicle integer
---@param isAudible boolean
---@param isInvisible boolean
function ExplodeVehicle(vehicle, isAudible, isInvisible) end

---@param vehicle integer
---@param p1 boolean
function ExplodeVehicleInCutscene(vehicle, p1) end

---@param x number
---@param y number
---@param z number
function ExtendWorldBoundaryForPlayer(x, y, z) end

---@return boolean
function FacebookDoUnkCheck() end

---@return boolean
function FacebookIsAvailable() end

---@return boolean
function FacebookIsSendingData() end

---@return boolean
function FacebookSetCreateCharacterComplete() end

---@param heistName string
---@param cashEarned integer
---@param xpEarned integer
---@return boolean
function FacebookSetHeistComplete(heistName, cashEarned, xpEarned) end

---@param milestoneId integer
---@return boolean
function FacebookSetMilestoneComplete(milestoneId) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param duration number
function FadeDecalsInRange(x, y, z, radius, duration) end

---@param p0 boolean
function FadeOutLocalPlayer(p0) end

---@param p0 number
function FadeUpPedLight(p0) end

---@param p1 any
---@param p2 any
---@return boolean, integer
function FilloutPmPlayerList(p1, p2) end

---@param p2 any
---@param p3 any
---@return boolean, any, any
function FilloutPmPlayerListWithNames(p2, p3) end

---@param ped integer
function FinalizeHeadBlend(ped) end

---@param animDictionary string
---@param animName string
---@param p2 string
---@return boolean, any, any
function FindAnimEventPhase(animDictionary, animName, p2) end

---@return integer, integer
function FindFirstObject() end

---@return integer, integer
function FindFirstPed() end

---@return integer, integer
function FindFirstPickup() end

---@return integer, integer
function FindFirstVehicle() end

---@param findHandle integer
---@return boolean, integer
function FindNextObject(findHandle) end

---@param findHandle integer
---@return boolean, integer
function FindNextPed(findHandle) end

---@param findHandle integer
---@return boolean, integer
function FindNextPickup(findHandle) end

---@param findHandle integer
---@return boolean, integer
function FindNextVehicle(findHandle) end

---@param stationNameHash integer
---@return integer
function FindRadioStationIndex(stationNameHash) end

---@param ped integer
---@return vector3
function FindRandomPointInSpace(ped) end

---@param posX number
---@param posY number
---@param posZ number
---@param dirX number
---@param dirY number
---@param dirZ number
---@param distance number
---@return boolean, vector3
function FindSpawnPointInDirection(posX, posY, posZ, dirX, dirY, dirZ, distance) end

---@param entity integer
---@return integer
function FindVehicleCarryingThisEntity(entity) end

---@param zoneId integer
---@param x number
---@param y number
---@param z number
function FireAirDefenseWeapon(zoneId, x, y, z) end

---@param object integer
function FixObjectFragment(object) end

---@param vehicle integer
---@param windowIndex integer
function FixVehicleWindow(vehicle, windowIndex) end

---@param toggle boolean
function FlagPlayerContextInTournament(toggle) end

---@param millisecondsToFlash integer
function FlashAbilityBar(millisecondsToFlash) end


function FlashMinimapDisplay() end

---@param hudColorIndex integer
function FlashMinimapDisplayWithColor(hudColorIndex) end

---@param p0 boolean
function FlashWantedDisplay(p0) end

---@param value number
---@return integer
function Floor(value) end

---@param enable boolean
function ForceCinematicRenderingThisUpdate(enable) end

---@param cleanupFlags integer
function ForceCleanup(cleanupFlags) end

---@param name string
---@param cleanupFlags integer
function ForceCleanupForAllThreadsWithThisName(name, cleanupFlags) end

---@param id integer
---@param cleanupFlags integer
function ForceCleanupForThreadWithThisId(id, cleanupFlags) end


function ForceCloseReportugcMenu() end


function ForceCloseTextInputBox() end

---@param entity integer
function ForceEntityAiAndAnimationUpdate(entity) end


function ForceGameStatePlaying() end


function ForceLightningFlash() end

---@param radioStation string
---@param trackListName string
---@param timeOffsetMilliseconds integer
function ForceMusicTrackList(radioStation, trackListName, timeOffsetMilliseconds) end

---@param ped integer
---@param forceAiPreCameraUpdate boolean
---@param forceZeroTimestep boolean
function ForcePedAiAndAnimationUpdate(ped, forceAiPreCameraUpdate, forceZeroTimestep) end

---@param ped integer
---@param motionStateHash integer | string
---@param shouldReset boolean
---@param updateState integer
---@param forceAIPreCameraUpdate boolean
---@return boolean
function ForcePedMotionState(ped, motionStateHash, shouldReset, updateState, forceAIPreCameraUpdate) end


function ForcePedPanicWalla() end

---@param ped integer
function ForcePedToOpenParachute(ped) end

---@param p0 any
function ForcePickupRegenerate(p0) end

---@param vehicle integer
---@param p1 boolean
function ForcePlaybackRecordedVehicleUpdate(vehicle, p1) end

---@param toggle boolean
function ForceRenderInGameUi(toggle) end

---@param entity integer
---@param interior integer
---@param roomHashKey integer | string
function ForceRoomForEntity(entity, interior, roomHashKey) end

---@param interiorID integer
---@param roomHashKey integer | string
function ForceRoomForGameViewport(interiorID, roomHashKey) end

---@param enabled boolean
function ForceSnowPass(enabled) end

---@return any
function ForceSonarBlipsThisFrame() end

---@param submarine integer
---@param time integer
function ForceSubmarineNeurtalBuoyancy(submarine, time) end

---@param vehicle integer
---@param toggle boolean
function ForceSubmarineSurfaceMode(vehicle, toggle) end

---@param vehicle integer
---@param gameObjectName string
function ForceUseAudioGameObject(vehicle, gameObjectName) end

---@param vehicle integer
---@param force boolean
function ForceVehicleEngineSynth(vehicle, force) end


function FreeMemoryForHighQualityPhoto() end


function FreeMemoryForLowQualityPhoto() end


function FreeMemoryForMissionCreatorPhoto() end

---@param entity integer
---@param toggle boolean
function FreezeEntityPosition(entity, toggle) end


function FreezeMicrophone() end

---@param ped integer
function FreezePedCameraRotation(ped) end

---@param radioStation string
function FreezeRadioStation(radioStation) end

---@param vehicle integer
function FullyChargeNitrous(vehicle) end

---@param x number
---@param y number
---@param z number
---@param p3 boolean
---@return integer, integer, number, number
function GenerateDirectionsToCoord(x, y, z, p3) end

---@param achievement integer
---@return integer
function GetAchievementProgress(achievement) end

---@return table
function GetActivePlayers() end

---@param vehicle integer
---@return integer
function GetActiveVehicleMissionType(vehicle) end

---@return integer, integer
function GetActualScreenResolution() end

---@param ped integer
---@return integer
function GetAiBlip(ped) end

---@param ped integer
---@return integer
function GetAiBlip_2(ped) end

---@return table
function GetAllRopes() end

---@return table
function GetAllTrackJunctions() end

---@return table
function GetAllVehicleModels() end

---@return integer, integer
function GetAllVehicles() end

---@return integer
function GetAllocatedStackSize() end

---@return boolean
function GetAllowMovementWhileZoomed() end

---@return number
function GetAmbientPedRangeMultiplier() end

---@return number
function GetAmbientVehicleRangeMultiplier() end

---@param ped integer
---@return integer
function GetAmbientVoiceNameHash(ped) end

---@param ped integer
---@param weaponHash integer | string
---@return boolean, integer
function GetAmmoInClip(ped, weaponHash) end

---@param ped integer
---@param weaponhash integer | string
---@return integer
function GetAmmoInPedWeapon(ped, weaponhash) end

---@param vehicle integer
---@param seat integer
---@param ammo integer
---@return boolean
function GetAmmoInVehicleWeaponClip(vehicle, seat, ammo) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function GetAngleBetween_2dVectors(x1, y1, x2, y2) end

---@param animDict string
---@param animName string
---@return number
function GetAnimDuration(animDict, animName) end

---@param animDict string
---@param animName string
---@param x number
---@param y number
---@param z number
---@param xRot number
---@param yRot number
---@param zRot number
---@param p8 number
---@param p9 integer
---@return vector3
function GetAnimInitialOffsetPosition(animDict, animName, x, y, z, xRot, yRot, zRot, p8, p9) end

---@param animDict string
---@param animName string
---@param x number
---@param y number
---@param z number
---@param xRot number
---@param yRot number
---@param zRot number
---@param p8 number
---@param p9 integer
---@return vector3
function GetAnimInitialOffsetRotation(animDict, animName, x, y, z, xRot, yRot, zRot, p8, p9) end

---@return boolean
function GetAreCameraControlsDisabled() end

---@return number
function GetAspectRatio() end

---@return integer
function GetAudibleMusicTrackTextId() end

---@param p3 any
---@param p4 boolean
---@return boolean, any, any
function GetBaseElementMetadata(p3, p4) end

---@return integer
function GetBenchmarkIterationsFromCommandLine() end

---@return integer
function GetBenchmarkPassFromCommandLine() end

---@return number
function GetBenchmarkTime() end

---@param ped integer
---@param ignoreAmmoCount boolean
---@return integer
function GetBestPedWeapon(ped, ignoreAmmoCount) end

---@param binkMovie integer
---@return number
function GetBinkMovieTime(binkMovie) end

---@param var integer
---@param rangeStart integer
---@param rangeEnd integer
---@return integer
function GetBitsInRange(var, rangeStart, rangeEnd) end

---@param blip integer
---@return integer
function GetBlipAlpha(blip) end

---@param blip integer
---@return integer
function GetBlipColour(blip) end

---@param blip integer
---@return vector3
function GetBlipCoords(blip) end

---@param entity integer
---@return integer
function GetBlipFromEntity(entity) end

---@param blip integer
---@return integer
function GetBlipHudColour(blip) end

---@param blip integer
---@return vector3
function GetBlipInfoIdCoord(blip) end

---@param blip integer
---@return integer
function GetBlipInfoIdDisplay(blip) end

---@param blip integer
---@return integer
function GetBlipInfoIdEntityIndex(blip) end

---@param blip integer
---@return integer
function GetBlipInfoIdPickupIndex(blip) end

---@param blip integer
---@return integer
function GetBlipInfoIdType(blip) end

---@param blip integer
---@return integer
function GetBlipRotation(blip) end

---@param blip integer
---@return integer
function GetBlipSprite(blip) end

---@param vehicle integer
---@return number
function GetBoatBoomPositionRatio(vehicle) end

---@param vehicle integer
---@param p1 boolean
function GetBoatBoomPositionRatio_2(vehicle, p1) end

---@param vehicle integer
---@param p1 boolean
function GetBoatBoomPositionRatio_3(vehicle, p1) end

---@param modelHash integer | string
---@return number
function GetBoatVehicleModelAgility(modelHash) end

---@param x number
---@param y number
---@return integer
function GetCalmingQuadAtCoords(x, y) end

---@param waterQuad integer
---@return boolean, integer, integer, integer, integer
function GetCalmingQuadBounds(waterQuad) end

---@return integer
function GetCalmingQuadCount() end

---@param waterQuad integer
---@return boolean, number
function GetCalmingQuadDampening(waterQuad) end

---@return integer
function GetCamActiveViewModeContext() end

---@param cam integer
---@return number
function GetCamAnimCurrentPhase(cam) end

---@param cam integer
---@return vector3
function GetCamCoord(cam) end

---@param cam integer
---@return number
function GetCamDofStrength(cam) end

---@param cam integer
---@return number
function GetCamFarClip(cam) end

---@param cam integer
---@return number
function GetCamFarDof(cam) end

---@param cam integer
---@return number
function GetCamFov(cam) end

---@param camera integer
---@return vector3, vector3, vector3, vector3
function GetCamMatrix(camera) end

---@param cam integer
---@return number
function GetCamNearClip(cam) end

---@param cam integer
---@return number
function GetCamNearDof(cam) end

---@param cam integer
---@param rotationOrder integer
---@return vector3
function GetCamRot(cam, rotationOrder) end

---@param cam integer
---@return integer
function GetCamSplineNodeIndex(cam) end

---@param cam integer
---@return number
function GetCamSplineNodePhase(cam) end

---@param cam integer
---@return number
function GetCamSplinePhase(cam) end

---@param context integer
---@return integer
function GetCamViewModeForContext(context) end

---@param vehicle integer
---@return boolean
function GetCanVehicleJump(vehicle) end

---@param cargobob integer
---@return vector3
function GetCargobobHookPosition(cargobob) end

---@return integer
function GetCauseOfMostRecentForceCleanup() end

---@param entity integer
---@return vector3
function GetCgoffset(entity) end

---@param flagIndex integer
---@return boolean
function GetClientConfigBool(flagIndex) end

---@param p0 integer
---@return string
function GetClipSetForScriptedGunTask(p0) end

---@return integer
function GetClockDayOfMonth() end

---@return integer
function GetClockDayOfWeek() end

---@return integer
function GetClockHours() end

---@return integer
function GetClockMinutes() end

---@return integer
function GetClockMonth() end

---@return integer
function GetClockSeconds() end

---@return integer
function GetClockYear() end

---@param blipSprite integer
---@return integer
function GetClosestBlipOfType(blipSprite) end

---@param x number
---@param y number
---@param z number
---@return boolean, vector3
function GetClosestFirePos(x, y, z) end

---@param x number
---@param y number
---@param z number
---@param zMeasureMult number
---@param zTolerance integer
---@return boolean, vector3
function GetClosestMajorVehicleNode(x, y, z, zMeasureMult, zTolerance) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param modelHash integer | string
---@param isMission boolean
---@param p6 boolean
---@param p7 boolean
---@return integer
function GetClosestObjectOfType(x, y, z, radius, modelHash, isMission, p6, p7) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param p4 boolean
---@param p5 boolean
---@param p7 boolean
---@param p8 boolean
---@param pedType integer
---@return boolean, integer
function GetClosestPed(x, y, z, radius, p4, p5, p7, p8, pedType) end

---@param x number
---@param y number
---@param z number
---@param minimumEdgeLength number
---@param minimumLaneCount integer
---@param onlyMajorRoads boolean
---@return boolean, vector3, vector3, integer, integer, number
function GetClosestRoad(x, y, z, minimumEdgeLength, minimumLaneCount, onlyMajorRoads) end

---@param position vector3
---@param radius number
---@return table
function GetClosestTrackNodes(position, radius) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param modelHash integer | string
---@param flags integer
---@return integer
function GetClosestVehicle(x, y, z, radius, modelHash, flags) end

---@param x number
---@param y number
---@param z number
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance number
---@return boolean, vector3
function GetClosestVehicleNode(x, y, z, nodeFlags, zMeasureMult, zTolerance) end

---@param x number
---@param y number
---@param z number
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance integer
---@return boolean, vector3, number
function GetClosestVehicleNodeWithHeading(x, y, z, nodeFlags, zMeasureMult, zTolerance) end

---@return number
function GetCloudHatOpacity() end

---@return integer
function GetCloudTimeAsInt() end

---@return string
function GetCloudTimeAsString() end

---@param entity integer
---@return vector3
function GetCollisionNormalOfLastHitForEntity(entity) end

---@param ped integer
---@param p1 integer
---@return number
function GetCombatFloat(ped, p1) end

---@param index integer
---@param index2 integer
---@return string
function GetCommerceItemCat(index, index2) end

---@param index integer
---@return string
function GetCommerceItemId(index) end

---@param index integer
---@return string
function GetCommerceItemName(index) end

---@param index integer
---@return integer
function GetCommerceItemNumCats(index) end

---@param index integer
---@return string
function GetCommerceItemTexturename(index) end

---@param index integer
---@return string
function GetCommerceProductPrice(index) end

---@param padIndex integer
---@param controlGroup integer
---@param p2 boolean
---@return string
function GetControlGroupInstructionalButton(padIndex, controlGroup, p2) end

---@param padIndex integer
---@param control integer
---@param p2 boolean
---@return string
function GetControlInstructionalButton(padIndex, control, p2) end

---@param padIndex integer
---@param control integer
---@return number
function GetControlNormal(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return number
function GetControlUnboundNormal(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return integer
function GetControlValue(padIndex, control) end

---@param vehicle integer
---@return integer
function GetConvertibleRoofState(vehicle) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param modelHash integer | string
---@param rotationOrder integer
---@return any, vector3, vector3
function GetCoordsAndRotationOfClosestObjectOfType(x, y, z, radius, modelHash, rotationOrder) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param projectileHash integer | string
---@param ownedByPlayer boolean
---@return boolean, vector3
function GetCoordsOfProjectileTypeInArea(x1, y1, z1, x2, y2, z2, projectileHash, ownedByPlayer) end

---@param ped integer
---@param weaponHash integer | string
---@param distance number
---@param ownedByPlayer boolean
---@return boolean, vector3
function GetCoordsOfProjectileTypeWithinDistance(ped, weaponHash, distance, ownedByPlayer) end

---@return integer
function GetCurrentFrontendMenuVersion() end

---@return string
function GetCurrentGameName() end

---@return integer
function GetCurrentLanguage() end

---@return integer
function GetCurrentNumberOfCloudPhotos() end

---@param ped integer
---@return boolean, integer
function GetCurrentPedVehicleWeapon(ped) end

---@param ped integer
---@param p2 boolean
---@return boolean, integer
function GetCurrentPedWeapon(ped, p2) end

---@param ped integer
---@return integer
function GetCurrentPedWeaponEntityIndex(ped) end

---@param vehicle integer
---@return integer
function GetCurrentPlaybackForVehicle(vehicle) end

---@param radioStationName string
---@return integer
function GetCurrentRadioTrackPlaybackTime(radioStationName) end

---@return integer, integer
function GetCurrentScreenResolution() end

---@return integer
function GetCurrentScriptedConversationLine() end

---@return string
function GetCurrentServerEndpoint() end

---@param radioStationName string
---@return integer
function GetCurrentTrackSoundName(radioStationName) end

---@return integer
function GetCurrentWebpageId() end

---@return integer
function GetCurrentWebsiteId() end

---@param cutsceneName string
---@return integer
function GetCutFileNumSections(cutsceneName) end

---@return integer
function GetCutsceneEndTime() end

---@return integer
function GetCutscenePlayTime() end

---@return integer
function GetCutsceneSectionPlaying() end

---@return integer
function GetCutsceneTime() end

---@return integer
function GetCutsceneTotalDuration() end

---@param entity integer
---@param type integer
---@return vector3
function GetDamping(entity, type) end

---@param ped integer
---@param p1 number
---@param p2 number
---@return vector3
function GetDeadPedPickupCoords(ped, p1, p2) end

---@return integer
function GetDebugCamera() end

---@param decal integer
---@return number
function GetDecalWashLevel(decal) end

---@return number
function GetDeepOceanScaler() end

---@return integer
function GetDefaultScriptRendertargetRenderId() end

---@param padIndex integer
---@param control integer
---@return number
function GetDisabledControlNormal(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return number
function GetDisabledControlUnboundNormal(padIndex, control) end

---@param modelHash integer | string
---@return string
function GetDisplayNameFromVehicleModel(modelHash) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param useZ boolean
---@return number
function GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, useZ) end

---@param dlcVehicleIndex integer
---@return boolean, any
function GetDlcVehicleData(dlcVehicleIndex) end

---@param dlcVehicleIndex integer
---@return integer
function GetDlcVehicleFlags(dlcVehicleIndex) end

---@param hash integer | string
---@return integer
function GetDlcVehicleModLockHash(hash) end

---@param dlcVehicleIndex integer
---@return integer
function GetDlcVehicleModel(dlcVehicleIndex) end

---@param dlcWeaponIndex integer
---@param dlcWeapCompIndex integer
---@return boolean, integer
function GetDlcWeaponComponentData(dlcWeaponIndex, dlcWeapCompIndex) end

---@param dlcWeaponIndex integer
---@param dlcWeapCompIndex integer
---@return boolean, integer
function GetDlcWeaponComponentDataSp(dlcWeaponIndex, dlcWeapCompIndex) end

---@param dlcWeaponIndex integer
---@return boolean, integer
function GetDlcWeaponData(dlcWeaponIndex) end

---@param dlcWeaponIndex integer
---@return boolean, integer
function GetDlcWeaponDataSp(dlcWeaponIndex) end

---@param vehicle integer
---@return boolean
function GetDoesVehicleHaveTombstone(vehicle) end

---@param vehicle integer
---@return boolean
function GetDriftTyresEnabled(vehicle) end

---@param duiObject integer
---@return string
function GetDuiHandle(duiObject) end

---@param entity integer
---@return any
function GetEntityAddress(entity) end

---@param entity integer
---@return integer
function GetEntityAlpha(entity) end

---@param entity integer
---@param animDict string
---@param animName string
---@return number
function GetEntityAnimCurrentTime(entity, animDict, animName) end

---@param entity integer
---@param animDict string
---@param animName string
---@return number
function GetEntityAnimTotalTime(entity, animDict, animName) end

---@param entity integer
---@return string
function GetEntityArchetypeName(entity) end

---@param entity integer
---@return integer
function GetEntityAttachedTo(entity) end

---@param vehicle integer
---@return integer
function GetEntityAttachedToCargobob(vehicle) end

---@param towTruck integer
---@return integer
function GetEntityAttachedToTowTruck(towTruck) end

---@param entity integer
---@return integer
function GetEntityBoneCount(entity) end

---@param entity integer
---@param boneName string
---@return integer
function GetEntityBoneIndexByName(entity, boneName) end

---@param entity integer
---@param boneIndex integer
---@return vector3
function GetEntityBonePosition_2(entity, boneIndex) end

---@param entity integer
---@param boneIndex integer
---@return vector3
function GetEntityBoneRotation(entity, boneIndex) end

---@param entity integer
---@param boneIndex integer
---@return vector3
function GetEntityBoneRotationLocal(entity, boneIndex) end

---@param entity integer
---@return boolean
function GetEntityCanBeDamaged(entity) end

---@param entity integer
---@return boolean
function GetEntityCollisionDisabled(entity) end

---@param entity integer
---@param alive boolean
---@return vector3
function GetEntityCoords(entity, alive) end

---@param entity integer
---@return vector3
function GetEntityForwardVector(entity) end

---@param entity integer
---@return number
function GetEntityForwardX(entity) end

---@param entity integer
---@return number
function GetEntityForwardY(entity) end

---@param entity integer
---@return number
function GetEntityHeading(entity) end

---@param entity integer
---@return number
function GetEntityHeadingFromEulers(entity) end

---@param entity integer
---@return integer
function GetEntityHealth(entity) end

---@param entity integer
---@param X number
---@param Y number
---@param Z number
---@param atTop boolean
---@param inWorldCoords boolean
---@return number
function GetEntityHeight(entity, X, Y, Z, atTop, inWorldCoords) end

---@param entity integer
---@return number
function GetEntityHeightAboveGround(entity) end

---@param mapdata integer
---@param entity integer
---@return integer
function GetEntityIndexFromMapdata(mapdata, entity) end

---@param cutsceneEntName string
---@param modelHash integer | string
---@return integer
function GetEntityIndexOfCutsceneEntity(cutsceneEntName, modelHash) end

---@param cutsceneEntName string
---@param modelHash integer | string
---@return integer
function GetEntityIndexOfRegisteredEntity(cutsceneEntName, modelHash) end

---@param explosionType integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param radius number
---@return integer
function GetEntityInsideExplosionArea(explosionType, x1, y1, z1, x2, y2, z2, radius) end

---@param explosionType integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@return integer
function GetEntityInsideExplosionSphere(explosionType, x, y, z, radius) end

---@param entity integer
---@return integer
function GetEntityLodDist(entity) end

---@param entity integer
---@return boolean, integer, integer
function GetEntityMapdataOwner(entity) end

---@param entity integer
---@return vector3, vector3, vector3, vector3
function GetEntityMatrix(entity) end

---@param entity integer
---@return integer
function GetEntityMaxHealth(entity) end

---@param entity integer
---@return integer
function GetEntityModel(entity) end

---@param entity integer
---@param modelHash integer | string
---@return integer
function GetEntityPickup(entity, modelHash) end

---@param entity integer
---@return number
function GetEntityPitch(entity) end

---@param player integer
---@return boolean, integer
function GetEntityPlayerIsFreeAimingAt(player) end

---@param entity integer
---@return integer
function GetEntityPopulationType(entity) end

---@param entity integer
---@return boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean, boolean
function GetEntityProofs(entity) end

---@param entity integer
---@return number, number, number, number
function GetEntityQuaternion(entity) end

---@param entity integer
---@return number
function GetEntityRoll(entity) end

---@param entity integer
---@param rotationOrder integer
---@return vector3
function GetEntityRotation(entity, rotationOrder) end

---@param entity integer
---@return vector3
function GetEntityRotationVelocity(entity) end

---@param entity integer
---@return string, integer
function GetEntityScript(entity) end

---@param entity integer
---@return number
function GetEntitySpeed(entity) end

---@param entity integer
---@param relative boolean
---@return vector3
function GetEntitySpeedVector(entity, relative) end

---@param entity integer
---@return number
function GetEntitySubmergedLevel(entity) end

---@param entity integer
---@return integer
function GetEntityType(entity) end

---@param entity integer
---@return number
function GetEntityUprightValue(entity) end

---@param entity integer
---@return vector3
function GetEntityVelocity(entity) end

---@param vehicle integer
---@param doorIndex integer
---@return vector3
function GetEntryPositionOfDoor(vehicle, doorIndex) end

---@param eventGroup integer
---@param eventIndex integer
---@return integer
function GetEventAtIndex(eventGroup, eventIndex) end

---@param eventGroup integer
---@param eventIndex integer
---@param eventDataSize integer
---@return boolean, integer
function GetEventData(eventGroup, eventIndex, eventDataSize) end

---@param eventGroup integer
---@param eventIndex integer
---@return boolean
function GetEventExists(eventGroup, eventIndex) end

---@param resource string
---@param key string
---@return number
function GetExternalKvpFloat(resource, key) end

---@param resource string
---@param key string
---@return integer
function GetExternalKvpInt(resource, key) end

---@param resource string
---@param key string
---@return string
function GetExternalKvpString(resource, key) end

---@return boolean
function GetExtraContentPackHasBeenInstalled() end

---@return integer
function GetExtraTimecycleModifierIndex() end

---@return integer
function GetFakeWantedLevel() end

---@return number
function GetFallDamageLandOnFootMultiplier() end

---@return number
function GetFallDamageMultiplier() end

---@param labelName string
---@return string
function GetFilenameForAudioConversation(labelName) end

---@return vector3
function GetFinalRenderedCamCoord() end

---@return number
function GetFinalRenderedCamFarClip() end

---@return number
function GetFinalRenderedCamFarDof() end

---@return number
function GetFinalRenderedCamFov() end

---@return number
function GetFinalRenderedCamMotionBlurStrength() end

---@return number
function GetFinalRenderedCamNearClip() end

---@return number
function GetFinalRenderedCamNearDof() end

---@param rotationOrder integer
---@return vector3
function GetFinalRenderedCamRot(rotationOrder) end

---@param player integer
---@return number
function GetFinalRenderedInWhenFriendlyFov(player) end

---@param player integer
---@param rotationOrder integer
---@return vector3
function GetFinalRenderedInWhenFriendlyRot(player, rotationOrder) end

---@param blipSprite integer
---@return integer
function GetFirstBlipInfoId(blipSprite) end

---@return number
function GetFirstPersonAimCamZoomFactor() end

---@param p0 number
---@param p1 integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 integer
---@param p8 integer
---@return integer
function GetFocusPedOnScreen(p0, p1, p2, p3, p4, p5, p6, p7, p8) end

---@return integer
function GetFollowPedCamViewMode() end

---@return integer
function GetFollowPedCamZoomLevel() end

---@return integer
function GetFollowVehicleCamViewMode() end

---@return integer
function GetFollowVehicleCamZoomLevel() end

---@param componentHash integer | string
---@param forcedComponentIndex integer
---@return integer, integer, integer
function GetForcedComponent(componentHash, forcedComponentIndex) end

---@param componentHash integer | string
---@param forcedPropIndex integer
---@return integer, integer, integer
function GetForcedProp(componentHash, forcedPropIndex) end

---@return integer
function GetFrameCount() end

---@return number
function GetFrameTime() end

---@return number
function GetFuelConsumptionRateMultiplier() end

---@return boolean
function GetFuelConsumptionState() end

---@return integer
function GetGameTimer() end

---@return vector3
function GetGameplayCamCoord() end

---@return number
function GetGameplayCamFov() end

---@return number
function GetGameplayCamRelativeHeading() end

---@return number
function GetGameplayCamRelativePitch() end

---@param rotationOrder integer
---@return vector3
function GetGameplayCamRot(rotationOrder) end

---@param flagIndex integer
---@return integer
function GetGlobalActionscriptFlag(flagIndex) end

---@return string
function GetGlobalCharBuffer() end

---@return number
function GetGlobalPassengerMassMultiplier() end

---@return integer
function GetGlobalWaterType() end

---@return boolean
function GetGpsBlipRouteFound() end

---@return integer
function GetGpsBlipRouteLength() end

---@param x number
---@param y number
---@param z number
---@return boolean, number, vector3
function GetGroundZAndNormalFor_3dCoord(x, y, z) end

---@param x number
---@param y number
---@param z number
---@param waterAsGround boolean
---@return boolean, number
function GetGroundZExcludingObjectsFor_3dCoord(x, y, z, waterAsGround) end

---@param x number
---@param y number
---@param z number
---@param includeWater boolean
---@return boolean, number
function GetGroundZFor_3dCoord(x, y, z, includeWater) end

---@param groupID integer
---@return any, integer
function GetGroupSize(groupID) end

---@param object integer
---@return boolean
function GetHasObjectFragInst(object) end

---@param vehicle integer
---@return boolean
function GetHasRetractableWheels(vehicle) end

---@param vehicle integer
---@return boolean
function GetHasRocketBoost(vehicle) end

---@param string string
---@return integer
function GetHashKey(string) end

---@param entity integer
---@param componentId integer
---@param drawableVariant integer
---@param textureVariant integer
---@return integer
function GetHashNameForComponent(entity, componentId, drawableVariant, textureVariant) end

---@param entity integer
---@param componentId integer
---@param propIndex integer
---@param propTextureIndex integer
---@return integer
function GetHashNameForProp(entity, componentId, propIndex, propTextureIndex) end

---@param x number
---@param y number
---@param z number
---@return integer
function GetHashOfMapAreaAtCoords(x, y, z) end

---@return integer
function GetHashOfThisScriptName() end

---@param dx number
---@param dy number
---@return number
function GetHeadingFromVector_2d(dx, dy) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function GetHeightmapBottomZForArea(x1, y1, x2, y2) end

---@param x number
---@param y number
---@return number
function GetHeightmapBottomZForPosition(x, y) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function GetHeightmapTopZForArea(x1, y1, x2, y2) end

---@param x number
---@param y number
---@return number
function GetHeightmapTopZForPosition(x, y) end

---@param vehicle integer
---@return number
function GetHeliMainRotorHealth(vehicle) end

---@param vehicle integer
---@return number
function GetHeliTailBoomHealth(vehicle) end

---@param heli integer
---@return number
function GetHeliTailRotorHealth(heli) end

---@param hudColorIndex integer
---@return integer, integer, integer, integer
function GetHudColour(hudColorIndex) end

---@param id integer
---@return integer, integer
function GetHudComponentAlign(id) end

---@param id integer
---@return string
function GetHudComponentName(id) end

---@param id integer
---@return vector3
function GetHudComponentPosition(id) end

---@param id integer
---@return vector3
function GetHudComponentSize(id) end

---@param worldX number
---@param worldY number
---@param worldZ number
---@return boolean, number, number
function GetHudScreenPositionFromWorldPosition(worldX, worldY, worldZ) end

---@param vehicle integer
---@param wheelId integer
---@return number
function GetHydraulicWheelValue(vehicle, wheelId) end

---@return integer
function GetIdOfThisThread() end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return integer
function GetIdealPlayerSwitchType(x1, y1, z1, x2, y2, z2) end

---@return integer
function GetIndexOfCurrentLevel() end

---@param p0 any
---@param p1 any
---@return any
function GetIndexedItemInItemset(p0, p1) end

---@param x number
---@param y number
---@param z number
---@return integer
function GetInteriorAtCoords(x, y, z) end

---@param x number
---@param y number
---@param z number
---@param interiorType string
---@return integer
function GetInteriorAtCoordsWithType(x, y, z, interiorType) end

---@param x number
---@param y number
---@param z number
---@param typeHash integer | string
---@return integer
function GetInteriorAtCoordsWithTypehash(x, y, z, typeHash) end

---@param interiorId integer
---@return number, number, number, number, number, number
function GetInteriorEntitiesExtents(interiorId) end

---@param x number
---@param y number
---@param z number
---@return integer
function GetInteriorFromCollision(x, y, z) end

---@param entity integer
---@return integer
function GetInteriorFromEntity(entity) end

---@return integer
function GetInteriorFromPrimaryView() end

---@param interior integer
---@return integer
function GetInteriorGroupId(interior) end

---@param interior integer
---@return number
function GetInteriorHeading(interior) end

---@param interior integer
---@return vector3, integer
function GetInteriorLocationAndNamehash(interior) end

---@param interiorId integer
---@param portalIndex integer
---@param cornerIndex integer
---@return number, number, number
function GetInteriorPortalCornerPosition(interiorId, portalIndex, cornerIndex) end

---@param interiorId integer
---@return integer
function GetInteriorPortalCount(interiorId) end

---@param interiorId integer
---@param portalIndex integer
---@param entityIndex integer
---@return integer
function GetInteriorPortalEntityArchetype(interiorId, portalIndex, entityIndex) end

---@param interiorId integer
---@param portalIndex integer
---@return integer
function GetInteriorPortalEntityCount(interiorId, portalIndex) end

---@param interiorId integer
---@param portalIndex integer
---@param entityIndex integer
---@return integer
function GetInteriorPortalEntityFlag(interiorId, portalIndex, entityIndex) end

---@param interiorId integer
---@param portalIndex integer
---@param entityIndex integer
---@return number, number, number
function GetInteriorPortalEntityPosition(interiorId, portalIndex, entityIndex) end

---@param interiorId integer
---@param portalIndex integer
---@param entityIndex integer
---@return number, number, number, number
function GetInteriorPortalEntityRotation(interiorId, portalIndex, entityIndex) end

---@param interiorId integer
---@param portalIndex integer
---@return integer
function GetInteriorPortalFlag(interiorId, portalIndex) end

---@param interiorId integer
---@param portalIndex integer
---@return integer
function GetInteriorPortalRoomFrom(interiorId, portalIndex) end

---@param interiorId integer
---@param portalIndex integer
---@return integer
function GetInteriorPortalRoomTo(interiorId, portalIndex) end

---@param interiorId integer
---@return number, number, number
function GetInteriorPosition(interiorId) end

---@param interiorId integer
---@return integer
function GetInteriorRoomCount(interiorId) end

---@param interiorId integer
---@param roomIndex integer
---@return number, number, number, number, number, number
function GetInteriorRoomExtents(interiorId, roomIndex) end

---@param interiorId integer
---@param roomIndex integer
---@return integer
function GetInteriorRoomFlag(interiorId, roomIndex) end

---@param interiorId integer
---@param roomHash integer
---@return integer
function GetInteriorRoomIndexByHash(interiorId, roomHash) end

---@param interiorId integer
---@param roomIndex integer
---@return string
function GetInteriorRoomName(interiorId, roomIndex) end

---@param interiorId integer
---@param roomIndex integer
---@return integer
function GetInteriorRoomTimecycle(interiorId, roomIndex) end

---@param interiorId integer
---@return number, number, number, number
function GetInteriorRotation(interiorId) end

---@param entity integer
---@param p1 any
---@return boolean
function GetIsArenaPropPhysicsDisabled(entity, p1) end

---@return boolean
function GetIsAutoSaveOff() end

---@param vehicle integer
---@return boolean
function GetIsBoatCapsized(vehicle) end

---@param vehicle integer
---@param doorIndex integer
---@return boolean
function GetIsDoorValid(vehicle, doorIndex) end

---@return boolean
function GetIsHidef() end

---@param vehicle integer
---@return boolean
function GetIsLeftVehicleHeadlightDamaged(vehicle) end

---@return boolean
function GetIsLoadingScreenActive() end

---@param ped integer
---@param gadgetHash integer | string
---@return boolean
function GetIsPedGadgetEquipped(ped, gadgetHash) end

---@param xCoord number
---@param yCoord number
---@param zCoord number
---@param radius number
---@return boolean
function GetIsPetrolDecalInRange(xCoord, yCoord, zCoord, radius) end

---@param playerId integer
---@return boolean
function GetIsPlayerDrivingOnHighway(playerId) end

---@return boolean
function GetIsPlayerInAnimalForm() end

---@return boolean
function GetIsPreloadedConversationReady() end

---@param vehicle integer
---@return boolean
function GetIsRightVehicleHeadlightDamaged(vehicle) end

---@param ped integer
---@param taskIndex integer
---@return boolean
function GetIsTaskActive(ped, taskIndex) end

---@return boolean
function GetIsUsingAlternateDriveby() end

---@param vehicleModel integer | string
---@return boolean
function GetIsVehicleElectric(vehicleModel) end

---@param vehicle integer
---@return boolean
function GetIsVehicleEmpDisabled(vehicle) end

---@param vehicle integer
---@return boolean
function GetIsVehicleEngineRunning(vehicle) end

---@param vehicle integer
---@return boolean
function GetIsVehiclePrimaryColourCustom(vehicle) end

---@param vehicle integer
---@return boolean
function GetIsVehicleSecondaryColourCustom(vehicle) end

---@param vehicle integer
---@return boolean
function GetIsVehicleShuntBoostActive(vehicle) end

---@param name string
---@return boolean
function GetIsWaypointRecordingLoaded(name) end

---@param vehicle integer
---@return boolean
function GetIsWheelsLoweredStateActive(vehicle) end

---@return boolean
function GetIsWidescreen() end

---@param x integer
---@return any
function GetItemsetSize(x) end

---@param ped integer
---@return integer
function GetJackTarget(ped) end

---@param entity integer
---@return integer
function GetKeyForEntityInRoom(entity) end

---@return number
function GetKillFallHeight() end

---@param vehicle integer
---@return integer
function GetLandingGearState(vehicle) end

---@return integer
function GetLastDrivenVehicle() end

---@param entity integer
---@return integer
function GetLastMaterialHitByEntity(entity) end

---@param vehicle integer
---@param seatIndex integer
---@return integer
function GetLastPedInVehicleSeat(vehicle, seatIndex) end

---@param vehicle integer
---@return integer
function GetLastRammedVehicle(vehicle) end

---@param string string
---@return integer
function GetLengthOfLiteralString(string) end

---@param string string
---@return integer
function GetLengthOfLiteralStringInBytes(string) end

---@param gxt string
---@return integer
function GetLengthOfStringWithThisTextLabel(gxt) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param planeX number
---@param planeY number
---@param planeZ number
---@param planeNormalX number
---@param planeNormalY number
---@param planeNormalZ number
---@return boolean, number
function GetLinePlaneIntersection(x1, y1, z1, x2, y2, z2, planeX, planeY, planeZ, planeNormalX, planeNormalY, planeNormalZ) end

---@param vehicle integer
---@param liveryIndex integer
---@return string
function GetLiveryName(vehicle, liveryIndex) end

---@return integer
function GetLocalPlayerAimState() end

---@return integer
function GetLocalPlayerGamepadAimState() end

---@return integer, integer, integer, integer, integer, integer
function GetLocalTime() end

---@param ped integer
---@return number
function GetLockonDistanceOfCurrentPedWeapon(ped) end

---@return number
function GetLodscale() end

---@return integer
function GetMainPlayerBlipId() end

---@param modelHash integer | string
---@return string
function GetMakeNameFromVehicleModel(modelHash) end

---@param index integer
---@return boolean, number, number, number, number, number
function GetMapZoomDataLevel(index) end

---@param mapDataHash integer
---@param entityInternalIdx integer
---@return boolean, integer
function GetMapdataEntityHandle(mapDataHash, entityInternalIdx) end

---@param mapDataHash integer
---@param entityInternalIdx integer
---@param matrixPtr integer
---@return boolean
function GetMapdataEntityMatrix(mapDataHash, entityInternalIdx, matrixPtr) end

---@param mapdataHandle integer | string
---@return integer
function GetMapdataFromHashKey(mapdataHandle) end

---@param ped integer
---@param weaponHash integer | string
---@return boolean, integer
function GetMaxAmmo(ped, weaponHash) end

---@param ped integer
---@param ammoType integer | string
---@return boolean, integer
function GetMaxAmmoByType(ped, ammoType) end

---@param ped integer
---@param weaponHash integer | string
---@param p2 boolean
---@return integer
function GetMaxAmmoInClip(ped, weaponHash, p2) end

---@return integer
function GetMaxNumNetworkObjects() end

---@return integer
function GetMaxNumNetworkPeds() end

---@return integer
function GetMaxNumNetworkPickups() end

---@return integer
function GetMaxNumNetworkVehicles() end

---@param ped integer
---@return number
function GetMaxRangeOfCurrentPedWeapon(ped) end

---@return integer
function GetMaxWantedLevel() end

---@return integer
function GetMaximumNumberOfCloudPhotos() end

---@return integer
function GetMaximumNumberOfPhotos() end

---@param ped integer
---@return integer
function GetMeleeTargetForPed(ped) end

---@return integer, integer, integer
function GetMenuLayoutChangedEventDetails() end

---@param p0 integer | string
---@return boolean, any
function GetMenuPedBoolStat(p0) end

---@param p0 any
---@return boolean, number
function GetMenuPedFloatStat(p0) end

---@param p0 any
---@return boolean, any
function GetMenuPedIntStat(p0) end

---@param p0 any
---@param p2 any
---@param p3 any
---@return boolean, any
function GetMenuPedMaskedIntStat(p0, p2, p3) end

---@return integer
function GetMillisecondsPerGameMinute() end

---@param x number
---@param y number
---@param z number
---@return boolean
function GetMinimapFowCoordinateIsRevealed(x, y, z) end

---@return number
function GetMinimapFowDiscoveryRatio() end

---@return integer
function GetMinimapType() end

---@return boolean
function GetMissionFlag() end

---@return vector3
function GetMobilePhonePosition() end

---@return integer
function GetMobilePhoneRenderId() end

---@param p1 integer
---@return vector3
function GetMobilePhoneRotation(p1) end

---@param vehicle integer
---@param modType integer
---@return string
function GetModSlotName(vehicle, modType) end

---@param vehicle integer
---@param modType integer
---@param modValue integer
---@return string
function GetModTextLabel(vehicle, modType, modValue) end

---@param modelHash integer | string
---@return vector3, vector3
function GetModelDimensions(modelHash) end

---@param ped integer
---@return integer
function GetMount(ped) end

---@param scaleformHandle integer
---@return boolean, boolean, integer, integer, integer
function GetMouseEvent(scaleformHandle) end

---@return integer
function GetMusicPlaytime() end

---@return integer
function GetMusicVolSlider() end

---@param threadId integer
---@return string
function GetNameOfThread(threadId) end

---@param x number
---@param y number
---@param z number
---@return string
function GetNameOfZone(x, y, z) end

---@param name string
---@return integer
function GetNamedRendertargetRenderId(name) end

---@param ped integer
---@return integer, number, boolean
function GetNavmeshRouteDistanceRemaining(ped) end

---@param ped integer
---@return integer
function GetNavmeshRouteResult(ped) end

---@param entity integer
---@return integer
function GetNearestPlayerToEntity(entity) end

---@param entity integer
---@param team integer
---@return integer
function GetNearestPlayerToEntityOnTeam(entity, team) end

---@param soundId integer
---@return integer
function GetNetworkIdFromSoundId(soundId) end

---@return integer
function GetNetworkTime() end

---@return integer
function GetNetworkTimeAccurate() end

---@return boolean
function GetNetworkWalkMode() end

---@return integer
function GetNewSelectedMissionCreatorBlip() end

---@return boolean, number, number, integer
function GetNextAudibleBeat() end

---@param blipSprite integer
---@return integer
function GetNextBlipInfoId(blipSprite) end

---@param index integer
---@return integer
function GetNextGpsDisabledZoneIndex(index) end

---@return integer
function GetNextWeatherTypeHashName() end

---@param index integer
---@param spStat boolean
---@param charStat boolean
---@param character integer
---@param section string
---@return integer
function GetNgstatBoolHash(index, spStat, charStat, character, section) end

---@param index integer
---@param spStat boolean
---@param charStat boolean
---@param character integer
---@param section string
---@return integer
function GetNgstatIntHash(index, spStat, charStat, character, section) end

---@return boolean
function GetNoLoadingScreen() end

---@return integer
function GetNorthRadarBlip() end

---@param x number
---@param y number
---@param z number
---@param nthClosest integer
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance number
---@return boolean, vector3
function GetNthClosestVehicleNode(x, y, z, nthClosest, nodeFlags, zMeasureMult, zTolerance) end

---@param x number
---@param y number
---@param z number
---@param desiredX number
---@param desiredY number
---@param desiredZ number
---@param nthClosest integer
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance number
---@return boolean, vector3, number
function GetNthClosestVehicleNodeFavourDirection(x, y, z, desiredX, desiredY, desiredZ, nthClosest, nodeFlags, zMeasureMult, zTolerance) end

---@param x number
---@param y number
---@param z number
---@param nthClosest integer
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance number
---@return integer
function GetNthClosestVehicleNodeId(x, y, z, nthClosest, nodeFlags, zMeasureMult, zTolerance) end

---@param x number
---@param y number
---@param z number
---@param nthClosest integer
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance number
---@return integer, vector3, number
function GetNthClosestVehicleNodeIdWithHeading(x, y, z, nthClosest, nodeFlags, zMeasureMult, zTolerance) end

---@param x number
---@param y number
---@param z number
---@param nthClosest integer
---@param nodeFlags integer
---@param zMeasureMult number
---@param zTolerance number
---@return boolean, vector3, number, integer
function GetNthClosestVehicleNodeWithHeading(x, y, z, nthClosest, nodeFlags, zMeasureMult, zTolerance) end

---@return integer, integer
function GetNuiCursorPosition() end

---@return integer
function GetNumCommerceItems() end

---@param p0 boolean
---@return integer
function GetNumCreatedMissionObjects(p0) end

---@param p0 boolean
---@return integer
function GetNumCreatedMissionPeds(p0) end

---@param p0 boolean
---@return integer
function GetNumCreatedMissionVehicles(p0) end

---@param dispatchService integer
---@return integer
function GetNumDispatchedUnitsForPlayer(dispatchService) end

---@return integer
function GetNumDlcVehicles() end

---@param dlcWeaponIndex integer
---@return integer
function GetNumDlcWeaponComponents(dlcWeaponIndex) end

---@param dlcWeaponIndex integer
---@return integer
function GetNumDlcWeaponComponentsSp(dlcWeaponIndex) end

---@return integer
function GetNumDlcWeapons() end

---@return integer
function GetNumDlcWeaponsSp() end

---@return integer
function GetNumHairColors() end

---@return integer
function GetNumMakeupColors() end

---@param paintType integer
---@param p1 boolean
---@return integer
function GetNumModColors(paintType, p1) end

---@param vehicle integer
---@return integer
function GetNumModKits(vehicle) end

---@param posMinX number
---@param posMinY number
---@param posMinZ number
---@param posMaxX number
---@param posMaxY number
---@param posMaxZ number
---@return integer
function GetNumNavmeshesExistingInArea(posMinX, posMinY, posMinZ, posMaxX, posMaxY, posMaxZ) end

---@param p0 boolean
---@return integer
function GetNumReservedMissionObjects(p0) end

---@param p0 boolean
---@return integer
function GetNumReservedMissionPeds(p0) end

---@param p0 boolean
---@return integer
function GetNumReservedMissionVehicles(p0) end

---@return integer
function GetNumSuccessfulStuntJumps() end

---@param character integer
---@return integer
function GetNumTattooShopDlcItems(character) end

---@return integer
function GetNumUnlockedRadioStations() end

---@param vehicle integer
---@param modType integer
---@return integer
function GetNumVehicleMods(vehicle, modType) end

---@return integer
function GetNumVehicleWindowTints() end

---@return integer
function GetNumberOfActiveBlips() end

---@param eventGroup integer
---@return integer
function GetNumberOfEvents(eventGroup) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@return integer
function GetNumberOfFiresInRange(x, y, z, radius) end

---@param stackSize integer
---@return integer
function GetNumberOfFreeStacksOfThisSize(stackSize) end

---@param ped integer
---@param componentId integer
---@param collection string
---@return integer
function GetNumberOfPedCollectionDrawableVariations(ped, componentId, collection) end

---@param ped integer
---@param anchorPoint integer
---@param collection string
---@return integer
function GetNumberOfPedCollectionPropDrawableVariations(ped, anchorPoint, collection) end

---@param ped integer
---@param anchorPoint integer
---@param collection string
---@param propIndex integer
---@return integer
function GetNumberOfPedCollectionPropTextureVariations(ped, anchorPoint, collection, propIndex) end

---@param ped integer
---@param componentId integer
---@param collection string
---@param drawableId integer
---@return integer
function GetNumberOfPedCollectionTextureVariations(ped, componentId, collection, drawableId) end

---@param ped integer
---@param componentId integer
---@return integer
function GetNumberOfPedDrawableVariations(ped, componentId) end

---@param ped integer
---@param propId integer
---@return integer
function GetNumberOfPedPropDrawableVariations(ped, propId) end

---@param ped integer
---@param propId integer
---@param drawableId integer
---@return integer
function GetNumberOfPedPropTextureVariations(ped, propId, drawableId) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@return integer
function GetNumberOfPedTextureVariations(ped, componentId, drawableId) end

---@return integer
function GetNumberOfPlayers() end

---@param team integer
---@return integer
function GetNumberOfPlayersInTeam(team) end

---@param scriptHash integer | string
---@return integer
function GetNumberOfReferencesOfScriptWithNameHash(scriptHash) end

---@return integer
function GetNumberOfStreamingRequests() end

---@param vehicle integer
---@return integer
function GetNumberOfVehicleColours(vehicle) end

---@param vehicle integer
---@return integer
function GetNumberOfVehicleDoors(vehicle) end

---@return integer
function GetNumberOfVehicleNumberPlates() end

---@param p0 any
---@param p1 boolean
---@return number
function GetObjectFragmentDamageHealth(p0, p1) end

---@param entity integer
---@return integer
function GetObjectIndexFromEntityIndex(entity) end

---@param object integer
---@return integer
function GetObjectTextureVariation(object) end

---@param xPos number
---@param yPos number
---@param zPos number
---@param heading number
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@return vector3
function GetOffsetFromCoordAndHeadingInWorldCoords(xPos, yPos, zPos, heading, xOffset, yOffset, zOffset) end

---@param entity integer
---@param posX number
---@param posY number
---@param posZ number
---@return vector3
function GetOffsetFromEntityGivenWorldCoords(entity, posX, posY, posZ) end

---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@return vector3
function GetOffsetFromEntityInWorldCoords(entity, offsetX, offsetY, offsetZ) end

---@param interior integer
---@param x number
---@param y number
---@param z number
---@return vector3
function GetOffsetFromInteriorInWorldCoords(interior, x, y, z) end

---@return string
function GetOnlineVersion() end

---@return string
function GetOnscreenKeyboardResult() end

---@param index integer
---@param spStat boolean
---@param charStat boolean
---@param character integer
---@return integer
function GetPackedBoolStatKey(index, spStat, charStat, character) end

---@param index integer
---@param spStat boolean
---@param charStat boolean
---@param character integer
---@return integer
function GetPackedIntStatKey(index, spStat, charStat, character) end

---@param index integer
---@param spStat boolean
---@param charStat boolean
---@param character integer
---@return integer
function GetPackedTuBoolStatKey(index, spStat, charStat, character) end

---@param index integer
---@param spStat boolean
---@param charStat boolean
---@param character integer
---@return integer
function GetPackedTuIntStatKey(index, spStat, charStat, character) end

---@return number
function GetParkedVehicleDensityMultiplier() end

---@return vector3
function GetPauseMapPointerWorldPosition() end

---@return vector3
function GetPauseMenuPosition() end

---@return integer, integer
function GetPauseMenuSelection() end

---@return integer
function GetPauseMenuState() end

---@param ped integer
---@return integer
function GetPedAccuracy(ped) end

---@param ped integer
---@return integer
function GetPedAlertness(ped) end

---@param ped integer
---@param ammoType integer | string
---@return integer
function GetPedAmmoByType(ped, ammoType) end

---@param ped integer
---@param weaponHash integer | string
---@return integer
function GetPedAmmoTypeFromWeapon(ped, weaponHash) end

---@param ped integer
---@param weaponHash integer | string
---@return integer
function GetPedAmmoTypeFromWeapon_2(ped, weaponHash) end

---@param ped integer
---@return integer
function GetPedArmour(ped) end

---@param groupID integer
---@return integer
function GetPedAsGroupLeader(groupID) end

---@param groupID integer
---@param memberNumber integer
---@return integer
function GetPedAsGroupMember(groupID, memberNumber) end

---@param ped integer
---@param boneId integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@return vector3
function GetPedBoneCoords(ped, boneId, offsetX, offsetY, offsetZ) end

---@param ped integer
---@param boneId integer
---@return integer
function GetPedBoneIndex(ped, boneId) end

---@param ped integer
---@param boneId integer
---@return vector3, vector3, vector3, vector3
function GetPedBoneMatrix(ped, boneId) end

---@param ped integer
---@return integer
function GetPedCauseOfDeath(ped) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@return integer
function GetPedCollectionLocalIndexFromDrawable(ped, componentId, drawableId) end

---@param ped integer
---@param anchorPoint integer
---@param propIndex integer
---@return integer
function GetPedCollectionLocalIndexFromProp(ped, anchorPoint, propIndex) end

---@param ped integer
---@param index integer
---@return string
function GetPedCollectionName(ped, index) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@return string
function GetPedCollectionNameFromDrawable(ped, componentId, drawableId) end

---@param ped integer
---@param anchorPoint integer
---@param propIndex integer
---@return string
function GetPedCollectionNameFromProp(ped, anchorPoint, propIndex) end

---@param ped integer
---@return integer
function GetPedCollectionsCount(ped) end

---@param ped integer
---@return integer
function GetPedCombatMovement(ped) end

---@param ped integer
---@return integer
function GetPedCombatRange(ped) end

---@param ped integer
---@param flagId integer
---@param p2 boolean
---@return boolean
function GetPedConfigFlag(ped, flagId, p2) end

---@param ped integer
---@return boolean, number, number
function GetPedCurrentMovementSpeed(ped) end

---@param collection integer | string
---@param overlay integer | string
---@return integer
function GetPedDecorationZoneFromHashes(collection, overlay) end

---@param ped integer
---@return table
function GetPedDecorations(ped) end

---@param ped integer
---@return integer
function GetPedDecorationsState(ped) end

---@param ped integer
---@param p1 boolean
---@return vector3
function GetPedDefensiveAreaPosition(ped, p1) end

---@return number
function GetPedDensityMultiplier() end

---@param ped integer
---@return number
function GetPedDesiredMoveBlendRatio(ped) end

---@param ped integer
---@return boolean
function GetPedDiesInWater(ped) end

---@param ped integer
---@param componentId integer
---@param collection string
---@param drawableId integer
---@return integer
function GetPedDrawableGlobalIndexFromCollection(ped, componentId, collection, drawableId) end

---@param ped integer
---@param componentId integer
---@return integer
function GetPedDrawableVariation(ped, componentId) end

---@param ped integer
---@param componentId integer
---@return integer
function GetPedDrawableVariationCollectionLocalIndex(ped, componentId) end

---@param ped integer
---@param componentId integer
---@return string
function GetPedDrawableVariationCollectionName(ped, componentId) end

---@param ped integer
---@return number
function GetPedEmissiveIntensity(ped) end

---@param ped integer
---@return number
function GetPedEnveffScale(ped) end

---@param ped integer
---@param eventType integer
---@return boolean, any
function GetPedEventData(ped, eventType) end

---@param ped integer
---@param worldSpace boolean
---@return vector3
function GetPedExtractedDisplacement(ped, worldSpace) end

---@param ped integer
---@return integer
function GetPedEyeColor(ped) end

---@param ped integer
---@param index integer
---@return number
function GetPedFaceFeature(ped, index) end

---@param ped integer
---@return integer
function GetPedGroupIndex(ped) end

---@param ped integer
---@return integer
function GetPedHairColor(ped) end

---@param ped integer
---@return integer
function GetPedHairHighlightColor(ped) end

---@param hairColorIndex integer
---@return integer, integer, integer
function GetPedHairRgbColor(hairColorIndex) end

---@param ped integer
---@return boolean, any
function GetPedHeadBlendData(ped) end

---@param type integer
---@return integer
function GetPedHeadBlendFirstIndex(type) end

---@param type integer
---@return integer
function GetPedHeadBlendNumHeads(type) end

---@param ped integer
---@param index integer
---@return boolean, integer, integer, integer, integer, number
function GetPedHeadOverlayData(ped, index) end

---@param overlayID integer
---@return integer
function GetPedHeadOverlayNum(overlayID) end

---@param ped integer
---@param overlayID integer
---@return integer
function GetPedHeadOverlayValue(ped, overlayID) end

---@param ped integer
---@return integer
function GetPedHelmetStoredHatPropIndex(ped) end

---@param ped integer
---@return integer
function GetPedHelmetStoredHatTexIndex(ped) end

---@param vehicle integer
---@param seatIndex integer
---@return integer
function GetPedInVehicleSeat(vehicle, seatIndex) end

---@param entity integer
---@return integer
function GetPedIndexFromEntityIndex(entity) end

---@param ped integer
---@return boolean, integer
function GetPedLastDamageBone(ped) end

---@param ped integer
---@return boolean, vector3
function GetPedLastWeaponImpactCoord(ped) end

---@param makeupColorIndex integer
---@return integer, integer, integer
function GetPedMakeupRgbColor(makeupColorIndex) end

---@param ped integer
---@return integer
function GetPedMaxHealth(ped) end

---@param modelHash integer | string
---@return integer
function GetPedModelHealthConfig(modelHash) end

---@param modelHash integer | string
---@return integer
function GetPedModelPersonality(modelHash) end

---@param ped integer
---@return integer
function GetPedMoney(ped) end

---@param ped integer
---@return integer
function GetPedMovementClipset(ped) end

---@param ped integer
---@param ignore integer
---@return integer, integer
function GetPedNearbyPeds(ped, ignore) end

---@param ped integer
---@return integer, integer
function GetPedNearbyVehicles(ped) end

---@param ped integer
---@param componentId integer
---@return integer
function GetPedPaletteVariation(ped, componentId) end

---@param ped integer
---@return integer
function GetPedParachuteLandingType(ped) end

---@param ped integer
---@return integer
function GetPedParachuteState(ped) end

---@param ped integer
---@return integer
function GetPedParachuteTintIndex(ped) end

---@param ped integer
---@param anchorPoint integer
---@return integer
function GetPedPropCollectionLocalIndex(ped, anchorPoint) end

---@param ped integer
---@param anchorPoint integer
---@return string
function GetPedPropCollectionName(ped, anchorPoint) end

---@param ped integer
---@param anchorPoint integer
---@param collection string
---@param propIndex integer
---@return integer
function GetPedPropGlobalIndexFromCollection(ped, anchorPoint, collection, propIndex) end

---@param ped integer
---@param componentId integer
---@return integer
function GetPedPropIndex(ped, componentId) end

---@param ped integer
---@param componentId integer
---@return integer
function GetPedPropTextureIndex(ped, componentId) end

---@param ped integer
---@param bone integer
---@return integer
function GetPedRagdollBoneIndex(ped, bone) end

---@param ped integer
---@return integer
function GetPedRelationshipGroupDefaultHash(ped) end

---@param ped integer
---@return integer
function GetPedRelationshipGroupHash(ped) end

---@param ped integer
---@param flagId integer
---@return boolean
function GetPedResetFlag(ped, flagId) end

---@param ped integer
---@return number
function GetPedScale(ped) end

---@param ped integer
---@return integer
function GetPedSourceOfDeath(ped) end

---@param ped integer
---@return boolean
function GetPedStealthMovement(ped) end

---@param ped integer
---@return number
function GetPedSweat(ped) end

---@param ped integer
---@param p1 any
---@return integer
function GetPedTaskCombatTarget(ped, p1) end

---@param ped integer
---@param componentId integer
---@return integer
function GetPedTextureVariation(ped, componentId) end

---@param ped integer
---@return integer
function GetPedTimeOfDeath(ped) end

---@param ped integer
---@return integer
function GetPedType(ped) end

---@param vehicle integer
---@param doorIndex integer
---@return integer
function GetPedUsingVehicleDoor(vehicle, doorIndex) end

---@param ped integer
---@return number
function GetPedVisualFieldCenterAngle(ped) end

---@param p0 any
---@return number
function GetPedWaypointDistance(p0) end

---@param ped integer
---@return integer
function GetPedWaypointProgress(ped) end

---@param ped integer
---@param weaponHash integer | string
---@param camoComponentHash integer | string
---@return integer
function GetPedWeaponLiveryColor(ped, weaponHash, camoComponentHash) end

---@param ped integer
---@param weaponHash integer | string
---@return integer
function GetPedWeaponTintIndex(ped, weaponHash) end

---@param ped integer
---@param weaponSlot integer | string
---@return integer
function GetPedWeapontypeInSlot(ped, weaponSlot) end

---@param ped integer
---@return number
function GetPedWetness(ped) end

---@param ped integer
---@return number
function GetPedWetnessHeight(ped) end

---@param id integer
---@return string
function GetPedheadshotTxdString(id) end

---@param ped integer
---@return integer
function GetPedsJacker(ped) end

---@param ped integer
---@return number
function GetPhoneGestureAnimCurrentTime(ped) end

---@param ped integer
---@return number
function GetPhoneGestureAnimTotalTime(ped) end

---@param pickup integer
---@return vector3
function GetPickupCoords(pickup) end

---@return number
function GetPickupGenerationRangeMultiplier() end

---@param pickupHash integer | string
---@return integer
function GetPickupHash(pickupHash) end

---@param weapon integer | string
---@return integer
function GetPickupHashFromWeapon(weapon) end

---@param pickup integer
---@return integer
function GetPickupObject(pickup) end

---@param player integer
---@return number
function GetPlayerCurrentStealthNoise(player) end

---@param player integer
---@return integer
function GetPlayerFakeWantedLevel(player) end

---@param serverId integer
---@return integer
function GetPlayerFromServerId(serverId) end

---@param player integer
---@return integer
function GetPlayerGroup(player) end

---@param player integer
---@return boolean
function GetPlayerHasReserveParachute(player) end

---@param player integer
---@return number
function GetPlayerHealthRechargeLimit(player) end

---@return integer
function GetPlayerIndex() end

---@param player integer
---@return boolean
function GetPlayerInvincible(player) end

---@param player integer
---@return boolean
function GetPlayerInvincible_2(player) end

---@return number
function GetPlayerKillFallHeight() end

---@param player integer
---@return integer
function GetPlayerMaxArmour(player) end

---@param playerId integer
---@return number
function GetPlayerMaxStamina(playerId) end

---@param playerId integer
---@return number
function GetPlayerMeleeWeaponDefenseModifier(playerId) end

---@param player integer
---@return string
function GetPlayerName(player) end

---@param player integer
---@return integer
function GetPlayerParachuteModelOverride(player) end

---@param player integer
---@return integer
function GetPlayerParachutePackTintIndex(player) end

---@param player integer
---@return integer, integer, integer
function GetPlayerParachuteSmokeTrailColor(player) end

---@param player integer
---@return integer
function GetPlayerParachuteTintIndex(player) end

---@param playerId integer
---@return integer
function GetPlayerPed(playerId) end

---@param ped integer
---@return integer
function GetPlayerPedIsFollowing(ped) end

---@param player integer
---@return integer
function GetPlayerPedScriptIndex(player) end

---@return integer
function GetPlayerRadioStationGenre() end

---@return integer
function GetPlayerRadioStationIndex() end

---@return string
function GetPlayerRadioStationName() end

---@param player integer
---@return integer
function GetPlayerReserveParachuteModelOverride(player) end

---@param player integer
---@return integer
function GetPlayerReserveParachuteTintIndex(player) end

---@param player integer
---@return integer, integer, integer
function GetPlayerRgbColour(player) end

---@param player integer
---@return integer
function GetPlayerServerId(player) end

---@return integer
function GetPlayerShortSwitchState() end

---@param player integer
---@return number
function GetPlayerSprintStaminaRemaining(player) end

---@param player integer
---@return number
function GetPlayerSprintTimeRemaining(player) end

---@param playerId integer
---@return number
function GetPlayerStamina(playerId) end

---@return any
function GetPlayerSwitchInterpOutCurrentTime() end

---@return integer
function GetPlayerSwitchInterpOutDuration() end

---@return integer
function GetPlayerSwitchJumpCutIndex() end

---@return integer
function GetPlayerSwitchState() end

---@return integer
function GetPlayerSwitchType() end

---@param player integer
---@return boolean, integer
function GetPlayerTargetEntity(player) end

---@param player integer
---@return integer
function GetPlayerTeam(player) end

---@param player integer
---@return number
function GetPlayerUnderwaterTimeRemaining(player) end

---@param playerId integer
---@return number
function GetPlayerVehicleDamageModifier(playerId) end

---@param playerId integer
---@return number
function GetPlayerVehicleDefenseModifier(playerId) end

---@param player integer
---@return vector3
function GetPlayerWantedCentrePosition(player) end

---@param player integer
---@return integer
function GetPlayerWantedLevel(player) end

---@return integer
function GetPlayersLastVehicle() end

---@param x number
---@param y number
---@param z number
---@param p3 integer
---@return boolean, vector3
function GetPointOnRoadSide(x, y, z, p3) end

---@param bStartAtPlayerPos boolean
---@param fDistanceAlongRoute number
---@param slotType integer
---@return boolean, vector3
function GetPosAlongGpsTypeRoute(bStartAtPlayerPos, fDistanceAlongRoute, slotType) end

---@param vehicle integer
---@return number
function GetPositionInRecording(vehicle) end

---@param recording integer
---@param time number
---@param script string
---@return vector3
function GetPositionOfVehicleRecordingAtTime(recording, time, script) end

---@param id integer
---@param time number
---@return vector3
function GetPositionOfVehicleRecordingIdAtTime(id, time) end

---@return integer, integer, integer, integer, integer, integer
function GetPosixTime() end

---@return integer
function GetPowerSavingModeDuration() end

---@return integer
function GetPrevWeatherTypeHashName() end

---@param profileSetting integer
---@return integer
function GetProfileSetting(profileSetting) end

---@param ped integer
---@param weaponHash integer | string
---@param distance number
---@param ownedByPlayer boolean
---@return boolean, vector3, integer
function GetProjectileNearPed(ped, weaponHash, distance, ownedByPlayer) end

---@param stationIndex integer
---@return string
function GetRadioStationName(stationIndex) end

---@return number
function GetRainLevel() end

---@return boolean
function GetRandomEventFlag() end

---@param startRange number
---@param endRange number
---@return number
function GetRandomFloatInRange(startRange, endRange) end

---@param startRange integer
---@param endRange integer
---@return integer
function GetRandomIntInRange(startRange, endRange) end

---@param startRange integer
---@param endRange integer
---@return integer
function GetRandomIntInRange_2(startRange, endRange) end

---@param x number
---@param y number
---@param z number
---@param xRadius number
---@param yRadius number
---@param zRadius number
---@param pedType integer
---@return integer
function GetRandomPedAtCoord(x, y, z, xRadius, yRadius, zRadius, pedType) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 integer
---@param p5 integer
---@param p6 integer
---@return integer
function GetRandomVehicleBackBumperInSphere(p0, p1, p2, p3, p4, p5, p6) end

---@return number
function GetRandomVehicleDensityMultiplier() end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 integer
---@param p5 integer
---@param p6 integer
---@return integer
function GetRandomVehicleFrontBumperInSphere(p0, p1, p2, p3, p4, p5, p6) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param modelHash integer | string
---@param flags integer
---@return integer
function GetRandomVehicleInSphere(x, y, z, radius, modelHash, flags) end

---@param p0 boolean
---@return integer, integer
function GetRandomVehicleModelInMemory(p0) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param p4 boolean
---@param p5 boolean
---@param p6 boolean
---@return boolean, vector3, integer
function GetRandomVehicleNode(x, y, z, radius, p4, p5, p6) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param name string
---@return integer
function GetRayfireMapObject(x, y, z, radius, name) end

---@param object integer
---@return number
function GetRayfireMapObjectAnimPhase(object) end

---@param group1 integer | string
---@param group2 integer | string
---@return integer
function GetRelationshipBetweenGroups(group1, group2) end

---@param ped1 integer
---@param ped2 integer
---@return integer
function GetRelationshipBetweenPeds(ped1, ped2) end

---@param vehicle integer
---@return number
function GetRemainingNitrousDuration(vehicle) end

---@param size number
---@param font integer
---@return number
function GetRenderedCharacterHeight(size, font) end

---@return integer
function GetRenderingCam() end

---@param index integer
---@return integer
function GetReplayStatAtIndex(index) end

---@return integer
function GetReplayStatCount() end

---@return integer
function GetReplayStatMissionType() end

---@return boolean
function GetRequestingnightvision() end

---@param x number
---@param y number
---@param z number
---@param heading number
---@return boolean, vector3
function GetRoadBoundaryUsingHeading(x, y, z, heading) end

---@return integer
function GetRoomKeyForGameViewport() end

---@param entity integer
---@return integer
function GetRoomKeyFromEntity(entity) end

---@param rope integer
---@return integer
function GetRopeFlags(rope) end

---@param ropeId integer
---@return vector3
function GetRopeLastVertexCoord(ropeId) end

---@param rope integer
---@return number
function GetRopeLengthChangeRate(rope) end

---@param rope integer
---@return number
function GetRopeTimeMultiplier(rope) end

---@param rope integer
---@return integer
function GetRopeUpdateOrder(rope) end

---@param ropeId integer
---@param vertex integer
---@return vector3
function GetRopeVertexCoord(ropeId, vertex) end

---@param ropeId integer
---@return integer
function GetRopeVertexCount(ropeId) end

---@param recording integer
---@param time number
---@param script string
---@return vector3
function GetRotationOfVehicleRecordingAtTime(recording, time, script) end

---@param id integer
---@param time number
---@return vector3
function GetRotationOfVehicleRecordingIdAtTime(id, time) end

---@param tex integer
---@return integer
function GetRuntimeTextureHeight(tex) end

---@param tex integer
---@return integer
function GetRuntimeTexturePitch(tex) end

---@param tex integer
---@return integer
function GetRuntimeTextureWidth(tex) end

---@param x number
---@param y number
---@param z number
---@param onlyOnPavement boolean
---@param flags integer
---@return boolean, vector3
function GetSafeCoordForPed(x, y, z, onlyOnPavement, flags) end

---@param x number
---@param y number
---@param z number
---@param p3 number
---@param p4 number
---@return vector3
function GetSafePickupCoords(x, y, z, p3, p4) end

---@return number
function GetSafeZoneSize() end

---@param methodReturn integer
---@return boolean
function GetScaleformMovieMethodReturnValueBool(methodReturn) end

---@param method_return integer
---@return integer
function GetScaleformMovieMethodReturnValueInt(method_return) end

---@param method_return integer
---@return string
function GetScaleformMovieMethodReturnValueString(method_return) end

---@return number
function GetScenarioPedDensityMultiplier() end

---@param worldX number
---@param worldY number
---@param worldZ number
---@return boolean, number, number
function GetScreenCoordFromWorldCoord(worldX, worldY, worldZ) end

---@return integer, integer
function GetScreenResolution() end

---@return number
function GetScreenblurFadeCurrentTime() end

---@param x number
---@param y number
---@return number, number
function GetScriptGfxPosition(x, y) end

---@param ped integer
---@param taskHash integer | string
---@return integer
function GetScriptTaskStatus(ped, taskHash) end

---@param coverpoint integer
---@return vector3
function GetScriptedCoverPointCoords(coverpoint) end

---@param ped integer
---@return integer
function GetSeatPedIsTryingToEnter(ped) end

---@param ped integer
---@return integer
function GetSelectedPedWeapon(ped) end

---@param ped integer
---@return integer
function GetSequenceProgress(ped) end

---@param shapeTestHandle integer
---@return integer, boolean, vector3, vector3, integer
function GetShapeTestResult(shapeTestHandle) end

---@param shapeTestHandle integer
---@return integer, boolean, vector3, vector3, integer, integer
function GetShapeTestResultIncludingMaterial(shapeTestHandle) end

---@param componentHash integer | string
---@return integer
function GetShopPedApparelForcedComponentCount(componentHash) end

---@param componentHash integer | string
---@return integer
function GetShopPedApparelForcedPropCount(componentHash) end

---@param componentHash integer | string
---@return integer
function GetShopPedApparelVariantComponentCount(componentHash) end

---@param propHash integer | string
---@return integer
function GetShopPedApparelVariantPropCount(propHash) end

---@param componentHash integer | string
---@return any
function GetShopPedComponent(componentHash) end

---@param p0 any
---@return any
function GetShopPedOutfit(p0) end

---@param outfit integer | string
---@param slot integer
---@return boolean, any
function GetShopPedOutfitComponentVariant(outfit, slot) end

---@param p0 any
---@return integer
function GetShopPedOutfitLocate(p0) end

---@param outfitHash integer | string
---@param variantIndex integer
---@return boolean, any
function GetShopPedOutfitPropVariant(outfitHash, variantIndex) end

---@param componentHash integer | string
---@return any
function GetShopPedProp(componentHash) end

---@param componentId integer
---@return integer
function GetShopPedQueryComponent(componentId) end

---@param outfitIndex integer
---@return any
function GetShopPedQueryOutfit(outfitIndex) end

---@param componentId integer
---@return any
function GetShopPedQueryProp(componentId) end

---@param p0 boolean
---@return integer
function GetSizeOfSaveData(p0) end

---@return number
function GetSnowLevel() end

---@return integer
function GetSoundId() end

---@param netId integer
---@return integer
function GetSoundIdFromNetworkId(netId) end

---@return integer
function GetStandardBlipEnumId() end

---@param type integer | string
---@param x number
---@param y number
---@param z number
---@return boolean, number
function GetStateOfClosestDoorOfType(type, x, y, z) end

---@param object integer
---@return integer
function GetStateOfRayfireMapObject(object) end

---@param p0 string
---@return integer
function GetStatusOfLoadMissionCreatorPhoto(p0) end

---@return integer
function GetStatusOfMissionRepeatSave() end

---@return integer
function GetStatusOfSaveHighQualityPhoto() end

---@param scanForSaving boolean
---@return integer
function GetStatusOfSortedListOperation(scanForSaving) end

---@return integer
function GetStatusOfTakeHighQualityPhoto() end

---@return integer
function GetStatusOfTakeMissionCreatorPhoto() end

---@param p0 integer
---@return integer
function GetStatusOfTextureDownload(p0) end

---@return integer
function GetStreamPlayTime() end

---@param x number
---@param y number
---@param z number
---@return integer, integer
function GetStreetNameAtCoord(x, y, z) end

---@param hash integer | string
---@return string
function GetStreetNameFromHashKey(hash) end

---@param submarine integer
---@return boolean
function GetSubmarineIsUnderDesignDepth(submarine) end

---@param submarine integer
---@return integer
function GetSubmarineNumberOfAirLeaks(submarine) end

---@param sceneID integer
---@return number
function GetSynchronizedScenePhase(sceneID) end

---@param sceneID integer
---@return number
function GetSynchronizedSceneRate(sceneID) end

---@param ped integer
---@param eventName string
---@return boolean
function GetTaskMoveNetworkEvent(ped, eventName) end

---@param ped integer
---@param signalName string
---@return boolean
function GetTaskMoveNetworkSignalBool(ped, signalName) end

---@param ped integer
---@param signalName string
---@return number
function GetTaskMoveNetworkSignalFloat(ped, signalName) end

---@param ped integer
---@return string
function GetTaskMoveNetworkState(ped) end

---@param characterType integer
---@param decorationIndex integer
---@return boolean, any
function GetTattooShopDlcItemData(characterType, decorationIndex) end

---@param character integer
---@param collection integer
---@param preset integer
---@return integer
function GetTattooShopDlcItemIndex(character, collection, preset) end

---@param ped integer
---@return boolean
function GetTennisSwingAnimComplete(ped) end

---@param text string
---@param position integer
---@param length integer
---@return string
function GetTextSubstring(text, position, length) end

---@param text string
---@param position integer
---@param length integer
---@param maxLength integer
---@return string
function GetTextSubstringSafe(text, position, length, maxLength) end

---@param text string
---@param startPosition integer
---@param endPosition integer
---@return string
function GetTextSubstringSlice(text, startPosition, endPosition) end

---@param textureDict string
---@param textureName string
---@return vector3
function GetTextureResolution(textureDict, textureName) end

---@return string
function GetThisScriptName() end

---@param time integer
---@return string
function GetTimeAsString(time) end

---@param vehicle integer
---@param seat integer
---@return integer
function GetTimeBeforeVehicleWeaponReloadFinishes(vehicle, seat) end

---@param timeA integer
---@param timeB integer
---@return integer
function GetTimeDifference(timeA, timeB) end

---@param ped integer
---@param weaponHash integer | string
---@return integer
function GetTimeOfLastPedWeaponDamage(ped, weaponHash) end

---@param timeA integer
---@param timeB integer
---@return integer
function GetTimeOffset(timeA, timeB) end

---@param vehicle integer
---@return number
function GetTimePositionInRecording(vehicle) end

---@return integer
function GetTimeSinceLastArrest() end

---@return integer
function GetTimeSinceLastDeath() end

---@param padIndex integer
---@return integer
function GetTimeSinceLastInput(padIndex) end

---@param player integer
---@return integer
function GetTimeSincePlayerDroveAgainstTraffic(player) end

---@param player integer
---@return integer
function GetTimeSincePlayerDroveOnPavement(player) end

---@param player integer
---@return integer
function GetTimeSincePlayerHitPed(player) end

---@param player integer
---@return integer
function GetTimeSincePlayerHitVehicle(player) end

---@return integer
function GetTimecycleModifierCount() end

---@return integer
function GetTimecycleModifierIndex() end

---@param modifierName string
---@return integer
function GetTimecycleModifierIndexByName(modifierName) end

---@param modifierIndex integer
---@return string
function GetTimecycleModifierNameByIndex(modifierIndex) end

---@return number
function GetTimecycleModifierStrength() end

---@param modifierName string
---@param varName string
---@return boolean, number, number
function GetTimecycleModifierVar(modifierName, varName) end

---@param modifierName string
---@return integer
function GetTimecycleModifierVarCount(modifierName) end

---@param modifierName string
---@param modifierVarIndex integer
---@return string
function GetTimecycleModifierVarNameByIndex(modifierName, modifierVarIndex) end

---@return integer
function GetTimecycleTransitionModifierIndex() end

---@return integer
function GetTimecycleVarCount() end

---@param varIndex integer
---@return number
function GetTimecycleVarDefaultValueByIndex(varIndex) end

---@param varIndex integer
---@return string
function GetTimecycleVarNameByIndex(varIndex) end

---@return boolean
function GetTogglePausedRenderphasesStatus() end

---@param recording integer
---@param script string
---@return number
function GetTotalDurationOfVehicleRecording(recording, script) end

---@param id integer
---@return number
function GetTotalDurationOfVehicleRecordingId(id) end

---@return integer
function GetTotalSuccessfulStuntJumps() end

---@param track integer
---@return number
function GetTrackBrakingDistance(track) end

---@param track integer
---@return number
function GetTrackMaxSpeed(track) end

---@param trackIndex integer
---@param trackNode integer
---@return boolean, vector3
function GetTrackNodeCoords(trackIndex, trackNode) end

---@param trackIndex integer
---@return integer
function GetTrackNodeCount(trackIndex) end

---@param train integer
---@param trailerNumber integer
---@return integer
function GetTrainCarriage(train, trailerNumber) end

---@param train integer
---@return integer
function GetTrainCurrentTrackNode(train) end

---@param train integer
---@return integer
function GetTrainDoorCount(train) end

---@param train integer
---@param doorIndex integer
---@return number
function GetTrainDoorOpenRatio(train, doorIndex) end

---@param train integer
---@return number
function GetTrainSpeed(train) end

---@return integer
function GetTvChannel() end

---@return number
function GetTvVolume() end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetTyreHealth(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetTyreWearMultiplier(vehicle, wheelIndex) end

---@return number
function GetUsedCreatorModelMemoryPercentage() end

---@return boolean
function GetUsingnightvision() end

---@return boolean
function GetUsingseethrough() end

---@return integer, integer, integer, integer, integer, integer
function GetUtcTime() end

---@param componentHash integer | string
---@param variantComponentIndex integer
---@return integer, integer, integer
function GetVariantComponent(componentHash, variantComponentIndex) end

---@param componentHash integer | string
---@param variantPropIndex integer
---@return integer, integer, integer
function GetVariantProp(componentHash, variantPropIndex) end

---@param textLabel string
---@return integer
function GetVariationChosenForScriptedLine(textLabel) end

---@param vehicle integer
---@return number
function GetVehicleAcceleration(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleAlarmTimeLeft(vehicle) end

---@param cargobob integer
---@return integer
function GetVehicleAttachedToCargobob(cargobob) end

---@param vehicle integer
---@return number
function GetVehicleBodyHealth(vehicle) end

---@param aircraft integer
---@return integer
function GetVehicleBombCount(aircraft) end

---@param vehicle integer
---@return boolean
function GetVehicleCanActivateParachute(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleCauseOfDestruction(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleCheatPowerIncrease(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleClass(vehicle) end

---@param vehicleClass integer
---@return number
function GetVehicleClassEstimatedMaxSpeed(vehicleClass) end

---@param modelHash integer | string
---@return integer
function GetVehicleClassFromName(modelHash) end

---@param vehicleClass integer
---@return number
function GetVehicleClassMaxAcceleration(vehicleClass) end

---@param vehicleClass integer
---@return number
function GetVehicleClassMaxAgility(vehicleClass) end

---@param vehicleClass integer
---@return number
function GetVehicleClassMaxBraking(vehicleClass) end

---@param vehicleClass integer
---@return number
function GetVehicleClassMaxTraction(vehicleClass) end

---@param vehicle integer
---@return number
function GetVehicleClutch(vehicle) end

---@param vehicle integer
---@return integer, integer, integer
function GetVehicleColor(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleColourCombination(vehicle) end

---@param vehicle integer
---@return integer, integer
function GetVehicleColours(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleColoursWhichCanBeSet(vehicle) end

---@param aircraft integer
---@return integer
function GetVehicleCountermeasureCount(aircraft) end

---@param vehicle integer
---@param p1 integer
---@return integer
function GetVehicleCrewEmblemRequestState(vehicle, p1) end

---@param vehicle integer
---@return integer
function GetVehicleCurrentGear(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleCurrentRpm(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleCurrentSlipstreamDraft(vehicle) end

---@param vehicle integer
---@return integer, integer, integer
function GetVehicleCustomPrimaryColour(vehicle) end

---@param vehicle integer
---@return integer, integer, integer
function GetVehicleCustomSecondaryColour(vehicle) end

---@return number
function GetVehicleDashboardBoost() end

---@param vehicle integer
---@return integer
function GetVehicleDashboardColor(vehicle) end

---@return number
function GetVehicleDashboardCurrentGear() end

---@return number
function GetVehicleDashboardFuel() end

---@return integer
function GetVehicleDashboardLights() end

---@return number
function GetVehicleDashboardOilPressure() end

---@return number
function GetVehicleDashboardOilTemp() end

---@return number
function GetVehicleDashboardRpm() end

---@param vehicle integer
---@return number
function GetVehicleDashboardSpeed(vehicle) end

---@return number
function GetVehicleDashboardTemp() end

---@return number
function GetVehicleDashboardVacuum() end

---@param vehicle integer
---@return integer
function GetVehicleDefaultHorn(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleDefaultHornIgnoreMods(vehicle) end

---@param vehicle integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@return vector3
function GetVehicleDeformationAtPos(vehicle, offsetX, offsetY, offsetZ) end

---@return number
function GetVehicleDensityMultiplier() end

---@param vehicle integer
---@return number
function GetVehicleDirtLevel(vehicle) end

---@param vehicle integer
---@param doorIndex integer
---@return number
function GetVehicleDoorAngleRatio(vehicle, doorIndex) end

---@param vehicle integer
---@return integer
function GetVehicleDoorLockStatus(vehicle) end

---@param vehicle integer
---@param player integer
---@return boolean
function GetVehicleDoorsLockedForPlayer(vehicle, player) end

---@param vehicle integer
---@return number
function GetVehicleDrawnWheelAngleMult(vehicle) end

---@param vehicleModel integer | string
---@return integer
function GetVehicleDrivetrainType(vehicleModel) end

---@param vehicle integer
---@return number
function GetVehicleEngineHealth(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleEngineTemperature(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleEnveffScale(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleEstimatedMaxSpeed(vehicle) end

---@param vehicle integer
---@return integer, integer
function GetVehicleExtraColours(vehicle) end

---@param aircraft integer
---@return number
function GetVehicleFlightNozzlePosition(aircraft) end

---@param vehicle integer
---@return number
function GetVehicleFuelLevel(vehicle) end

---@param vehicle integer
---@param gear integer
---@return number
function GetVehicleGearRatio(vehicle, gear) end

---@param vehicle integer
---@return number
function GetVehicleGravityAmount(vehicle) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@return number
function GetVehicleHandlingFloat(vehicle, class_, fieldName) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@return integer
function GetVehicleHandlingInt(vehicle, class_, fieldName) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@return vector3
function GetVehicleHandlingVector(vehicle, class_, fieldName) end

---@param vehicle integer
---@param flagIndex integer
---@return boolean
function GetVehicleHasFlag(vehicle, flagIndex) end

---@param vehicle integer
---@return boolean
function GetVehicleHasKers(vehicle) end

---@param vehicle integer
---@return boolean
function GetVehicleHasParachute(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleHealthPercentage(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleHighGear(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleHomingLockonState(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleHornSoundIndex(vehicle) end

---@param entity integer
---@return integer
function GetVehicleIndexFromEntityIndex(entity) end

---@param vehicle integer
---@return integer
function GetVehicleIndicatorLights(vehicle) end

---@param vehicle integer
---@param doorIndex integer
---@return integer
function GetVehicleIndividualDoorLockStatus(vehicle, doorIndex) end

---@param vehicle integer
---@return integer
function GetVehicleInteriorColor(vehicle) end

---@param vehicle integer
---@return boolean
function GetVehicleIsMercenary(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleLayoutHash(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleLightMultiplier(vehicle) end

---@param vehicle integer
---@return boolean, boolean, boolean
function GetVehicleLightsState(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleLivery(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleLiveryCount(vehicle) end

---@param vehicle integer
---@return boolean, integer
function GetVehicleLockOnTarget(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleMaxBraking(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleMaxNumberOfPassengers(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleMaxTraction(vehicle) end

---@param vehicle integer
---@param modType integer
---@return integer
function GetVehicleMod(vehicle, modType) end

---@param vehicle integer
---@return integer, integer, integer
function GetVehicleModColor_1(vehicle) end

---@param vehicle integer
---@param p1 boolean
---@return string
function GetVehicleModColor_1Name(vehicle, p1) end

---@param vehicle integer
---@return integer, integer
function GetVehicleModColor_2(vehicle) end

---@param vehicle integer
---@return string
function GetVehicleModColor_2Name(vehicle) end

---@param vehicle integer
---@param modType integer
---@param modIndex integer
---@return integer
function GetVehicleModIdentifierHash(vehicle, modType, modIndex) end

---@param vehicle integer
---@return integer
function GetVehicleModKit(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleModKitType(vehicle) end

---@param vehicle integer
---@param modType integer
---@param modIndex integer
---@return integer
function GetVehicleModModifierValue(vehicle, modType, modIndex) end

---@param vehicle integer
---@param modType integer
---@return boolean
function GetVehicleModVariation(vehicle, modType) end

---@param modelHash integer | string
---@return number
function GetVehicleModelAcceleration(modelHash) end

---@param modelHash integer | string
---@return number
function GetVehicleModelEstimatedAgility(modelHash) end

---@param modelHash integer | string
---@return number
function GetVehicleModelEstimatedMaxSpeed(modelHash) end

---@param modelHash integer | string
---@return number
function GetVehicleModelMaxBraking(modelHash) end

---@param modelHash integer | string
---@return number
function GetVehicleModelMaxBrakingMaxMods(modelHash) end

---@param modelHash integer | string
---@return number
function GetVehicleModelMaxKnots(modelHash) end

---@param modelHash integer | string
---@return number
function GetVehicleModelMaxTraction(modelHash) end

---@param modelHash integer | string
---@return integer
function GetVehicleModelNumberOfSeats(modelHash) end

---@param vehicleModel integer | string
---@return integer
function GetVehicleModelValue(vehicleModel) end

---@param vehicle integer
---@return integer, integer, integer
function GetVehicleNeonLightsColour(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleNextGear(vehicle) end

---@param nodeID integer
---@return boolean
function GetVehicleNodeIsGpsAllowed(nodeID) end

---@param nodeID integer
---@return boolean
function GetVehicleNodeIsSwitchedOff(nodeID) end

---@param nodeId integer
---@return vector3
function GetVehicleNodePosition(nodeId) end

---@param x number
---@param y number
---@param z number
---@return boolean, integer, integer
function GetVehicleNodeProperties(x, y, z) end

---@param vehicle integer
---@return integer
function GetVehicleNumberOfBrokenBones(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleNumberOfBrokenOffBones(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleNumberOfPassengers(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleNumberOfWheels(vehicle) end

---@param vehicle integer
---@return string
function GetVehicleNumberPlateText(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleNumberPlateTextIndex(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleOilLevel(vehicle) end

---@param ped integer
---@return integer
function GetVehiclePedIsEntering(ped) end

---@param ped integer
---@param lastVehicle? boolean [default: false]
---@return integer
function GetVehiclePedIsIn(ped, lastVehicle) end

---@param ped integer
---@return integer
function GetVehiclePedIsTryingToEnter(ped) end

---@param ped integer
---@return integer
function GetVehiclePedIsUsing(ped) end

---@param vehicle integer
---@return number
function GetVehiclePetrolTankHealth(vehicle) end

---@param vehicle integer
---@return integer
function GetVehiclePlateType(vehicle) end

---@param recording integer
---@param script string
---@return integer
function GetVehicleRecordingId(recording, script) end

---@param vehicle integer
---@return integer
function GetVehicleRoofLivery(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleRoofLiveryCount(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleSteeringScale(vehicle) end

---@param vehicle integer
---@return vector3, vector3
function GetVehicleSuspensionBounds(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleSuspensionHeight(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleThrottleOffset(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleTopSpeedModifier(vehicle) end

---@param vehicle integer
---@return boolean, integer
function GetVehicleTrailerVehicle(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleTurboPressure(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleTypeRaw(vehicle) end

---@param vehicle integer
---@return integer, integer, integer
function GetVehicleTyreSmokeColor(vehicle) end

---@param vehicle integer
---@return boolean
function GetVehicleTyresCanBurst(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleWaypointProgress(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleWaypointTargetPoint(vehicle) end

---@param vehicle integer
---@param seat integer
---@return number
function GetVehicleWeaponReloadTime(vehicle, seat) end

---@param vehicle integer
---@param weaponIndex integer
---@return integer
function GetVehicleWeaponRestrictedAmmo(vehicle, weaponIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelBrakePressure(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return integer
function GetVehicleWheelFlags(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelHealth(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return boolean
function GetVehicleWheelIsPowered(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelPower(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelRimColliderSize(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelRotationSpeed(vehicle, wheelIndex) end

---@param vehicle integer
---@return number
function GetVehicleWheelSize(vehicle) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelSpeed(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelSteeringAngle(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return integer
function GetVehicleWheelSurfaceMaterial(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelSuspensionCompression(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelTireColliderSize(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelTireColliderWidth(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelTractionVectorLength(vehicle, wheelIndex) end

---@param vehicle integer
---@return integer
function GetVehicleWheelType(vehicle) end

---@param vehicle integer
---@return number
function GetVehicleWheelWidth(vehicle) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelXOffset(vehicle, wheelIndex) end

---@param vehicle integer
---@param wheelIndex integer
---@return number
function GetVehicleWheelYRotation(vehicle, wheelIndex) end

---@param vehicle integer
---@return integer
function GetVehicleWheelieState(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleWindowTint(vehicle) end

---@param vehicle integer
---@return integer
function GetVehicleXenonLightsColor(vehicle) end

---@param vehicle integer
---@return boolean, integer, integer, integer
function GetVehicleXenonLightsCustomColor(vehicle) end

---@return number
function GetVehicleXmasSnowFactor() end

---@param name string
---@return number
function GetVisualSettingFloat(name) end

---@return integer
function GetWantedLevelParoleDuration() end

---@param player integer
---@return number
function GetWantedLevelRadius(player) end

---@param wantedLevel integer
---@return integer
function GetWantedLevelThreshold(wantedLevel) end

---@return integer
function GetWarningMessageTitleHash() end

---@param x number
---@param y number
---@param z number
---@return boolean, number
function GetWaterHeight(x, y, z) end

---@param x number
---@param y number
---@param z number
---@return boolean, number
function GetWaterHeightNoWaves(x, y, z) end

---@param waterQuad integer
---@return boolean, integer, integer, integer, integer
function GetWaterQuadAlpha(waterQuad) end

---@param x number
---@param y number
---@return integer
function GetWaterQuadAtCoords(x, y) end

---@param x number
---@param y number
---@param z number
---@return integer
function GetWaterQuadAtCoords_3d(x, y, z) end

---@param waterQuad integer
---@return boolean, integer, integer, integer, integer
function GetWaterQuadBounds(waterQuad) end

---@return integer
function GetWaterQuadCount() end

---@param waterQuad integer
---@return boolean, integer
function GetWaterQuadHasLimitedDepth(waterQuad) end

---@param waterQuad integer
---@return boolean, integer
function GetWaterQuadIsInvisible(waterQuad) end

---@param waterQuad integer
---@return boolean, number
function GetWaterQuadLevel(waterQuad) end

---@param waterQuad integer
---@return boolean, integer
function GetWaterQuadNoStencil(waterQuad) end

---@param waterQuad integer
---@return boolean, integer
function GetWaterQuadType(waterQuad) end

---@param waveQuad integer
---@return boolean, number
function GetWaveQuadAmplitude(waveQuad) end

---@param x number
---@param y number
---@return integer
function GetWaveQuadAtCoords(x, y) end

---@param waveQuad integer
---@return boolean, integer, integer, integer, integer
function GetWaveQuadBounds(waveQuad) end

---@return integer
function GetWaveQuadCount() end

---@param waveQuad integer
---@return boolean, number, number
function GetWaveQuadDirection(waveQuad) end

---@return integer
function GetWaypointBlipEnumId() end

---@param p0 string
---@param p1 integer
---@return number
function GetWaypointDistanceAlongRoute(p0, p1) end

---@param weaponHash integer | string
---@return number
function GetWeaponAccuracySpread(weaponHash) end

---@param ped integer
---@return integer
function GetWeaponAnimationOverride(ped) end

---@param weaponHash integer | string
---@return integer
function GetWeaponClipSize(weaponHash) end

---@param componentHash integer | string
---@return number
function GetWeaponComponentAccuracyModifier(componentHash) end

---@param componentHash integer | string
---@return integer
function GetWeaponComponentCameraHash(componentHash) end

---@param componentHash integer | string
---@return integer
function GetWeaponComponentClipSize(componentHash) end

---@param componentHash integer | string
---@return number
function GetWeaponComponentDamageModifier(componentHash) end

---@param componentHash integer | string
---@return boolean, integer
function GetWeaponComponentHudStats(componentHash) end

---@param componentHash integer | string
---@return number
function GetWeaponComponentRangeDamageModifier(componentHash) end

---@param componentHash integer | string
---@return number
function GetWeaponComponentRangeModifier(componentHash) end

---@param componentHash integer | string
---@return integer
function GetWeaponComponentReticuleHash(componentHash) end

---@param componentHash integer | string
---@return integer
function GetWeaponComponentTypeModel(componentHash) end

---@param componentHash integer | string
---@return integer
function GetWeaponComponentVariantExtraComponentCount(componentHash) end

---@param componentHash integer | string
---@param extraComponentIndex integer
---@return integer
function GetWeaponComponentVariantExtraComponentModel(componentHash, extraComponentIndex) end

---@param weaponHash integer | string
---@param componentHash integer | string
---@return number
function GetWeaponDamage(weaponHash, componentHash) end

---@param weaponHash integer | string
---@return number
function GetWeaponDamageModifier(weaponHash) end

---@param weaponHash integer | string
---@return integer
function GetWeaponDamageType(weaponHash) end

---@param weaponHash integer | string
---@return boolean, any
function GetWeaponHudStats(weaponHash) end

---@param ped integer
---@param p1 boolean
---@return integer
function GetWeaponObjectFromPed(ped, p1) end

---@param weaponObject integer
---@param camoComponentHash integer | string
---@return integer
function GetWeaponObjectLiveryColor(weaponObject, camoComponentHash) end

---@param weapon integer
---@return integer
function GetWeaponObjectTintIndex(weapon) end

---@param weaponHash integer | string
---@return number
function GetWeaponRecoilShakeAmplitude(weaponHash) end

---@param weaponHash integer | string
---@return number
function GetWeaponTimeBetweenShots(weaponHash) end

---@param weaponHash integer | string
---@return integer
function GetWeaponTintCount(weaponHash) end

---@param pickupHash integer | string
---@return integer
function GetWeaponTypeFromPickupType(pickupHash) end

---@param weaponHash integer | string
---@return integer
function GetWeapontypeGroup(weaponHash) end

---@param weaponHash integer | string
---@return integer
function GetWeapontypeModel(weaponHash) end

---@param weaponHash integer | string
---@return integer
function GetWeapontypeSlot(weaponHash) end

---@return integer, integer, number
function GetWeatherTypeTransition() end

---@return vector3
function GetWindDirection() end

---@return number
function GetWindSpeed() end

---@param screenX number
---@param screenY number
---@return vector3, vector3
function GetWorldCoordFromScreenCoord(screenX, screenY) end

---@param entity integer
---@param boneIndex integer
---@return vector3
function GetWorldPositionOfEntityBone(entity, boneIndex) end

---@param x number
---@param y number
---@param z number
---@return integer
function GetZoneAtCoords(x, y, z) end

---@param zoneName string
---@return integer
function GetZoneFromNameId(zoneName) end

---@param zoneId integer
---@return integer
function GetZonePopschedule(zoneId) end

---@param zoneId integer
---@return integer
function GetZoneScumminess(zoneId) end

---@param achievement integer
---@return boolean
function GiveAchievementToPlayer(achievement) end

---@param ped integer
---@param weaponHash integer | string
---@param ammoCount integer
---@param bForceInHand boolean
function GiveDelayedWeaponToPed(ped, weaponHash, ammoCount, bForceInHand) end

---@param ped integer
---@param loadoutHash integer | string
function GiveLoadoutToPed(ped, loadoutHash) end

---@param ped integer
---@param cannotRemove boolean
---@param helmetFlag integer
---@param textureIndex integer
function GivePedHelmet(ped, cannotRemove, helmetFlag, textureIndex) end

---@param ped integer
function GivePedNmMessage(ped) end

---@param ped integer
---@param p1 integer
function GivePedToPauseMenu(ped, p1) end

---@param player integer
---@param toggle boolean
function GivePlayerRagdollControl(player, toggle) end

---@param ped integer
---@param weaponHash integer | string
---@param componentHash integer | string
function GiveWeaponComponentToPed(ped, weaponHash, componentHash) end

---@param weaponObject integer
---@param addonHash integer | string
function GiveWeaponComponentToWeaponObject(weaponObject, addonHash) end

---@param weaponObject integer
---@param ped integer
function GiveWeaponObjectToPed(weaponObject, ped) end

---@param ped integer
---@param weaponHash integer | string
---@param ammoCount integer
---@param isHidden boolean
---@param bForceInHand boolean
function GiveWeaponToPed(ped, weaponHash, ammoCount, isHidden, bForceInHand) end

---@return number
function GolfTrailGetMaxHeight() end

---@param p0 integer
---@return vector3
function GolfTrailGetVisualControlPoint(p0) end

---@param p0 integer
---@param p1 integer
---@param p2 integer
---@param p3 integer
---@param p4 integer
---@param p5 integer
---@param p6 integer
---@param p7 integer
---@param p8 integer
---@param p9 integer
---@param p10 integer
---@param p11 integer
function GolfTrailSetColour(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) end

---@param toggle boolean
function GolfTrailSetEnabled(toggle) end

---@param p0 boolean
function GolfTrailSetFacing(p0) end

---@param type integer
---@param xPos number
---@param yPos number
---@param zPos number
---@param p4 number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function GolfTrailSetFixedControlPoint(type, xPos, yPos, zPos, p4, red, green, blue, alpha) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 boolean
function GolfTrailSetPath(p0, p1, p2, p3, p4, p5, p6, p7, p8) end

---@param p0 number
---@param p1 number
---@param p2 number
function GolfTrailSetRadius(p0, p1, p2) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
function GolfTrailSetShaderParams(p0, p1, p2, p3, p4) end

---@param p0 integer
---@param p1 integer
function GolfTrailSetTessellation(p0, p1) end


function GrassLodResetScriptAreas() end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param p4 number
---@param p5 number
---@param p6 number
function GrassLodShrinkScriptAreas(x, y, z, radius, p4, p5, p6) end

---@param cam integer
---@param entity integer
---@param xRot number
---@param yRot number
---@param zRot number
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param isRelative boolean
function HardAttachCamToEntity(cam, entity, xRot, yRot, zRot, xOffset, yOffset, zOffset, isRelative) end

---@param cam integer
---@param ped integer
---@param boneIndex integer
---@param xRot number
---@param yRot number
---@param zRot number
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param isRelative boolean
function HardAttachCamToPedBone(cam, ped, boneIndex, xRot, yRot, zRot, xOffset, yOffset, zOffset, isRelative) end

---@param achievement integer
---@return boolean
function HasAchievementBeenPassed(achievement) end

---@param asset string
---@return boolean
function HasActionModeAssetLoaded(asset) end

---@param slot integer
---@return boolean
function HasAdditionalTextLoaded(slot) end

---@param animDict string
---@return boolean
function HasAnimDictLoaded(animDict) end

---@param entity integer
---@param actionHash integer | string
---@return boolean
function HasAnimEventFired(entity, actionHash) end

---@param animSet string
---@return boolean
function HasAnimSetLoaded(animSet) end

---@return boolean
function HasAsyncInstallFinished() end

---@param x number
---@param y number
---@param z number
---@param p3 number
---@param p4 boolean
---@param p5 boolean
---@return boolean
function HasBulletImpactedInArea(x, y, z, p3, p4, p5) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 boolean
---@param p7 boolean
---@return boolean
function HasBulletImpactedInBox(p0, p1, p2, p3, p4, p5, p6, p7) end

---@param hash integer | string
---@param amount integer
---@return boolean
function HasButtonCombinationJustBeenEntered(hash, amount) end

---@param hash integer | string
---@return boolean
function HasCheatStringJustBeenEntered(hash) end

---@param clipSet string
---@return boolean
function HasClipSetLoaded(clipSet) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param modelHash integer | string
---@param p5 any
---@return boolean
function HasClosestObjectOfTypeBeenBroken(p0, p1, p2, p3, modelHash, p5) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param modelHash integer | string
---@param p5 boolean
---@return boolean
function HasClosestObjectOfTypeBeenCompletelyDestroyed(x, y, z, radius, modelHash, p5) end

---@param unused any
---@return boolean, boolean
function HasCloudRequestsFinished(unused) end

---@param model integer | string
---@return boolean
function HasCollisionForModelLoaded(model) end

---@param entity integer
---@return boolean
function HasCollisionLoadedAroundEntity(entity) end

---@param cutsceneName string
---@return boolean
function HasCutFileLoaded(cutsceneName) end

---@return boolean
function HasCutsceneCutThisFrame() end

---@return boolean
function HasCutsceneFinished() end

---@return boolean
function HasCutsceneLoaded() end

---@return boolean
function HasDirectorModeBeenTriggered() end

---@param entity integer
---@param animDict string
---@param animName string
---@param p3 integer
---@return boolean
function HasEntityAnimFinished(entity, animDict, animName, p3) end

---@param entity integer
---@return boolean
function HasEntityBeenDamagedByAnyObject(entity) end

---@param entity integer
---@return boolean
function HasEntityBeenDamagedByAnyPed(entity) end

---@param entity integer
---@return boolean
function HasEntityBeenDamagedByAnyVehicle(entity) end

---@param entity integer
---@param damager integer
---@param bCheckDamagerVehicle boolean
---@return boolean
function HasEntityBeenDamagedByEntity(entity, damager, bCheckDamagerVehicle) end

---@param entity integer
---@param weaponHash integer | string
---@param weaponType integer
---@return boolean
function HasEntityBeenDamagedByWeapon(entity, weaponHash, weaponType) end

---@param entity1 integer
---@param entity2 integer
---@param flags integer
---@return boolean
function HasEntityClearLosToEntity(entity1, entity2, flags) end

---@param entity1 integer
---@param entity2 integer
---@return boolean
function HasEntityClearLosToEntityInFront(entity1, entity2) end

---@param entity1 integer
---@param entity2 integer
---@param traceType integer
---@return any
function HasEntityClearLosToEntity_2(entity1, entity2, traceType) end

---@param entity integer
---@return boolean
function HasEntityCollidedWithAnything(entity) end

---@return boolean
function HasFilledVehiclePopulation() end

---@param cleanupFlags integer
---@return boolean
function HasForceCleanupOccurred(cleanupFlags) end

---@return boolean
function HasLoadedMpDataSet() end

---@return boolean
function HasLoadedSpDataSet() end

---@return boolean
function HasMenuLayoutChangedEventOccurred() end

---@param id integer
---@return boolean
function HasMinimapOverlayLoaded(id) end

---@param model integer | string
---@return boolean
function HasModelLoaded(model) end

---@param fxName string
---@return boolean
function HasNamedPtfxAssetLoaded(fxName) end

---@return boolean
function HasNetworkTimeStarted() end

---@param object integer
---@return boolean
function HasObjectBeenBroken(object) end

---@param ped integer
---@param weaponHash integer | string
---@param weaponType integer
---@return boolean
function HasPedBeenDamagedByWeapon(ped, weaponHash, weaponType) end

---@param ped integer
---@param weaponHash integer | string
---@param p2 boolean
---@return boolean
function HasPedGotWeapon(ped, weaponHash, p2) end

---@param ped integer
---@param weaponHash integer | string
---@param componentHash integer | string
---@return boolean
function HasPedGotWeaponComponent(ped, weaponHash, componentHash) end

---@param ped integer
---@return boolean
function HasPedHeadBlendFinished(ped) end

---@param ped integer
---@return boolean
function HasPedPreloadPropDataFinished(ped) end

---@param ped integer
---@return boolean
function HasPedPreloadVariationDataFinished(ped) end

---@param ped integer
---@param eventId integer
---@return boolean
function HasPedReceivedEvent(ped, eventId) end

---@return boolean
function HasPedheadshotImgUploadFailed() end

---@return boolean
function HasPedheadshotImgUploadSucceeded() end

---@param pickup integer
---@return boolean
function HasPickupBeenCollected(pickup) end

---@param player integer
---@param ms integer
---@param p2 boolean
---@return boolean
function HasPlayerBeenShotByCop(player, ms, p2) end

---@param player integer
---@return boolean
function HasPlayerBeenSpottedInStolenVehicle(player) end

---@param player integer
---@return boolean
function HasPlayerDamagedAtLeastOneNonAnimalPed(player) end

---@param player integer
---@return boolean
function HasPlayerDamagedAtLeastOnePed(player) end

---@param player integer
---@return boolean
function HasPlayerLeftTheWorld(player) end

---@param p0 any
---@return boolean
function HasPreloadModsFinished(p0) end

---@return boolean
function HasPtfxAssetLoaded() end

---@return boolean
function HasResumedFromSuspend() end

---@param scaleformHandle integer
---@return boolean
function HasScaleformContainerMovieLoadedIntoParent(scaleformHandle) end

---@param scaleformName string
---@return boolean
function HasScaleformMovieFilenameLoaded(scaleformName) end

---@param scaleformHandle integer
---@return boolean
function HasScaleformMovieLoaded(scaleformHandle) end

---@param scaleformName string
---@return boolean, integer
function HasScaleformMovieNamedLoaded(scaleformName) end

---@param hudComponent integer
---@return boolean
function HasScaleformScriptHudMovieLoaded(hudComponent) end

---@param scriptName string
---@return boolean
function HasScriptLoaded(scriptName) end

---@param scriptHash integer | string
---@return boolean
function HasScriptWithNameHashLoaded(scriptHash) end

---@param soundId integer
---@return boolean
function HasSoundFinished(soundId) end

---@param asset string
---@return boolean
function HasStealthModeAssetLoaded(asset) end

---@param textureDict string
---@return boolean
function HasStreamedTextureDictLoaded(textureDict) end

---@param gxt string
---@param slot integer
---@return boolean
function HasThisAdditionalTextLoaded(gxt, slot) end

---@param cutsceneName string
---@return boolean
function HasThisCutsceneLoaded(cutsceneName) end

---@param vehicleAsset integer
---@return boolean
function HasVehicleAssetLoaded(vehicleAsset) end

---@param driver integer
---@param vehicle integer
---@param weaponHash integer | string
---@param p3 any
---@return boolean
function HasVehicleGotProjectileAttached(driver, vehicle, weaponHash, p3) end

---@return boolean
function HasVehiclePhoneExplosiveDevice() end

---@param recording integer
---@param script string
---@return boolean
function HasVehicleRecordingBeenLoaded(recording, script) end

---@param weaponHash integer | string
---@return boolean
function HasWeaponAssetLoaded(weaponHash) end

---@param weapon integer
---@param addonHash integer | string
---@return boolean
function HasWeaponGotWeaponComponent(weapon, addonHash) end

---@param vehicle integer
---@param seat integer
---@return boolean
function HasWeaponReloadingInVehicle(vehicle, seat) end

---@param ped integer
---@return boolean
function HaveAllStreamingRequestsCompleted(ped) end

---@return boolean
function HaveCreditsReachedEnd() end

---@param vehicle integer
---@return boolean
function HaveVehicleModsStreamedIn(vehicle) end


function HideAreaAndVehicleNameThisFrame() end


function HideHelpTextThisFrame() end


function HideHudAndRadarThisFrame() end

---@param id integer
function HideHudComponentThisFrame(id) end


function HideLoadingOnFadeThisFrame() end


function HideMinimapExteriorMapThisFrame() end


function HideMinimapInteriorMapThisFrame() end

---@param blip integer
function HideNumberOnBlip(blip) end

---@param ped integer
---@param p1 any
---@param p2 boolean
function HidePedBloodDamageByZone(ped, p1, p2) end

---@param ped integer
---@param toggle boolean
function HidePedWeaponForScriptedCutscene(ped, toggle) end

---@param pickup integer
---@param toggle boolean
function HidePortablePickupWhenDetached(pickup, toggle) end

---@param id integer
function HideScriptedHudComponentThisFrame(id) end

---@param vehicle integer
---@param toggle boolean
function HideVehicleTombstone(vehicle, toggle) end

---@param bankName string
---@param bOverNetwork boolean
---@return boolean
function HintAmbientAudioBank(bankName, bOverNetwork) end

---@param bankName string
---@param bOverNetwork boolean
---@param playerBits integer
---@return boolean
function HintMissionAudioBank(bankName, bOverNetwork, playerBits) end

---@param bankName string
---@param bOverNetwork boolean
---@return boolean
function HintScriptAudioBank(bankName, bOverNetwork) end

---@param p0 any
---@param p1 any
function HiredLimo(p0, p1) end


function HudDisplayLoadingScreenTips() end

---@param show boolean
function HudForceWeaponWheel(show) end

---@param weaponHash integer | string
function HudSetWeaponWheelTopSlot(weaponHash) end

---@return integer
function HudWeaponWheelGetSelectedHash() end

---@param weaponTypeIndex integer
---@return integer
function HudWeaponWheelGetSlotHash(weaponTypeIndex) end

---@param toggle boolean
function HudWeaponWheelIgnoreControlInput(toggle) end


function HudWeaponWheelIgnoreSelection() end


function IgnoreMenuPreferenceForBonnetCameraThisUpdate() end

---@param toggle boolean
function IgnoreNextRestart(toggle) end


function InitCreatorBudget() end

---@return integer
function InitShopPedComponent() end

---@return integer
function InitShopPedProp() end

---@param audioName string
---@param entity integer
function InitSynchSceneAudioWithEntity(audioName, entity) end

---@param audioName string
---@param x number
---@param y number
---@param z number
function InitSynchSceneAudioWithPosition(audioName, x, y, z) end


function InstantlyFillPedPopulation() end


function InstantlyFillVehiclePopulation() end

---@param value integer
---@return integer
function IntToParticipantindex(value) end

---@param value integer
---@return integer
function IntToPlayerindex(value) end

---@param camera integer
---@param camPosX number
---@param camPosY number
---@param camPosZ number
---@param camRotX number
---@param camRotY number
---@param camRotZ number
---@param fov number
---@param duration integer
---@param posCurveType integer
---@param rotCurveType integer
---@param rotOrder integer
---@param fovCurveType integer
function InterpolateCamWithParams(camera, camPosX, camPosY, camPosZ, camRotX, camRotY, camRotZ, fov, duration, posCurveType, rotCurveType, rotOrder, fovCurveType) end

---@param interrupterPed integer
---@param context string
---@param voiceName string
function InterruptConversation(interrupterPed, context, voiceName) end

---@param interrupterPed integer
---@param context string
---@param voiceName string
function InterruptConversationAndPause(interrupterPed, context, voiceName) end


function InvalidateIdleCam() end


function InvalidateVehicleIdleCam() end

---@return boolean
function IsAimCamActive() end

---@return boolean
function IsAimCamThirdPersonActive() end

---@param alarmName string
---@return boolean
function IsAlarmPlaying(alarmName) end

---@return boolean
function IsAllowedIndependentCameraModes() end

---@param ped integer
---@return boolean
function IsAmbientSpeechDisabled(ped) end

---@param ped integer
---@return boolean
function IsAmbientSpeechPlaying(ped) end

---@param ambientZone string
---@return boolean
function IsAmbientZoneEnabled(ambientZone) end

---@param handle integer
---@return boolean
function IsAnEntity(handle) end

---@param pedHandle integer
---@return boolean
function IsAnimalVocalizationPlaying(pedHandle) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean, integer
function IsAnyAirDefenseZoneInsideSphere(x, y, z, radius) end

---@param vehicle integer
---@return boolean
function IsAnyEntityAttachedToHandlerFrame(vehicle) end

---@param garageHash integer | string
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@param p4 any
---@return boolean
function IsAnyEntityEntirelyInsideGarage(garageHash, p1, p2, p3, p4) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function IsAnyHostilePedNearPoint(ped, x, y, z, radius) end

---@param x number
---@param y number
---@param z number
---@param range number
---@param p4 boolean
---@return boolean
function IsAnyObjectNearPoint(x, y, z, range, p4) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function IsAnyPedNearPoint(x, y, z, radius) end

---@param vehicle integer
---@return boolean
function IsAnyPedRappellingFromHeli(vehicle) end

---@param minX number
---@param minY number
---@param minZ number
---@param maxX number
---@param maxY number
---@param maxZ number
---@param bHighlightArea boolean
---@param bDo3DCheck boolean
---@return boolean
function IsAnyPedShootingInArea(minX, minY, minZ, maxX, maxY, maxZ, bHighlightArea, bDo3DCheck) end

---@return boolean
function IsAnyPositionalSpeechPlaying() end

---@param ped integer
---@return boolean
function IsAnySpeechPlaying(ped) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function IsAnyVehicleNearPoint(x, y, z, radius) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 boolean
---@param p7 boolean
---@param p8 boolean
---@param p9 boolean
---@param p10 boolean
---@param p11 any
---@param p12 boolean
---@return boolean
function IsAreaOccupied(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12) end

---@param scene string
---@return boolean
function IsAudioSceneActive(scene) end

---@return boolean
function IsAussieVersion() end

---@return boolean
function IsAutoSaveInProgress() end

---@param vehicle integer
---@return boolean
function IsBigVehicle(vehicle) end

---@return boolean
function IsBigmapActive() end

---@return boolean
function IsBigmapFull() end

---@param address integer
---@param offset integer
---@return boolean
function IsBitSet(address, offset) end

---@param blip integer
---@return boolean
function IsBlipFlashing(blip) end

---@param blip integer
---@return boolean
function IsBlipOnMinimap(blip) end

---@param blip integer
---@return boolean
function IsBlipShortRange(blip) end

---@param boat integer
---@return boolean
function IsBoatAnchored(boat) end

---@return boolean
function IsBonnetCinematicCamRendering() end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param ownedByPlayer boolean
---@return boolean
function IsBulletInAngledArea(x1, y1, z1, x2, y2, z2, width, ownedByPlayer) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param ownedByPlayer boolean
---@return boolean
function IsBulletInArea(x, y, z, radius, ownedByPlayer) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param ownedByPlayer boolean
---@return boolean
function IsBulletInBox(x1, y1, z1, x2, y2, z2, ownedByPlayer) end

---@param cam integer
---@return boolean
function IsCamActive(cam) end

---@param cam integer
---@return boolean
function IsCamInterpolating(cam) end

---@param cam integer
---@param animName string
---@param animDictionary string
---@return boolean
function IsCamPlayingAnim(cam, animName, animDictionary) end

---@param cam integer
---@return boolean
function IsCamRendering(cam) end

---@param cam integer
---@return boolean
function IsCamShaking(cam) end

---@param p0 any
---@return boolean
function IsCamSplinePaused(p0) end

---@return boolean
function IsCinematicCamInputActive() end

---@return boolean
function IsCinematicCamRendering() end

---@return boolean
function IsCinematicCamShaking() end

---@return boolean
function IsCinematicIdleCamRendering() end

---@param p0 any
---@return boolean
function IsCinematicShotActive(p0) end

---@param x number
---@param y number
---@param z number
---@return boolean
function IsCollisionMarkedOutside(x, y, z) end

---@return boolean
function IsCommandLineBenchmarkValueSet() end

---@return boolean
function IsCommerceDataValid() end

---@return boolean
function IsCommerceStoreOpen() end

---@param itemHash integer | string
---@return boolean
function IsContentItemLocked(itemHash) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsControlEnabled(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsControlJustPressed(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsControlJustReleased(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsControlPressed(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsControlReleased(padIndex, control) end

---@param ped integer
---@return boolean
function IsConversationPedDead(ped) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean
function IsCopPedInArea_3d(x1, y1, z1, x2, y2, z2) end

---@param x1 number
---@param x2 number
---@param y1 number
---@param y2 number
---@param z1 number
---@param z2 number
---@return boolean
function IsCopVehicleInArea_3d(x1, x2, y1, y2, z1, z2) end

---@return boolean
function IsCutsceneActive() end

---@param flag integer
---@return boolean
function IsCutscenePlaybackFlagSet(flag) end

---@return boolean
function IsCutscenePlaying() end

---@param netID integer
---@return boolean
function IsDamageTrackerActiveOnNetworkId(netID) end

---@param player integer
---@return boolean
function IsDamageTrackerActiveOnPlayer(player) end

---@param decal integer
---@return boolean
function IsDecalAlive(decal) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsDisabledControlJustPressed(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsDisabledControlJustReleased(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsDisabledControlPressed(padIndex, control) end

---@param padIndex integer
---@param control integer
---@return boolean
function IsDisabledControlReleased(padIndex, control) end

---@param rawKeyIndex integer
---@return boolean
function IsDisabledRawKeyDown(rawKeyIndex) end

---@param rawKeyIndex integer
---@return boolean
function IsDisabledRawKeyPressed(rawKeyIndex) end

---@param rawKeyIndex integer
---@return boolean
function IsDisabledRawKeyReleased(rawKeyIndex) end

---@param rawKeyIndex integer
---@return boolean
function IsDisabledRawKeyUp(rawKeyIndex) end

---@param dlcHash integer | string
---@return boolean
function IsDlcPresent(dlcHash) end

---@param hash integer | string
---@return boolean
function IsDlcVehicleMod(hash) end

---@param doorHash integer | string
---@return boolean
function IsDoorClosed(doorHash) end

---@param doorHash integer | string
---@return boolean
function IsDoorRegisteredWithSystem(doorHash) end

---@param ped integer
---@return boolean
function IsDrivebyTaskUnderneathDrivingTask(ped) end

---@param duiObject integer
---@return boolean
function IsDuiAvailable(duiObject) end

---@return boolean
function IsDurangoVersion() end

---@param entity integer
---@return boolean
function IsEntityAMissionEntity(entity) end

---@param entity integer
---@return boolean
function IsEntityAPed(entity) end

---@param entity integer
---@return boolean
function IsEntityAVehicle(entity) end

---@param entity integer
---@return boolean
function IsEntityAnObject(entity) end

---@param entity integer
---@param xPos number
---@param yPos number
---@param zPos number
---@param xSize number
---@param ySize number
---@param zSize number
---@param highlightArea boolean
---@param do3dCheck boolean
---@param transportMode integer
---@return boolean
function IsEntityAtCoord(entity, xPos, yPos, zPos, xSize, ySize, zSize, highlightArea, do3dCheck, transportMode) end

---@param entity integer
---@param target integer
---@param xSize number
---@param ySize number
---@param zSize number
---@param highlightArea boolean
---@param do3dCheck boolean
---@param transportMode integer
---@return boolean
function IsEntityAtEntity(entity, target, xSize, ySize, zSize, highlightArea, do3dCheck, transportMode) end

---@param entity integer
---@return boolean
function IsEntityAttached(entity) end

---@param entity integer
---@return boolean
function IsEntityAttachedToAnyObject(entity) end

---@param entity integer
---@return boolean
function IsEntityAttachedToAnyPed(entity) end

---@param entity integer
---@return boolean
function IsEntityAttachedToAnyVehicle(entity) end

---@param from integer
---@param to integer
---@return boolean
function IsEntityAttachedToEntity(from, to) end

---@param vehicle integer
---@param entity integer
---@return boolean
function IsEntityAttachedToHandlerFrame(vehicle, entity) end

---@param entity integer
---@return boolean
function IsEntityDead(entity) end

---@param entity integer
---@return boolean
function IsEntityFocus(entity) end

---@param entity integer
---@return boolean
function IsEntityGhostedToLocalPlayer(entity) end

---@param entity integer
---@return boolean
function IsEntityInAir(entity) end

---@param entity integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param debug boolean
---@param includez boolean
---@param p10 any
---@return boolean
function IsEntityInAngledArea(entity, x1, y1, z1, x2, y2, z2, width, debug, includez, p10) end

---@param entity integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param p7 boolean
---@param p8 boolean
---@param p9 any
---@return boolean
function IsEntityInArea(entity, x1, y1, z1, x2, y2, z2, p7, p8, p9) end

---@param entity integer
---@return boolean
function IsEntityInWater(entity) end

---@param entity integer
---@param zone string
---@return boolean
function IsEntityInZone(entity, zone) end

---@param entity integer
---@return boolean
function IsEntityOccluded(entity) end

---@param entity integer
---@return boolean
function IsEntityOnFire(entity) end

---@param entity integer
---@return boolean
function IsEntityOnScreen(entity) end

---@param entity integer
---@param animDict string
---@param animName string
---@param taskFlag integer
---@return boolean
function IsEntityPlayingAnim(entity, animDict, animName, taskFlag) end

---@param entity integer
---@return boolean
function IsEntityStatic(entity) end

---@param entity integer
---@param targetEntity integer
---@return boolean
function IsEntityTouchingEntity(entity, targetEntity) end

---@param entity integer
---@param modelHash integer | string
---@return boolean
function IsEntityTouchingModel(entity, modelHash) end

---@param entity integer
---@param angle number
---@return boolean
function IsEntityUpright(entity, angle) end

---@param entity integer
---@return boolean
function IsEntityUpsidedown(entity) end

---@param entity integer
---@return boolean
function IsEntityVisible(entity) end

---@param entity integer
---@return boolean
function IsEntityVisibleToScript(entity) end

---@param entity integer
---@return boolean
function IsEntityWaitingForWorldCollision(entity) end

---@param ped integer
---@param vehicle integer
---@param seatIndex integer
---@param checkSide boolean
---@param leftSide boolean
---@return boolean
function IsEntryPointForSeatClear(ped, vehicle, seatIndex, checkSide, leftSide) end

---@param explosionType integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean
function IsExplosionActiveInArea(explosionType, x1, y1, z1, x2, y2, z2) end

---@param explosionType integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@return boolean
function IsExplosionInAngledArea(explosionType, x1, y1, z1, x2, y2, z2, width) end

---@param explosionType integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean
function IsExplosionInArea(explosionType, x1, y1, z1, x2, y2, z2) end

---@param explosionType integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function IsExplosionInSphere(explosionType, x, y, z, radius) end

---@return boolean
function IsFirstPersonAimCamActive() end

---@param ped integer
---@return boolean
function IsFlashLightOn(ped) end

---@param hudIndex integer
---@return boolean
function IsFloatingHelpTextOnScreen(hudIndex) end

---@return boolean
function IsFollowPedCamActive() end

---@return boolean
function IsFollowVehicleCamActive() end

---@return boolean
function IsFrontendFading() end

---@return boolean
function IsFrontendReadyForControl() end

---@return boolean
function IsGameEnhancedVersion() end

---@return boolean
function IsGameInControlOfMusic() end

---@return boolean
function IsGameplayCamLookingBehind() end

---@return boolean
function IsGameplayCamRendering() end

---@return boolean
function IsGameplayCamShaking() end

---@return boolean
function IsGameplayHintActive() end

---@param garageHash integer | string
---@param p1 boolean
---@param p2 integer
---@return boolean
function IsGarageEmpty(garageHash, p1, p2) end

---@param handler integer
---@param container integer
---@return boolean
function IsHandlerFrameAboveContainer(handler, container) end

---@param vehicle integer
---@return boolean
function IsHeliLandingAreaBlocked(vehicle) end

---@param vehicle integer
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@return boolean
function IsHeliPartBroken(vehicle, p1, p2, p3) end

---@return boolean
function IsHelpMessageBeingDisplayed() end

---@return boolean
function IsHelpMessageFadingOut() end

---@return boolean
function IsHelpMessageOnScreen() end

---@param vehicle integer
---@return boolean
function IsHornActive(vehicle) end

---@return boolean
function IsHoveringOverMissionCreatorBlip() end

---@param id integer
---@return boolean
function IsHudComponentActive(id) end

---@return boolean
function IsHudHidden() end

---@return boolean
function IsHudPreferenceSwitchedOn() end

---@param p0 any
---@param p1 any
---@return boolean
function IsInItemset(p0, p1) end

---@return boolean
function IsInPowerSavingMode() end

---@return boolean
function IsInVehicleCamDisabled() end

---@param incidentId integer
---@return boolean
function IsIncidentValid(incidentId) end

---@param interiorID integer
---@return boolean
function IsInteriorCapped(interiorID) end

---@param interior integer
---@return boolean
function IsInteriorDisabled(interior) end

---@param interior integer
---@param entitySetName string
---@return boolean
function IsInteriorEntitySetActive(interior, entitySetName) end

---@param interiorID integer
---@return boolean
function IsInteriorReady(interiorID) end

---@return boolean
function IsInteriorRenderingDisabled() end

---@return boolean
function IsInteriorScene() end

---@param iplName string
---@return boolean
function IsIplActive(iplName) end

---@param p0 any
---@return boolean
function IsItemsetValid(p0) end

---@return boolean
function IsJapaneseVersion() end

---@return boolean
function IsLookInverted() end

---@return boolean
function IsMemoryCardInUse() end

---@return boolean
function IsMessageBeingDisplayed() end

---@return boolean
function IsMinigameInProgress() end

---@return boolean
function IsMinimapRendering() end

---@return boolean
function IsMissionCompletePlaying() end

---@return boolean
function IsMissionCompleteReadyForUi() end

---@param blip integer
---@return boolean
function IsMissionCreatorBlip(blip) end

---@param newsStory integer
---@return boolean
function IsMissionNewsStoryUnlocked(newsStory) end

---@param vehicle integer
---@return boolean
function IsMissionTrain(vehicle) end

---@return boolean
function IsMobileInterferenceActive() end

---@return boolean
function IsMobilePhoneCallOngoing() end

---@return boolean
function IsMobilePhoneRadioActive() end

---@param model integer | string
---@return boolean
function IsModelAPed(model) end

---@param model integer | string
---@return boolean
function IsModelAVehicle(model) end

---@param model integer | string
---@return boolean
function IsModelInCdimage(model) end

---@param model integer | string
---@return boolean
function IsModelValid(model) end

---@param ped integer
---@return boolean
function IsMountedWeaponTaskUnderneathDrivingTask(ped) end

---@return boolean
function IsMouseRolledOverInstructionalButtons() end

---@param ped integer
---@return boolean
function IsMoveBlendRatioRunning(ped) end

---@param ped integer
---@return boolean
function IsMoveBlendRatioSprinting(ped) end

---@param ped integer
---@return boolean
function IsMoveBlendRatioStill(ped) end

---@param ped integer
---@return boolean
function IsMoveBlendRatioWalking(ped) end

---@param gamerTagId integer
---@return boolean
function IsMpGamerTagActive(gamerTagId) end

---@param gamerTagId integer
---@return boolean
function IsMpGamerTagFree(gamerTagId) end

---@return boolean
function IsMpGamerTagMovieActive() end

---@return boolean
function IsMultiplayerChatActive() end

---@return boolean
function IsMusicOneshotPlaying() end

---@param modelHash integer | string
---@return boolean
function IsNamedRendertargetLinked(modelHash) end

---@param name string
---@return boolean
function IsNamedRendertargetRegistered(name) end

---@return any
function IsNavigatingMenuContent() end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean
function IsNavmeshLoadedInArea(x1, y1, z1, x2, y2, z2) end

---@return boolean
function IsNavmeshRequiredRegionOwnedByAnyThread() end

---@param netId integer
---@return boolean
function IsNetworkIdOwnedByParticipant(netId) end

---@return boolean
function IsNetworkLoadingScene() end

---@return boolean
function IsNewLoadSceneActive() end

---@return boolean
function IsNewLoadSceneLoaded() end

---@param weatherType string
---@return boolean
function IsNextWeatherType(weatherType) end

---@param vehicle integer
---@return boolean
function IsNitrousActive(vehicle) end

---@return boolean
function IsNuiFocusKeepingInput() end

---@return boolean
function IsNuiFocused() end

---@param object integer
---@return boolean
function IsObjectAPickup(object) end

---@param object integer
---@return boolean
function IsObjectAPortablePickup(object) end

---@param garageHash integer | string
---@param entity integer
---@param p2 number
---@param p3 integer
---@return boolean
function IsObjectEntirelyInsideGarage(garageHash, entity, p2, p3) end

---@param objectHash integer | string
---@param x number
---@param y number
---@param z number
---@param range number
---@return boolean
function IsObjectNearPoint(objectHash, x, y, z, range) end

---@param garageHash integer | string
---@param entity integer
---@param p2 integer
---@return boolean
function IsObjectPartiallyInsideGarage(garageHash, entity, p2) end

---@param object integer
---@return boolean
function IsObjectVisible(object) end

---@param object integer
---@return boolean
function IsObjectWithinBrainActivationRange(object) end

---@return boolean
function IsOnlinePoliciesMenuActive() end

---@return boolean
function IsOrbisVersion() end

---@return boolean
function IsPauseMenuActive() end

---@return boolean
function IsPauseMenuRestarting() end

---@return boolean
function IsPausemapInInteriorMode() end

---@return boolean
function IsPcVersion() end

---@param ped integer
---@return boolean
function IsPedAPlayer(ped) end

---@param ped integer
---@return boolean
function IsPedActiveInScenario(ped) end

---@param ped integer
---@return boolean
function IsPedAimingFromCover(ped) end

---@param ped integer
---@param typeFlags integer
---@return boolean
function IsPedArmed(ped, typeFlags) end

---@param ped integer
---@return boolean
function IsPedBeingArrested(ped) end

---@param ped integer
---@return boolean
function IsPedBeingJacked(ped) end

---@param ped integer
---@return boolean
function IsPedBeingStealthKilled(ped) end

---@param ped integer
---@param p1 integer
---@return boolean
function IsPedBeingStunned(ped, p1) end

---@param colorID integer
---@return boolean
function IsPedBlushColorValid(colorID) end

---@param colorId integer
---@return boolean
function IsPedBlushColorValid_2(colorId) end

---@param colorID integer
---@return boolean
function IsPedBodyBlemishValid(colorID) end

---@param ped integer
---@return boolean
function IsPedClimbing(ped) end

---@param ped integer
---@param componentId integer
---@param collection string
---@param drawableId integer
---@return boolean
function IsPedCollectionComponentVariationGen9Exclusive(ped, componentId, collection, drawableId) end

---@param ped integer
---@param componentId integer
---@param collection string
---@param drawableId integer
---@param textureId integer
---@return boolean
function IsPedCollectionComponentVariationValid(ped, componentId, collection, drawableId, textureId) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@return boolean
function IsPedComponentVariationGen9Exclusive(ped, componentId, drawableId) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@param textureId integer
---@return boolean
function IsPedComponentVariationValid(ped, componentId, drawableId, textureId) end

---@param ped integer
---@return boolean
function IsPedCuffed(ped) end

---@param ped integer
---@return boolean
function IsPedCurrentWeaponSilenced(ped) end

---@param ped integer
---@param checkMeleeDeathFlags boolean
---@return boolean
function IsPedDeadOrDying(ped, checkMeleeDeathFlags) end

---@param ped integer
---@param p1 boolean
---@return boolean
function IsPedDefensiveAreaActive(ped, p1) end

---@param ped integer
---@return boolean
function IsPedDiving(ped) end

---@param ped integer
---@return boolean
function IsPedDoingBeastJump(ped) end

---@param ped integer
---@return boolean
function IsPedDoingDriveby(ped) end

---@param ped integer
---@return boolean
function IsPedDucking(ped) end

---@param ped integer
---@return boolean, integer
function IsPedEvasiveDiving(ped) end

---@param ped integer
---@param vehicle integer
---@return boolean, integer
function IsPedExclusiveDriverOfVehicle(ped, vehicle) end

---@param ped integer
---@param otherPed integer
---@param angle number
---@return boolean
function IsPedFacingPed(ped, otherPed, angle) end

---@param ped integer
---@return boolean
function IsPedFalling(ped) end

---@param ped integer
---@return boolean
function IsPedFatallyInjured(ped) end

---@param ped integer
---@return boolean
function IsPedFleeing(ped) end

---@param ped integer
---@return boolean
function IsPedGettingIntoAVehicle(ped) end

---@param ped integer
---@return boolean
function IsPedGettingUp(ped) end

---@param ped integer
---@return boolean
function IsPedGoingIntoCover(ped) end

---@param ped integer
---@param groupId integer
---@return boolean
function IsPedGroupMember(ped, groupId) end

---@param colorID integer
---@return boolean
function IsPedHairColorValid(colorID) end

---@param colorId integer
---@return boolean
function IsPedHairColorValid_2(colorId) end

---@param ped integer
---@return boolean
function IsPedHangingOnToVehicle(ped) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param p4 number
---@return boolean
function IsPedHeadingTowardsPosition(ped, x, y, z, p4) end

---@param ped integer
---@param entity integer
---@return boolean
function IsPedHeadtrackingEntity(ped, entity) end

---@param ped1 integer
---@param ped2 integer
---@return boolean
function IsPedHeadtrackingPed(ped1, ped2) end

---@param ped integer
---@return boolean
function IsPedHelmetUnk(ped) end

---@param ped integer
---@return boolean
function IsPedHuman(ped) end

---@param ped integer
---@return boolean
function IsPedHurt(ped) end

---@param ped integer
---@return boolean
function IsPedInAnyBoat(ped) end

---@param ped integer
---@return boolean
function IsPedInAnyHeli(ped) end

---@param ped integer
---@return boolean
function IsPedInAnyPlane(ped) end

---@param ped integer
---@return boolean
function IsPedInAnyPoliceVehicle(ped) end

---@param ped integer
---@return boolean
function IsPedInAnySub(ped) end

---@param ped integer
---@return boolean
function IsPedInAnyTaxi(ped) end

---@param ped integer
---@return boolean
function IsPedInAnyTrain(ped) end

---@param ped integer
---@param atGetIn? boolean [default: false]
---@return boolean
function IsPedInAnyVehicle(ped, atGetIn) end

---@param ped integer
---@param target integer
---@return boolean
function IsPedInCombat(ped, target) end

---@param ped integer
---@param exceptUseWeapon boolean
---@return boolean
function IsPedInCover(ped, exceptUseWeapon) end

---@param ped integer
---@return boolean
function IsPedInCoverFacingLeft(ped) end

---@param ped integer
---@return boolean
function IsPedInCurrentConversation(ped) end

---@param ped integer
---@return boolean
function IsPedInFlyingVehicle(ped) end

---@param ped integer
---@return boolean
function IsPedInGroup(ped) end

---@param ped integer
---@return boolean
function IsPedInHighCover(ped) end

---@param ped integer
---@return boolean
function IsPedInMeleeCombat(ped) end

---@param ped integer
---@param modelHash integer | string
---@return boolean
function IsPedInModel(ped, modelHash) end

---@param ped integer
---@return boolean
function IsPedInParachuteFreeFall(ped) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param range number
---@return boolean
function IsPedInSphereAreaOfAnyEnemyPeds(ped, x, y, z, range) end

---@param ped integer
---@param vehicle integer
---@param atGetIn boolean
---@return boolean
function IsPedInVehicle(ped, vehicle, atGetIn) end

---@param ped integer
---@return boolean
function IsPedInWrithe(ped) end

---@param ped integer
---@return boolean
function IsPedInjured(ped) end

---@param ped integer
---@return boolean
function IsPedJacking(ped) end

---@param ped integer
---@return boolean
function IsPedJumping(ped) end

---@param ped integer
---@return boolean
function IsPedJumpingOutOfVehicle(ped) end

---@param colorID integer
---@return boolean
function IsPedLipstickColorValid(colorID) end

---@param colorId integer
---@return boolean
function IsPedLipstickColorValid_2(colorId) end

---@param ped integer
---@return boolean
function IsPedMale(ped) end

---@param ped integer
---@param modelHash integer | string
---@return boolean
function IsPedModel(ped, modelHash) end

---@param ped integer
---@return boolean
function IsPedOnAnyBike(ped) end

---@param ped integer
---@return boolean
function IsPedOnFoot(ped) end

---@param ped integer
---@return boolean
function IsPedOnMount(ped) end

---@param ped integer
---@param vehicle integer
---@return boolean
function IsPedOnSpecificVehicle(ped, vehicle) end

---@param ped integer
---@return boolean
function IsPedOnVehicle(ped) end

---@param ped integer
---@return boolean
function IsPedOpeningADoor(ped) end

---@param ped integer
---@return boolean
function IsPedPerformingDependentComboLimit(ped) end

---@param ped integer
---@return boolean
function IsPedPerformingMeleeAction(ped) end

---@param ped integer
---@return boolean
function IsPedPerformingStealthKill(ped) end

---@param ped integer
---@return boolean
function IsPedPlantingBomb(ped) end

---@param ped integer
---@return boolean
function IsPedPlayingBaseClipInScenario(ped) end

---@param ped integer
---@return boolean
function IsPedProne(ped) end

---@param ped integer
---@return boolean
function IsPedRagdoll(ped) end

---@param ped integer
---@return boolean
function IsPedReloading(ped) end

---@param ped integer
---@param event any
---@return boolean
function IsPedRespondingToEvent(ped, event) end

---@param ped integer
---@return boolean
function IsPedRingtonePlaying(ped) end

---@param ped integer
---@return boolean
function IsPedRunning(ped) end

---@param ped integer
---@return boolean
function IsPedRunningArrestTask(ped) end

---@param ped integer
---@return boolean
function IsPedRunningMeleeTask(ped) end

---@param ped integer
---@return boolean
function IsPedRunningMobilePhoneTask(ped) end

---@param ped integer
---@return boolean
function IsPedRunningRagdollTask(ped) end

---@param ped integer
---@return boolean
function IsPedShaderEffectValid(ped) end

---@param ped integer
---@return boolean
function IsPedSheltered(ped) end

---@param ped integer
---@return boolean
function IsPedShooting(ped) end

---@param ped integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param p7 boolean
---@param p8 boolean
---@return boolean
function IsPedShootingInArea(ped, x1, y1, z1, x2, y2, z2, p7, p8) end

---@param ped integer
---@return boolean
function IsPedSittingInAnyVehicle(ped) end

---@param ped integer
---@param vehicle integer
---@return boolean
function IsPedSittingInVehicle(ped, vehicle) end

---@param ped integer
---@return boolean
function IsPedSprinting(ped) end

---@param ped integer
---@return boolean
function IsPedStill(ped) end

---@param ped integer
---@return boolean
function IsPedStopped(ped) end

---@param ped integer
---@return boolean
function IsPedStrafing(ped) end

---@param Ped integer
---@return boolean
function IsPedSwappingWeapon(Ped) end

---@param ped integer
---@return boolean
function IsPedSwimming(ped) end

---@param ped integer
---@return boolean
function IsPedSwimmingUnderWater(ped) end

---@param ped integer
---@return boolean
function IsPedTakingOffHelmet(ped) end

---@param ped integer
---@return boolean
function IsPedTracked(ped) end

---@param ped integer
---@return boolean
function IsPedTryingToEnterALockedVehicle(ped) end

---@param ped integer
---@return boolean
function IsPedUsingActionMode(ped) end

---@param ped integer
---@return boolean
function IsPedUsingAnyScenario(ped) end

---@param ped integer
---@param scenario string
---@return boolean
function IsPedUsingScenario(ped, scenario) end

---@param ped integer
---@return boolean
function IsPedVaulting(ped) end

---@param ped integer
---@return boolean
function IsPedWalking(ped) end

---@param ped integer
---@param weaponHash integer | string
---@param componentHash integer | string
---@return boolean
function IsPedWeaponComponentActive(ped, weaponHash, componentHash) end

---@param ped integer
---@return boolean
function IsPedWeaponReadyToShoot(ped) end

---@param ped integer
---@return boolean
function IsPedWearingHelmet(ped) end

---@return boolean
function IsPedheadshotImgUploadAvailable() end

---@param id integer
---@return boolean
function IsPedheadshotReady(id) end

---@param id integer
---@return boolean
function IsPedheadshotValid(id) end

---@param object integer
---@return boolean
function IsPickupWeaponObjectValid(object) end

---@param plane integer
---@return boolean
function IsPlaneLandingGearIntact(plane) end

---@param vehicle integer
---@return boolean
function IsPlaybackGoingOnForVehicle(vehicle) end

---@param vehicle integer
---@return boolean
function IsPlaybackUsingAiGoingOnForVehicle(vehicle) end

---@param player integer
---@return boolean
function IsPlayerBattleAware(player) end

---@param player integer
---@param atArresting boolean
---@return boolean
function IsPlayerBeingArrested(player, atArresting) end

---@param player integer
---@return boolean
function IsPlayerBluetoothEnable(player) end

---@param player integer
---@return boolean
function IsPlayerClimbing(player) end

---@param player integer
---@return boolean
function IsPlayerControlOn(player) end

---@param player integer
---@return boolean
function IsPlayerDead(player) end

---@param player integer
---@param type integer
---@return boolean
function IsPlayerDrivingDangerously(player, type) end

---@param garageHash integer | string
---@param player integer
---@param p2 number
---@param p3 integer
---@return boolean
function IsPlayerEntirelyInsideGarage(garageHash, player, p2, p3) end

---@param player integer
---@return boolean
function IsPlayerFreeAiming(player) end

---@param player integer
---@param entity integer
---@return boolean
function IsPlayerFreeAimingAtEntity(player, entity) end

---@param player integer
---@return boolean
function IsPlayerFreeForAmbientTask(player) end

---@param player integer
---@return boolean
function IsPlayerInCutscene(player) end

---@return boolean
function IsPlayerLoggingInNp() end

---@return boolean
function IsPlayerOnline() end

---@param garageHash integer | string
---@param player integer
---@param p2 integer
---@return boolean
function IsPlayerPartiallyInsideGarage(garageHash, player, p2) end

---@param player integer
---@return boolean
function IsPlayerPlaying(player) end

---@param player integer
---@return boolean
function IsPlayerPressingHorn(player) end

---@param player integer
---@return boolean
function IsPlayerReadyForCutscene(player) end

---@param player integer
---@return boolean
function IsPlayerRidingTrain(player) end

---@param player integer
---@return boolean
function IsPlayerScriptControlOn(player) end

---@return boolean
function IsPlayerSwitchInProgress() end

---@param player integer
---@return boolean
function IsPlayerTargettingAnything(player) end

---@param player integer
---@param entity integer
---@return boolean
function IsPlayerTargettingEntity(player, entity) end

---@return boolean
function IsPlayerTeleportActive() end

---@return boolean
function IsPlayerVehRadioEnable() end

---@param player integer
---@param wantedLevel integer
---@return boolean
function IsPlayerWantedLevelGreater(player, wantedLevel) end

---@param ped integer
---@return boolean
function IsPlayingPhoneGestureAnim(ped) end

---@param tvChannel integer
---@param p1 any
---@return boolean
function IsPlaylistUnk(tvChannel, p1) end

---@param xPos number
---@param yPos number
---@param zPos number
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param p10 boolean
---@param includez boolean
---@return boolean
function IsPointInAngledArea(xPos, yPos, zPos, x1, y1, z1, x2, y2, z2, width, p10, includez) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 any
---@return boolean
function IsPointObscuredByAMissionEntity(p0, p1, p2, p3, p4, p5, p6) end

---@param x number
---@param y number
---@param z number
---@param vehicle integer
---@return boolean
function IsPointOnRoad(x, y, z, vehicle) end

---@param id integer
---@return boolean
function IsPopMultiplierAreaUnk(id) end

---@param x number
---@param y number
---@param z number
---@param range number
---@param p4 boolean
---@param checkVehicles boolean
---@param checkPeds boolean
---@param p7 boolean
---@param p8 boolean
---@param ignoreEntity integer
---@param p10 boolean
---@return boolean
function IsPositionOccupied(x, y, z, range, p4, checkVehicles, checkPeds, p7, p8, ignoreEntity, p10) end

---@param weatherType string
---@return boolean
function IsPrevWeatherType(weatherType) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param ownedByPlayer boolean
---@return boolean
function IsProjectileInArea(x1, y1, z1, x2, y2, z2, ownedByPlayer) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param p7 number
---@param weaponHash integer | string
---@param ownedByPlayer boolean
---@return boolean
function IsProjectileTypeInAngledArea(x1, y1, z1, x2, y2, z2, width, p7, weaponHash, ownedByPlayer) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param type integer
---@param ownedByPlayer boolean
---@return boolean
function IsProjectileTypeInArea(x1, y1, z1, x2, y2, z2, type, ownedByPlayer) end

---@param x number
---@param y number
---@param z number
---@param projHash integer | string
---@param radius number
---@param ownedByPlayer boolean
---@return boolean
function IsProjectileTypeWithinDistance(x, y, z, projHash, radius, ownedByPlayer) end

---@return boolean
function IsPs3Version() end

---@return boolean
function IsRadarHidden() end

---@return boolean
function IsRadarPreferenceSwitchedOn() end

---@return boolean
function IsRadioFadedOut() end

---@return boolean
function IsRadioRetuning() end

---@param radioStation string
---@return boolean
function IsRadioStationFavourited(radioStation) end

---@param rawKeyIndex integer
---@return boolean
function IsRawKeyDown(rawKeyIndex) end

---@param rawKeyIndex integer
---@return boolean
function IsRawKeyPressed(rawKeyIndex) end

---@param rawKeyIndex integer
---@return boolean
function IsRawKeyReleased(rawKeyIndex) end

---@param rawKeyIndex integer
---@return boolean
function IsRawKeyUp(rawKeyIndex) end

---@return boolean
function IsRecording() end

---@return boolean
function IsReportugcMenuOpen() end

---@return boolean
function IsRockstarMessageReadyForScript() end

---@param scaleformIndex integer
---@return boolean
function IsScaleformMovieDeleting(scaleformIndex) end

---@param method_return integer
---@return boolean
function IsScaleformMovieMethodReturnValueReady(method_return) end

---@param scenarioGroup string
---@return boolean
function IsScenarioGroupEnabled(scenarioGroup) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 boolean
---@return boolean
function IsScenarioOccupied(p0, p1, p2, p3, p4) end

---@param scenarioType string
---@return boolean
function IsScenarioTypeEnabled(scenarioType) end

---@return boolean
function IsScreenFadedIn() end

---@return boolean
function IsScreenFadedOut() end

---@return boolean
function IsScreenFadingIn() end

---@return boolean
function IsScreenFadingOut() end

---@return boolean
function IsScreenblurFadeRunning() end

---@return boolean
function IsScriptGlobalShaking() end

---@return boolean
function IsScriptedConversationLoaded() end

---@return boolean
function IsScriptedConversationOngoing() end

---@param id integer
---@return boolean
function IsScriptedHudComponentActive(id) end

---@param id integer
---@return boolean
function IsScriptedHudComponentHiddenThisFrame(id) end

---@param ped integer
---@param animDict string
---@param anim string
---@return boolean
function IsScriptedScenarioPedUsingConditionalAnim(ped, animDict, anim) end

---@param ped integer
---@return boolean
function IsScriptedSpeechPlaying(ped) end

---@param ped integer
---@return boolean
function IsScubaGearLightEnabled(ped) end

---@param vehicle integer
---@param seatIndex integer
---@return boolean
function IsSeatWarpOnly(vehicle, seatIndex) end

---@param eventType integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function IsShockingEventInSphere(eventType, x, y, z, radius) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean
function IsSniperBulletInArea(x1, y1, z1, x2, y2, z2) end

---@return boolean
function IsSniperInverted() end

---@return boolean
function IsSocialClubActive() end

---@param player integer
---@return boolean
function IsSpecialAbilityActive(player) end

---@param player integer
---@return boolean
function IsSpecialAbilityEnabled(player) end

---@param player integer
---@return boolean
function IsSpecialAbilityMeterFull(player) end

---@param playerModel integer | string
---@return boolean
function IsSpecialAbilityUnlocked(playerModel) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@return boolean
function IsSphereVisible(x, y, z, radius) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@return boolean
function IsSphereVisibleToAnotherMachine(p0, p1, p2, p3) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@return boolean
function IsSphereVisibleToPlayer(p0, p1, p2, p3, p4) end

---@return boolean
function IsSrlLoaded() end

---@return boolean
function IsSteamVersion() end

---@return boolean
function IsStoreAvailableToUser() end

---@return boolean
function IsStreamPlaying() end

---@param p0 integer
---@return boolean
function IsStreamingAdditionalText(p0) end

---@param registerAs string
---@return boolean
function IsStreamingFileReady(registerAs) end

---@return boolean
function IsStreamvolActive() end

---@param string string
---@return boolean
function IsStringNull(string) end

---@param string string
---@return boolean
function IsStringNullOrEmpty(string) end

---@return boolean
function IsStuntJumpInProgress() end

---@return boolean
function IsStuntJumpMessageShowing() end

---@return boolean
function IsSubtitlePreferenceSwitchedOn() end

---@return boolean
function IsSwitchReadyForDescent() end

---@return boolean
function IsSwitchSkippingDescent() end

---@param sceneID integer
---@return boolean
function IsSynchronizedSceneHoldLastFrame(sceneID) end

---@param sceneID integer
---@return boolean
function IsSynchronizedSceneLooped(sceneID) end

---@param sceneId integer
---@return boolean
function IsSynchronizedSceneRunning(sceneId) end

---@return boolean
function IsSystemUiBeingDisplayed() end

---@param ped integer
---@return boolean
function IsTaskMoveNetworkActive(ped) end

---@param ped integer
---@return boolean
function IsTaskMoveNetworkReadyForTransition(ped) end

---@param vehicle integer
---@return boolean
function IsTaxiLightOn(vehicle) end

---@param ped integer
---@return boolean
function IsTennisMode(ped) end

---@return boolean
function IsThisAMinigameScript() end

---@param model integer | string
---@return boolean
function IsThisModelABicycle(model) end

---@param model integer | string
---@return boolean
function IsThisModelABike(model) end

---@param model integer | string
---@return boolean
function IsThisModelABoat(model) end

---@param model integer | string
---@return boolean
function IsThisModelACar(model) end

---@param model integer | string
---@return boolean
function IsThisModelAHeli(model) end

---@param model integer | string
---@return boolean
function IsThisModelAJetski(model) end

---@param model integer | string
---@return boolean
function IsThisModelAPlane(model) end

---@param model integer | string
---@return boolean
function IsThisModelAQuadbike(model) end

---@param model integer | string
---@return boolean
function IsThisModelATrain(model) end

---@param model integer | string
---@return boolean
function IsThisModelAnAmphibiousCar(model) end

---@param model integer | string
---@return boolean
function IsThisModelAnAmphibiousQuadbike(model) end

---@param threadId integer
---@return boolean
function IsThreadActive(threadId) end

---@param timeA integer
---@param timeB integer
---@return boolean
function IsTimeEqualTo(timeA, timeB) end

---@param timeA integer
---@param timeB integer
---@return boolean
function IsTimeLessThan(timeA, timeB) end

---@param timeA integer
---@param timeB integer
---@return boolean
function IsTimeMoreThan(timeA, timeB) end

---@param vehicle integer
---@param modType integer
---@return boolean
function IsToggleModOn(vehicle, modType) end

---@param track integer
---@return boolean
function IsTrackEnabled(track) end

---@param track integer
---@return boolean
function IsTrackSwitchedOff(track) end

---@param ped integer
---@return boolean
function IsTrackedPedVisible(ped) end

---@param point integer
---@return boolean
function IsTrackedPointVisible(point) end

---@param vehicle integer
---@param seatIndex integer
---@return boolean
function IsTurretSeat(vehicle, seatIndex) end

---@param videoCliphash integer | string
---@return boolean
function IsTvPlaylistItemPlaying(videoCliphash) end

---@param playerId integer
---@return boolean
function IsUpdatingMpGamerTagNameAndCrewDetails(playerId) end

---@param padIndex integer
---@return boolean
function IsUsingKeyboard(padIndex) end

---@param padIndex integer
---@return boolean
function IsUsingKeyboard_2(padIndex) end

---@param interior integer
---@return boolean
function IsValidInterior(interior) end

---@param vehicle integer
---@param checkRoofExtras boolean
---@return boolean
function IsVehicleAConvertible(vehicle, checkRoofExtras) end

---@param vehicle integer
---@return boolean
function IsVehicleAlarmActivated(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleAlarmSet(vehicle) end

---@param cargobob integer
---@param vehicleAttached integer
---@return boolean
function IsVehicleAttachedToCargobob(cargobob, vehicleAttached) end

---@param towTruck integer
---@param vehicle integer
---@return boolean
function IsVehicleAttachedToTowTruck(towTruck, vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleAttachedToTrailer(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleAudiblyDamaged(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleBeingHalted(vehicle) end

---@param vehicle integer
---@param frontBumper boolean
---@return boolean
function IsVehicleBumperBouncing(vehicle, frontBumper) end

---@param vehicle integer
---@param front boolean
---@return boolean
function IsVehicleBumperBrokenOff(vehicle, front) end

---@param vehicle integer
---@return boolean
function IsVehicleDamaged(vehicle) end

---@param veh integer
---@param doorID integer
---@return boolean
function IsVehicleDoorDamaged(veh, doorID) end

---@param vehicle integer
---@param doorIndex integer
---@return boolean
function IsVehicleDoorFullyOpen(vehicle, doorIndex) end

---@param vehicle integer
---@param isOnFireCheck boolean
---@return boolean
function IsVehicleDriveable(vehicle, isOnFireCheck) end

---@param vehicle integer
---@return boolean
function IsVehicleEngineOnFire(vehicle) end

---@param vehicle integer
---@param extraId integer
---@return boolean
function IsVehicleExtraTurnedOn(vehicle, extraId) end

---@param vehicle integer
---@return boolean
function IsVehicleHighDetail(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleInBurnout(vehicle) end

---@param garageName string
---@param vehicle integer
---@return boolean
function IsVehicleInGarageArea(garageName, vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleInSubmarineMode(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleInteriorLightOn(vehicle) end

---@param vehicle integer
---@param modType integer
---@param modIndex integer
---@return boolean
function IsVehicleModGen9Exclusive(vehicle, modType, modIndex) end

---@param vehicle integer
---@param model integer | string
---@return boolean
function IsVehicleModel(vehicle, model) end

---@param vehicle integer
---@return boolean
function IsVehicleNeedsToBeHotwired(vehicle) end

---@param vehicle integer
---@param index integer
---@return boolean
function IsVehicleNeonLightEnabled(vehicle, index) end

---@param vehicleNodeId integer
---@return boolean
function IsVehicleNodeIdValid(vehicleNodeId) end

---@param vehicle integer
---@return boolean
function IsVehicleOnAllWheels(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleOnBoostPad(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleParachuteActive(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehiclePreviouslyOwnedByPlayer(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleRadioOn(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleRocketBoostActive(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleSearchlightOn(vehicle) end

---@param vehicle integer
---@param seatIndex integer
---@return boolean
function IsVehicleSeatFree(vehicle, seatIndex) end

---@param vehicle integer
---@return boolean
function IsVehicleSirenAudioOn(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleSirenOn(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleSlipstreamLeader(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleSprayable(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleStolen(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleStopped(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleStoppedAtTrafficLights(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleStuckOnRoof(vehicle) end

---@param vehicle integer
---@param p1 integer
---@param p2 integer
---@return boolean
function IsVehicleStuckTimerUp(vehicle, p1, p2) end

---@param vehicle integer
---@param wheelID integer
---@param isBurstToRim boolean
---@return boolean
function IsVehicleTyreBurst(vehicle, wheelID, isBurstToRim) end

---@param vehicle integer
---@return boolean
function IsVehicleVisible(vehicle) end

---@param vehicle integer
---@return boolean
function IsVehicleWanted(vehicle) end

---@param weaponHash integer | string
---@param vehicle integer
---@param owner integer
---@return boolean
function IsVehicleWeaponDisabled(weaponHash, vehicle, owner) end

---@param vehicle integer
---@param wheelIndex integer
---@return boolean
function IsVehicleWheelBrokenOff(vehicle, wheelIndex) end

---@param vehicle integer
---@param windowIndex integer
---@return boolean
function IsVehicleWindowIntact(vehicle, windowIndex) end

---@return boolean
function IsWarningMessageActive() end

---@return boolean
function IsWarningMessageReadyForControl() end

---@return boolean
function IsWaypointActive() end

---@param p0 any
---@return boolean
function IsWaypointPlaybackGoingOnForPed(p0) end

---@param vehicle integer
---@return boolean
function IsWaypointPlaybackGoingOnForVehicle(vehicle) end

---@param weaponHash integer | string
---@return boolean
function IsWeaponValid(weaponHash) end

---@return boolean
function IsWorldPointWithinBrainActivationRange() end

---@return boolean
function IsXbox360Version() end

---@param ped integer
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@param p4 boolean
function KnockOffPedProp(ped, p1, p2, p3, p4) end

---@param ped integer
function KnockPedOffVehicle(ped) end

---@return boolean
function LandingMenuIsActive() end

---@return boolean, any, any
function Leaderboards2ReadByHandle() end

---@param gamerHandleCsv string
---@param platformName string
---@return boolean, any
function Leaderboards2ReadByPlatform(gamerHandleCsv, platformName) end

---@param p1 any
---@return boolean, any, any
function Leaderboards2ReadByRadius(p1) end

---@param p1 any
---@param p2 any
---@return boolean, any
function Leaderboards2ReadByRank(p1, p2) end

---@param p2 any
---@param p4 any
---@param p6 any
---@return boolean, any, any, any, any
function Leaderboards2ReadByRow(p2, p4, p6) end

---@param p1 number
---@param p2 any
---@return boolean, any
function Leaderboards2ReadByScoreFloat(p1, p2) end

---@param p1 any
---@param p2 any
---@return boolean, any
function Leaderboards2ReadByScoreInt(p1, p2) end

---@param p2 any
---@param p3 boolean
---@param p4 any
---@param p5 any
---@return boolean, any, any
function Leaderboards2ReadFriendsByRow(p2, p3, p4, p5) end

---@return boolean, any, any, any
function Leaderboards2ReadRankPrediction() end

---@return boolean, any
function Leaderboards2WriteData() end

---@return boolean, any, any
function Leaderboards2WriteDataForEventType() end

---@return boolean, any
function LeaderboardsCacheDataRow() end


function LeaderboardsClearCacheData() end

---@param statName integer | string
---@param value number
function LeaderboardsDeaths(statName, value) end

---@param p0 any
---@param p1 any
---@return boolean, any
function LeaderboardsGetCacheDataRow(p0, p1) end

---@param p0 any
---@return boolean
function LeaderboardsGetCacheExists(p0) end

---@param p0 any
---@return integer
function LeaderboardsGetCacheNumberOfRows(p0) end

---@param p0 any
---@return any
function LeaderboardsGetCacheTime(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function LeaderboardsGetColumnId(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function LeaderboardsGetColumnType(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@return any
function LeaderboardsGetNumberOfColumns(p0, p1) end

---@return boolean
function LeaderboardsReadAnyPending() end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function LeaderboardsReadClear(p0, p1, p2) end

---@return any
function LeaderboardsReadClearAll() end

---@param p0 any
---@param p1 any
---@param p2 any
---@return boolean
function LeaderboardsReadPending(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return boolean
function LeaderboardsReadSuccessful(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 number
function LeaderboardsWriteAddColumn(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
function LeaderboardsWriteAddColumnLong(p0, p1, p2) end


function LeaveCursorMode() end

---@param modelHash integer | string
function LinkNamedRendertarget(modelHash) end

---@param emitterName string
---@param entity integer
function LinkStaticEmitterToEntity(emitterName, entity) end


function LoadAllObjectsNow() end

---@param keepInMemory boolean
---@return boolean
function LoadAllPathNodes(keepInMemory) end

---@param name string
---@param transitionTime number
function LoadCloudHat(name, transitionTime) end

---@param hash integer | string
function LoadContentChangeSetGroup(hash) end

---@param waterType integer
function LoadGlobalWaterType(waterType) end

---@param p0 string
---@param p3 boolean
---@return boolean, any, any
function LoadMissionCreatorPhoto(p0, p3) end

---@param movieMeshSetName string
---@return integer
function LoadMovieMeshSet(movieMeshSetName) end

---@param ropeId integer
---@param rope_preset string
function LoadRopeData(ropeId, rope_preset) end

---@param x number
---@param y number
---@param z number
function LoadScene(x, y, z) end

---@param streamName string
---@param soundSet string
---@return boolean
function LoadStream(streamName, soundSet) end

---@param streamName string
---@param startOffset integer
---@param soundSet string
---@return boolean
function LoadStreamWithStartOffset(streamName, startOffset, soundSet) end

---@param resourceName string
---@param fileName string
---@return boolean
function LoadWaterFromPath(resourceName, fileName) end

---@return boolean
function LoadingscreenGetLoadFreemode() end

---@return boolean
function LoadingscreenGetLoadFreemodeWithEventName() end

---@return boolean
function LoadingscreenIsLoadingFreemode() end

---@param toggle boolean
function LoadingscreenSetIsLoadingFreemode(toggle) end

---@param toggle boolean
function LoadingscreenSetLoadFreemode(toggle) end

---@param toggle boolean
function LoadingscreenSetLoadFreemodeWithEventName(toggle) end

---@return integer
function LocalizationGetSystemDateFormat() end

---@return integer
function LocalizationGetSystemLanguage() end


function LockLoadingScreenButtons() end

---@param angle integer
function LockMinimapAngle(angle) end

---@param x number
---@param y number
function LockMinimapPosition(x, y) end

---@param radioStationName string
---@param toggle boolean
function LockRadioStation(radioStationName, toggle) end

---@param radioStation string
---@param trackListName string
function LockRadioStationTrackList(radioStation, trackListName) end

---@param value number
---@return number
function Log10(value) end

---@param p0 string
function LogDebugInfo(p0) end

---@param vehicle integer
---@param instantlyLower boolean
function LowerConvertibleRoof(vehicle, instantlyLower) end

---@param vehicle integer
function LowerRetractableWheels(vehicle) end

---@param ped integer
---@return boolean
function MakePedReload(ped) end

---@param object integer
function MarkObjectForDeletion(object) end

---@param vehicle integer
---@param percentChange number
function ModifyVehicleTopSpeed(vehicle, percentChange) end

---@param x number
---@param y number
---@param height number
---@param radius number
function ModifyWater(x, y, height, radius) end

---@param p0 any
---@param p1 any
function MoveVehicleDecals(p0, p1) end

---@param channel integer
function MumbleAddVoiceChannelListen(channel) end

---@param targetId integer
---@param channel integer
function MumbleAddVoiceTargetChannel(targetId, channel) end

---@param targetId integer
---@param player integer
function MumbleAddVoiceTargetPlayer(targetId, player) end

---@param targetId integer
---@param serverId integer
function MumbleAddVoiceTargetPlayerByServerId(targetId, serverId) end


function MumbleClearVoiceChannel() end

---@param targetId integer
function MumbleClearVoiceTarget(targetId) end

---@param targetId integer
function MumbleClearVoiceTargetChannels(targetId) end

---@param targetId integer
function MumbleClearVoiceTargetPlayers(targetId) end

---@param channel integer
---@return boolean
function MumbleDoesChannelExist(channel) end

---@return number
function MumbleGetTalkerProximity() end

---@param serverId integer
---@return integer
function MumbleGetVoiceChannelFromServerId(serverId) end

---@return boolean
function MumbleIsActive() end

---@return boolean
function MumbleIsConnected() end

---@param player integer
---@return boolean
function MumbleIsPlayerTalking(player) end

---@param channel integer
function MumbleRemoveVoiceChannelListen(channel) end

---@param targetId integer
---@param channel integer
function MumbleRemoveVoiceTargetChannel(targetId, channel) end

---@param targetId integer
---@param player integer
function MumbleRemoveVoiceTargetPlayer(targetId, player) end

---@param targetId integer
---@param serverId integer
function MumbleRemoveVoiceTargetPlayerByServerId(targetId, serverId) end

---@param state boolean
function MumbleSetActive(state) end

---@param distance number
function MumbleSetAudioInputDistance(distance) end

---@param intentHash integer | string
function MumbleSetAudioInputIntent(intentHash) end

---@param distance number
function MumbleSetAudioOutputDistance(distance) end

---@param address string
---@param port integer
function MumbleSetServerAddress(address, port) end

---@param serverId integer
---@param submixId integer
function MumbleSetSubmixForServerId(serverId, submixId) end

---@param value number
function MumbleSetTalkerProximity(value) end

---@param channel integer
function MumbleSetVoiceChannel(channel) end

---@param targetId integer
function MumbleSetVoiceTarget(targetId) end

---@param player integer
---@param volume number
function MumbleSetVolumeOverride(player, volume) end

---@param serverId integer
---@param volume number
function MumbleSetVolumeOverrideByServerId(serverId, volume) end


function N_0x0032a6dba562c518() end

---@param p0 any
function N_0x006e4b040ed37ec3(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x0077f15613d36993(p0, p1, p2, p3) end

---@param p0 any
function N_0x015b03ee1c43e6ec(p0) end

---@param vehicle integer
---@param p1 number
function N_0x0205f5365292d2eb(vehicle, p1) end


function N_0x0218ba067d249dea() end

---@param p0 number
function N_0x0225778816fdc28c(p0) end

---@param toggle boolean
function N_0x02369d5c8a51fdcf(toggle) end

---@return any
function N_0x023acab2dc9dc4a4() end

---@param p0 boolean
function N_0x02e93c796abd3a97(p0) end

---@param p0 boolean
function N_0x03300b57fcac6ddb(p0) end

---@return boolean, any
function N_0x0395cb47b022e62c() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function N_0x03c2eebb04b3fb72(p0, p1, p2, p3, p4, p5, p6) end

---@param ped integer
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@param p4 boolean
---@param p5 boolean
---@param p6 boolean
---@param p7 boolean
---@param p8 any
---@return boolean
function N_0x03ea03af85a85cb7(ped, p1, p2, p3, p4, p5, p6, p7, p8) end


function N_0x03f1a106bda7dd3e() end

---@param p0 any
---@param p1 any
---@return any
function N_0x0419b167ee128f33(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function N_0x041c7f2a6c9894e6(p0, p1, p2) end

---@param toggle boolean
function N_0x04655f9d075d0ae5(toggle) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function N_0x04918a41bc9b8157(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function N_0x0581730ab9380412(p0, p1, p2, p3, p4, p5) end

---@param p0 any
---@param p1 any
function N_0x0596843b34b95ce5(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@return boolean
function N_0x06087579e7aa85a9(p0, p1, p2, p3, p4, p5) end

---@param ped integer
---@param toggle boolean
function N_0x061cb768363d6424(ped, toggle) end

---@param vehicle integer
---@param p1 boolean
function N_0x063ae2b2cc273588(vehicle, p1) end


function N_0x06462a961e94b67c() end

---@param p0 any
---@param p1 any
function N_0x065d03a9d6b2c6b5(p0, p1) end

---@param p0 any
function N_0x06eaf70ae066441e(p0) end

---@param p0 boolean
function N_0x06ee9048fd080382(p0) end

---@param p0 any
---@return any
function N_0x07dbd622d9533857(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function N_0x07eab372c8841d99(p0, p1, p2) end

---@param p0 integer
function N_0x0811381ef5062fec(p0) end

---@param amount integer
---@return boolean
function N_0x08e8eeadfd0dc4a0(amount) end

---@param p0 any
function N_0x0a9c7f36e5d7b683(p0) end


function N_0x0aa27680a0bd43fa() end

---@param p0 boolean
function N_0x0ae73d8df3a762b2(p0) end

---@param p0 any
---@param p1 any
function N_0x0b3e35ac043707d9(p0, p1) end


function N_0x0b40ed49d7d6ff84() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function N_0x0b565b0aae56a0e8(p0, p1, p2, p3, p4, p5, p6) end

---@return any
function N_0x0b8b7f74bf061c6d() end

---@param p0 any
function N_0x0c698d8f099174c7(p0) end

---@param p0 any
function N_0x0cf54f20de43879c(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function N_0x0cf6cc51aa18f0f8(p0, p1, p2) end

---@param p0 any
---@param p1 any
function N_0x0d01d20616fc73fb(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x0d30eb83668e63c5(p0, p1, p2, p3) end

---@return any, any
function N_0x0d77a82dc2d0da59() end

---@param amount integer
---@param p1 any
---@param p2 any
function N_0x0dd362f14f18942a(amount, p1, p2) end

---@param toggle boolean
function N_0x0e4299c549f0d1f1(toggle) end

---@param ped integer
---@param player integer
---@return boolean
function N_0x0ede326d47cd0f3e(ped, player) end

---@param p0 any
---@param p1 any
function N_0x0f1a4b45b7693b95(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x0f62619393661d6e(p0, p1, p2) end

---@param scriptIndex integer
---@param p1 string
---@return boolean
function N_0x0f6f1ebbc4e1d5e6(scriptIndex, p1) end

---@param ped integer
---@param p1 boolean
---@return any
function N_0x0ffb3c758e8c07b9(ped, p1) end

---@param vehicle integer
function N_0x107a473d7a6647a9(vehicle) end

---@param toggle boolean
function N_0x108be26959a9d9bb(toggle) end

---@param ped integer
---@param p1 number
function N_0x110f526ab784111f(ped, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x112209ce0290c03a(p0, p1, p2, p3) end


function N_0x1153fa02a659051c() end

---@param p0 any
function N_0x11579d940949c49e(p0) end

---@param p0 string
function N_0x116fb94dc4b79f17(p0) end

---@param p2 any
---@param p3 any
---@return boolean, any, any
function N_0x1171a97a3d3981b6(p2, p3) end

---@param p0 any
---@param p1 any
function N_0x1178e104409fe58c(p0, p1) end

---@param p0 any
---@param p1 any
function N_0x1216e0bfa72cc703(p0, p1) end

---@param p0 number
function N_0x12ded8ca53d47ea5(p0) end

---@param p0 any
---@param p1 any
function N_0x1312ddd8385aee4e(p0, p1) end

---@param p0 any
function N_0x1398582b7f72b3ed(p0) end


function N_0x13b350b8ad0eee10() end

---@param p0 boolean
function N_0x13f1fcb111b820b0(p0) end


function N_0x140e6a44870a11ce() end

---@param p0 any
function N_0x144da052257ae7d8(p0) end

---@return boolean
function N_0x14922ed3e38761f0() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x14d29bb12d47f68c(p0, p1, p2, p3, p4) end

---@return any, any, any, any
function N_0x14e0b2d1ad1044e0() end

---@param p0 any
function N_0x14eda9ee27bd1626(p0) end


function N_0x14fc5833464340a8() end

---@return integer
function N_0x155467aca0f55705() end


function N_0x1612c45f9e3e0d44() end

---@param p0 any
---@return boolean
function N_0x162c23ca83ed0a62(p0) end

---@param p0 any
function N_0x164c5ff663790845(p0) end

---@return any
function N_0x16da8172459434aa() end

---@return boolean, any
function N_0x170910093218c8b9() end

---@param p0 any
---@param p1 any
function N_0x17c9e241111a674d(p0, p1) end


function N_0x17fca7199a530203() end

---@param vehicle integer
---@param p1 number
function N_0x182f266c2d9e2beb(vehicle, p1) end

---@param p0 any
---@return boolean, any
function N_0x19853b5b17d77bca(p0) end


function N_0x19af7ed9b9d23058() end

---@param ped integer
---@return boolean
function N_0x19bfed045c647c49(ped) end

---@param entity integer
---@param p1 boolean
function N_0x1a092bb0c3808b96(entity, p1) end

---@param ped integer
---@param p1 integer
function N_0x1a330d297aac6bc1(ped, p1) end

---@param p0 any
---@param p1 any
function N_0x1a6cbb06e2d0d79d(p0, p1) end

---@param p0 any
function N_0x1a7ce7cd3e653485(p0) end

---@return any, number
function N_0x1a8ea222f9c67dbb() end

---@param p0 boolean
function N_0x1bbc135a4d25edde(p0) end

---@param p0 any
---@param p1 any
function N_0x1c57c94a6446492a(p0, p1) end

---@return boolean
function N_0x1d12a56fc95be92e() end

---@return boolean
function N_0x1d4dc17c38feaff0() end

---@param p0 integer
---@return boolean
function N_0x1d610eb0fea716d9(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x1dc9b749e7ae282b(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
function N_0x1e3f1b1b891a2aaa(p0, p1) end

---@param p0 any
---@return any
function N_0x1e77fa7a62ee6c4c(p0) end


function N_0x1e9057a74fd73e23() end

---@return any
function N_0x1f2300cb7fa7b7f6() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
function N_0x1f351cf1c6475734(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end


function N_0x1f7bc3539f9e0224() end

---@param p0 any
function N_0x1f8e00fb18239600(p0) end

---@param ped integer
---@param toggle boolean
function N_0x2016c603d6b8987c(ped, toggle) end

---@param p0 boolean
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
function N_0x20746f7b1032a3c7(p0, p1, p2, p3) end

---@param missionNameLabel string
---@param p1 any
function N_0x208784099002bc30(missionNameLabel, p1) end

---@param p0 boolean
function N_0x20c6c7e4eb082a7f(p0) end

---@return boolean
function N_0x2107a3773771186d() end


function N_0x211c4ef450086857() end

---@return boolean
function N_0x214cd562a939246a() end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 number
---@param p9 boolean
---@return vector3
function N_0x21c235bc64831e5a(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@return boolean, integer
function N_0x225798743970412b() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x226c284c830d0ca8(p0, p1, p2, p3) end

---@param scriptIndex integer
---@param p1 string
---@return integer
function N_0x22e21fbcfc88c149(scriptIndex, p1) end


function N_0x2302c0264ea58d31() end

---@param p0 any
function N_0x2310a8f9421ebf43(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0x2311dd7159f00582(vehicle, p1) end


function N_0x23227df0b2115469() end

---@param p0 any
function N_0x237440e46d918649(p0) end

---@param p0 any
---@param p1 any
function N_0x2382ab11450ae7ba(p0, p1) end

---@param padIndex integer
---@return boolean
function N_0x23f09eadc01449d6(padIndex) end

---@return boolean
function N_0x241fca5b1aa14f75() end


function N_0x243296a510b562b6() end

---@param p0 boolean
function N_0x247acbc4abbc9d1c(p0) end

---@param p0 any
---@param p2 any
---@param p3 any
---@param p4 any
---@return boolean, any
function N_0x24a49beaf468dc90(p0, p2, p3, p4) end

---@param p0 any
---@param p1 any
function N_0x24c024ba8379a70a(p0, p1) end

---@return any
function N_0x24e4e51fc16305f9() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function N_0x25361a96e0f7e419(p0, p1, p2, p3) end

---@param p0 any
---@return any
function N_0x2542269291c6ac84(p0) end


function N_0x2555cf7da5473794() end

---@return boolean
function N_0x2570e26be63964e3() end

---@param p0 any
function N_0x259ba6d4e6f808f1(p0) end

---@return any
function N_0x25aaa32bdc98f2a3() end


function N_0x25d990f8e0e3f13c() end

---@param p0 boolean
function N_0x25fc3e33a31ad0c9(p0) end

---@param p0 boolean
function N_0x261e97ad7bcf3d40(p0) end

---@param p0 any
function N_0x265559da40b3f327(p0) end


function N_0x265635150fb0d82e() end

---@param p0 integer
function N_0x26d7399b9587fe89(p0) end

---@return any
function N_0x26f07dd83a5f7f98() end

---@param p0 any
---@param p1 boolean
function N_0x271017b9ba825366(p0, p1) end

---@param ped integer
---@param p1 number
function N_0x2735233a786b1bef(ped, p1) end

---@param toggle boolean
function N_0x2790f4b17d098e26(toggle) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
function N_0x27aa1c973cacfe63(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end


function N_0x27cfb1b1e078cb2d() end

---@param p0 any
---@param p1 any
function N_0x27f248c3febfaad3(p0, p1) end

---@param textureDict string
---@param p1 boolean
---@return boolean
function N_0x27feb5254759cde3(textureDict, p1) end

---@param p0 any
function N_0x2818ff6638cb09de(p0) end

---@param p0 any
function N_0x282b6739644f4347(p0) end


function N_0x283b6062a2c01e9b() end

---@param ped integer
---@param value number
function N_0x288df530c92dad6f(ped, value) end

---@param p0 number
---@param p1 number
function N_0x28b022a17b068a3a(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x28ecb8ac2f607db2(p0, p1, p2, p3, p4) end

---@param p0 number
---@param p1 number
---@param p2 integer
function N_0x293220da1b46cebc(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
---@param p10 any
---@param p11 any
---@param p12 any
---@param p13 any
function N_0x29682e2ccf21e9b5(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) end


function N_0x2a251aa48b2b46db() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x2a7cec72c3443bcc(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x2a93c46aab1eacc9(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x2afc2d19b50797f2(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@return any
function N_0x2b1c623823db0d9d(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 any
function N_0x2b40a97646381508(p0) end

---@param p0 integer
---@param p1 string
---@return boolean
function N_0x2b51edbefc301339(p0, p1) end

---@param ped integer
---@param p1 boolean
function N_0x2b694afcf64e6994(ped, p1) end

---@return any
function N_0x2bf66d2e7414f686() end

---@param blip integer
---@return integer
function N_0x2c173ae2bdb9385e(blip) end

---@param p0 any
---@return any
function N_0x2c42340f916c5930(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0x2c4a1590abf43e8b(vehicle, p1) end

---@param blip integer
---@param p1 any
function N_0x2c9f302398e13141(blip, p1) end

---@param p0 any
function N_0x2cd90358f67d0aa8(p0) end

---@param p0 any
function N_0x2ce9d95e4051aecd(p0) end

---@param textureDict string
---@param textureName string
---@param x number
---@param y number
---@param width number
---@param height number
---@param p6 number
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param p11 integer
function N_0x2d3b147afad49de0(textureDict, textureName, x, y, width, height, p6, red, green, blue, alpha, p11) end

---@param p0 any
---@return boolean
function N_0x2d5dc831176d0114(p0) end

---@param p0 any
function N_0x2d7a9b577e72385e(p0) end

---@return any
function N_0x2d874d4ae612a65f() end

---@param p0 any
---@return any, integer
function N_0x2da41ed6e1fcd7a5(p0) end

---@return any
function N_0x2dd39bf3e2f9c47f() end

---@param ped integer
---@return boolean, integer
function N_0x2dfc81c9b9608549(ped) end

---@param p0 any
function N_0x2e0259babc27a327(p0) end

---@param p0 any
---@return boolean
function N_0x2e0bf682cc778d49(p0) end

---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@return any, integer, integer
function N_0x2e4c123d1c8a710e(p2, p3, p4, p5, p6) end

---@return boolean
function N_0x2f057596f2bd0061() end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
function N_0x2f074c904d85129e(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 boolean
function N_0x2f137b508de238f2(p0) end

---@param p0 any
---@param p1 boolean
function N_0x2f3c3d9f50681de4(p0, p1) end

---@param p0 any
---@param p1 any
function N_0x2f41a3bae005e5fa(p0, p1) end

---@param p0 boolean
function N_0x2f7ceb6520288061(p0) end

---@param p0 number
---@param p1 number
function N_0x2f7f2b26dd3f18ee(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x2fa3173480008493(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x2fab6614ce22e196(p0, p1, p2, p3) end

---@param p0 any
---@return any
function N_0x2fcb133ca50a49eb(p0) end

---@return boolean
function N_0x3001bef2feca3680() end

---@return integer
function N_0x30432a0118736e00() end

---@return boolean
function N_0x3044240d2e0fa842() end

---@return any
function N_0x31125fd509d9043f() end

---@param p0 any
---@param p1 any
function N_0x31574b1b41268673(p0, p1) end

---@param p0 any
function N_0x316db59cd14c1774(p0) end

---@param p0 any
---@param p1 any
function N_0x31ba138f6304fb9f(p0, p1) end

---@param player integer
---@param p1 number
function N_0x31e90b8873a4cd3b(player, p1) end

---@param p0 boolean
function N_0x31f924b53eaddf65(p0) end

---@param p0 any
function N_0x324c5aa411da7737(p0) end

---@return any
function N_0x32cac93c9de73d32() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x32ebd154cb6b8b99(p0, p1, p2) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@return any
function N_0x336b3d200ab007cb(p0, p1, p2, p3, p4) end

---@param p0 boolean
---@return boolean
function N_0x33d47e85b476abcd(p0) end

---@param p0 any
---@param p1 any
---@return any
function N_0x33d72899e24c3365(p0, p1) end

---@return boolean
function N_0x33df47cc0642061b() end

---@param vehicle integer
---@param p1 boolean
function N_0x3441cad2f2231923(vehicle, p1) end


function N_0x346ef3ecaaab149e() end

---@param p0 any
---@return boolean, any
function N_0x34770b9ce0e03b91(p0) end

---@param p0 any
---@param p1 any
function N_0x352e2b5cf420bf3b(p0, p1) end

---@return any
function N_0x357b152ef96c30b6() end

---@param blip integer
function N_0x35a3cd97b2c0a6d2(blip) end

---@param p0 any
---@param p1 any
function N_0x35bb21de06784373(p0, p1) end

---@param p0 boolean
function N_0x35e0654f4bad7971(p0) end

---@param p0 any
---@return any
function N_0x36391f397731595d(p0) end

---@param p0 integer
function N_0x367ef5e2f439b4c6(p0) end

---@param ropeId integer
---@param p1 boolean
function N_0x36ccb9be67b970fd(ropeId, p1) end

---@param toggle boolean
function N_0x36de109527a2c0c4(toggle) end

---@param player integer
function N_0x36f1b38855f2a8df(player) end

---@param p0 any
---@param p1 any
function N_0x36f32de87082343e(p0, p1) end

---@param p0 number
function N_0x36f6626459d91457(p0) end

---@param p0 any
---@return integer
function N_0x37d5f739fd494675(p0) end


function N_0x380b4968d1e09e55() end

---@param p0 any
---@param p1 any
---@return number
function N_0x38491439b6ba7f7d(p0, p1) end

---@param p0 any
---@return any
function N_0x3855fb5eb2c5e8b2(p0) end

---@param entity integer
---@param toggle boolean
function N_0x38b7c51ab1edc7d8(entity, toggle) end

---@param value integer
function N_0x38baaa5dd4c9d19f(value) end

---@param p0 any
---@param p1 any
function N_0x38c1cb1cb119a016(p0, p1) end

---@return any
function N_0x393bd2275ceb7793() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
---@param p10 any
---@param p11 any
---@param p12 any
---@return any
function N_0x39455bf4f4f55186(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12) end


function N_0x394cd08e31313c28() end

---@return integer
function N_0x397baa01068baa96() end

---@param p0 boolean
function N_0x39917e1b4cb0f911(p0) end

---@param p0 any
---@param p1 any
function N_0x39a5fb7eaf150840(p0, p1) end

---@param object integer
---@param toggle boolean
---@param R integer
---@param G integer
---@param B integer
function N_0x3b2fd68db5f8331c(object, toggle, R, G, B) end

---@param vehicle integer
---@param doorIndex integer
---@param toggle boolean
function N_0x3b458ddb57038f08(vehicle, doorIndex, toggle) end

---@param p0 any
---@param p1 any
---@return any
function N_0x3bd770d281982db5(p0, p1) end

---@param toggle boolean
function N_0x3c5c1e2c2ff814b1(toggle) end

---@param checkpointHandle integer
---@param x number
---@param y number
---@param z number
function N_0x3c788e7f6438754d(checkpointHandle, x, y, z) end

---@param p0 any
function N_0x3de3aa516fb126a4(p0) end

---@param ped integer
---@return boolean
function N_0x3e38e28a1d80ddf6(ped) end

---@param p0 any
---@param p1 any
function N_0x3e9679c1dfcf422c(p0, p1) end

---@param p0 any
function N_0x3ebeac6c3f81f6bd(p0) end

---@param netId integer
---@param state boolean
function N_0x3fa36981311fa4ff(netId, state) end

---@param p0 any
---@param p1 any
function N_0x3fc795691834481d(p0, p1) end

---@param p0 boolean
function N_0x4008edf7d6e48175(p0) end

---@param roomHashKey integer | string
function N_0x405dc2aef6af95b9(roomHashKey) end

---@param p0 any
---@param p1 any
function N_0x407dc5e97db1a4d3(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x4128464231e3ca0b(p0, p1, p2, p3) end

---@param p0 any
function N_0x41290b40fa63e6da(p0) end

---@param p0 any
---@return any
function N_0x412f1364fa066cfb(p0) end

---@param p0 any
function N_0x419615486bbf1956(p0) end

---@return boolean
function N_0x4237e822315d8ba9() end

---@param ped integer
---@param p1 boolean
function N_0x425aecf167663f48(ped, p1) end

---@return any
function N_0x4282e08174868be3() end

---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param p4 number
function N_0x428ad3e26c8d9eb0(vehicle, x, y, z, p4) end

---@param p0 any
function N_0x430a7631a84c9be7(p0) end

---@param p0 any
---@param p1 any
---@return any
function N_0x4348bfda56023a2f(p0, p1) end

---@param vehicle integer
---@param p1 boolean
function N_0x43fa0dfc5df87815(vehicle, p1) end

---@param p0 any
function N_0x43fa7cbe20dab219(p0) end

---@param vehicle integer
function N_0x4419966c9936071a(vehicle) end


function N_0x444c4525ece0a4b9() end

---@param p0 any
function N_0x44919cc079bb60bf(p0) end

---@param p1 any
---@return any
function N_0x44aca259d67651db(p1) end

---@return boolean
function N_0x450819d8cf90c416() end

---@return any
function N_0x45e816772e93a9db() end

---@param player integer
function N_0x4669b3ed80f24b4e(player) end

---@param p0 boolean
function N_0x469f2ecdec046337(p0) end

---@param ped integer
---@param flag integer
---@return boolean
function N_0x46b05bcae43856b0(ped, flag) end

---@param p0 number
function N_0x46d1a61a21f566fc(p0) end

---@param p0 any
---@param p1 any
function N_0x46f3add1e2d5baf2(p0, p1) end


function N_0x472397322e92a856() end

---@param p0 integer
---@return boolean, any
function N_0x4737980e8a283806(p0) end

---@param p0 any
function N_0x4811bbac21c5fcd5(p0) end


function N_0x483aca1176ca93f1() end

---@param p0 integer
function N_0x48621c9fca3ebd28(p0) end

---@param p0 any
---@param p1 number
---@return boolean
function N_0x487912fd248efddf(p0, p1) end

---@return boolean
function N_0x4879e4fe39074cdf() end

---@param name string
---@return any
function N_0x48f069265a0e4bec(name) end

---@param p0 any
function N_0x490861b88f4fd846(p0) end

---@param ped integer
---@param toggle boolean
function N_0x49e50bdb8ba4dab2(ped, toggle) end

---@return any, any
function N_0x4a7d6e727f941747() end

---@param toggle boolean
function N_0x4a9fde3a5a6d0437(toggle) end

---@param vehicle integer
---@param togle boolean
function N_0x4ad280eb48b2d8e6(vehicle, togle) end

---@param p0 any
---@param p1 any
---@return any
function N_0x4ad490ae1536933b(p0, p1) end


function N_0x4af92acd3141d96c() end


function N_0x4aff7e02e485e92b() end

---@param p0 any
---@param p1 any
function N_0x4b5b620c9b59ed34(p0, p1) end

---@param p0 any
---@param p1 any
function N_0x4c134b4df76025d0(p0, p1) end

---@param interior integer
---@return any
function N_0x4c2330e61d3deb56(interior) end


function N_0x4c2a9fdc22377075() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x4c3b75694f7e0d9c(p0, p1, p2) end

---@return any
function N_0x4c89fe2bdeb3f169() end

---@return any
function N_0x4c9034162368e206() end

---@param cutsceneName string
---@return boolean
function N_0x4cebc1ed31e8925e(cutsceneName) end

---@return any
function N_0x4d02279c83be69fe() end


function N_0x4d953df78ebf8158() end

---@param p0 any
---@param p1 boolean
function N_0x4d9d109f63fee1d4(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x4dc416f246a41fc8(p0, p1, p2, p3, p4) end

---@param p0 any
---@return boolean
function N_0x4df7cfff471a7fb1(p0) end

---@param p0 any
function N_0x4e52e752c76e7e7a(p0) end

---@return any
function N_0x4ed9c8d6da297639() end

---@param p0 any
---@return any
function N_0x4fcd976da686580c(p0) end

---@param p0 any
---@param p1 any
function N_0x4fcdbd3f0a813c25(p0, p1) end

---@return any
function N_0x5068f488ddb54dd8() end

---@return boolean
function N_0x50a8a36201dbf83e() end

---@param ped integer
---@return integer
function N_0x511f1a683387c7e2(ped) end

---@param toggle boolean
function N_0x51db102f4a3ba5e0(toggle) end

---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param p7 integer
---@param p8 any
---@return boolean
function N_0x51f30db60626a20e(vehicle, x, y, z, rotX, rotY, rotZ, p7, p8) end

---@param p0 any
---@param p1 any
---@return boolean, any, any
function N_0x5324a0e3e4ce3570(p0, p1) end

---@return any
function N_0x53c10c8bd774f2c9() end

---@param p0 any
function N_0x53c31853ec9531ff(p0) end

---@param p0 any
function N_0x53cae13e9b426993(p0) end

---@param vehicle integer
function N_0x53ddc75bc3ac0a90(vehicle) end

---@param p0 any
---@return integer
function N_0x5407b7288d0478b7(p0) end

---@param p0 number
function N_0x547237aa71ab44de(p0) end

---@param p0 number
function N_0x54e22ea2c1956a8d(p0) end

---@param ped integer
---@param p1 string
---@param p2 number
function N_0x54f157e0336a3822(ped, p1, p2) end

---@param player integer
function N_0x5501b7a5cdb79d37(player) end

---@param value integer
function N_0x55384438fc55ad8e(value) end

---@param p0 boolean
function N_0x5539c3ebf104a53a(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x5574637681911fda(p0, p1, p2, p3) end

---@return boolean, any
function N_0x559ebf901a8c68e0() end

---@param p0 any
---@param p1 any
function N_0x55a1e095db052fa5(p0, p1) end

---@return any
function N_0x55a8becaf28a4eb7() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x55ecf4d13d9903b0(p0, p1, p2, p3) end


function N_0x55f5a5f07134de60() end

---@param player1 integer
---@param player2 integer
---@param toggle boolean
function N_0x55fcc0c390620314(player1, player2, toggle) end

---@param p0 any
---@return any
function N_0x560b423d73015e77(p0) end

---@param p0 integer
function N_0x5688585e6d563cd8(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0x56eb5e94318d3fb6(vehicle, p1) end

---@param p0 integer
function N_0x57d760d55f54e071(p0) end

---@return integer
function N_0x583df8e3d4afbd98() end

---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param p4 any
function N_0x5845066d8a1ea7f7(vehicle, x, y, z, p4) end

---@param p0 any
---@return boolean, any
function N_0x584770794d758c18(p0) end

---@param p0 boolean
---@param p1 boolean
function N_0x58bb377bec7cd5f4(p0, p1) end

---@return boolean
function N_0x59328eb08c5ceb2b() end

---@return any
function N_0x593feae1f73392d4() end


function N_0x59424bd75174c9b1() end

---@param vehicle integer
---@param toggle boolean
---@param p2 number
function N_0x59c3757b3b7408e8(vehicle, toggle, p2) end

---@param p0 any
function N_0x59d421683d31835a(p0) end

---@param p0 any
---@return boolean
function N_0x5a34cd9c3c5bec44(p0) end


function N_0x5a43c76f7fc7ba5f() end

---@return boolean
function N_0x5a556b229a169402() end


function N_0x5a7f62fda59759bd() end


function N_0x5ad3932daeb1e5d3() end

---@return integer
function N_0x5b0316762afd4a64() end

---@return any
function N_0x5b1f2e327b6b6fe1() end

---@param p0 any
---@param p1 boolean
function N_0x5b6010b3cbc29095(p0, p1) end

---@param p0 boolean
function N_0x5b73c77d9eb66e24(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function N_0x5b9853296731e88d(p0, p1, p2, p3, p4, p5) end

---@param p0 any
---@param p1 any
---@return any
function N_0x5ba68a0840d546ac(p0, p1) end

---@param toggle boolean
function N_0x5bbcf35bf6e456f7(toggle) end

---@param p0 any
---@return any
function N_0x5bd5f255321c4aaf(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x5bf29846c6527c54(p0, p1, p2, p3, p4) end

---@param entity integer
---@param p1 number
function N_0x5c3b791d580e0bc2(entity, p1) end

---@param p0 any
function N_0x5c41e6babc9e2112(p0) end

---@param cam integer
---@return boolean
function N_0x5c48a1d6e3b33179(cam) end


function N_0x5c497525f803486b() end

---@param p0 any
function N_0x5cdaed54b34b0ed0(p0) end

---@param vehicle integer
---@param p1 integer
---@param p2 number
function N_0x5d96cfb59da076a0(vehicle, p1, p2) end

---@param p0 any
function N_0x5dbf05db5926d089(p0) end


function N_0x5debd9c4dc995692() end

---@param p0 any
function N_0x5e3aa4ca2b6fb0ee(p0) end

---@param vehicle integer
---@param toggle boolean
function N_0x5e569ec46ec21cae(vehicle, toggle) end

---@return boolean
function N_0x5ead2bf6484852e4() end

---@param p0 any
function N_0x5ecd378ee64450ab(p0) end

---@return boolean
function N_0x5edef0cf8c1dab3c() end

---@param vehicle integer
---@param health number
function N_0x5ee5632f47ae9695(vehicle, health) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x5f456788b05faeac(p0, p1, p2) end

---@param toggle boolean
function N_0x5f6df3d92271e8a1(toggle) end

---@param p0 any
function N_0x5ff2c33b13a02a11(p0) end

---@param p0 any
function N_0x600f8cb31c7aab6e(p0) end

---@return boolean
function N_0x60edd13eb3ac1ff3() end

---@param p0 any
function N_0x60eedc12af66e846(p0) end

---@param p0 any
function N_0x6100b3cefd43452e(p0) end

---@return boolean
function N_0x613f125ba3bd2eb9() end

---@param checkpoint integer
function N_0x615d3925e87a3b26(checkpoint) end

---@return integer
function N_0x617f49c2668e6155() end

---@param p0 any
function N_0x61f95e5bb3e0a8c6(p0) end


function N_0x62374889a4d59f72() end

---@param p0 any
function N_0x62454a641b41f3c5(p0) end


function N_0x629526aba383bcaa() end

---@param p0 boolean
function N_0x62e849b7eb28e770(p0) end


function N_0x62ecfcfdee7885d6() end

---@return any
function N_0x63b406d7884bfa95() end


function N_0x63eb2b972a218cac() end

---@param p0 any
---@param p1 any
function N_0x63ecf581bc70e363(p0, p1) end

---@param p0 any
---@param p1 any
function N_0x641f272b52e2f0f8(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return any
function N_0x6483c25849031c4f(p0, p1, p2) end

---@param p0 any
function N_0x649c97d52332341a(p0) end

---@param entity integer
---@return vector3
function N_0x64d779659bc37b19(entity) end

---@return boolean
function N_0x64e5c4cc82847b73() end

---@param p0 any
---@param p1 any
function N_0x6501129c9e0ffa05(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function N_0x65482bfd0923c8a1(p0, p1, p2, p3, p4, p5) end

---@param p0 any
function N_0x6551b1f7f6cd46ea(p0) end

---@param p0 any
---@param p1 any
function N_0x659f9d71f52843f8(p0, p1) end

---@param p0 any
function N_0x65b080555ea48149(p0) end

---@param toggle boolean
function N_0x65d2ebb47e1cec21(toggle) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x66972397e0757e7a(p0, p1, p2) end


function N_0x66a49d021870fe88() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x66e3aaface2d1eb8(p0, p1, p2) end

---@return any
function N_0x66e7cb63c97b7d20() end


function N_0x675721c9f644d161() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x675d19c6067cae08(p0, p1, p2, p3) end

---@param p0 any
function N_0x678f86d8fc040bdb(p0) end

---@return any
function N_0x67fc09bc554a75e5() end


function N_0x68103e2247887242() end

---@param p0 any
---@param p1 any
function N_0x68b562e124cc0aef(p0, p1) end

---@param player integer
---@return boolean
function N_0x690a61a6d13583f6(player) end

---@return any
function N_0x690b76bd2763e068() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p4 any
---@param p5 boolean
---@return boolean, any
function N_0x692d58df40657e8c(p0, p1, p2, p4, p5) end


function N_0x693478acbd7f18e7() end

---@param p0 integer
---@param p1 string
---@return boolean, any
function N_0x699e4a5c8c893a18(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x69ef772b192614c1(p0, p1, p2, p3) end

---@param toggle boolean
function N_0x6a51f78772175a51(toggle) end

---@param toggle boolean
function N_0x6a5d89d7769a40d8(toggle) end

---@param p0 any
function N_0x6a60e43998228229(p0) end

---@return boolean
function N_0x6a7f19756f1a9016() end

---@param vehicle integer
---@param p1 any
function N_0x6a973569ba094650(vehicle, p1) end

---@param p0 any
function N_0x6ad0bd5e087866cb(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x6b7e4fb50d5f3d65(p0, p1, p2, p3, p4) end

---@param p0 any
---@return integer, integer
function N_0x6bc0acd0673acebe(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x6bccf9948492fd85(p0, p1, p2, p3, p4) end

---@param p0 any
---@return boolean
function N_0x6bfb12ce158e3dd4(p0) end

---@param player integer
function N_0x6bff5f84102df80a(player) end

---@param padIndex integer
---@return boolean
function N_0x6cd79468a1e595c6(padIndex) end


function N_0x6ce50e47f5543d0c() end

---@param componentHash integer | string
---@return integer
function N_0x6cebe002e58dee97(componentHash) end

---@param action string
function N_0x6d6840cee8845831(action) end

---@return boolean, integer, integer
function N_0x6dee77aff8c21bd1() end

---@return any
function N_0x6e0a5253375c4584() end

---@param p0 any
---@return any
function N_0x6e4361ff3e8cd7ca(p0) end

---@param action string
function N_0x6e91b04e08773030(action) end

---@param p0 any
---@return any
function N_0x6eaaefc76acc311f(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0x6ebfb22d646ffc18(vehicle, p1) end

---@param toggle boolean
function N_0x6f2135b6129620c1(toggle) end


function N_0x6f361b8889a792a3() end

---@return any
function N_0x6fb7bb3607d27fa2() end

---@param p0 any
---@return boolean
function N_0x6fcf8ddea146c45b(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x6fd97159fe3c971a(p0, p1, p2, p3) end


function N_0x6fd992c4a1c1b986() end

---@return boolean
function N_0x6fddf453c0c756ec() end


function N_0x701fda1e82076ba4() end

---@param p0 any
function N_0x702bc4d605522539(p0) end

---@param p0 any
function N_0x7033eefd9b28088e(p0) end

---@param p0 any
function N_0x703cc7f60cbb2b57(p0) end

---@return boolean
function N_0x705a276ebff3133d() end

---@param coordX number
---@param coordY number
---@param coordZ number
function N_0x70a382adec069dd3(coordX, coordY, coordZ) end

---@return boolean
function N_0x710bcda8071eded1() end

---@param p0 any
---@param p1 any
function N_0x711794453cfd692b(p0, p1) end


function N_0x7148e0f43d11f0d9() end


function N_0x71b008056e5692d6() end

---@return any
function N_0x71e7b2e657449aad() end

---@param p0 any
---@param p1 any
function N_0x723c1ce13fbfdb67(p0, p1) end

---@param entity integer
---@param toggle boolean
function N_0x7241ccb7d020db69(entity, toggle) end

---@param p0 any
---@param p2 any
---@return any, any
function N_0x725012a415dba050(p0, p2) end


function N_0x7295c203dd659dfe() end

---@param p0 any
---@param p1 any
function N_0x72beccf4b829522e(p0, p1) end

---@return boolean
function N_0x72eb7ba9b69bf6ab() end

---@param p0 any
function N_0x73001e34f85137f8(p0) end

---@param ped integer
function N_0x733c87d4ce22bea2(ped) end

---@param p0 any
---@param p1 any
function N_0x734e1714d077da9a(p0, p1) end

---@param p0 any
---@param p1 any
function N_0x73561d4425a021a2(p0, p1) end

---@param vehicle integer
---@param toggle boolean
function N_0x737e398138550fff(vehicle, toggle) end


function N_0x741a3d8380319a81() end

---@param p0 any
---@return any
function N_0x742b58f723233ed9(p0) end

---@param p0 integer
---@return integer
function N_0x74a0fd0688f1ee45(p0) end

---@return integer
function N_0x74fb3e29e6d10fa9() end

---@return integer
function N_0x754615490a029508() end

---@param p0 integer
---@return boolean
function N_0x759650634f07b6b4(p0) end

---@param ped integer
---@param p1 boolean
function N_0x75ba1cb3b7d40caf(ped, p1) end


function N_0x760910b49d2b98ea() end

---@param p0 any
function N_0x762db2d380b48d04(p0) end

---@param p0 any
---@param p1 any
function N_0x76b3f29d3f967692(p0, p1) end

---@param vehicle integer
function N_0x76d26a22750e849e(vehicle) end

---@param p0 any
function N_0x77faddcbe3499df7(p0) end

---@return any
function N_0x7808619f31ff22db() end

---@param pickup integer
function N_0x7813e8b8c4ae4799(pickup) end

---@param p0 any
---@param p1 boolean
---@return boolean
function N_0x78321bea235fd8cd(p0, p1) end

---@param p0 any
---@param p1 any
function N_0x78ceee41f49f421f(p0, p1) end

---@param entity integer
function N_0x78e8e3a640178255(entity) end

---@return any
function N_0x793ff272d5b365f4() end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
function N_0x796a877e459b99ea(p0, p1, p2, p3) end

---@param profileSetting integer
---@param settingValue integer
function N_0x79d310a861697cc9(profileSetting, settingValue) end

---@param transactionId integer
---@return boolean
function N_0x79edac677ca62f81(transactionId) end


function N_0x7a42b2e236e71415() end

---@param p0 boolean
---@return boolean
function N_0x7ac24eab6d74118d(p0) end

---@param p0 any
function N_0x7b18da61f6bae9d5(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function N_0x7bae68775557ae0b(p0, p1, p2, p3, p4, p5) end

---@param p0 any
function N_0x7bbe7ff626a591fe(p0) end

---@param p0 any
function N_0x7c226d5346d4d10a(p0) end

---@return boolean
function N_0x7c4fccd2e4deb394() end

---@param p0 any
function N_0x7d36291161859389(p0) end

---@param p0 boolean
function N_0x7d395ea61622e116(p0) end

---@param p0 any
function N_0x7d8ba05688ad64c7(p0) end

---@return any
function N_0x7db18ca8cad5b098() end

---@return integer
function N_0x7db53b37a2f211a0() end

---@param p0 any
---@return any
function N_0x7e07c78925d5fd96(p0) end

---@param p0 string
---@param p1 boolean
function N_0x7e2bd3ef6c205f09(p0, p1) end

---@param p0 any
---@return boolean
function N_0x7e6946f68a38b74f(p0) end


function N_0x7ec6f9a478a6a512() end

---@param p0 any
function N_0x7ecdf98587e92dec(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x7eec2a316c250073(p0, p1, p2) end

---@param entity integer
---@return boolean
function N_0x7ef7649b64d7ff10(entity) end

---@param p0 any
---@return boolean
function N_0x7f2c4cdf2e82df4c(p0) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 number
---@param p9 boolean
---@return number
function N_0x7f8f6405f4777af6(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param modelHash integer | string
function N_0x7f96f23fa9b73327(modelHash) end

---@return boolean
function N_0x7fa5d82b8f58ec06() end

---@param p0 integer
---@return boolean
function N_0x7fcc39c46c3c03bd(p0) end

---@return any
function N_0x7ffcbfee44ecfabf() end

---@param ped integer
function N_0x80054d7fcc70eec6(ped) end

---@return boolean
function N_0x801879a9b4f4b2fb() end

---@param vehicle integer
---@param toggle boolean
function N_0x80e3357fdef45c21(vehicle, toggle) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x810b5fcc52ec7ff0(p0, p1, p2, p3) end

---@param p0 any
function N_0x814af7dcaacc597b(p0) end

---@param p0 boolean
---@return any, any, any, any, any, any, any, any
function N_0x817b86108eb94e51(p0) end


function N_0x81cbae94390f9f89() end

---@param p0 any
---@param p1 any
function N_0x820e9892a77e97cd(p0, p1) end

---@param vehicle integer
---@param toggle boolean
function N_0x8235f1bead557629(vehicle, toggle) end

---@param p0 any
function N_0x823ec8e82ba45986(p0) end

---@param name string
---@return any
function N_0x8269816f6cfd40f8(name) end

---@param p0 any
---@param p1 any
function N_0x826d1ee4d1cafc78(p0, p1) end

---@param p0 integer | string
---@return integer
function N_0x829cd22e043a2577(p0) end

---@param p0 any
---@return any
function N_0x82acc484ffa3b05f(p0) end

---@param toggle boolean
function N_0x82e0ac411e41a5b4(toggle) end

---@param entity integer
---@param interiorID integer
function N_0x82ebb79e258fa2b7(entity, interiorID) end

---@param p0 any
function N_0x830c3a44eb3f2cf9(p0) end

---@param p0 any
---@param p1 any
function N_0x834344a414c7c85d(p0, p1) end

---@param p0 any
---@param p1 any
---@return any, integer
function N_0x83660b734994124d(p0, p1) end

---@return boolean
function N_0x836b62713e0534ca() end


function N_0x83fe8d7229593017() end


function N_0x8410c5e0cd847b9d() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x8423541e8b3a1589(p0, p1, p2) end

---@return any
function N_0x84a810b375e69c0e() end

---@return any
function N_0x84b418e93894ac1c() end

---@return boolean, integer
function N_0x84de3b5fb3e666f0() end

---@param p0 any
function N_0x84dfc579c2fc214c(p0) end


function N_0x851cd923176eba7c() end

---@param p0 any
---@return any
function N_0x8533cafde1f0f336(p0) end

---@param p0 any
---@param p1 any
function N_0x858ec9fd25de04aa(p0, p1) end

---@return any
function N_0x85f6c9aba1de2bcf() end

---@param ped integer
---@param p1 string
---@param value number
function N_0x8634cef2522d987b(ped, p1, value) end

---@param p0 any
---@param p1 any
function N_0x8664170ef165c4a6(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x870289a558348378(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x870b8b7a766615c8(p0, p1, p2) end

---@param multiplier number
function N_0x87ddeb611b329a9c(multiplier) end

---@param p0 any
function N_0x88087ee1f28024ae(p0) end

---@param vehicle integer
---@param toggle boolean
function N_0x8821196d91fa2de5(vehicle, toggle) end

---@param p0 any
---@param p1 any
---@return any
function N_0x88578f6ec36b4a3a(p0, p1) end

---@param vehicle integer
function N_0x887fa38787de8c72(vehicle) end

---@param p0 any
function N_0x8881c98a31117998(p0) end

---@return any
function N_0x88b588b41ff7868e() end

---@param vehicle integer
---@param p1 boolean
function N_0x88bc673ca9e0ae99(vehicle, p1) end


function N_0x8951eb9c6906d3c8() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function N_0x8989cbd7b4e82534(p0, p1, p2, p3, p4, p5, p6) end

---@return boolean, any
function N_0x8a4416c0db05fa66() end

---@return any
function N_0x8b0c2964ba471961() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function N_0x8b4ffc790ca131ef(p0, p1, p2, p3) end

---@return any
function N_0x8b9cdbd6c566c38c() end

---@param p0 number
---@param p1 number
function N_0x8bf907833be275de(p0, p1) end

---@param p0 any
---@return boolean
function N_0x8c8d2739ba44af0f(p0) end

---@param p0 any
function N_0x8c9d11605e59d955(p0) end

---@param p0 any
function N_0x8caab2bd3ea58bd4(p0) end

---@param p0 integer
---@param p1 string
---@return boolean, any
function N_0x8cc469ab4d349b7c(p0, p1) end

---@param toggle boolean
function N_0x8cde909a0370bb3a(toggle) end

---@param p0 any
function N_0x8cff648fbd7330f1(p0) end

---@param p0 string
function N_0x8d74e26f54b4e5c3(p0) end

---@param player integer
---@param p1 number
function N_0x8d768602adef2245(player, p1) end

---@param p0 any
function N_0x8d8adb562f09a245(p0) end

---@param threadId integer
function N_0x8d9df6eca8768583(threadId) end

---@param p0 any
---@param p1 any
function N_0x8dca505a5c196f05(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x8e243837643d9583(p0, p1, p2, p3) end

---@param p0 any
function N_0x8ec74ceb042e7cff(p0) end

---@param toggle boolean
function N_0x8ef52acaecc51d9c(toggle) end

---@param p0 any
---@param p2 any
---@return boolean, any
function N_0x8f08017f9d7c47bd(p0, p2) end

---@param toggle boolean
function N_0x8f0d5ba1c2cc91d7(toggle) end

---@return any
function N_0x906ca41a4b74eca4() end

---@param p0 any
function N_0x908311265d42a820(p0) end

---@param player integer
---@param entity integer
function N_0x9097eb6d4bb9a12a(player, entity) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x90cd7c6871fbf1b4(p0, p1, p2, p3) end

---@param p0 string
function N_0x916ca67d26fd1e37(p0) end

---@param p0 boolean
function N_0x91ef6ee6419e5b97(p0) end

---@param p0 any
---@return any
function N_0x9237e334f6e43156(p0) end

---@param p0 string
---@return boolean, integer
function N_0x92da6e70ef249bd1(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function N_0x92fc0eedfac04a14(p0, p1, p2, p3, p4, p5) end

---@param p0 any
function N_0x930f504203f561c9(p0) end

---@return boolean
function N_0x933bbeeb8c61b5f4() end

---@param p0 boolean
function N_0x94538037ee44f5cf(p0) end


function N_0x9465e683b12d3f6b() end

---@return boolean
function N_0x9489659372a81585() end

---@param p0 number
function N_0x949f397a288b28b3(p0) end

---@param iplName1 string
---@param iplName2 string
function N_0x95a7dabddbb78ae7(iplName1, iplName2) end

---@param p0 any
---@param p1 any
function N_0x95baf97c82464629(p0, p1) end

---@param vehicle integer
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0x9640e30a7f395e4b(vehicle, p1, p2, p3, p4) end

---@param p0 any
function N_0x9641588dab93b4b5(p0) end

---@param componentHash integer | string
---@return integer
function N_0x96e2929292a4db77(componentHash) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x96e6d5150dbf1c09(p0, p1, p2) end

---@param p0 boolean
function N_0x973d76aa760a6cb6(p0) end

---@param weaponObject integer
---@param p1 integer
function N_0x977ca98939e82e4b(weaponObject, p1) end

---@param vehicle integer
---@param toggle boolean
function N_0x97841634ef7df1d6(vehicle, toggle) end

---@param p0 any
function N_0x97e7e2c04245115b(p0) end

---@param p0 any
---@param p1 any
function N_0x97ffb4adeed08066(p0, p1) end

---@param vehicle integer
---@param toggle boolean
function N_0x9849de24fcf23ccc(vehicle, toggle) end

---@param string string
---@param length integer
---@return string
function N_0x98c3cf913d895111(string, length) end

---@return any
function N_0x98d18905bf723b99() end


function N_0x98e2bc1ca26287c3() end


function N_0x98edf76a7271e4f2() end

---@param p0 boolean
function N_0x9911f4a24485f653(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0x998e18ceb44487fc(p0, p1, p2, p3) end

---@param toggle boolean
function N_0x99a05839c46ce316(toggle) end

---@param vehicle integer
---@param p1 number
---@param p2 number
function N_0x99cad8e7afdb60fa(vehicle, p1, p2) end

---@return integer
function N_0x9a62ec95ae10e011() end

---@param ped integer
---@param toggle boolean
function N_0x9a77dfd295e29b09(ped, toggle) end


function N_0x9ac92eed5e4793ab() end

---@param p0 boolean
function N_0x9b079e5221d984d3(p0) end


function N_0x9b4bd21d69b1e609() end

---@return any
function N_0x9b5016a6433a68c5() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0x9bd7bd55e4533183(p0, p1, p2) end

---@param vehicle integer
---@param p1 boolean
---@param p2 boolean
function N_0x9bddc73cc6a115d4(vehicle, p1, p2) end

---@param vehicle integer
---@param p1 boolean
function N_0x9becd4b9fef3f8a6(vehicle, p1) end

---@param ped integer
---@return boolean, integer
function N_0x9c6a6c19b6c0c496(ped) end

---@param p0 any
---@return any
function N_0x9d252648778160df(p0) end

---@param p0 any
function N_0x9d30687c57baa0bb(p0) end

---@param p0 any
---@param p1 any
function N_0x9d724b400a7e8ffc(p0, p1) end

---@param toggle boolean
function N_0x9d7afcbf21c51712(toggle) end

---@return boolean
function N_0x9de5d2f723575ed0() end

---@param p0 boolean
---@param p1 boolean
function N_0x9dfe13ecdc1ec196(p0, p1) end

---@return boolean, any, any
function N_0x9e30e91fb03a2caf() end

---@param toggle boolean
function N_0x9e6542f0ce8e70a3(toggle) end

---@param p0 boolean
function N_0x9ebd751e5787baf2(p0) end

---@return any
function N_0x9ec8858184cd253a() end

---@param player integer
function N_0x9edd76e87d5d51ba(player) end

---@param player integer
---@param entity integer
function N_0x9f260bfb59adbca3(player, entity) end

---@param vehicle integer
---@param p1 boolean
function N_0x9f3f689b814f2599(vehicle, p1) end


function N_0x9f97da93681f87ea() end

---@param p0 integer
---@param p1 number
function N_0x9fcb3cbfb3ead69a(p0, p1) end

---@return any
function N_0x9fedf86898f100e9() end

---@param vehicle integer
---@param seatIndex integer
---@return integer
function N_0xa01bc64dd4bfbbac(vehicle, seatIndex) end

---@param p0 any
---@param p1 number
---@param p2 boolean
function N_0xa08fe5e49bdc39dd(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
---@param p10 any
---@param p11 any
---@param p12 any
---@param p13 any
---@return any
function N_0xa0ad167e4b39d9a2(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) end

---@param p0 any
function N_0xa0cefcea390aab9b(p0) end

---@return boolean, any
function N_0xa0f93d5465b3094d() end

---@return any
function N_0xa0fa4ec6a05da44e() end

---@return integer
function N_0xa0fe76168a189ddb() end

---@return any
function N_0xa12d3a5a3753cc23() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xa17784fca9548d15(p0, p1, p2) end

---@param p1 boolean
---@return integer
function N_0xa1ae736541b0fca3(p1) end

---@return boolean
function N_0xa213b11dff526300() end

---@return boolean, integer, integer, integer
function N_0xa238192f33110615() end

---@param p0 any
function N_0xa247f9ef01d8082e(p0) end

---@param p0 any
---@param p1 boolean
function N_0xa2767257a320fc82(p0, p1) end


function N_0xa2c1f5e92afe49ed() end

---@param ped integer
---@param weaponHash integer | string
---@return integer
function N_0xa2c9ac24b4061285(ped, weaponHash) end

---@return integer
function N_0xa2ccbe62cd4c91a4() end

---@param toggle boolean
function N_0xa2e9c1ab8a92e8cd(toggle) end

---@return any
function N_0xa306f470d1660581() end

---@param p0 any
---@param p1 any
function N_0xa3c53804bdb68ed2(p0, p1) end

---@param ped integer
---@return boolean
function N_0xa3f3564a5b3646c0(ped) end

---@return boolean
function N_0xa468e0be12b12c70() end

---@param p0 boolean
function N_0xa46b73faa3460ae1(p0) end

---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@return boolean, vector3, vector3, vector3
function N_0xa4822f1cf23f4810(p3, p4, p5, p6, p7, p8) end

---@return boolean, vector3, number, boolean, boolean
function N_0xa4a0065e39c9f25c() end

---@param p0 any
function N_0xa4a9a4c40e615885(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xa51338e0dccd4065(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xa51b086b0b2c0f7a(p0, p1, p2, p3) end

---@param p0 any
function N_0xa52d5247a4227e14(p0) end

---@param p0 any
---@param p1 boolean
function N_0xa660faf550eb37e5(p0, p1) end

---@param p0 any
---@param p1 any
---@return any
function N_0xa6eef01087181edd(p0, p1) end

---@param p0 any
function N_0xa6f54bb2ffca35ea(p0) end

---@param p0 any
function N_0xa6fceccf4721d679(p0) end


function N_0xa7092afe81944852() end

---@return any, any, any, any
function N_0xa736cf7fb7c5bff4() end

---@return any
function N_0xa761d4ac6115623d() end

---@param p0 any
---@param p1 any
---@return boolean, any, any
function N_0xa7862bc5ed1dfd7e(p0, p1) end

---@param p0 integer
function N_0xa78b8fa58200da56(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0xa7dcdf4ded40a8f4(vehicle, p1) end

---@param doorHash integer | string
---@param p1 boolean
function N_0xa85a21582451e951(doorHash, p1) end

---@param p0 any
function N_0xa8733668d1047b51(p0) end

---@return any
function N_0xa8acb6459542a8c8() end

---@return any
function N_0xa943fd1722e11efd() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xa95cfb4e02390842(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xa95f667a755725da(p0, p1, p2, p3) end

---@param p0 any
---@param p1 boolean
function N_0xa9b61a329bfdcbea(p0, p1) end

---@param p0 any
---@param p1 any
function N_0xaa059c615de9dd03(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xaa525dff66bb82f5(p0, p1, p2) end

---@return vector3
function N_0xaa5fafcd2c5f5e47() end

---@param vehicle integer
---@param toggle boolean
function N_0xaa653ae61924b0a0(vehicle, toggle) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function N_0xaa76052dda9bfc3e(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 any
---@return any
function N_0xaaa6a3698a69e048(p0) end

---@param p0 any
---@param p1 any
function N_0xaabd62873ffb1a33(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
function N_0xaae9be70ec7c69ab(p0, p1, p2, p3, p4, p5, p6, p7) end

---@param vehicle integer
---@param p1 boolean
function N_0xab04325045427aae(vehicle, p1) end

---@param ped integer
---@param p1 string
---@return any
function N_0xab13a5565480b6d9(ped, p1) end

---@param p0 any
---@param p1 any
function N_0xab31ef4de6800ce9(p0, p1) end

---@param p0 number
function N_0xac2890471901861c(p0) end

---@param ped integer
---@param p1 any
---@param p2 number
---@param hash integer | string
---@param p4 any
---@param p5 any
function N_0xad27d957598e49e9(ped, p1, p2, hash, p4, p5) end

---@param player integer
function N_0xad73ce5a09e42d12(player) end

---@param p0 integer
---@return number, number
function N_0xadb57e5b663cca8b(p0) end

---@param p0 any
function N_0xadd6627c4d325458(p0) end

---@param p0 integer
---@return boolean
function N_0xadf084fb8f075d06(p0) end

---@param vehicle integer
---@return boolean
function N_0xae3fee8709b39dcb(vehicle) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
function N_0xae51bc858f32ba66(p0, p1, p2, p3, p4) end

---@param p0 any
---@return boolean
function N_0xaeab987727c5a8a4(p0) end


function N_0xaedf1bc1c133d6e3() end

---@param roomName string
function N_0xaf348afcb575a441(roomName) end

---@param p0 any
---@param p1 any
function N_0xaf60e6a2936f982a(p0, p1) end

---@param ped integer
---@param toggle boolean
function N_0xafc976fd0580c7b3(ped, toggle) end

---@param object integer
---@param p1 number
---@param p2 number
---@param p3 boolean
---@return boolean
function N_0xafe24e4d29249e4a(object, p1, p2, p3) end

---@return any
function N_0xaff47709f1d5dcce() end


function N_0xb1381b97f70c7b30() end


function N_0xb13e88e655e5a3bc() end

---@param p0 any
---@param p1 any
function N_0xb17bc6453f6cf5ac(p0, p1) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function N_0xb1b6216ca2e7b55e(p0, p1, p2) end

---@return boolean
function N_0xb1d2bb1e1631f5b1() end

---@param p0 any
function N_0xb26f670685631727(p0) end

---@param p0 any
---@param p1 any
function N_0xb282749d5e028163(p0, p1) end

---@param object integer
---@param toggle boolean
function N_0xb2d0bde54f0e8e5a(object, toggle) end

---@param vehicle integer
---@param toggle boolean
function N_0xb2e0c0d6922d31f2(vehicle, toggle) end

---@return any
function N_0xb2ebe8cbc58b90e9() end

---@param p0 any
---@return any
function N_0xb309ebea797e001f(p0) end

---@param toggle boolean
function N_0xb3352e018d6f89df(toggle) end

---@return boolean
function N_0xb37e4e6a2388ca7b() end

---@param p0 number
function N_0xb3c641f3630bf6da(p0) end

---@return boolean
function N_0xb3da2606774a8e2d() end

---@param p0 number
function N_0xb45eff719d8427a6(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xb4c2ec463672474e(p0, p1, p2, p3) end

---@param p0 any
function N_0xb4deae67f35e2acd(p0) end

---@param toggle boolean
function N_0xb51b9ab9ef81868c(toggle) end

---@param p0 boolean
function N_0xb542de8c3d1cb210(p0) end

---@param p0 any
---@param p1 any
function N_0xb552929b85fc27ec(p0, p1) end

---@param p0 any
function N_0xb569f41f3e7e83a4(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0xb5b58e24868cb09e(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
function N_0xb5b7742424bd4445(p0, p1) end

---@return any
function N_0xb5d3453c98456528() end

---@param p0 any
function N_0xb606e6cc59664972(p0) end

---@param vehicle integer
---@param toggle boolean
function N_0xb68cfaf83a02768d(vehicle, toggle) end

---@param ropeId integer
---@param p1 integer
function N_0xb743f735c03d7810(ropeId, p1) end

---@return boolean, any, any
function N_0xb746d20b17f2a229() end


function N_0xb7b873520c84c118() end


function N_0xb7c6d80fb371659a() end


function N_0xb885852c39cc265d() end

---@param p0 any
---@return any
function N_0xb9351a07a0d458b1(p0) end

---@param p0 any
---@param p1 any
function N_0xb9562064627ff9db(p0, p1) end

---@return boolean
function N_0xb9cf1f793a9f1bf1() end

---@param p0 any
---@param p1 any
function N_0xba0127da25fd54c9(p0, p1) end

---@param p0 string
function N_0xba3d194057c79a7b(p0) end

---@param p0 any
function N_0xba4b8d83bdc75551(p0) end

---@param p0 any
---@param p1 any
function N_0xba7f0b77d80a4eb7(p0, p1) end

---@param toggle boolean
function N_0xba8d65c1c65702e5(toggle) end

---@return any
function N_0xba9749cc94c1fd85() end

---@param p0 any
function N_0xbaa2f0490e146be8(p0) end

---@param p0 any
---@param p1 any
function N_0xbb2333bb87ddd87f(p0, p1) end

---@param p0 number
function N_0xbb90e12cac1dab25(p0) end

---@param ropeId integer
---@param p1 integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 number
---@param p9 number
---@param p10 number
---@param p11 number
---@param p12 number
---@param p13 number
function N_0xbc0ce682d4d05650(ropeId, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13) end

---@param player integer
function N_0xbc9490ca15aea8fb(player) end

---@return any
function N_0xbcedb009461da156() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xbd0efb25cca8f97a(p0, p1, p2, p3) end

---@return boolean
function N_0xbd545d44cce70597() end

---@return boolean
function N_0xbdb6f89c729cf388() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function N_0xbe197eaa669238f4(p0, p1, p2, p3) end

---@return any
function N_0xbe3db208333d9844() end

---@param vehicle integer
---@param toggle boolean
function N_0xbe5c1255a1830ff5(vehicle, toggle) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xbeb2d9a1d9a8f55a(p0, p1, p2, p3) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
function N_0xbed8ca5ff5e04113(p0, p1, p2, p3) end

---@param statName integer | string
---@param p1 integer
---@return boolean, number
function N_0xbed9f5693f34ed17(statName, p1) end

---@param p0 boolean
function N_0xbef34b1d9624d5dd(p0) end

---@param player integer
---@param p1 boolean
function N_0xbf22e0f32968e967(player, p1) end

---@param p0 any
function N_0xbf371cd2b64212fd(p0) end

---@return any
function N_0xbf72910d0f26f025() end

---@param p0 any
function N_0xbfafdb5faaa5c5ab(p0) end

---@param p0 any
---@param p1 any
function N_0xbffe53ae7e67fcdc(p0, p1) end


function N_0xc01d2470f22cde5a() end

---@param p0 any
function N_0xc03fab2c2f92289b(p0) end

---@param p0 boolean
function N_0xc0416b061f2b7e5e(p0) end

---@return any
function N_0xc0e0d686ddfc6eae() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xc0ed6438e6d39ba8(p0, p1, p2) end

---@return boolean, any
function N_0xc13c38e47ea5df31() end


function N_0xc141b8917e0017ec() end

---@param p0 any
function N_0xc14bd9f5337219b2(p0) end

---@param vehicle integer
function N_0xc1805d05e6d4fe10(vehicle) end

---@param p0 any
function N_0xc1e963c58664b556(p0) end

---@return boolean
function N_0xc2c97ea97711d1ae() end

---@return boolean
function N_0xc2d2ad9eaae265b8() end

---@param ped integer
function N_0xc2ee020f5fb4db53(ped) end

---@param p0 any
---@return any
function N_0xc30bdaee47256c13(p0) end

---@return any
function N_0xc32ea7a2f6ca7557() end

---@param player integer
function N_0xc3376f42b1faccc6(player) end

---@param entity integer
---@param toggle boolean
function N_0xc34bc448da29f5e9(entity, toggle) end


function N_0xc35a6d07c93802b2() end

---@param vehicle integer
---@param p1 boolean
function N_0xc361aa040d6637a8(vehicle, p1) end

---@return boolean
function N_0xc42dd763159f3461() end

---@param p0 any
---@return any, integer
function N_0xc434133d9ba52777(p0) end

---@return boolean
function N_0xc4637a6d03c24cc3() end

---@param p0 any
function N_0xc4b3347bd68bd609(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0xc50ce861b55eab8b(vehicle, p1) end

---@param modelHash integer | string
---@param p1 any
---@param p2 any
---@return any
function N_0xc56fbf2f228e1dac(modelHash, p1, p2) end

---@return boolean
function N_0xc571d0e77d8bbc29() end

---@param ped integer
function N_0xc594b315edf2d4af(ped) end

---@return boolean
function N_0xc5a35c73b68f3c49() end

---@param p0 any
function N_0xc5c8f970d4edff71(p0) end

---@param object integer
---@param toggle boolean
function N_0xc6033d32241f6fb5(object, toggle) end

---@param toggle boolean
function N_0xc61b86c9f61eb404(toggle) end


function N_0xc67e2da1cbe759e2() end

---@return any
function N_0xc6e0e2616a7576bb() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function N_0xc6e74cf8c884c880(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 boolean
function N_0xc7f29ca00f46350e(p0) end

---@param transactionId integer
---@return boolean
function N_0xc830417d630a50f9(transactionId) end


function N_0xc8391c309684595a() end


function N_0xc847b43f369ac0b5() end

---@return any
function N_0xc87e740d9f3872cc() end

---@param cam integer
function N_0xc8b5c4a79cc18b94(cam) end

---@return boolean, any, any, any
function N_0xc8e1071177a23be5() end

---@param p0 any
function N_0xca465d9cc0d231ba(p0) end

---@param p0 boolean
function N_0xca4ae345a153d573(p0) end

---@param p0 any
function N_0xca575c391fea25cc(p0) end


function N_0xca59ccae5d01e4ce() end

---@param p0 any
---@param p2 any
---@return boolean, any
function N_0xca6b2f7ce32ab653(p0, p2) end

---@param player integer
---@param p1 boolean
function N_0xcac57395b151135f(player, p1) end

---@param padIndex integer
function N_0xcb0360efefb2580d(padIndex) end

---@return boolean
function N_0xcb645e85e97ea48b() end

---@param p0 integer
---@return integer
function N_0xcb82a0bf0e3e3265(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0xcc25a4553dfbf9ea(p0, p1, p2, p3, p4) end

---@param object integer
function N_0xcc6e963682533882(object) end

---@param p0 boolean
function N_0xccd078c2665d2973(p0) end

---@param ped integer
---@param p1 boolean
function N_0xcd018c591f94cb43(ped, p1) end


function N_0xcd0f5b5d932ae473() end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xcd4d66b43b1dd28d(p0, p1, p2) end

---@param toggle boolean
function N_0xcd74233600c4ea6b(toggle) end

---@param p0 any
---@param p1 any
function N_0xcea7c8e1b48ff68c(p0, p1) end

---@param p0 number
---@param p1 number
function N_0xced08cbe8ebb97c7(p0, p1) end

---@param p0 any
---@param p1 boolean
function N_0xceda60a74219d064(p0, p1) end

---@param p0 any
function N_0xcf9159024555488c(p0) end

---@param toggle boolean
function N_0xcfd16f0db5a3535c(toggle) end

---@param vehicle integer
function N_0xcfd778e7904c255e(vehicle) end

---@param p0 boolean
function N_0xcfeb46dcd7d8d5eb(p0) end

---@param p0 any
---@param p1 any
function N_0xd05a3241b9a86f19(p0, p1) end

---@return any
function N_0xd10282b6e3751ba0() end

---@param p0 any
function N_0xd1942374085c8469(p0) end

---@param p0 any
function N_0xd1a1ee3b4fa8e760(p0) end

---@param p0 any
function N_0xd1c55b110e4df534(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xd1c9b92bdd3f151d(p0, p1, p2) end


function N_0xd2049635deb9c375() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0xd29334ed1a256dbf(p0, p1, p2, p3, p4) end

---@return boolean
function N_0xd313de83394af134() end

---@param p0 any
function N_0xd3301660a57c9272(p0) end

---@param ped integer
function N_0xd33daa36272177c4(ped) end

---@param p0 any
---@param p1 any
---@return any
function N_0xd3e51c0ab8c26eee(p0, p1) end

---@param p0 any
---@param p1 any
---@return any
function N_0xd4196117af7bb974(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xd4367d310f079db0(p0, p1, p2, p3) end

---@param x number
---@param y number
---@param z number
---@param radius number
function N_0xd4a7a435b3710d05(x, y, z, radius) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0xd558bec0bba7e8d2(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
function N_0xd565f438137f0e10(p0, p1) end

---@return any
function N_0xd642319c54aadeb6() end

---@param p0 any
function N_0xd6ca58b3b53a0f22(p0) end

---@param p0 any
---@param p1 any
function N_0xd6d7478ca62b8d41(p0, p1) end

---@param p0 boolean
function N_0xd7b6c73cad419bcf(p0) end

---@return any
function N_0xd8122c407663b995() end

---@param player integer
---@param p1 any
function N_0xd821056b9acf8052(player, p1) end


function N_0xd9f692d349249528() end

---@param p0 any
function N_0xdaf80797fc534bec(p0) end

---@param p0 any
---@return boolean
function N_0xdaf87174be7454ff(p0) end

---@param checkpointHandle integer
function N_0xdb1ea9411c8911ec(checkpointHandle) end

---@param p0 any
---@return any
function N_0xdb41d07a45a6d4b7(p0) end

---@param player integer
---@return integer
function N_0xdb663cc9ff3407a9(player) end

---@param p0 boolean
function N_0xdb90c6cca48940f1(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0xdbc631f109350b8c(vehicle, p1) end

---@param p0 any
---@return any
function N_0xdbf860cf1db8e599(p0) end

---@param player integer
---@return boolean
function N_0xdcc07526b8ec45af(player) end


function N_0xdce97bdf8a0eabc8() end

---@param player integer
---@param p1 number
---@return boolean
function N_0xdd2620b7b9d16ff1(player, p1) end


function N_0xdd79df9f4d26e1c9() end

---@return any
function N_0xde03620f8703a9df() end

---@param player integer
---@param toggle boolean
function N_0xde45d1a1ef45ee61(player, toggle) end

---@param amount integer
---@param p1 any
function N_0xde68e30d89f97132(amount, p1) end

---@param p0 any
---@return any, any
function N_0xdeaaf77eb3687e97(p0) end

---@return any
function N_0xdf4b952f7d381b95() end

---@param p0 any
function N_0xdfbd93bf2943e29b(p0) end

---@param p0 any
function N_0xdfcdb14317a9b361(p0) end

---@param ped integer
function N_0xdfe68c4b787e1bfb(ped) end

---@param p0 boolean
function N_0xe058175f8eafe79a(p0) end

---@param p0 any
---@param p1 boolean
function N_0xe05dd0e9707003a3(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xe05f6aeefeb0bb02(p0, p1, p2) end

---@param p0 any
function N_0xe0f82d68c7039158(p0) end

---@param p0 any
---@param p1 number
function N_0xe111a7c0d200cbc5(p0, p1) end

---@param p0 any
---@return boolean
function N_0xe154b48b68ef72bc(p0) end

---@return boolean
function N_0xe1615ec03b3bb4fd() end

---@param p0 any
---@return any
function N_0xe16aa70ce9beedc3(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
function N_0xe23adc6fcb1f29ae(p0, p1, p2) end

---@param p0 number
function N_0xe2892e7e55d7073a(p0) end

---@param p0 any
---@param p1 any
function N_0xe2bb399d90942091(p0, p1) end

---@param amount integer
---@param p1 any
function N_0xe2e244ab823b4483(amount, p1) end


function N_0xe2f53f172b45ede1() end

---@param p0 any
function N_0xe3261d791eb44acb(p0) end

---@param p0 boolean
function N_0xe36a98d8ab3d3c66(p0) end


function N_0xe3d969d2785ffb5e() end

---@return any
function N_0xe3e5a7c64ca2c6ed() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return integer, integer, integer
function N_0xe42d626eec94e5d9(p0, p1, p2, p3) end

---@param p0 any
---@return any
function N_0xe496a53ba5f50a56(p0) end

---@param p0 any
function N_0xe4c3b169876d33d7(p0) end

---@param ped integer
function N_0xe4dcec7fd5b739a5(ped) end

---@param p0 any
---@return any
function N_0xe4f6e8d07a2f0f51(p0) end

---@param p0 integer
---@param p1 integer
function N_0xe532ec1a63231b4f(p0, p1) end

---@param vehicle integer
---@param p1 number
function N_0xe5810ac70602f2f5(vehicle, p1) end

---@return number
function N_0xe59343e9e96529e7() end

---@return any
function N_0xe5e9746a66359f9d() end

---@param toggle boolean
function N_0xe63d7c6eececb66b(toggle) end

---@param entity integer
---@param p1 boolean
function N_0xe66377cddada4810(entity, p1) end

---@param p0 any
---@param p1 any
function N_0xe6717e652b8c8d8a(p0, p1) end

---@param p0 any
---@param p1 any
function N_0xe6d2cedd370ff98e(p0, p1) end

---@return boolean
function N_0xe75a4a2e5e316d86() end

---@param p0 any
---@return any
function N_0xe791df1f73ed2c8b(p0) end

---@param vehicle integer
---@param p1 boolean
function N_0xe851e480b814d4ba(vehicle, p1) end

---@param vehicle integer
---@return boolean
function N_0xe8718faf591fd224(vehicle) end

---@return any
function N_0xe8853fbce7d8d0d6() end

---@param p0 any
---@param p1 any
function N_0xe906ec930f5fe7c8(p0, p1) end

---@param ped integer
---@return boolean
function N_0xe95b0c7d5ba3b96b(ped) end

---@param p0 any
---@param p1 any
function N_0xea8c0ddb10e2822a(p0, p1) end


function N_0xea95c0853a27888e() end

---@param p0 any
---@return integer
function N_0xea9960d07dadcf10(p0) end

---@param p0 any
---@param p1 any
function N_0xeb078ca2b5e82add(p0, p1) end

---@return any
function N_0xeb2104e905c6f2e9() end

---@param p0 any
---@param p1 boolean
function N_0xeb6f1a9b5510a5d2(p0, p1) end


function N_0xeb81a3dadd503187() end

---@return any
function N_0xebcab9e5048434f4() end

---@return any
function N_0xebd3205a207939ed() end


function N_0xebf8284d8cadeb53() end

---@param p0 any
---@return boolean
function N_0xebfa8d50addc54c4(p0) end

---@param ped integer
---@param unk number
function N_0xec4b4b3b9908052a(ped, unk) end

---@param p0 any
---@return any
function N_0xec72c258667be5ea(p0) end

---@return boolean
function N_0xecb41ac6ab754401() end

---@param ped integer
function N_0xed3c76adfa6d07c4(ped) end

---@param p0 any
---@param p1 any
function N_0xed5ede9e676643c9(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xed5fd7af10f5e262(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xed76d195e6e3bf7f(p0, p1, p2, p3) end

---@param p0 any
function N_0xedbf6c9b0d2c65c8(p0) end

---@param p0 boolean
function N_0xef398beee4ef45f9(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function N_0xef39ee20c537e98c(p0, p1, p2, p3, p4, p5) end

---@param vehicle integer
---@param p1 boolean
function N_0xef9d388f8d377f44(vehicle, p1) end

---@param p0 any
---@return any
function N_0xf033419d1b81fae8(p0) end

---@param p0 any
function N_0xf051d9bfb6ba39c0(p0) end

---@param p0 any
function N_0xf06a6f41cb445443(p0) end


function N_0xf083835b70ba9bfe() end

---@return any, number
function N_0xf11f01d98113536a() end

---@return boolean
function N_0xf13fe2a80c05c561() end

---@param value integer
function N_0xf1a1803d3476f215(value) end

---@param p0 any
---@return boolean
function N_0xf22ca0fd74b80e7a(p0) end

---@param ped integer
---@return boolean
function N_0xf2385935bffd4d92(ped) end

---@param padIndex integer
---@param p1 integer
function N_0xf239400e16c23e08(padIndex, p1) end


function N_0xf25e02cb9c5818f8() end

---@return any
function N_0xf284ac67940c6812() end

---@return any
function N_0xf287f506767cc8a9() end

---@param toggle boolean
function N_0xf2bebcdfafdaa19e(toggle) end

---@return integer
function N_0xf2ca003f167e21d2() end

---@return boolean
function N_0xf2e07819ef1a5289() end

---@param p0 any
---@param p1 any
---@return any
function N_0xf3b0e0aed097a3f5(p0, p1) end

---@param p0 any
---@param p1 any
function N_0xf3f776ada161e47d(p0, p1) end

---@param p0 any
function N_0xf49abc20d8552257(p0) end


function N_0xf4a0dadb70f57fa6() end

---@param checkpoint integer
---@param posX number
---@param posY number
---@param posZ number
---@param unkX number
---@param unkY number
---@param unkZ number
function N_0xf51d36185993515d(checkpoint, posX, posY, posZ, unkX, unkY, unkZ) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function N_0xf534d94dfa2ead26(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 number
function N_0xf55e4046f6f831dc(p0, p1) end

---@param p0 string
---@return boolean, integer
function N_0xf6baaaf762e1bf40(p0) end

---@param p0 any
function N_0xf6f4383b7c92f11a(p0) end

---@param p0 number
function N_0xf78b803082d4386f(p0) end


function N_0xf814fec6a19fd6e0() end

---@param p0 any
function N_0xf8155a7f03ddfc8e(p0) end

---@param blip integer
---@param p1 any
---@param p2 any
---@param width number
---@param p4 any
---@param length number
---@param heading number
---@param p7 any
function N_0xf83d0febe75e62c9(blip, p1, p2, width, p4, length, heading, p7) end


function N_0xf854439efbb3b583() end

---@param vehicle integer
---@param p1 integer
function N_0xf8b49f5ba7f850e7(vehicle, p1) end

---@return any, any, any, any
function N_0xf8c54a461c3e11dc() end

---@param p0 any
function N_0xf9096193df1f99d4(p0) end

---@param p0 any
---@param p1 any
function N_0xf92099527db8e2a7(p0, p1) end

---@return any
function N_0xf9f2922717b819ec() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function N_0xfa07759e6fddd7cf(p0, p1, p2, p3) end

---@param toggle boolean
function N_0xfa1e0e893d915215(toggle) end


function N_0xfa2888e3833c8e96() end

---@param p0 boolean
function N_0xfa3ffb0eebc288a3(p0) end

---@param x number
---@param y number
---@param z number
function N_0xfa83ca6776038f64(x, y, z) end

---@param name string
---@return any
function N_0xfaa457ef263e8763(name) end

---@param ped integer
---@param toggle boolean
function N_0xfab944d4d481accb(ped, toggle) end


function N_0xfac18e7356bd3210() end

---@param player integer
function N_0xfac75988a7d078d3(player) end

---@param p0 integer | string
---@param p1 integer
---@param p2 integer | string
function N_0xfae628f1e9adb239(p0, p1, p2) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
function N_0xfaf2a78061fd9ef4(p0, p1, p2, p3) end


function N_0xfb00ca71da386228() end

---@return boolean
function N_0xfb199266061f820a() end

---@param p0 integer
---@return any, any
function N_0xfb1f9381e80fa13f(p0) end

---@param p0 any
---@param p1 any
function N_0xfb680d403909dc70(p0, p1) end

---@param p0 any
function N_0xfcc228e07217fcac(p0) end

---@param checkpoint integer
function N_0xfcf6788fc4860cd4(checkpoint) end

---@param entity integer
function N_0xfd3151cd37ea2245(entity) end

---@param ped integer
---@param toggle boolean
function N_0xfd325494792302d7(ped, toggle) end

---@param p0 boolean
function N_0xfd75dabc0957bf33(p0) end

---@param pickupHash integer | string
function N_0xfdc07c58e8aab715(pickupHash) end

---@param p0 any
---@param p1 boolean
---@return boolean
function N_0xfe4c1d0d3b9cc17e(p0, p1) end

---@param ped integer
---@return boolean
function N_0xfec9a3b1820f3331(ped) end

---@param p0 number
---@param p1 any
function N_0xff4803bc019852d9(p0, p1) end

---@return any
function N_0xff8f3a92b75ed67a() end

---@param player integer
function N_0xffee8fa29ab9a18e(player) end

---@param quantity integer
---@return boolean, any
function NetGameserverBasketAddItem(quantity) end

---@param p0 any
---@return boolean, any
function NetGameserverBasketApplyServerData(p0) end

---@return boolean
function NetGameserverBasketDelete() end

---@return boolean
function NetGameserverBasketEnd() end

---@return boolean
function NetGameserverBasketIsFull() end

---@param categoryHash integer | string
---@param actionHash integer | string
---@param flags integer
---@return boolean, integer
function NetGameserverBasketStart(categoryHash, actionHash, flags) end

---@param categoryHash integer | string
---@param itemHash integer | string
---@param actionTypeHash integer | string
---@param value integer
---@param flags integer
---@return boolean, integer
function NetGameserverBeginService(categoryHash, itemHash, actionTypeHash, value, flags) end

---@return boolean
function NetGameserverCatalogIsReady() end

---@param name string
---@return boolean
function NetGameserverCatalogItemExists(name) end

---@param hash integer | string
---@return boolean
function NetGameserverCatalogItemExistsHash(hash) end

---@param transactionId integer
---@return boolean
function NetGameserverCheckoutStart(transactionId) end

---@param slot integer
---@param transfer boolean
---@param reason integer | string
---@return boolean
function NetGameserverDeleteCharacterSlot(slot, transfer, reason) end

---@return integer
function NetGameserverDeleteCharacterSlotGetStatus() end

---@return boolean
function NetGameserverDeleteSetTelemetryNonceSeed() end

---@param transactionId integer
---@return boolean
function NetGameserverEndService(transactionId) end

---@param inventory boolean
---@param playerbalance boolean
---@return boolean
function NetGameserverGetBalance(inventory, playerbalance) end

---@return boolean, integer
function NetGameserverGetCatalogState() end

---@param itemHash integer | string
---@param categoryHash integer | string
---@param p2 boolean
---@return integer
function NetGameserverGetPrice(itemHash, categoryHash, p2) end

---@return boolean, integer, boolean
function NetGameserverGetTransactionManagerData() end

---@return boolean
function NetGameserverIsCatalogValid() end

---@return boolean
function NetGameserverIsSessionRefreshPending() end

---@param charSlot integer
---@return boolean
function NetGameserverIsSessionValid(charSlot) end

---@param charSlot integer
---@return boolean
function NetGameserverSessionApplyReceivedData(charSlot) end

---@param p0 integer
---@return boolean
function NetGameserverSetTelemetryNonceSeed(p0) end

---@param charSlot integer
---@return boolean
function NetGameserverStartSession(charSlot) end

---@param charSlot integer
---@param amount integer
---@return boolean
function NetGameserverTransferBankToWallet(charSlot, amount) end

---@return integer
function NetGameserverTransferCashGetStatus() end

---@return integer
function NetGameserverTransferCashGetStatus_2() end

---@return boolean
function NetGameserverTransferCashSetTelemetryNonceSeed() end

---@param charSlot integer
---@param amount integer
---@return boolean
function NetGameserverTransferWalletToBank(charSlot, amount) end

---@return boolean
function NetGameserverUseServerTransactions() end

---@param netHandle integer
---@return integer
function NetToEnt(netHandle) end

---@param netHandle integer
---@return integer
function NetToObj(netHandle) end

---@param netHandle integer
---@return integer
function NetToPed(netHandle) end

---@param netHandle integer
---@return integer
function NetToVeh(netHandle) end

---@return boolean
function NetworkAcceptInvite() end

---@param p0 any
---@return boolean
function NetworkAcceptPresenceInvite(p0) end

---@param tunableContext string
---@param tunableName string
---@return boolean
function NetworkAccessTunableBool(tunableContext, tunableName) end

---@param tunableContext integer | string
---@param tunableName integer | string
---@return boolean
function NetworkAccessTunableBoolHash(tunableContext, tunableName) end

---@param tunableContext string
---@param tunableName string
---@return boolean, number
function NetworkAccessTunableFloat(tunableContext, tunableName) end

---@param tunableContext integer | string
---@param tunableName integer | string
---@return boolean, number
function NetworkAccessTunableFloatHash(tunableContext, tunableName) end

---@param tunableContext string
---@param tunableName string
---@return boolean, integer
function NetworkAccessTunableInt(tunableContext, tunableName) end

---@param tunableContext integer | string
---@param tunableName integer | string
---@return boolean, integer
function NetworkAccessTunableIntHash(tunableContext, tunableName) end

---@return any
function NetworkActionFollowInvite() end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@return any
function NetworkAddEntityAngledArea(x1, y1, z1, x2, y2, z2, width) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@return any
function NetworkAddEntityArea(p0, p1, p2, p3, p4, p5) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@return any
function NetworkAddEntityDisplayedBoundaries(p0, p1, p2, p3, p4, p5) end

---@param entity integer
---@param netScene integer
---@param animDict string
---@param animName string
---@param blendIn number
---@param blendOut number
---@param flag integer
function NetworkAddEntityToSynchronisedScene(entity, netScene, animDict, animName, blendIn, blendOut, flag) end

---@param p1 integer
---@return integer
function NetworkAddFollowers(p1) end

---@param message string
---@return boolean, integer
function NetworkAddFriend(message) end

---@param netScene integer
---@param modelHash integer | string
---@param x number
---@param y number
---@param z number
---@param animDict string
---@param animName string
---@param blendInSpeed number
---@param blendOutSpeed number
---@param flags integer
function NetworkAddMapEntityToSynchronisedScene(netScene, modelHash, x, y, z, animDict, animName, blendInSpeed, blendOutSpeed, flags) end

---@param ped integer
---@param netScene integer
---@param animDict string
---@param animClip string
---@param blendInSpeed number
---@param blendOutSpeed number
---@param syncedSceneFlags integer
---@param ragdollFlags integer
---@param moverBlendInDelta number
---@param ikFlags integer
function NetworkAddPedToSynchronisedScene(ped, netScene, animDict, animClip, blendInSpeed, blendOutSpeed, syncedSceneFlags, ragdollFlags, moverBlendInDelta, ikFlags) end

---@param ped integer
---@param netSceneID integer
---@param animDict string
---@param animClip string
---@param blendIn number
---@param blendOut number
---@param sceneFlags integer
---@param ragdollFlags integer
---@param moverBlendInDelta number
---@param ikFlags integer
function NetworkAddPedToSynchronisedSceneWithIk(ped, netSceneID, animDict, animClip, blendIn, blendOut, sceneFlags, ragdollFlags, moverBlendInDelta, ikFlags) end

---@param netScene integer
---@param animDict string
---@param animName string
function NetworkAddSynchronisedSceneCamera(netScene, animDict, animName) end

---@return boolean
function NetworkAllocateTunablesRegistrationDataMap() end

---@param entity integer
---@param toggle boolean
function NetworkAllowRemoteAttachmentModification(entity, toggle) end

---@return boolean, any
function NetworkAmIBlockedByGamer() end

---@param player integer
---@return boolean
function NetworkAmIBlockedByPlayer(player) end

---@return boolean, any
function NetworkAmIMutedByGamer() end

---@param player integer
---@return boolean
function NetworkAmIMutedByPlayer(player) end

---@param ped integer
---@param player integer
---@return boolean
function NetworkApplyCachedPlayerHeadBlendData(ped, player) end

---@param ped integer
---@param p1 integer
function NetworkApplyPedScarData(ped, p1) end

---@param p0 integer
---@param p1 integer
function NetworkApplyTransitionParameter(p0, p1) end

---@param p0 integer
---@param string string
---@param p2 boolean
function NetworkApplyTransitionParameterString(p0, string, p2) end

---@param x number
---@param y number
---@param z number
function NetworkApplyVoiceProximityOverride(x, y, z) end

---@return boolean
function NetworkAreCutsceneEntities() end

---@return boolean, integer, integer
function NetworkAreHandlesTheSame() end

---@return boolean
function NetworkAreSocialClubPoliciesCurrent() end

---@param p0 any
---@return boolean
function NetworkAreTransitionDetailsValid(p0) end

---@param netScene integer
---@param entity integer
---@param bone integer
function NetworkAttachSynchronisedSceneToEntity(netScene, entity, bone) end


function NetworkBail() end


function NetworkBailTransition() end


function NetworkBailTransitionQuickmatch() end

---@param toggle boolean
function NetworkBlockInvites(toggle) end

---@param toggle boolean
function NetworkBlockJoinQueueInvites(toggle) end

---@param p0 boolean
function NetworkBlockKickedPlayers(p0) end

---@param cost integer
---@param p1 boolean
---@param p2 boolean
function NetworkBuyAirstrike(cost, p1, p2) end

---@param p0 integer
---@param p1 integer
---@param p2 boolean
---@param p3 boolean
function NetworkBuyBackupGang(p0, p1, p2, p3) end

---@param amount integer
---@param victim integer
---@param p2 boolean
---@param p3 boolean
function NetworkBuyBounty(amount, victim, p2, p3) end

---@param p0 integer
---@param p1 integer
---@param p2 integer | string
---@param p3 boolean
---@param p4 boolean
function NetworkBuyContraband(p0, p1, p2, p3, p4) end

---@param amountSpent integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkBuyFairgroundRide(amountSpent, p1, p2, p3) end

---@param cost integer
---@param p1 boolean
---@param p2 boolean
function NetworkBuyHealthcare(cost, p1, p2) end

---@param cost integer
---@param p1 boolean
---@param p2 boolean
function NetworkBuyHeliStrike(cost, p1, p2) end

---@param amount integer
---@param item integer | string
---@param p2 any
---@param p3 any
---@param p4 boolean
---@param item_name string
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 boolean
function NetworkBuyItem(amount, item, p2, p3, p4, item_name, p6, p7, p8, p9) end

---@param p0 integer
---@param p1 integer
---@param p2 boolean
---@param p3 boolean
function NetworkBuyLotteryTicket(p0, p1, p2, p3) end

---@param propertyCost integer
---@param propertyName integer | string
---@param p2 boolean
---@param p3 boolean
function NetworkBuyProperty(propertyCost, propertyName, p2, p3) end

---@param p0 integer
---@param p1 boolean
---@param p2 boolean
function NetworkBuySmokes(p0, p1, p2) end


function NetworkCacheLocalPlayerHeadBlendData() end

---@return boolean, integer
function NetworkCanAccessMultiplayer() end

---@return boolean
function NetworkCanBail() end

---@param amount integer
---@return boolean
function NetworkCanBet(amount) end

---@param cost integer
---@return boolean
function NetworkCanBuyLotteryTicket(cost) end

---@return boolean, integer
function NetworkCanCommunicateWithGamer() end

---@return boolean, any
function NetworkCanCommunicateWithGamer_2() end

---@return boolean
function NetworkCanEnterMultiplayer() end

---@return boolean, any
function NetworkCanGamerPlayMultiplayerWithMe() end

---@return boolean, any
function NetworkCanPlayMultiplayerWithGamer() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return boolean
function NetworkCanReceivePlayerCash(p0, p1, p2, p3) end

---@return boolean
function NetworkCanSessionEnd() end

---@return boolean
function NetworkCanSetWaypoint() end

---@return boolean
function NetworkCanShareJobCash() end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@param p4 any
---@return boolean
function NetworkCanSpendMoney(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@param p5 any
---@return boolean, any
function NetworkCanSpendMoney_2(p0, p1, p2, p3, p5) end

---@return boolean, any
function NetworkCanViewGamerUserContent() end


function NetworkCancelRespawnSearch() end

---@param p0 any
---@return boolean
function NetworkCasinoCanGamble(p0) end

---@return boolean
function NetworkCasinoCanPurchaseChipsWithPvc() end

---@return boolean
function NetworkCasinoCanPurchaseChipsWithPvc_2() end

---@param hash integer | string
---@return boolean
function NetworkCasinoCanUseGamblingType(hash) end

---@param p0 integer
---@param p1 integer
---@return boolean
function NetworkCasinoPurchaseChips(p0, p1) end

---@param p0 integer
---@param p1 integer
---@return boolean
function NetworkCasinoSellChips(p0, p1) end

---@param p0 any
---@param p1 any
function NetworkChangeTransitionSlots(p0, p1) end

---@param p0 integer
---@param p1 integer
---@param p2 boolean
---@return boolean
function NetworkCheckCommunicationPrivileges(p0, p1, p2) end

---@param friendDataIndex integer
---@return boolean, integer
function NetworkCheckDataManagerSucceededForHandle(friendDataIndex) end

---@param p0 integer
---@param p1 integer
---@param p2 boolean
---@return boolean
function NetworkCheckUserContentPrivileges(p0, p1, p2) end

---@param animDict string
---@param animName string
---@return boolean
function NetworkClanAnimation(animDict, animName) end

---@return boolean
function NetworkClanAnyDownloadMembershipPending() end

---@return boolean, integer
function NetworkClanDownloadMembership() end

---@return boolean, any
function NetworkClanDownloadMembershipPending() end

---@param txdName string
---@return boolean, any
function NetworkClanGetEmblemTxdName(txdName) end

---@return integer
function NetworkClanGetLocalMembershipsCount() end

---@param membershipIndex integer
---@return boolean, integer, integer
function NetworkClanGetMembership(membershipIndex) end

---@return integer, integer
function NetworkClanGetMembershipCount() end

---@param p1 integer
---@return boolean, integer
function NetworkClanGetMembershipDesc(p1) end

---@param membershipIndex integer
---@return boolean, integer
function NetworkClanGetMembershipValid(membershipIndex) end

---@param bufferSize integer
---@param formattedTag string
---@return integer
function NetworkClanGetUiFormattedTag(bufferSize, formattedTag) end

---@param p0 any
---@return boolean, any
function NetworkClanIsEmblemReady(p0) end

---@param bufferSize integer
---@return boolean, integer
function NetworkClanIsRockstarClan(bufferSize) end

---@param clanDesc integer
---@return boolean
function NetworkClanJoin(clanDesc) end

---@param bufferSize integer
---@return boolean, integer, integer
function NetworkClanPlayerGetDesc(bufferSize) end

---@return boolean, integer
function NetworkClanPlayerIsActive() end

---@param p0 any
function NetworkClanReleaseEmblem(p0) end

---@return boolean, integer
function NetworkClanRemoteMembershipsAreInCache() end

---@param p0 any
---@return boolean
function NetworkClanRequestEmblem(p0) end

---@return boolean
function NetworkClanServiceIsValid() end

---@param characterSlot integer
function NetworkClearCharacterWallet(characterSlot) end


function NetworkClearClockTimeOverride() end

---@return any
function NetworkClearFollowInvite() end


function NetworkClearFollowers() end


function NetworkClearFoundGamers() end


function NetworkClearGetGamerStatus() end


function NetworkClearGroupActivity() end


function NetworkClearPropertyId() end


function NetworkClearTransitionCreatorHandle() end


function NetworkClearVoiceChannel() end


function NetworkClearVoiceProximityOverride() end


function NetworkCloseTransitionMatchmaking() end

---@param entity integer
---@param toggle boolean
function NetworkConcealEntity(entity, toggle) end

---@param player integer
---@param toggle boolean
---@param bAllowDamagingWhileConcealed boolean
function NetworkConcealPlayer(player, toggle, bAllowDamagingWhileConcealed) end

---@param x number
---@param y number
---@param z number
---@param xRot number
---@param yRot number
---@param zRot number
---@param rotationOrder integer
---@param holdLastFrame boolean
---@param looped boolean
---@param phaseToStopScene number
---@param phaseToStartScene number
---@param animSpeed number
---@return integer
function NetworkCreateSynchronisedScene(x, y, z, xRot, yRot, zRot, rotationOrder, holdLastFrame, looped, phaseToStopScene, phaseToStartScene, animSpeed) end

---@param amount integer
---@param p1 string
---@param p2 string
---@param p3 boolean
---@param p4 boolean
---@param p5 boolean
function NetworkDeductCash(amount, p1, p2, p3, p4, p5) end

---@param characterSlot integer
---@param p1 boolean
---@param p2 boolean
function NetworkDeleteCharacter(characterSlot, p1, p2) end

---@return boolean
function NetworkDidFindGamersSucceed() end

---@return boolean
function NetworkDidGetGamerStatusSucceed() end

---@param player integer
---@param toggle boolean
function NetworkDisableInvincibleFlashing(player, toggle) end

---@param toggle boolean
function NetworkDisableLeaveRemotePedBehind(toggle) end

---@param netID integer
function NetworkDisableProximityMigration(netID) end

---@param p1 any
---@return integer, any
function NetworkDisplaynamesFromHandlesStart(p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return boolean
function NetworkDoTransitionQuickmatch(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return boolean
function NetworkDoTransitionQuickmatchAsync(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p5 any
---@return boolean, any
function NetworkDoTransitionQuickmatchWithGroup(p0, p1, p2, p3, p5) end

---@param p1 any
---@param p2 boolean
---@param players integer
---@param p4 boolean
---@return boolean, any
function NetworkDoTransitionToFreemode(p1, p2, players, p4) end

---@param p0 boolean
---@param maxPlayers integer
---@return boolean
function NetworkDoTransitionToGame(p0, maxPlayers) end

---@param players integer
---@param p3 boolean
---@param p4 boolean
---@param p5 boolean
---@return boolean, any, any
function NetworkDoTransitionToNewFreemode(players, p3, p4, p5) end

---@param p0 boolean
---@param maxPlayers integer
---@param p2 boolean
---@return boolean
function NetworkDoTransitionToNewGame(p0, maxPlayers, p2) end

---@param netId integer
---@return boolean
function NetworkDoesEntityExistWithNetworkId(netId) end

---@param netId integer
---@return boolean
function NetworkDoesNetworkIdExist(netId) end

---@param tunableContext string
---@param tunableName string
---@return boolean
function NetworkDoesTunableExist(tunableContext, tunableName) end

---@param tunableContext integer | string
---@param tunableName integer | string
---@return boolean
function NetworkDoesTunableExistHash(tunableContext, tunableName) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnBoss(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkEarnBossAgency(p0, p1, p2, p3) end

---@param p0 any
function NetworkEarnBountyHunterReward(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function NetworkEarnCasinoHeist(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkEarnCasinoHeistBonus(p0, p1, p2, p3, p4) end

---@param amount integer
---@param p1 any
function NetworkEarnCollectableCompletedCollection(amount, p1) end

---@param p0 any
function NetworkEarnFmbbWageBonus(p0) end

---@param p0 any
---@param p1 any
function NetworkEarnFromAiTargetKill(p0, p1) end

---@param p0 integer
---@param p1 string
---@return any
function NetworkEarnFromAmbientJob(p0, p1) end

---@param amount integer
---@param p1 any
function NetworkEarnFromArenaCareerProgression(amount, p1) end

---@param amount integer
---@param p1 any
function NetworkEarnFromArenaSkillLevelProgression(amount, p1) end

---@param amount integer
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkEarnFromArenaWar(amount, p1, p2, p3) end

---@param amount integer
function NetworkEarnFromArmourTruck(amount) end

---@param amount integer
function NetworkEarnFromAssassinateTargetKilled(amount) end

---@param amount integer
function NetworkEarnFromAssassinateTargetKilled_2(amount) end

---@param p0 any
---@param p1 any
function NetworkEarnFromAutoshopBusiness(p0, p1) end

---@param p0 any
function NetworkEarnFromAutoshopIncome(p0) end

---@param amount integer
function NetworkEarnFromBbEventBonus(amount) end

---@param amount integer
function NetworkEarnFromBbEventCargo(amount) end

---@param amount integer
---@param heistHash string
function NetworkEarnFromBendJob(amount, heistHash) end

---@param amount integer
---@param p1 string
function NetworkEarnFromBetting(amount, p1) end

---@param p0 any
---@param p1 any
function NetworkEarnFromBikeShopBusiness(p0, p1) end

---@param p0 any
function NetworkEarnFromBikerIncome(p0) end

---@param amount integer
---@param p3 any
---@return integer, any
function NetworkEarnFromBounty(amount, p3) end

---@param p0 any
function NetworkEarnFromBusinessBattle(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnFromBusinessHubSell(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkEarnFromBusinessHubSource(p0, p1, p2, p3) end

---@param amount integer
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkEarnFromBusinessProduct(amount, p1, p2, p3) end

---@param p0 any
function NetworkEarnFromCarclubMembership(p0) end

---@param amount integer
function NetworkEarnFromCashingOut(amount) end

---@param amount integer
---@param hash integer | string
function NetworkEarnFromCasinoAward(amount, hash) end

---@param amount integer
function NetworkEarnFromCasinoMissionParticipation(amount) end

---@param amount integer
function NetworkEarnFromCasinoMissionReward(amount) end

---@param amount integer
function NetworkEarnFromCasinoStoryMissionReward(amount) end

---@param p0 any
---@param p2 boolean
---@return any
function NetworkEarnFromChallengeWin(p0, p2) end

---@param p0 any
function NetworkEarnFromClubManagementParticipation(p0) end

---@param amount integer
function NetworkEarnFromCollectablesActionFigures(amount) end

---@param amount integer
---@param p1 any
function NetworkEarnFromCollectionItem(amount, p1) end

---@param amount integer
function NetworkEarnFromCompleteCollection(amount) end

---@param amount integer
---@param p1 any
function NetworkEarnFromContraband(amount, p1) end

---@param amount integer
function NetworkEarnFromCrateDrop(amount) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnFromCriminalMastermindBonus(p0, p1, p2) end

---@param amount integer
function NetworkEarnFromDailyObjectiveEvent(amount) end

---@param p0 integer
---@param p1 string
---@param p2 integer
function NetworkEarnFromDailyObjectives(p0, p1, p2) end

---@param amount integer
---@param p1 any
function NetworkEarnFromDarChallenge(amount, p1) end

---@param p0 any
function NetworkEarnFromDestroyingContraband(p0) end

---@param amount integer
---@param vehicleHash integer | string
function NetworkEarnFromDoomsdayFinaleBonus(amount, vehicleHash) end

---@param p0 any
function NetworkEarnFromFmbbBossWork(p0) end

---@param p0 any
function NetworkEarnFromFmbbPhonecallMission(p0) end

---@param amount integer
function NetworkEarnFromGangPickup(amount) end

---@param amount integer
---@param unk string
---@param p2 any
function NetworkEarnFromGangopsAwards(amount, unk, p2) end

---@param amount integer
---@param unk string
---@param actIndex integer
function NetworkEarnFromGangopsElite(amount, unk, actIndex) end

---@param amount integer
---@param unk string
function NetworkEarnFromGangopsJobsFinale(amount, unk) end

---@param amount integer
function NetworkEarnFromGangopsJobsPrepParticipation(amount) end

---@param amount integer
---@param unk string
function NetworkEarnFromGangopsJobsSetup(amount, unk) end

---@param amount integer
---@param p1 integer
function NetworkEarnFromGangopsWages(amount, p1) end

---@param amount integer
---@param p1 integer
function NetworkEarnFromGangopsWagesBonus(amount, p1) end

---@param p0 any
---@param amount integer
---@param p2 any
---@param p3 any
function NetworkEarnFromHackerTruckMission(p0, amount, p2, p3) end

---@param amount integer
function NetworkEarnFromHoldups(amount) end

---@param amount integer
---@param modelHash integer | string
function NetworkEarnFromImportExport(amount, modelHash) end

---@param amount integer
---@param p1 string
function NetworkEarnFromJob(amount, p1) end

---@param p0 any
---@return any, any
function NetworkEarnFromJobBonus(p0) end

---@param amount integer
---@param p1 string
function NetworkEarnFromJobX2(amount, p1) end

---@param amount integer
function NetworkEarnFromNotBadsport(amount) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
function NetworkEarnFromPersonalVehicle(p0, p1, p2, p3, p4, p5, p6, p7, p8) end

---@param amount integer
function NetworkEarnFromPickup(amount) end

---@param amount integer
---@param p1 string
function NetworkEarnFromPremiumJob(amount, p1) end

---@param amount integer
---@param propertyName integer | string
function NetworkEarnFromProperty(amount, propertyName) end

---@param amount integer
function NetworkEarnFromRcTimeTrial(amount) end

---@param amount integer
---@param p1 any
function NetworkEarnFromRdrBonus(amount, p1) end

---@param amount integer
function NetworkEarnFromRockstar(amount) end

---@param amount integer
---@param baseNameHash integer | string
function NetworkEarnFromSellBase(amount, baseNameHash) end

---@param amount integer
---@param bunkerHash integer | string
function NetworkEarnFromSellBunker(amount, bunkerHash) end

---@param amount integer
function NetworkEarnFromSellingVehicle(amount) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkEarnFromSightseeing(p0, p1, p2, p3) end

---@param amount integer
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkEarnFromSmuggling(amount, p1, p2, p3) end

---@param amount integer
function NetworkEarnFromSpinTheWheelCash(amount) end

---@param amount integer
---@param p1 integer
function NetworkEarnFromTargetRefund(amount, p1) end

---@param amount integer
function NetworkEarnFromTimeTrialWin(amount) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnFromTunerAward(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkEarnFromTunerFinale(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
function NetworkEarnFromUpgradeAutoshopLocation(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
function NetworkEarnFromVehicle(p0, p1, p2, p3, p4, p5, p6, p7) end

---@param p0 any
---@param p1 any
function NetworkEarnFromVehicleAutoshop(p0, p1) end

---@param p0 any
function NetworkEarnFromVehicleAutoshopBonus(p0) end

---@param amount integer
---@param p1 any
---@param p2 any
function NetworkEarnFromVehicleExport(amount, p1, p2) end

---@param amount integer
function NetworkEarnFromWagePayment(amount) end

---@param amount integer
function NetworkEarnFromWagePaymentBonus(amount) end


function NetworkEarnFromWarehouse() end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnGoon(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function NetworkEarnIslandHeist(p0, p1, p2, p3, p4, p5) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnJobBonusFirstTimeBonus(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkEarnJobBonusHeistAward(p0, p1, p2) end


function NetworkEndTutorialSession() end

---@param areaHandle integer
---@return boolean
function NetworkEntityAreaDoesExist(areaHandle) end

---@param areaHandle integer
---@return boolean
function NetworkEntityAreaIsOccupied(areaHandle) end

---@param heli integer
---@param isAudible boolean
---@param isInvisible boolean
---@param netScriptEntityId integer
function NetworkExplodeHeli(heli, isAudible, isInvisible, netScriptEntityId) end

---@param vehicle integer
---@param isAudible boolean
---@param isInvisible boolean
---@param p3 boolean
function NetworkExplodeVehicle(vehicle, isAudible, isInvisible, p3) end

---@param entity integer
---@param bNetwork boolean
function NetworkFadeInEntity(entity, bNetwork) end

---@param entity integer
---@param normal boolean
---@param slow boolean
function NetworkFadeOutEntity(entity, normal, slow) end

---@param p0 any
---@return boolean
function NetworkFindGamersInCrew(p0) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@return boolean
function NetworkFindMatchedGamers(p0, p1, p2, p3) end


function NetworkFinishBroadcastingData() end

---@param sceneId integer
function NetworkForceLocalUseOfSyncedSceneCamera(sceneId) end

---@return boolean, any
function NetworkGamerHasHeadset() end

---@return boolean
function NetworkGamertagFromHandlePending() end

---@return boolean, integer
function NetworkGamertagFromHandleStart() end

---@return boolean
function NetworkGamertagFromHandleSucceeded() end

---@param p0 boolean
---@return integer
function NetworkGetActivityPlayerNum(p0) end

---@return integer
function NetworkGetAgeGroup() end

---@param player integer
---@return number
function NetworkGetAverageLatencyForPlayer(player) end

---@param player integer
---@return number
function NetworkGetAverageLatencyForPlayer_2(player) end

---@param player integer
---@return number
function NetworkGetAveragePacketLossForPlayer(player) end

---@param p0 any
---@param p1 any
---@return boolean, any, any
function NetworkGetBackgroundLoadingRecipients(p0, p1) end

---@param contentHash integer | string
---@return integer
function NetworkGetContentModifierListId(contentHash) end

---@return boolean, any
function NetworkGetCurrentlySelectedGamerHandleFromInviteMenu() end

---@param p0 any
---@param p1 any
---@return boolean, integer
function NetworkGetDestroyerOfEntity(p0, p1) end

---@param netId integer
---@return integer, integer
function NetworkGetDestroyerOfNetworkId(netId) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return integer
function NetworkGetDisplaynamesFromHandles(p0, p1, p2) end

---@param netId integer
---@return integer
function NetworkGetEntityFromNetworkId(netId) end

---@param entity integer
---@return boolean
function NetworkGetEntityIsLocal(entity) end

---@param entity integer
---@return boolean
function NetworkGetEntityIsNetworked(entity) end

---@param player integer
---@return integer, integer
function NetworkGetEntityKillerOfPlayer(player) end

---@param entity integer
---@return integer
function NetworkGetEntityNetScriptId(entity) end

---@return integer
function NetworkGetEvcBalance() end

---@param p1 any
---@return boolean, any
function NetworkGetFoundGamer(p1) end

---@return integer
function NetworkGetFriendCount() end

---@param friendIndex integer
---@return string
function NetworkGetFriendName(friendIndex) end

---@param friendIndex integer
---@return string
function NetworkGetFriendNameFromIndex(friendIndex) end

---@return boolean
function NetworkGetGamerStatusFromQueue() end

---@param p1 any
---@return boolean, any
function NetworkGetGamerStatusResult(p1) end

---@return string, integer
function NetworkGetGamertagFromHandle() end

---@return integer, integer, integer
function NetworkGetGlobalMultiplayerClock() end

---@param scriptName string
---@param p1 integer
---@param p2 integer
---@return integer
function NetworkGetHostOfScript(scriptName, p1, p2) end

---@return integer
function NetworkGetHostOfThisScript() end

---@return integer
function NetworkGetInstanceIdOfThisScript() end

---@return boolean
function NetworkGetIsHighEarner() end

---@param entity integer
---@return vector3
function NetworkGetLastVelocityReceived(entity) end

---@param bufferSize integer
---@return integer
function NetworkGetLocalHandle(bufferSize) end

---@param netSceneId integer
---@return integer
function NetworkGetLocalSceneFromNetworkId(netSceneId) end

---@return integer
function NetworkGetMaxFriends() end

---@return integer
function NetworkGetMaxNumParticipants() end

---@param entity integer
---@return integer
function NetworkGetNetworkIdFromEntity(entity) end

---@return integer
function NetworkGetNumBodyTrackers() end

---@return integer
function NetworkGetNumConnectedPlayers() end

---@return integer
function NetworkGetNumFoundGamers() end

---@return integer
function NetworkGetNumParticipants() end

---@return integer
function NetworkGetNumPresenceInvites() end

---@param p1 any
---@param p2 any
---@return integer, any
function NetworkGetNumScriptParticipants(p1, p2) end

---@param player integer
---@return integer
function NetworkGetNumUnackedForPlayer(player) end

---@param player integer
---@return integer
function NetworkGetOldestResendCountForPlayer(player) end

---@param index integer
---@return integer
function NetworkGetParticipantIndex(index) end

---@param dataSize integer
---@return integer, any
function NetworkGetPlatformPartyMembers(dataSize) end

---@return integer
function NetworkGetPlatformPartyUnk() end

---@param player integer
---@return vector3
function NetworkGetPlayerCoords(player) end

---@return integer, integer
function NetworkGetPlayerFromGamerHandle() end

---@param player integer
---@return integer
function NetworkGetPlayerIndex(player) end

---@param ped integer
---@return integer
function NetworkGetPlayerIndexFromPed(ped) end

---@param player integer
---@return number
function NetworkGetPlayerLoudness(player) end

---@param player integer
---@return boolean
function NetworkGetPlayerOwnsWaypoint(player) end

---@param player integer
---@return integer
function NetworkGetPlayerTutorialSessionInstance(player) end

---@return any
function NetworkGetPositionHashOfThisScript() end

---@param p0 any
---@return string
function NetworkGetPresenceInviteContentId(p0) end

---@param p0 any
---@return boolean
function NetworkGetPresenceInviteFromAdmin(p0) end

---@param p0 any
---@return boolean, any
function NetworkGetPresenceInviteHandle(p0) end

---@param p0 any
---@return any
function NetworkGetPresenceInviteId(p0) end

---@param inviteIndex integer
---@return string
function NetworkGetPresenceInviteInviter(inviteIndex) end

---@param p0 any
---@return boolean
function NetworkGetPresenceInviteIsTournament(p0) end

---@param p0 any
---@return any
function NetworkGetPresenceInvitePlaylistCurrent(p0) end

---@param p0 any
---@return any
function NetworkGetPresenceInvitePlaylistLength(p0) end

---@param inviteIndex integer
---@return integer
function NetworkGetPresenceInviteSessionId(inviteIndex) end


function NetworkGetPrimaryClanDataCancel() end

---@return any
function NetworkGetPrimaryClanDataClear() end

---@return boolean, any, any
function NetworkGetPrimaryClanDataNew() end

---@return any
function NetworkGetPrimaryClanDataPending() end

---@param p1 any
---@return boolean, any
function NetworkGetPrimaryClanDataStart(p1) end

---@return any
function NetworkGetPrimaryClanDataSuccess() end

---@return integer
function NetworkGetPvcBalance() end

---@return integer
function NetworkGetPvcTransferBalance() end

---@return integer
function NetworkGetRandomInt() end

---@param rangeStart integer
---@param rangeEnd integer
---@return integer
function NetworkGetRandomIntRanged(rangeStart, rangeEnd) end

---@return integer
function NetworkGetRemainingTransferBalance() end

---@param randomInt integer
---@return vector3, number
function NetworkGetRespawnResult(randomInt) end

---@param p0 any
---@return any
function NetworkGetRespawnResultFlags(p0) end

---@return boolean
function NetworkGetRosPrivilege_24() end

---@return boolean
function NetworkGetRosPrivilege_25() end

---@return boolean
function NetworkGetRosPrivilege_9() end

---@return integer
function NetworkGetScriptStatus() end

---@return string
function NetworkGetStringBankBalance() end

---@return string
function NetworkGetStringBankWalletBalance() end

---@param characterSlot integer
---@return string
function NetworkGetStringWalletBalance(characterSlot) end

---@return number
function NetworkGetTalkerProximity() end

---@return integer
function NetworkGetTargetingMode() end

---@return boolean
function NetworkGetThisScriptIsNetworkScript() end

---@return integer
function NetworkGetTimeoutTime() end

---@return integer
function NetworkGetTotalNumPlayers() end

---@return boolean, integer
function NetworkGetTransitionHost() end

---@param dataCount integer
---@return integer, any
function NetworkGetTransitionMembers(dataCount) end

---@return integer
function NetworkGetTunableCloudCrc() end

---@param player integer
---@return integer
function NetworkGetUnreliableResendCountForPlayer(player) end

---@return integer
function NetworkGetVcBalance() end

---@return integer
function NetworkGetVcBankBalance() end

---@param amount integer
---@return boolean
function NetworkGetVcBankBalanceIsNotLessThan(amount) end

---@param amount integer
---@param characterSlot integer
---@return boolean
function NetworkGetVcBankWalletBalanceIsNotLessThan(amount, characterSlot) end

---@param characterSlot integer
---@return integer
function NetworkGetVcWalletBalance(characterSlot) end

---@param amount integer
---@param characterSlot integer
---@return boolean
function NetworkGetVcWalletBalanceIsNotLessThan(amount, characterSlot) end

---@param amount integer
---@return integer
function NetworkGivePlayerJobshareCash(amount) end

---@param friendIndex integer
---@param bufferSize integer
---@return integer
function NetworkHandleFromFriend(friendIndex, bufferSize) end

---@param memberId string
---@param bufferSize integer
---@return integer
function NetworkHandleFromMemberId(memberId, bufferSize) end

---@param player integer
---@param bufferSize integer
---@return integer
function NetworkHandleFromPlayer(player, bufferSize) end

---@param userId string
---@param bufferSize integer
---@return integer
function NetworkHandleFromUserId(userId, bufferSize) end

---@return boolean
function NetworkHasAgeRestrictedProfile() end

---@param player integer
---@return boolean
function NetworkHasCachedPlayerHeadBlendData(player) end

---@param doorHash integer | string
---@return boolean
function NetworkHasControlOfDoor(doorHash) end

---@param entity integer
---@return boolean
function NetworkHasControlOfEntity(entity) end

---@param netId integer
---@return boolean
function NetworkHasControlOfNetworkId(netId) end

---@param pickup integer
---@return boolean
function NetworkHasControlOfPickup(pickup) end

---@param entity integer
---@return boolean
function NetworkHasEntityBeenRegisteredWithThisThread(entity) end

---@return boolean
function NetworkHasFollowInvite() end

---@return boolean
function NetworkHasGameBeenAltered() end

---@return boolean
function NetworkHasHeadset() end

---@return boolean, integer
function NetworkHasInviteBeenAcked() end

---@return boolean, any
function NetworkHasInvitedGamer() end

---@return boolean, any
function NetworkHasInvitedGamerToTransition() end

---@return boolean
function NetworkHasPendingInvite() end

---@param player integer
---@return boolean
function NetworkHasPlayerStartedTransition(player) end

---@return boolean
function NetworkHasReceivedHostBroadcastData() end

---@param index integer
---@return boolean
function NetworkHasRosPrivilege(index) end

---@param privilege integer
---@return boolean, integer, vector3
function NetworkHasRosPrivilegeEndDate(privilege) end

---@return boolean
function NetworkHasSocialClubAccount() end

---@return boolean
function NetworkHasSocialNetworkingSharingPriv() end

---@return boolean, integer
function NetworkHasTransitionInviteBeenAcked() end

---@return boolean
function NetworkHasValidRosCredentials() end

---@return boolean, any
function NetworkHasViewGamerUserContentResult() end

---@return integer, integer
function NetworkHashFromGamerHandle() end

---@param player integer
---@return integer
function NetworkHashFromPlayerHandle(player) end

---@param p0 integer
---@param player integer
---@return boolean
function NetworkHaveCommunicationPrivileges(p0, player) end

---@return boolean
function NetworkHaveOnlinePrivilege_2() end

---@return boolean
function NetworkHaveOnlinePrivileges() end

---@return boolean
function NetworkHaveRosBannedPriv() end

---@return boolean
function NetworkHaveRosCreateTicketPriv() end

---@return boolean
function NetworkHaveRosLeaderboardWritePriv() end

---@return boolean
function NetworkHaveRosMultiplayerPriv() end

---@return boolean
function NetworkHaveRosSocialClubPriv() end

---@param p0 integer
---@return boolean
function NetworkHaveUserContentPrivileges(p0) end

---@param p0 integer
---@param p1 integer
---@param p2 integer
---@param p3 integer
---@param p4 any
---@param p5 boolean
---@param p6 boolean
---@param p7 integer
---@param p8 any
---@param p9 integer
---@return boolean
function NetworkHostTransition(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param wallet integer
---@param bank integer
function NetworkInitializeCash(wallet, bank) end

---@param p1 any
---@return boolean, any, any, any
function NetworkInviteGamers(p1) end

---@param p1 any
---@return boolean, any
function NetworkInviteGamersToTransition(p1) end

---@return boolean
function NetworkIsActivitySession() end

---@return boolean
function NetworkIsActivitySpectator() end

---@return boolean, integer
function NetworkIsActivitySpectatorFromHandle() end

---@return any
function NetworkIsAddingFriend() end

---@return boolean
function NetworkIsCableConnected() end

---@return boolean, integer
function NetworkIsChattingInPlatformParty() end

---@return boolean
function NetworkIsClockTimeOverridden() end

---@return boolean
function NetworkIsCloudAvailable() end

---@return boolean
function NetworkIsCloudBackgroundScriptRequestPending() end

---@param player integer
---@return boolean
function NetworkIsConnectionEndpointRelayServer(player) end

---@param doorHash integer | string
---@return boolean
function NetworkIsDoorNetworked(doorHash) end

---@param entity integer
---@return boolean
function NetworkIsEntityConcealed(entity) end

---@param entity integer
---@return boolean
function NetworkIsEntityFading(entity) end

---@return boolean
function NetworkIsFindingGamers() end

---@return boolean, integer
function NetworkIsFriend() end

---@return boolean, integer
function NetworkIsFriendHandleOnline() end

---@param friendName string
---@return boolean
function NetworkIsFriendInMultiplayer(friendName) end

---@param friendName string
---@return boolean
function NetworkIsFriendInSameTitle(friendName) end

---@param friendIndex integer
---@return boolean
function NetworkIsFriendIndexOnline(friendIndex) end

---@param name string
---@return boolean
function NetworkIsFriendOnline(name) end

---@return boolean
function NetworkIsGameInProgress() end

---@return boolean, any
function NetworkIsGamerBlockedByMe() end

---@return boolean, integer
function NetworkIsGamerInMySession() end

---@return boolean, integer
function NetworkIsGamerMutedByMe() end

---@return boolean, integer
function NetworkIsGamerTalking() end

---@return boolean
function NetworkIsGettingGamerStatus() end

---@param bufferSize integer
---@return boolean, integer
function NetworkIsHandleValid(bufferSize) end

---@return boolean
function NetworkIsHost() end

---@return boolean
function NetworkIsHostOfThisScript() end

---@return boolean
function NetworkIsInMpCutscene() end

---@return boolean
function NetworkIsInParty() end

---@return boolean
function NetworkIsInPlatformParty() end

---@return boolean
function NetworkIsInPlatformPartyChat() end

---@return boolean
function NetworkIsInSession() end

---@return boolean
function NetworkIsInSpectatorMode() end

---@return boolean
function NetworkIsInTransition() end

---@return boolean
function NetworkIsInTutorialSession() end

---@return boolean, integer
function NetworkIsInactiveProfile() end

---@return boolean
function NetworkIsLocalPlayerInvincible() end

---@return boolean
function NetworkIsLocalTalking() end

---@return boolean
function NetworkIsMultiplayerDisabled() end

---@param netId integer
---@return boolean
function NetworkIsNetworkIdAClone(netId) end

---@return boolean
function NetworkIsOfflineInvitePending() end

---@param p0 integer
---@return boolean
function NetworkIsParticipantActive(p0) end

---@return boolean, integer
function NetworkIsPartyMember() end

---@param p0 any
---@return any
function NetworkIsPendingFriend(p0) end

---@param player integer
---@return boolean
function NetworkIsPlayerAParticipant(player) end

---@param player1 integer
---@param script string
---@param player2 integer
---@return boolean
function NetworkIsPlayerAParticipantOnScript(player1, script, player2) end

---@param player integer
---@return boolean
function NetworkIsPlayerActive(player) end

---@param player integer
---@return boolean
function NetworkIsPlayerBlockedByMe(player) end

---@param player integer
---@return boolean
function NetworkIsPlayerConcealed(player) end

---@param player integer
---@return boolean
function NetworkIsPlayerConnected(player) end

---@param player integer
---@param index integer
---@return boolean
function NetworkIsPlayerEqualToIndex(player, index) end

---@param player integer
---@return boolean
function NetworkIsPlayerFading(player) end

---@param player integer
---@return boolean
function NetworkIsPlayerInMpCutscene(player) end

---@param player integer
---@return boolean
function NetworkIsPlayerMutedByMe(player) end

---@param player integer
---@return boolean
function NetworkIsPlayerTalking(player) end

---@return boolean
function NetworkIsPsnAvailable() end

---@param scriptName string
---@param player integer
---@param p2 boolean
---@param p3 any
---@return boolean
function NetworkIsScriptActive(scriptName, player, p2, p3) end

---@param scriptHash integer | string
---@param p1 integer
---@param p2 boolean
---@param p3 integer
---@return boolean
function NetworkIsScriptActiveByHash(scriptHash, p1, p2, p3) end

---@return boolean
function NetworkIsSessionActive() end

---@return boolean
function NetworkIsSessionBusy() end

---@return boolean
function NetworkIsSessionStarted() end

---@return boolean
function NetworkIsSignedIn() end

---@return boolean
function NetworkIsSignedOnline() end

---@return boolean
function NetworkIsTextChatActive() end

---@param p0 any
---@param p1 boolean
---@param p2 any
---@return boolean
function NetworkIsThisScriptMarked(p0, p1, p2) end

---@return boolean
function NetworkIsTransitionBusy() end

---@return boolean
function NetworkIsTransitionClosedCrew() end

---@return boolean
function NetworkIsTransitionClosedFriends() end

---@return boolean
function NetworkIsTransitionHost() end

---@return boolean, integer
function NetworkIsTransitionHostFromHandle() end

---@return boolean
function NetworkIsTransitionMatchmaking() end

---@return boolean
function NetworkIsTransitionOpenToMatchmaking() end

---@return boolean
function NetworkIsTransitionPrivate() end

---@return boolean
function NetworkIsTransitionSolo() end

---@return boolean
function NetworkIsTransitionStarted() end

---@return boolean
function NetworkIsTransitionToGame() end

---@return boolean
function NetworkIsTransitionVisibilityLocked() end

---@return boolean
function NetworkIsTunableCloudRequestPending() end

---@return boolean
function NetworkIsTutorialSessionChangePending() end

---@return any
function NetworkJoinGroupActivity() end

---@return boolean
function NetworkJoinPreviouslyFailedSession() end

---@return boolean
function NetworkJoinPreviouslyFailedTransition() end

---@param player integer
---@return boolean
function NetworkJoinTransition(player) end

---@return boolean
function NetworkLaunchTransition() end

---@return boolean
function NetworkLeaveTransition() end

---@param characterSlot integer
function NetworkManualDeleteCharacter(characterSlot) end

---@return boolean, any
function NetworkMarkTransitionGamerAsFullyJoined() end

---@return string, integer
function NetworkMemberIdFromGamerHandle() end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
---@return boolean
function NetworkMoneyCanBet(amount, p1, p2) end


function NetworkOpenTransitionMatchmaking() end

---@param player integer
---@param toggle boolean
function NetworkOverrideChatRestrictions(player, toggle) end

---@param ms integer
function NetworkOverrideClockMillisecondsPerGameMinute(ms) end

---@param hours integer
---@param minutes integer
---@param seconds integer
function NetworkOverrideClockTime(hours, minutes, seconds) end

---@param entity integer
---@param x number
---@param y number
---@param z number
---@param heading number
function NetworkOverrideCoordsAndHeading(entity, x, y, z, heading) end

---@param player integer
---@param toggle boolean
function NetworkOverrideReceiveRestrictions(player, toggle) end

---@param toggle boolean
function NetworkOverrideReceiveRestrictionsAll(toggle) end

---@param player integer
---@param toggle boolean
function NetworkOverrideSendRestrictions(player, toggle) end

---@param toggle boolean
function NetworkOverrideSendRestrictionsAll(toggle) end

---@param team integer
---@param toggle boolean
function NetworkOverrideTeamRestrictions(team, toggle) end

---@param p0 boolean
function NetworkOverrideTransitionChat(p0) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkPayEmployeeWage(p0, p1, p2) end

---@param amount integer
---@param matchId string
---@param p2 boolean
---@param p3 boolean
function NetworkPayMatchEntryFee(amount, matchId, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkPayUtilityBill(amount, p1, p2) end

---@param ped integer
function NetworkPedForceGameStateUpdate(ped) end

---@return integer
function NetworkPlayerGetCheaterReason() end

---@param player integer
---@return string
function NetworkPlayerGetName(player) end

---@param player integer
---@return string, integer
function NetworkPlayerGetUserid(player) end

---@param player integer
---@return boolean
function NetworkPlayerHasHeadset(player) end

---@return integer
function NetworkPlayerIdToInt() end

---@param player integer
---@return boolean
function NetworkPlayerIndexIsCheater(player) end

---@return boolean
function NetworkPlayerIsBadsport() end

---@return boolean
function NetworkPlayerIsCheater() end

---@param player integer
---@return boolean
function NetworkPlayerIsRockstarDev(player) end

---@return any, any
function NetworkQueryRespawnResults() end

---@return boolean, any
function NetworkQueueGamerForStatus() end


function NetworkQuitMpToDesktop() end

---@param value integer
---@return integer
function NetworkReceivePlayerJobshareCash(value) end

---@param index integer
---@param context string
---@param reason string
---@param unk boolean
function NetworkRefundCash(index, context, reason, unk) end

---@param entity integer
function NetworkRegisterEntityAsNetworked(entity) end

---@param numVars integer
---@return integer
function NetworkRegisterHostBroadcastVariables(numVars) end

---@param numVars integer
---@return integer
function NetworkRegisterPlayerBroadcastVariables(numVars) end

---@param contextHash integer | string
---@param nameHash integer | string
---@return boolean, boolean
function NetworkRegisterTunableBoolHash(contextHash, nameHash) end

---@param contextHash integer | string
---@param nameHash integer | string
---@return boolean, number
function NetworkRegisterTunableFloatHash(contextHash, nameHash) end

---@param contextHash integer | string
---@param nameHash integer | string
---@return boolean, integer
function NetworkRegisterTunableIntHash(contextHash, nameHash) end


function NetworkRemoveAllTransitionInvite() end

---@param p0 any
---@return boolean
function NetworkRemoveEntityArea(p0) end

---@param p0 any
---@return boolean
function NetworkRemovePresenceInvite(p0) end

---@return any
function NetworkRemoveTransitionInvite() end


function NetworkReportMyself() end

---@return boolean
function NetworkRequestCloudBackgroundScripts() end


function NetworkRequestCloudTunables() end

---@param doorID integer
---@return boolean
function NetworkRequestControlOfDoor(doorID) end

---@param entity integer
---@return boolean
function NetworkRequestControlOfEntity(entity) end

---@param netId integer
---@return boolean
function NetworkRequestControlOfNetworkId(netId) end


function NetworkResetBodyTracker() end

---@param player integer
---@param x number
---@param y number
---@param z number
---@param p4 boolean
---@param p5 boolean
function NetworkRespawnCoords(player, x, y, z, p4, p5) end

---@param x number
---@param y number
---@param z number
---@param heading number
---@param nInvincibilityTime integer
---@param bLeaveDeadPed boolean
function NetworkResurrectLocalPlayer(x, y, z, heading, nInvincibilityTime, bLeaveDeadPed) end

---@param earnedMoney integer
function NetworkRivalDeliveryCompleted(earnedMoney) end

---@param seed integer
function NetworkSeedRandomNumberGenerator(seed) end

---@param p2 any
---@param p3 any
---@return boolean, integer, any
function NetworkSendInviteViaPresence(p2, p3) end

---@param p2 any
---@param p3 any
---@return boolean, any, any
function NetworkSendPresenceTransitionInvite(p2, p3) end

---@param message string
---@return boolean, integer
function NetworkSendTextMessage(message) end

---@param p1 string
---@param p2 integer
---@param p3 integer
---@param p4 boolean
---@return boolean, integer
function NetworkSendTransitionGamerInstruction(p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return boolean
function NetworkSessionActivityQuickmatch(p0, p1, p2, p3) end

---@param groupId integer
function NetworkSessionAddActiveMatchmakingGroup(groupId) end

---@param toggle boolean
function NetworkSessionBlockJoinRequests(toggle) end


function NetworkSessionCancelInvite() end

---@param p0 integer
---@param p1 boolean
function NetworkSessionChangeSlots(p0, p1) end

---@param p0 integer
---@param p1 integer
---@param p2 integer
---@param maxPlayers integer
---@param p4 boolean
---@return boolean
function NetworkSessionCrewMatchmaking(p0, p1, p2, maxPlayers, p4) end

---@param p0 boolean
---@param p1 boolean
---@return boolean
function NetworkSessionEnd(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param maxPlayers integer
---@param p4 any
---@param p5 any
---@return any
function NetworkSessionEnter(p0, p1, p2, maxPlayers, p4, p5) end


function NetworkSessionForceCancelInvite() end

---@param p0 integer
---@param p1 integer
---@param maxPlayers integer
---@param p3 boolean
---@return boolean
function NetworkSessionFriendMatchmaking(p0, p1, maxPlayers, p3) end

---@return integer
function NetworkSessionGetInviter() end

---@param player integer
---@return boolean
function NetworkSessionGetKickVote(player) end

---@param p0 integer
---@return integer
function NetworkSessionGetMatchmakingGroupFree(p0) end

---@return integer
function NetworkSessionGetPrivateSlots() end

---@param p0 integer
---@param maxPlayers integer
---@param p2 boolean
---@return boolean
function NetworkSessionHost(p0, maxPlayers, p2) end

---@param p0 integer
---@param maxPlayers integer
---@return boolean
function NetworkSessionHostClosed(p0, maxPlayers) end

---@param p0 integer
---@param maxPlayers integer
---@return boolean
function NetworkSessionHostFriendsOnly(p0, maxPlayers) end

---@param p0 integer
function NetworkSessionHostSinglePlayer(p0) end

---@return boolean
function NetworkSessionIsClosedCrew() end

---@return boolean
function NetworkSessionIsClosedFriends() end

---@return boolean
function NetworkSessionIsInVoiceSession() end

---@return boolean
function NetworkSessionIsPrivate() end

---@return boolean
function NetworkSessionIsSolo() end

---@return boolean
function NetworkSessionIsVisible() end

---@return boolean
function NetworkSessionIsVoiceSessionBusy() end


function NetworkSessionJoinInvite() end

---@param player integer
function NetworkSessionKickPlayer(player) end


function NetworkSessionLeaveSinglePlayer() end

---@param toggle boolean
function NetworkSessionMarkVisible(toggle) end

---@param matchmakingGroup integer
function NetworkSessionSetMatchmakingGroup(matchmakingGroup) end

---@param playerType integer
---@param playerCount integer
function NetworkSessionSetMatchmakingGroupMax(playerType, playerCount) end

---@param p0 any
function NetworkSessionSetMatchmakingMentalState(p0) end

---@param p0 boolean
function NetworkSessionSetMatchmakingPropertyId(p0) end

---@param p0 boolean
function NetworkSessionValidateJoin(p0) end

---@return any
function NetworkSessionVoiceConnectToPlayer() end


function NetworkSessionVoiceHost() end


function NetworkSessionVoiceLeave() end

---@param p0 boolean
---@param p1 integer
function NetworkSessionVoiceRespondToRequest(p0, p1) end

---@param timeout integer
function NetworkSessionVoiceSetTimeout(timeout) end

---@return boolean
function NetworkSessionWasInvited() end

---@param playerCount integer
function NetworkSetActivityPlayerMax(playerCount) end

---@param toggle boolean
function NetworkSetActivitySpectator(toggle) end

---@param maxSpectators integer
function NetworkSetActivitySpectatorMax(maxSpectators) end

---@param toggle boolean
---@param player integer
function NetworkSetChoiceMigrateOptions(toggle, player) end

---@return boolean, any
function NetworkSetCurrentDataManagerHandle() end

---@param missionId string
function NetworkSetCurrentMissionId(missionId) end

---@param mpSettingSpawn integer | string
function NetworkSetCurrentSpawnSetting(mpSettingSpawn) end

---@return boolean, any
function NetworkSetCurrentlySelectedGamerHandleFromInviteMenu() end

---@param entity integer
---@param toggle boolean
function NetworkSetEntityCanBlend(entity, toggle) end

---@param entity integer
---@param p1 boolean
function NetworkSetEntityGhostedWithOwner(entity, p1) end

---@param entity integer
---@param toggle boolean
function NetworkSetEntityInvisibleToNetwork(entity, toggle) end

---@param toggle boolean
function NetworkSetFriendlyFireOption(toggle) end

---@return integer
function NetworkSetGamerInvitedToTransition() end

---@param toggle boolean
function NetworkSetInFreeCamMode(toggle) end

---@param p0 boolean
---@param p1 boolean
function NetworkSetInMpCutscene(p0, p1) end

---@param toggle boolean
---@param playerPed integer
function NetworkSetInSpectatorMode(toggle, playerPed) end

---@param toggle boolean
---@param playerPed integer
---@param p2 boolean
function NetworkSetInSpectatorModeExtended(toggle, playerPed, p2) end

---@return integer
function NetworkSetInviteOnCallForInviteMenu() end

---@param time integer
function NetworkSetLocalPlayerInvincibleTime(time) end

---@param toggle boolean
function NetworkSetLocalPlayerSyncLookAt(toggle) end


function NetworkSetMissionFinished() end

---@param toggle boolean
function NetworkSetNoSpectatorChat(toggle) end

---@param object integer
---@param enabled boolean
function NetworkSetObjectForceStaticBlend(object, enabled) end

---@param toggle boolean
function NetworkSetOverrideSpectatorMode(toggle) end

---@param toggle boolean
function NetworkSetPlayerIsPassive(toggle) end

---@param id integer
function NetworkSetPropertyId(id) end

---@param p0 integer
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSetRichPresence(p0, p1, p2, p3) end

---@param p0 integer
---@param textLabel string
function NetworkSetRichPresenceString(p0, textLabel) end


function NetworkSetScriptIsSafeForNetworkGame() end

---@param toggle boolean
function NetworkSetScriptReadyForEvents(toggle) end

---@param value number
function NetworkSetTalkerProximity(value) end

---@param toggle boolean
function NetworkSetTeamOnlyChat(toggle) end

---@param maxNumMissionParticipants integer
---@param p1 boolean
---@param instanceId integer
function NetworkSetThisScriptIsNetworkScript(maxNumMissionParticipants, p1, instanceId) end

---@param p0 any
function NetworkSetTransitionActivityId(p0) end

---@return any
function NetworkSetTransitionCreatorHandle() end

---@param p0 boolean
---@param p1 boolean
function NetworkSetTransitionVisibilityLock(p0, p1) end

---@param toggle boolean
function NetworkSetVehicleTestDrive(toggle) end

---@param vehicle integer
---@param toggle boolean
function NetworkSetVehicleWheelsDestructible(vehicle, toggle) end

---@param toggle boolean
function NetworkSetVoiceActive(toggle) end

---@param channel integer
function NetworkSetVoiceChannel(channel) end

---@return boolean
function NetworkShouldShowConnectivityTroubleshooting() end

---@return integer
function NetworkShowProfileUi() end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentAmmoDrop(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentArcadeGame(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentArcadeGeneric(p0, p1, p2, p3, p4) end

---@param amount integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentArenaJoinSpectator(amount, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentArenaPremium(amount, p1, p2) end

---@param amount integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentArenaSpectatorBox(amount, p1, p2, p3) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentArrestBail(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentAutoshopModifications(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentAutoshopPropertyUtilityFee(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentBaService(p0, p1, p2, p3, p4) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBallisticEquipment(amount, p1, p2) end

---@param p0 integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBankInterest(p0, p1, p2) end

---@param p0 any
function NetworkSpentBeachPartyGeneric(p0) end

---@param amount integer
---@param p1 integer
---@param matchId string
---@param p3 boolean
---@param p4 boolean
function NetworkSpentBetting(amount, p1, matchId, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBikeShopModify(p0, p1, p2, p3) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBoatPickup(p0, p1, p2) end

---@return boolean
function NetworkSpentBoss() end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBounty(p0, p1, p2) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBountyHunterMission(amount, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBullShark(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBusiness(p0, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
---@param p3 string
function NetworkSpentBuyArena(amount, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBuyAutoshop(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBuyBase(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBuyBunker(p0, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
---@return any
function NetworkSpentBuyCasino(amount, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBuyOfftheradar(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBuyPassiveMode(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentBuyRevealPlayers(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBuyTiltrotor(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentBuyTruck(p0, p1, p2, p3) end

---@param p0 any
---@param p2 boolean
---@param p3 boolean
---@return any
function NetworkSpentBuyWantedlevel(p0, p2, p3) end

---@param p0 any
---@param p2 boolean
---@param p3 boolean
---@return any
function NetworkSpentCallPlayer(p0, p2, p3) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
---@param p3 any
function NetworkSpentCarclub(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentCarclubMembership(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentCarclubTakeover(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function NetworkSpentCargoSourcing(p0, p1, p2, p3, p4, p5) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 boolean
---@param p4 boolean
function NetworkSpentCarwash(p0, p1, p2, p3, p4) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentCashDrop(amount, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
function NetworkSpentCasinoClubGeneric(p0, p1, p2, p3, p4, p5, p6, p7, p8) end

---@param amount integer
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentCasinoGeneric(amount, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
---@param p10 any
function NetworkSpentCasinoHeist(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentCasinoHeistSkipMission(p0, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
---@param p3 integer
function NetworkSpentCasinoMembership(amount, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentCinema(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentEmployAssassins(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 boolean
function NetworkSpentFromBank(p0, p1, p2, p3) end

---@param bank integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentFromRockstar(bank, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentGangopsCannon(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentGangopsStartMission(p0, p1, p2, p3) end

---@param type integer
---@param amount integer
---@param p2 boolean
---@param p3 boolean
function NetworkSpentGangopsStartStrand(type, amount, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentGangopsTripSkip(amount, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentGunrunningContactService(p0, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentHangarStaffCharges(amount, p1, p2) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentHangarUtilityCharges(amount, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentHeliPickup(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentHireMercenary(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentHireMugger(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentHoldups(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentImAbility(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkSpentImportExportRepair(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 any
---@param p3 boolean
function NetworkSpentInStripclub(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentIslandHeist(p0, p1, p2, p3) end

---@param amount integer
---@param matchId string
---@param p2 boolean
---@param p3 boolean
function NetworkSpentJobSkip(amount, matchId, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentJukebox(p0, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentMakeItRain(amount, p1, p2) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentMoveYacht(amount, p1, p2) end

---@param amount integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentNightclubBarDrink(amount, p1, p2, p3) end

---@param player integer
---@param amount integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentNightclubEntryFee(player, amount, p1, p2, p3) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentNoCops(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentOrderBodyguardVehicle(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentOrderWarehouseVehicle(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentPaServiceDancer(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentPaServiceHeliPickup(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkSpentPayBoss(p0, p1, p2) end

---@param p0 integer
---@param p1 integer
---@param amount integer
function NetworkSpentPayGoon(p0, p1, amount) end

---@param amount integer
---@param vehicleModel integer | string
---@param notBankrupt boolean
---@param hasTheMoney boolean
---@return integer
function NetworkSpentPayVehicleInsurancePremium(amount, vehicleModel, notBankrupt, hasTheMoney) end

---@param p0 integer
---@param p1 integer
---@param p2 boolean
---@param p3 boolean
function NetworkSpentPlayerHealthcare(p0, p1, p2, p3) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentProstitutes(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentPurchaseHangar(p0, p1, p2, p3) end

---@param amount integer
---@param data any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentPurchaseWarehouse(amount, data, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentRdrhatchetBonus(amount, p1, p2) end

---@param amount integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentRehireDj(amount, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkSpentRenameOrganization(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentRequestHeist(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentRequestJob(p0, p1, p2) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentRobbedByMugger(amount, p1, p2) end

---@param p0 boolean
function NetworkSpentSalesDisplay(p0) end

---@param amount integer
---@param p1 any
---@param p2 boolean
---@param p3 boolean
function NetworkSpentSpinTheWheelPayment(amount, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function NetworkSpentSubmarine(p0, p1, p2, p3, p4, p5) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
function NetworkSpentTaxi(amount, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function NetworkSpentTelescope(p0, p1, p2) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
---@param p3 string
function NetworkSpentUpgradeArena(amount, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeAutoshop(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeBase(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeBunker(p0, p1, p2, p3) end

---@param amount integer
---@param p1 boolean
---@param p2 boolean
---@return any
function NetworkSpentUpgradeCasino(amount, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeHangar(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeSub(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeTiltrotor(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function NetworkSpentUpgradeTruck(p0, p1, p2, p3) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
function NetworkSpentVehicleExportMods(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function NetworkSpentVehicleRequested(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
function NetworkSpentVipUtilityCharges(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param amount integer
function NetworkSpentWager(p0, p1, amount) end

---@param player integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@param p5 number
---@param p6 number
---@param p7 number
---@param flags integer
---@return boolean
function NetworkStartRespawnSearchForPlayer(player, x, y, z, radius, p5, p6, p7, flags) end

---@param player integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param p8 number
---@param p9 number
---@param p10 number
---@param flags integer
---@return boolean
function NetworkStartRespawnSearchInAngledAreaForPlayer(player, x1, y1, z1, x2, y2, z2, width, p8, p9, p10, flags) end


function NetworkStartSoloTutorialSession() end

---@param netScene integer
function NetworkStartSynchronisedScene(netScene) end

---@param netHandle any
---@return integer
function NetworkStartUserContentPermissionsCheck(netHandle) end


function NetworkStopLoadScene() end

---@param netScene integer
function NetworkStopSynchronisedScene(netScene) end

---@param toggle boolean
function NetworkSuppressInvite(toggle) end

---@param hash integer | string
---@param p1 integer
---@param p2 integer
---@param state integer
---@param p4 integer
function NetworkTransitionTrack(hash, p1, p2, state, p4) end

---@param tunableContext integer | string
---@param tunableName integer | string
---@param defaultValue boolean
---@return boolean
function NetworkTryAccessTunableBoolHash(tunableContext, tunableName, defaultValue) end

---@param p0 any
---@param p1 any
function NetworkUgcNav(p0, p1) end

---@param entity integer
function NetworkUnregisterNetworkedEntity(entity) end

---@return boolean
function NetworkUpdateLoadScene() end


function NetworkUpdatePlayerScars() end

---@param netID integer
---@param toggle boolean
function NetworkUseHighPrecisionBlending(netID, toggle) end

---@param vehicle integer
---@param toggle boolean
function NetworkUseHighPrecisionVehicleBlending(vehicle, toggle) end

---@param entity integer
function NetworkUseLogarithmicBlendingThisFrame(entity) end

---@param posX number
---@param posY number
---@param posZ number
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param radius number
---@param p7 integer
---@return boolean
function NewLoadSceneStart(posX, posY, posZ, offsetX, offsetY, offsetZ, radius, p7) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param p4 any
---@return boolean
function NewLoadSceneStartSphere(x, y, z, radius, p4) end


function NewLoadSceneStop() end

---@param fontBitField integer
function NextOnscreenKeyboardResultWillDisplayUsingTheseFonts(fontBitField) end

---@param object integer
---@return integer
function ObjToNet(object) end


function OnEnterMp() end


function OnEnterSp() end

---@param enable boolean
function OnesyncEnableRemoteAttachmentSanitization(enable) end

---@param vehicle integer
function OpenBombBayDoors(vehicle) end

---@param p0 string
---@param p1 string
function OpenCommerceStore(p0, p1) end


function OpenOnlinePoliciesMenu() end

---@param patrolRoute string
function OpenPatrolRoute(patrolRoute) end


function OpenReportugcMenu() end

---@return integer
function OpenSequenceTask() end


function OpenSocialClubMenu() end

---@param p0 any
---@param p1 any
---@param vehicleHash integer | string
function OrderedBossVehicle(p0, p1, vehicleHash) end

---@param cam integer
---@param p1 integer
---@param p2 number
---@param p3 number
function OverrideCamSplineMotionBlur(cam, p1, p2, p3) end

---@param cam integer
---@param p1 integer
---@param p2 number
---@param p3 number
function OverrideCamSplineVelocity(cam, p1, p2, p3) end


function OverrideInteriorSmokeEnd() end

---@param level number
function OverrideInteriorSmokeLevel(level) end

---@param name string
function OverrideInteriorSmokeName(name) end

---@param scaling number
function OverrideLodscaleThisFrame(scaling) end

---@param hash integer | string
---@param toggle boolean
function OverrideMicrophoneSettings(hash, toggle) end

---@param p0 integer
---@param hudColor integer
function OverrideMultiplayerChatColour(p0, hudColor) end

---@param gxtEntryHash integer | string
function OverrideMultiplayerChatPrefix(gxtEntryHash) end

---@param ped integer
---@param txd string
---@param txn string
---@return boolean
function OverridePedBadgeTexture(ped, txd, txn) end

---@param flag boolean
function OverridePedsCanStandOnTopFlag(flag) end

---@param flag boolean
function OverridePedsUseDefaultDriveByClipset(flag) end

---@param overriddenMaterialHash integer | string
---@param scriptOverrides boolean
function OverridePlayerGroundMaterial(overriddenMaterialHash, scriptOverrides) end

---@param path string
function OverridePopGroups(path) end

---@param scheduleId integer
---@param vehicleHash integer | string
function OverridePopscheduleVehicleModel(scheduleId, vehicleHash) end

---@param state boolean
---@param reaction integer
function OverrideReactionToVehicleSiren(state, reaction) end

---@param p0 boolean
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 boolean
---@return boolean, vector3, number
function OverrideSaveHouse(p0, p1, p2, p3, p4, p5) end

---@param voiceEffect string
function OverrideTrevorRage(voiceEffect) end

---@param streamName string
---@param override boolean
function OverrideUnderwaterStream(streamName, override) end

---@param vehicle integer
---@param override boolean
---@param hornHash integer
function OverrideVehHorn(vehicle, override, hornHash) end

---@param vehicle integer
---@param can boolean
function OverrideVehiclePedsCanStandOnTopFlag(vehicle, can) end

---@return integer
function ParticipantId() end

---@return integer
function ParticipantIdToInt() end

---@param scaleformHandle integer
---@return boolean
function PassKeyboardInputToScaleform(scaleformHandle) end

---@param decalType integer
---@param textureDict string
---@param textureName string
function PatchDecalDiffuseMap(decalType, textureDict, textureName) end

---@param toggle boolean
function PauseClock(toggle) end

---@param toggle boolean
function PauseDeathArrestRestart(toggle) end

---@param hash integer | string
function PauseMenuActivateContext(hash) end

---@param contextHash integer | string
function PauseMenuDeactivateContext(contextHash) end

---@param toggle boolean
function PauseMenuDisableBusyspinner(toggle) end

---@return integer
function PauseMenuGetMouseHoverIndex() end

---@return integer
function PauseMenuGetMouseHoverUniqueId() end

---@param contextHash integer | string
---@return boolean
function PauseMenuIsContextActive(contextHash) end

---@return any
function PauseMenuIsContextMenuActive() end

---@param p0 integer
function PauseMenuRedrawInstructionalButtons(p0) end

---@param bVisible boolean
---@param iColumnID integer
---@param iSpinnerIndex integer
function PauseMenuSetBusySpinner(bVisible, iColumnID, iSpinnerIndex) end

---@param setWarn boolean
function PauseMenuSetWarnOnTabChange(setWarn) end

---@param pageId integer
function PauseMenuceptionGoDeeper(pageId) end


function PauseMenuceptionTheKick() end

---@param vehicle integer
function PausePlaybackRecordedVehicle(vehicle) end

---@param finishCurrentLine boolean
function PauseScriptedConversation(finishCurrentLine) end

---@param enabled boolean
function PauseToggleFullscreenMap(enabled) end

---@param ped integer
---@return boolean
function PedHasUseScenarioTask(ped) end

---@param ped integer
---@return integer
function PedToNet(ped) end

---@param interior integer
function PinInteriorInMemory(interior) end

---@param ropeId integer
---@param vertex integer
---@param x number
---@param y number
---@param z number
function PinRopeVertex(ropeId, vertex, x, y, z) end

---@param object integer
---@return boolean
function PlaceObjectOnGroundOrObjectProperly(object) end

---@param object integer
---@return boolean
function PlaceObjectOnGroundProperly(object) end

---@param speechName string
---@param voiceName string
---@param x number
---@param y number
---@param z number
---@param speechParam string
function PlayAmbientSpeechFromPositionNative(speechName, voiceName, x, y, z, speechParam) end

---@param ped integer
---@param animDict string
---@param animName string
function PlayAnimOnRunningScenario(ped, animDict, animName) end

---@param pedHandle integer
---@param animalType integer
---@param speechName string
function PlayAnimalVocalization(pedHandle, animalType, speechName) end

---@param binkMovie integer
function PlayBinkMovie(binkMovie) end

---@param cam integer
---@param animName string
---@param animDictionary string
---@param x number
---@param y number
---@param z number
---@param xRot number
---@param yRot number
---@param zRot number
---@param p9 boolean
---@param p10 integer
---@return boolean
function PlayCamAnim(cam, animName, animDictionary, x, y, z, xRot, yRot, zRot, p9, p10) end

---@param soundName string
---@param soundsetName string
function PlayDeferredSoundFrontend(soundName, soundsetName) end

---@param bActive boolean
function PlayEndCreditsMusic(bActive) end

---@param entity integer
---@param animName string
---@param animDict string
---@param fBlendDelta number
---@param bLoop boolean
---@param bHoldLastFrame boolean
---@param bDriveToPose boolean
---@param fStartPhase number
---@param iFlags integer
---@return boolean
function PlayEntityAnim(entity, animName, animDict, fBlendDelta, bLoop, bHoldLastFrame, bDriveToPose, fStartPhase, iFlags) end

---@param p0 any
---@param p4 number
---@param p5 number
---@return any, any, any
function PlayEntityScriptedAnim(p0, p4, p5) end

---@param ped integer
---@param animName string
---@param animDict string
function PlayFacialAnim(ped, animName, animDict) end

---@param audioName string
function PlayMissionCompleteAudio(audioName) end

---@param ped integer
---@param damageReason integer
---@param rawDamage number
function PlayPain(ped, damageReason, rawDamage) end

---@param ped integer
---@param speechName string
---@param speechParam string
function PlayPedAmbientSpeechAndCloneNative(ped, speechName, speechParam) end

---@param ped integer
---@param speechName string
---@param speechParam string
function PlayPedAmbientSpeechNative(ped, speechName, speechParam) end

---@param ped integer
---@param speechName string
---@param voiceName string
---@param speechParam string
---@param p4 boolean
function PlayPedAmbientSpeechWithVoiceNative(ped, speechName, voiceName, speechParam, p4) end

---@param ringtoneName string
---@param ped integer
---@param p2 boolean
function PlayPedRingtone(ringtoneName, ped, p2) end

---@param name string
---@param p1 number
---@return integer
function PlayPoliceReport(name, p1) end

---@param soundId integer
---@param audioName string
---@param audioRef string
---@param p3 boolean
---@param p4 any
---@param p5 boolean
function PlaySound(soundId, audioName, audioRef, p3, p4, p5) end

---@param soundId integer
---@param audioName string
---@param x number
---@param y number
---@param z number
---@param audioRef string
---@param isNetwork boolean
---@param range integer
---@param p8 boolean
function PlaySoundFromCoord(soundId, audioName, x, y, z, audioRef, isNetwork, range, p8) end

---@param soundId integer
---@param audioName string
---@param entity integer
---@param audioRef string
---@param isNetwork boolean
---@param p5 any
function PlaySoundFromEntity(soundId, audioName, entity, audioRef, isNetwork, p5) end

---@param soundId integer
---@param audioName string
---@param audioRef string
---@param p3 boolean
function PlaySoundFrontend(soundId, audioName, audioRef, p3) end

---@param object integer
function PlayStreamFromObject(object) end

---@param ped integer
function PlayStreamFromPed(ped) end

---@param x number
---@param y number
---@param z number
function PlayStreamFromPosition(x, y, z) end

---@param vehicle integer
function PlayStreamFromVehicle(vehicle) end


function PlayStreamFrontend() end

---@param sceneId integer
---@return boolean
function PlaySynchronizedAudioEvent(sceneId) end

---@param camera integer
---@param scene integer
---@param animName string
---@param animDictionary string
---@return boolean
function PlaySynchronizedCamAnim(camera, scene, animName, animDictionary) end

---@param entity integer
---@param syncedScene integer
---@param animName string
---@param animDictName string
---@param fBlendInDelta number
---@param fBlendOutDelta number
---@param iFlags integer
---@param fMoverBlendInDelta number
---@return boolean
function PlaySynchronizedEntityAnim(entity, syncedScene, animName, animDictName, fBlendInDelta, fBlendOutDelta, iFlags, fMoverBlendInDelta) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param objectModelHash integer | string
---@param sceneId integer
---@param pAnimName string
---@param pAnimDictName string
---@param fBlendDelta number
---@param fBlendOutDelta number
---@param flags integer
---@param fMoverBlendInDelta number
---@return boolean
function PlaySynchronizedMapEntityAnim(x, y, z, radius, objectModelHash, sceneId, pAnimName, pAnimDictName, fBlendDelta, fBlendOutDelta, flags, fMoverBlendInDelta) end

---@param ped integer
---@param p1 integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 boolean
function PlayTennisDiveAnim(ped, p1, p2, p3, p4, p5) end

---@param ped integer
---@param animDict string
---@param animName string
---@param p3 number
---@param p4 number
---@param p5 boolean
function PlayTennisSwingAnim(ped, animDict, animName, p3, p4, p5) end

---@param vehicle integer
---@param doorIndex integer
function PlayVehicleDoorCloseSound(vehicle, doorIndex) end

---@param vehicle integer
---@param doorIndex integer
function PlayVehicleDoorOpenSound(vehicle, doorIndex) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
function PlayerAttachVirtualBound(p0, p1, p2, p3, p4, p5, p6, p7) end


function PlayerDetachVirtualBound() end

---@return integer
function PlayerId() end

---@return integer
function PlayerPedId() end

---@param p0 any
function PlaystatsAcquiredHiddenPackage(p0) end

---@param p0 any
---@param p1 any
function PlaystatsActivityDone(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function PlaystatsArcadegame(p0, p1, p2, p3, p4, p5) end

---@param p0 integer
---@param p1 integer
---@param p2 integer
---@param p3 integer
---@param p4 integer
function PlaystatsArenaWarSpectator(p0, p1, p2, p3, p4) end

---@return any
function PlaystatsArenaWarsEnded() end

---@param id integer
function PlaystatsAwardBadsport(id) end

---@param amount integer
---@param type integer | string
---@param category integer | string
function PlaystatsAwardXp(amount, type, category) end

---@param action string
---@param value integer
function PlaystatsBackgroundScriptAction(action, value) end

---@param p0 integer
function PlaystatsBanAlert(p0) end

---@return any
function PlaystatsBuyContraband() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function PlaystatsCarclubChallenge(p0, p1, p2, p3) end

---@param p0 any
function PlaystatsCarclubPoints(p0) end

---@param p0 any
---@param p1 any
function PlaystatsCarclubPrize(p0, p1) end

---@param p0 any
function PlaystatsCasinoBlackjack(p0) end

---@param p0 any
function PlaystatsCasinoBlackjackLight(p0) end

---@param p0 any
function PlaystatsCasinoChip(p0) end

---@param p0 any
function PlaystatsCasinoInsidetrack(p0) end

---@param p0 any
function PlaystatsCasinoInsidetrackLight(p0) end

---@param p0 any
function PlaystatsCasinoLuckyseven(p0) end

---@return any
function PlaystatsCasinoMissionEnded() end

---@param p0 any
function PlaystatsCasinoRoulette(p0) end

---@param p0 any
function PlaystatsCasinoRouletteLight(p0) end

---@param p0 any
function PlaystatsCasinoSlotmachine(p0) end

---@param p0 any
function PlaystatsCasinoSlotmachineLight(p0) end

---@param p0 any
---@param p1 any
function PlaystatsCasinoStoryMissionEnded(p0, p1) end

---@param p0 any
function PlaystatsCasinoThreecardpoker(p0) end

---@param p0 any
function PlaystatsCasinoThreecardpokerLight(p0) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function PlaystatsChangeMcEmblem(p0, p1, p2, p3, p4) end

---@param cheat string
function PlaystatsCheatApplied(cheat) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function PlaystatsClothChange(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
function PlaystatsCollectible(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function PlaystatsCopyRankIntoNewSlot(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 number
---@param p1 number
---@param p2 number
function PlaystatsCrateCreated(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function PlaystatsCrateDropMissionDone(p0, p1, p2, p3, p4, p5) end

---@return any
function PlaystatsDarMissionEnd() end

---@return any
function PlaystatsDefendContraband() end

---@return any
function PlaystatsDirectorMode() end

---@param p0 integer
---@param p1 integer
---@param p2 integer
function PlaystatsDroneUsage(p0, p1, p2) end

---@return any
function PlaystatsDupeDetection() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function PlaystatsEarnedMcPoints(p0, p1, p2, p3, p4, p5) end

---@return any
function PlaystatsEnterSessionPack() end

---@param p0 any
function PlaystatsExtraEvent(p0) end

---@param p0 any
---@param p1 any
function PlaystatsFriendActivity(p0, p1) end

---@return any
function PlaystatsGunrunMissionEnded() end

---@return any
function PlaystatsH2FmprepEnd() end

---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function PlaystatsH2InstanceEnd(p1, p2, p3) end

---@param hash integer | string
---@param p1 integer
function PlaystatsHeistSaveCheat(hash, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function PlaystatsHoldUpMissionDone(p0, p1, p2, p3) end

---@param time integer
function PlaystatsIdleKick(time) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function PlaystatsImportExportMissionDone(p0, p1, p2, p3) end

---@param p0 any
function PlaystatsInventory(p0) end

---@return any, any, any, any
function PlaystatsJobBend() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function PlaystatsLeaveJobChain(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
function PlaystatsMatchStarted(p0, p1, p2, p3, p4, p5, p6) end

---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function PlaystatsMissionCheckpoint(p1, p2, p3) end

---@param p1 any
---@param p2 any
---@param p3 boolean
---@param p4 boolean
---@param p5 boolean
---@return any
function PlaystatsMissionOver(p1, p2, p3, p4, p5) end

---@param p1 any
---@param p2 any
---@param p3 boolean
---@return any
function PlaystatsMissionStarted(p1, p2, p3) end

---@return any
function PlaystatsNpcInvite() end

---@param p0 any
---@param p1 any
---@param p2 any
function PlaystatsOddjobDone(p0, p1, p2) end

---@param p0 boolean
---@param p1 integer
---@param p2 integer
---@param p3 integer
function PlaystatsPassiveMode(p0, p1, p2, p3) end

---@param modelHash integer | string
function PlaystatsPegasaircraft(modelHash) end

---@return any
function PlaystatsPiMenuHideSettings() end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function PlaystatsPropChange(p0, p1, p2, p3) end

---@param element integer
---@param item string
function PlaystatsQuickfixTool(element, item) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function PlaystatsRaceCheckpoint(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
function PlaystatsRaceToPointMissionDone(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param name string
---@param p1 any
---@param p2 any
---@param p3 any
function PlaystatsRandomMissionDone(name, p1, p2, p3) end

---@param rank integer
function PlaystatsRankUp(rank) end

---@return any
function PlaystatsRecoverContraband() end

---@param p0 any
function PlaystatsRobberyFinale(p0) end

---@param p0 any
function PlaystatsRobberyPrep(p0) end

---@param amount integer
---@param act integer
---@param player integer
---@param cm number
function PlaystatsRosBet(amount, act, player, cm) end

---@return any
function PlaystatsSellContraband() end

---@param joinType integer
function PlaystatsSetJoinType(joinType) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function PlaystatsShopItem(p0, p1, p2, p3, p4) end

---@return any
function PlaystatsSmugMissionEnded() end

---@param p0 integer
---@param p1 integer
---@param p2 integer
---@param p3 integer
function PlaystatsSpectatorWheelSpin(p0, p1, p2, p3) end

---@param amount integer
function PlaystatsSpentPiCustomLoadout(amount) end


function PlaystatsStartOfflineMode() end


function PlaystatsStartTrackingStunts() end

---@return any
function PlaystatsStoneHatchetEnd() end


function PlaystatsStopTrackingStunts() end

---@param weaponHash integer | string
---@param componentHashTo integer | string
---@param componentHashFrom integer | string
function PlaystatsWeaponModeChange(weaponHash, componentHashTo, componentHashFrom) end

---@param scaleformHash integer | string
---@param p1 integer
function PlaystatsWebsiteVisited(scaleformHash, p1) end

---@param cam integer
---@param x number
---@param y number
---@param z number
function PointCamAtCoord(cam, x, y, z) end

---@param cam integer
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param p5 boolean
function PointCamAtEntity(cam, entity, offsetX, offsetY, offsetZ, p5) end

---@param cam integer
---@param ped integer
---@param boneIndex integer
---@param x number
---@param y number
---@param z number
---@param p6 boolean
function PointCamAtPedBone(cam, ped, boneIndex, x, y, z, p6) end

---@param vehicle integer
function PopOutVehicleWindscreen(vehicle) end


function PopTimecycleModifier() end


function PopulateNow() end

---@param base number
---@param exponent number
---@return number
function Pow(base, exponent) end

---@param srl string
function PrefetchSrl(srl) end


function PreloadBusyspinner() end

---@param name string
function PreloadCloudHat(name) end

---@param displaySubtitles boolean
---@param addToBriefScreen boolean
---@param cloneConversation boolean
---@param interruptible boolean
function PreloadScriptConversation(displaySubtitles, addToBriefScreen, cloneConversation, interruptible) end

---@param displaySubtitles boolean
---@param addToBriefScreen boolean
function PreloadScriptPhoneConversation(displaySubtitles, addToBriefScreen) end

---@param model integer | string
function PreloadVehicleAudioBank(model) end

---@param p0 any
---@param modType integer
---@param p2 any
function PreloadVehicleMod(p0, modType, p2) end

---@param alarmName string
---@return boolean
function PrepareAlarm(alarmName) end

---@param lightType integer
---@param flags integer
---@param x number
---@param y number
---@param z number
---@param r integer
---@param g integer
---@param b integer
---@param intensity number
function PrepareLight(lightType, flags, x, y, z, r, g, b, intensity) end

---@param eventName string
---@return boolean
function PrepareMusicEvent(eventName) end

---@param audioEvent string
---@param startOffsetMs integer
---@return boolean
function PrepareSynchronizedAudioEvent(audioEvent, startOffsetMs) end

---@param sceneId integer
---@param audioEvent string
---@return boolean
function PrepareSynchronizedAudioEventForScene(sceneId, audioEvent) end

---@param statHash integer | string
---@param value number
---@param p2 integer
function PresenceEventUpdatestatFloat(statHash, value, p2) end

---@param statHash integer | string
---@param value integer
---@param p2 integer
function PresenceEventUpdatestatInt(statHash, value, p2) end

---@param timecycleModifierName string
function PresetInteriorAmbientCache(timecycleModifierName) end

---@param object integer
---@param p1 boolean
---@param p2 boolean
function PreventCollectionOfPortablePickup(object, p1, p2) end

---@param p2 string
---@return string, integer, integer
function ProcessCashGift(p2) end

---@param entity integer
function ProcessEntityAttachments(entity) end

---@param blip integer
function PulseBlip(blip) end


function PushTimecycleModifier() end

---@param p0 any
---@return any
function QueryMovieMeshSetState(p0) end

---@return boolean
function QueueMissionRepeatLoad() end

---@return boolean
function QueueMissionRepeatSave() end

---@param scanForSaving boolean
---@return boolean
function QueueOperationToCreateSortedListOfPhotos(scanForSaving) end


function QuitGame() end

---@param x number
---@param y number
---@param z number
---@return any
function RaceGalleryAddBlip(x, y, z) end

---@param toggle boolean
function RaceGalleryFullscreen(toggle) end

---@param spriteId integer
function RaceGalleryNextBlipSprite(spriteId) end

---@param vehicle integer
---@param instantlyRaise boolean
function RaiseConvertibleRoof(vehicle, instantlyRaise) end

---@param vehicle integer
function RaiseRetractableWheels(vehicle) end

---@param x number
---@param y number
---@param z number
---@param radius number
function RecordBrokenGlass(x, y, z, radius) end

---@param ped integer
---@return boolean
function RefillAmmoInstantly(ped) end


function RefreshClosestOceanShoreline() end

---@param interiorID integer
function RefreshInterior(interiorID) end

---@param p0 integer
---@return boolean
function RefreshPlayerListStats(p0) end


function RefreshWaypoint() end

---@param factory function
function RegisterArchetypes(factory) end

---@param name string
---@return any
function RegisterBoolToSave(name) end

---@param cutsceneEntity integer
---@param cutsceneEntName string
---@param p2 integer
---@param modelHash integer | string
---@param p4 integer
function RegisterEntityForCutscene(cutsceneEntity, cutsceneEntName, p2, modelHash, p4) end

---@param name string
---@return any
function RegisterEnumToSave(name) end

---@param name string
---@return any
function RegisterFloatToSave(name) end

---@param fileName string
function RegisterFontFile(fileName) end

---@param fontName string
---@return integer
function RegisterFontId(fontName) end

---@param ped integer
---@param radius number
function RegisterHatedTargetsAroundPed(ped, radius) end

---@param name string
---@return any
function RegisterInt64ToSave(name) end

---@param name string
---@return any
function RegisterIntToSave(name) end

---@param commandString string
---@param description string
---@param defaultMapper string
---@param defaultParameter string
function RegisterKeyMapping(commandString, description, defaultMapper, defaultParameter) end

---@param name string
---@param p1 boolean
---@return boolean
function RegisterNamedRendertarget(name, p1) end


function RegisterNoirScreenEffectThisFrame() end

---@param callbackType string
---@param callback function
function RegisterNuiCallback(callbackType, callback) end

---@param callbackType string
function RegisterNuiCallbackType(callbackType) end

---@param scriptName string
---@param modelHash integer | string
---@param p2 integer
---@param activationRange number
---@param p4 integer
---@param p5 integer
function RegisterObjectScriptBrain(scriptName, modelHash, p2, activationRange, p4, p5) end

---@param ped integer
---@return integer
function RegisterPedheadshot(ped) end

---@param ped integer
---@return integer
function RegisterPedheadshotTransparent(ped) end

---@param ped integer
---@return integer
function RegisterPedheadshot_3(ped) end

---@param keymapName string
---@param onKeyDown function
---@param onKeyUp function
---@param rawKeyIndex integer
---@param canBeDisabled boolean
function RegisterRawKeymap(keymapName, onKeyDown, onKeyUp, rawKeyIndex, canBeDisabled) end

---@param callbackType string
---@param callback function
function RegisterRawNuiCallback(callbackType, callback) end

---@param numSections integer
---@param radius number
---@param diffuseTextureName string
---@param normalMapName string
---@param distanceMappingScale number
---@param uvScaleX number
---@param uvScaleY number
---@param specularFresnel number
---@param specularFalloff number
---@param specularIntensity number
---@param bumpiness number
---@param color integer
---@return integer
function RegisterRopeData(numSections, radius, diffuseTextureName, normalMapName, distanceMappingScale, uvScaleX, uvScaleY, specularFresnel, specularFalloff, specularIntensity, bumpiness, color) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p5 any
---@param p6 any
---@return any, any
function RegisterSaveHouse(p0, p1, p2, p3, p5, p6) end

---@param inChargeOfAudio boolean
function RegisterScriptWithAudio(inChargeOfAudio) end

---@param resourceName string
---@param fileName string
---@param cacheString string
function RegisterStreamingFileFromCache(resourceName, fileName, cacheString) end

---@param kvsKey string
function RegisterStreamingFileFromKvs(kvsKey) end

---@param registerAs string
---@param url string
function RegisterStreamingFileFromUrl(registerAs, url) end


function RegisterSynchronisedScriptSpeech() end

---@param ped integer
---@param target integer
function RegisterTarget(ped, target) end

---@param name string
---@return any
function RegisterTextLabelToSave(name) end

---@param name string
---@return any
function RegisterTextLabelToSave_2(name) end

---@param trackIndex integer
---@param trackNode integer
---@param newIndex integer
---@param newNode integer
---@param direction boolean
---@return integer
function RegisterTrackJunction(trackIndex, trackNode, newIndex, newNode, direction) end

---@param scriptName string
---@param activationRange number
---@param p2 integer
function RegisterWorldPointScriptBrain(scriptName, activationRange, p2) end


function ReleaseAllCommerceItemImages() end


function ReleaseAmbientAudioBank() end

---@param binkMovie integer
function ReleaseBinkMovie(binkMovie) end


function ReleaseControlOfFrontend() end


function ReleaseMissionAudioBank() end

---@param movieMeshSet integer
function ReleaseMovieMeshSet(movieMeshSet) end

---@param name string
---@return boolean
function ReleaseNamedRendertarget(name) end

---@param audioBank string
function ReleaseNamedScriptAudioBank(audioBank) end

---@param ped integer
function ReleasePedPreloadPropData(ped) end

---@param ped integer
function ReleasePedPreloadVariationData(ped) end

---@param id integer
function ReleasePedheadshotImgUpload(id) end

---@param vehicle integer
function ReleasePreloadMods(vehicle) end


function ReleaseScriptAudioBank() end

---@param entity integer
function ReleaseScriptGuidFromEntity(entity) end

---@param soundId integer
function ReleaseSoundId(soundId) end


function ReleaseWeaponAudio() end


function ReloadMapMenu() end

---@param keymapName string
---@param newRawKeyIndex integer
function RemapRawKeymap(keymapName, newRawKeyIndex) end

---@return boolean
function RemoteCheatDetected() end

---@param asset string
function RemoveActionModeAsset(asset) end

---@param zoneId integer
---@return boolean
function RemoveAirDefenseZone(zoneId) end


function RemoveAllAirDefenseZones() end


function RemoveAllCoverBlockingAreas() end

---@param ped integer
---@param p1 boolean
function RemoveAllPedWeapons(ped, p1) end

---@param pickupHash integer | string
function RemoveAllPickupsOfType(pickupHash) end

---@param weaponHash integer | string
---@param explode boolean
function RemoveAllProjectilesOfType(weaponHash, explode) end

---@param p0 boolean
function RemoveAllShockingEvents(p0) end

---@param entity integer
function RemoveAllStickyBombsFromEntity(entity) end

---@param animDict string
function RemoveAnimDict(animDict) end

---@param animSet string
function RemoveAnimSet(animSet) end

---@param blip integer
function RemoveBlip(blip) end

---@param clipSet string
function RemoveClipSet(clipSet) end

---@param coverpoint integer
function RemoveCoverPoint(coverpoint) end

---@param p0 integer
function RemoveCurrentRise(p0) end

---@param cutsceneName string
function RemoveCutFile(cutsceneName) end


function RemoveCutscene() end

---@param decal integer
function RemoveDecal(decal) end

---@param obj integer
function RemoveDecalsFromObject(obj) end

---@param obj integer
---@param x number
---@param y number
---@param z number
function RemoveDecalsFromObjectFacing(obj, x, y, z) end

---@param vehicle integer
function RemoveDecalsFromVehicle(vehicle) end

---@param x number
---@param y number
---@param z number
---@param range number
function RemoveDecalsInRange(x, y, z, range) end

---@param p0 any
function RemoveDispatchSpawnBlockingArea(p0) end

---@param doorHash integer | string
function RemoveDoorFromSystem(doorHash) end

---@param handle integer
function RemoveDryVolume(handle) end

---@param entity integer
---@param fadeOut number
function RemoveEntityFromAudioMixGroup(entity, fadeOut) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function RemoveForcedObject(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
function RemoveFromItemset(p0, p1) end

---@param groupId integer
function RemoveGroup(groupId) end

---@param configName string
function RemoveHealthConfig(configName) end

---@param iplName string
function RemoveIpl(iplName) end

---@param modelHash integer | string
function RemoveModelFromCreatorBudget(modelHash) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param model integer | string
---@param lazy boolean
function RemoveModelHide(x, y, z, radius, model, lazy) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param oldModelHash integer | string
---@param newModelHash integer | string
---@param bLazy boolean
function RemoveModelSwap(x, y, z, radius, oldModelHash, newModelHash, bLazy) end

---@param gamerTagId integer
function RemoveMpGamerTag(gamerTagId) end


function RemoveMultiplayerBankCash() end


function RemoveMultiplayerHudCash() end


function RemoveMultiplayerWalletCash() end

---@param fxName string
function RemoveNamedPtfxAsset(fxName) end

---@param p0 any
function RemoveNavmeshBlockingObject(p0) end


function RemoveNavmeshRequiredRegions() end

---@param object integer
function RemoveObjectHighDetailModel(object) end

---@param ptfxHandle integer
---@param p1 boolean
function RemoveParticleFx(ptfxHandle, p1) end

---@param entity integer
function RemoveParticleFxFromEntity(entity) end

---@param X number
---@param Y number
---@param Z number
---@param radius number
function RemoveParticleFxInRange(X, Y, Z, radius) end

---@param ped integer
---@param toggle boolean
function RemovePedDefensiveArea(ped, toggle) end

---@param ped integer
function RemovePedElegantly(ped) end

---@param ped integer
function RemovePedFromGroup(ped) end

---@param ped integer
---@param instantly boolean
function RemovePedHelmet(ped, instantly) end

---@param ped integer
function RemovePedPreferredCoverSet(ped) end

---@param cargobob integer
function RemovePickUpRopeForCargobob(cargobob) end

---@param pickup integer
function RemovePickup(pickup) end

---@param player integer
---@param p2 boolean
function RemovePlayerHelmet(player, p2) end

---@param id integer
---@param p1 boolean
function RemovePopMultiplierArea(id, p1) end

---@param id integer
---@param p1 boolean
function RemovePopMultiplierSphere(id, p1) end

---@param portalSettingsName string
function RemovePortalSettingsOverride(portalSettingsName) end


function RemovePtfxAsset() end

---@param groupHash integer | string
function RemoveRelationshipGroup(groupHash) end

---@param origTxd string
---@param origTxn string
function RemoveReplaceTexture(origTxd, origTxn) end

---@param speedzone integer
---@return boolean
function RemoveRoadNodeSpeedZone(speedzone) end

---@param hudComponent integer
function RemoveScaleformScriptHudMovie(hudComponent) end

---@param scenarioBlockingIndex integer
---@param bNetwork boolean
function RemoveScenarioBlockingArea(scenarioBlockingIndex, bNetwork) end


function RemoveScenarioBlockingAreas() end

---@param fireHandle integer
function RemoveScriptFire(fireHandle) end

---@param event integer
---@return boolean
function RemoveShockingEvent(event) end


function RemoveShockingEventSpawnBlockingAreas() end

---@param hash integer | string
---@param p1 boolean
function RemoveStealthKill(hash, p1) end

---@param asset string
function RemoveStealthModeAsset(asset) end

---@param p0 string
function RemoveTcmodifierOverride(p0) end

---@param textureId integer
function RemoveTexture(textureId) end

---@param modifierName string
function RemoveTimecycleModifier(modifierName) end

---@param modifierName string
---@param varName string
function RemoveTimecycleModifierVar(modifierName, varName) end

---@param junctionIndex integer
---@return boolean
function RemoveTrackJunction(junctionIndex) end

---@param vehicleAsset integer
function RemoveVehicleAsset(vehicleAsset) end

---@param p0 any
function RemoveVehicleCombatAvoidanceArea(p0) end

---@param vehicle integer
---@param p1 integer
function RemoveVehicleCrewEmblem(vehicle, p1) end

---@param vehicle integer
function RemoveVehicleHighDetailModel(vehicle) end

---@param vehicle integer
---@param modType integer
function RemoveVehicleMod(vehicle, modType) end

---@param recording integer
---@param script string
function RemoveVehicleRecording(recording, script) end

---@param vehicle integer
function RemoveVehicleShadowEffect(vehicle) end

---@param vehicle integer
function RemoveVehicleStuckCheck(vehicle) end

---@param vehicle integer
function RemoveVehicleUpsidedownCheck(vehicle) end

---@param vehicle integer
---@param windowIndex integer
function RemoveVehicleWindow(vehicle, windowIndex) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param unk any
function RemoveVehiclesFromGeneratorsInArea(x1, y1, z1, x2, y2, z2, unk) end


function RemoveWarningMessageListItems() end

---@param name string
function RemoveWaypointRecording(name) end

---@param weaponHash integer | string
function RemoveWeaponAsset(weaponHash) end

---@param ped integer
---@param weaponHash integer | string
---@param componentHash integer | string
function RemoveWeaponComponentFromPed(ped, weaponHash, componentHash) end

---@param weaponObject integer
---@param addonHash integer | string
function RemoveWeaponComponentFromWeaponObject(weaponObject, addonHash) end

---@param ped integer
---@param weaponHash integer | string
function RemoveWeaponFromPed(ped, weaponHash) end

---@param x number
---@param y number
---@param z number
---@param colorIndex integer
function RenderFakePickupGlow(x, y, z, colorIndex) end

---@param render boolean
---@param ease boolean
---@param easeTime integer
---@param easeCoordsAnim boolean
---@param p4 boolean
function RenderScriptCams(render, ease, easeTime, easeCoordsAnim, p4) end

---@param hudColorIndex integer
---@param hudColorIndex2 integer
function ReplaceHudColour(hudColorIndex, hudColorIndex2) end

---@param hudColorIndex integer
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function ReplaceHudColourWithRgba(hudColorIndex, r, g, b, a) end

---@return number
function ReplayFreeCamGetMaxRange() end

---@param player integer
---@param crimeType integer
---@param wantedLvlThresh integer
function ReportCrime(player, crimeType, wantedLvlThresh) end

---@param player integer
function ReportPoliceSpottedPlayer(player) end

---@param asset string
function RequestActionModeAsset(asset) end

---@param x number
---@param y number
---@param z number
function RequestAdditionalCollisionAtCoord(x, y, z) end

---@param gxt string
---@param slot integer
function RequestAdditionalText(gxt, slot) end

---@param gxt string
---@param slot integer
function RequestAdditionalTextForDlc(gxt, slot) end

---@param bankName string
---@param bOverNetwork boolean
---@return boolean
function RequestAmbientAudioBank(bankName, bOverNetwork) end

---@param animDict string
function RequestAnimDict(animDict) end

---@param animSet string
function RequestAnimSet(animSet) end

---@param clipSet string
function RequestClipSet(clipSet) end

---@param x number
---@param y number
---@param z number
function RequestCollisionAtCoord(x, y, z) end

---@param model integer | string
function RequestCollisionForModel(model) end

---@param index integer
---@return boolean
function RequestCommerceItemImage(index) end

---@param cutsceneName string
function RequestCutFile(cutsceneName) end

---@param cutsceneName string
---@param flags integer
function RequestCutscene(cutsceneName, flags) end

---@param cutsceneName string
---@param playbackFlags integer
---@param flags integer
function RequestCutsceneWithPlaybackList(cutsceneName, playbackFlags, flags) end

---@param iplName string
function RequestIpl(iplName) end

---@param model integer | string
function RequestMenuPedModel(model) end

---@param bankName string
---@param bOverNetwork boolean
---@return boolean
function RequestMissionAudioBank(bankName, bOverNetwork) end

---@param model integer | string
function RequestModel(model) end

---@param interior integer
---@param roomName string
function RequestModelsInRoom(interior, roomName) end

---@param fxName string
function RequestNamedPtfxAsset(fxName) end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return boolean
function RequestPathsPreferAccurateBoundingstruct(x1, y1, x2, y2) end

---@param ped integer
---@param p1 boolean
function RequestPedVehicleVisibilityTracking(ped, p1) end

---@param ped integer
function RequestPedVisibilityTracking(ped) end

---@param id integer
---@return boolean
function RequestPedheadshotImgUpload(id) end


function RequestPtfxAsset() end

---@param setName string
---@return boolean
function RequestResourceFileSet(setName) end

---@param scaleformName string
---@return integer
function RequestScaleformMovie(scaleformName) end

---@param scaleformName string
---@return integer
function RequestScaleformMovieInstance(scaleformName) end

---@param scaleformName string
---@return integer
function RequestScaleformMovieSkipRenderWhilePaused(scaleformName) end

---@param scaleformName string
---@return integer
function RequestScaleformMovieWithIgnoreSuperWidescreen(scaleformName) end

---@param hudComponent integer
function RequestScaleformScriptHudMovie(hudComponent) end

---@param scriptName string
function RequestScript(scriptName) end

---@param bankName string
---@param bOverNetwork boolean
---@return boolean
function RequestScriptAudioBank(bankName, bOverNetwork) end

---@param scriptHash integer | string
function RequestScriptWithNameHash(scriptHash) end

---@param asset string
function RequestStealthModeAsset(asset) end

---@param textureDict string
---@param p1 boolean
function RequestStreamedTextureDict(textureDict, p1) end

---@param ped integer
---@param name string
---@return boolean
function RequestTaskMoveNetworkStateTransition(ped, name) end

---@param opponentPed integer
function RequestTennisBanks(opponentPed) end

---@param vehicleHash integer | string
---@param vehicleAsset integer
function RequestVehicleAsset(vehicleHash, vehicleAsset) end

---@param vehicle integer
function RequestVehicleDashboardScaleformMovie(vehicle) end

---@param vehicle integer
function RequestVehicleHighDetailModel(vehicle) end

---@param recording integer
---@param script string
function RequestVehicleRecording(recording, script) end

---@param name string
function RequestWaypointRecording(name) end

---@param weaponHash integer | string
---@param p1 integer
---@param p2 integer
function RequestWeaponAsset(weaponHash, p1, p2) end

---@param weaponObject integer
function RequestWeaponHighDetailModel(weaponObject) end

---@param amount integer
function ReserveNetworkLocalObjects(amount) end

---@param amount integer
function ReserveNetworkLocalPeds(amount) end

---@param amount integer
function ReserveNetworkLocalVehicles(amount) end

---@param amount integer
function ReserveNetworkMissionObjects(amount) end

---@param amount integer
function ReserveNetworkMissionPeds(amount) end

---@param amount integer
function ReserveNetworkMissionVehicles(amount) end

---@param numFrames integer
function ResetAdaptation(numFrames) end


function ResetAiMeleeWeaponDamageModifier() end


function ResetAiWeaponDamageModifier() end


function ResetBenchmarkRecording() end


function ResetDeepOceanScaler() end


function ResetDispatchIdealSpawnDistance() end


function ResetDispatchSpawnBlockingAreas() end


function ResetDispatchSpawnLocation() end

---@param p0 any
function ResetDispatchTimeBetweenSpawnAttempts(p0) end


function ResetEditorValues() end

---@param entity integer
function ResetEntityAlpha(entity) end


function ResetEntityDrawOutlineRenderTechnique() end


function ResetExclusiveScenarioGroup() end


function ResetFlyThroughWindscreenParams() end


function ResetGhostedEntityAlpha() end

---@param flagIndex integer
function ResetGlobalActionscriptFlag(flagIndex) end

---@param groupHandle integer
function ResetGroupFormationDefaultSpacing(groupHandle) end

---@param id integer
function ResetHudComponentValues(id) end


function ResetInputMappingScheme() end

---@param index integer
function ResetMapZoomDataLevel(index) end

---@param mapDataHash integer
---@param entityInternalIdx integer
---@return boolean
function ResetMapdataEntityMatrix(mapDataHash, entityInternalIdx) end

---@param name string
function ResetParticleFxOverride(name) end


function ResetPausedRenderphases() end

---@param ped integer
function ResetPedAudioFlags(ped) end

---@param ped integer
function ResetPedInVehicleContext(ped) end

---@param ped integer
function ResetPedLastVehicle(ped) end

---@param modelHash integer | string
function ResetPedModelPersonality(modelHash) end

---@param ped integer
---@param transitionSpeed number
function ResetPedMovementClipset(ped, transitionSpeed) end

---@param ped integer
function ResetPedRagdollTimer(ped) end

---@param ped integer
function ResetPedStrafeClipset(ped) end

---@param ped integer
function ResetPedVisibleDamage(ped) end

---@param ped integer
function ResetPedWeaponMovementClipset(ped) end

---@param player integer
function ResetPlayerArrestState(player) end

---@param player integer
function ResetPlayerInputGait(player) end

---@param player integer
function ResetPlayerStamina(player) end


function ResetReticuleValues() end


function ResetScenarioGroupsEnabled() end


function ResetScenarioTypesEnabled() end


function ResetScriptGfxAlign() end


function ResetTrevorRage() end

---@param vehicle integer
function ResetVehiclePedsCanStandOnTopFlag(vehicle) end

---@param vehicle integer
function ResetVehicleStartupRevSound(vehicle) end

---@param vehicle integer
---@param nullAttributes integer
function ResetVehicleStuckTimer(vehicle, nullAttributes) end

---@param vehicle integer
---@param toggle boolean
function ResetVehicleWheels(vehicle, toggle) end

---@param player integer
function ResetWantedLevelDifficulty(player) end


function ResetWater() end


function ResetWorldBoundaryForPlayer() end

---@param menuHash integer | string
---@param highlightedTab integer
function RestartFrontendMenu(menuHash, highlightedTab) end


function RestartGame() end


function RestartScriptedConversation() end

---@param player integer
---@param percentage number
function RestorePlayerStamina(player, percentage) end

---@param ped integer
function ResurrectPed(ped) end

---@param p0 integer
---@return integer
function ReturnTwo(p0) end

---@param ped integer
function ReviveInjuredPed(ped) end

---@return string
function RockstarMessageGetString() end

---@param vehicle integer
---@param windowIndex integer
function RollDownWindow(vehicle, windowIndex) end

---@param vehicle integer
function RollDownWindows(vehicle) end

---@param vehicle integer
---@param windowIndex integer
function RollUpWindow(vehicle, windowIndex) end

---@return boolean
function RopeAreTexturesLoaded() end

---@param ropeId integer
function RopeConvertToSimple(ropeId) end

---@param toggle boolean
---@return integer
function RopeDrawShadowEnabled(toggle) end

---@param ropeId integer
---@param length number
function RopeForceLength(ropeId, length) end

---@param ropeId integer
---@return number
function RopeGetDistanceBetweenEnds(ropeId) end


function RopeLoadTextures() end

---@param ropeId integer
---@param length number
function RopeResetLength(ropeId, length) end

---@param ropeId integer
---@param p1 any
function RopeSetUpdateOrder(ropeId, p1) end

---@param ropeId integer
function RopeSetUpdatePinverts(ropeId) end


function RopeUnloadTextures() end

---@param value number
---@return integer
function Round(value) end


function SaveBenchmarkRecording() end

---@param unused integer
---@return boolean
function SaveHighQualityPhoto(unused) end

---@return boolean
function SaveRecordingClip() end


function ScEmailMessageClearRecipList() end

---@return integer
function ScEmailMessagePushGamerToRecipList() end

---@param name string
---@return boolean
function ScGamerdataGetBool(name) end

---@param name string
---@return boolean, number
function ScGamerdataGetFloat(name) end

---@param name string
---@return boolean, integer
function ScGamerdataGetInt(name) end

---@param achievement integer
---@return boolean
function ScGetHasAchievementBeenPassed(achievement) end

---@return string
function ScGetNickname() end

---@param offset integer
---@param limit integer
function ScInboxGetEmails(offset, limit) end

---@param msgIndex integer
---@return boolean
function ScInboxGetMessageIsReadAtIndex(msgIndex) end

---@param msgIndex integer
---@return integer
function ScInboxGetMessageTypeAtIndex(msgIndex) end

---@return integer
function ScInboxGetTotalNumMessages() end

---@param p0 integer
---@return boolean
function ScInboxMessageDoApply(p0) end

---@param index integer
---@return boolean, integer
function ScInboxMessageGetBountyData(index) end

---@param p0 integer
---@param p1 string
---@return boolean
function ScInboxMessageGetDataBool(p0, p1) end

---@param p0 integer
---@param context string
---@return boolean, integer
function ScInboxMessageGetDataInt(p0, context) end

---@param p0 integer
---@param context string
---@param out string
---@return boolean
function ScInboxMessageGetDataString(p0, context, out) end

---@param p0 integer
---@return string
function ScInboxMessageGetString(p0) end

---@param p0 any
---@return boolean, any
function ScInboxMessageGetUgcdata(p0) end

---@param p0 integer
---@return boolean
function ScInboxMessagePop(p0) end

---@return integer
function ScInboxMessagePushGamerToEventRecipList() end

---@param data string
---@return boolean
function ScInboxMessageSendBountyPresenceEvent(data) end

---@param data string
function ScInboxMessageSendUgcStatUpdateEvent(data) end

---@param plateText string
---@param plateData string
---@return boolean, integer
function ScLicenseplateAdd(plateText, plateData) end

---@param token integer
---@return boolean
function ScLicenseplateGetAddIsPending(token) end

---@param token integer
---@return integer
function ScLicenseplateGetAddStatus(token) end

---@param token integer
---@return integer
function ScLicenseplateGetCount(token) end

---@param token integer
---@return boolean
function ScLicenseplateGetIsvalidIsPending(token) end

---@param token integer
---@return integer
function ScLicenseplateGetIsvalidStatus(token) end

---@param token integer
---@param plateIndex integer
---@return string
function ScLicenseplateGetPlate(token, plateIndex) end

---@param token integer
---@param plateIndex integer
---@return string
function ScLicenseplateGetPlateData(token, plateIndex) end

---@param plateText string
---@return boolean, integer
function ScLicenseplateIsvalid(plateText) end

---@param oldPlateText string
---@param newPlateText string
---@param plateData string
---@return boolean
function ScLicenseplateSetPlateData(oldPlateText, newPlateText, plateData) end

---@return boolean
function ScPresenceAttrSetFloat() end

---@param attrHash integer | string
---@param value integer
---@return boolean
function ScPresenceAttrSetInt(attrHash, value) end

---@param attrHash integer | string
---@param value string
---@return boolean
function ScPresenceAttrSetString(attrHash, value) end

---@param string string
---@return boolean, integer
function ScProfanityCheckString(string) end

---@param string string
---@return boolean, integer
function ScProfanityCheckUgcString(string) end

---@param token integer
---@return boolean
function ScProfanityGetCheckIsPending(token) end

---@param token integer
---@return boolean
function ScProfanityGetCheckIsValid(token) end

---@param token integer
---@return boolean
function ScProfanityGetStringPassed(token) end

---@param token integer
---@return integer
function ScProfanityGetStringStatus(token) end

---@param value boolean
function ScaleformMovieMethodAddParamBool(value) end

---@param value number
function ScaleformMovieMethodAddParamFloat(value) end

---@param value integer
function ScaleformMovieMethodAddParamInt(value) end

---@param value integer
function ScaleformMovieMethodAddParamLatestBriefString(value) end

---@param string string
function ScaleformMovieMethodAddParamLiteralString(string) end

---@param string string
function ScaleformMovieMethodAddParamPlayerNameString(string) end

---@param string string
function ScaleformMovieMethodAddParamTextureNameString(string) end

---@param toggle boolean
function ScriptIsMovingMobilePhoneOffscreen(toggle) end

---@param override boolean
---@param windElevationHashName integer | string
function ScriptOverridesWindElevation(override, windElevationHashName) end

---@param player integer
---@return boolean, integer, integer
function ScriptRaceGetPlayerSplitTime(player) end

---@param numCheckpoints integer
---@param numLaps integer
---@param numPlayers integer
---@param localPlayer integer
function ScriptRaceInit(numCheckpoints, numLaps, numPlayers, localPlayer) end

---@param ped integer
---@param checkpoint integer
---@param lap integer
---@param time integer
function ScriptRacePlayerHitCheckpoint(ped, checkpoint, lap, time) end


function ScriptRaceShutdown() end

---@return integer
function ScriptThreadIteratorGetNextThreadId() end


function ScriptThreadIteratorReset() end

---@return number
function SeethroughGetMaxThickness() end


function SeethroughReset() end

---@param red integer
---@param green integer
---@param blue integer
function SeethroughSetColorNear(red, green, blue) end

---@param distance number
function SeethroughSetFadeEndDistance(distance) end

---@param distance number
function SeethroughSetFadeStartDistance(distance) end

---@param index integer
---@param heatScale number
function SeethroughSetHeatscale(index, heatScale) end

---@param intensity number
function SeethroughSetHiLightIntensity(intensity) end

---@param noise number
function SeethroughSetHiLightNoise(noise) end

---@param thickness number
function SeethroughSetMaxThickness(thickness) end

---@param amount number
function SeethroughSetNoiseAmountMax(amount) end

---@param amount number
function SeethroughSetNoiseAmountMin(amount) end

---@param hitFlags integer
---@param precise boolean
---@return integer
function SelectEntityAtCursor(hitFlags, precise) end

---@param fracX number
---@param fracY number
---@param hitFlags integer
---@param precise boolean
---@return integer
function SelectEntityAtPos(fracX, fracY, hitFlags, precise) end

---@param duiObject integer
---@param jsonString string
function SendDuiMessage(duiObject, jsonString) end

---@param duiObject integer
---@param button string
function SendDuiMouseDown(duiObject, button) end

---@param duiObject integer
---@param x integer
---@param y integer
function SendDuiMouseMove(duiObject, x, y) end

---@param duiObject integer
---@param button string
function SendDuiMouseUp(duiObject, button) end

---@param duiObject integer
---@param deltaY integer
---@param deltaX integer
function SendDuiMouseWheel(duiObject, deltaY, deltaX) end

---@param jsonString string
---@return boolean
function SendLoadingScreenMessage(jsonString) end

---@param jsonString string
---@return boolean
function SendNuiMessage(jsonString) end

---@param value number
---@param maxValue number
function SetAbilityBarValue(value, maxValue) end

---@param visible boolean
function SetAbilityBarVisibilityInMultiplayer(visible) end

---@param achievement integer
---@param progress integer
---@return boolean
function SetAchievementProgress(achievement, progress) end

---@param object integer
---@param toggle boolean
function SetActivateObjectPhysicsAsSoonAsItIsUnfrozen(object, toggle) end

---@param toggle boolean
function SetAggressiveHorns(toggle) end

---@param type integer
function SetAiGlobalPathNodesType(type) end

---@param modifier number
function SetAiMeleeWeaponDamageModifier(modifier) end

---@param value number
function SetAiWeaponDamageModifier(value) end

---@param value integer
function SetAimCooldown(value) end

---@param player integer
---@param multiplier number
function SetAirDragMultiplierForPlayersVehicle(player, multiplier) end

---@param active boolean
function SetAllLowPriorityVehicleGeneratorsActive(active) end

---@param toggle boolean
function SetAllPathsCacheBoundingstruct(toggle) end

---@param player integer
---@param toggle boolean
function SetAllRandomPedsFlee(player, toggle) end

---@param player integer
function SetAllRandomPedsFleeThisFrame(player) end


function SetAllVehicleGeneratorsActive() end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param p6 boolean
---@param p7 boolean
function SetAllVehicleGeneratorsActiveInArea(x1, y1, z1, x2, y2, z2, p6, p7) end

---@param toggle boolean
function SetAllowAbilityBarInMultiplayer(toggle) end

---@param allow boolean
function SetAllowCommaOnTextInput(allow) end

---@param multiplier number
function SetAmbientPedRangeMultiplierThisFrame(multiplier) end

---@param p0 boolean
function SetAmbientPedsDropMoney(p0) end

---@param range number
function SetAmbientVehicleRangeMultiplierThisFrame(range) end

---@param ped integer
---@param voiceName string
function SetAmbientVoiceName(ped, voiceName) end

---@param ped integer
---@param hash integer | string
function SetAmbientVoiceNameHash(ped, hash) end

---@param zoneListName string
---@param enabled boolean
---@param forceUpdate boolean
function SetAmbientZoneListState(zoneListName, enabled, forceUpdate) end

---@param ambientZone string
---@param enabled boolean
---@param forceUpdate boolean
function SetAmbientZoneListStatePersistent(ambientZone, enabled, forceUpdate) end

---@param zoneName string
---@param enabled boolean
---@param forceUpdate boolean
function SetAmbientZoneState(zoneName, enabled, forceUpdate) end

---@param zoneName string
---@param enabled boolean
---@param forceUpdate boolean
function SetAmbientZoneStatePersistent(zoneName, enabled, forceUpdate) end

---@param ped integer
---@param weaponHash integer | string
---@param ammo integer
---@return boolean
function SetAmmoInClip(ped, weaponHash, ammo) end

---@param vehicle integer
---@param seat integer
---@param ammo integer
---@return boolean
function SetAmmoInVehicleWeaponClip(vehicle, seat, ammo) end

---@param p0 any
---@param p1 boolean
---@param p2 any
---@param p3 boolean
function SetAnimLooped(p0, p1, p2, p3) end

---@param entity integer
---@param p1 number
---@param p2 any
---@param p3 boolean
function SetAnimPhase(entity, p1, p2, p3) end

---@param p0 any
---@param p1 number
---@param p2 any
---@param p3 boolean
function SetAnimRate(p0, p1, p2, p3) end

---@param p0 any
---@param p1 number
---@param p2 any
---@param p3 any
---@param p4 boolean
function SetAnimWeight(p0, p1, p2, p3, p4) end

---@param animal integer
---@param mood integer
function SetAnimalMood(animal, mood) end

---@param state boolean
function SetArtificialLightsState(state) end

---@param toggle boolean
function SetArtificialLightsStateAffectsVehicles(toggle) end

---@param flagName string
---@param toggle boolean
function SetAudioFlag(flagName, toggle) end

---@param scene string
---@param variableName string
---@param value number
function SetAudioSceneVariable(scene, variableName, value) end

---@param timeMs integer
function SetAudioScriptCleanupTime(timeMs) end

---@param mode integer
function SetAudioSpecialEffectMode(mode) end

---@param submixId integer
---@param effectSlot integer
---@param paramIndex integer
---@param paramValue number
function SetAudioSubmixEffectParamFloat(submixId, effectSlot, paramIndex, paramValue) end

---@param submixId integer
---@param effectSlot integer
---@param paramIndex integer
---@param paramValue integer
function SetAudioSubmixEffectParamInt(submixId, effectSlot, paramIndex, paramValue) end

---@param submixId integer
---@param effectSlot integer
function SetAudioSubmixEffectRadioFx(submixId, effectSlot) end

---@param submixId integer
---@param outputSlot integer
---@param frontLeftVolume number
---@param frontRightVolume number
---@param rearLeftVolume number
---@param rearRightVolume number
---@param channel5Volume number
---@param channel6Volume number
function SetAudioSubmixOutputVolumes(submixId, outputSlot, frontLeftVolume, frontRightVolume, rearLeftVolume, rearRightVolume, channel5Volume, channel6Volume) end

---@param vehicle integer
---@param priority integer
function SetAudioVehiclePriority(vehicle, priority) end

---@param player integer
---@param toggle boolean
function SetAutoGiveParachuteWhenEnterPlane(player, toggle) end

---@param player integer
---@param toggle boolean
function SetAutoGiveScubaGearWhenExitVehicle(player, toggle) end

---@param toggle boolean
function SetBackfaceculling(toggle) end

---@param contentId string
---@param contentTypeName string
---@return boolean
function SetBalanceAddMachine(contentId, contentTypeName) end

---@param dataCount integer
---@param contentTypeName string
---@return boolean, any
function SetBalanceAddMachines(dataCount, contentTypeName) end

---@param player integer
function SetBeastModeActive(player) end

---@param toggleBigMap boolean
---@param showFullMap boolean
function SetBigmapActive(toggleBigMap, showFullMap) end

---@param vehicle integer
---@param x number
---@param y number
function SetBikeOnStand(vehicle, x, y) end

---@param name string
---@return integer
function SetBinkMovie(name) end

---@param binkMovie integer
---@param progress number
function SetBinkMovieTime(binkMovie, progress) end

---@param binkMovie integer
---@param p1 boolean
function SetBinkMovieUnk_2(binkMovie, p1) end

---@param binkMovie integer
---@param value number
function SetBinkMovieVolume(binkMovie, value) end

---@param binkMovie integer
---@param shouldSkip boolean
function SetBinkShouldSkip(binkMovie, shouldSkip) end

---@param address integer
---@param offset integer
function SetBit(address, offset) end

---@param rangeStart integer
---@param rangeEnd integer
---@param p3 integer
---@return integer
function SetBitsInRange(rangeStart, rangeEnd, p3) end

---@param blip integer
---@param alpha integer
function SetBlipAlpha(blip, alpha) end

---@param blip integer
---@param toggle boolean
function SetBlipAsFriendly(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipAsMissionCreatorBlip(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipAsShortRange(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipBright(blip, toggle) end

---@param blip integer
---@param index integer
function SetBlipCategory(blip, index) end

---@param blip integer
---@param color integer
function SetBlipColour(blip, color) end

---@param blip integer
---@param posX number
---@param posY number
---@param posZ number
function SetBlipCoords(blip, posX, posY, posZ) end

---@param blip integer
---@param displayId integer
function SetBlipDisplay(blip, displayId) end

---@param blip integer
---@param toggle boolean
function SetBlipDisplayIndicatorOnBlip(blip, toggle) end

---@param blip integer
---@param opacity integer
---@param duration integer
function SetBlipFade(blip, opacity, duration) end

---@param blip integer
---@param interval integer
function SetBlipFlashInterval(blip, interval) end

---@param blip integer
---@param duration integer
function SetBlipFlashTimer(blip, duration) end

---@param blip integer
---@param toggle boolean
function SetBlipFlashes(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipFlashesAlternate(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipHiddenOnLegend(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipHighDetail(blip, toggle) end

---@param blip integer
---@param gxtEntry string
function SetBlipNameFromTextFile(blip, gxtEntry) end

---@param blip integer
---@param player integer
function SetBlipNameToPlayerName(blip, player) end

---@param blip integer
---@param priority integer
function SetBlipPriority(blip, priority) end

---@param blip integer
---@param rotation integer
function SetBlipRotation(blip, rotation) end

---@param blip integer
---@param enabled boolean
function SetBlipRoute(blip, enabled) end

---@param blip integer
---@param colour integer
function SetBlipRouteColour(blip, colour) end

---@param blip integer
---@param scale number
function SetBlipScale(blip, scale) end

---@param blip integer
---@param xScale number
---@param yScale number
function SetBlipScaleTransformation(blip, xScale, yScale) end

---@param blip integer
---@param r integer
---@param g integer
---@param b integer
function SetBlipSecondaryColour(blip, r, g, b) end

---@param blip integer
---@param toggle boolean
function SetBlipShowCone(blip, toggle) end

---@param blip integer
---@param toggle boolean
function SetBlipShrink(blip, toggle) end

---@param blip integer
---@param spriteId integer
function SetBlipSprite(blip, spriteId) end

---@param blip integer
---@param heading number
function SetBlipSquaredRotation(blip, heading) end


function SetBlockAmbientPedsFromDroppingWeaponsThisFrame() end

---@param ped integer
---@param toggle boolean
function SetBlockingOfNonTemporaryEvents(ped, toggle) end

---@param boat integer
---@param toggle boolean
function SetBoatAnchor(boat, toggle) end

---@param vehicle integer
---@param ratio number
function SetBoatBoomPositionRatio(vehicle, ratio) end

---@param vehicle integer
---@param p1 boolean
function SetBoatDisableAvoidance(vehicle, p1) end

---@param vehicle integer
function SetBoatIsSinking(vehicle) end

---@param boat integer
---@param value number
function SetBoatLowLodAnchorDistance(boat, value) end

---@param boat integer
---@param toggle boolean
function SetBoatRemainsAnchoredWhilePlayerIsDriver(boat, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetBoatSinksWhenWrecked(vehicle, toggle) end

---@param waterQuad integer
---@param minX integer
---@param minY integer
---@param maxX integer
---@param maxY integer
---@return boolean
function SetCalmingQuadBounds(waterQuad, minX, minY, maxX, maxY) end

---@param calmingQuad integer
---@param dampening number
---@return boolean
function SetCalmingQuadDampening(calmingQuad, dampening) end

---@param cam integer
---@param active boolean
function SetCamActive(cam, active) end

---@param camTo integer
---@param camFrom integer
---@param duration integer
---@param easeLocation integer
---@param easeRotation integer
function SetCamActiveWithInterp(camTo, camFrom, duration, easeLocation, easeRotation) end

---@param cam integer
---@param toggle boolean
function SetCamAffectsAiming(cam, toggle) end

---@param cam integer
---@param phase number
function SetCamAnimCurrentPhase(cam, phase) end

---@param cam integer
---@param toggle boolean
function SetCamControlsMiniMapHeading(cam, toggle) end

---@param cam integer
---@param posX number
---@param posY number
---@param posZ number
function SetCamCoord(cam, posX, posY, posZ) end

---@param camera integer
---@param name string
function SetCamDebugName(camera, name) end

---@param camera integer
---@param p1 number
function SetCamDofFnumberOfLens(camera, p1) end

---@param camera integer
---@param multiplier number
function SetCamDofFocalLengthMultiplier(camera, multiplier) end

---@param camera integer
---@param p1 number
function SetCamDofFocusDistanceBias(camera, p1) end

---@param camera integer
---@param p1 number
function SetCamDofMaxNearInFocusDistance(camera, p1) end

---@param camera integer
---@param p1 number
function SetCamDofMaxNearInFocusDistanceBlendLevel(camera, p1) end

---@param cam integer
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
function SetCamDofPlanes(cam, p1, p2, p3, p4) end

---@param cam integer
---@param dofStrength number
function SetCamDofStrength(cam, dofStrength) end

---@param p0 integer
function SetCamEffect(p0) end

---@param cam integer
---@param farClip number
function SetCamFarClip(cam, farClip) end

---@param cam integer
---@param farDOF number
function SetCamFarDof(cam, farDOF) end

---@param cam integer
---@param fieldOfView number
function SetCamFov(cam, fieldOfView) end

---@param cam integer
---@param p1 boolean
function SetCamInheritRollVehicle(cam, p1) end

---@param cam integer
---@param strength number
function SetCamMotionBlurStrength(cam, strength) end

---@param cam integer
---@param nearClip number
function SetCamNearClip(cam, nearClip) end

---@param cam integer
---@param nearDOF number
function SetCamNearDof(cam, nearDOF) end

---@param cam integer
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param fieldOfView number
---@param transitionSpeed integer
---@param p9 integer
---@param p10 integer
---@param rotationOrder integer
function SetCamParams(cam, posX, posY, posZ, rotX, rotY, rotZ, fieldOfView, transitionSpeed, p9, p10, rotationOrder) end

---@param cam integer
---@param rotX number
---@param rotY number
---@param rotZ number
---@param rotationOrder integer
function SetCamRot(cam, rotX, rotY, rotZ, rotationOrder) end

---@param cam integer
---@param amplitude number
function SetCamShakeAmplitude(cam, amplitude) end

---@param cam integer
---@param timeDuration integer
function SetCamSplineDuration(cam, timeDuration) end

---@param cam integer
---@param p1 integer
---@param p2 integer
---@param p3 number
function SetCamSplineNodeEase(cam, p1, p2, p3) end

---@param cam integer
---@param p1 integer
---@param flags integer
function SetCamSplineNodeExtraFlags(cam, p1, flags) end

---@param cam integer
---@param p1 integer
---@param scale number
function SetCamSplineNodeVelocityScale(cam, p1, scale) end

---@param cam integer
---@param p1 number
function SetCamSplinePhase(cam, p1) end

---@param cam integer
---@param smoothingStyle integer
function SetCamSplineSmoothingStyle(cam, smoothingStyle) end

---@param cam integer
---@param toggle boolean
function SetCamUseShallowDofMode(cam, toggle) end

---@param context integer
---@param viewMode integer
function SetCamViewModeForContext(context, viewMode) end

---@param vehicle integer
---@param toggle boolean
function SetCamberedWheelsDisabled(vehicle, toggle) end

---@param ped integer
---@param toggle boolean
---@param p2 boolean
function SetCanAttackFriendly(ped, toggle, p2) end

---@param entity integer
---@param toggle boolean
function SetCanAutoVaultOnEntity(entity, toggle) end

---@param entity integer
---@param toggle boolean
function SetCanClimbOnEntity(entity, toggle) end

---@param ped integer
---@param toggle boolean
function SetCanPedEquipAllWeapons(ped, toggle) end

---@param ped integer
---@param weaponHash integer | string
---@param toggle boolean
function SetCanPedEquipWeapon(ped, weaponHash, toggle) end

---@param vehicle integer
---@param state boolean
function SetCanResprayVehicle(vehicle, state) end

---@param vehicle integer
function SetCarBootOpen(vehicle) end

---@param multiplier number
function SetCarHighSpeedBumpSeverityMultiplier(multiplier) end

---@param cargobob integer
---@param entity integer
function SetCargobobExcludeFromPickupEntity(cargobob, entity) end

---@param cargobob integer
---@param toggle boolean
function SetCargobobForceDontDetachVehicle(cargobob, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetCargobobHookCanAttach(vehicle, toggle) end

---@param cargobob integer
---@param isActive boolean
function SetCargobobPickupMagnetActive(cargobob, isActive) end

---@param vehicle integer
---@param p1 number
function SetCargobobPickupMagnetEffectRadius(vehicle, p1) end

---@param vehicle integer
---@param p1 number
function SetCargobobPickupMagnetFalloff(vehicle, p1) end

---@param cargobob integer
---@param p1 number
function SetCargobobPickupMagnetPullRopeLength(cargobob, p1) end

---@param cargobob integer
---@param p1 number
function SetCargobobPickupMagnetPullStrength(cargobob, p1) end

---@param cargobob integer
---@param p1 number
function SetCargobobPickupMagnetReducedFalloff(cargobob, p1) end

---@param cargobob integer
---@param vehicle integer
function SetCargobobPickupMagnetReducedStrength(cargobob, vehicle) end

---@param cargobob integer
---@param strength number
function SetCargobobPickupMagnetStrength(cargobob, strength) end

---@param cargobob integer
---@param p1 number
function SetCargobobPickupRopeDampingMultiplier(cargobob, p1) end

---@param vehicle integer
---@param state integer
function SetCargobobPickupRopeType(vehicle, state) end

---@param entity integer
function SetCgAtBoundcenter(entity) end

---@param entity integer
---@param x number
---@param y number
---@param z number
function SetCgoffset(entity, x, y, z) end

---@param checkpoint integer
---@param nearHeight number
---@param farHeight number
---@param radius number
function SetCheckpointCylinderHeight(checkpoint, nearHeight, farHeight, radius) end

---@param checkpoint integer
---@param height_multiplier number
function SetCheckpointIconHeight(checkpoint, height_multiplier) end

---@param checkpoint integer
---@param scale number
function SetCheckpointIconScale(checkpoint, scale) end

---@param checkpoint integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function SetCheckpointRgba(checkpoint, red, green, blue, alpha) end

---@param checkpoint integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function SetCheckpointRgba2(checkpoint, red, green, blue, alpha) end

---@param p0 boolean
function SetCinematicButtonActive(p0) end

---@param p0 number
function SetCinematicCamShakeAmplitude(p0) end

---@param toggle boolean
function SetCinematicModeActive(toggle) end


function SetCinematicNewsChannelActiveThisUpdate() end

---@param flagIndex integer
---@param enabled boolean
function SetClientConfigBool(flagIndex, enabled) end

---@param day integer
---@param month integer
---@param year integer
function SetClockDate(day, month, year) end

---@param hour integer
---@param minute integer
---@param second integer
function SetClockTime(hour, minute, second) end

---@param overrideSettingsName string
function SetCloudSettingsOverride(overrideSettingsName) end

---@param opacity number
function SetCloudsAlpha(opacity) end

---@param hudColor integer
function SetColourOfNextTextComponent(hudColor) end

---@param ped integer
---@param combatType integer
---@param p2 number
function SetCombatFloat(ped, combatType, p2) end

---@param padIndex integer
---@param red integer
---@param green integer
---@param blue integer
function SetControlLightEffectColor(padIndex, red, green, blue) end

---@param padIndex integer
---@param control integer
---@param amount number
---@return boolean
function SetControlNormal(padIndex, control, amount) end

---@param enable boolean
function SetConversationAudioControlledByAnim(enable) end

---@param isPlaceHolder boolean
function SetConversationAudioPlaceholder(isPlaceHolder) end

---@param vehicle integer
---@param toggle boolean
function SetConvertibleRoof(vehicle, toggle) end

---@param vehicle integer
---@param bLatched boolean
function SetConvertibleRoofLatchState(vehicle, bLatched) end

---@param toggle boolean
function SetCreateRandomCops(toggle) end

---@param toggle boolean
function SetCreateRandomCopsNotOnScenarios(toggle) end

---@param toggle boolean
function SetCreateRandomCopsOnScenarios(toggle) end

---@param object integer
---@param toggle boolean
function SetCreateWeaponObjectLightSource(object, toggle) end

---@param toggle boolean
function SetCreditsActive(toggle) end

---@param ped integer
---@param weaponHash integer | string
---@return boolean
function SetCurrentPedVehicleWeapon(ped, weaponHash) end

---@param ped integer
---@param weaponHash integer | string
---@param bForceInHand boolean
function SetCurrentPedWeapon(ped, weaponHash, bForceInHand) end

---@param modifierName string
function SetCurrentPlayerTcmodifier(modifierName) end

---@param x number
---@param y number
---@return boolean
function SetCursorLocation(x, y) end

---@param hudColorId integer
function SetCustomMpHudColor(hudColorId) end

---@param radioStation string
---@param trackListName string
---@param forceNow boolean
function SetCustomRadioTrackList(radioStation, trackListName, forceNow) end

---@param name string
function SetCutsceneAudioOverride(name) end

---@param p0 boolean
function SetCutsceneCanBeSkipped(p0) end

---@param cutsceneEntName string
---@param p1 integer
---@param p2 integer
function SetCutsceneEntityStreamingFlags(cutsceneEntName, p1, p2) end

---@param p0 boolean
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
function SetCutsceneFadeValues(p0, p1, p2, p3) end

---@param x number
---@param y number
---@param z number
---@param heading number
---@param p4 integer
function SetCutsceneOrigin(x, y, z, heading, p4) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param p6 integer
function SetCutsceneOriginAndOrientation(x1, y1, z1, x2, y2, z2, p6) end

---@param cutsceneEntName string
---@param componentId integer
---@param drawableId integer
---@param textureId integer
---@param modelHash integer | string
function SetCutscenePedComponentVariation(cutsceneEntName, componentId, drawableId, textureId, modelHash) end

---@param cutsceneEntName string
---@param ped integer
---@param modelHash integer | string
function SetCutscenePedComponentVariationFromPed(cutsceneEntName, ped, modelHash) end

---@param cutsceneEntName string
---@param componentId integer
---@param drawableId integer
---@param textureId integer
---@param modelHash integer | string
function SetCutscenePedPropVariation(cutsceneEntName, componentId, drawableId, textureId, modelHash) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
function SetCutsceneTriggerArea(p0, p1, p2, p3, p4, p5) end

---@param entity integer
---@param vertex integer
---@param value number
function SetDamping(entity, vertex, value) end

---@param enabled boolean
function SetDebugLinesAndSpheresDrawingActive(enabled) end

---@param ped integer
---@param name integer | string
function SetDecisionMaker(ped, name) end

---@param intensity number
function SetDeepOceanScaler(intensity) end

---@param plateIndex integer
---@param pattern string
function SetDefaultVehicleNumberPlateTextPattern(plateIndex, pattern) end

---@param vehicle integer
---@param deploy boolean
---@param p2 boolean
function SetDeployHeliStubWings(vehicle, deploy, p2) end


function SetDirectorModeClearTriggeredFlag() end

---@param player integer
---@param toggle boolean
function SetDisableAmbientMeleeMove(player, toggle) end

---@param disableExtraTrickForces boolean
function SetDisableBmxExtraTrickForces(disableExtraTrickForces) end

---@param object integer
---@param toggle boolean
function SetDisableBreaking(object, toggle) end


function SetDisableDecalRenderingThisFrame() end

---@param vehicle integer
---@param disableExplode boolean
function SetDisableExplodeFromBodyDamageOnCollision(vehicle, disableExplode) end

---@param plane integer
---@param disable boolean
function SetDisableExplodeFromBodyDamageReceivedByAiVehicle(plane, disable) end

---@param object integer
---@param toggle boolean
function SetDisableFragDamage(object, toggle) end

---@param helicopter integer
---@param disableExplode boolean
function SetDisableHeliExplodeFromBodyDamage(helicopter, disableExplode) end

---@param vehicle integer
---@param toggle boolean
function SetDisableHoverModeFlight(vehicle, toggle) end


function SetDisablePetrolDecalsIgnitingThisFrame() end

---@param vehicle integer
---@param toggle boolean
function SetDisablePretendOccupants(vehicle, toggle) end

---@param toggle boolean
function SetDisableRandomTrainsThisFrame(toggle) end

---@param vehicle integer
---@param p1 boolean
function SetDisableSuperdummyMode(vehicle, p1) end

---@param vehicle integer
---@param turretIdx integer
function SetDisableTurretMovementThisFrame(vehicle, turretIdx) end

---@param vehicle integer
---@param toggle boolean
function SetDisableVehicleEngineFires(vehicle, toggle) end

---@param vehicle integer
---@param direction boolean
function SetDisableVehicleFlightNozzlePosition(vehicle, direction) end

---@param vehicle integer
---@param toggle boolean
function SetDisableVehiclePetrolTankDamage(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetDisableVehiclePetrolTankFires(vehicle, toggle) end

---@param toggle boolean
function SetDisableVehicleUnk(toggle) end

---@param toggle boolean
function SetDisableVehicleUnk_2(toggle) end

---@param vehicle integer
---@param toggle boolean
function SetDisableVehicleWindowCollisions(vehicle, toggle) end

---@param appId string
function SetDiscordAppId(appId) end

---@param index integer
---@param label string
---@param url string
function SetDiscordRichPresenceAction(index, label, url) end

---@param assetName string
function SetDiscordRichPresenceAsset(assetName) end

---@param assetName string
function SetDiscordRichPresenceAssetSmall(assetName) end

---@param text string
function SetDiscordRichPresenceAssetSmallText(text) end

---@param text string
function SetDiscordRichPresenceAssetText(text) end

---@param player integer
---@param toggle boolean
function SetDispatchCopsForPlayer(player, toggle) end

---@param p0 number
function SetDispatchIdealSpawnDistance(p0) end

---@param x number
---@param y number
---@param z number
function SetDispatchSpawnLocation(x, y, z) end

---@param p0 any
---@param p1 number
function SetDispatchTimeBetweenSpawnAttempts(p0, p1) end

---@param p0 any
---@param p1 number
function SetDispatchTimeBetweenSpawnAttemptsMultiplier(p0, p1) end

---@param toggle boolean
function SetDistantCarsEnabled(toggle) end

---@param toggle boolean
function SetDitchPoliceModels(toggle) end

---@param x number
---@param y number
---@param z number
---@param is2d boolean
function SetDrawOrigin(x, y, z, is2d) end

---@param vehicle integer
---@param toggle boolean
function SetDriftTyresEnabled(vehicle, toggle) end

---@param driver integer
---@param cruiseSpeed number
function SetDriveTaskCruiseSpeed(driver, cruiseSpeed) end

---@param ped integer
---@param drivingStyle integer
function SetDriveTaskDrivingStyle(ped, drivingStyle) end

---@param p0 any
---@param p1 number
function SetDriveTaskMaxCruiseSpeed(p0, p1) end

---@param shootingPed integer
---@param targetPed integer
---@param targetVehicle integer
---@param x number
---@param y number
---@param z number
function SetDrivebyTaskTarget(shootingPed, targetPed, targetVehicle, x, y, z) end

---@param driver integer
---@param ability number
function SetDriverAbility(driver, ability) end

---@param driver integer
---@param aggressiveness number
function SetDriverAggressiveness(driver, aggressiveness) end

---@param driver integer
---@param modifier number
function SetDriverRacingModifier(driver, modifier) end

---@param duiObject integer
---@param url string
function SetDuiUrl(duiObject, url) end

---@param probeLength number
function SetEmitterProbeLength(probeLength) end

---@param emitterName string
---@param radioStation string
function SetEmitterRadioStation(emitterName, radioStation) end

---@param entity integer
---@param toggle boolean
---@param p2 integer
function SetEnableArenaPropPhysics(entity, toggle, p2) end

---@param entity integer
---@param toggle boolean
---@param p2 integer
---@param ped integer
function SetEnableArenaPropPhysicsOnPed(entity, toggle, p2, ped) end

---@param ped integer
---@param toggle boolean
function SetEnableBoundAnkles(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetEnableHandcuffs(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetEnablePedEnveffScale(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetEnableScuba(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetEnableScubaGearLight(ped, toggle) end

---@param toggle boolean
function SetEnableVehicleSlipstreaming(toggle) end

---@param entity integer
---@param alphaLevel integer
---@param skin boolean
function SetEntityAlpha(entity, alphaLevel, skin) end

---@param entity integer
---@param toggle boolean
function SetEntityAlwaysPrerender(entity, toggle) end

---@param entity integer
---@param x number
---@param y number
---@param z number
function SetEntityAngularVelocity(entity, x, y, z) end

---@param entity integer
---@param animDictionary string
---@param animName string
---@param time number
function SetEntityAnimCurrentTime(entity, animDictionary, animName, time) end

---@param entity integer
---@param animDictionary string
---@param animName string
---@param speedMultiplier number
function SetEntityAnimSpeed(entity, animDictionary, animName, speedMultiplier) end

---@param entity integer
---@param scriptHostObject boolean
---@param bGrabFromOtherScript boolean
function SetEntityAsMissionEntity(entity, scriptHostObject, bGrabFromOtherScript) end

---@param entity integer
function SetEntityAsNoLongerNeeded(entity) end

---@param entity integer
---@param toggle boolean
function SetEntityCanBeDamaged(entity, toggle) end

---@param entity integer
---@param bCanBeDamaged boolean
---@param relGroup integer
function SetEntityCanBeDamagedByRelationshipGroup(entity, bCanBeDamaged, relGroup) end

---@param entity integer
---@param toggle boolean
function SetEntityCanBeTargetedWithoutLos(entity, toggle) end

---@param entity integer
---@param toggle boolean
function SetEntityCleanupByEngine(entity, toggle) end

---@param entity integer
---@param toggle boolean
---@param keepPhysics boolean
function SetEntityCollision(entity, toggle, keepPhysics) end

---@param entity integer
---@param toggle boolean
---@param keepPhysics boolean
function SetEntityCompletelyDisableCollision(entity, toggle, keepPhysics) end

---@param entity integer
---@param xPos number
---@param yPos number
---@param zPos number
---@param alive boolean
---@param deadFlag boolean
---@param ragdollFlag boolean
---@param clearArea boolean
function SetEntityCoords(entity, xPos, yPos, zPos, alive, deadFlag, ragdollFlag, clearArea) end

---@param entity integer
---@param x number
---@param y number
---@param z number
---@param keepTasks boolean
---@param keepIK boolean
---@param doWarp boolean
function SetEntityCoordsNoOffset(entity, x, y, z, keepTasks, keepIK, doWarp) end

---@param entity integer
---@param xPos number
---@param yPos number
---@param zPos number
---@param alive boolean
---@param deadFlag boolean
---@param ragdollFlag boolean
---@param clearArea boolean
function SetEntityCoordsWithoutPlantsReset(entity, xPos, yPos, zPos, alive, deadFlag, ragdollFlag, clearArea) end

---@param entity integer
---@param p1 boolean
function SetEntityDecalsDisabled(entity, p1) end

---@param entity integer
---@param enabled boolean
function SetEntityDrawOutline(entity, enabled) end

---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function SetEntityDrawOutlineColor(red, green, blue, alpha) end

---@param techniqueGroup string
function SetEntityDrawOutlineRenderTechnique(techniqueGroup) end

---@param shader integer
function SetEntityDrawOutlineShader(shader) end

---@param entity integer
---@param toggle boolean
function SetEntityDynamic(entity, toggle) end

---@param speakerConversationIndex integer
---@param entity integer
function SetEntityForNullConvPed(speakerConversationIndex, entity) end

---@param entity integer
---@param toggle boolean
function SetEntityHasGravity(entity, toggle) end

---@param entity integer
---@param heading number
function SetEntityHeading(entity, heading) end

---@param entity integer
---@param health integer
function SetEntityHealth(entity, health) end

---@param entity integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function SetEntityIconColor(entity, red, green, blue, alpha) end

---@param entity integer
---@param toggle boolean
function SetEntityIconVisibility(entity, toggle) end

---@param entity integer
---@param toggle boolean
function SetEntityInvincible(entity, toggle) end

---@param entity integer
---@param p1 boolean
---@param p2 number
function SetEntityIsTargetPriority(entity, p1, p2) end

---@param entity integer
---@param toggle boolean
function SetEntityLights(entity, toggle) end

---@param entity integer
---@param toggle boolean
function SetEntityLoadCollisionFlag(entity, toggle) end

---@param entity integer
function SetEntityLocallyInvisible(entity) end

---@param entity integer
function SetEntityLocallyVisible(entity) end

---@param entity integer
---@param value integer
function SetEntityLodDist(entity, value) end

---@param entity integer
---@param forwardX number
---@param forwardY number
---@param forwardZ number
---@param rightX number
---@param rightY number
---@param rightZ number
---@param upX number
---@param upY number
---@param upZ number
---@param atX number
---@param atY number
---@param atZ number
function SetEntityMatrix(entity, forwardX, forwardY, forwardZ, rightX, rightY, rightZ, upX, upY, upZ, atX, atY, atZ) end

---@param entity integer
---@param value integer
function SetEntityMaxHealth(entity, value) end

---@param entity integer
---@param speed number
function SetEntityMaxSpeed(entity, speed) end

---@param entity integer
---@param toggle boolean
function SetEntityMotionBlur(entity, toggle) end

---@param entity1 integer
---@param entity2 integer
---@param thisFrameOnly boolean
function SetEntityNoCollisionEntity(entity1, entity2, thisFrameOnly) end

---@param entity1 integer
---@param entity2 integer
function SetEntityNoCollisionWithNetworkedEntity(entity1, entity2) end

---@param entity integer
---@param toggle boolean
function SetEntityOnlyDamagedByPlayer(entity, toggle) end

---@param entity integer
---@param p1 boolean
---@param relationshipHash integer | string
function SetEntityOnlyDamagedByRelationshipGroup(entity, p1, relationshipHash) end

---@param entity integer
---@param toggle boolean
function SetEntityProofUnk(entity, toggle) end

---@param entity integer
---@param bulletProof boolean
---@param fireProof boolean
---@param explosionProof boolean
---@param collisionProof boolean
---@param meleeProof boolean
---@param steamProof boolean
---@param p7 boolean
---@param drownProof boolean
function SetEntityProofs(entity, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof) end

---@param entity integer
---@param x number
---@param y number
---@param z number
---@param w number
function SetEntityQuaternion(entity, x, y, z, w) end

---@param entity integer
---@param toggle boolean
function SetEntityRecordsCollisions(entity, toggle) end

---@param entity integer
---@param toggle boolean
function SetEntityRenderScorched(entity, toggle) end

---@param entity integer
---@param toggle boolean
function SetEntityRequiresMoreExpensiveRiverCheck(entity, toggle) end

---@param entity integer
---@param pitch number
---@param roll number
---@param yaw number
---@param rotationOrder integer
---@param bDeadCheck boolean
function SetEntityRotation(entity, pitch, roll, yaw, rotationOrder, bDeadCheck) end

---@param entity integer
---@param state integer
function SetEntityTrafficlightOverride(entity, state) end

---@param entity integer
---@param x number
---@param y number
---@param z number
function SetEntityVelocity(entity, x, y, z) end

---@param entity integer
---@param toggle boolean
---@param unk boolean
function SetEntityVisible(entity, toggle, unk) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function SetEntityVisibleInCutscene(p0, p1, p2) end

---@param player integer
---@param toggle boolean
function SetEveryoneIgnorePlayer(player, toggle) end

---@param scenarioGroup string
function SetExclusiveScenarioGroup(scenarioGroup) end

---@param player integer
function SetExplosiveAmmoThisFrame(player) end

---@param player integer
function SetExplosiveMeleeThisFrame(player) end

---@param modifierName string
function SetExtraTimecycleModifier(modifierName) end

---@param ped integer
---@param animDict string
function SetFacialClipsetOverride(ped, animDict) end

---@param ped integer
---@param animName string
---@param animDict string
function SetFacialIdleAnimOverride(ped, animName, animDict) end

---@param toggle boolean
function SetFadeInAfterDeathArrest(toggle) end

---@param toggle boolean
function SetFadeInAfterLoad(toggle) end

---@param toggle boolean
function SetFadeOutAfterArrest(toggle) end

---@param toggle boolean
function SetFadeOutAfterDeath(toggle) end

---@param x number
---@param y number
function SetFakePausemapPlayerPositionThisFrame(x, y) end

---@param fakeWantedLevel integer
function SetFakeWantedLevel(fakeWantedLevel) end

---@param multiplier number
function SetFallDamageLandOnFootMultiplier(multiplier) end

---@param multiplier number
function SetFallDamageMultiplier(multiplier) end

---@param toggle boolean
function SetFarDrawVehicles(toggle) end

---@param player integer
function SetFireAmmoThisFrame(player) end

---@param p0 number
function SetFireSpreadRate(p0) end

---@param distance number
function SetFirstPersonAimCamNearClipThisUpdate(distance) end

---@param zoomFactor number
function SetFirstPersonAimCamZoomFactor(zoomFactor) end

---@param minAngle number
---@param maxAngle number
function SetFirstPersonCamPitchRange(minAngle, maxAngle) end

---@param p0 number
---@param p1 number
---@param fadeIn number
---@param duration number
---@param fadeOut number
function SetFlash(p0, p1, fadeIn, duration, fadeOut) end

---@param ped integer
---@param toggle boolean
function SetFlashLightEnabled(ped, toggle) end

---@param distance number
---@return any
function SetFlashLightFadeDistance(distance) end

---@param state boolean
function SetFlashLightKeepOnWhileMoving(state) end

---@param hudIndex integer
---@param x number
---@param y number
function SetFloatingHelpTextScreenPosition(hudIndex, x, y) end

---@param hudIndex integer
---@param style integer
---@param hudColor integer
---@param alpha integer
---@param arrowPosition integer
---@param boxOffset integer
function SetFloatingHelpTextStyle(hudIndex, style, hudColor, alpha, arrowPosition, boxOffset) end

---@param hudIndex integer
---@param entity integer
---@param offsetX number
---@param offsetY number
function SetFloatingHelpTextToEntity(hudIndex, entity, offsetX, offsetY) end

---@param hudIndex integer
---@param x number
---@param y number
---@param z number
function SetFloatingHelpTextWorldPosition(hudIndex, x, y, z) end

---@param cam integer
---@param x number
---@param y number
---@param z number
function SetFlyCamCoordAndConstrain(cam, x, y, z) end

---@param cam integer
---@param p1 number
---@param p2 number
---@param p3 number
function SetFlyCamHorizontalResponse(cam, p1, p2, p3) end

---@param cam integer
---@param height number
function SetFlyCamMaxHeight(cam, height) end

---@param cam integer
---@param p1 number
---@param p2 number
---@param p3 number
function SetFlyCamVerticalSpeedMultiplier(cam, p1, p2, p3) end

---@param vehMinSpeed number
---@param unkMinSpeed number
---@param unkModifier number
---@param minDamage number
---@return boolean
function SetFlyThroughWindscreenParams(vehMinSpeed, unkMinSpeed, unkModifier, minDamage) end

---@param entity integer
function SetFocusEntity(entity) end

---@param x number
---@param y number
---@param z number
---@param offsetX number
---@param offsetY number
---@param offsetZ number
function SetFocusPosAndVel(x, y, z, offsetX, offsetY, offsetZ) end

---@param state boolean
function SetFogVolumeRenderDisabled(state) end

---@param camName string
---@param easeTime integer
---@return boolean
function SetFollowPedCamThisUpdate(camName, easeTime) end

---@param viewMode integer
function SetFollowPedCamViewMode(viewMode) end

---@param seatIndex integer
function SetFollowTurretSeatCam(seatIndex) end

---@param viewMode integer
function SetFollowVehicleCamViewMode(viewMode) end

---@param zoomLevel integer
function SetFollowVehicleCamZoomLevel(zoomLevel) end

---@param ped integer
---@param toggle boolean
function SetForceFootstepUpdate(ped, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetForceHdVehicle(vehicle, toggle) end

---@param boat integer
---@param toggle boolean
function SetForceLowLodAnchorMode(boat, toggle) end

---@param x number
---@param y number
---@param z number
---@param p3 number
function SetForceObjectThisFrame(x, y, z, p3) end

---@param toggle boolean
function SetForcePedFootstepsTracks(toggle) end

---@param player integer
function SetForcePlayerToJump(player) end

---@param ped integer
---@param p1 boolean
---@param type integer
---@param p3 integer
function SetForceStepType(ped, p1, type, p3) end

---@param toggle boolean
function SetForceVehicleTrails(toggle) end

---@param vehicle integer
---@param height number
function SetForkliftForkHeight(vehicle, height) end

---@param active boolean
function SetFrontendActive(active) end

---@param active boolean
function SetFrontendRadioActive(active) end

---@param multiplier number
function SetFuelConsumptionRateMultiplier(multiplier) end

---@param state boolean
function SetFuelConsumptionState(state) end

---@param toggle boolean
function SetGamePaused(toggle) end

---@param toggle boolean
function SetGamePausesForStreaming(toggle) end

---@param ped integer
function SetGameplayCamFollowPedThisUpdate(ped) end

---@param camName string
function SetGameplayCamHash(camName) end

---@param pitch number
function SetGameplayCamRawPitch(pitch) end

---@param yaw number
function SetGameplayCamRawYaw(yaw) end

---@param heading number
function SetGameplayCamRelativeHeading(heading) end

---@param angle number
---@param scalingFactor number
function SetGameplayCamRelativePitch(angle, scalingFactor) end

---@param roll number
---@param pitch number
---@param yaw number
function SetGameplayCamRelativeRotation(roll, pitch, yaw) end

---@param amplitude number
function SetGameplayCamShakeAmplitude(amplitude) end

---@param vehicleName string
function SetGameplayCamVehicleCamera(vehicleName) end

---@param vehicleModel integer | string
function SetGameplayCamVehicleCameraName(vehicleModel) end

---@param x number
---@param y number
---@param z number
---@param duration integer
---@param blendOutDuration integer
---@param blendInDuration integer
---@param unk integer
function SetGameplayCoordHint(x, y, z, duration, blendOutDuration, blendInDuration, unk) end

---@param entity integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param p4 boolean
---@param p5 integer
---@param p6 integer
---@param p7 integer
---@param p8 any
function SetGameplayEntityHint(entity, xOffset, yOffset, zOffset, p4, p5, p6, p7, p8) end

---@param toggle boolean
function SetGameplayHintAnimCloseup(toggle) end

---@param xOffset number
function SetGameplayHintAnimOffsetx(xOffset) end

---@param yOffset number
function SetGameplayHintAnimOffsety(yOffset) end

---@param value number
function SetGameplayHintBaseOrbitPitchOffset(value) end

---@param value number
function SetGameplayHintFollowDistanceScalar(value) end

---@param FOV number
function SetGameplayHintFov(FOV) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 boolean
---@param p5 any
---@param p6 any
---@param p7 any
function SetGameplayObjectHint(p0, p1, p2, p3, p4, p5, p6, p7) end

---@param p0 integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param p4 boolean
---@param duration integer
---@param blendOutDuration integer
---@param blendInDuration integer
function SetGameplayPedHint(p0, x1, y1, z1, p4, duration, blendOutDuration, blendInDuration) end

---@param vehicle integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param p4 boolean
---@param time integer
---@param easeInTime integer
---@param easeOutTime integer
function SetGameplayVehicleHint(vehicle, offsetX, offsetY, offsetZ, p4, time, easeInTime, easeOutTime) end

---@param toggle boolean
function SetGarbageTrucks(toggle) end

---@param alpha integer
function SetGhostedEntityAlpha(alpha) end

---@param height number
function SetGlobalMinBirdFlightHeight(height) end

---@param massMul number
function SetGlobalPassengerMassMultiplier(massMul) end

---@param signalLevel number
function SetGlobalRadioSignalLevel(signalLevel) end

---@param active boolean
function SetGpsActive(active) end

---@param toggle boolean
---@param radarThickness integer
---@param mapThickness integer
function SetGpsCustomRouteRender(toggle, radarThickness, mapThickness) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
function SetGpsDisabledZone(x1, y1, z1, x2, y2, z2) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param index integer
function SetGpsDisabledZoneAtIndex(x1, y1, z1, x2, y2, z2, index) end

---@param p0 integer
---@param p1 number
function SetGpsFlags(p0, p1) end

---@param toggle boolean
function SetGpsFlashes(toggle) end

---@param toggle boolean
function SetGpsMultiRouteRender(toggle) end

---@param level integer
function SetGravityLevel(level) end

---@param groupId integer
---@param formationType integer
function SetGroupFormation(groupId, formationType) end

---@param groupId integer
---@param p1 number
---@param p2 number
---@param p3 number
function SetGroupFormationSpacing(groupId, p1, p2, p3) end

---@param groupHandle integer
---@param separationRange number
function SetGroupSeparationRange(groupHandle, separationRange) end

---@param toggle boolean
function SetHandleRockstarMessageViaScript(toggle) end

---@param vehicle string
---@param class_ string
---@param fieldName string
---@param value any
function SetHandlingField(vehicle, class_, fieldName, value) end

---@param vehicle string
---@param class_ string
---@param fieldName string
---@param value number
function SetHandlingFloat(vehicle, class_, fieldName, value) end

---@param vehicle string
---@param class_ string
---@param fieldName string
---@param value integer
function SetHandlingInt(vehicle, class_, fieldName, value) end

---@param vehicle string
---@param class_ string
---@param fieldName string
---@param value vector3
function SetHandlingVector(vehicle, class_, fieldName, value) end

---@param value integer
function SetHasContentUnlocksFlags(value) end

---@param x number
---@param y number
---@param z number
---@param radius number
function SetHdArea(x, y, z, radius) end

---@param ped integer
---@param r integer
---@param g integer
---@param b integer
---@param id integer
function SetHeadBlendPaletteColor(ped, r, g, b, id) end

---@param configName string
---@param newValue number
function SetHealthConfigDefaultArmor(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigDefaultEndurance(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigDefaultHealth(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigDogTakedownThreshold(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigDyingThreshold(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigFatiguedThreshold(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigHurtThreshold(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigInjuredThreshold(configName, newValue) end

---@param configName string
---@param newValue boolean
function SetHealthConfigInvincible(configName, newValue) end

---@param configName string
---@param newValue boolean
function SetHealthConfigMeleeFatalAttack(configName, newValue) end

---@param configName string
---@param newValue number
function SetHealthConfigWritheFromBulletThreshold(configName, newValue) end

---@param health integer
---@param capacity integer
---@param wasAdded boolean
function SetHealthHudDisplayValues(health, capacity, wasAdded) end

---@param vehicle integer
function SetHeliBladesFullSpeed(vehicle) end

---@param vehicle integer
---@param speed number
function SetHeliBladesSpeed(vehicle, speed) end

---@param vehicle integer
---@param x number
---@param y number
---@param z number
function SetHeliCombatOffset(vehicle, x, y, z) end

---@param vehicle integer
---@param health number
function SetHeliMainRotorHealth(vehicle, health) end

---@param helicopter integer
---@param bResistToExplosion boolean
function SetHeliResistToExplosion(helicopter, bResistToExplosion) end

---@param heli integer
---@param toggle boolean
function SetHeliTailBoomCanBreakOff(heli, toggle) end

---@param vehicle integer
---@param health number
function SetHeliTailRotorHealth(vehicle, health) end

---@param vehicle integer
---@param p1 number
function SetHeliTurbulenceScalar(vehicle, p1) end

---@param helicopter integer
---@param multiplier number
function SetHelicopterRollPitchYawMult(helicopter, multiplier) end

---@param style integer
---@param hudColor integer
---@param alpha integer
---@param p3 integer
---@param p4 integer
function SetHelpMessageTextStyle(style, hudColor, alpha, p3, p4) end

---@param p0 boolean
---@param p1 boolean
---@param nearplaneOut number
---@param nearplaneIn number
---@param farplaneOut number
---@param farplaneIn number
function SetHidofOverride(p0, p1, nearplaneOut, nearplaneIn, farplaneOut, farplaneIn) end

---@param ped integer
---@param duration any
---@param p2 any
---@param p3 any
function SetHighFallTask(ped, duration, p2, p3) end

---@param vehicle integer
---@param toggle boolean
function SetHornEnabled(vehicle, toggle) end

---@param vehicle integer
---@param time number
function SetHornPermanentlyOnTime(vehicle, time) end

---@param vehicle integer
---@param ratio number
function SetHoverModeWingRatio(vehicle, ratio) end

---@param id integer
---@param horizontalAlign integer
---@param verticalAlign integer
function SetHudComponentAlign(id, horizontalAlign, verticalAlign) end

---@param id integer
---@param x number
---@param y number
function SetHudComponentPosition(id, x, y) end

---@param id integer
---@param x number
---@param y number
function SetHudComponentSize(id, x, y) end

---@param vehicle integer
---@param toggle boolean
function SetHydraulicRaised(vehicle, toggle) end

---@param vehicle integer
---@param state integer
function SetHydraulicWheelState(vehicle, state) end

---@param vehicle integer
---@param wheelId integer
---@param state integer
---@param value number
---@param p4 number
function SetHydraulicWheelStateTransition(vehicle, wheelId, state, value, p4) end

---@param vehicle integer
---@param wheelId integer
---@param value number
function SetHydraulicWheelValue(vehicle, wheelId, value) end

---@param player integer
---@param toggle boolean
function SetIgnoreLowPriorityShockingEvents(player, toggle) end

---@param toggle boolean
function SetIgnoreNoGpsFlag(toggle) end

---@param toggle boolean
function SetIgnoreSecondaryRouteNodes(toggle) end

---@param ignore boolean
function SetIgnoreVehicleOwnershipForStowing(ignore) end

---@param ped integer
---@param ikIndex integer
---@param entityLookAt integer
---@param boneLookAt integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param ikTargetFlags integer
---@param blendInDuration integer
---@param blendOutDuration integer
function SetIkTarget(ped, ikIndex, entityLookAt, boneLookAt, offsetX, offsetY, offsetZ, ikTargetFlags, blendInDuration, blendOutDuration) end

---@param p0 integer
---@param p1 integer
function SetInVehicleCamStateThisUpdate(p0, p1) end

---@param incidentId integer
---@param dispatchService integer
---@param numUnits integer
function SetIncidentRequestedUnits(incidentId, dispatchService, numUnits) end

---@param incidentId integer
---@param p1 number
function SetIncidentUnk(incidentId, p1) end

---@param radioStation string
function SetInitialPlayerStation(radioStation) end

---@param padIndex integer
---@param control integer
function SetInputExclusive(padIndex, control) end

---@param flag integer
function SetInstancePriorityHint(flag) end

---@param toggle integer
function SetInstancePriorityMode(toggle) end

---@param interiorID integer
---@param toggle boolean
function SetInteriorActive(interiorID, toggle) end

---@param interior integer
---@param entitySetName string
---@param color integer
function SetInteriorEntitySetColor(interior, entitySetName, color) end

---@param interiorId integer
---@param portalIndex integer
---@param cornerIndex integer
---@param posX number
---@param posY number
---@param posZ number
function SetInteriorPortalCornerPosition(interiorId, portalIndex, cornerIndex, posX, posY, posZ) end

---@param interiorId integer
---@param portalIndex integer
---@param entityIndex integer
---@param flag integer
function SetInteriorPortalEntityFlag(interiorId, portalIndex, entityIndex, flag) end

---@param interiorId integer
---@param portalIndex integer
---@param flag integer
function SetInteriorPortalFlag(interiorId, portalIndex, flag) end

---@param interiorId integer
---@param portalIndex integer
---@param roomFrom integer
function SetInteriorPortalRoomFrom(interiorId, portalIndex, roomFrom) end

---@param interiorId integer
---@param portalIndex integer
---@param roomTo integer
function SetInteriorPortalRoomTo(interiorId, portalIndex, roomTo) end

---@param probeLength number
function SetInteriorProbeLength(probeLength) end

---@param interiorId integer
---@param roomIndex integer
---@param bbMinX number
---@param bbMinY number
---@param bbMinZ number
---@param bbMaxX number
---@param bbMaxY number
---@param bbMaxZ number
function SetInteriorRoomExtents(interiorId, roomIndex, bbMinX, bbMinY, bbMinZ, bbMaxX, bbMaxY, bbMaxZ) end

---@param interiorId integer
---@param roomIndex integer
---@param flag integer
function SetInteriorRoomFlag(interiorId, roomIndex, flag) end

---@param interiorId integer
---@param roomIndex integer
---@param timecycleHash integer
function SetInteriorRoomTimecycle(interiorId, roomIndex, timecycleHash) end

---@param toggle boolean
function SetInteriorZoomLevelDecreased(toggle) end

---@param toggle boolean
function SetInteriorZoomLevelIncreased(toggle) end

---@param islandName string
---@param toggle boolean
function SetIslandEnabled(islandName, toggle) end

---@param hide boolean
function SetKeyMappingHideResources(hide) end

---@param height number
function SetKillFallHeight(height) end

---@param vehicle integer
function SetLastDrivenVehicle(vehicle) end

---@param toggle boolean
function SetLaunchControlEnabled(toggle) end

---@param alpha number
function SetLightAlpha(alpha) end

---@param intensity number
---@param radius number
---@param bias number
---@param intensity2 number
function SetLightAo(intensity, radius, bias, intensity2) end

---@param size number
function SetLightCapsuleSize(size) end

---@param x integer
---@param y integer
---@param width integer
---@param height integer
function SetLightClipRect(x, y, width, height) end

---@param r integer
---@param g integer
---@param b integer
function SetLightColor(r, g, b) end

---@param innerConeAngle number
---@param outerConeAngle number
function SetLightCone(innerConeAngle, outerConeAngle) end

---@param x number
---@param y number
---@param z number
function SetLightCoords(x, y, z) end

---@param xDir number
---@param yDir number
---@param zDir number
---@param xTanDir number
---@param yTanDir number
---@param zTanDir number
function SetLightDirection(xDir, yDir, zDir, xTanDir, yTanDir, zTanDir) end

---@param extraFlags integer
function SetLightExtraflags(extraFlags) end

---@param fadeDistance integer
function SetLightFadeDistance(fadeDistance) end

---@param falloff number
function SetLightFalloff(falloff) end

---@param flags integer
function SetLightFlags(flags) end

---@param intensity number
---@param range number
function SetLightHeadlight(intensity, range) end

---@param intensity number
function SetLightIntensity(intensity) end

---@param interiorId integer
---@param isPortal boolean
---@param roomIndex integer
function SetLightInterior(interiorId, isPortal, roomIndex) end

---@param x number
---@param y number
---@param z number
---@param w number
function SetLightPlane(x, y, z, w) end

---@param radius number
function SetLightRadius(radius) end

---@param shadowFlags integer
---@param shadowDistance number
---@param shadowFade number
---@param shadowDepthBiasScale number
function SetLightShadowDetails(shadowFlags, shadowDistance, shadowFade, shadowDepthBiasScale) end

---@param fadeDistance integer
function SetLightShadowFadeDistance(fadeDistance) end

---@param fadeDistance integer
function SetLightSpecularFadeDistance(fadeDistance) end

---@param textureDict string
---@param textureHash integer
function SetLightTexture(textureDict, textureHash) end

---@param lightType integer
function SetLightType(lightType) end

---@param volIntensity number
---@param volSizeScale number
---@param r number
---@param g number
---@param b number
---@param i number
---@param outerExponent number
function SetLightVolumeDetails(volIntensity, volSizeScale, r, g, b, i, outerExponent) end

---@param volumetricFadeDistance integer
function SetLightVolumetricFadeDistance(volumetricFadeDistance) end

---@param distance number
function SetLightsCutoffDistanceTweak(distance) end

---@param toggle boolean
function SetLocalPlayerAsGhost(toggle) end

---@param p0 boolean
function SetLocalPlayerCanCollectPortablePickups(p0) end

---@param modelHash integer | string
---@param toggle boolean
function SetLocalPlayerCanUsePickupsWithThisModel(modelHash, toggle) end

---@param p0 boolean
function SetLocalPlayerInvisibleLocally(p0) end

---@param p0 boolean
---@param p1 boolean
function SetLocalPlayerVisibleInCutscene(p0, p1) end

---@param p0 boolean
function SetLocalPlayerVisibleLocally(p0) end

---@param color integer
function SetMainPlayerBlipColour(color) end

---@param manualShutdown boolean
function SetManualShutdownLoadingScreenNui(manualShutdown) end

---@param index integer
---@param zoomScale number
---@param zoomSpeed number
---@param scrollSpeed number
---@param tilesX number
---@param tilesY number
function SetMapZoomDataLevel(index, zoomScale, zoomSpeed, scrollSpeed, tilesX, tilesY) end

---@param name string
---@param toggle boolean
function SetMapdatacullboxEnabled(name, toggle) end

---@param maximumValue integer
function SetMaxArmourHudDisplay(maximumValue) end

---@param maximumValue integer
function SetMaxHealthHudDisplay(maximumValue) end

---@param modelHash integer | string
---@param p1 integer
function SetMaxNumPortablePickupsCarriedByPlayer(modelHash, p1) end

---@param maxWantedLevel integer
function SetMaxWantedLevel(maxWantedLevel) end

---@param p0 boolean
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param x3 number
---@param y3 number
---@param z3 number
function SetMicrophonePosition(p0, x1, y1, z1, x2, y2, z2, x3, y3, z3) end

---@param value integer
function SetMillisecondsPerGameMinute(value) end

---@param toggle boolean
function SetMinigameInProgress(toggle) end

---@param altitude number
---@param p1 boolean
function SetMinimapAltitudeIndicatorLevel(altitude, p1) end

---@param toggle boolean
function SetMinimapBlockWaypoint(toggle) end

---@param type integer
function SetMinimapClipType(type) end

---@param componentID integer
---@param toggle boolean
---@param hudColor integer
---@return integer
function SetMinimapComponent(componentID, toggle, hudColor) end

---@param name string
---@param alignX string
---@param alignY string
---@param posX number
---@param posY number
---@param sizeX number
---@param sizeY number
function SetMinimapComponentPosition(name, alignX, alignY, posX, posY, sizeX, sizeY) end

---@param x number
---@param y number
---@param z number
function SetMinimapFowRevealCoordinate(x, y, z) end

---@param hole integer
function SetMinimapGolfCourse(hole) end


function SetMinimapGolfCourseOff() end

---@param toggle boolean
function SetMinimapHideFow(toggle) end

---@param toggle boolean
function SetMinimapInPrologue(toggle) end

---@param toggle boolean
---@param ped integer
function SetMinimapInSpectatorMode(toggle, ped) end

---@param miniMap integer
---@param x number
---@param y number
---@param xScale number
---@param yScale number
---@param alpha number
function SetMinimapOverlayDisplay(miniMap, x, y, xScale, yScale, alpha) end

---@param toggle boolean
function SetMinimapSonarSweep(toggle) end

---@param type integer
function SetMinimapType(type) end

---@param toggle boolean
function SetMissionFlag(toggle) end

---@param p0 boolean
---@param name string
function SetMissionName(p0, name) end

---@param p0 boolean
---@param name string
function SetMissionName_2(p0, name) end

---@param train integer
---@param p1 boolean
function SetMissionTrainAsNoLongerNeeded(train, p1) end

---@param train integer
---@param x number
---@param y number
---@param z number
function SetMissionTrainCoords(train, x, y, z) end

---@param toggle boolean
function SetMobilePhoneDofState(toggle) end

---@param posX number
---@param posY number
---@param posZ number
function SetMobilePhonePosition(posX, posY, posZ) end

---@param state boolean
function SetMobilePhoneRadioState(state) end

---@param rotX number
---@param rotY number
---@param rotZ number
---@param p3 any
function SetMobilePhoneRotation(rotX, rotY, rotZ, p3) end

---@param scale number
function SetMobilePhoneScale(scale) end

---@param toggle boolean
function SetMobileRadioEnabledDuringGameplay(toggle) end

---@param model integer | string
function SetModelAsNoLongerNeeded(model) end

---@param modelHash integer | string
---@param ratePerSecond number
---@param headlightRotation number
---@param invertRotation boolean
function SetModelHeadlightConfiguration(modelHash, ratePerSecond, headlightRotation, invertRotation) end

---@param shootingPed integer
---@param targetPed integer
---@param targetVehicle integer
---@param x number
---@param y number
---@param z number
function SetMountedWeaponTarget(shootingPed, targetPed, targetVehicle, x, y, z) end

---@param style integer
function SetMouseCursorStyle(style) end


function SetMouseCursorThisFrame() end

---@param isVisible boolean
function SetMouseCursorVisible(isVisible) end

---@param ped integer
---@param name string
function SetMovementModeOverride(ped, name) end

---@param gamerTagId integer
---@param component integer
---@param alpha integer
function SetMpGamerTagAlpha(gamerTagId, component, alpha) end

---@param gamerTagId integer
---@param string string
function SetMpGamerTagBigText(gamerTagId, string) end

---@param gamerTagId integer
---@param component integer
---@param hudColorIndex integer
function SetMpGamerTagColour(gamerTagId, component, hudColorIndex) end

---@param gamerTagId integer
---@param toggle boolean
function SetMpGamerTagDisablePlayerHealthSync(gamerTagId, toggle) end

---@param gamerTagId integer
---@param hudColorIndex integer
function SetMpGamerTagHealthBarColour(gamerTagId, hudColorIndex) end

---@param gamerTagId integer
---@param count integer
function SetMpGamerTagMpBagLargeCount(gamerTagId, count) end

---@param gamerTagId integer
---@param string string
function SetMpGamerTagName(gamerTagId, string) end

---@param gamerTagId integer
---@param health integer
---@param maximumHealth integer
function SetMpGamerTagOverridePlayerHealth(gamerTagId, health, maximumHealth) end

---@param gamerTagId integer
---@param toggle boolean
function SetMpGamerTagUseVehicleHealth(gamerTagId, toggle) end

---@param gamerTagId integer
---@param component integer
---@param toggle boolean
function SetMpGamerTagVisibility(gamerTagId, component, toggle) end

---@param gamerTagId integer
---@param toggle boolean
function SetMpGamerTagVisibilityAll(gamerTagId, toggle) end

---@param gamerTagId integer
---@param wantedlvl integer
function SetMpGamerTagWantedLevel(gamerTagId, wantedlvl) end

---@param enabled boolean
function SetMpGamerTagsUseVehicleBehavior(enabled) end

---@param distance number
function SetMpGamerTagsVisibleDistance(distance) end


function SetMultiplayerBankCash() end

---@param p0 integer
---@param p1 integer
function SetMultiplayerHudCash(p0, p1) end


function SetMultiplayerWalletCash() end

---@param toggle boolean
function SetNetworkCutsceneEntities(toggle) end

---@param vehicle integer
---@param toggle boolean
function SetNetworkEnableVehiclePositionCorrection(vehicle, toggle) end

---@param netId integer
---@param player integer
---@param toggle boolean
function SetNetworkIdAlwaysExistsForPlayer(netId, player, toggle) end

---@param netId integer
---@param toggle boolean
function SetNetworkIdCanMigrate(netId, toggle) end

---@param netId integer
---@param toggle boolean
function SetNetworkIdExistsOnAllMachines(netId, toggle) end

---@param netId integer
---@param p1 boolean
---@param p2 boolean
function SetNetworkIdVisibleInCutscene(netId, p1, p2) end

---@param vehicle integer
---@param toggle boolean
function SetNetworkVehicleAsGhost(vehicle, toggle) end

---@param vehicle integer
---@param multiplier number
function SetNetworkVehiclePositionUpdateMultiplier(vehicle, multiplier) end

---@param netId integer
---@param time integer
function SetNetworkVehicleRespotTimer(netId, time) end

---@param enabled boolean
function SetNetworkWalkMode(enabled) end

---@param x number
---@param y number
function SetNewWaypoint(x, y) end

---@param p0 number
function SetNextDesiredMoveState(p0) end

---@param modifierName string
function SetNextPlayerTcmodifier(modifierName) end

---@param toggle boolean
function SetNightvision(toggle) end

---@param vehicle integer
---@param isActive boolean
function SetNitrousIsActive(vehicle, isActive) end

---@param toggle boolean
function SetNoLoadingScreen(toggle) end

---@param toggle boolean
function SetNoiseoveride(toggle) end

---@param value number
function SetNoisinessoveride(value) end

---@param hasFocus boolean
---@param hasCursor boolean
function SetNuiFocus(hasFocus, hasCursor) end

---@param keepInput boolean
function SetNuiFocusKeepInput(keepInput) end

---@param zIndex integer
function SetNuiZindex(zIndex) end

---@param value integer
function SetNumberOfParkedVehicles(value) end

---@param object integer
---@param toggle boolean
function SetObjectAllowLowLodBuoyancy(object, toggle) end

---@param object integer
function SetObjectAsNoLongerNeeded(object) end

---@param object integer
---@param toggle boolean
function SetObjectForceVehiclesToAvoid(object, toggle) end

---@param object integer
---@param p1 boolean
---@param r integer
---@param g integer
---@param b integer
---@return any
function SetObjectLightColor(object, p1, r, g, b) end

---@param object integer
---@param mass number
---@param gravityFactor number
---@param linearC number
---@param linearV number
---@param linearV2 number
---@param angularC number
---@param angularV number
---@param angularV2 number
---@param p9 number
---@param maxAngSpeed number
---@param buoyancyFactor number
function SetObjectPhysicsParams(object, mass, gravityFactor, linearC, linearV, linearV2, angularC, angularV, angularV2, p9, maxAngSpeed, buoyancyFactor) end

---@param object integer
---@param duration number
function SetObjectStuntPropDuration(object, duration) end

---@param object integer
---@param intensity integer
function SetObjectStuntPropSpeedup(object, intensity) end

---@param object integer
---@param targettable boolean
function SetObjectTargettable(object, targettable) end

---@param object integer
---@param setFlag34 boolean
---@param setFlag35 boolean
function SetObjectTargettableByPlayer(object, setFlag34, setFlag35) end

---@param object integer
---@param textureVariation integer
function SetObjectTextureVariation(object, textureVariation) end

---@param vehicle integer
---@param toggle boolean
function SetOpenRearDoorsOnExplosion(vehicle, toggle) end

---@param vehicle integer
---@param extend boolean
function SetOppressorTransformState(vehicle, extend) end

---@param vehicle integer
---@param override boolean
function SetOverrideNitrousLevel(vehicle, override) end

---@param weatherType string
function SetOverrideWeather(weatherType) end

---@param padIndex integer
---@param duration integer
---@param frequency integer
function SetPadShake(padIndex, duration, frequency) end

---@param ped integer
---@param x number
---@param y number
---@param z number
function SetParachuteTaskTarget(ped, x, y, z) end

---@param ped integer
---@param thrust number
function SetParachuteTaskThrust(ped, thrust) end

---@param multiplier number
function SetParkedVehicleDensityMultiplierThisFrame(multiplier) end

---@param scale number
function SetParticleFxBulletImpactScale(scale) end

---@param vehicle integer
---@param p1 boolean
function SetParticleFxCamInsideNonplayerVehicle(vehicle, p1) end

---@param p0 boolean
function SetParticleFxCamInsideVehicle(p0) end

---@param ptfxHandle integer
---@param alpha number
function SetParticleFxLoopedAlpha(ptfxHandle, alpha) end

---@param ptfxHandle integer
---@param r number
---@param g number
---@param b number
---@param bLocalOnly boolean
function SetParticleFxLoopedColour(ptfxHandle, r, g, b, bLocalOnly) end

---@param ptfxHandle integer
---@param propertyName string
---@param amount number
---@param noNetwork boolean
function SetParticleFxLoopedEvolution(ptfxHandle, propertyName, amount, noNetwork) end

---@param ptfxHandle integer
---@param range number
function SetParticleFxLoopedFarClipDist(ptfxHandle, range) end

---@param ptfxHandle integer
---@param x number
---@param y number
---@param z number
---@param rotX number
---@param rotY number
---@param rotZ number
function SetParticleFxLoopedOffsets(ptfxHandle, x, y, z, rotX, rotY, rotZ) end

---@param ptfxHandle integer
---@param scale number
function SetParticleFxLoopedScale(ptfxHandle, scale) end

---@param alpha number
function SetParticleFxNonLoopedAlpha(alpha) end

---@param r number
---@param g number
---@param b number
function SetParticleFxNonLoopedColour(r, g, b) end

---@param p0 number
---@param p1 number
---@param scale number
function SetParticleFxNonLoopedEmitterScale(p0, p1, scale) end

---@param oldAsset string
---@param newAsset string
function SetParticleFxOverride(oldAsset, newAsset) end

---@param p0 any
function SetParticleFxShootoutBoat(p0) end

---@param toggle boolean
function SetPauseMenuActive(toggle) end

---@param state boolean
function SetPauseMenuPedLighting(state) end

---@param state boolean
function SetPauseMenuPedSleepState(state) end

---@param ped integer
---@param accuracy integer
function SetPedAccuracy(ped, accuracy) end

---@param ped integer
---@param toggle boolean
function SetPedAiBlipForcedOn(ped, toggle) end

---@param ped integer
---@param gangId integer
function SetPedAiBlipGangId(ped, gangId) end

---@param ped integer
---@param toggle boolean
function SetPedAiBlipHasCone(ped, toggle) end

---@param ped integer
---@param range number
function SetPedAiBlipNoticeRange(ped, range) end

---@param ped integer
---@param spriteId integer
function SetPedAiBlipSprite(ped, spriteId) end

---@param ped integer
---@param value integer
function SetPedAlertness(ped, value) end

---@param ped integer
---@param toggle boolean
function SetPedAllowVehiclesOverride(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedAllowedToDuck(ped, toggle) end

---@param ped integer
---@param stance integer
---@param animDictionary string
---@param animationName string
---@param p4 number
---@param p5 boolean
function SetPedAlternateMovementAnim(ped, stance, animDictionary, animationName, p4, p5) end

---@param ped integer
---@param animDict string
---@param animName string
---@param p3 number
---@param p4 boolean
function SetPedAlternateWalkAnim(ped, animDict, animName, p3, p4) end

---@param ped integer
---@param weaponHash integer | string
---@param ammo integer
function SetPedAmmo(ped, weaponHash, ammo) end

---@param ped integer
---@param ammoType integer | string
---@param ammo integer
function SetPedAmmoByType(ped, ammoType, ammo) end

---@param ped integer
---@param ammo integer
function SetPedAmmoToDrop(ped, ammo) end

---@param ped integer
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 boolean
---@param p9 boolean
function SetPedAngledDefensiveArea(ped, p1, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param ped integer
---@param toggle boolean
function SetPedAoBlobRendering(ped, toggle) end

---@param ped integer
---@param amount integer
function SetPedArmour(ped, amount) end

---@param ped integer
---@param toggle boolean
function SetPedAsCop(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedAsEnemy(ped, toggle) end

---@param ped integer
---@param groupId integer
function SetPedAsGroupLeader(ped, groupId) end

---@param ped integer
---@param groupId integer
function SetPedAsGroupMember(ped, groupId) end

---@param ped integer
function SetPedAsNoLongerNeeded(ped) end

---@param ped integer
---@param toggle boolean
function SetPedAudioFootstepLoud(ped, toggle) end

---@param ped integer
---@param p1 boolean
function SetPedAudioGender(ped, p1) end

---@param ped integer
---@param father integer
---@param mother integer
---@param fathersSide number
---@param mothersSide number
function SetPedBlendFromParents(ped, father, mother, fathersSide, mothersSide) end

---@param ped integer
---@param toggle boolean
function SetPedBlocksPathingWhenDead(ped, toggle) end

---@param ped integer
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
function SetPedBoundsOrientation(ped, p1, p2, p3, p4, p5) end

---@param ped integer
---@param toggle boolean
function SetPedCanArmIk(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanBeDraggedOut(ped, toggle) end

---@param ped integer
---@param state integer
function SetPedCanBeKnockedOffVehicle(ped, state) end

---@param ped integer
---@param toggle boolean
function SetPedCanBeShotInVehicle(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanBeTargetedWhenInjured(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanBeTargetedWithoutLos(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanBeTargetted(ped, toggle) end

---@param ped integer
---@param player integer
---@param toggle boolean
function SetPedCanBeTargettedByPlayer(ped, player, toggle) end

---@param ped integer
---@param team integer
---@param toggle boolean
function SetPedCanBeTargettedByTeam(ped, team, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanCowerInCover(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanEvasiveDive(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanHeadIk(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanLegIk(ped, toggle) end

---@param ped integer
---@param loseProps boolean
---@param p2 integer
function SetPedCanLosePropsOnDamage(ped, loseProps, p2) end

---@param ped integer
---@param toggle boolean
function SetPedCanPeekInCover(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanPlayAmbientAnims(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanPlayAmbientBaseAnims(ped, toggle) end

---@param ped integer
---@param bBlockIdleClips boolean
---@param bRemoveIdleClipIfPlaying boolean
function SetPedCanPlayAmbientIdles(ped, bBlockIdleClips, bRemoveIdleClipIfPlaying) end

---@param ped integer
---@param toggle boolean
function SetPedCanPlayGestureAnims(ped, toggle) end

---@param ped integer
---@param p1 boolean
function SetPedCanPlayInjuredAnims(ped, p1) end

---@param ped integer
---@param toggle boolean
---@param p2 boolean
function SetPedCanPlayVisemeAnims(ped, toggle, p2) end

---@param ped integer
---@param toggle boolean
function SetPedCanRagdoll(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanRagdollFromPlayerImpact(ped, toggle) end

---@param ped integer
---@param p1 boolean
---@param p2 boolean
function SetPedCanSmashGlass(ped, p1, p2) end

---@param ped integer
---@param toggle boolean
function SetPedCanSwitchWeapon(ped, toggle) end

---@param pedHandle integer
---@param groupHandle integer
---@param toggle boolean
function SetPedCanTeleportToGroupLeader(pedHandle, groupHandle, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedCanTorsoIk(ped, toggle) end

---@param ped integer
---@param p1 boolean
function SetPedCanTorsoReactIk(ped, p1) end

---@param ped integer
---@param p1 boolean
function SetPedCanTorsoVehicleIk(ped, p1) end

---@param ped integer
---@param toggle boolean
function SetPedCanUseAutoConversationLookat(ped, toggle) end

---@param ped integer
---@param value number
function SetPedCapsule(ped, value) end

---@param ped integer
---@param xBias number
---@param yBias number
function SetPedChanceOfFiringBlanks(ped, xBias, yBias) end

---@param ped integer
---@param enabled boolean
function SetPedClothEventsEnabled(ped, enabled) end

---@param ped integer
---@param p1 integer
function SetPedClothPackageIndex(ped, p1) end

---@param p0 any
---@param p1 any
function SetPedClothProne(p0, p1) end

---@param ped integer
---@param componentId integer
---@param collection string
---@param drawableId integer
---@param textureId integer
---@param paletteId integer
function SetPedCollectionComponentVariation(ped, componentId, collection, drawableId, textureId, paletteId) end

---@param ped integer
---@param anchorPoint integer
---@param collection string
---@param propIndex integer
---@param textureId integer
function SetPedCollectionPreloadPropData(ped, anchorPoint, collection, propIndex, textureId) end

---@param ped integer
---@param componentId integer
---@param collection string
---@param drawableId integer
---@param textureId integer
function SetPedCollectionPreloadVariationData(ped, componentId, collection, drawableId, textureId) end

---@param ped integer
---@param anchorPoint integer
---@param collection string
---@param propIndex integer
---@param textureId integer
---@param attach boolean
function SetPedCollectionPropIndex(ped, anchorPoint, collection, propIndex, textureId, attach) end

---@param ped integer
---@param p1 integer
function SetPedCombatAbility(ped, p1) end

---@param ped integer
---@param attributeIndex integer
---@param enabled boolean
function SetPedCombatAttributes(ped, attributeIndex, enabled) end

---@param ped integer
---@param combatMovement integer
function SetPedCombatMovement(ped, combatMovement) end

---@param ped integer
---@param range integer
function SetPedCombatRange(ped, range) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@param textureId integer
---@param paletteId integer
function SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId) end

---@param ped integer
---@param flagId integer
---@param value boolean
function SetPedConfigFlag(ped, flagId, value) end

---@param ped integer
---@param posX number
---@param posY number
---@param posZ number
function SetPedCoordsKeepVehicle(ped, posX, posY, posZ) end

---@param ped integer
---@param posX number
---@param posY number
---@param posZ number
function SetPedCoordsNoGang(ped, posX, posY, posZ) end

---@param ped integer
---@param p1 string
function SetPedCoverClipsetOverride(ped, p1) end

---@param ped integer
---@param p1 string
function SetPedCowerHash(ped, p1) end

---@param ped integer
---@param visible boolean
---@param deselectWeapon boolean
---@param p3 boolean
---@param p4 boolean
function SetPedCurrentWeaponVisible(ped, visible, deselectWeapon, p3, p4) end

---@param ped integer
function SetPedCycleVehicleWeaponsOnly(ped) end

---@param ped integer
function SetPedDefaultComponentVariation(ped) end

---@param ped integer
---@param attachPed integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 number
---@param p9 boolean
---@param p10 boolean
function SetPedDefensiveAreaAttachedToPed(ped, attachPed, p2, p3, p4, p5, p6, p7, p8, p9, p10) end

---@param ped integer
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 boolean
function SetPedDefensiveAreaDirection(ped, p1, p2, p3, p4) end

---@param ped integer
---@param target integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param radius number
---@param p6 boolean
function SetPedDefensiveSphereAttachedToPed(ped, target, xOffset, yOffset, zOffset, radius, p6) end

---@param ped integer
---@param target integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param radius number
---@param p6 boolean
function SetPedDefensiveSphereAttachedToVehicle(ped, target, xOffset, yOffset, zOffset, radius, p6) end

---@param multiplier number
function SetPedDensityMultiplierThisFrame(multiplier) end

---@param ped integer
---@param heading number
function SetPedDesiredHeading(ped, heading) end

---@param ped integer
---@param p1 number
function SetPedDesiredMoveBlendRatio(ped, p1) end

---@param ped integer
---@param toggle boolean
function SetPedDiesInSinkingVehicle(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedDiesInVehicle(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedDiesInWater(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedDiesInstantlyInWater(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedDiesWhenInjured(ped, toggle) end

---@param ped integer
---@param clipset string
function SetPedDriveByClipsetOverride(ped, clipset) end

---@param ped integer
---@param weaponHash integer | string
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param ammoCount integer
function SetPedDropsInventoryWeapon(ped, weaponHash, xOffset, yOffset, zOffset, ammoCount) end

---@param ped integer
function SetPedDropsWeapon(ped) end

---@param ped integer
---@param toggle boolean
function SetPedDropsWeaponsWhenDead(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedDucking(ped, toggle) end

---@param ped integer
---@param intensity number
function SetPedEmissiveIntensity(ped, intensity) end

---@param ped integer
---@param toggle boolean
function SetPedEnableWeaponBlocking(ped, toggle) end

---@param ped integer
---@param r integer
---@param g integer
---@param b integer
function SetPedEnveffColorModulator(ped, r, g, b) end

---@param ped integer
---@param value number
function SetPedEnveffScale(ped, value) end

---@param ped integer
---@param index integer
function SetPedEyeColor(ped, index) end

---@param ped integer
---@param index integer
---@param scale number
function SetPedFaceFeature(ped, index, scale) end

---@param ped integer
---@param patternHash integer | string
function SetPedFiringPattern(ped, patternHash) end

---@param ped integer
---@param attributeFlags integer
---@param enable boolean
function SetPedFleeAttributes(ped, attributeFlags, enable) end

---@param ped integer
---@param gadgetHash integer | string
---@param p2 boolean
function SetPedGadget(ped, gadgetHash, p2) end

---@param ped integer
---@param toggle boolean
function SetPedGeneratesDeadBodyEvents(ped, toggle) end

---@param ped integer
---@param animGroupGesture string
function SetPedGestureGroup(ped, animGroupGesture) end

---@param ped integer
---@param toggle boolean
function SetPedGetOutUpsideDownVehicle(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedGravity(ped, toggle) end

---@param ped integer
---@param index integer
function SetPedGroupMemberPassengerIndex(ped, index) end

---@param ped integer
---@param colorID integer
---@param highlightColorID integer
function SetPedHairTint(ped, colorID, highlightColorID) end

---@param ped integer
---@param hasCone boolean
function SetPedHasAiBlip(ped, hasCone) end

---@param ped integer
---@param hasCone boolean
---@param color integer
function SetPedHasAiBlipWithColor(ped, hasCone, color) end

---@param ped integer
---@param shapeFirstID integer
---@param shapeSecondID integer
---@param shapeThirdID integer
---@param skinFirstID integer
---@param skinSecondID integer
---@param skinThirdID integer
---@param shapeMix number
---@param skinMix number
---@param thirdMix number
---@param isParent boolean
function SetPedHeadBlendData(ped, shapeFirstID, shapeSecondID, shapeThirdID, skinFirstID, skinSecondID, skinThirdID, shapeMix, skinMix, thirdMix, isParent) end

---@param ped integer
---@param overlayID integer
---@param index integer
---@param opacity number
function SetPedHeadOverlay(ped, overlayID, index, opacity) end

---@param ped integer
---@param overlayID integer
---@param colorType integer
---@param colorID integer
---@param secondColorID integer
function SetPedHeadOverlayColor(ped, overlayID, colorType, colorID, secondColorID) end

---@param ped integer
---@param value number
function SetPedHearingRange(ped, value) end

---@param ped integer
---@param heatScale number
function SetPedHeatscaleOverride(ped, heatScale) end

---@param ped integer
---@param bEnable boolean
function SetPedHelmet(ped, bEnable) end

---@param ped integer
---@param helmetFlag integer
function SetPedHelmetFlag(ped, helmetFlag) end

---@param ped integer
---@param propIndex integer
function SetPedHelmetPropIndex(ped, propIndex) end

---@param ped integer
---@param textureIndex integer
function SetPedHelmetTextureIndex(ped, textureIndex) end

---@param ped integer
---@param p1 boolean
---@param p2 integer
---@param p3 integer
function SetPedHelmetUnk(ped, p1, p2, p3) end

---@param ped integer
---@param toggle boolean
function SetPedHighlyPerceptive(ped, toggle) end

---@param ped integer
---@param value number
function SetPedIdRange(ped, value) end

---@param ped integer
---@param context integer | string
function SetPedInVehicleContext(ped, context) end

---@param ped integer
function SetPedIncreasedAvoidanceRadius(ped) end

---@param ped integer
---@param toggle boolean
---@param weaponHash integer | string
function SetPedInfiniteAmmo(ped, toggle, weaponHash) end

---@param ped integer
---@param toggle boolean
function SetPedInfiniteAmmoClip(ped, toggle) end

---@param ped integer
---@param vehicle integer
---@param seatIndex integer
function SetPedIntoVehicle(ped, vehicle, seatIndex) end

---@param ped integer
---@param toggle boolean
function SetPedIsDrunk(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedKeepTask(ped, toggle) end

---@param ped integer
---@param mode integer
function SetPedLegIkMode(ped, mode) end

---@param ped integer
---@param multiplier number
function SetPedLodMultiplier(ped, multiplier) end

---@param ped integer
---@param value integer
function SetPedMaxHealth(ped, value) end

---@param ped integer
---@param value number
function SetPedMaxMoveBlendRatio(ped, value) end

---@param ped integer
---@param value number
function SetPedMaxTimeInWater(ped, value) end

---@param ped integer
---@param value number
function SetPedMaxTimeUnderwater(ped, value) end

---@param primaryCount integer
---@param secondaryCount integer
---@param populationPedCount integer
function SetPedMeleeCombatLimits(primaryCount, secondaryCount, populationPedCount) end

---@param ped integer
---@param minTimeInMs integer
function SetPedMinGroundTimeForStungun(ped, minTimeInMs) end

---@param ped integer
---@param value number
function SetPedMinMoveBlendRatio(ped, value) end

---@param modelHash integer | string
---@param configName string
function SetPedModelHealthConfig(modelHash, configName) end

---@param model integer | string
---@param toggle boolean
function SetPedModelIsSuppressed(model, toggle) end

---@param modelHash integer | string
---@param personalityHash integer | string
function SetPedModelPersonality(modelHash, personalityHash) end

---@param ped integer
---@param amount integer
function SetPedMoney(ped, amount) end

---@param ped integer
---@param toggle boolean
function SetPedMotionBlur(ped, toggle) end

---@param ped integer
function SetPedMoveAnimsBlendOut(ped) end

---@param ped integer
---@param value number
function SetPedMoveRateOverride(ped, value) end

---@param ped integer
---@param clipSet string
---@param transitionSpeed number
function SetPedMovementClipset(ped, clipSet, transitionSpeed) end

---@param ped integer
---@param name string
function SetPedNameDebug(ped, name) end

---@param ped integer
---@param toggle boolean
function SetPedNeverLeavesGroup(ped, toggle) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
function SetPedNonCreationArea(x1, y1, z1, x2, y2, z2) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@return any
function SetPedPanicExitScenario(ped, x, y, z) end

---@param ped integer
---@param tintIndex integer
function SetPedParachuteTintIndex(ped, tintIndex) end

---@param ped integer
---@param avoidFire boolean
function SetPedPathAvoidFire(ped, avoidFire) end

---@param ped integer
---@param Toggle boolean
function SetPedPathCanDropFromHeight(ped, Toggle) end

---@param ped integer
---@param Toggle boolean
function SetPedPathCanUseClimbovers(ped, Toggle) end

---@param ped integer
---@param Toggle boolean
function SetPedPathCanUseLadders(ped, Toggle) end

---@param ped integer
---@param modifier number
function SetPedPathClimbCostModifier(ped, modifier) end

---@param ped integer
---@param mayEnterWater boolean
function SetPedPathMayEnterWater(ped, mayEnterWater) end

---@param ped integer
---@param avoidWater boolean
function SetPedPathPreferToAvoidWater(ped, avoidWater) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
function SetPedPathsBackToOriginal(p0, p1, p2, p3, p4, p5) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param unknown boolean
function SetPedPathsInArea(x1, y1, z1, x2, y2, z2, unknown) end

---@param ped integer
---@param index integer
function SetPedPhonePaletteIdx(ped, index) end

---@param ped integer
---@param pinned boolean
---@param i integer
---@return any
function SetPedPinnedDown(ped, pinned, i) end

---@param ped integer
---@param toggle boolean
function SetPedPlaysHeadOnHornAnimWhenDiesInVehicle(ped, toggle) end

---@param budgetLevel integer
function SetPedPopulationBudget(budgetLevel) end

---@param ped integer
---@param itemSet any
function SetPedPreferredCoverSet(ped, itemSet) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@param textureId integer
---@return boolean
function SetPedPreloadPropData(ped, componentId, drawableId, textureId) end

---@param ped integer
---@param slot integer
---@param drawableId integer
---@param textureId integer
---@return any
function SetPedPreloadVariationData(ped, slot, drawableId, textureId) end

---@param ped integer
---@param lookAt integer
function SetPedPrimaryLookat(ped, lookAt) end

---@param ped integer
---@param componentId integer
---@param drawableId integer
---@param textureId integer
---@param attach boolean
function SetPedPropIndex(ped, componentId, drawableId, textureId, attach) end

---@param ped integer
---@param pedRace integer
---@param pvgHash integer
function SetPedRaceAndVoiceGroup(ped, pedRace, pvgHash) end

---@param ped integer
function SetPedRagdollForceFall(ped) end

---@param ped integer
---@param toggle boolean
function SetPedRagdollOnCollision(ped, toggle) end

---@param ped integer
---@param p1 integer
function SetPedRandomComponentVariation(ped, p1) end

---@param ped integer
function SetPedRandomProps(ped) end

---@param ped integer
---@param hash integer | string
function SetPedRelationshipGroupDefaultHash(ped, hash) end

---@param ped integer
---@param hash integer | string
function SetPedRelationshipGroupHash(ped, hash) end

---@param ped integer
---@param p1 any
function SetPedReserveParachuteTintIndex(ped, p1) end

---@param ped integer
---@param flagId integer
---@param doReset boolean
function SetPedResetFlag(ped, flagId, doReset) end

---@param ped integer
function SetPedScubaGearVariation(ped) end

---@param ped integer
---@param value number
function SetPedSeeingRange(ped, value) end

---@param ped integer
---@param p1 number
---@return integer
function SetPedShootOrdnanceWeapon(ped, p1) end

---@param ped integer
---@param shootRate integer
function SetPedShootRate(ped, shootRate) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param toggle boolean
function SetPedShootsAtCoord(ped, x, y, z, toggle) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@return boolean
function SetPedShouldPlayDirectedScenarioExit(ped, x, y, z) end

---@param ped integer
---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function SetPedShouldPlayFleeScenarioExit(ped, p1, p2, p3) end

---@param ped integer
function SetPedShouldPlayImmediateScenarioExit(ped) end

---@param ped integer
function SetPedShouldPlayNormalScenarioExit(ped) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@param p5 boolean
---@param p6 boolean
function SetPedSphereDefensiveArea(ped, x, y, z, radius, p5, p6) end

---@param ped integer
---@param toggle boolean
function SetPedStayInVehicleWhenJacked(ped, toggle) end

---@param ped integer
---@param p1 boolean
---@param action string
function SetPedStealthMovement(ped, p1, action) end

---@param ped integer
---@param toggle boolean
function SetPedSteersAroundObjects(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedSteersAroundPeds(ped, toggle) end

---@param ped integer
---@param toggle boolean
function SetPedSteersAroundVehicles(ped, toggle) end

---@param ped integer
---@param clipSet string
function SetPedStrafeClipset(ped, clipSet) end

---@param ped integer
---@param toggle boolean
function SetPedSuffersCriticalHits(ped, toggle) end

---@param ped integer
---@param toggle boolean
---@return boolean
function SetPedSurvivesBeingOutOfWater(ped, toggle) end

---@param ped integer
---@param sweat number
function SetPedSweat(ped, sweat) end

---@param ped integer
---@param responseType integer
function SetPedTargetLossResponse(ped, responseType) end

---@param ped integer
---@param radius number
---@param maxFriends integer
function SetPedToInformRespectedFriends(ped, radius, maxFriends) end

---@param ped integer
---@param toggle boolean
function SetPedToLoadCover(ped, toggle) end

---@param ped integer
---@param minTime integer
---@param maxTime integer
---@param ragdollType integer
---@param bAbortIfInjured boolean
---@param bAbortIfDead boolean
---@param bForceScriptControl boolean
---@return boolean
function SetPedToRagdoll(ped, minTime, maxTime, ragdollType, bAbortIfInjured, bAbortIfDead, bForceScriptControl) end

---@param ped integer
---@param minTime integer
---@param maxTime integer
---@param nFallType integer
---@param dirX number
---@param dirY number
---@param dirZ number
---@param fGroundHeight number
---@param grab1X number
---@param grab1Y number
---@param grab1Z number
---@param grab2X number
---@param grab2Y number
---@param grab2Z number
---@return boolean
function SetPedToRagdollWithFall(ped, minTime, maxTime, nFallType, dirX, dirY, dirZ, fGroundHeight, grab1X, grab1Y, grab1Z, grab2X, grab2Y, grab2Z) end

---@param min number
---@param max number
function SetPedTurningThresholds(min, max) end

---@param ped integer
---@param p1 boolean
---@param p2 integer
---@param action string
function SetPedUsingActionMode(ped, p1, p2, action) end

---@param ped integer
---@param vehicle integer
---@param seatIndex integer
---@param flags integer
function SetPedVehicleForcedSeatUsage(ped, vehicle, seatIndex, flags) end

---@param ped integer
---@param angle number
function SetPedVisualFieldCenterAngle(ped, angle) end

---@param ped integer
---@param value number
function SetPedVisualFieldMaxAngle(ped, value) end

---@param ped integer
---@param angle number
function SetPedVisualFieldMaxElevationAngle(ped, angle) end

---@param ped integer
---@param value number
function SetPedVisualFieldMinAngle(ped, value) end

---@param ped integer
---@param angle number
function SetPedVisualFieldMinElevationAngle(ped, angle) end

---@param ped integer
---@param range number
function SetPedVisualFieldPeripheralRange(ped, range) end

---@param ped integer
function SetPedVoiceFull(ped) end

---@param ped integer
---@param voiceGroupHash integer | string
function SetPedVoiceGroup(ped, voiceGroupHash) end

---@param ped integer
---@param voiceGroupHash integer | string
function SetPedVoiceGroupRace(ped, voiceGroupHash) end

---@param density number
---@param applyValue number
function SetPedWallaDensity(density, applyValue) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@return any
function SetPedWaypointRouteOffset(p0, p1, p2, p3) end

---@param ped integer
---@param weaponHash integer | string
---@param camoComponentHash integer | string
---@param colorIndex integer
function SetPedWeaponLiveryColor(ped, weaponHash, camoComponentHash, colorIndex) end

---@param ped integer
---@param clipSet string
function SetPedWeaponMovementClipset(ped, clipSet) end

---@param ped integer
---@param weaponHash integer | string
---@param tintIndex integer
function SetPedWeaponTintIndex(ped, weaponHash, tintIndex) end

---@param ped integer
function SetPedWetnessEnabledThisFrame(ped) end

---@param ped integer
---@param height number
function SetPedWetnessHeight(ped, height) end

---@param entity integer
---@param toggle boolean
function SetPickUpByCargobobDisabled(entity, toggle) end

---@param p0 number
function SetPickupAmmoAmountScaler(p0) end

---@param multiplier number
function SetPickupGenerationRangeMultiplier(multiplier) end

---@param p0 any
---@param p1 any
function SetPickupHiddenWhenUncollectable(p0, p1) end

---@param pickup integer
---@param duration integer
function SetPickupRegenerationTime(pickup, duration) end

---@param cargobob integer
---@param length1 number
---@param length2 number
---@param state boolean
function SetPickupRopeLengthForCargobob(cargobob, length1, length2, state) end

---@param p0 any
---@param p1 any
function SetPickupUncollectable(p0, p1) end

---@param plane integer
---@param toggle boolean
function SetPlaneAvoidsOthers(plane, toggle) end

---@param plane integer
---@param toggle boolean
function SetPlaneControlSectionsShouldBreakOffFromExplosions(plane, toggle) end

---@param vehicle integer
---@param health number
function SetPlaneEngineHealth(vehicle, health) end

---@param plane integer
---@param health number
function SetPlanePropellersHealth(plane, health) end

---@param vehicle integer
---@param toggle boolean
function SetPlaneResistToExplosion(vehicle, toggle) end

---@param vehicle integer
---@param damageSection integer
---@param damageScale number
function SetPlaneSectionDamageScale(vehicle, damageSection, damageScale) end

---@param vehicle integer
---@param multiplier number
function SetPlaneTurbulenceMultiplier(vehicle, multiplier) end

---@param vehicle integer
---@param speed number
function SetPlaybackSpeed(vehicle, speed) end

---@param vehicle integer
---@param drivingStyle integer
function SetPlaybackToUseAi(vehicle, drivingStyle) end

---@param vehicle integer
---@param time integer
---@param drivingStyle integer
---@param p3 boolean
function SetPlaybackToUseAiTryToRevertBackLater(vehicle, time, drivingStyle, p3) end

---@param player integer
---@param zoneId integer
---@param enable boolean
function SetPlayerAirDefenseZoneFlag(player, zoneId, enable) end

---@param ped integer
---@param isAngry boolean
function SetPlayerAngry(ped, isAngry) end

---@param player integer
---@param state boolean
function SetPlayerBluetoothState(player, state) end

---@param player integer
---@param toggle boolean
function SetPlayerCanBeHassledByGangs(player, toggle) end

---@param player integer
---@param toggle boolean
function SetPlayerCanDoDriveBy(player, toggle) end

---@param player integer
---@param enabled boolean
function SetPlayerCanLeaveParachuteSmokeTrail(player, enabled) end

---@param player integer
---@param toggle boolean
function SetPlayerCanUseCover(player, toggle) end

---@param value integer
function SetPlayerClothLockCounter(value) end

---@param index integer
function SetPlayerClothPackageIndex(index) end

---@param player integer
---@param p1 integer
function SetPlayerClothPinFrames(player, p1) end

---@param player integer
---@param bHasControl boolean
---@param flags integer
function SetPlayerControl(player, bHasControl, flags) end

---@param player integer
---@param distance number
function SetPlayerFallDistance(player, distance) end

---@param player integer
---@param toggle boolean
function SetPlayerForceSkipAimIntro(player, toggle) end

---@param player integer
---@param toggle boolean
function SetPlayerForcedAim(player, toggle) end

---@param player integer
---@param toggle boolean
function SetPlayerForcedZoom(player, toggle) end

---@param player integer
function SetPlayerHasReserveParachute(player) end

---@param player integer
---@param limit number
function SetPlayerHealthRechargeLimit(player, limit) end

---@param player integer
---@param regenRate number
function SetPlayerHealthRechargeMultiplier(player, regenRate) end

---@param player integer
---@param p1 boolean
function SetPlayerHomingRocketDisabled(player, p1) end

---@param player integer
---@param bInvincible boolean
function SetPlayerInvincible(player, bInvincible) end

---@param player integer
---@param toggle boolean
function SetPlayerInvincibleKeepRagdollEnabled(player, toggle) end

---@param player integer
---@param toggle boolean
function SetPlayerInvisibleLocally(player, toggle) end

---@param toggle boolean
function SetPlayerIsInAnimalForm(toggle) end

---@param toggle boolean
function SetPlayerIsInDirectorMode(toggle) end

---@param height number
function SetPlayerKillFallHeight(height) end

---@param player integer
---@param toggle boolean
function SetPlayerLeavePedBehind(player, toggle) end

---@param player integer
---@param toggle boolean
function SetPlayerLockon(player, toggle) end

---@param player integer
---@param range number
function SetPlayerLockonRangeOverride(player, range) end

---@param player integer
---@param value integer
function SetPlayerMaxArmour(player, value) end

---@param playerId integer
---@param maxStamina number
---@return boolean
function SetPlayerMaxStamina(playerId, maxStamina) end

---@param player integer
function SetPlayerMayNotEnterAnyVehicle(player) end

---@param player integer
---@param vehicle integer
function SetPlayerMayOnlyEnterThisVehicle(player, vehicle) end

---@param player integer
---@param modifier number
function SetPlayerMeleeWeaponDamageModifier(player, modifier) end

---@param player integer
---@param modifier number
function SetPlayerMeleeWeaponDefenseModifier(player, modifier) end

---@param player integer
---@param model integer | string
function SetPlayerModel(player, model) end

---@param player integer
---@param multiplier number
function SetPlayerNoiseMultiplier(player, multiplier) end

---@param player integer
---@param model integer | string
function SetPlayerParachuteModelOverride(player, model) end

---@param player integer
---@param model integer | string
function SetPlayerParachutePackModelOverride(player, model) end

---@param player integer
---@param tintIndex integer
function SetPlayerParachutePackTintIndex(player, tintIndex) end

---@param player integer
---@param r integer
---@param g integer
---@param b integer
function SetPlayerParachuteSmokeTrailColor(player, r, g, b) end

---@param player integer
---@param tintIndex integer
function SetPlayerParachuteTintIndex(player, tintIndex) end

---@param player integer
---@param p1 integer
---@param p2 any
---@param p3 any
---@param p4 boolean
function SetPlayerParachuteVariationOverride(player, p1, p2, p3, p4) end

---@param player integer
---@param model integer | string
function SetPlayerReserveParachuteModelOverride(player, model) end

---@param player integer
---@param index integer
function SetPlayerReserveParachuteTintIndex(player, index) end

---@param player integer
---@param flags integer
function SetPlayerResetFlagPreferRearSeats(player, flags) end

---@param toggle boolean
function SetPlayerRockstarEditorDisabled(toggle) end

---@param style integer
function SetPlayerShortSwitchStyle(style) end

---@param player integer
---@param toggle boolean
function SetPlayerSimulateAiming(player, toggle) end

---@param player integer
---@param multiplier number
function SetPlayerSneakingNoiseMultiplier(player, multiplier) end

---@param player integer
---@param toggle boolean
function SetPlayerSprint(player, toggle) end

---@param playerId integer
---@param stamina number
---@return boolean
function SetPlayerStamina(playerId, stamina) end

---@param player integer
---@param value number
function SetPlayerStealthPerceptionModifier(player, value) end

---@param name string
function SetPlayerSwitchEstablishingShot(name) end

---@param cameraCoordX number
---@param cameraCoordY number
---@param cameraCoordZ number
---@param camRotationX number
---@param camRotationY number
---@param camRotationZ number
---@param camFov number
---@param camFarClip number
---@param rotationOrder integer
function SetPlayerSwitchOutro(cameraCoordX, cameraCoordY, cameraCoordZ, camRotationX, camRotationY, camRotationZ, camFov, camFarClip, rotationOrder) end

---@param player integer
---@param state boolean
function SetPlayerTalkingOverride(player, state) end

---@param targetLevel integer
function SetPlayerTargetLevel(targetLevel) end

---@param targetMode integer
function SetPlayerTargetingMode(targetMode) end

---@param value number
function SetPlayerTcmodifierTransition(value) end

---@param player integer
---@param team integer
function SetPlayerTeam(player, team) end

---@param player integer
---@param percentage number
---@return any
function SetPlayerUnderwaterTimeRemaining(player, percentage) end

---@param vehicle integer
---@param active boolean
function SetPlayerVehicleAlarmAudioActive(vehicle, active) end

---@param player integer
---@param modifier number
function SetPlayerVehicleDamageModifier(player, modifier) end

---@param player integer
---@param modifier number
function SetPlayerVehicleDefenseModifier(player, modifier) end

---@param player integer
---@param toggle boolean
function SetPlayerVisibleLocally(player, toggle) end

---@param player integer
---@param position vector3
---@param p2 boolean
---@param p3 boolean
function SetPlayerWantedCentrePosition(player, position, p2, p3) end

---@param player integer
---@param wantedLevel integer
---@param delayedResponse boolean
function SetPlayerWantedLevel(player, wantedLevel, delayedResponse) end

---@param player integer
---@param wantedLevel integer
---@param delayedResponse boolean
function SetPlayerWantedLevelNoDrop(player, wantedLevel, delayedResponse) end

---@param player integer
---@param p1 boolean
function SetPlayerWantedLevelNow(player, p1) end

---@param player integer
---@param modifier number
function SetPlayerWeaponDamageModifier(player, modifier) end

---@param player integer
---@param modifier number
function SetPlayerWeaponDefenseModifier(player, modifier) end

---@param player integer
---@param modifier number
function SetPlayerWeaponDefenseModifier_2(player, modifier) end

---@param toggle boolean
function SetPlayerpadShakesWhenControllerDisabled(toggle) end

---@param vehicle integer
function SetPlayersLastVehicle(vehicle) end

---@param isActive boolean
function SetPmWarningscreenActive(isActive) end

---@param vehicle integer
---@param p1 boolean
function SetPoliceFocusWillTrackVehicle(vehicle, p1) end

---@param player integer
---@param toggle boolean
function SetPoliceIgnorePlayer(player, toggle) end

---@param toggle boolean
function SetPoliceRadarBlips(toggle) end

---@param x number
---@param y number
---@param z number
---@param min number
---@param max number
function SetPopControlSphereThisFrame(x, y, z, min, max) end

---@param oldPortalSettingsName string
---@param newPortalSettingsName string
function SetPortalSettingsOverride(oldPortalSettingsName, newPortalSettingsName) end

---@param speakerConversationIndex integer
---@param x number
---@param y number
---@param z number
function SetPositionForNullConvPed(speakerConversationIndex, x, y, z) end

---@param enabled boolean
function SetPositionedPlayerVehicleRadioEmitterEnabled(enabled) end


function SetProfileSettingPrologueComplete() end

---@param toggle boolean
function SetRaceTrackRender(toggle) end


function SetRadarAsExteriorThisFrame() end

---@param interior integer | string
---@param x number
---@param y number
---@param heading integer
---@param zoom integer
function SetRadarAsInteriorThisFrame(interior, x, y, heading, zoom) end

---@param zoomLevel integer
function SetRadarZoom(zoomLevel) end

---@param zoom number
function SetRadarZoomPrecise(zoom) end

---@param blip integer
---@param zoom number
function SetRadarZoomToBlip(blip, zoom) end

---@param zoom number
function SetRadarZoomToDistance(zoom) end

---@param toggle boolean
function SetRadioAutoUnfreeze(toggle) end

---@param fadeTime number
function SetRadioFrontendFadeTime(fadeTime) end


function SetRadioRetuneDown() end


function SetRadioRetuneUp() end

---@param radioStation string
---@param toggle boolean
function SetRadioStationIsVisible(radioStation, toggle) end

---@param radioStation string
---@param toggle boolean
function SetRadioStationMusicOnly(radioStation, toggle) end

---@param radioStation integer
function SetRadioToStationIndex(radioStation) end

---@param stationName string
function SetRadioToStationName(stationName) end

---@param radioStation string
---@param radioTrack string
function SetRadioTrack(radioStation, radioTrack) end

---@param radioStationName string
---@param mixName string
---@param p2 integer
function SetRadioTrackMix(radioStationName, mixName, p2) end

---@param blip integer
---@param toggle boolean
function SetRadiusBlipEdge(blip, toggle) end

---@param ped integer
---@param flags integer
function SetRagdollBlockingFlags(ped, flags) end

---@param level number
function SetRainLevel(level) end

---@param toggle boolean
function SetRandomBoats(toggle) end

---@param toggle boolean
function SetRandomBoatsInMp(toggle) end

---@param toggle boolean
function SetRandomEventFlag(toggle) end

---@param seed integer
function SetRandomSeed(seed) end

---@param toggle boolean
function SetRandomTrains(toggle) end

---@param multiplier number
function SetRandomVehicleDensityMultiplierThisFrame(multiplier) end


function SetRandomWeatherType() end

---@param state boolean
function SetReactionToVehicleSirenDisabled(state) end

---@param vehicle integer
---@param enable boolean
function SetReduceDriftVehicleSuspension(vehicle, enable) end

---@param toggle boolean
function SetReducePedModelBudget(toggle) end

---@param toggle boolean
function SetReduceVehicleModelBudget(toggle) end

---@param relationship integer
---@param group1 integer | string
---@param group2 integer | string
function SetRelationshipBetweenGroups(relationship, group1, group2) end

---@param group integer | string
---@param p1 boolean
function SetRelationshipGroupDontAffectWantedLevel(group, p1) end

---@param player integer
---@param p1 boolean
function SetRelationshipToPlayer(player, p1) end

---@param toggle boolean
function SetRenderHdOnly(toggle) end

---@param train integer
---@param toggle boolean
function SetRenderTrainAsDerailed(train, toggle) end

---@param x number
---@param y number
---@param z number
---@param heading number
function SetRestartCustomPosition(x, y, z, heading) end

---@param presenceState string
function SetRichPresence(presenceState) end

---@param toggle boolean
function SetRiotModeEnabled(toggle) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
function SetRoadsBackToOriginal(p0, p1, p2, p3, p4, p5) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
function SetRoadsBackToOriginalInAngledArea(x1, y1, z1, x2, y2, z2, width) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param width number
---@param unknown1 boolean
---@param unknown2 boolean
---@param unknown3 boolean
function SetRoadsInAngledArea(x1, y1, z1, x2, y2, z2, width, unknown1, unknown2, unknown3) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param nodeEnabled boolean
---@param unknown2 boolean
function SetRoadsInArea(x1, y1, z1, x2, y2, z2, nodeEnabled, unknown2) end

---@param rope integer
---@param lengthChangeRate number
function SetRopeLengthChangeRate(rope, lengthChangeRate) end

---@param shouldCreate boolean
function SetRopesCreateNetworkWorldState(shouldCreate) end

---@param player integer
---@param multiplier number
function SetRunSprintMultiplierForPlayer(player, multiplier) end

---@param tex integer
---@param buffer string
---@param length integer
---@return boolean
function SetRuntimeTextureArgbData(tex, buffer, length) end

---@param tex integer
---@param fileName string
---@return boolean
function SetRuntimeTextureImage(tex, fileName) end

---@param tex integer
---@param x integer
---@param y integer
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function SetRuntimeTexturePixel(tex, x, y, r, g, b, a) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function SetSaveHouse(p0, p1, p2) end

---@param ignoreVehicle boolean
function SetSaveMenuActive(ignoreVehicle) end

---@param transactionId integer
function SetSaveMigrationTransactionId(transactionId) end

---@param scaleformHandle integer
function SetScaleformMovieAsNoLongerNeeded(scaleformHandle) end

---@param scaleformMovieId integer
---@param useLargeRT boolean
function SetScaleformMovieToUseLargeRt(scaleformMovieId, useLargeRT) end

---@param scaleformHandle integer
---@param toggle boolean
function SetScaleformMovieToUseSuperLargeRt(scaleformHandle, toggle) end

---@param scaleform integer
---@param toggle boolean
function SetScaleformMovieToUseSystemTime(scaleform, toggle) end

---@param scenarioGroup string
---@param p1 boolean
function SetScenarioGroupEnabled(scenarioGroup, p1) end

---@param interiorMult number
---@param exteriorMult number
function SetScenarioPedDensityMultiplierThisFrame(interiorMult, exteriorMult) end

---@param x number
---@param y number
---@param z number
---@param range number
---@param p4 integer
function SetScenarioPedsSpawnInSphereArea(x, y, z, range, p4) end

---@param value boolean
function SetScenarioPedsToBeReturnedByNextCommand(value) end

---@param scenarioType string
---@param toggle boolean
function SetScenarioTypeEnabled(scenarioType, toggle) end

---@param scriptName string
function SetScriptAsNoLongerNeeded(scriptName) end

---@param horizontalAlign integer
---@param verticalAlign integer
function SetScriptGfxAlign(horizontalAlign, verticalAlign) end

---@param x number
---@param y number
---@param w number
---@param h number
function SetScriptGfxAlignParams(x, y, w, h) end

---@param flag boolean
function SetScriptGfxDrawBehindPausemenu(flag) end

---@param order integer
function SetScriptGfxDrawOrder(order) end

---@param doorHash integer | string
---@param toggle boolean
function SetScriptUpdateDoorAudio(doorHash, toggle) end

---@param r integer
---@param g integer
---@param b integer
---@param a integer
function SetScriptVariableHudColour(r, g, b, a) end

---@param r integer
---@param g integer
---@param b integer
---@param a integer
function SetScriptVariable_2HudColour(r, g, b, a) end

---@param vehicleGenerator integer
---@param enabled boolean
function SetScriptVehicleGenerator(vehicleGenerator, enabled) end

---@param scriptHash integer | string
function SetScriptWithNameHashAsNoLongerNeeded(scriptHash) end

---@param ped integer
---@param p1 number
function SetScriptedAnimSeatOffset(ped, p1) end

---@param x number
---@param y number
---@param z number
function SetScriptedConversionCoordThisFrame(x, y, z) end

---@param toggle boolean
function SetSeethrough(toggle) end

---@param taskSequenceId integer
---@param _repeat boolean
function SetSequenceToRepeat(taskSequenceId, _repeat) end

---@param vehicle integer
---@param toggle boolean
function SetSirenKeepOn(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetSirenWithNoDriver(vehicle, toggle) end

---@param name string
---@param path string
---@param data string
function SetSnakeoilForEntry(name, path, data) end

---@param level number
function SetSnowLevel(level) end

---@param name string
function SetSocialClubTour(name) end

---@param player integer
---@param p1 integer
function SetSpecialAbility(player, p1) end

---@param multiplier number
function SetSpecialAbilityMultiplier(multiplier) end

---@param vehicle integer
---@param toggle boolean
function SetSpecialFlightModeAllowed(vehicle, toggle) end

---@param vehicle integer
---@param ratio number
function SetSpecialFlightModeRatio(vehicle, ratio) end

---@param vehicle integer
---@param state number
function SetSpecialFlightModeTargetRatio(vehicle, state) end

---@param p0 number
function SetSrlTime(p0) end

---@param type integer | string
---@param x number
---@param y number
---@param z number
---@param locked boolean
---@param heading number
---@param p6 boolean
function SetStateOfClosestDoorOfType(type, x, y, z, locked, heading, p6) end

---@param object integer
---@param state integer
function SetStateOfRayfireMapObject(object, state) end

---@param emitterName string
---@param toggle boolean
function SetStaticEmitterEnabled(emitterName, toggle) end

---@param toggle boolean
function SetStoreEnabled(toggle) end

---@param textureDict string
function SetStreamedTextureDictAsNoLongerNeeded(textureDict) end

---@param toggle boolean
function SetStreaming(toggle) end

---@param toggle boolean
function SetStuntJumpsCanTrigger(toggle) end

---@param vehicle integer
---@param toggle boolean
---@param depth1 number
---@param depth2 number
---@param depth3 number
function SetSubmarineCrushDepths(vehicle, toggle, depth1, depth2, depth3) end

---@param player integer
function SetSuperJumpThisFrame(player) end

---@param player integer
---@param multiplier number
function SetSwimMultiplierForPlayer(player, multiplier) end

---@param sceneID integer
---@param toggle boolean
function SetSynchronizedSceneHoldLastFrame(sceneID, toggle) end

---@param sceneID integer
---@param toggle boolean
function SetSynchronizedSceneLooped(sceneID, toggle) end

---@param sceneID integer
---@param x number
---@param y number
---@param z number
---@param roll number
---@param pitch number
---@param yaw number
---@param p7 boolean
function SetSynchronizedSceneOrigin(sceneID, x, y, z, roll, pitch, yaw, p7) end

---@param sceneID integer
---@param phase number
function SetSynchronizedScenePhase(sceneID, phase) end

---@param sceneID integer
---@param rate number
function SetSynchronizedSceneRate(sceneID, rate) end

---@param hash integer | string
---@return boolean
function SetTableGamesCameraThisUpdate(hash) end

---@param ped integer
---@param signalName string
---@param value boolean
function SetTaskMoveNetworkSignalBool(ped, signalName, value) end

---@param ped integer
---@param signalName string
---@param value number
function SetTaskMoveNetworkSignalFloat(ped, signalName, value) end

---@param ped integer
---@param signalName string
---@param value number
function SetTaskMoveNetworkSignalFloat_2(ped, signalName, value) end

---@param ped integer
---@param flag integer
---@param set boolean
function SetTaskVehicleChaseBehaviorFlag(ped, flag, set) end

---@param ped integer
---@param distance number
function SetTaskVehicleChaseIdealPursuitDistance(ped, distance) end

---@param plane integer
---@param height integer
function SetTaskVehicleGotoPlaneMinHeightAboveTerrain(plane, height) end

---@param vehicle integer
---@param state boolean
function SetTaxiLights(vehicle, state) end

---@param object integer
---@param p1 any
---@param p2 boolean
function SetTeamPickupObject(object, p1, p2) end

---@param align boolean
function SetTextCentre(align) end

---@param enabled boolean
---@return boolean
function SetTextChatEnabled(enabled) end

---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function SetTextColour(red, green, blue, alpha) end


function SetTextDropShadow() end

---@param distance integer
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function SetTextDropshadow(distance, r, g, b, a) end

---@param p0 integer
---@param r integer
---@param g integer
---@param b integer
---@param a integer
function SetTextEdge(p0, r, g, b, a) end

---@param fontType integer
function SetTextFont(fontType) end

---@param fontId integer
function SetTextFontForCurrentCommand(fontId) end

---@param state boolean
function SetTextInputBoxEnabled(state) end

---@param justifyType integer
function SetTextJustification(justifyType) end

---@param p0 integer
function SetTextLeading(p0) end


function SetTextOutline() end

---@param p0 boolean
function SetTextProportional(p0) end

---@param renderId integer
function SetTextRenderId(renderId) end

---@param toggle boolean
function SetTextRightJustify(toggle) end

---@param scale number
---@param size number
function SetTextScale(scale, size) end

---@param start number
---@param _end number
function SetTextWrap(start, _end) end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param modelHash integer | string
---@param textureVariation integer
---@return boolean
function SetTextureVariationOfClosestObjectOfType(x, y, z, radius, modelHash, textureVariation) end

---@param distance number
function SetThirdPersonAimCamNearClipThisUpdate(distance) end

---@param toggle boolean
function SetThisScriptCanBePaused(toggle) end

---@param toggle boolean
function SetThisScriptCanRemoveBlipsCreatedByAnyScript(toggle) end

---@param priority integer
function SetThreadPriority(priority) end

---@param timeScale number
function SetTimeScale(timeScale) end

---@param modifierName string
function SetTimecycleModifier(modifierName) end

---@param strength number
function SetTimecycleModifierStrength(strength) end

---@param modifierName string
---@param varName string
---@param value1 number
---@param value2 number
function SetTimecycleModifierVar(modifierName, varName, value1, value2) end

---@param track integer
---@param brakingDistance number
function SetTrackBrakingDistance(track, brakingDistance) end

---@param track integer
---@param enabled boolean
function SetTrackEnabled(track, enabled) end

---@param junctionIndex integer
---@param state boolean
---@return boolean
function SetTrackJunctionActive(junctionIndex, state) end

---@param track integer
---@param newSpeed integer
function SetTrackMaxSpeed(track, newSpeed) end

---@param point integer
---@param x number
---@param y number
---@param z number
---@param radius number
function SetTrackedPointInfo(point, x, y, z, radius) end

---@param vehicle integer
---@param enabled boolean
function SetTrailerAttachmentEnabled(vehicle, enabled) end

---@param vehicle integer
---@param p1 number
function SetTrailerInverseMassScale(vehicle, p1) end


function SetTrailerLegsLowered() end

---@param vehicle integer
function SetTrailerLegsRaised(vehicle) end

---@param train integer
---@param speed number
function SetTrainCruiseSpeed(train, speed) end

---@param train integer
---@param doorIndex integer
---@param ratio number
function SetTrainDoorOpenRatio(train, doorIndex, ratio) end

---@param train integer
---@param speed number
function SetTrainSpeed(train, speed) end

---@param train integer
---@param state integer
function SetTrainState(train, state) end

---@param train integer
---@param state boolean
function SetTrainStopAtStations(train, state) end

---@param trackIndex integer
---@param frequency integer
function SetTrainTrackSpawnFrequency(trackIndex, frequency) end

---@param forceOpen boolean
function SetTrainsForceDoorsOpen(forceOpen) end

---@param vehicle integer
---@param transformRate number
function SetTransformRateForAnimation(vehicle, transformRate) end

---@param vehicle integer
---@param useAlternateInput boolean
function SetTransformToSubmarineUsesAlternateInput(vehicle, useAlternateInput) end

---@param transitionTime number
function SetTransitionOutOfTimecycleModifier(transitionTime) end

---@param modifierName string
---@param transition number
function SetTransitionTimecycleModifier(modifierName, transition) end

---@param toggle boolean
function SetTvAudioFrontend(toggle) end

---@param channel integer
function SetTvChannel(channel) end

---@param tvChannel integer
---@param playlistName string
---@param restart boolean
function SetTvChannelPlaylist(tvChannel, playlistName, restart) end

---@param tvChannel integer
---@param playlistName string
---@param hour integer
function SetTvChannelPlaylistAtHour(tvChannel, playlistName, hour) end

---@param volume number
function SetTvVolume(volume) end

---@param vehicle integer
---@param wheelIndex integer
---@param health number
function SetTyreHealth(vehicle, wheelIndex, health) end

---@param vehicle integer
---@param wheelIndex integer
---@param multiplier number
function SetTyreSoftnessMultiplier(vehicle, wheelIndex, multiplier) end

---@param vehicle integer
---@param wheelIndex integer
---@param multiplier number
function SetTyreTractionLossMultiplier(vehicle, wheelIndex, multiplier) end

---@param vehicle integer
---@param wheelIndex integer
---@param multiplier number
function SetTyreWearMultiplier(vehicle, wheelIndex, multiplier) end

---@param value boolean
function SetUnkGlobalBoolRelatedToDamage(value) end


function SetUseHiDof() end


function SetUseHiDofInCutscene() end

---@param vehicle integer
---@param toggle boolean
function SetUseHigherVehicleJumpForce(vehicle, toggle) end

---@param toggle boolean
function SetUseIslandMap(toggle) end

---@param toggle boolean
function SetUseWaypointAsDestination(toggle) end

---@param toggle boolean
function SetUserRadioControlEnabled(toggle) end

---@param variableName string
---@param value number
function SetVariableOnCutsceneAudio(variableName, value) end

---@param soundId integer
---@param variableName string
---@param value number
function SetVariableOnSound(soundId, variableName, value) end

---@param p0 string
---@param p1 number
function SetVariableOnStream(p0, p1) end

---@param variableName string
---@param value number
function SetVariableOnUnderWaterStream(variableName, value) end

---@param vehicle integer
function SetVehHasRadioOverride(vehicle) end

---@param vehicle integer
---@param radioStation string
function SetVehRadioStation(vehicle, radioStation) end

---@param vehicle integer
---@param actHighSpeed boolean
function SetVehicleActAsIfHighSpeedForFragSmashing(vehicle, actHighSpeed) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleActiveDuringPlayback(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleActiveForPedNavigation(vehicle, toggle) end

---@param vehicle integer
---@param state boolean
function SetVehicleAlarm(vehicle, state) end

---@param vehicle integer
---@param time integer
function SetVehicleAlarmTimeLeft(vehicle, time) end

---@param vehicle integer
---@param toggle boolean
---@param p2 boolean
function SetVehicleAllowHomingMissleLockon(vehicle, toggle, p2) end

---@param veh integer
---@param toggle boolean
function SetVehicleAllowNoPassengersLockon(veh, toggle) end

---@param vehicle integer
function SetVehicleAsNoLongerNeeded(vehicle) end

---@param vehicle integer
---@param intensity number
function SetVehicleAudioBodyDamageFactor(vehicle, intensity) end

---@param vehicle integer
---@param damageFactor number
function SetVehicleAudioEngineDamageFactor(vehicle, damageFactor) end

---@param vehicle integer
---@param value boolean
function SetVehicleAutoRepairDisabled(vehicle, value) end

---@param vehicle integer
---@param p1 boolean
---@param p2 any
---@return any
function SetVehicleAutomaticallyAttaches(vehicle, p1, p2) end

---@param vehicle integer
---@param value number
function SetVehicleBodyHealth(vehicle, value) end

---@param aircraft integer
---@param bombCount integer
function SetVehicleBombCount(aircraft, bombCount) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleBoostActive(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleBrake(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleBrakeLights(vehicle, toggle) end

---@param vehicle integer
---@param position number
---@param p2 boolean
function SetVehicleBulldozerArmPosition(vehicle, position, p2) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleBurnout(vehicle, toggle) end

---@param vehicle integer
---@param canBeLockedOn boolean
---@param unk boolean
function SetVehicleCanBeLockedOn(vehicle, canBeLockedOn, unk) end

---@param vehicle integer
---@param state boolean
function SetVehicleCanBeTargetted(vehicle, state) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanBeUsedByFleeingPeds(vehicle, toggle) end

---@param vehicle integer
---@param state boolean
function SetVehicleCanBeVisiblyDamaged(vehicle, state) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanBreak(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanDeformWheels(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanEngineOperateOnFire(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanLeakOil(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanLeakPetrol(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleCanSaveInGarage(vehicle, toggle) end

---@param vehicle integer
---@param height number
function SetVehicleCeilingHeight(vehicle, height) end

---@param vehicle integer
---@param value number
function SetVehicleCheatPowerIncrease(vehicle, value) end

---@param vehicle integer
---@param clutch number
function SetVehicleClutch(vehicle, clutch) end

---@param vehicle integer
---@param colorCombination integer
function SetVehicleColourCombination(vehicle, colorCombination) end

---@param vehicle integer
---@param colorPrimary integer
---@param colorSecondary integer
function SetVehicleColours(vehicle, colorPrimary, colorSecondary) end

---@param vehicle integer
---@param state boolean
function SetVehicleControlsInverted(vehicle, state) end

---@param aircraft integer
---@param count integer
function SetVehicleCountermeasureCount(aircraft, count) end

---@param vehicle integer
---@param gear integer
function SetVehicleCurrentGear(vehicle, gear) end

---@param vehicle integer
---@param rpm number
function SetVehicleCurrentRpm(vehicle, rpm) end

---@param vehicle integer
---@param r integer
---@param g integer
---@param b integer
function SetVehicleCustomPrimaryColour(vehicle, r, g, b) end

---@param vehicle integer
---@param r integer
---@param g integer
---@param b integer
function SetVehicleCustomSecondaryColour(vehicle, r, g, b) end

---@param vehicle integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param damage number
---@param radius number
---@param focusOnModel boolean
function SetVehicleDamage(vehicle, xOffset, yOffset, zOffset, damage, radius, focusOnModel) end

---@param vehicle integer
---@param p1 number
---@return any
function SetVehicleDamageModifier(vehicle, p1) end

---@param vehicle integer
---@param color integer
function SetVehicleDashboardColor(vehicle, color) end

---@param vehicle integer
function SetVehicleDeformationFixed(vehicle) end

---@param multiplier number
function SetVehicleDensityMultiplierThisFrame(multiplier) end

---@param vehicle integer
---@param dirtLevel number
function SetVehicleDirtLevel(vehicle, dirtLevel) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleDisableTowing(vehicle, toggle) end

---@param vehicle integer
---@param doorIndex integer
---@param deleteDoor boolean
function SetVehicleDoorBroken(vehicle, doorIndex, deleteDoor) end

---@param vehicle integer
---@param doorIndex integer
---@param isBreakable boolean
function SetVehicleDoorCanBreak(vehicle, doorIndex, isBreakable) end

---@param vehicle integer
---@param doorIndex integer
---@param speed integer
---@param angle number
function SetVehicleDoorControl(vehicle, doorIndex, speed, angle) end

---@param vehicle integer
---@param doorIndex integer
---@param forceClose boolean
---@param lock boolean
---@param p4 boolean
function SetVehicleDoorLatched(vehicle, doorIndex, forceClose, lock, p4) end

---@param vehicle integer
---@param doorIndex integer
---@param loose boolean
---@param openInstantly boolean
function SetVehicleDoorOpen(vehicle, doorIndex, loose, openInstantly) end

---@param vehicle integer
---@param doorIndex integer
---@param closeInstantly boolean
function SetVehicleDoorShut(vehicle, doorIndex, closeInstantly) end

---@param vehicle integer
---@param doorLockStatus integer
function SetVehicleDoorsLocked(vehicle, doorLockStatus) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleDoorsLockedForAllPlayers(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleDoorsLockedForNonScriptPlayers(vehicle, toggle) end

---@param vehicle integer
---@param player integer
---@param toggle boolean
function SetVehicleDoorsLockedForPlayer(vehicle, player, toggle) end

---@param vehicle integer
---@param team integer
---@param toggle boolean
function SetVehicleDoorsLockedForTeam(vehicle, team, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleDoorsLockedForUnk(vehicle, toggle) end

---@param vehicle integer
---@param closeInstantly boolean
function SetVehicleDoorsShut(vehicle, closeInstantly) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleDropsMoneyWhenBlownUp(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleEngineCanDegrade(vehicle, toggle) end

---@param vehicle integer
---@param health number
function SetVehicleEngineHealth(vehicle, health) end

---@param vehicle integer
---@param value boolean
---@param instantly boolean
---@param disableAutoStart boolean
function SetVehicleEngineOn(vehicle, value, instantly, disableAutoStart) end

---@param vehicle integer
---@param temperature number
function SetVehicleEngineTemperature(vehicle, temperature) end

---@param vehicle integer
---@param fade number
function SetVehicleEnveffScale(vehicle, fade) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleExclusiveDriver(vehicle, toggle) end

---@param vehicle integer
---@param ped integer
---@param index integer
function SetVehicleExclusiveDriver_2(vehicle, ped, index) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleExplodesOnHighExplosionDamage(vehicle, toggle) end

---@param vehicle integer
---@param scale number
---@return any
function SetVehicleExplosiveDamageScale(vehicle, scale) end

---@param vehicle integer
---@param range integer
function SetVehicleExtendedRemovalRange(vehicle, range) end

---@param vehicle integer
---@param extraId integer
---@param disable boolean
function SetVehicleExtra(vehicle, extraId, disable) end

---@param vehicle integer
---@param pearlescentColor integer
---@param wheelColor integer
function SetVehicleExtraColours(vehicle, pearlescentColor, wheelColor) end

---@param vehicle integer
function SetVehicleFixed(vehicle) end

---@param vehicle integer
---@param flagIndex integer
---@param value boolean
---@return boolean
function SetVehicleFlag(vehicle, flagIndex, value) end

---@param vehicle integer
---@param angleRatio number
function SetVehicleFlightNozzlePosition(vehicle, angleRatio) end

---@param vehicle integer
---@param angle number
function SetVehicleFlightNozzlePositionImmediate(vehicle, angle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleForceAfterburner(vehicle, toggle) end

---@param vehicle integer
---@param speed number
function SetVehicleForwardSpeed(vehicle, speed) end

---@param vehicle integer
---@param friction number
function SetVehicleFrictionOverride(vehicle, friction) end

---@param vehicle integer
---@param level number
function SetVehicleFuelLevel(vehicle, level) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleFullbeam(vehicle, toggle) end

---@param vehicle integer
---@param gear integer
---@param ratio number
function SetVehicleGearRatio(vehicle, gear, ratio) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleGeneratesEngineShockingEvents(vehicle, toggle) end

---@param x number
---@param y number
---@param z number
---@param radius number
function SetVehicleGeneratorAreaOfInterest(x, y, z, radius) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleGravity(vehicle, toggle) end

---@param vehicle integer
---@param gravity number
function SetVehicleGravityAmount(vehicle, gravity) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleHandbrake(vehicle, toggle) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@param value any
function SetVehicleHandlingField(vehicle, class_, fieldName, value) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@param value number
function SetVehicleHandlingFloat(vehicle, class_, fieldName, value) end

---@param vehicle integer
---@param hash integer | string
function SetVehicleHandlingHashForAi(vehicle, hash) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@param value integer
function SetVehicleHandlingInt(vehicle, class_, fieldName, value) end

---@param vehicle integer
---@param class_ string
---@param fieldName string
---@param value vector3
function SetVehicleHandlingVector(vehicle, class_, fieldName, value) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleHasBeenDrivenFlag(vehicle, toggle) end

---@param vehicle integer
---@param owned boolean
function SetVehicleHasBeenOwnedByPlayer(vehicle, owned) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleHasMutedSirens(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleHasStrongAxles(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleHasUnbreakableLights(vehicle, toggle) end

---@param vehicle integer
---@param flag integer
function SetVehicleHeadlightShadows(vehicle, flag) end

---@param vehicle integer
---@param gear integer
function SetVehicleHighGear(vehicle, gear) end

---@param vehicle integer
---@param value integer
function SetVehicleHornVariation(vehicle, value) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleInactiveDuringPlayback(vehicle, toggle) end

---@param vehicle integer
---@param turnSignal integer
---@param toggle boolean
function SetVehicleIndicatorLights(vehicle, turnSignal, toggle) end

---@param vehicle integer
---@param doorIndex integer
---@param doorLockStatus integer
function SetVehicleIndividualDoorsLocked(vehicle, doorIndex, doorLockStatus) end

---@param vehicle integer
---@param influenceWantedLevel boolean
function SetVehicleInfluencesWantedLevel(vehicle, influenceWantedLevel) end

---@param vehicle integer
---@param color integer
function SetVehicleInteriorColor(vehicle, color) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleInteriorlight(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleIsConsideredByPlayer(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleIsRacing(vehicle, toggle) end

---@param vehicle integer
---@param isStolen boolean
function SetVehicleIsStolen(vehicle, isStolen) end

---@param vehicle integer
---@param state boolean
function SetVehicleIsWanted(vehicle, state) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleKeepEngineOnWhenAbandoned(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleKersAllowed(vehicle, toggle) end

---@param vehicle integer
---@param multiplier number
function SetVehicleLightMultiplier(vehicle, multiplier) end

---@param vehicle integer
---@param state integer
function SetVehicleLights(vehicle, state) end

---@param vehicle integer
---@param livery integer
function SetVehicleLivery(vehicle, livery) end

---@param vehicle integer
---@param multiplier number
function SetVehicleLodMultiplier(vehicle, multiplier) end

---@param vehicle integer
---@param speed number
function SetVehicleMaxSpeed(vehicle, speed) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleMissileWarningEnabled(vehicle, toggle) end

---@param vehicle integer
---@param modType integer
---@param modIndex integer
---@param customTires boolean
function SetVehicleMod(vehicle, modType, modIndex, customTires) end

---@param vehicle integer
---@param paintType integer
---@param color integer
---@param pearlescentColor integer
function SetVehicleModColor_1(vehicle, paintType, color, pearlescentColor) end

---@param vehicle integer
---@param paintType integer
---@param color integer
function SetVehicleModColor_2(vehicle, paintType, color) end

---@param vehicle integer
---@param modKit integer
function SetVehicleModKit(vehicle, modKit) end

---@param model integer | string
---@param suppressed boolean
function SetVehicleModelIsSuppressed(model, suppressed) end

---@param vehicle integer
---@param name string
function SetVehicleNameDebug(vehicle, name) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleNeedsToBeHotwired(vehicle, toggle) end

---@param vehicle integer
---@param index integer
---@param toggle boolean
function SetVehicleNeonLightEnabled(vehicle, index, toggle) end

---@param vehicle integer
---@param color integer
function SetVehicleNeonLightsColor_2(vehicle, color) end

---@param vehicle integer
---@param r integer
---@param g integer
---@param b integer
function SetVehicleNeonLightsColour(vehicle, r, g, b) end

---@param vehicle integer
---@param nextGear integer
function SetVehicleNextGear(vehicle, nextGear) end

---@param range number
function SetVehicleNitroPtfxRange(range) end

---@param vehicle integer
---@param plateText string
function SetVehicleNumberPlateText(vehicle, plateText) end

---@param vehicle integer
---@param plateIndex integer
function SetVehicleNumberPlateTextIndex(vehicle, plateIndex) end

---@param vehicle integer
---@param level number
function SetVehicleOilLevel(vehicle, level) end

---@param vehicle integer
---@return boolean
function SetVehicleOnGroundProperly(vehicle) end

---@param vehicle integer
---@param killDriver boolean
---@param explodeOnImpact boolean
function SetVehicleOutOfControl(vehicle, killDriver, explodeOnImpact) end

---@param vehicle integer
---@param active boolean
function SetVehicleParachuteActive(vehicle, active) end

---@param vehicle integer
---@param modelHash integer | string
function SetVehicleParachuteModel(vehicle, modelHash) end

---@param vehicle integer
---@param textureVariation integer
function SetVehicleParachuteTextureVariation(vehicle, textureVariation) end

---@param vehicle integer
---@param health number
function SetVehiclePetrolTankHealth(vehicle, health) end

---@param vehicle integer
---@param value number
function SetVehiclePitchBias(vehicle, value) end

---@param p0 integer
function SetVehiclePopulationBudget(p0) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleProvidesCover(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleRadioEnabled(vehicle, toggle) end

---@param vehicle integer
---@param loud boolean
function SetVehicleRadioLoud(vehicle, loud) end

---@param vehicle integer
---@param p1 number
function SetVehicleRampLaunchModifier(vehicle, p1) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleRampSidewaysLaunchMotion(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleRampUpwardsLaunchMotion(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleReceivesRampDamage(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleReduceGrip(vehicle, toggle) end

---@param vehicle integer
---@param val integer
function SetVehicleReduceTraction(vehicle, val) end

---@param vehicle integer
---@param active boolean
function SetVehicleRocketBoostActive(vehicle, active) end

---@param vehicle integer
---@param percentage number
function SetVehicleRocketBoostPercentage(vehicle, percentage) end

---@param vehicle integer
---@param time number
function SetVehicleRocketBoostRefillTime(vehicle, time) end

---@param vehicle integer
---@param value number
function SetVehicleRollBias(vehicle, value) end

---@param vehicle integer
---@param livery integer
function SetVehicleRoofLivery(vehicle, livery) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleRudderBroken(vehicle, toggle) end

---@param heli integer
---@param toggle boolean
---@param canBeUsedByAI boolean
function SetVehicleSearchlight(heli, toggle, canBeUsedByAI) end

---@param vehicle integer
---@param p1 integer
---@param p2 integer
function SetVehicleShadowEffect(vehicle, p1, p2) end

---@param driver integer
---@param entity integer
---@param xTarget number
---@param yTarget number
---@param zTarget number
function SetVehicleShootAtTarget(driver, entity, xTarget, yTarget, zTarget) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleSilent(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleSiren(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleSt(vehicle, toggle) end

---@param vehicle integer
---@param soundName string
---@param setName string
function SetVehicleStartupRevSound(vehicle, soundName, setName) end

---@param vehicle integer
---@param value number
function SetVehicleSteerBias(vehicle, value) end

---@param vehicle integer
---@param angle number
function SetVehicleSteeringAngle(vehicle, angle) end

---@param vehicle integer
---@param scalar number
function SetVehicleSteeringBiasScalar(vehicle, scalar) end

---@param vehicle integer
---@param scale number
function SetVehicleSteeringScale(vehicle, scale) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleStrong(vehicle, toggle) end

---@param vehicle integer
---@param newHeight number
function SetVehicleSuspensionHeight(vehicle, newHeight) end

---@param vehicle integer
---@param position number
---@param p2 boolean
function SetVehicleTankTurretPosition(vehicle, position, p2) end

---@param vehicle integer
---@param ped integer
---@param toggle boolean
function SetVehicleTimedExplosion(vehicle, ped, toggle) end

---@param vehicle integer
---@param position number
function SetVehicleTowTruckArmPosition(vehicle, position) end

---@param vehicle integer
---@param pressure number
function SetVehicleTurboPressure(vehicle, pressure) end

---@param vehicle integer
---@param speed number
function SetVehicleTurretSpeedThisFrame(vehicle, speed) end

---@param vehicle integer
---@param index integer
---@param toggle boolean
function SetVehicleTurretUnk(vehicle, index, toggle) end

---@param vehicle integer
---@param index integer
---@param onRim boolean
---@param p3 number
function SetVehicleTyreBurst(vehicle, index, onRim, p3) end

---@param vehicle integer
---@param tyreIndex integer
function SetVehicleTyreFixed(vehicle, tyreIndex) end

---@param vehicle integer
---@param r integer
---@param g integer
---@param b integer
function SetVehicleTyreSmokeColor(vehicle, r, g, b) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleTyresCanBurst(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleUndriveable(vehicle, toggle) end

---@param vehicle integer
---@param multiplier number
function SetVehicleUnkDamageMultiplier(vehicle, multiplier) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleUseAlternateHandling(vehicle, toggle) end

---@param p0 integer
---@param p1 boolean
---@param p2 boolean
---@param p3 boolean
---@return any
function SetVehicleUseCutsceneWheelCompression(p0, p1, p2, p3) end

---@param vehicle integer
---@param bToggle boolean
function SetVehicleUseHornButtonForNitrous(vehicle, bToggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleUsePlayerLightSettings(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleUsesLargeRearRamp(vehicle, toggle) end

---@param vehicle integer
---@param weaponIndex integer
---@param ammoCount integer
function SetVehicleWeaponRestrictedAmmo(vehicle, weaponIndex, ammoCount) end

---@param vehicle integer
---@param weaponSlot integer
function SetVehicleWeaponsDisabled(vehicle, weaponSlot) end

---@param vehicle integer
---@param wheelIndex integer
---@param pressure number
function SetVehicleWheelBrakePressure(vehicle, wheelIndex, pressure) end

---@param vehicle integer
---@param wheelIndex integer
---@param flags integer
function SetVehicleWheelFlags(vehicle, wheelIndex, flags) end

---@param vehicle integer
---@param wheelIndex integer
---@param health number
function SetVehicleWheelHealth(vehicle, wheelIndex, health) end

---@param vehicle integer
---@param wheelIndex integer
---@param powered boolean
function SetVehicleWheelIsPowered(vehicle, wheelIndex, powered) end

---@param vehicle integer
---@param wheelIndex integer
---@param power number
function SetVehicleWheelPower(vehicle, wheelIndex, power) end

---@param vehicle integer
---@param wheelIndex integer
---@param value number
function SetVehicleWheelRimColliderSize(vehicle, wheelIndex, value) end

---@param vehicle integer
---@param wheelIndex integer
---@param speed number
function SetVehicleWheelRotationSpeed(vehicle, wheelIndex, speed) end

---@param vehicle integer
---@param size number
---@return boolean
function SetVehicleWheelSize(vehicle, size) end

---@param vehicle integer
---@param wheelIndex integer
---@param value number
function SetVehicleWheelTireColliderSize(vehicle, wheelIndex, value) end

---@param vehicle integer
---@param wheelIndex integer
---@param value number
function SetVehicleWheelTireColliderWidth(vehicle, wheelIndex, value) end

---@param vehicle integer
---@param wheelIndex integer
---@param length number
function SetVehicleWheelTractionVectorLength(vehicle, wheelIndex, length) end

---@param vehicle integer
---@param wheelType integer
function SetVehicleWheelType(vehicle, wheelType) end

---@param vehicle integer
---@param width number
---@return boolean
function SetVehicleWheelWidth(vehicle, width) end

---@param vehicle integer
---@param wheelIndex integer
---@param offset number
function SetVehicleWheelXOffset(vehicle, wheelIndex, offset) end

---@param vehicle integer
---@param wheelIndex integer
---@param value number
function SetVehicleWheelYRotation(vehicle, wheelIndex, value) end

---@param vehicle integer
---@param state integer
function SetVehicleWheelieState(vehicle, state) end

---@param vehicle integer
---@param enabled boolean
function SetVehicleWheelsCanBreak(vehicle, enabled) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleWheelsCanBreakOffWhenBlowUp(vehicle, toggle) end

---@param vehicle integer
---@param toggle boolean
function SetVehicleWheelsDealDamage(vehicle, toggle) end

---@param vehicle integer
---@param tint integer
function SetVehicleWindowTint(vehicle, tint) end

---@param vehicle integer
---@param color integer
function SetVehicleXenonLightsColor(vehicle, color) end

---@param vehicle integer
---@param red integer
---@param green integer
---@param blue integer
function SetVehicleXenonLightsCustomColor(vehicle, red, green, blue) end

---@param gripFactor number
function SetVehicleXmasSnowFactor(gripFactor) end

---@param name string
---@param value number
function SetVisualSettingFloat(name, value) end

---@param entity integer
---@param toggle boolean
function SetWaitForCollisionsBeforeProbe(entity, toggle) end

---@param player integer
---@param difficulty number
function SetWantedLevelDifficulty(player, difficulty) end

---@param player integer
---@param wantedLevel integer
---@param lossTime integer
function SetWantedLevelHiddenEvasionTime(player, wantedLevel, lossTime) end

---@param multiplier number
function SetWantedLevelMultiplier(multiplier) end

---@param entryLine1 string
---@param instructionalKey integer
---@param entryLine2 string
---@param p3 boolean
---@param p4 integer
---@param background string
---@param p6 string
---@param showBg boolean
---@param errorCode integer
function SetWarningMessage(entryLine1, instructionalKey, entryLine2, p3, p4, background, p6, showBg, errorCode) end

---@param index integer
---@param name string
---@param cash integer
---@param rp integer
---@param lvl integer
---@param colour integer
---@return boolean
function SetWarningMessageOptionItems(index, name, cash, rp, lvl, colour) end

---@param labelTitle string
---@param labelMsg string
---@param p2 integer
---@param p3 integer
---@param labelMsg2 string
---@param p5 boolean
---@param p6 integer
---@param p7 integer
---@param p8 string
---@param p9 string
---@param background boolean
---@param errorCode integer
function SetWarningMessageWithAlert(labelTitle, labelMsg, p2, p3, labelMsg2, p5, p6, p7, p8, p9, background, errorCode) end

---@param titleMsg string
---@param entryLine1 string
---@param flags integer
---@param promptMsg string
---@param p4 boolean
---@param p5 any
---@param background boolean
---@param showBg boolean
---@return any
function SetWarningMessageWithHeader(titleMsg, entryLine1, flags, promptMsg, p4, p5, background, showBg) end

---@param entryHeader string
---@param entryLine1 string
---@param instructionalKey any
---@param entryLine2 string
---@param p4 boolean
---@param p5 any
---@param p6 any
---@param p9 boolean
---@return any, any
function SetWarningMessageWithHeaderAndSubstringFlags(entryHeader, entryLine1, instructionalKey, entryLine2, p4, p5, p6, p9) end

---@param headerTextLabel string
---@param line1TextLabel string
---@param buttonsBitField integer
---@param buttonsBitFieldUpper integer
---@param line2TextLabel string
---@param addNumber boolean
---@param numberToAdd integer
---@param firstSubstring string
---@param secondSubstring string
---@param showBackground boolean
---@param errorCode integer
function SetWarningMessageWithHeaderExtended(headerTextLabel, line1TextLabel, buttonsBitField, buttonsBitFieldUpper, line2TextLabel, addNumber, numberToAdd, firstSubstring, secondSubstring, showBackground, errorCode) end

---@param minX integer
---@param minY integer
---@param maxX integer
---@param maxY integer
function SetWaterAreaClipRect(minX, minY, maxX, maxY) end

---@param waterQuad integer
---@param a0 integer
---@param a1 integer
---@param a2 integer
---@param a3 integer
---@return boolean
function SetWaterQuadAlpha(waterQuad, a0, a1, a2, a3) end

---@param waterQuad integer
---@param minX integer
---@param minY integer
---@param maxX integer
---@param maxY integer
---@return boolean
function SetWaterQuadBounds(waterQuad, minX, minY, maxX, maxY) end

---@param waterQuad integer
---@param hasLimitedDepth boolean
---@return boolean
function SetWaterQuadHasLimitedDepth(waterQuad, hasLimitedDepth) end

---@param waterQuad integer
---@param isInvisible boolean
---@return boolean
function SetWaterQuadIsInvisible(waterQuad, isInvisible) end

---@param waterQuad integer
---@param level number
---@return boolean
function SetWaterQuadLevel(waterQuad, level) end

---@param waterQuad integer
---@param noStencil boolean
---@return boolean
function SetWaterQuadNoStencil(waterQuad, noStencil) end

---@param waterQuad integer
---@param type integer
---@return boolean
function SetWaterQuadType(waterQuad, type) end

---@param waveQuad integer
---@param amplitude number
---@return boolean
function SetWaveQuadAmplitude(waveQuad, amplitude) end

---@param waveQuad integer
---@param minX integer
---@param minY integer
---@param maxX integer
---@param maxY integer
---@return boolean
function SetWaveQuadBounds(waveQuad, minX, minY, maxX, maxY) end

---@param waveQuad integer
---@param directionX number
---@param directionY number
---@return boolean
function SetWaveQuadDirection(waveQuad, directionX, directionY) end


function SetWaypointOff() end

---@param weaponHash integer | string
---@param spread number
function SetWeaponAccuracySpread(weaponHash, spread) end

---@param ped integer
---@param animStyle integer | string
function SetWeaponAnimationOverride(ped, animStyle) end

---@param weaponHash integer | string
---@param damageMultiplier number
function SetWeaponDamageModifier(weaponHash, damageMultiplier) end

---@param weaponHash integer | string
---@param multiplier number
function SetWeaponExplosionRadiusMultiplier(weaponHash, multiplier) end

---@param weaponObject integer
---@param camoComponentHash integer | string
---@param colorIndex integer
function SetWeaponObjectLiveryColor(weaponObject, camoComponentHash, colorIndex) end

---@param weapon integer
---@param tintIndex integer
function SetWeaponObjectTintIndex(weapon, tintIndex) end

---@param weaponHash integer | string
---@param amplitude number
function SetWeaponRecoilShakeAmplitude(weaponHash, amplitude) end

---@param state boolean
function SetWeaponsNoAimBlocking(state) end

---@param state boolean
function SetWeaponsNoAutoreload(state) end

---@param state boolean
function SetWeaponsNoAutoswap(state) end

---@param index integer
---@param typeName string
---@param timeMult integer
---@return boolean
function SetWeatherCycleEntry(index, typeName, timeMult) end

---@param network boolean
function SetWeatherOwnedByNetwork(network) end

---@param weatherType string
function SetWeatherTypeNow(weatherType) end

---@param weatherType string
function SetWeatherTypeNowPersist(weatherType) end

---@param weatherType string
---@param time number
function SetWeatherTypeOvertimePersist(weatherType, time) end

---@param weatherType string
function SetWeatherTypePersist(weatherType) end

---@param weatherType1 integer | string
---@param weatherType2 integer | string
---@param percentWeather2 number
function SetWeatherTypeTransition(weatherType1, weatherType2, percentWeather2) end

---@param scale number
function SetWetClothPinRadiusScale(scale) end

---@param p0 boolean
---@param p1 integer
function SetWidescreenBorders(p0, p1) end

---@param p0 any
function SetWidescreenFormat(p0) end

---@param speed number
function SetWind(speed) end

---@param direction number
function SetWindDirection(direction) end

---@param speed number
function SetWindSpeed(speed) end

---@param zoneId integer
---@param toggle boolean
function SetZoneEnabled(zoneId, toggle) end

---@param value integer
function Settimera(value) end

---@param value integer
function Settimerb(value) end

---@param p0 integer
---@param p1 integer
---@param p2 integer
---@param p3 integer
---@return integer
function SetupShopPedApparelQuery(p0, p1, p2, p3) end

---@param character integer
---@param p1 integer
---@param p2 integer
---@param p3 boolean
---@param p4 integer
---@param componentId integer
---@return integer
function SetupShopPedApparelQueryTu(character, p1, p2, p3, p4, componentId) end

---@param character integer
---@param p1 boolean
---@return integer
function SetupShopPedOutfitQuery(character, p1) end

---@param cam integer
---@param shakeName string
---@param intensity number
function ShakeCam(cam, shakeName, intensity) end

---@param shakeName string
---@param intensity number
function ShakeCinematicCam(shakeName, intensity) end

---@param shakeName string
---@param intensity number
function ShakeGameplayCam(shakeName, intensity) end

---@param p0 string
---@param p1 number
function ShakeScriptGlobal(p0, p1) end

---@param value integer
---@param bitShift integer
---@return integer
function ShiftLeft(value, bitShift) end

---@param value integer
---@param bitShift integer
---@return integer
function ShiftRight(value, bitShift) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param damage integer
---@param pureAccuracy boolean
---@param weaponHash integer | string
---@param ownerPed integer
---@param isAudible boolean
---@param isInvisible boolean
---@param speed number
function ShootSingleBulletBetweenCoords(x1, y1, z1, x2, y2, z2, damage, pureAccuracy, weaponHash, ownerPed, isAudible, isInvisible, speed) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param damage integer
---@param p7 boolean
---@param weaponHash integer | string
---@param ownerPed integer
---@param isAudible boolean
---@param isInvisible boolean
---@param speed number
---@param entity integer
function ShootSingleBulletBetweenCoordsIgnoreEntity(x1, y1, z1, x2, y2, z2, damage, p7, weaponHash, ownerPed, isAudible, isInvisible, speed, entity) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param damage integer
---@param p7 boolean
---@param weaponHash integer | string
---@param ownerPed integer
---@param isAudible boolean
---@param isInvisible boolean
---@param speed number
---@param entity integer
---@param p14 boolean
---@param p15 boolean
---@param p16 boolean
---@param p17 boolean
function ShootSingleBulletBetweenCoordsIgnoreEntityNew(x1, y1, z1, x2, y2, z2, damage, p7, weaponHash, ownerPed, isAudible, isInvisible, speed, entity, p14, p15, p16, p17) end

---@return boolean
function ShouldUseMetricMeasurements() end

---@param toggle boolean
function ShowContactInstructionalButton(toggle) end

---@param blip integer
---@param toggle boolean
function ShowCrewIndicatorOnBlip(blip, toggle) end

---@param blip integer
---@param toggle boolean
function ShowFriendIndicatorOnBlip(blip, toggle) end

---@param blip integer
---@param toggle boolean
function ShowHasCompletedIndicatorOnBlip(blip, toggle) end

---@param blip integer
---@param toggle boolean
function ShowHeadingIndicatorOnBlip(blip, toggle) end

---@param blip integer
---@param toggle boolean
function ShowHeightOnBlip(blip, toggle) end

---@param id integer
function ShowHudComponentThisFrame(id) end

---@param blip integer
---@param number integer
function ShowNumberOnBlip(blip, number) end

---@param blip integer
---@param toggle boolean
function ShowOutlineIndicatorOnBlip(blip, toggle) end

---@param toggle boolean
function ShowPurchaseInstructionalButton(toggle) end

---@param id integer
function ShowScriptedHudComponentThisFrame(id) end


function ShowSigninUi() end

---@param p0 boolean
function ShowStartMissionInstructionalButton(p0) end

---@param blip integer
---@param toggle boolean
function ShowTickOnBlip(blip, toggle) end


function ShutdownAndLaunchSinglePlayerGame() end

---@return boolean
function ShutdownAndLoadMostRecentSave() end


function ShutdownCreatorBudget() end


function ShutdownLoadingScreen() end


function ShutdownLoadingScreenNui() end

---@param player integer
---@param amount number
---@param gaitType integer
---@param rotationSpeed number
---@param p4 boolean
---@param p5 boolean
function SimulatePlayerInputGait(player, amount, gaitType, rotationSpeed, p4, p5) end

---@param value number
---@return number
function Sin(value) end


function SkipRadioForward() end

---@param vehicle integer
---@param time number
function SkipTimeInPlaybackRecordedVehicle(vehicle, time) end

---@param vehicle integer
function SkipToEndAndStopPlaybackRecordedVehicle(vehicle) end


function SkipToNextScriptedConversationLine() end

---@param t number
---@param x number
---@param y number
---@param z number
---@param w number
---@param x1 number
---@param y1 number
---@param z1 number
---@param w1 number
---@return number, number, number, number
function SlerpNearQuaternion(t, x, y, z, w, x1, y1, z1, w1) end

---@param object integer
---@param toX number
---@param toY number
---@param toZ number
---@param speedX number
---@param speedY number
---@param speedZ number
---@param collision boolean
---@return boolean
function SlideObject(object, toX, toY, toZ, speedX, speedY, speedZ, collision) end

---@param vehicle integer
---@param windowIndex integer
function SmashVehicleWindow(vehicle, windowIndex) end

---@param vehicle integer
function SoundVehicleHornThisFrame(vehicle) end


function SpawnpointsCancelSearch() end

---@return integer
function SpawnpointsGetNumSearchResults() end

---@param randomInt integer
---@return number, number, number
function SpawnpointsGetSearchResult(randomInt) end

---@param p0 any
---@return any
function SpawnpointsGetSearchResultFlags(p0) end

---@return boolean
function SpawnpointsIsSearchActive() end

---@return boolean
function SpawnpointsIsSearchComplete() end

---@return boolean
function SpawnpointsIsSearchFailed() end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param interiorFlags integer
---@param scale number
---@param duration integer
function SpawnpointsStartSearch(p0, p1, p2, p3, p4, interiorFlags, scale, duration) end

---@param x number
---@param y number
---@param z number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param interiorFlags integer
---@param scale number
---@param duration integer
function SpawnpointsStartSearchInAngledArea(x, y, z, p3, p4, p5, p6, interiorFlags, scale, duration) end

---@param player any
function SpecialAbilityActivate(player) end

---@param player integer
---@param p1 integer
---@param p2 boolean
function SpecialAbilityChargeAbsolute(player, p1, p2) end

---@param player integer
---@param p2 integer
function SpecialAbilityChargeContinuous(player, p2) end

---@param player integer
---@param p1 boolean
---@param p2 boolean
function SpecialAbilityChargeLarge(player, p1, p2) end

---@param player integer
---@param p1 boolean
---@param p2 boolean
function SpecialAbilityChargeMedium(player, p1, p2) end

---@param player integer
---@param normalizedValue number
---@param p2 boolean
function SpecialAbilityChargeNormalized(player, normalizedValue, p2) end

---@param player integer
function SpecialAbilityChargeOnMissionFailed(player) end

---@param player integer
---@param p1 boolean
---@param p2 boolean
function SpecialAbilityChargeSmall(player, p1, p2) end

---@param player integer
function SpecialAbilityDeactivate(player) end

---@param player integer
function SpecialAbilityDeactivateFast(player) end

---@param p0 any
function SpecialAbilityDeplete(p0) end

---@param player integer
---@param p1 boolean
function SpecialAbilityDepleteMeter(player, p1) end

---@param player integer
---@param p1 boolean
function SpecialAbilityFillMeter(player, p1) end

---@param playerModel integer | string
function SpecialAbilityLock(playerModel) end

---@param player integer
function SpecialAbilityReset(player) end

---@param playerModel integer | string
function SpecialAbilityUnlock(playerModel) end

---@param ped integer
---@param noCollisionUntilClear boolean
function SpecialFunctionDoNotUse(ped, noCollisionUntilClear) end

---@param value number
---@return number
function Sqrt(value) end

---@param vehicle integer
---@param entity integer
---@param p2 number
function StabiliseEntityAttachedToHeli(vehicle, entity, p2) end

---@param alarmName string
---@param skipStartup boolean
function StartAlarm(alarmName, skipStartup) end

---@param scene string
---@return boolean
function StartAudioScene(scene) end


function StartBenchmarkRecording() end

---@param flags integer
function StartCutscene(flags) end

---@param x number
---@param y number
---@param z number
---@param flags integer
function StartCutsceneAtCoords(x, y, z, flags) end

---@param entity integer
---@return integer
function StartEntityFire(entity) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param flags integer
---@param entity integer
---@param p8 integer
---@return integer
function StartExpensiveSynchronousShapeTestLosProbe(x1, y1, z1, x2, y2, z2, flags, entity, p8) end

---@param resourceName string
---@param prefix string
---@return integer
function StartFindExternalKvp(resourceName, prefix) end

---@param duration integer
function StartFiringAmnesty(duration) end

---@param hudColor integer
---@param displayOnFoot boolean
---@param followPlayer boolean
function StartGpsCustomRoute(hudColor, displayOnFoot, followPlayer) end

---@param hudColor integer
---@param routeFromPlayer boolean
---@param displayOnFoot boolean
function StartGpsMultiRoute(hudColor, routeFromPlayer, displayOnFoot) end

---@param effectName string
---@param entity integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param xRot number
---@param yRot number
---@param zRot number
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return integer
function StartNetworkedParticleFxLoopedOnEntity(effectName, entity, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param entity integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param xRot number
---@param yRot number
---@param zRot number
---@param boneIndex integer
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return integer
function StartNetworkedParticleFxLoopedOnEntityBone(effectName, entity, xOffset, yOffset, zOffset, xRot, yRot, zRot, boneIndex, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param xPos number
---@param yPos number
---@param zPos number
---@param xRot number
---@param yRot number
---@param zRot number
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return boolean
function StartNetworkedParticleFxNonLoopedAtCoord(effectName, xPos, yPos, zPos, xRot, yRot, zRot, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param scale number
---@param axisX boolean
---@param axisY boolean
---@param axisZ boolean
---@return boolean
function StartNetworkedParticleFxNonLoopedOnEntity(effectName, entity, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, scale, axisX, axisY, axisZ) end

---@param effectName string
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param boneIndex integer
---@param scale number
---@param axisX boolean
---@param axisY boolean
---@param axisZ boolean
---@return boolean
function StartNetworkedParticleFxNonLoopedOnEntityBone(effectName, entity, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, boneIndex, scale, axisX, axisY, axisZ) end

---@param effectName string
---@param ped integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param boneIndex integer
---@param scale number
---@param axisX boolean
---@param axisY boolean
---@param axisZ boolean
---@return boolean
function StartNetworkedParticleFxNonLoopedOnPedBone(effectName, ped, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, boneIndex, scale, axisX, axisY, axisZ) end

---@param scriptName string
---@param stackSize integer
---@return integer
function StartNewScript(scriptName, stackSize) end

---@param scriptName string
---@param argCount integer
---@param stackSize integer
---@return integer, any
function StartNewScriptWithArgs(scriptName, argCount, stackSize) end

---@param scriptHash integer | string
---@param stackSize integer
---@return integer
function StartNewScriptWithNameHash(scriptHash, stackSize) end

---@param scriptHash integer | string
---@param argCount integer
---@param stackSize integer
---@return integer, any
function StartNewScriptWithNameHashAndArgs(scriptHash, argCount, stackSize) end

---@param effectName string
---@param x number
---@param y number
---@param z number
---@param xRot number
---@param yRot number
---@param zRot number
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@param p11 boolean
---@return integer
function StartParticleFxLoopedAtCoord(effectName, x, y, z, xRot, yRot, zRot, scale, xAxis, yAxis, zAxis, p11) end

---@param effectName string
---@param entity integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param xRot number
---@param yRot number
---@param zRot number
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return integer
function StartParticleFxLoopedOnEntity(effectName, entity, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param entity integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param xRot number
---@param yRot number
---@param zRot number
---@param boneIndex integer
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return integer
function StartParticleFxLoopedOnEntityBone(effectName, entity, xOffset, yOffset, zOffset, xRot, yRot, zRot, boneIndex, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param ped integer
---@param xOffset number
---@param yOffset number
---@param zOffset number
---@param xRot number
---@param yRot number
---@param zRot number
---@param boneIndex integer
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return integer
function StartParticleFxLoopedOnPedBone(effectName, ped, xOffset, yOffset, zOffset, xRot, yRot, zRot, boneIndex, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param xPos number
---@param yPos number
---@param zPos number
---@param xRot number
---@param yRot number
---@param zRot number
---@param scale number
---@param xAxis boolean
---@param yAxis boolean
---@param zAxis boolean
---@return integer
function StartParticleFxNonLoopedAtCoord(effectName, xPos, yPos, zPos, xRot, yRot, zRot, scale, xAxis, yAxis, zAxis) end

---@param effectName string
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param scale number
---@param axisX boolean
---@param axisY boolean
---@param axisZ boolean
---@return boolean
function StartParticleFxNonLoopedOnEntity(effectName, entity, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, scale, axisX, axisY, axisZ) end

---@param effectName string
---@param ped integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param boneIndex integer
---@param scale number
---@param axisX boolean
---@param axisY boolean
---@param axisZ boolean
---@return boolean
function StartParticleFxNonLoopedOnPedBone(effectName, ped, offsetX, offsetY, offsetZ, rotX, rotY, rotZ, boneIndex, scale, axisX, axisY, axisZ) end

---@param p0 number
function StartPetrolTrailDecals(p0) end

---@param vehicle integer
---@param recording integer
---@param script string
---@param p3 boolean
function StartPlaybackRecordedVehicle(vehicle, recording, script, p3) end

---@param vehicle integer
---@param recording integer
---@param script string
---@param speed number
---@param drivingStyle integer
function StartPlaybackRecordedVehicleUsingAi(vehicle, recording, script, speed, drivingStyle) end

---@param vehicle integer
---@param recording integer
---@param script string
---@param flags integer
---@param time integer
---@param drivingStyle integer
function StartPlaybackRecordedVehicleWithFlags(vehicle, recording, script, flags, time, drivingStyle) end

---@param from integer
---@param to integer
---@param flags integer
---@param switchType integer
function StartPlayerSwitch(from, to, flags, switchType) end

---@param player integer
---@param x number
---@param y number
---@param z number
---@param heading number
---@param teleportWithVehicle boolean
---@param findCollisionLand boolean
---@param p7 boolean
function StartPlayerTeleport(player, x, y, z, heading, teleportWithVehicle, findCollisionLand, p7) end


function StartPreloadedConversation() end

---@param mode integer
function StartRecording(mode) end

---@param ropeId integer
function StartRopeUnwindingFront(ropeId) end

---@param ropeId integer
function StartRopeWinding(ropeId) end

---@param size integer
---@param arrayName string
---@return any
function StartSaveArrayWithSize(size, arrayName) end

---@param p1 any
---@param p2 boolean
---@return any
function StartSaveData(p1, p2) end

---@param size integer
---@param structName string
---@return any
function StartSaveStructWithSize(size, structName) end

---@param displaySubtitles boolean
---@param addToBriefScreen boolean
---@param cloneConversation boolean
---@param interruptible boolean
function StartScriptConversation(displaySubtitles, addToBriefScreen, cloneConversation, interruptible) end

---@param X number
---@param Y number
---@param Z number
---@param maxChildren integer
---@param isGasFire boolean
---@return integer
function StartScriptFire(X, Y, Z, maxChildren, isGasFire) end

---@param displaySubtitles boolean
---@param addToBriefScreen boolean
function StartScriptPhoneConversation(displaySubtitles, addToBriefScreen) end

---@param entity integer
---@param flags1 integer
---@param flags2 integer
---@return integer
function StartShapeTestBound(entity, flags1, flags2) end

---@param entity integer
---@param flags1 integer
---@param flags2 integer
---@return integer
function StartShapeTestBoundingBox(entity, flags1, flags2) end

---@param x number
---@param y number
---@param z number
---@param x1 number
---@param y1 number
---@param z1 number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param p9 integer
---@param flags integer
---@param entity integer
---@param p12 integer
---@return integer
function StartShapeTestBox(x, y, z, x1, y1, z1, rotX, rotY, rotZ, p9, flags, entity, p12) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param radius number
---@param flags integer
---@param entity integer
---@param p9 integer
---@return integer
function StartShapeTestCapsule(x1, y1, z1, x2, y2, z2, radius, flags, entity, p9) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param traceFlags integer
---@param entity integer
---@param optionFlags integer
---@return integer
function StartShapeTestLosProbe(x1, y1, z1, x2, y2, z2, traceFlags, entity, optionFlags) end

---@param pVec1 vector3
---@param pVec2 vector3
---@param flag integer
---@param entity integer
---@param flag2 integer
---@return integer
function StartShapeTestSurroundingCoords(pVec1, pVec2, flag, entity, flag2) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param radius number
---@param flags integer
---@param entity integer
---@param p9 integer
---@return integer
function StartShapeTestSweptSphere(x1, y1, z1, x2, y2, z2, radius, flags, entity, p9) end

---@param vehicle integer
function StartVehicleAlarm(vehicle) end

---@param vehicle integer
---@param duration integer
---@param mode integer | string
---@param forever boolean
function StartVehicleHorn(vehicle, duration, mode, forever) end

---@param statSlot integer
---@return any
function StatClearSlotForReload(statSlot) end

---@param p0 any
---@return any
function StatDeleteSlot(p0) end

---@param statHash integer | string
---@param p2 any
---@return boolean, boolean
function StatGetBool(statHash, p2) end

---@param statName integer | string
---@param mask integer
---@param p2 integer
---@return boolean
function StatGetBoolMasked(statName, mask, p2) end

---@return integer
function StatGetCancelSaveMigrationStatus() end

---@param statHash integer | string
---@param p2 any
---@param p3 any
---@return boolean, any
function StatGetDate(statHash, p2, p3) end

---@param statHash integer | string
---@param p2 any
---@return boolean, number
function StatGetFloat(statHash, p2) end

---@param statHash integer | string
---@param p2 integer
---@return boolean, integer
function StatGetInt(statHash, p2) end

---@param statName integer | string
---@return string
function StatGetLicensePlate(statName) end

---@param p0 any
---@param p2 any
---@param p3 any
---@param p4 any
---@return boolean, any
function StatGetMaskedInt(p0, p2, p3, p4) end

---@param statName integer | string
---@return integer
function StatGetNumberOfDays(statName) end

---@param statName integer | string
---@return integer
function StatGetNumberOfHours(statName) end

---@param statName integer | string
---@return integer
function StatGetNumberOfMinutes(statName) end

---@param statName integer | string
---@return integer
function StatGetNumberOfSeconds(statName) end

---@param p0 integer
---@return integer
function StatGetPackedBoolMask(p0) end

---@param p0 integer
---@return integer
function StatGetPackedIntMask(p0) end

---@param p0 any
---@param p4 any
---@return boolean, any, any, any
function StatGetPos(p0, p4) end

---@return integer, integer
function StatGetSaveMigrationConsumeContentUnlockStatus() end

---@return integer, any
function StatGetSaveMigrationStatus() end

---@param statHash integer | string
---@param p1 integer
---@return string
function StatGetString(statHash, p1) end

---@param p0 any
---@return string
function StatGetUserId(p0) end

---@param statName integer | string
---@param value number
function StatIncrement(statName, value) end

---@param p0 integer
---@return boolean
function StatLoad(p0) end

---@param p0 any
---@return boolean
function StatLoadPending(p0) end

---@param platformName string
---@return boolean
function StatMigrateSave(platformName) end

---@param p0 integer
---@param p1 boolean
---@param p2 integer
---@return boolean
function StatSave(p0, p1, p2) end

---@return boolean
function StatSaveMigrationCancel() end

---@param contentId integer | string
---@param srcPlatform string
---@param srcGamerHandle string
---@return boolean
function StatSaveMigrationConsumeContentUnlock(contentId, srcPlatform, srcGamerHandle) end

---@return boolean
function StatSaveMigrationStatusStart() end

---@return boolean
function StatSavePending() end

---@return boolean
function StatSavePendingOrRequested() end

---@param toggle boolean
function StatSetBlockSaves(toggle) end

---@param statName integer | string
---@param value boolean
---@param save boolean
---@return boolean
function StatSetBool(statName, value, save) end

---@param statName integer | string
---@param value boolean
---@param mask integer
---@param save boolean
---@return boolean
function StatSetBoolMasked(statName, value, mask, save) end


function StatSetCheatIsActive() end

---@param statName integer | string
---@param p1 boolean
---@return boolean
function StatSetCurrentPosixTime(statName, p1) end

---@param statName integer | string
---@param numFields integer
---@param save boolean
---@return boolean, any
function StatSetDate(statName, numFields, save) end

---@param statName integer | string
---@param value number
---@param save boolean
---@return boolean
function StatSetFloat(statName, value, save) end

---@param statName integer | string
---@param value string
---@param save boolean
---@return boolean
function StatSetGxtLabel(statName, value, save) end

---@param statName integer | string
---@param value integer
---@param save boolean
---@return boolean
function StatSetInt(statName, value, save) end

---@param statName integer | string
---@param str string
---@return boolean
function StatSetLicensePlate(statName, str) end

---@param statName integer | string
---@param p1 any
---@param p2 any
---@param p3 integer
---@param save boolean
---@return boolean
function StatSetMaskedInt(statName, p1, p2, p3, save) end

---@param statName integer | string
---@param x number
---@param y number
---@param z number
---@param save boolean
---@return boolean
function StatSetPos(statName, x, y, z, save) end

---@param profileSetting integer
---@param value integer
function StatSetProfileSettingValue(profileSetting, value) end

---@param statName integer | string
---@param value string
---@param save boolean
---@return boolean
function StatSetString(statName, value, save) end

---@param statName integer | string
---@param value string
---@param save boolean
---@return boolean
function StatSetUserId(statName, value, save) end

---@param p0 any
---@return boolean
function StatSlotIsLoaded(p0) end

---@param alarmName string
---@param instantStop boolean
function StopAlarm(alarmName, instantStop) end

---@param instantStop boolean
function StopAllAlarms(instantStop) end


function StopAllGarageActivity() end

---@param ped integer
---@param p1 integer
---@param p2 boolean
function StopAnimPlayback(ped, p1, p2) end

---@param ped integer
---@param animDictionary string
---@param animationName string
---@param animExitSpeed number
function StopAnimTask(ped, animDictionary, animationName, animExitSpeed) end


function StopAnyPedModelBeingSuppressed() end

---@param sceneName string
function StopAudioScene(sceneName) end


function StopAudioScenes() end


function StopBenchmarkRecording() end

---@param binkMovie integer
function StopBinkMovie(binkMovie) end

---@param vehicle integer
function StopBringVehicleToHalt(vehicle) end

---@param cam integer
function StopCamPointing(cam) end

---@param cam integer
---@param p1 boolean
function StopCamShaking(cam, p1) end

---@param p0 boolean
function StopCinematicCamShaking(p0) end

---@param p0 integer | string
function StopCinematicShot(p0) end

---@param ped integer
function StopCurrentPlayingAmbientSpeech(ped) end

---@param ped integer
function StopCurrentPlayingSpeech(ped) end

---@param p0 boolean
function StopCutscene(p0) end


function StopCutsceneAudio() end


function StopCutsceneCamShaking() end


function StopCutsceneImmediately() end

---@param entity integer
---@param animation string
---@param animGroup string
---@param p3 number
---@return any
function StopEntityAnim(entity, animation, animGroup, p3) end

---@param entity integer
function StopEntityFire(entity) end

---@param x number
---@param y number
---@param z number
---@param radius number
function StopFireInRange(x, y, z, radius) end

---@param bStopImmediately boolean
function StopGameplayCamShaking(bStopImmediately) end

---@param bStopImmediately boolean
function StopGameplayHint(bStopImmediately) end

---@param padIndex integer
function StopPadShake(padIndex) end

---@param ptfxHandle integer
---@param p1 boolean
function StopParticleFxLooped(ptfxHandle, p1) end

---@param ped integer
function StopPedRingtone(ped) end

---@param ped integer
---@param shouldDisable boolean
function StopPedSpeaking(ped, shouldDisable) end

---@param ped integer
---@param shouldDisable boolean
function StopPedSpeakingSynced(ped, shouldDisable) end

---@param ped integer
function StopPedWeaponFiringWhenDropped(ped) end

---@param vehicle integer
function StopPlaybackRecordedVehicle(vehicle) end


function StopPlayerSwitch() end


function StopPlayerTeleport() end


function StopRecordingAndDiscardClip() end


function StopRecordingAndSaveClip() end


function StopRecordingThisFrame() end

---@param bShouldApplyAcrossAllThreads boolean
---@param distanceToBlend number
---@param blendType integer
function StopRenderingScriptCamsUsingCatchUp(bShouldApplyAcrossAllThreads, distanceToBlend, blendType) end

---@param ropeId integer
function StopRopeUnwindingFront(ropeId) end

---@param ropeId integer
function StopRopeWinding(ropeId) end


function StopSaveArray() end


function StopSaveData() end


function StopSaveStruct() end

---@param bStopImmediately boolean
function StopScriptGlobalShaking(bStopImmediately) end

---@param finishCurrentLine boolean
---@return integer
function StopScriptedConversation(finishCurrentLine) end


function StopSmokeGrenadeExplosionSounds() end

---@param soundId integer
function StopSound(soundId) end


function StopStream() end

---@param p0 any
---@return boolean
function StopSynchronizedAudioEvent(p0) end

---@param entity integer
---@param p1 number
---@param p2 boolean
---@return boolean
function StopSynchronizedEntityAnim(entity, p1, p2) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 any
---@param p5 number
---@return boolean
function StopSynchronizedMapEntityAnim(p0, p1, p2, p3, p4, p5) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 any
---@param p8 any
---@return any
function StreamvolCreateFrustum(p0, p1, p2, p3, p4, p5, p6, p7, p8) end

---@param p0 number
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 any
---@return any
function StreamvolCreateLine(p0, p1, p2, p3, p4, p5, p6) end

---@param x number
---@param y number
---@param z number
---@param rad number
---@param p4 any
---@param p5 any
---@return any
function StreamvolCreateSphere(x, y, z, rad, p4, p5) end

---@param unused any
function StreamvolDelete(unused) end

---@param unused any
---@return boolean
function StreamvolHasLoaded(unused) end

---@param unused any
---@return boolean
function StreamvolIsValid(unused) end

---@param string string
---@return boolean, integer
function StringToInt(string) end


function SuppressAgitationEventsNextFrame() end

---@param player integer
---@param crimeType integer
function SuppressCrimeThisFrame(player, crimeType) end


function SuppressFrontendRenderingThisFrame() end

---@param eventType integer
function SuppressShockingEventTypeNextFrame(eventType) end


function SuppressShockingEventsNextFrame() end

---@param eventType integer
---@param enable boolean
function SupressRandomEventThisFrame(eventType, enable) end

---@param name string
---@return boolean
function SwitchToInputMappingScheme(name) end

---@param name string
---@return boolean
function SwitchToInputMappingScheme_2(name) end

---@param ped integer
---@param flags integer
---@param switchType integer
function SwitchToMultiFirstpart(ped, flags, switchType) end

---@param ped integer
function SwitchToMultiSecondpart(ped) end

---@param trackId integer
---@param state boolean
function SwitchTrainTrack(trackId, state) end


function TakeControlOfFrontend() end

---@param scene integer
function TakeOwnershipOfSynchronizedScene(scene) end

---@param p0 number
---@return number
function Tan(p0) end

---@param ped integer
---@param heading number
---@param timeout integer
function TaskAchieveHeading(ped, heading, timeout) end

---@param ped integer
---@param ped2 integer
function TaskAgitatedAction(ped, ped2) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param time integer
---@param bInstantBlendToAim boolean
---@param bPlayAimIntro boolean
function TaskAimGunAtCoord(ped, x, y, z, time, bInstantBlendToAim, bPlayAimIntro) end

---@param ped integer
---@param entity integer
---@param duration integer
---@param bInstantBlendToAim boolean
function TaskAimGunAtEntity(ped, entity, duration, bInstantBlendToAim) end

---@param ped integer
---@param scriptTask integer | string
---@param bDisableBlockingClip boolean
---@param bInstantBlendToAim boolean
function TaskAimGunScripted(ped, scriptTask, bDisableBlockingClip, bInstantBlendToAim) end

---@param ped integer
---@param targetPed integer
---@param x number
---@param y number
---@param z number
---@param iGunTaskType integer | string
---@param bDisableBlockingClip boolean
---@param bForceAim boolean
function TaskAimGunScriptedWithTarget(ped, targetPed, x, y, z, iGunTaskType, bDisableBlockingClip, bForceAim) end

---@param ped integer
---@param target integer
function TaskArrestPed(ped, target) end

---@param ped integer
---@param boat integer
---@param vehicleTarget integer
---@param pedTarget integer
---@param x number
---@param y number
---@param z number
---@param missionType integer
---@param speed number
---@param drivingStyle integer
---@param radius number
---@param missionFlags integer
function TaskBoatMission(ped, boat, vehicleTarget, pedTarget, x, y, z, missionType, speed, drivingStyle, radius, missionFlags) end

---@param ped integer
---@param target integer
---@param p2 any
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
function TaskChatToPed(ped, target, p2, p3, p4, p5, p6, p7) end

---@param p0 any
function TaskClearDefensiveArea(p0) end

---@param ped integer
function TaskClearLookAt(ped) end

---@param ped integer
---@param unused boolean
function TaskClimb(ped, unused) end

---@param ped integer
---@param p1 integer
function TaskClimbLadder(ped, p1) end

---@param ped integer
---@param radius number
---@param p2 integer
function TaskCombatHatedTargetsAroundPed(ped, radius, p2) end

---@param p0 any
---@param p1 number
---@param p2 any
---@param p3 any
function TaskCombatHatedTargetsAroundPedTimed(p0, p1, p2, p3) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@param p5 any
function TaskCombatHatedTargetsInArea(ped, x, y, z, radius, p5) end

---@param ped integer
---@param targetPed integer
---@param p2 integer
---@param p3 integer
function TaskCombatPed(ped, targetPed, p2, p3) end

---@param p0 any
---@param ped integer
---@param p2 integer
---@param p3 any
function TaskCombatPedTimed(p0, ped, p2, p3) end

---@param ped integer
---@param duration integer
function TaskCower(ped, duration) end

---@param driverPed integer
---@param targetPed integer
---@param targetVehicle integer
---@param targetX number
---@param targetY number
---@param targetZ number
---@param distanceToShoot number
---@param pedAccuracy integer
---@param p8 boolean
---@param firingPattern integer | string
function TaskDriveBy(driverPed, targetPed, targetVehicle, targetX, targetY, targetZ, distanceToShoot, pedAccuracy, p8, firingPattern) end

---@param ped integer
---@param vehicle integer
---@param timeout integer
---@param seatIndex integer
---@param speed number
---@param flag integer
---@param p6 any
function TaskEnterVehicle(ped, vehicle, timeout, seatIndex, speed, flag, p6) end

---@param vehicle integer
function TaskEveryoneLeaveVehicle(vehicle) end

---@param p0 any
---@param p1 any
---@param p2 number
---@param p3 number
---@param p4 number
function TaskExitCover(p0, p1, p2, p3, p4) end

---@param x number
---@param y number
---@param z number
function TaskExtendRoute(x, y, z) end


function TaskFlushRoute() end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param moveBlendRatio number
---@param time integer
---@param radius number
---@param flags integer
---@param finalHeading number
function TaskFollowNavMeshToCoord(ped, x, y, z, moveBlendRatio, time, radius, flags, finalHeading) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param timeout integer
---@param unkFloat number
---@param unkInt integer
---@param unkX number
---@param unkY number
---@param unkZ number
---@param unk_40000f number
function TaskFollowNavMeshToCoordAdvanced(ped, x, y, z, speed, timeout, unkFloat, unkInt, unkX, unkY, unkZ, unk_40000f) end

---@param ped integer
---@param speed number
---@param routeMode integer
function TaskFollowPointRoute(ped, speed, routeMode) end

---@param ped integer
---@param entity integer
---@param offsetX number
---@param offsetY number
---@param offsetZ number
---@param movementSpeed number
---@param timeout integer
---@param stoppingRange number
---@param persistFollowing boolean
function TaskFollowToOffsetOfEntity(ped, entity, offsetX, offsetY, offsetZ, movementSpeed, timeout, stoppingRange, persistFollowing) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function TaskFollowWaypointRecording(p0, p1, p2, p3, p4) end

---@param ped integer
---@param state integer | string
---@param p2 boolean
function TaskForceMotionState(ped, state, p2) end

---@param ped integer
---@param boat integer
function TaskGetOffBoat(ped, boat) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param timeout integer
---@param targetHeading number
---@param distanceToSlide number
function TaskGoStraightToCoord(ped, x, y, z, speed, timeout, targetHeading, distanceToSlide) end

---@param entity1 integer
---@param entity2 integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 any
function TaskGoStraightToCoordRelativeToEntity(entity1, entity2, p2, p3, p4, p5, p6) end

---@param pedHandle integer
---@param goToLocationX number
---@param goToLocationY number
---@param goToLocationZ number
---@param focusLocationX number
---@param focusLocationY number
---@param focusLocationZ number
---@param speed number
---@param shootAtEnemies boolean
---@param distanceToStopAt number
---@param noRoadsDistance number
---@param unkTrue boolean
---@param unkFlag integer
---@param aimingFlag integer
---@param firingPattern integer | string
function TaskGoToCoordAndAimAtHatedEntitiesNearCoord(pedHandle, goToLocationX, goToLocationY, goToLocationZ, focusLocationX, focusLocationY, focusLocationZ, speed, shootAtEnemies, distanceToStopAt, noRoadsDistance, unkTrue, unkFlag, aimingFlag, firingPattern) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param fMoveBlendRatio number
---@param vehicle integer
---@param bUseLongRangeVehiclePathing boolean
---@param drivingFlags integer
---@param fMaxRangeToShootTargets number
function TaskGoToCoordAnyMeans(ped, x, y, z, fMoveBlendRatio, vehicle, bUseLongRangeVehiclePathing, drivingFlags, fMaxRangeToShootTargets) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param p5 any
---@param p6 boolean
---@param walkingStyle integer
---@param p8 number
---@param p9 any
---@param p10 any
---@param p11 any
function TaskGoToCoordAnyMeansExtraParams(ped, x, y, z, speed, p5, p6, walkingStyle, p8, p9, p10, p11) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param p5 any
---@param p6 boolean
---@param walkingStyle integer
---@param p8 number
---@param p9 any
---@param p10 any
---@param p11 any
---@param p12 any
function TaskGoToCoordAnyMeansExtraParamsWithCruiseSpeed(ped, x, y, z, speed, p5, p6, walkingStyle, p8, p9, p10, p11, p12) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param aimAtX number
---@param aimAtY number
---@param aimAtZ number
---@param moveSpeed number
---@param shoot boolean
---@param p9 number
---@param p10 number
---@param p11 boolean
---@param flags any
---@param p13 boolean
---@param firingPattern integer | string
function TaskGoToCoordWhileAimingAtCoord(ped, x, y, z, aimAtX, aimAtY, aimAtZ, moveSpeed, shoot, p9, p10, p11, flags, p13, firingPattern) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param entityToAimAt integer
---@param moveSpeed number
---@param shoot boolean
---@param targetRadius number
---@param slowDistance number
---@param useNavMesh boolean
---@param navFlags integer
---@param instantBlendAtAim boolean
---@param firingPattern integer | string
---@param time integer
function TaskGoToCoordWhileAimingAtEntity(ped, x, y, z, entityToAimAt, moveSpeed, shoot, targetRadius, slowDistance, useNavMesh, navFlags, instantBlendAtAim, firingPattern, time) end

---@param entity integer
---@param target integer
---@param duration integer
---@param distance number
---@param speed number
---@param p5 number
---@param p6 integer
function TaskGoToEntity(entity, target, duration, distance, speed, p5, p6) end

---@param p0 any
---@param p1 any
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 boolean
---@param p7 number
---@param p8 number
---@param p9 boolean
---@param p10 boolean
---@param p11 any
function TaskGoToEntityWhileAimingAtCoord(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) end

---@param ped integer
---@param entityToWalkTo integer
---@param entityToAimAt integer
---@param speed number
---@param shootatEntity boolean
---@param p5 number
---@param p6 number
---@param p7 boolean
---@param p8 boolean
---@param firingPattern integer | string
function TaskGoToEntityWhileAimingAtEntity(ped, entityToWalkTo, entityToAimAt, speed, shootatEntity, p5, p6, p7, p8, firingPattern) end

---@param ped integer
---@param target integer
---@param distanceToStopAt number
---@param StartAimingDist number
function TaskGotoEntityAiming(ped, target, distanceToStopAt, StartAimingDist) end

---@param ped integer
---@param entity integer
---@param duration integer
---@param seekRadius number
---@param seekAngleDeg number
---@param moveBlendRatio number
---@param gotoEntityOffsetFlags integer
function TaskGotoEntityOffset(ped, entity, duration, seekRadius, seekAngleDeg, moveBlendRatio, gotoEntityOffsetFlags) end

---@param ped integer
---@param entity integer
---@param duration integer
---@param targetRadius number
---@param offsetX number
---@param offsetY number
---@param moveBlendRatio number
---@param gotoEntityOffsetFlags integer
function TaskGotoEntityOffsetXy(ped, entity, duration, targetRadius, offsetX, offsetY, moveBlendRatio, gotoEntityOffsetFlags) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 any
function TaskGuardAssignedDefensiveArea(p0, p1, p2, p3, p4, p5, p6) end

---@param p0 integer
---@param p1 number
---@param p2 number
---@param p3 boolean
function TaskGuardCurrentPosition(p0, p1, p2, p3) end

---@param p0 integer
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 any
---@param p7 number
---@param p8 number
---@param p9 number
---@param p10 number
function TaskGuardSphereDefensiveArea(p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) end

---@param ped integer
---@param duration integer
---@param facingPed integer
---@param p3 integer
---@param p4 boolean
function TaskHandsUp(ped, duration, facingPed, p3, p4) end

---@param pilot integer
---@param entityToFollow integer
---@param x number
---@param y number
---@param z number
function TaskHeliChase(pilot, entityToFollow, x, y, z) end

---@param pilot integer
---@param heli1 integer
---@param heli2 integer
---@param p3 number
---@param p4 number
---@param p5 number
function TaskHeliEscortHeli(pilot, heli1, heli2, p3, p4, p5) end

---@param ped integer
---@param heli integer
---@param vehicleTarget integer
---@param pedTarget integer
---@param x number
---@param y number
---@param z number
---@param missionType integer
---@param speed number
---@param radius number
---@param heading number
---@param height number
---@param minHeight number
---@param slowDist number
---@param missionFlags integer
function TaskHeliMission(ped, heli, vehicleTarget, pedTarget, x, y, z, missionType, speed, radius, heading, height, minHeight, slowDist, missionFlags) end

---@param ped integer
---@param unused boolean
function TaskJump(ped, unused) end

---@param ped integer
---@param p1 integer
---@param flags integer
function TaskLeaveAnyVehicle(ped, p1, flags) end

---@param ped integer
---@param vehicle integer
---@param flags integer
function TaskLeaveVehicle(ped, vehicle, flags) end

---@param entity integer
---@param x number
---@param y number
---@param z number
---@param duration integer
---@param p5 any
---@param p6 any
function TaskLookAtCoord(entity, x, y, z, duration, p5, p6) end

---@param ped integer
---@param lookAt integer
---@param duration integer
---@param unknown1 integer
---@param unknown2 integer
function TaskLookAtEntity(ped, lookAt, duration, unknown1, unknown2) end

---@param ped integer
---@param p1 string
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 number
---@param p6 number
---@param p7 number
---@param p8 any
---@param p9 number
---@param p10 boolean
---@param animDict string
---@param flags integer
function TaskMoveNetworkAdvancedByName(ped, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, animDict, flags) end

---@param ped integer
---@param task string
---@param multiplier number
---@param p3 boolean
---@param animDict string
---@param flags integer
function TaskMoveNetworkByName(ped, task, multiplier, p3, animDict, flags) end

---@param ped integer
---@param p1 string
---@param p3 number
---@param p4 boolean
---@param animDict string
---@param flags integer
---@return any
function TaskMoveNetworkByNameWithInitParams(ped, p1, p3, p4, animDict, flags) end

---@param ped integer
---@param vehicle integer
---@param timeOut integer
---@param seat integer
---@param speed number
function TaskOpenVehicleDoor(ped, vehicle, timeOut, seat, speed) end

---@param ped integer
---@param p1 boolean
function TaskParachute(ped, p1) end

---@param ped integer
---@param x number
---@param y number
---@param z number
function TaskParachuteToTarget(ped, x, y, z) end

---@param ped integer
---@param p1 string
---@param p2 any
---@param p3 boolean
---@param p4 boolean
function TaskPatrol(ped, p1, p2, p3, p4) end

---@param ped integer
---@param ms integer
function TaskPause(ped, ms) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param heading number
---@param duration number
function TaskPedSlideToCoord(ped, x, y, z, heading, duration) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param heading number
---@param p5 number
---@param p6 number
function TaskPedSlideToCoordHdgRate(ped, x, y, z, heading, p5, p6) end

---@param ped integer
---@param taskSequenceId integer
function TaskPerformSequence(ped, taskSequenceId) end

---@param ped integer
---@param taskIndex integer
---@param progress1 integer
---@param progress2 integer
function TaskPerformSequenceFromProgress(ped, taskIndex, progress1, progress2) end

---@param ped integer
---@param taskSequenceId integer
function TaskPerformSequenceLocally(ped, taskSequenceId) end

---@param pilot integer
---@param entityToFollow integer
---@param x number
---@param y number
---@param z number
function TaskPlaneChase(pilot, entityToFollow, x, y, z) end

---@param ped integer
---@param vehicle integer
---@param p2 any
---@param p3 any
---@param p4 any
---@param p5 any
---@param p6 any
---@param p7 any
---@param p8 any
---@param p9 any
function TaskPlaneGotoPreciseVtol(ped, vehicle, p2, p3, p4, p5, p6, p7, p8, p9) end

---@param pilot integer
---@param plane integer
---@param runwayStartX number
---@param runwayStartY number
---@param runwayStartZ number
---@param runwayEndX number
---@param runwayEndY number
---@param runwayEndZ number
function TaskPlaneLand(pilot, plane, runwayStartX, runwayStartY, runwayStartZ, runwayEndX, runwayEndY, runwayEndZ) end

---@param ped integer
---@param vehicle integer
---@param targetVehicle integer
---@param targetPed integer
---@param fTargetCoordX number
---@param fTargetCoordY number
---@param fTargetCoordZ number
---@param iMissionIndex integer
---@param fCruiseSpeed number
---@param fTargetReachedDist number
---@param fOrientation number
---@param iFlightHeight integer
---@param iMinHeightAboveTerrain integer
---@param bPrecise boolean
function TaskPlaneMission(ped, vehicle, targetVehicle, targetPed, fTargetCoordX, fTargetCoordY, fTargetCoordZ, iMissionIndex, fCruiseSpeed, fTargetReachedDist, fOrientation, iFlightHeight, iMinHeightAboveTerrain, bPrecise) end

---@param pilot integer
---@param aircraft integer
---@param xPos number
---@param yPos number
---@param zPos number
---@param fCruiseSpeed number
---@param fTargetReachedDist number
function TaskPlaneTaxi(pilot, aircraft, xPos, yPos, zPos, fCruiseSpeed, fTargetReachedDist) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param heading number
function TaskPlantBomb(ped, x, y, z, heading) end

---@param ped integer
---@param animDictionary string
---@param animationName string
---@param blendInSpeed number
---@param blendOutSpeed number
---@param duration integer
---@param flag integer
---@param playbackRate number
---@param lockX boolean
---@param lockY boolean
---@param lockZ boolean
function TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ) end

---@param ped integer
---@param animDictionary string
---@param animationName string
---@param posX number
---@param posY number
---@param posZ number
---@param rotX number
---@param rotY number
---@param rotZ number
---@param blendInSpeed number
---@param blendOutSpeed number
---@param duration integer
---@param flag any
---@param animTime number
---@param p14 any
---@param p15 any
function TaskPlayAnimAdvanced(ped, animDictionary, animationName, posX, posY, posZ, rotX, rotY, rotZ, blendInSpeed, blendOutSpeed, duration, flag, animTime, p14, p15) end

---@param ped integer
---@param animDict string
---@param animation string
---@param boneMaskType string
---@param p4 number
---@param p5 number
---@param p6 boolean
---@param p7 boolean
function TaskPlayPhoneGestureAnimation(ped, animDict, animation, boneMaskType, p4, p5, p6, p7) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param timeout any
---@param p5 boolean
---@param p6 number
---@param p7 boolean
---@param p8 boolean
---@param p9 any
---@param p10 boolean
function TaskPutPedDirectlyIntoCover(ped, x, y, z, timeout, p5, p6, p7, p8, p9, p10) end

---@param ped integer
---@param meleeTarget integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 boolean
function TaskPutPedDirectlyIntoMelee(ped, meleeTarget, p2, p3, p4, p5) end

---@param ped integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param minZ number
---@param ropeId integer
---@param clipset string
---@param p10 any
function TaskRappelDownWall(ped, x1, y1, z1, x2, y2, z2, minZ, ropeId, clipset, p10) end

---@param ped integer
---@param unused number
function TaskRappelFromHeli(ped, unused) end

---@param ped integer
---@param fleeTarget integer
function TaskReactAndFleePed(ped, fleeTarget) end

---@param ped integer
---@param unused boolean
function TaskReloadWeapon(ped, unused) end

---@param ped integer
---@param p4 number
---@param p5 number
---@return any, any, any
function TaskScriptedAnimation(ped, p4, p5) end

---@param ped integer
---@param target integer
---@param duration integer
---@param p3 boolean
function TaskSeekCoverFromPed(ped, target, duration, p3) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param duration integer
---@param p5 boolean
function TaskSeekCoverFromPos(ped, x, y, z, duration, p5) end

---@param ped integer
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param p7 any
---@param p8 boolean
function TaskSeekCoverToCoords(ped, x1, y1, z1, x2, y2, z2, p7, p8) end

---@param p0 any
---@param p1 any
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 any
---@param p6 boolean
function TaskSeekCoverToCoverPoint(p0, p1, p2, p3, p4, p5, p6) end

---@param ped integer
---@param toggle boolean
function TaskSetBlockingOfNonTemporaryEvents(ped, toggle) end

---@param ped integer
---@param p1 integer | string
function TaskSetDecisionMaker(ped, p1) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
function TaskSetSphereDefensiveArea(p0, p1, p2, p3, p4) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param moveBlendRatio number
---@param radius number
function TaskSharkCircleCoord(ped, x, y, z, moveBlendRatio, radius) end

---@param ped integer
---@param eventHandle integer
function TaskShockingEventReact(ped, eventHandle) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param duration integer
---@param firingPattern integer | string
function TaskShootAtCoord(ped, x, y, z, duration, firingPattern) end

---@param entity integer
---@param target integer
---@param duration integer
---@param firingPattern integer | string
function TaskShootAtEntity(entity, target, duration, firingPattern) end

---@param ped integer
---@param vehicle integer
function TaskShuffleToNextVehicleSeat(ped, vehicle) end

---@param ped integer
function TaskSkyDive(ped) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param distance number
---@param time integer
---@param p6 boolean
---@param p7 boolean
function TaskSmartFleeCoord(ped, x, y, z, distance, time, p6, p7) end

---@param ped integer
---@param fleeTarget integer
---@param distance number
---@param fleeTime any
---@param p4 boolean
---@param p5 boolean
function TaskSmartFleePed(ped, fleeTarget, distance, fleeTime, p4, p5) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param heading number
---@param scenarioName string
function TaskStandGuard(ped, x, y, z, heading, scenarioName) end

---@param ped integer
---@param time integer
function TaskStandStill(ped, time) end

---@param ped integer
---@param scenarioName string
---@param x number
---@param y number
---@param z number
---@param heading number
---@param timeToLeave integer
---@param playIntro boolean
---@param warp boolean
function TaskStartScenarioAtPosition(ped, scenarioName, x, y, z, heading, timeToLeave, playIntro, warp) end

---@param ped integer
---@param scenarioName string
---@param timeToLeave integer
---@param playIntroClip boolean
function TaskStartScenarioInPlace(ped, scenarioName, timeToLeave, playIntroClip) end

---@param ped integer
function TaskStayInCover(ped) end

---@param killer integer
---@param target integer
---@param actionType integer | string
---@param p3 number
---@param p4 any
function TaskStealthKill(killer, target, actionType, p3, p4) end

---@param ped integer
function TaskStopPhoneGestureAnimation(ped) end

---@param p0 any
---@param submarine integer
---@param x number
---@param y number
---@param z number
---@param p5 any
function TaskSubmarineGotoAndStop(p0, submarine, x, y, z, p5) end

---@param ped integer
---@param p1 boolean
function TaskSwapWeapon(ped, p1) end

---@param ped integer
---@param anim string
---@param p2 string
---@param p3 string
---@param p4 string
---@param p5 integer
---@param vehicle integer
---@param p7 number
---@param p8 number
function TaskSweepAimEntity(ped, anim, p2, p3, p4, p5, vehicle, p7, p8) end

---@param p0 any
---@param p5 any
---@param p6 number
---@param p7 number
---@param p8 number
---@param p9 number
---@param p10 number
---@return any, any, any, any
function TaskSweepAimPosition(p0, p5, p6, p7, p8, p9, p10) end

---@param ped integer
---@param scene integer
---@param animDictionary string
---@param animationName string
---@param speed number
---@param speedMultiplier number
---@param duration integer
---@param flag integer
---@param playbackRate number
---@param p9 any
function TaskSynchronizedScene(ped, scene, animDictionary, animationName, speed, speedMultiplier, duration, flag, playbackRate, p9) end

---@param ped integer
---@param x number
---@param y number
---@param z number
function TaskThrowProjectile(ped, x, y, z) end

---@param p0 boolean
---@param p1 boolean
function TaskToggleDuck(p0, p1) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param duration integer
function TaskTurnPedToFaceCoord(ped, x, y, z, duration) end

---@param ped integer
---@param entity integer
---@param duration integer
function TaskTurnPedToFaceEntity(ped, entity, duration) end

---@param ped integer
---@param p1 integer
function TaskUseMobilePhone(ped, p1) end

---@param ped integer
---@param duration integer
function TaskUseMobilePhoneTimed(ped, duration) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 any
function TaskUseNearestScenarioChainToCoord(p0, p1, p2, p3, p4, p5) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 any
function TaskUseNearestScenarioChainToCoordWarp(p0, p1, p2, p3, p4, p5) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param distance number
---@param duration integer
function TaskUseNearestScenarioToCoord(ped, x, y, z, distance, duration) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@param p5 any
function TaskUseNearestScenarioToCoordWarp(ped, x, y, z, radius, p5) end

---@param ped integer
---@param x number
---@param y number
---@param z number
function TaskVehicleAimAtCoord(ped, x, y, z) end

---@param ped integer
---@param target integer
function TaskVehicleAimAtPed(ped, target) end

---@param driver integer
---@param targetEnt integer
function TaskVehicleChase(driver, targetEnt) end

---@param ped integer
---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param p6 any
---@param vehicleModel integer | string
---@param drivingMode integer
---@param stopRange number
---@param p10 number
function TaskVehicleDriveToCoord(ped, vehicle, x, y, z, speed, p6, vehicleModel, drivingMode, stopRange, p10) end

---@param ped integer
---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param drivingStyle integer
---@param stopRange number
function TaskVehicleDriveToCoordLongrange(ped, vehicle, x, y, z, speed, drivingStyle, stopRange) end

---@param ped integer
---@param vehicle integer
---@param speed number
---@param drivingStyle integer
function TaskVehicleDriveWander(ped, vehicle, speed, drivingStyle) end

---@param ped integer
---@param vehicle integer
---@param targetVehicle integer
---@param mode integer
---@param speed number
---@param drivingStyle integer
---@param minDistance number
---@param p7 integer
---@param noRoadsDistance number
function TaskVehicleEscort(ped, vehicle, targetVehicle, mode, speed, drivingStyle, minDistance, p7, noRoadsDistance) end

---@param driver integer
---@param vehicle integer
---@param targetEntity integer
---@param speed number
---@param drivingStyle integer
---@param minDistance integer
function TaskVehicleFollow(driver, vehicle, targetEntity, speed, drivingStyle, minDistance) end

---@param ped integer
---@param vehicle integer
---@param WPRecording string
---@param p3 integer
---@param p4 integer
---@param p5 integer
---@param p6 integer
---@param p7 number
---@param p8 boolean
---@param p9 number
function TaskVehicleFollowWaypointRecording(ped, vehicle, WPRecording, p3, p4, p5, p6, p7, p8, p9) end

---@param ped integer
---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param speed number
---@param behaviorFlag integer
---@param stoppingRange number
function TaskVehicleGotoNavmesh(ped, vehicle, x, y, z, speed, behaviorFlag, stoppingRange) end

---@param pilot integer
---@param vehicle integer
---@param entityToFollow integer
---@param targetSpeed number
---@param p4 integer
---@param radius number
---@param altitude integer
---@param p7 integer
function TaskVehicleHeliProtect(pilot, vehicle, entityToFollow, targetSpeed, p4, radius, altitude, p7) end

---@param ped integer
---@param vehicle integer
---@param vehicleTarget integer
---@param missionType integer
---@param speed number
---@param drivingStyle integer
---@param radius number
---@param straightLineDist number
---@param DriveAgainstTraffic boolean
function TaskVehicleMission(ped, vehicle, vehicleTarget, missionType, speed, drivingStyle, radius, straightLineDist, DriveAgainstTraffic) end

---@param ped integer
---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param missionType integer
---@param speed number
---@param drivingStyle integer
---@param radius number
---@param straightLineDist number
---@param DriveAgainstTraffic boolean
function TaskVehicleMissionCoorsTarget(ped, vehicle, x, y, z, missionType, speed, drivingStyle, radius, straightLineDist, DriveAgainstTraffic) end

---@param ped integer
---@param vehicle integer
---@param pedTarget integer
---@param missionType integer
---@param speed number
---@param drivingStyle integer
---@param radius number
---@param straightLineDist number
---@param DriveAgainstTraffic boolean
function TaskVehicleMissionPedTarget(ped, vehicle, pedTarget, missionType, speed, drivingStyle, radius, straightLineDist, DriveAgainstTraffic) end

---@param ped integer
---@param vehicle integer
---@param x number
---@param y number
---@param z number
---@param heading number
---@param mode integer
---@param radius number
---@param keepEngineOn boolean
function TaskVehiclePark(ped, vehicle, x, y, z, heading, mode, radius, keepEngineOn) end

---@param vehicle integer
---@param animationSet string
---@param animationName string
function TaskVehiclePlayAnim(vehicle, animationSet, animationName) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param p4 number
function TaskVehicleShootAtCoord(ped, x, y, z, p4) end

---@param ped integer
---@param target integer
---@param p2 number
function TaskVehicleShootAtPed(ped, target, p2) end

---@param driver integer
---@param vehicle integer
---@param action integer
---@param time integer
function TaskVehicleTempAction(driver, vehicle, action, time) end

---@param ped integer
---@param x number
---@param y number
---@param z number
---@param radius number
---@param minimalLength integer
---@param timeBetweenWalks number
function TaskWanderInArea(ped, x, y, z, radius, minimalLength, timeBetweenWalks) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
function TaskWanderSpecific(p0, p1, p2, p3) end

---@param ped integer
---@param p1 number
---@param p2 integer
function TaskWanderStandard(ped, p1, p2) end

---@param ped integer
---@param time integer
---@param canPeekAndAim boolean
---@param forceInitialFacingDirection boolean
---@param forceFaceLeft boolean
---@param coverIndex integer
function TaskWarpPedDirectlyIntoCover(ped, time, canPeekAndAim, forceInitialFacingDirection, forceFaceLeft, coverIndex) end

---@param ped integer
---@param vehicle integer
---@param seatIndex integer
function TaskWarpPedIntoVehicle(ped, vehicle, seatIndex) end

---@param ped integer
---@param target integer
---@param time integer
---@param p3 integer
function TaskWrithe(ped, target, time, p3) end

---@param scriptName string
function TerminateAllScriptsWithThisName(scriptName) end


function TerminateThisThread() end

---@param threadId integer
function TerminateThread(threadId) end

---@param toggle boolean
function TerraingridActivate(toggle) end

---@param lowR integer
---@param lowG integer
---@param lowB integer
---@param lowAlpha integer
---@param R integer
---@param G integer
---@param B integer
---@param Alpha integer
---@param highR integer
---@param highG integer
---@param highB integer
---@param highAlpha integer
function TerraingridSetColours(lowR, lowG, lowB, lowAlpha, R, G, B, Alpha, highR, highG, highB, highAlpha) end

---@param x number
---@param y number
---@param z number
---@param p3 number
---@param rotation number
---@param p5 number
---@param width number
---@param height number
---@param p8 number
---@param scale number
---@param glowIntensity number
---@param normalHeight number
---@param heightDiff number
function TerraingridSetParams(x, y, z, p3, rotation, p5, width, height, p8, scale, glowIntensity, normalHeight, heightDiff) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param flag integer
---@return boolean, vector3
function TestProbeAgainstAllWater(x1, y1, z1, x2, y2, z2, flag) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return boolean, vector3
function TestProbeAgainstWater(x1, y1, z1, x2, y2, z2) end

---@param x number
---@param y number
---@param z number
---@param flag integer
---@return boolean, number
function TestVerticalProbeAgainstAllWater(x, y, z, flag) end

---@param p0 integer
---@return string
function TextureDownloadGetName(p0) end

---@param p0 integer
---@return boolean
function TextureDownloadHasFailed(p0) end

---@param p0 integer
function TextureDownloadRelease(p0) end

---@param FilePath string
---@param Name string
---@param p3 boolean
---@return integer, integer
function TextureDownloadRequest(FilePath, Name, p3) end


function ThefeedAutoPostGametipsOff() end


function ThefeedAutoPostGametipsOn() end


function ThefeedClearFrozenPost() end


function ThefeedDisableLoadingScreenTips() end


function ThefeedDisplayLoadingScreenTips() end


function ThefeedFlushQueue() end


function ThefeedForceRenderOff() end


function ThefeedForceRenderOn() end


function ThefeedFreezeNextPost() end

---@return integer
function ThefeedGetFirstVisibleDeleteRemaining() end


function ThefeedHideThisFrame() end

---@return boolean
function ThefeedIsPaused() end

---@param toggle boolean
function ThefeedOnlyShowTooltips(toggle) end


function ThefeedPause() end

---@param notificationId integer
function ThefeedRemoveItem(notificationId) end


function ThefeedResetAllParameters() end


function ThefeedResume() end

---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function ThefeedSetAnimpostfxColor(red, green, blue, alpha) end

---@param count integer
function ThefeedSetAnimpostfxCount(count) end

---@param toggle boolean
function ThefeedSetAnimpostfxSound(toggle) end

---@param toggle boolean
function ThefeedSetFlushAnimpostfx(toggle) end

---@param hudColorIndex integer
function ThefeedSetNextPostBackgroundColor(hudColorIndex) end

---@param pos number
function ThefeedSetScriptedMenuHeight(pos) end


function ThefeedSpsExtendWidescreenOff() end


function ThefeedSpsExtendWidescreenOn() end

---@param txdString1 string
---@param txnString1 string
---@param txdString2 string
---@param txnString2 string
function ThefeedUpdateItemTexture(txdString1, txnString1, txdString2, txnString2) end

---@return integer
function Timera() end

---@return integer
function Timerb() end

---@return number
function Timestep() end

---@param FilePath string
---@param Name string
---@param p2 boolean
---@return integer
function TitleTextureDownloadRequest(FilePath, Name, p2) end

---@param value integer
---@return number
function ToFloat(value) end

---@param toggle boolean
function TogglePausedRenderphases(toggle) end

---@param toggle boolean
function ToggleShowOptionalStuntJumpCamera(toggle) end

---@param toggle boolean
function ToggleStealthRadar(toggle) end

---@param player integer
---@param pickupHash integer | string
---@param toggle boolean
function ToggleUsePickupsForPlayer(player, pickupHash, toggle) end

---@param vehicle integer
---@param modType integer
---@param toggle boolean
function ToggleVehicleMod(vehicle, modType, toggle) end

---@param object integer
function TrackObjectVisibility(object) end

---@param vehicle integer
function TrackVehicleVisibility(vehicle) end

---@param vehicle integer
---@param instantly boolean
function TransformToCar(vehicle, instantly) end

---@param vehicle integer
---@param instantly boolean
function TransformToSubmarine(vehicle, instantly) end

---@param eventName string
---@param eventPayload string
---@param payloadLength integer
---@param bps integer
function TriggerLatentServerEventInternal(eventName, eventPayload, payloadLength, bps) end

---@param eventName string
---@return boolean
function TriggerMusicEvent(eventName) end

---@param transitionTime number
---@return boolean
function TriggerScreenblurFadeIn(transitionTime) end

---@param transitionTime number
---@return boolean
function TriggerScreenblurFadeOut(transitionTime) end

---@param player integer
---@param p1 integer
---@param scriptHash integer | string
---@return boolean
function TriggerScriptCrcCheckOnPlayer(player, p1, scriptHash) end

---@param eventGroup integer
---@param eventDataSize integer
---@param playerBits integer
---@return integer
function TriggerScriptEvent(eventGroup, eventDataSize, playerBits) end

---@param eventGroup integer
---@param eventDataSize integer
---@param playerBits integer
---@return integer
function TriggerScriptEvent_2(eventGroup, eventDataSize, playerBits) end

---@param eventName string
---@param eventPayload string
---@param payloadLength integer
function TriggerServerEventInternal(eventName, eventPayload, payloadLength) end

---@param vehicle integer
function TriggerSiren(vehicle) end

---@param posX number
---@param posY number
---@param posZ number
---@param radius number
---@param p4 integer
function TriggerSonarBlip(posX, posY, posZ, radius, p4) end

---@param vehicle integer
---@param seat integer
---@param ped integer
---@return boolean
function TriggerVehicleWeaponReload(vehicle, seat, ped) end


function UgcCancelQuery() end


function UgcClearCreateResult() end


function UgcClearModifyResult() end


function UgcClearOfflineQuery() end


function UgcClearQueryResults() end

---@return boolean, any, any
function UgcCopyContent() end

---@param data string
---@param dataCount integer
---@param contentName string
---@param description string
---@param tagsCsv string
---@param contentTypeName string
---@param publish boolean
---@return boolean
function UgcCreateContent(data, dataCount, contentName, description, tagsCsv, contentTypeName, publish) end

---@param contentName string
---@param description string
---@param tagsCsv string
---@param contentTypeName string
---@param publish boolean
---@return boolean
function UgcCreateMission(contentName, description, tagsCsv, contentTypeName, publish) end

---@return any
function UgcDidGetSucceed() end

---@param p0 any
---@param p1 any
---@return boolean, any, any
function UgcGetBookmarkedContent(p0, p1) end

---@param p0 any
---@param p1 any
---@return string
function UgcGetCachedDescription(p0, p1) end

---@param p0 integer
---@return integer
function UgcGetContentCategory(p0) end

---@param p0 any
---@return integer
function UgcGetContentDescriptionHash(p0) end

---@param p0 any
---@param p1 any
---@return any
function UgcGetContentFileVersion(p0, p1) end

---@param p0 any
---@return boolean
function UgcGetContentHasPlayerBookmarked(p0) end

---@param p0 any
---@return boolean
function UgcGetContentHasPlayerRecord(p0) end

---@return integer
function UgcGetContentHash() end

---@param p0 integer
---@return string
function UgcGetContentId(p0) end

---@param p0 any
---@return boolean
function UgcGetContentIsPublished(p0) end

---@param p0 any
---@return boolean
function UgcGetContentIsVerified(p0) end

---@param p0 any
---@return any
function UgcGetContentLanguage(p0) end

---@param p0 any
---@return string
function UgcGetContentName(p0) end

---@return any
function UgcGetContentNum() end

---@param p0 integer
---@param p1 integer
---@return string
function UgcGetContentPath(p0, p1) end

---@param p0 any
---@param p1 any
---@return any
function UgcGetContentRating(p0, p1) end

---@param p0 any
---@param p1 any
---@return any
function UgcGetContentRatingCount(p0, p1) end

---@param p0 any
---@param p1 any
---@return any
function UgcGetContentRatingNegativeCount(p0, p1) end

---@param p0 any
---@param p1 any
---@return any
function UgcGetContentRatingPositiveCount(p0, p1) end

---@return any
function UgcGetContentTotal() end

---@param p0 any
---@return any
function UgcGetContentUpdatedDate(p0) end

---@param p0 integer
---@return string
function UgcGetContentUserId(p0) end

---@param p0 any
---@return string
function UgcGetContentUserName(p0) end

---@return string
function UgcGetCreateContentId() end

---@return any
function UgcGetCreateResult() end

---@return any
function UgcGetCreatorNum() end

---@param p0 any
---@param p1 any
---@param p2 any
---@return boolean, any, any
function UgcGetCrewContent(p0, p1, p2) end

---@param p0 any
---@param p1 any
---@return boolean, any, any
function UgcGetFriendContent(p0, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@return boolean, any, any
function UgcGetGetByCategory(p0, p1, p2) end

---@return any
function UgcGetModifyResult() end

---@param p0 any
---@param p1 any
---@return boolean, any, any
function UgcGetMyContent(p0, p1) end

---@return any
function UgcGetQueryResult() end

---@param p0 integer
---@return string
function UgcGetRootContentId(p0) end

---@return boolean
function UgcHasCreateFinished() end

---@return boolean
function UgcHasGetFinished() end

---@return boolean
function UgcHasModifyFinished() end

---@return boolean
function UgcIsGetting() end

---@param p0 any
---@return boolean
function UgcIsLanguageSupported(p0) end

---@param p0 any
---@return boolean
function UgcPoliciesMakePrivate(p0) end

---@param contentId string
---@param baseContentId string
---@param contentTypeName string
---@return boolean
function UgcPublish(contentId, baseContentId, contentTypeName) end

---@param contentId string
---@param latestVersion boolean
---@param contentTypeName string
---@return boolean
function UgcQueryByContentId(contentId, latestVersion, contentTypeName) end

---@param count integer
---@param latestVersion boolean
---@param contentTypeName string
---@return boolean, any
function UgcQueryByContentIds(count, latestVersion, contentTypeName) end

---@param p0 any
---@param p1 any
---@param p3 any
---@param p4 any
---@param p5 any
---@return boolean, any
function UgcQueryMyContent(p0, p1, p3, p4, p5) end

---@param offset integer
---@param count integer
---@param contentTypeName string
---@param p3 integer
---@return boolean
function UgcQueryRecentlyCreatedContent(offset, count, contentTypeName, p3) end

---@param p0 integer
---@return integer
function UgcRequestCachedDescription(p0) end

---@param p0 integer
---@param p1 integer
---@return integer
function UgcRequestContentDataFromIndex(p0, p1) end

---@param contentTypeName string
---@param contentId string
---@param p2 integer
---@param p3 integer
---@param p4 integer
---@return integer
function UgcRequestContentDataFromParams(contentTypeName, contentId, p2, p3, p4) end

---@param contentId string
---@param bookmarked boolean
---@param contentTypeName string
---@return boolean
function UgcSetBookmarked(contentId, bookmarked, contentTypeName) end

---@param p1 boolean
---@return boolean, any, any
function UgcSetDeleted(p1) end

---@param contentId string
---@param rating number
---@param contentTypeName string
---@return boolean
function UgcSetPlayerData(contentId, rating, contentTypeName) end

---@param p0 boolean
function UgcSetQueryDataFromOffline(p0) end

---@param p1 any
---@param p2 any
---@param p3 any
---@param p5 boolean
---@return any, any, any
function UgcTextureDownloadRequest(p1, p2, p3, p5) end

---@param contentId string
---@param dataCount integer
---@param contentName string
---@param description string
---@param tagsCsv string
---@param contentTypeName string
---@return boolean, any
function UgcUpdateContent(contentId, dataCount, contentName, description, tagsCsv, contentTypeName) end

---@param contentId string
---@param contentName string
---@param description string
---@param tagsCsv string
---@param contentTypeName string
---@return boolean
function UgcUpdateMission(contentId, contentName, description, tagsCsv, contentTypeName) end

---@return boolean
function Ui3dsceneIsAvailable() end

---@param presetName string
---@return boolean
function Ui3dscenePushPreset(presetName) end

---@return boolean
function UiStartedEndUserBenchmark() end

---@param name integer | string
---@param eventType integer
function UnblockDecisionMakerEvent(name, eventType) end

---@param groupName string
function UnblockSpeechContextGroup(groupName) end

---@param ped integer
function UncuffPed(ped) end

---@param radioStation string
function UnfreezeRadioStation(radioStation) end

---@param name string
---@param p1 number
function UnloadCloudHat(name, p1) end

---@param hash integer | string
function UnloadContentChangeSetGroup(hash) end


function UnlockMinimapAngle() end


function UnlockMinimapPosition() end

---@param newsStory integer
function UnlockMissionNewsStory(newsStory) end

---@param radioStation string
---@param trackListName string
function UnlockRadioStationTrackList(radioStation, trackListName) end

---@param decalType integer
function UnpatchDecalDiffuseMap(decalType) end

---@param vehicle integer
function UnpausePlaybackRecordedVehicle(vehicle) end

---@param interior integer
function UnpinInterior(interior) end

---@param ropeId integer
---@param vertex integer
function UnpinRopeVertex(ropeId, vertex) end

---@param id integer
function UnregisterPedheadshot(id) end

---@param callbackType string
function UnregisterRawNuiCallback(callbackType) end


function UnregisterScriptWithAudio() end


function UnrequestTennisBanks() end

---@param entity integer
function UpdateLightsOnEntity(entity) end

---@param mapdata integer
---@param entity integer
---@param entityDef table
function UpdateMapdataEntity(mapdata, entity, entityDef) end

---@param object integer
---@param posX number
---@param posY number
---@param posZ number
---@param scaleX number
---@param scaleY number
---@param scaleZ number
---@param heading number
---@param flags integer
function UpdateNavmeshBlockingObject(object, posX, posY, posZ, scaleX, scaleY, scaleZ, heading, flags) end

---@return integer
function UpdateOnscreenKeyboard() end

---@param ped integer
---@param shapeMix number
---@param skinMix number
---@param thirdMix number
function UpdatePedHeadBlendData(ped, shapeMix, skinMix, thirdMix) end

---@param player integer
---@return boolean
function UpdatePlayerTeleport(player) end

---@param soundId integer
---@param x number
---@param y number
---@param z number
function UpdateSoundCoord(soundId, x, y, z) end

---@param p0 integer
---@param p1 integer
---@param p2 number
---@param p3 number
---@param p4 number
---@param p5 boolean
function UpdateTaskAimGunScriptedTarget(p0, p1, p2, p3, p4, p5) end

---@param ped integer
---@param duration integer
function UpdateTaskHandsUpDuration(ped, duration) end

---@param ped integer
---@param entity integer
function UpdateTaskSweepAimEntity(ped, entity) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
function UpdateTaskSweepAimPosition(p0, p1, p2, p3) end

---@param allowTrackReprioritization boolean
function UpdateUnlockableDjRadioTracks(allowTrackReprioritization) end

---@param p0 boolean
function UseFakeMpCash(p0) end

---@param ped integer
---@param useSweetner boolean
---@param soundSetHash integer | string
function UseFootstepScriptSweeteners(ped, useSweetner, soundSetHash) end

---@param name string
function UseParticleFxAsset(name) end

---@param toggle boolean
function UsePlayerColourInsteadOfTeamColour(toggle) end

---@param vehicles boolean
---@param peds boolean
function UseScriptCamForAmbientPopulationOriginThisFrame(vehicles, peds) end

---@param vehicle integer
---@param sirenAsHorn boolean
function UseSirenAsHorn(vehicle, sirenAsHorn) end


function UseVehicleCamStuntSettingsThisUpdate() end

---@param name string
---@param p1 boolean
---@param p2 number
---@param p3 number
function UseWaypointRecordingAsAssistedMovementRoute(name, p1, p2, p3) end

---@param toggle boolean
function UsingMissionCreator(toggle) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
function Vdist(x1, y1, z1, x2, y2, z2) end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number
function Vdist2(x1, y1, z1, x2, y2, z2) end

---@param vehicle integer
---@return integer
function VehToNet(vehicle) end

---@param vehicle integer
---@param speed number
function VehicleWaypointPlaybackOverrideSpeed(vehicle, speed) end

---@param vehicle integer
function VehicleWaypointPlaybackPause(vehicle) end

---@param vehicle integer
function VehicleWaypointPlaybackResume(vehicle) end

---@param vehicle integer
function VehicleWaypointPlaybackUseDefaultSpeed(vehicle) end

---@param x number
---@param y number
---@param z number
---@return number
function Vmag(x, y, z) end

---@param x number
---@param y number
---@param z number
---@return number
function Vmag2(x, y, z) end

---@param ms integer
function Wait(ms) end

---@return boolean
function WasCutsceneSkipped() end

---@param ped integer
---@return boolean
function WasPedKilledByStealth(ped) end

---@param ped integer
---@return boolean
function WasPedKilledByTakedown(ped) end

---@param ped integer
---@return boolean
function WasPedKnockedOut(ped) end

---@param ped integer
---@return boolean
function WasPedSkeletonUpdated(ped) end

---@param vehicle integer
---@param p1 number
function WashDecalsFromVehicle(vehicle, p1) end

---@param p0 any
---@param p1 any
---@param p2 any
---@param p3 any
---@param p4 any
function WashDecalsInRange(p0, p1, p2, p3, p4) end

---@param p0 number
function WaterOverrideFadeIn(p0) end

---@param p0 number
function WaterOverrideFadeOut(p0) end

---@param minAmplitude number
function WaterOverrideSetOceannoiseminamplitude(minAmplitude) end

---@param amplitude number
function WaterOverrideSetOceanwaveamplitude(amplitude) end

---@param maxAmplitude number
function WaterOverrideSetOceanwavemaxamplitude(maxAmplitude) end

---@param minAmplitude number
function WaterOverrideSetOceanwaveminamplitude(minAmplitude) end

---@param bumpiness number
function WaterOverrideSetRipplebumpiness(bumpiness) end

---@param disturb number
function WaterOverrideSetRippledisturb(disturb) end

---@param maxBumpiness number
function WaterOverrideSetRipplemaxbumpiness(maxBumpiness) end

---@param minBumpiness number
function WaterOverrideSetRippleminbumpiness(minBumpiness) end

---@param amplitude number
function WaterOverrideSetShorewaveamplitude(amplitude) end

---@param maxAmplitude number
function WaterOverrideSetShorewavemaxamplitude(maxAmplitude) end

---@param minAmplitude number
function WaterOverrideSetShorewaveminamplitude(minAmplitude) end

---@param strength number
function WaterOverrideSetStrength(strength) end

---@param p0 any
---@return boolean
function WaypointPlaybackGetIsPaused(p0) end

---@param p0 any
---@param p1 number
---@param p2 boolean
function WaypointPlaybackOverrideSpeed(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 boolean
function WaypointPlaybackPause(p0, p1, p2) end

---@param p0 any
---@param p1 boolean
---@param p2 any
---@param p3 any
function WaypointPlaybackResume(p0, p1, p2, p3) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 boolean
function WaypointPlaybackStartAimingAtCoord(p0, p1, p2, p3, p4) end

---@param p0 any
---@param p1 any
---@param p2 boolean
function WaypointPlaybackStartAimingAtPed(p0, p1, p2) end

---@param p0 any
---@param p1 number
---@param p2 number
---@param p3 number
---@param p4 boolean
---@param p5 any
function WaypointPlaybackStartShootingAtCoord(p0, p1, p2, p3, p4, p5) end

---@param p0 any
---@param p1 any
---@param p2 boolean
---@param p3 any
function WaypointPlaybackStartShootingAtPed(p0, p1, p2, p3) end

---@param p0 any
function WaypointPlaybackStopAimingOrShooting(p0) end

---@param p0 any
function WaypointPlaybackUseDefaultSpeed(p0) end

---@param name string
---@param x number
---@param y number
---@param z number
---@return boolean, integer
function WaypointRecordingGetClosestWaypoint(name, x, y, z) end

---@param name string
---@param point integer
---@return boolean, vector3
function WaypointRecordingGetCoord(name, point) end

---@param name string
---@return boolean, integer
function WaypointRecordingGetNumPoints(name) end

---@param name string
---@param point integer
---@return number
function WaypointRecordingGetSpeedAtPoint(name, point) end

---@param amount integer
---@return integer
function WithdrawVc(amount) end

---@param entityModelHash integer | string
---@param x number
---@param y number
---@param z number
---@param p4 boolean
---@return boolean
function WouldEntityBeOccluded(entityModelHash, x, y, z, p4) end
