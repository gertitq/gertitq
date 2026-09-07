-- Grow a Chicken Fighter: Maclib Auto Arena
local SCRIPT_VERSION = "v1.0.372"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local sharedEnv = getgenv()
-- Reset the old top-right default once for this icon layout.  After the first
-- run, a manually dragged position is preserved across reloads.
if sharedEnv.ChickenArenaMinimizeIconPositionVersion ~= SCRIPT_VERSION then
    sharedEnv.ChickenArenaMinimizeIconPosition = nil
    sharedEnv.ChickenArenaMinimizeIconPositionVersion = SCRIPT_VERSION
end
if sharedEnv.ChickenScrapInputConnection then
    pcall(function()
        sharedEnv.ChickenScrapInputConnection:Disconnect()
    end)
    sharedEnv.ChickenScrapInputConnection = nil
end
if sharedEnv.ChickenStatsMountConnection then
    pcall(function()
        sharedEnv.ChickenStatsMountConnection:Disconnect()
    end)
    sharedEnv.ChickenStatsMountConnection = nil
end
if sharedEnv.ChickenStatsTabConnections then
    for _, connection in ipairs(sharedEnv.ChickenStatsTabConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    sharedEnv.ChickenStatsTabConnections = nil
end
if sharedEnv.ChickenAutoFuseInputMountConnection then
    pcall(function()
        sharedEnv.ChickenAutoFuseInputMountConnection:Disconnect()
    end)
    sharedEnv.ChickenAutoFuseInputMountConnection = nil
end
if sharedEnv.ChickenAntiIdleConnection then
    pcall(function()
        sharedEnv.ChickenAntiIdleConnection:Disconnect()
    end)
    sharedEnv.ChickenAntiIdleConnection = nil
end
if sharedEnv.ChickenUiWindowScaleConnections then
    for _, connection in ipairs(sharedEnv.ChickenUiWindowScaleConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    sharedEnv.ChickenUiWindowScaleConnections = nil
end
if sharedEnv.ChickenInterfaceLayoutConnection then
    pcall(function()
        sharedEnv.ChickenInterfaceLayoutConnection:Disconnect()
    end)
    sharedEnv.ChickenInterfaceLayoutConnection = nil
end
-- Tear down the combat ESP from the previous reload before creating a new
-- listener/overlay.  Keeping this separate from the MacLib window prevents a
-- reload from stacking duplicate HP bars and damage counters.
if sharedEnv.ChickenArenaCombatESPConnection then
    pcall(function()
        sharedEnv.ChickenArenaCombatESPConnection:Disconnect()
    end)
    sharedEnv.ChickenArenaCombatESPConnection = nil
end
if sharedEnv.ChickenArenaCombatESPResultConnection then
    pcall(function()
        sharedEnv.ChickenArenaCombatESPResultConnection:Disconnect()
    end)
    sharedEnv.ChickenArenaCombatESPResultConnection = nil
end
if sharedEnv.ChickenArenaCombatESPFxConnection then
    pcall(function()
        sharedEnv.ChickenArenaCombatESPFxConnection:Disconnect()
    end)
    sharedEnv.ChickenArenaCombatESPFxConnection = nil
end
if sharedEnv.ChickenArenaCombatESPFxFastConnection then
    pcall(function()
        sharedEnv.ChickenArenaCombatESPFxFastConnection:Disconnect()
    end)
    sharedEnv.ChickenArenaCombatESPFxFastConnection = nil
end
if sharedEnv.ChickenArenaCombatESPGui then
    pcall(function()
        sharedEnv.ChickenArenaCombatESPGui:Destroy()
    end)
    sharedEnv.ChickenArenaCombatESPGui = nil
end
-- Keep the controller's event listeners bounded across live reloads.  The
-- old listeners were generation-gated, but they still woke up for every
-- Arena/Tower event and accumulated after each reload.
if sharedEnv.ChickenArenaCoreConnections then
    for _, connection in ipairs(sharedEnv.ChickenArenaCoreConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    sharedEnv.ChickenArenaCoreConnections = nil
end
-- Auto Rejoin was removed.  Retire a listener left by an older build before
-- the new script starts, so an old enabled setting cannot teleport the client.
if sharedEnv.ChickenAutoRejoinConnection then
    pcall(function()
        sharedEnv.ChickenAutoRejoinConnection:Disconnect()
    end)
    sharedEnv.ChickenAutoRejoinConnection = nil
end
-- Stop the previous UFO/UFU controller before rebuilding the window.  The
-- token makes an old loop exit even when its task is between waits.
if sharedEnv.ChickenUfuLoopToken then
    sharedEnv.ChickenUfuLoopToken += 1
    sharedEnv.ChickenUfuLoopToken = nil
end
if sharedEnv.ChickenUfuEventConnections then
    for _, connection in ipairs(sharedEnv.ChickenUfuEventConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    sharedEnv.ChickenUfuEventConnections = nil
end
if sharedEnv.ChickenArenaMacWindow then
    pcall(function()
        sharedEnv.ChickenArenaMacWindow:Unload()
    end)
    sharedEnv.ChickenArenaMacWindow = nil
else
    for _, item in CoreGui:GetDescendants() do
        if item:IsA("TextLabel") and item.Text == "gertitq" then
            local oldGui = item:FindFirstAncestorOfClass("ScreenGui")
            if oldGui then
                oldGui:Destroy()
                break
            end
        end
    end
end
if sharedEnv.ChickenArenaMinimizeIconConnection then
    pcall(function()
        sharedEnv.ChickenArenaMinimizeIconConnection:Disconnect()
    end)
    sharedEnv.ChickenArenaMinimizeIconConnection = nil
end
if sharedEnv.ChickenArenaMinimizeIconDragConnections then
    for _, connection in ipairs(sharedEnv.ChickenArenaMinimizeIconDragConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    sharedEnv.ChickenArenaMinimizeIconDragConnections = nil
end
sharedEnv.ChickenArenaMinimizeIconDragBound = nil
sharedEnv.ChickenArenaMinimizeIconDragState = nil
if sharedEnv.ChickenArenaMinimizeIconGui then
    pcall(function()
        sharedEnv.ChickenArenaMinimizeIconGui:Destroy()
    end)
    sharedEnv.ChickenArenaMinimizeIconGui = nil
end
-- Remove an icon ScreenGui left by an older build even when the executor did
-- not preserve the sharedEnv reference across reloads.
local iconGuiParents = {CoreGui}
if type(gethui) == "function" then
    pcall(function()
        local hiddenGui = gethui()
        if hiddenGui then
            table.insert(iconGuiParents, hiddenGui)
        end
    end)
end
for _, iconGuiParent in ipairs(iconGuiParents) do
    pcall(function()
        for _, child in ipairs(iconGuiParent:GetChildren()) do
            if child:IsA("ScreenGui")
                and (child.Name == "ChickenArenaMinimizeIcon"
                    or child.Name == "ChickenArenaMinimizeIconV2") then
                child:Destroy()
            end
        end
        local nestedIconGuis = {}
        for _, item in ipairs(iconGuiParent:GetDescendants()) do
            if item:IsA("ScreenGui")
                and (item.Name == "ChickenArenaMinimizeIcon"
                    or item.Name == "ChickenArenaMinimizeIconV2") then
                table.insert(nestedIconGuis, item)
            end
        end
        for _, item in ipairs(nestedIconGuis) do
            item:Destroy()
        end
    end)
end
sharedEnv.ChickenArenaMinimizeIconTrackedGui = nil
sharedEnv.ChickenArenaMinimizeIconTrackedBase = nil

-- Retire the old standalone monitor now that its information lives in this window.
sharedEnv.ChickenArenaMonitorGeneration = (sharedEnv.ChickenArenaMonitorGeneration or 0) + 1
if sharedEnv.ChickenArenaMonitorWindow then
    pcall(function()
        sharedEnv.ChickenArenaMonitorWindow:Unload()
    end)
    sharedEnv.ChickenArenaMonitorWindow = nil
end

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local arenaGetView = remotes:WaitForChild("ArenaGetView")
local arenaFight = remotes:WaitForChild("ArenaFight")
local arenaSkip = remotes:WaitForChild("ArenaSkip")
local arenaBattleResult = remotes:WaitForChild("ArenaBattleResult")
local setAutoAbility = remotes:WaitForChild("SetArenaAutoAbility")
local incubatorClaim = remotes:WaitForChild("IncubatorClaim")
local towerStart = remotes:WaitForChild("TowerStart")
local towerElevator = remotes:WaitForChild("TowerElevator")
local towerSurrender = remotes:WaitForChild("TowerSurrender")
local rebirthRemote = remotes:WaitForChild("Rebirth")
local towerRunStarted = remotes:WaitForChild("TowerRunStarted")
local towerRunEnded = remotes:WaitForChild("TowerRunEnded")
local towerDefeat = remotes:WaitForChild("TowerDefeat")
local towerContinueOffer = remotes:WaitForChild("TowerContinueOffer")
local towerContinueDecline = remotes:WaitForChild("TowerContinueDecline")
local expandCoopRemote = remotes:WaitForChild("ExpandCoop")
local buyGeneratorRemote = remotes:WaitForChild("BuyGenerator")
local upgradeGeneratorRemote = remotes:WaitForChild("UpgradeGenerator")
local upgradeRecyclerRemote = remotes:WaitForChild("UpgradeRecycler")
sharedEnv.ChickenPromoteRemote = remotes:WaitForChild("PromoteChicken")
-- Collection/Fusion remotes use the same calls as the game's Flock UI.  Keep
-- them in one table so the Auto Fuse controller can be disabled cleanly on
-- reload without adding more top-level locals.
sharedEnv.ChickenFuseRemotes = {
    fuse = remotes:WaitForChild("FuseChickens"),
    nickname = remotes:WaitForChild("SetChickenNickname"),
    sell = remotes:WaitForChild("SellChickens"),
}

local loadModule = require
local DataService = loadModule(ReplicatedStorage.Packages.DataService)
local RebirthBonus = loadModule(ReplicatedStorage.Core.Progression.RebirthBonus)
local RebirthExperiment = loadModule(ReplicatedStorage.Core.Progression.RebirthExperiment)
local CoopView = loadModule(ReplicatedStorage.Features.Coop.CoopView)
local RecyclerView = loadModule(ReplicatedStorage.Features.Scrap.RecyclerView)
local TowerFloor = loadModule(ReplicatedStorage.Features.Battle.tower.TowerFloor)
local ChickenMode
local ChickenOverlay
pcall(function()
    local chickenFeatures = Players.LocalPlayer:WaitForChild("PlayerScripts")
        :WaitForChild("Features")
        :WaitForChild("Chicken")
    ChickenMode = loadModule(chickenFeatures:WaitForChild("ChickenMode"))
    ChickenOverlay = loadModule(chickenFeatures:WaitForChild("ChickenOverlay"))
end)

local MacLib = loadstring(game:HttpGet(
    "https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"
))()

-- Keep settings isolated per Roblox account.  Potassium/Real's workspace is
-- shared by multiple clients, so a single fixed filename lets one account
-- overwrite the other account's toggles whenever either UI saves.
sharedEnv.ChickenSettingsProfile = {
    legacyFile = "ChickenFighterSettings.json",
    migrationFile = "ChickenFighterSettings.profile.json",
    player = Players.LocalPlayer,
}
sharedEnv.ChickenSettingsProfile.userId = sharedEnv.ChickenSettingsProfile.player
    and tonumber(sharedEnv.ChickenSettingsProfile.player.UserId) or nil
sharedEnv.ChickenSettingsProfile.accountKey = sharedEnv.ChickenSettingsProfile.userId
    and tostring(math.floor(sharedEnv.ChickenSettingsProfile.userId))
    or tostring(sharedEnv.ChickenSettingsProfile.player
        and sharedEnv.ChickenSettingsProfile.player.Name or "player"):gsub("[^%w%-_]", "_")
if sharedEnv.ChickenSettingsProfile.accountKey == "" then
    sharedEnv.ChickenSettingsProfile.accountKey = "player"
end
sharedEnv.ChickenSettingsProfile.ownerKey = sharedEnv.ChickenSettingsProfile.userId
    and tostring(math.floor(sharedEnv.ChickenSettingsProfile.userId))
    or ("name:" .. sharedEnv.ChickenSettingsProfile.accountKey)
sharedEnv.ChickenSettingsProfile.file = "ChickenFighterSettings_"
    .. sharedEnv.ChickenSettingsProfile.accountKey .. ".json"
sharedEnv.ChickenSettingsFile = sharedEnv.ChickenSettingsProfile.file
sharedEnv.ChickenSettingsAccountKey = sharedEnv.ChickenSettingsProfile.ownerKey
local DEFAULT_SETTINGS_SCHEMA = 2
-- Keep held Scrap close to the Recycler without entering its auto-deposit radius.
-- The final 12-stud approach is reserved for the Rebirth overlap window.
local SCRAP_RECYCLER_STAGING_DISTANCE = 18
-- Embedded startup defaults. These mirror the current saved configuration so
-- a new machine starts with the same values even before a settings file exists.
local DEFAULT_SETTINGS = {
    -- Synced from the current gertitq profile.  These values are used whenever
    -- a machine has no saved settings file yet.  Webhook URLs stay blank so
    -- publishing the script cannot disclose the account's private tokens.
    autoArena = false,
    -- Match the current gertitq Arena page preference.
    arenaCombatEsp = false,
    smartSelection = false,
    autoTowerToRebirth = false,
    autoTowerContinuous = false,
    -- Leave is opt-in.  A blank/zero target keeps the feature unarmed even
    -- when an old config contains the toggle.
    autoLeaveOnRebirth = false,
    leaveWhenRebirth = 0,
    autoLeaveAfterMinutes = false,
    leaveAfterMinutes = 0,
    autoDismissTowerPopup = true,
    towerStartLatest = true,
    towerStartDelay = 25,
    towerDeathDelay = 15,
    -- Optional timed Tower loop controls.  Zero/blank means no extra delay.
    towerRunDuration = 35,
    towerNextRunDelay = 25,
    autoIncubator = true,
    autoHatching = false,
    autoHatchSell = false,
    hatchingEggs = {},
    hatchingSellRarityExceptions = {},
    hatchingSellChickenExceptions = {"catalyst_hen", "storm_colossus"},
    fastIncubator = false,
    fastIncubatorSwapSeconds = 1,
    fastIncubatorReturnSeconds = 5,
    -- Fast Coop Deploy starts with no Source/Target selection.  The feature
    -- remains idle until both are chosen explicitly in the UI.
    fastIncubatorSourceId = nil,
    fastIncubatorTargetId = nil,
    -- Auto to Chaos is opt-in.  The selected event ids determine when the
    -- owned chicken is sent to the event pit.
    autoUfu = false,
    autoChaosEvents = {"ufo"},
    autoChaosUsePickedChicken = false,
    autoChaosUseAllEventChicken = false,
    autoChaosUseUfoChicken = false,
    autoChaosChickenId = nil,
    autoChaosChickenIds = {},
    autoChaosTargetRarity = "secret",
    -- UFO leave is opt-in.  A blank rarity or a disabled toggle never
    -- schedules a leave, even when the selected UFO roster is already done.
    autoLeaveOnUfoRarity = false,
    leaveWhenUfoRarity = "",
    autoNest = true,
    autoScrap = false,
    holdScrapBeforeRebirth = false,
    scrapTargetCount = 10,
    scrapDepositDelay = 0,
    -- Rebirth delay starts either when Scrap deposit is confirmed (current
    -- behavior) or as soon as the Recycler walk starts (legacy behavior).
    rebirthDelayTrigger = "deposit",
    scrapManualPauseSeconds = 5,
    upgradeEnabled = false,
    upgradeCoop = true,
    upgradeFeeder = true,
    feederWatchdog = false,
    upgradeRecycler = true,
    keepMoneyForLastFloor = true,
    upgradeOrder = "feeder",
    upgradeDelay = 0.1,
    autoFuse = false,
    autoFuseConfigVersion = 5,
    autoFuseMode = "sameName",
    autoFuseRarity = "",
    autoFuseRarities = {},
    -- Empty means every owned chicken type in the selected rarities is
    -- eligible.  When populated, only the selected typeIds are considered.
    autoFuseChickenNames = {},
    autoFuseExceptions = {},
    autoFuseDelay = 0.5,
    autoFuseKeepBest = 5,
    -- Kept for old config compatibility; Mode 2 now always fuses instead of
    -- selling incomplete-stat chickens.
    autoFuseSellBadStat = false,
    autoFuseRenameIfUp = "up",
    autoFuseRenameIfAlone = "alone",
    -- Auto Promote is opt-in.  Targets are owned chicken ids; materials are
    -- selected automatically from the same chicken type while protecting
    -- Favorite/Inverted chickens and the configured rarity boundaries.
    autoPromote = false,
    promoteTargetIds = {},
    -- Target processing follows the picker order (especially useful when
    -- several copies share the same name and rarity).
    promoteTargetOrder = {},
    -- Optional egg source.  An empty value keeps the manual target picker.
    promoteEggId = "",
    promoteExcludeChickenTypes = {},
    promoteKeepCount = 3,
    promoteKeepConfigVersion = 1,
    promoteExcludeRarities = {},
    -- Exclude only material rarities strictly higher than the target by
    -- default; equal rarity remains usable unless the user selects the
    -- stricter >= option.
    promoteExcludeHigher = true,
    promoteExcludeHigherOrEqual = false,
    uiToggleKey = "LeftShift",
    -- Optional game-window sizing controls.  Zero/blank leaves each original
    -- dimension unchanged; user-facing values are percentages (0-100).
    uiWindowWidthPercent = 0,
    uiWindowHeightPercent = 0,
    -- Stats catalog level used for the displayed HP/ATK base values.
    statsBaseLevel = 1,
    -- Genome value used for the catalog projection; each rarity clamps it to
    -- its own gene cap (e.g. Common 8, Mythic 27, Secret 31).
    statsGenomeStat = 31,
    statsSelectedTypeIds = {},
    statsSelectedEggId = nil,
    -- Discord webhook notifications are opt-in and never include the webhook
    -- URL in logs or UI text.  Keep the current event selection, but leave
    -- sending disabled until the user enables it.
    discordWebhookEnabled = false,
    discordWebhookUrl = "",
    discordWebhookEvents = {"ufo"},
    -- Upcoming-event schedule updates are independent from LIVE alerts and
    -- use their own Discord webhook URL.
    discordUpcomingEventsEnabled = false,
    discordUpcomingEventsUrl = "",
    discordUpcomingEventsMessageId = "",
}
local savedSettings: {[string]: any} = {}

sharedEnv.ChickenReadJsonFile = function(path)
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return nil
    end

    local existsOk, exists = pcall(function()
        return isfile(path)
    end)
    if not existsOk or not exists then
        return nil
    end

    local readOk, contents = pcall(function()
        return readfile(path)
    end)
    if not readOk or type(contents) ~= "string" or contents == "" then
        return nil
    end

    local decodeOk, decoded = pcall(function()
        return HttpService:JSONDecode(contents)
    end)
    return decodeOk and type(decoded) == "table" and decoded or nil
end

sharedEnv.ChickenReadSettingsFile = function(path)
    local decoded = sharedEnv.ChickenReadJsonFile(path)
    if type(decoded) == "table"
        and tonumber(decoded.__schema) == DEFAULT_SETTINGS_SCHEMA then
        return decoded
    end
    return nil
end

local function loadSavedSettings()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return
    end

    local profile = sharedEnv.ChickenReadSettingsFile(sharedEnv.ChickenSettingsProfile.file)
    if profile then
        savedSettings = profile
        return
    end

    -- One-time migration: preserve the existing single-account settings for
    -- the first profile that starts this build, while preventing a second
    -- account from importing the same legacy file and then sharing it again.
    local legacy = sharedEnv.ChickenReadSettingsFile(sharedEnv.ChickenSettingsProfile.legacyFile)
    if not legacy then
        return
    end
    local marker = sharedEnv.ChickenReadJsonFile(sharedEnv.ChickenSettingsProfile.migrationFile)
    local markerOwner = type(marker) == "table" and tostring(marker.owner or "") or ""
    if markerOwner ~= "" and markerOwner ~= sharedEnv.ChickenSettingsProfile.ownerKey then
        return
    end

    savedSettings = legacy
    savedSettings.__accountUserId = sharedEnv.ChickenSettingsProfile.ownerKey
    pcall(function()
        writefile(sharedEnv.ChickenSettingsProfile.file, HttpService:JSONEncode(savedSettings))
    end)
    if markerOwner == "" and type(writefile) == "function" then
        pcall(function()
            writefile(sharedEnv.ChickenSettingsProfile.migrationFile, HttpService:JSONEncode({
                owner = sharedEnv.ChickenSettingsProfile.ownerKey,
                profile = sharedEnv.ChickenSettingsProfile.file,
            }))
        end)
    end
end

local function savedBool(name, fallback)
    local value = savedSettings[name]
    if type(value) == "boolean" then
        return value
    end
    return fallback
end

sharedEnv.ChickenSettingsSavedStringSet = function(value)
    local output = {}
    if type(value) ~= "table" then
        return output
    end
    for key, item in pairs(value) do
        local selected = type(key) == "number" and item or (item == true and key or nil)
        if type(selected) == "string" and selected ~= "" then
            output[selected] = true
        end
    end
    return output
end

sharedEnv.ChickenSettingsStringSetArray = function(value)
    local output = {}
    if type(value) == "table" then
        for key, enabled in pairs(value) do
            local selected = enabled == true and key or (type(key) == "number" and enabled or nil)
            if type(selected) == "string" and selected ~= "" then
                table.insert(output, selected)
            end
        end
    end
    table.sort(output)
    return output
end

-- Maclib TextBox receives keyboard-layout characters as typed. Normalize the
-- Thai Kedmanee number-row keys so values such as 1 or 0.5 still parse when
-- Roblox is using a Thai keyboard layout.
local function parseNumberInput(value)
    local text = tostring(value or "")
    text = text:gsub("ๅ", "1")
        :gsub("/", "2")
        :gsub("-", "3")
        :gsub("ภ", "4")
        :gsub("ถ", "5")
        :gsub("ุ", "6")
        :gsub("ึ", "7")
        :gsub("ค", "8")
        :gsub("ต", "9")
        :gsub("จ", "0")
        :gsub("ม", ".")
    return tonumber(text)
end

sharedEnv.ChickenParsePercentInput = function(value)
    local parsed = parseNumberInput(value)
    if not parsed or parsed <= 0 then
        return 0
    end
    -- Accept both the user-facing percent form (90) and a fractional form
    -- (0.9) so old/manual values remain convenient.
    if parsed <= 1 then
        parsed *= 100
    end
    return math.clamp(parsed, 1, 100)
end

loadSavedSettings()

-- Keep Count was introduced with a zero default.  Migrate that untouched
-- first-run value to the requested default of three, while preserving an
-- explicit zero once the new setting has been saved.
if (tonumber(savedSettings.promoteKeepConfigVersion) or 0)
    < DEFAULT_SETTINGS.promoteKeepConfigVersion then
    if savedSettings.promoteKeepCount == nil
        or tonumber(savedSettings.promoteKeepCount) == 0 then
        savedSettings.promoteKeepCount = DEFAULT_SETTINGS.promoteKeepCount
    end
    savedSettings.promoteKeepConfigVersion = DEFAULT_SETTINGS.promoteKeepConfigVersion
end

-- The first Auto Fuse build persisted its implicit Rarity/Common and "up"
-- defaults.  Migrate that untouched first-run state to empty selections once;
-- deliberate choices made afterward continue to persist normally.
if (tonumber(savedSettings.autoFuseConfigVersion) or 0) < 2 then
    if savedSettings.autoFuseMode == "rarity"
        and savedSettings.autoFuseRarity == "common" then
        savedSettings.autoFuseMode = nil
        savedSettings.autoFuseRarity = nil
    end
    if savedSettings.autoFuseRenameIfUp == "up" then
        savedSettings.autoFuseRenameIfUp = nil
    end
end
-- A previous run could already have written migration version 2 while the
-- Rarity dropdown was still on its implicit Common value.  If no mode is
-- selected, that rarity is not an intentional usable choice; clear it too.
if (savedSettings.autoFuseMode == nil or savedSettings.autoFuseMode == "")
    and savedSettings.autoFuseRarity == "common" then
    savedSettings.autoFuseRarity = nil
end
-- v1.0.91 changes the default nickname for an ascended result to "up".
-- Preserve an explicitly changed value, but migrate the old untouched blank
-- default so the current machine matches the embedded script defaults.
if (tonumber(savedSettings.autoFuseConfigVersion) or 0) < 3
    and (savedSettings.autoFuseRenameIfUp == nil or savedSettings.autoFuseRenameIfUp == "") then
    savedSettings.autoFuseRenameIfUp = DEFAULT_SETTINGS.autoFuseRenameIfUp
end

local autoArena = savedBool("autoArena", DEFAULT_SETTINGS.autoArena)
local smartSelection = savedBool("smartSelection", DEFAULT_SETTINGS.smartSelection)
sharedEnv.ChickenArenaCombatESPEnabled = savedBool(
    "arenaCombatEsp",
    DEFAULT_SETTINGS.arenaCombatEsp
)
-- Migrate the old Auto Tower toggle into the new combined mode once.
local autoTowerToRebirth = savedBool("autoTowerToRebirth", savedBool("autoTower", DEFAULT_SETTINGS.autoTowerToRebirth))
local autoTower = savedBool("autoTowerContinuous", DEFAULT_SETTINGS.autoTowerContinuous)
sharedEnv.ChickenAutoLeaveOnRebirth = savedBool("autoLeaveOnRebirth", DEFAULT_SETTINGS.autoLeaveOnRebirth)
sharedEnv.ChickenLeaveWhenRebirth = math.max(
    0,
    math.floor(parseNumberInput(savedSettings.leaveWhenRebirth) or DEFAULT_SETTINGS.leaveWhenRebirth)
)
sharedEnv.ChickenAutoLeaveAfterMinutes = savedBool(
    "autoLeaveAfterMinutes",
    DEFAULT_SETTINGS.autoLeaveAfterMinutes
)
sharedEnv.ChickenLeaveAfterMinutes = math.max(
    0,
    tonumber(parseNumberInput(savedSettings.leaveAfterMinutes)
        or DEFAULT_SETTINGS.leaveAfterMinutes) or 0
)
local autoDismissTowerPopup = savedBool("autoDismissTowerPopup", DEFAULT_SETTINGS.autoDismissTowerPopup)
local towerStartLatest = savedBool("towerStartLatest", DEFAULT_SETTINGS.towerStartLatest)
local towerStartDelay = math.clamp(parseNumberInput(savedSettings.towerStartDelay) or DEFAULT_SETTINGS.towerStartDelay, 0, 300)
local towerDeathDelay = math.clamp(parseNumberInput(savedSettings.towerDeathDelay) or DEFAULT_SETTINGS.towerDeathDelay, 0, 300)
sharedEnv.ChickenTowerTiming = {
    runDuration = math.clamp(
        parseNumberInput(savedSettings.towerRunDuration) or DEFAULT_SETTINGS.towerRunDuration,
        0,
        300
    ),
    nextRunDelay = math.clamp(
        parseNumberInput(savedSettings.towerNextRunDelay) or DEFAULT_SETTINGS.towerNextRunDelay,
        0,
        300
    ),
}
sharedEnv.ChickenUiWindowScaleWidthPercent = sharedEnv.ChickenParsePercentInput(
    savedSettings.uiWindowWidthPercent
)
sharedEnv.ChickenUiWindowScaleHeightPercent = sharedEnv.ChickenParsePercentInput(
    savedSettings.uiWindowHeightPercent
)

-- Optional game-window sizing.  This is deliberately event-driven: it edits
-- only the game's existing frames and never creates a second UI or a render
-- loop.  The original Size values are retained so 0/blank restores them.
sharedEnv.ChickenUiWindowScale = (function()
    local baselines = type(sharedEnv.ChickenUiWindowScaleBaselines) == "table"
        and sharedEnv.ChickenUiWindowScaleBaselines or {}
    sharedEnv.ChickenUiWindowScaleBaselines = baselines
    local token = (tonumber(sharedEnv.ChickenUiWindowScaleToken) or 0) + 1
    sharedEnv.ChickenUiWindowScaleToken = token
    sharedEnv.ChickenUiWindowScaleConnections = {}
    local watchedScreens = {}
    local watchedRoots = {}
    local pending = false
    local api = {}

    local function connect(signal, callback)
        local connection = signal:Connect(callback)
        table.insert(sharedEnv.ChickenUiWindowScaleConnections, connection)
    end

    local function isWindowCandidate(object)
        if not object:IsA("GuiObject") then
            return false
        end
        local screenGui = object:FindFirstAncestorWhichIsA("ScreenGui")
        if not screenGui then
            return false
        end
        local size = object.Size
        local position = object.Position
        local anchor = object.AnchorPoint
        if size.X.Scale < 0.08 and size.Y.Scale < 0.08
            and math.abs(size.X.Offset) < 120 and math.abs(size.Y.Offset) < 80 then
            return false
        end
        if size.X.Scale >= 0.98 and size.Y.Scale >= 0.98 then
            return false
        end
        local centerX = anchor.X >= 0.44 and anchor.X <= 0.56
            and position.X.Scale >= 0.40 and position.X.Scale <= 0.60
        if not centerX then
            return false
        end
        local name = string.lower(object.Name)
        local namedWindow = name == "panel"
            or name == "window"
            or name:find("popup", 1, true) ~= nil
            or name:find("gifting", 1, true) ~= nil
            or name:find("milestone", 1, true) ~= nil
            or name:find("picker", 1, true) ~= nil
            or name:find("promoted", 1, true) ~= nil
        local directChild = object.Parent and object.Parent:IsA("ScreenGui")
        if not directChild and not namedWindow then
            return false
        end
        local centerY = anchor.Y >= 0.35 and anchor.Y <= 0.65
            and position.Y.Scale >= 0.25 and position.Y.Scale <= 0.75
        if not namedWindow and not centerY then
            return false
        end
        if not namedWindow
            and size.X.Scale < 0.12 and size.Y.Scale < 0.12 then
            return false
        end
        return true
    end

    local function objectDepth(object)
        local depth = 0
        local parent = object.Parent
        while parent do
            depth += 1
            parent = parent.Parent
        end
        return depth
    end

    local function discoverRoots(playerGui)
        local roots = {}
        for root in pairs(watchedRoots) do
            if root.Parent and root:IsDescendantOf(playerGui) then
                table.insert(roots, root)
            end
        end
        for root in pairs(baselines) do
            if root.Parent and root:IsDescendantOf(playerGui) then
                local known = false
                for _, existing in ipairs(roots) do
                    if existing == root then
                        known = true
                        break
                    end
                end
                if not known then
                    table.insert(roots, root)
                end
            end
        end
        local candidates = {}
        for _, screenGui in ipairs(playerGui:GetChildren()) do
            if screenGui:IsA("ScreenGui") then
                for _, object in ipairs(screenGui:GetDescendants()) do
                    if isWindowCandidate(object) then
                        table.insert(candidates, object)
                    end
                end
            end
        end
        table.sort(candidates, function(a, b)
            return objectDepth(a) < objectDepth(b)
        end)
        for _, object in ipairs(candidates) do
            local nested = false
            for _, root in ipairs(roots) do
                if object:IsDescendantOf(root) then
                    nested = true
                    break
                end
            end
            if not nested then
                table.insert(roots, object)
            end
        end
        return roots
    end

    local function apply()
        if sharedEnv.ChickenUiWindowScaleToken ~= token then
            return
        end
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChild("PlayerGui")
        if not playerGui then
            return
        end
        local roots = discoverRoots(playerGui)
        local activeRoots = {}
        for _, root in ipairs(roots) do
            activeRoots[root] = true
        end
        for root in pairs(baselines) do
            if root.Parent and root:IsDescendantOf(playerGui) and not activeRoots[root] then
                baselines[root] = nil
            end
        end
        for _, root in ipairs(roots) do
            if not watchedRoots[root] then
                watchedRoots[root] = true
                connect(root:GetPropertyChangedSignal("Visible"), function()
                    api.queue()
                end)
                connect(root:GetPropertyChangedSignal("Size"), function()
                    api.queue()
                end)
            end
            local size = root.Size
            local baseline = baselines[root]
            if not baseline then
                baseline = {
                    xScale = size.X.Scale,
                    xOffset = size.X.Offset,
                    yScale = size.Y.Scale,
                    yOffset = size.Y.Offset,
                }
                baselines[root] = baseline
            end
            local widthEnabled = sharedEnv.ChickenUiWindowScaleWidthPercent > 0
            local heightEnabled = sharedEnv.ChickenUiWindowScaleHeightPercent > 0
            local xScale = widthEnabled
                and sharedEnv.ChickenUiWindowScaleWidthPercent / 100 or baseline.xScale
            local yScale = heightEnabled
                and sharedEnv.ChickenUiWindowScaleHeightPercent / 100 or baseline.yScale
            local xOffset = widthEnabled and baseline.xScale == 0
                and 0 or baseline.xOffset
            local yOffset = heightEnabled and baseline.yScale == 0
                and 0 or baseline.yOffset
            if math.abs(size.X.Scale - xScale) > 0.001
                or math.abs(size.X.Offset - xOffset) > 0.5
                or math.abs(size.Y.Scale - yScale) > 0.001
                or math.abs(size.Y.Offset - yOffset) > 0.5 then
                root.Size = UDim2.new(xScale, xOffset, yScale, yOffset)
            end
        end
    end

    function api.queue()
        if sharedEnv.ChickenUiWindowScaleToken ~= token or pending then
            return
        end
        pending = true
        task.delay(0.35, function()
            pending = false
            if sharedEnv.ChickenUiWindowScaleToken ~= token then
                return
            end
            apply()
        end)
    end

    local function watchScreen(screenGui)
        if not screenGui or not screenGui:IsA("ScreenGui")
            or watchedScreens[screenGui] then
            return
        end
        watchedScreens[screenGui] = true
        connect(screenGui:GetPropertyChangedSignal("Enabled"), api.queue)
        connect(screenGui.ChildAdded, api.queue)
    end

    function api.start()
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChild("PlayerGui")
        if not playerGui then
            return
        end
        for _, child in ipairs(playerGui:GetChildren()) do
            watchScreen(child)
        end
        connect(playerGui.ChildAdded, function(child)
            if sharedEnv.ChickenUiWindowScaleToken ~= token then
                return
            end
            watchScreen(child)
            api.queue()
        end)
        apply()
        api.queue()
    end

    function api.apply()
        apply()
    end

    return api
end)()

local autoIncubator = savedBool("autoIncubator", DEFAULT_SETTINGS.autoIncubator)
sharedEnv.ChickenHatchingState = {
    enabled = savedBool("autoHatching", DEFAULT_SETTINGS.autoHatching),
    selectedEggs = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.hatchingEggs),
    autoSell = savedBool("autoHatchSell", DEFAULT_SETTINGS.autoHatchSell),
    sellRarityExceptions = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.hatchingSellRarityExceptions),
    sellChickenExceptions = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.hatchingSellChickenExceptions),
    status = "DISABLED",
    busy = false,
    lastActionAt = 0,
    lastHatchedCount = 0,
    lastSoldCount = 0,
    lastEggId = nil,
    optionSignature = nil,
    reordering = false,
    pendingRefresh = false,
}
-- The interactive live events that accept the game's Chaos order.  The first
-- four are in GameConfig.worldEvents.order; Chicken Trade is a separately
-- surfaced pit event and is included when the server publishes its EventId.
-- Labels are only for the UI and saved settings continue to use stable ids.
-- Keep all helper data in one shared table so this script stays under Luau's
-- local-register limit at the top level.
sharedEnv.ChickenAutoChaos = {
    defs = {
        {id = "ufo", label = "UFO Invasion"},
        {id = "goldenGoose", label = "Golden Goose"},
        {id = "hotEgg", label = "Hot Egg"},
        {id = "chickenBoss", label = "Chicken Boss"},
        {id = "tradeMachine", label = "Chicken Trade"},
    },
    ids = {},
    selected = {},
}
for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
    sharedEnv.ChickenAutoChaos.ids[eventDef.id] = true
end
-- Webhook choices use the same canonical event ids as Auto Chaos, but are
-- independent from the Auto Chaos selection.  This lets notifications work
-- even when no event is selected for Chaos automation.
sharedEnv.ChickenWebhookEventOptions = {}
sharedEnv.ChickenWebhookEventOptionToId = {}
sharedEnv.ChickenWebhookEventIdToOption = {}
for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
    table.insert(sharedEnv.ChickenWebhookEventOptions, eventDef.label)
    sharedEnv.ChickenWebhookEventOptionToId[eventDef.label] = eventDef.id
    sharedEnv.ChickenWebhookEventIdToOption[eventDef.id] = eventDef.label
end
-- Public Roblox CDN thumbnail URLs used by Discord embeds.  These correspond
-- to the game's ReplicatedStorage.Content.Icons assets and are directly
-- fetchable by Discord (unlike rbxassetid:// URLs).
sharedEnv.ChickenWebhookEventIconUrls = {
    ufo = "https://tr.rbxcdn.com/180DAY-f27c4e404663297b202181f0099d899a/420/420/Image/Png/noFilter",
    goldenGoose = "https://tr.rbxcdn.com/180DAY-83b276bb3a96c12388c1e4bc5c8538f2/420/420/Image/Png/noFilter",
    hotEgg = "https://tr.rbxcdn.com/180DAY-28da15f4108955ded18654a374b04c8c/420/420/Image/Png/noFilter",
    chickenBoss = "https://tr.rbxcdn.com/180DAY-2ffde40bc31433d27d28bd164cf00ee8/420/420/Image/Png/noFilter",
    tradeMachine = "https://tr.rbxcdn.com/180DAY-21bba1f3deb9ce0eb125515e6a77c533/420/420/Image/Png/noFilter",
}
-- Discord fields cannot render a different thumbnail per field, so use the
-- same recognizable event icons the game uses as compact emoji prefixes.
sharedEnv.ChickenWebhookEventEmojis = {
    goldenGoose = "🪿",
    hotEgg = "🥚",
    ufo = "🛸",
    chickenBoss = "🐔",
    tradeMachine = "🔄",
}
sharedEnv.ChickenWebhookEventIconUrl = function(eventId)
    return sharedEnv.ChickenWebhookEventIconUrls[tostring(eventId or "")]
end
if type(savedSettings.autoChaosEvents) == "table" then
    for key, value in pairs(savedSettings.autoChaosEvents) do
        local savedEventId = type(key) == "number" and value or (value == true and key or nil)
        if type(savedEventId) == "string" then
            -- JSON/config writers may normalize keys to lower case. Resolve
            -- against the canonical id so camelCase events survive reload.
            local lowered = string.lower(savedEventId)
            for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
                if string.lower(eventDef.id) == lowered then
                    sharedEnv.ChickenAutoChaos.selected[eventDef.id] = true
                    break
                end
            end
        end
    end
else
    -- Pre-event-list settings used Auto UFO, so preserve that behavior on the
    -- first load while still allowing the user to clear the selection.
    sharedEnv.ChickenAutoChaos.selected.ufo = true
end

sharedEnv.ChickenUfuState = {
    enabled = savedBool("autoUfu", DEFAULT_SETTINGS.autoUfu),
    events = sharedEnv.ChickenAutoChaos.selected,
    -- Keep the old single-chicken key only as a migration fallback. UFO uses
    -- the multi-select list; normal events use the active chicken.
    useAllEventChicken = savedBool(
        "autoChaosUseAllEventChicken",
        savedBool("autoChaosUsePickedChicken", DEFAULT_SETTINGS.autoChaosUseAllEventChicken)
    ),
    useUfoChicken = savedBool(
        "autoChaosUseUfoChicken",
        savedBool("autoChaosUsePickedChicken", DEFAULT_SETTINGS.autoChaosUseUfoChicken)
    ),
    pickedChickenId = type(savedSettings.autoChaosChickenId) == "string"
        and savedSettings.autoChaosChickenId or nil,
    pickedChickenIds = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.autoChaosChickenIds),
    targetRarity = type(savedSettings.autoChaosTargetRarity) == "string"
        and string.lower(savedSettings.autoChaosTargetRarity) or DEFAULT_SETTINGS.autoChaosTargetRarity,
    leaveWhenRarityEnabled = savedBool(
        "autoLeaveOnUfoRarity",
        DEFAULT_SETTINGS.autoLeaveOnUfoRarity
    ),
    leaveWhenRarity = type(savedSettings.leaveWhenUfoRarity) == "string"
        and string.lower(savedSettings.leaveWhenUfoRarity):gsub("^%s+", ""):gsub("%s+$", "")
        or DEFAULT_SETTINGS.leaveWhenUfoRarity,
    ufoLeaveSessionStarted = false,
    ufoLeaveTriggered = false,
    chickenOptionSignature = nil,
    chickenOptionsReady = false,
    chickenReordering = false,
    activeChickenId = nil,
    ufoIndex = 1,
    ufoActiveChickenId = nil,
    ufoTargetReached = false,
    ufoAdvancePending = false,
    ufoRotationComplete = false,
    originalActiveChickenId = nil,
    restoreActivePending = false,
    activeSwitchBusy = false,
    lastActiveSwitchAt = 0,
    currentEventId = nil,
    lastMutation = nil,
    lastMutationAt = 0,
    nextChickenRefreshAt = 0,
    status = "DISABLED",
    phase = "IDLE",
    cycles = 0,
    waitingReturn = false,
    orderIssued = false,
    deathPending = false,
    lastBodyLife = nil,
    lastActionAt = 0,
    eventEndsAt = 0,
    lastBodyState = nil,
    lastCarrying = 0,
    lastStatusBody = nil,
    ufoMutationCount = 0,
    ufoChaosRounds = 0,
    ufoEventStartedAt = 0,
    webhookRawLive = false,
    webhookRawLiveEventId = nil,
    webhookRawLiveDeadline = nil,
    webhookUfoEndKey = "",
}
-- Arena and UFO Chaos both control the same active chicken.  When Auto Chaos
-- has UFO selected, reserve the warmup/live window for the event so Arena
-- does not start a fresh match immediately before the beam arrives.  An
-- already-running Arena match is allowed to finish; the Arena controller
-- only stops issuing new Fight requests until the UFO window has ended.
sharedEnv.ChickenArenaEventPause = {
    active = false,
    reason = "",
    eventId = "",
    phase = "",
    changedAt = 0,
}
sharedEnv.ChickenArenaShouldPauseForUfo = function()
    local state = sharedEnv.ChickenArenaEventPause
    local ufuState = sharedEnv.ChickenUfuState
    local eventId = string.lower(tostring(workspace:GetAttribute("EventId") or ""))
    local phase = string.lower(tostring(workspace:GetAttribute("EventPhase") or ""))
    local selected = type(ufuState) == "table"
        and ufuState.enabled == true
        and type(ufuState.events) == "table"
        and ufuState.events.ufo == true
    local active = selected
        and eventId == "ufo"
        and (phase == "warmup" or phase == "live")
    local reason = active and (phase == "live" and "UFO LIVE" or "UFO WARMUP") or ""
    if state.active ~= active
        or state.reason ~= reason
        or state.eventId ~= eventId
        or state.phase ~= phase then
        state.active = active
        state.reason = reason
        state.eventId = eventId
        state.phase = phase
        state.changedAt = os.clock()
    end
    return active, reason
end
-- Auto Tower to Rebirth and Auto Chaos/UFO both need the player's active
-- chicken.  Pause Tower only while the selected UFO event is in WARMUP or
-- LIVE, so WAITING does not block normal Tower runs.  This is intentionally
-- separate from the Arena warmup/live pause above because Arena and Tower
-- have different ownership rules for the active chicken.
sharedEnv.ChickenTowerShouldPauseForUfo = function()
    local ufuState = sharedEnv.ChickenUfuState
    local selected = type(ufuState) == "table"
        and ufuState.enabled == true
        and type(ufuState.events) == "table"
        and ufuState.events.ufo == true
    local eventId = string.lower(tostring(workspace:GetAttribute("EventId") or ""))
    local phase = string.lower(tostring(workspace:GetAttribute("EventPhase") or ""))
    local active = selected
        and eventId == "ufo"
        and (phase == "warmup" or phase == "live")
    local reason = active
        and (phase == "live" and "UFO LIVE" or "UFO WARMUP")
        or ""
    return active, reason
end
-- Webhook state is kept separate from Auto Chaos: notifications must work
-- even when Auto Chaos is disabled or the event is not selected for Chaos.
sharedEnv.ChickenWebhookState = {
    enabled = savedBool("discordWebhookEnabled", DEFAULT_SETTINGS.discordWebhookEnabled),
    url = type(savedSettings.discordWebhookUrl) == "string"
        and savedSettings.discordWebhookUrl or DEFAULT_SETTINGS.discordWebhookUrl,
    events = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.discordWebhookEvents),
    upcomingEnabled = savedBool(
        "discordUpcomingEventsEnabled",
        DEFAULT_SETTINGS.discordUpcomingEventsEnabled
    ),
    upcomingUrl = type(savedSettings.discordUpcomingEventsUrl) == "string"
        and savedSettings.discordUpcomingEventsUrl
        or (savedBool("discordUpcomingEventsEnabled", false)
            and type(savedSettings.discordWebhookUrl) == "string"
            and savedSettings.discordWebhookUrl or ""),
    upcomingMessageId = type(savedSettings.discordUpcomingEventsMessageId) == "string"
        and savedSettings.discordUpcomingEventsMessageId
        or (type(sharedEnv.ChickenWebhookState) == "table"
            and tostring(sharedEnv.ChickenWebhookState.upcomingMessageId or "") or ""),
    upcomingPending = false,
    upcomingDirty = false,
    upcomingLastUpdateAt = 0,
    lastAttemptKey = type(sharedEnv.ChickenWebhookState) == "table"
        and sharedEnv.ChickenWebhookState.lastAttemptKey or "",
    lastAttemptAt = type(sharedEnv.ChickenWebhookState) == "table"
        and tonumber(sharedEnv.ChickenWebhookState.lastAttemptAt) or 0,
    lastStatus = "IDLE",
    lastError = "",
}
-- Invalidate any countdown-edit workers left by a previous live reload.
sharedEnv.ChickenWebhookCountdownGeneration =
    (tonumber(sharedEnv.ChickenWebhookCountdownGeneration) or 0) + 1
-- UFO mutation results are aggregated into one Discord message per event
-- window.  Keep only the message id and accumulated reports across reloads so
-- later results can PATCH the same message instead of creating a new one.
sharedEnv.ChickenWebhookUfoRoundState = type(sharedEnv.ChickenWebhookUfoRoundState) == "table"
    and sharedEnv.ChickenWebhookUfoRoundState or {}
if type(sharedEnv.ChickenWebhookUfoRoundState.results) ~= "table" then
    sharedEnv.ChickenWebhookUfoRoundState.results = {}
end
if type(sharedEnv.ChickenWebhookUfoRoundState.seen) ~= "table" then
    sharedEnv.ChickenWebhookUfoRoundState.seen = {}
end
-- A live-reload invalidates an in-flight worker from the previous chunk.  The
-- worker checks the generation before touching this state, so it is safe to
-- clear these transient flags while retaining the Discord message id.
sharedEnv.ChickenWebhookUfoRoundState.pending = false
sharedEnv.ChickenWebhookUfoRoundState.dirty = false
sharedEnv.ChickenWebhookUfoRoundState.generation = sharedEnv.ChickenWebhookCountdownGeneration
sharedEnv.ChickenWebhookSelectedOptions = function()
    local output = {}
    local state = sharedEnv.ChickenWebhookState
    for _, option in ipairs(sharedEnv.ChickenWebhookEventOptions or {}) do
        local eventId = sharedEnv.ChickenWebhookEventOptionToId[option]
        if state and state.events and eventId and state.events[eventId] == true then
            table.insert(output, option)
        end
    end
    return output
end
sharedEnv.ChickenWebhookFormatRemaining = function(target)
    local remaining = math.max(0, math.floor((tonumber(target) or 0)
        - workspace:GetServerTimeNow() + 0.5))
    local minutes = math.floor(remaining / 60)
    local seconds = remaining % 60
    return string.format("%d:%02d (%ds)", minutes, seconds, remaining)
end
sharedEnv.ChickenWebhookFormatNextUfo = function(target)
    local timestamp = math.floor(tonumber(target) or 0)
    return "<t:" .. tostring(timestamp) .. ":R>"
end
sharedEnv.ChickenWebhookFormatUpcomingCountdown = function(target)
    -- Match Event Alert's Discord-rendered relative timestamp format, such as
    -- "in 1 minute" or "3 hours ago", instead of a frozen client countdown.
    local timestamp = math.floor(tonumber(target) or 0)
    return "<t:" .. tostring(timestamp) .. ":R>"
end
-- Return the next scheduled occurrence of every rotating world event.  The
-- game publishes only the current EventId/Phase/Deadline; the shared cycle
-- and order in GameConfig are the authoritative schedule for the others.
sharedEnv.ChickenWebhookBuildUpcomingEvents = function()
    local configOk, config = pcall(function()
        local contentFolder = ReplicatedStorage:FindFirstChild("Content")
        local configModule = contentFolder and contentFolder:FindFirstChild("GameConfig")
        if not configModule then
            return nil
        end
        return require(configModule)
    end)
    local worldEvents = configOk and type(config) == "table" and config.worldEvents or nil
    if type(worldEvents) ~= "table" then
        return {key = "unavailable", events = {}, error = "GameConfig.worldEvents unavailable"}
    end
    local cycle = tonumber(worldEvents.cycle) or 600
    local warmup = tonumber(worldEvents.warmup) or 60
    local live = tonumber(worldEvents.live) or 180
    local order = worldEvents.order
    if type(order) ~= "table" or #order == 0 then
        order = {"goldenGoose", "hotEgg", "ufo", "chickenBoss"}
    end
    local now = workspace:GetServerTimeNow()
    local currentId = tostring(workspace:GetAttribute("EventId") or "")
    local currentLower = string.lower(currentId)
    local currentPhase = string.lower(tostring(workspace:GetAttribute("EventPhase") or "idle"))
    local deadline = tonumber(workspace:GetAttribute("EventDeadline"))
    local currentIndex
    for index, value in ipairs(order) do
        if string.lower(tostring(value)) == currentLower then
            currentIndex = index
            currentId = tostring(value)
            break
        end
    end
    local events = {}
    if currentIndex and deadline then
        local slotStart = deadline
        if currentPhase == "warmup" then
            slotStart = deadline - warmup
        elseif currentPhase == "live" then
            slotStart = deadline - warmup - live
        end
        local count = #order
        for index, value in ipairs(order) do
            local eventId = tostring(value)
            local offset = (index - currentIndex) % count
            local target = slotStart + offset * cycle
            local targetKind = "WARMUP"
            if currentPhase == "warmup" and index == currentIndex then
                target = deadline
                targetKind = "LIVE"
            elseif currentPhase == "live" and offset == 0 then
                -- The current live slot's next occurrence is one full cycle
                -- away, not the slot that is already in progress.
                target = slotStart + count * cycle
            end
            while target <= now do
                target += count * cycle
            end
            table.insert(events, {
                id = eventId,
                target = target,
                kind = targetKind,
            })
        end
    else
        -- Keep the feature useful during a short attribute replication gap;
        -- once the server publishes its event state the exact schedule above
        -- takes over automatically.
        local anchor = math.floor(now / cycle + 1) * cycle
        for index, value in ipairs(order) do
            local target = anchor + (index - 1) * cycle
            while target <= now do
                target += #order * cycle
            end
            table.insert(events, {
                id = tostring(value),
                target = target,
                kind = "WARMUP",
            })
        end
    end
    table.sort(events, function(left, right)
        if tonumber(left.target) == tonumber(right.target) then
            return tostring(left.id) < tostring(right.id)
        end
        return (tonumber(left.target) or 0) < (tonumber(right.target) or 0)
    end)
    local eventDefs = type(worldEvents.defs) == "table" and worldEvents.defs or {}
    local labelById = sharedEnv.ChickenWebhookEventIdToOption or {}
    local emojiById = sharedEnv.ChickenWebhookEventEmojis or {}
    for _, item in ipairs(events) do
        local eventId = tostring(item.id or "")
        local configDef = eventDefs[eventId]
        item.label = labelById[eventId]
            or (type(configDef) == "table" and type(configDef.name) == "string"
                and configDef.name)
            or eventId
        item.emoji = emojiById[eventId] or "📅"
    end
    local keyParts = {}
    for _, item in ipairs(events) do
        table.insert(keyParts, item.id .. "=" .. tostring(math.floor(item.target)))
    end
    return {
        key = table.concat(keyParts, "|"),
        events = events,
        currentId = currentId,
        currentPhase = currentPhase,
    }
end
sharedEnv.ChickenWebhookBuildUpcomingEmbed = function(snapshot)
    snapshot = type(snapshot) == "table" and snapshot or {}
    local eventLines = {}
    for _, item in ipairs(snapshot.events or {}) do
        local eventId = tostring(item.id or "")
        local label = tostring(item.label or eventId)
        local emoji = tostring(item.emoji or "📅")
        local countdown = sharedEnv.ChickenWebhookFormatUpcomingCountdown(item.target)
        local fieldName = eventId == "ufo"
            and (emoji .. " UFO")
            or (emoji .. " " .. label)
        table.insert(eventLines, "**" .. fieldName .. "** " .. countdown)
    end
    if #eventLines == 0 then
        table.insert(eventLines, tostring(snapshot.error or "Schedule is not available yet."))
    end
    return {
        title = "📅 Upcoming Events",
        description = "All scheduled events. Countdown is refreshed in this same message.\n\n"
            .. table.concat(eventLines, "\n"),
        color = 16766720,
        fields = {},
        footer = {text = "gertitq • " .. SCRIPT_VERSION},
    }
end
sharedEnv.ChickenWebhookSendEvent = function(eventId, deadline, isTest, details)
    local state = sharedEnv.ChickenWebhookState
    if type(state) ~= "table" or state.enabled ~= true then
        return false
    end
    eventId = tostring(eventId or "")
    if eventId == "" or state.events[eventId] ~= true then
        return false
    end
    local detail = type(details) == "table" and details or {}
    local url = tostring(state.url or "")
    if not url:match("^https?://") then
        state.lastStatus = "INVALID WEBHOOK URL"
        state.lastError = "URL must start with http:// or https://"
        return false
    end
    local detailKey = tostring(detail.key or deadline or "")
    local eventKey = (isTest and "test|" or "") .. eventId .. "|" .. detailKey
    local now = os.clock()
    if state.lastAttemptKey == eventKey
        and now - (tonumber(state.lastAttemptAt) or 0) < 15 then
        return false
    end
    state.lastAttemptKey = eventKey
    state.lastAttemptAt = now
    local label = eventId
    for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs or {}) do
        if eventDef.id == eventId then
            label = eventDef.label
            break
        end
    end
    local deadlineValue = tonumber(deadline) or 0
    local remaining = deadline and math.max(0, deadlineValue - workspace:GetServerTimeNow()) or nil
    local timeLeftText = detail.timeLeftText or (deadline
        and ("<t:" .. tostring(math.floor(deadlineValue)) .. ":R>")
        or "unknown")
    local playerName = Players.LocalPlayer and Players.LocalPlayer.Name or "Player"
    local fields = {
        {name = "Event", value = tostring(label), inline = true},
        {name = "Player", value = tostring(playerName), inline = true},
        {name = "Time left", value = timeLeftText, inline = true},
    }
    if type(detail.fields) == "table" then
        for _, field in ipairs(detail.fields) do
            if type(field) == "table" and field.name and field.value then
                table.insert(fields, {
                    name = tostring(field.name),
                    value = tostring(field.value),
                    inline = field.inline == true,
                })
            end
        end
    end
    local embed = {
        title = detail.title or ((isTest and "🧪 " or "🔔 ") .. tostring(label)
            .. (isTest and " WEBHOOK TEST" or " LIVE")),
        description = detail.description or (isTest
            and "This is a test notification from gertitq."
            or "A selected game event is now live."),
        color = tonumber(detail.color) or 5763719,
        fields = fields,
        footer = {text = "gertitq • " .. SCRIPT_VERSION},
    }
    local iconUrl = sharedEnv.ChickenWebhookEventIconUrl(eventId)
    if iconUrl then
        embed.thumbnail = {url = iconUrl}
    end
    local payload = {
        username = "gertitq",
        allowed_mentions = {parse = {}},
        embeds = {embed},
    }
    local body = HttpService:JSONEncode(payload)
    state.lastStatus = "SENDING " .. string.upper(tostring(label))
    task.spawn(function()
        local requestFn
        pcall(function()
            if type(request) == "function" then
                requestFn = request
            end
        end)
        if not requestFn then
            pcall(function()
                if type(http_request) == "function" then
                    requestFn = http_request
                end
            end)
        end
        if not requestFn then
            pcall(function()
                if type(http) == "table" and type(http.request) == "function" then
                    requestFn = http.request
                end
            end)
        end
        if not requestFn then
            state.lastStatus = "WEBHOOK ERROR"
            state.lastError = "HTTP request is unavailable in this executor"
            return
        end
        -- `wait=true` asks Discord to return the created message id.  The id
        -- is needed only for the optional Next UFO countdown refresh below.
        local postUrl = url
        if not postUrl:find("wait=", 1, true) then
            postUrl = postUrl .. (postUrl:find("?", 1, true) and "&wait=true" or "?wait=true")
        end
        local ok, response = pcall(requestFn, {
            Url = postUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body,
        })
        if not ok then
            state.lastStatus = "WEBHOOK ERROR"
            state.lastError = "HTTP request failed"
            return
        end
        local statusCode = type(response) == "table"
            and tonumber(response.StatusCode or response.status_code or response.Status) or nil
        local success = type(response) ~= "table"
            or response.Success == true
            or (statusCode and statusCode >= 200 and statusCode < 300)
        if success then
            state.lastStatus = "SENT " .. string.upper(tostring(label))
            state.lastError = ""
            local countdownTarget = tonumber(detail.countdownTarget)
            if countdownTarget and countdownTarget > workspace:GetServerTimeNow()
                and type(response) == "table" then
                local messageId = tostring(response.id or response.messageId or "")
                local responseBody = response.Body or response.body
                if messageId == "" and type(responseBody) == "string" and responseBody ~= "" then
                    local decodedOk, decoded = pcall(function()
                        return HttpService:JSONDecode(responseBody)
                    end)
                    if decodedOk and type(decoded) == "table" then
                        messageId = tostring(decoded.id or decoded.messageId or "")
                    end
                elseif messageId == "" and type(responseBody) == "table" then
                    messageId = tostring(responseBody.id or responseBody.messageId or "")
                end
                if messageId ~= "" then
                    local countdownGeneration = tonumber(sharedEnv.ChickenWebhookCountdownGeneration) or 0
                    task.spawn(function()
                        local function pushCountdown()
                            if sharedEnv.ChickenWebhookCountdownGeneration ~= countdownGeneration then
                                return false
                            end
                            local nextValue = sharedEnv.ChickenWebhookFormatNextUfo(countdownTarget)
                            local found = false
                            for _, field in ipairs(embed.fields or {}) do
                                if type(field) == "table" and field.name == "Next UFO" then
                                    field.value = nextValue
                                    found = true
                                    break
                                end
                            end
                            if not found then
                                return false
                            end
                            local editUrl = url:gsub("/+$", "") .. "/messages/" .. messageId
                            local editBody = HttpService:JSONEncode({embeds = {embed}})
                            pcall(requestFn, {
                                Url = editUrl,
                                Method = "PATCH",
                                Headers = { ["Content-Type"] = "application/json" },
                                Body = editBody,
                            })
                            return true
                        end

                        -- Refresh every five seconds: enough to expose a
                        -- moving seconds value without hammering Discord's
                        -- webhook rate limit.
                        while sharedEnv.ChickenWebhookCountdownGeneration == countdownGeneration
                            and workspace:GetServerTimeNow() < countdownTarget do
                            task.wait(5)
                            if not pushCountdown() then
                                return
                            end
                        end
                        if sharedEnv.ChickenWebhookCountdownGeneration == countdownGeneration then
                            pushCountdown()
                        end
                    end)
                end
            end
        else
            state.lastStatus = "WEBHOOK ERROR"
            state.lastError = statusCode and ("HTTP " .. tostring(statusCode)) or "HTTP request rejected"
        end
    end)
    return true
end
sharedEnv.ChickenWebhookTableCount = function(value)
    if type(value) == "number" then
        return math.max(0, math.floor(value))
    end
    if type(value) ~= "table" then
        return 0
    end
    local count = 0
    for _ in pairs(value) do
        count += 1
    end
    return count
end
sharedEnv.ChickenWebhookFormatMap = function(value)
    if type(value) ~= "table" then
        return tostring(value or "None")
    end
    local geneLabels = {
        vigor = "HP",
        furia = "ATK",
        velocidad = "SPD",
        impetu = "PWR",
        fertility = "EGG",
    }
    local parts = {}
    for key, item in pairs(value) do
        local rawKey = string.lower(tostring(key))
        local displayKey = geneLabels[rawKey] or tostring(key)
        local line
        if type(item) == "table" then
            local before = item.before or item.old or item.from
            local after = item.after or item.new or item.to or item.value
            if before ~= nil and after ~= nil then
                line = displayKey .. ": " .. tostring(before) .. " → " .. tostring(after)
            elseif after ~= nil then
                line = displayKey .. ": " .. tostring(after)
            else
                line = displayKey
            end
        else
            line = displayKey .. ": " .. tostring(item)
        end
        table.insert(parts, line)
    end
    table.sort(parts)
    return #parts > 0 and table.concat(parts, "\n") or "None"
end
-- Format the five genome stats as one compact list.  ChickenMutated sends
-- changes as an array ({gene, from, to}), while the owned roster stores the
-- current genome as a keyed table; merge both so unchanged stats are still
-- shown and every value includes the rarity cap.
sharedEnv.ChickenWebhookFormatGenomeStats = function(payload, chickenId, rarity)
    payload = type(payload) == "table" and payload or {}
    local labelsByGene = {
        vigor = "HP",
        hp = "HP",
        health = "HP",
        furia = "ATK",
        atk = "ATK",
        attack = "ATK",
        velocidad = "SPD",
        spd = "SPD",
        speed = "SPD",
        impetu = "PWR",
        pwr = "PWR",
        power = "PWR",
        fertility = "EGG",
        egg = "EGG",
    }
    local orderedGenes = {"ATK", "EGG", "HP", "PWR", "SPD"}
    local function geneLabel(value)
        local key = string.lower(tostring(value or ""))
        return labelsByGene[key] or string.upper(tostring(value or ""))
    end
    local function numberText(value)
        local number = tonumber(value)
        if number == nil then
            return tostring(value or "?")
        end
        if math.floor(number) == number then
            return tostring(math.floor(number))
        end
        return string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "")
    end
    local function itemValue(item, afterOnly)
        if type(item) ~= "table" then
            return item
        end
        if afterOnly then
            return item.after or item.new or item.to or item.value or item.current
        end
        return item.value or item.current or item.after or item.new or item.to
    end
    local function extractGenome(value)
        local output = {}
        if type(value) ~= "table" then
            return output
        end
        if #value > 0 then
            for index, item in ipairs(value) do
                local code = orderedGenes[index]
                if type(item) == "table" and item.gene then
                    code = geneLabel(item.gene)
                end
                if code and labelsByGene[string.lower(code)] then
                    code = geneLabel(code)
                end
                local number = tonumber(itemValue(item, true))
                if code and number ~= nil then
                    output[code] = number
                end
            end
            return output
        end
        for key, item in pairs(value) do
            local code = labelsByGene[string.lower(tostring(key))]
            if not code and type(item) == "table" then
                code = labelsByGene[string.lower(tostring(item.gene or item.stat or item.name or ""))]
            end
            local number = tonumber(itemValue(item, true))
            if code and number ~= nil then
                output[code] = number
            end
        end
        return output
    end
    local beforeValues = {}
    local afterValues = {}
    local function recordChange(code, item)
        if not code or type(item) ~= "table" then
            return
        end
        local before = tonumber(item.from or item.before or item.old)
        local after = tonumber(item.to or item.after or item.new or item.value)
        if before ~= nil then
            beforeValues[code] = before
        end
        if after ~= nil then
            afterValues[code] = after
        end
    end
    local changes = payload.changes
    if type(changes) == "table" then
        if #changes > 0 then
            for _, item in ipairs(changes) do
                if type(item) == "table" then
                    local code = labelsByGene[string.lower(tostring(
                        item.gene or item.stat or item.name or ""
                    ))]
                    recordChange(code, item)
                end
            end
        else
            for key, item in pairs(changes) do
                local code = labelsByGene[string.lower(tostring(key))]
                if not code and type(item) == "table" then
                    code = labelsByGene[string.lower(tostring(
                        item.gene or item.stat or item.name or ""
                    ))]
                end
                recordChange(code, item)
            end
        end
    end
    local finalValues = extractGenome(payload.genome)
    local chaos = sharedEnv.ChickenAutoChaos
    local row = chaos and chaos.chickenById and chaos.chickenById[chickenId]
    local rosterChicken = row and row.chicken
    local rosterValues = extractGenome(rosterChicken and rosterChicken.genome)
    for code, number in pairs(rosterValues) do
        if finalValues[code] == nil then
            finalValues[code] = number
        end
    end
    for code, number in pairs(afterValues) do
        finalValues[code] = number
    end
    local cap
    pcall(function()
        if type(sharedEnv.ChickenGenomeCap) == "function" then
            cap = sharedEnv.ChickenGenomeCap(rarity)
        end
    end)
    cap = tonumber(cap) or 31
    local capText = numberText(cap)
    local lines = {}
    for _, code in ipairs(orderedGenes) do
        local after = afterValues[code]
        local current = finalValues[code]
        if after == nil then
            after = current
        end
        local before = beforeValues[code]
        local line
        if before ~= nil and after ~= nil and before ~= after then
            line = code .. " " .. numberText(before) .. " → "
                .. numberText(after) .. "/" .. capText
        else
            line = code .. " " .. numberText(after) .. "/" .. capText
        end
        table.insert(lines, line)
    end
    return #lines > 0 and table.concat(lines, "\n") or "None"
end
sharedEnv.ChickenWebhookRarityRank = function(value)
    local chaos = sharedEnv.ChickenAutoChaos
    if chaos and type(chaos.rarityRank) == "function" then
        local ok, rank = pcall(chaos.rarityRank, value)
        if ok then
            return tonumber(rank) or 0
        end
    end
    return 0
end
sharedEnv.ChickenWebhookChickenLabel = function(id)
    local chaos = sharedEnv.ChickenAutoChaos
    if chaos and type(chaos.chickenLabel) == "function" then
        local ok, label = pcall(chaos.chickenLabel, id)
        if ok and label then
            return tostring(label)
        end
    end
    return tostring(id or "Unknown chicken")
end
sharedEnv.ChickenWebhookSendUfoMutation = function(payload, roundNumber, deadline, isTest)
    if type(payload) ~= "table" then
        return false
    end
    local chickenId = type(payload.chickenId) == "string" and payload.chickenId or ""
    local chickenLabel = sharedEnv.ChickenWebhookChickenLabel(chickenId)
    local fromRarity = tostring(payload.fromRarity or payload.from or "")
    local toRarity = tostring(payload.rarity or payload.toRarity or "")
    local fromRank = sharedEnv.ChickenWebhookRarityRank(fromRarity)
    local toRank = sharedEnv.ChickenWebhookRarityRank(toRarity)
    local tierUp = payload.ascended == true
        or (fromRank > 0 and toRank > fromRank)
    local changeCount = sharedEnv.ChickenWebhookTableCount(payload.changes)
    local statIncreased = payload.statIncreased == true or changeCount > 0
    local resultStatus
    local resultIcon
    local resultColor
    if tierUp then
        resultStatus = "TIER UP SUCCESS"
        resultIcon = "⬆️"
        resultColor = 5763719
    elseif statIncreased then
        resultStatus = "STAT INCREASE SUCCESS"
        resultIcon = "🧬"
        resultColor = 3447003
    else
        resultStatus = "NO TIER UP / NO STAT INCREASE"
        resultIcon = "⚠️"
        resultColor = 15158332
    end
    local rarityLine
    if fromRarity ~= "" or toRarity ~= "" then
        rarityLine = (fromRarity ~= "" and fromRarity or "Unknown")
            .. " → " .. (toRarity ~= "" and toRarity or "Unknown")
    else
        rarityLine = "Unknown"
    end
    local rawChangesText = sharedEnv.ChickenWebhookFormatMap(payload.changes)
    local genomeText = sharedEnv.ChickenWebhookFormatGenomeStats(
        payload,
        chickenId,
        toRarity ~= "" and toRarity or fromRarity
    )
    local signature = table.concat({
        chickenId,
        fromRarity,
        toRarity,
        tostring(payload.ascended == true),
        rawChangesText,
    }, "|")
    return sharedEnv.ChickenWebhookUfoRoundUpdate(
        deadline,
        deadline,
        {
            signature = "mutation|" .. signature .. "|" .. tostring(roundNumber or ""),
            status = resultStatus,
            icon = resultIcon,
            color = resultColor,
            chicken = chickenLabel,
            rarity = rarityLine,
            changes = genomeText,
            genome = nil,
            round = roundNumber,
            beamGenes = payload.beamGenes,
            recyclerLevel = payload.recyclerLevel,
        },
        roundNumber,
        false,
        isTest
    )
end
sharedEnv.ChickenWebhookNextUfoTimes = function(eventId, phase, deadline)
    local configOk, config = pcall(function()
        local contentFolder = ReplicatedStorage:FindFirstChild("Content")
        local configModule = contentFolder and contentFolder:FindFirstChild("GameConfig")
        if not configModule then
            return nil
        end
        return require(configModule)
    end)
    if not configOk or type(config) ~= "table" then
        return nil
    end
    local worldEvents = config.worldEvents
    if type(worldEvents) ~= "table" then
        return nil
    end
    local cycle = tonumber(worldEvents.cycle) or 600
    local warmup = tonumber(worldEvents.warmup) or 60
    local live = tonumber(worldEvents.live) or 180
    local order = worldEvents.order
    if type(order) ~= "table" or #order == 0 then
        order = {"goldenGoose", "hotEgg", "ufo", "chickenBoss"}
    end
    local currentIndex = nil
    local ufoIndex = nil
    for index, id in ipairs(order) do
        if tostring(id) == tostring(eventId) then
            currentIndex = index
        end
        if tostring(id) == "ufo" then
            ufoIndex = index
        end
    end
    if not ufoIndex then
        return nil
    end
    local deadlineValue = tonumber(deadline)
    if not deadlineValue then
        return nil
    end
    local phaseText = string.lower(tostring(phase or "idle"))
    local slotStart
    if phaseText == "idle" then
        slotStart = deadlineValue
    elseif phaseText == "warmup" then
        slotStart = deadlineValue - warmup
    elseif phaseText == "live" then
        slotStart = deadlineValue - warmup - live
    else
        slotStart = deadlineValue
    end
    local slotCount = #order
    local offsetSlots = 1
    if currentIndex then
        offsetSlots = (ufoIndex - currentIndex) % slotCount
        if offsetSlots == 0 then
            offsetSlots = slotCount
        end
    end
    local nextWarmup = slotStart + offsetSlots * cycle
    return {
        warmup = nextWarmup,
        live = nextWarmup + warmup,
        slots = offsetSlots,
    }
end
-- Build the single message used for all mutation reports in one UFO window.
-- Each report is a field in this embed, so the three possible outcomes stay
-- together and the final round summary can update the same Discord message.
sharedEnv.ChickenWebhookBuildUfoRoundEmbed = function(roundState)
    roundState = type(roundState) == "table" and roundState or {}
    local results = type(roundState.results) == "table" and roundState.results or {}
    local function clipped(value, limit)
        local text = tostring(value or "None")
        limit = limit or 900
        if #text > limit then
            return string.sub(text, 1, limit - 3) .. "..."
        end
        return text
    end
    local playerName = Players.LocalPlayer and Players.LocalPlayer.Name or "Player"
    local deadlineValue = tonumber(roundState.deadline) or 0
    local timeLeft
    if deadlineValue > 0 then
        -- Keep the original event deadline so Discord renders a relative
        -- value such as "21 hours ago" after the round has ended.
        timeLeft = "<t:" .. tostring(math.floor(deadlineValue)) .. ":R>"
    elseif roundState.ended == true then
        timeLeft = "ENDED"
    else
        timeLeft = "LIVE"
    end
    local roundCount = math.max(0, math.floor(tonumber(roundState.rounds) or 0))
    local mutationCount = #results
    local missingCount = roundState.ended == true
        and math.max(0, roundCount - mutationCount) or 0
    local tierCount = 0
    local statCount = 0
    local noChangeCount = 0
    for _, result in ipairs(results) do
        local status = tostring(result.status or "")
        if status == "TIER UP SUCCESS" then
            tierCount += 1
        elseif status == "STAT INCREASE SUCCESS"
            or status == "STAT INCREASE SUCCESS (NO TIER UP)" then
            statCount += 1
        elseif status == "NO TIER UP / NO STAT INCREASE" then
            noChangeCount += 1
        end
    end
    -- Restore the round metadata so a finished message explains the event
    -- window before listing its individual mutation results.
    local fields = {
        {name = "Event", value = "UFO Invasion", inline = true},
        {name = "Player", value = tostring(playerName), inline = true},
        {name = "Time left", value = timeLeft, inline = true},
        {name = "Chaos rounds", value = tostring(roundCount), inline = true},
        {name = "Mutation reports", value = tostring(mutationCount), inline = true},
        {name = "Missing results", value = roundState.ended == true
            and tostring(missingCount) or "—", inline = true},
    }
    -- Keep enough room for the summary and Next UFO field under Discord's
    -- 25-field embed limit when a round produces many reports.
    local maxResultFields = 17
    for index, result in ipairs(results) do
        if index > maxResultFields then
            break
        end
        local status = tostring(result.status or "UNKNOWN")
        local displayStatus = status == "STAT INCREASE SUCCESS (NO TIER UP)"
            and "STAT INCREASE SUCCESS" or status
        -- A no-change result has no useful payload to read.  Keep only its
        -- status line instead of repeating a full chicken/genome snapshot.
        if status == "NO TIER UP / NO STAT INCREASE" then
            table.insert(fields, {
                name = "#" .. tostring(index) .. " " .. status,
                value = "Chicken: " .. clipped(result.chicken, 180),
                inline = false,
            })
        else
            local changeLines = {}
            local rawChanges = tostring(result.changes or "")
            if rawChanges ~= "" and rawChanges ~= "None" then
                for line in string.gmatch(rawChanges, "[^\n]+") do
                    table.insert(changeLines, tostring(#changeLines + 1) .. ": " .. line)
                end
            end
            local detailLines = {
                "Chicken: " .. clipped(result.chicken, 180),
                "Rarity: " .. clipped(result.rarity, 180),
                "Genome (stat)",
                #changeLines > 0 and table.concat(changeLines, "\n") or "None",
            }
            if result.beamGenes ~= nil then
                table.insert(detailLines, "Beam genes: " .. clipped(result.beamGenes, 180))
            end
            if result.recyclerLevel ~= nil then
                table.insert(detailLines, "Recycler level: " .. clipped(result.recyclerLevel, 180))
            end
            table.insert(fields, {
                name = "#" .. tostring(index) .. " " .. tostring(result.icon or "")
                    .. " " .. displayStatus,
                value = clipped(table.concat(detailLines, "\n"), 1000),
                inline = false,
            })
        end
    end
    -- Keep the compact result totals immediately above the next-event
    -- countdown so the final summary is easy to scan in Discord.
    table.insert(fields, {
        name = "Result summary", value = table.concat({
            "⬆️ TIER UP SUCCESS: " .. tostring(tierCount),
            "🧬 STAT INCREASE SUCCESS : " .. tostring(statCount),
            "⚠️ NO TIER UP: " .. tostring(noChangeCount),
        }, "\n"),
        inline = false,
    })
    if roundState.ended == true then
        local nextTimes = sharedEnv.ChickenWebhookNextUfoTimes(
            "ufo", "live", roundState.deadline
        )
        table.insert(fields, {
            name = "Next UFO",
            value = nextTimes
                and sharedEnv.ChickenWebhookFormatNextUfo(nextTimes.warmup)
                or "Unknown",
            inline = false,
        })
    end
    local title = (roundState.isTest == true and "🧪 " or "")
        .. (roundState.ended == true and "🏁 " or "🛸 ")
        .. "UFO Invasion • "
        .. (roundState.ended == true and "ROUND ENDED" or "LIVE")
    return {
        title = title,
        description = roundState.ended == true
            and "This message contains all Chaos results from this UFO round."
            or "A selected game event is now live. Chaos results are updated in this message.",
        color = roundState.ended == true and 10181046 or 5763719,
        fields = fields,
        footer = {text = "gertitq • " .. SCRIPT_VERSION},
        thumbnail = {url = sharedEnv.ChickenWebhookEventIconUrl("ufo")},
    }
end
-- Post the first update for a UFO round, then PATCH that same Discord message
-- for later mutations and for the final round summary.  If a result arrives
-- while a request is in flight, `dirty` coalesces it into one follow-up edit
-- instead of opening a second message or hammering the webhook.
sharedEnv.ChickenWebhookUfoRoundUpdate = function(roundKey, deadline, result, rounds, ended, isTest)
    local webhookState = sharedEnv.ChickenWebhookState
    if type(webhookState) ~= "table" or webhookState.enabled ~= true
        or type(webhookState.events) ~= "table"
        or webhookState.events.ufo ~= true then
        return false
    end
    local url = tostring(webhookState.url or "")
    if not url:match("^https?://") then
        webhookState.lastStatus = "INVALID WEBHOOK URL"
        webhookState.lastError = "URL must start with http:// or https://"
        return false
    end
    local numericKey = tonumber(roundKey or deadline)
    local stableKey = numericKey and tostring(math.floor(numericKey + 0.5))
        or tostring(roundKey or deadline or "unknown")
    local fullKey = (isTest == true and "test|" or "live|") .. stableKey
    local roundState = sharedEnv.ChickenWebhookUfoRoundState
    if type(roundState) ~= "table" then
        roundState = {}
        sharedEnv.ChickenWebhookUfoRoundState = roundState
    end
    if roundState.key ~= fullKey then
        roundState.key = fullKey
        roundState.messageId = ""
        roundState.results = {}
        roundState.seen = {}
        roundState.rounds = 0
        roundState.mutations = 0
        roundState.deadline = tonumber(deadline) or 0
        roundState.ended = false
        roundState.isTest = isTest == true
        roundState.pending = false
        roundState.dirty = false
    else
        roundState.deadline = tonumber(deadline) or roundState.deadline or 0
        roundState.isTest = isTest == true
    end
    local incomingRounds = tonumber(rounds)
    if incomingRounds then
        roundState.rounds = math.max(
            tonumber(roundState.rounds) or 0,
            math.floor(incomingRounds)
        )
    end
    if ended == true then
        roundState.ended = true
    end
    if type(result) == "table" then
        local resultKey = tostring(result.signature or result.key or table.concat({
            tostring(result.chicken or ""),
            tostring(result.status or ""),
            tostring(result.round or ""),
        }, "|"))
        if not roundState.seen[resultKey] then
            roundState.seen[resultKey] = true
            table.insert(roundState.results, result)
        end
    end
    roundState.mutations = #roundState.results
    if roundState.pending == true then
        roundState.dirty = true
        return true
    end
    local embed = sharedEnv.ChickenWebhookBuildUfoRoundEmbed(roundState)
    local body = HttpService:JSONEncode({
        username = "gertitq",
        allowed_mentions = {parse = {}},
        embeds = {embed},
    })
    local messageId = tostring(roundState.messageId or "")
    local method = messageId == "" and "POST" or "PATCH"
    local endpoint = url
    if method == "POST" and not endpoint:find("wait=", 1, true) then
        endpoint = endpoint .. (endpoint:find("?", 1, true) and "&wait=true" or "?wait=true")
    elseif method == "PATCH" then
        endpoint = endpoint:gsub("/+$", "") .. "/messages/" .. messageId
    end
    local generation = tonumber(sharedEnv.ChickenWebhookCountdownGeneration) or 0
    local requestKey = roundState.key
    roundState.pending = true
    roundState.dirty = false
    webhookState.lastStatus = "SENDING UFO INVASION"
    webhookState.lastError = ""
    task.spawn(function()
        local requestFn
        pcall(function()
            if type(request) == "function" then
                requestFn = request
            end
        end)
        if not requestFn then
            pcall(function()
                if type(http_request) == "function" then
                    requestFn = http_request
                end
            end)
        end
        if not requestFn then
            pcall(function()
                if type(http) == "table" and type(http.request) == "function" then
                    requestFn = http.request
                end
            end)
        end
        if not requestFn then
            if sharedEnv.ChickenWebhookCountdownGeneration == generation
                and sharedEnv.ChickenWebhookUfoRoundState.key == requestKey then
                roundState.pending = false
                webhookState.lastStatus = "WEBHOOK ERROR"
                webhookState.lastError = "HTTP request is unavailable in this executor"
            end
            return
        end
        local ok, response = pcall(requestFn, {
            Url = endpoint,
            Method = method,
            Headers = { ["Content-Type"] = "application/json" },
            Body = body,
        })
        if sharedEnv.ChickenWebhookCountdownGeneration ~= generation
            or sharedEnv.ChickenWebhookUfoRoundState.key ~= requestKey then
            return
        end
        local statusCode = type(response) == "table"
            and tonumber(response.StatusCode or response.status_code or response.Status) or nil
        local success = ok and (type(response) ~= "table"
            or response.Success == true
            or (statusCode and statusCode >= 200 and statusCode < 300))
        if success then
            if method == "POST" and type(response) == "table" then
                local newMessageId = tostring(response.id or response.messageId or "")
                local responseBody = response.Body or response.body
                if newMessageId == "" and type(responseBody) == "string" and responseBody ~= "" then
                    local decodedOk, decoded = pcall(function()
                        return HttpService:JSONDecode(responseBody)
                    end)
                    if decodedOk and type(decoded) == "table" then
                        newMessageId = tostring(decoded.id or decoded.messageId or "")
                    end
                elseif newMessageId == "" and type(responseBody) == "table" then
                    newMessageId = tostring(responseBody.id or responseBody.messageId or "")
                end
                if newMessageId ~= "" then
                    roundState.messageId = newMessageId
                end
            end
            webhookState.lastStatus = "SENT UFO INVASION"
            webhookState.lastError = ""
        else
            webhookState.lastStatus = "WEBHOOK ERROR"
            webhookState.lastError = statusCode
                and ("HTTP " .. tostring(statusCode)) or "HTTP request rejected"
            -- If Discord says the tracked message is gone, the next coalesced
            -- update starts a fresh message; ordinary failures are not retried
            -- aggressively and therefore cannot flood the webhook.
            if method == "PATCH" and statusCode == 404 then
                roundState.messageId = ""
                roundState.dirty = true
            end
        end
        roundState.pending = false
        if roundState.dirty == true then
            roundState.dirty = false
            sharedEnv.ChickenWebhookUfoRoundUpdate(
                stableKey,
                roundState.deadline,
                nil,
                roundState.rounds,
                roundState.ended,
                roundState.isTest
            )
        end
    end)
    return true
end
sharedEnv.ChickenWebhookSendUfoRoundEnd = function(previousPhase, previousDeadline, rounds, mutations, isTest)
    return sharedEnv.ChickenWebhookUfoRoundUpdate(
        previousDeadline,
        previousDeadline,
        nil,
        rounds,
        true,
        isTest
    )
end
sharedEnv.ChickenWebhookTestEvent = function(eventId)
    eventId = tostring(eventId or "")
    local deadline = workspace:GetServerTimeNow() + 60
    return sharedEnv.ChickenWebhookSendEvent(eventId, deadline, true)
end
sharedEnv.ChickenFastIncubatorEnabled = savedBool("fastIncubator", DEFAULT_SETTINGS.fastIncubator)
sharedEnv.ChickenFastIncubatorSwapSeconds = math.clamp(
    parseNumberInput(savedSettings.fastIncubatorSwapSeconds) or DEFAULT_SETTINGS.fastIncubatorSwapSeconds,
    0.1,
    60
)
sharedEnv.ChickenFastIncubatorReturnSeconds = math.clamp(
    parseNumberInput(savedSettings.fastIncubatorReturnSeconds) or DEFAULT_SETTINGS.fastIncubatorReturnSeconds,
    0.1,
    60
)
sharedEnv.ChickenFastIncubatorSourceId = type(savedSettings.fastIncubatorSourceId) == "string"
    and savedSettings.fastIncubatorSourceId or nil
sharedEnv.ChickenFastIncubatorTargetId = type(savedSettings.fastIncubatorTargetId) == "string"
    and savedSettings.fastIncubatorTargetId or nil
local autoNest = savedBool("autoNest", DEFAULT_SETTINGS.autoNest)
local autoScrap = savedBool("autoScrap", DEFAULT_SETTINGS.autoScrap)
local holdScrapBeforeRebirth = savedBool("holdScrapBeforeRebirth", DEFAULT_SETTINGS.holdScrapBeforeRebirth)
local scrapTargetCount = math.clamp(parseNumberInput(savedSettings.scrapTargetCount) or DEFAULT_SETTINGS.scrapTargetCount, 1, 24)
local scrapDepositDelay = math.clamp(parseNumberInput(savedSettings.scrapDepositDelay) or DEFAULT_SETTINGS.scrapDepositDelay, 0, 60)
sharedEnv.ChickenRebirthDelayTrigger = savedSettings.rebirthDelayTrigger == "walk" and "walk"
    or savedSettings.rebirthDelayTrigger == "deposit" and "deposit"
    or savedSettings.rebirthDelayTrigger == "none" and "none"
    or DEFAULT_SETTINGS.rebirthDelayTrigger
sharedEnv.ChickenRebirthDelaySyncing = false
local scrapManualPauseSeconds = math.clamp(parseNumberInput(savedSettings.scrapManualPauseSeconds) or DEFAULT_SETTINGS.scrapManualPauseSeconds, 0, 300)
local upgradeEnabled = savedBool("upgradeEnabled", DEFAULT_SETTINGS.upgradeEnabled)
local upgradeCoop = savedBool("upgradeCoop", DEFAULT_SETTINGS.upgradeCoop)
local upgradeFeeder = savedBool("upgradeFeeder", DEFAULT_SETTINGS.upgradeFeeder)
sharedEnv.ChickenFeederWatchdog = savedBool("feederWatchdog", DEFAULT_SETTINGS.feederWatchdog)
local upgradeRecycler = savedBool("upgradeRecycler", DEFAULT_SETTINGS.upgradeRecycler)
local keepMoneyForLastFloor = savedBool("keepMoneyForLastFloor", DEFAULT_SETTINGS.keepMoneyForLastFloor)
local upgradeOrder = savedSettings.upgradeOrder == "high" and "high"
    or savedSettings.upgradeOrder == "feeder" and "feeder"
    or DEFAULT_SETTINGS.upgradeOrder
-- Keep a small spacing between upgrade remotes even when the saved value is 0;
-- a zero-delay burst is rejected by the server as rateLimited.
local upgradeDelay = math.clamp(
    parseNumberInput(savedSettings.upgradeDelay) or DEFAULT_SETTINGS.upgradeDelay,
    0.05,
    60
)
-- Auto Fuse is opt-in.  Exceptions are persisted by chicken id but filtered
-- against the currently selected rarities when the roster list is rebuilt.
local savedAutoFuseRarities = {}
if type(savedSettings.autoFuseRarities) == "table" then
    for key, value in pairs(savedSettings.autoFuseRarities) do
        local rarity = type(key) == "number" and value or (value == true and key or nil)
        if type(rarity) == "string" and rarity ~= "" then
            savedAutoFuseRarities[rarity] = true
        end
    end
end
if next(savedAutoFuseRarities) == nil
    and type(savedSettings.autoFuseRarity) == "string"
    and savedSettings.autoFuseRarity ~= "" then
    savedAutoFuseRarities[savedSettings.autoFuseRarity] = true
end
sharedEnv.ChickenAutoFuseState = {
    enabled = savedBool("autoFuse", DEFAULT_SETTINGS.autoFuse),
    mode = savedSettings.autoFuseMode == "stats" and "stats"
        or savedSettings.autoFuseMode == "rarity" and "rarity"
        or savedSettings.autoFuseMode == "sameName" and "sameName"
        or DEFAULT_SETTINGS.autoFuseMode,
    rarities = savedAutoFuseRarities,
    selectedNames = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.autoFuseChickenNames),
    rarity = type(savedSettings.autoFuseRarity) == "string"
        and savedSettings.autoFuseRarity ~= "" and savedSettings.autoFuseRarity
        or DEFAULT_SETTINGS.autoFuseRarity,
    exceptions = {},
    delay = math.clamp(
        parseNumberInput(savedSettings.autoFuseDelay) or DEFAULT_SETTINGS.autoFuseDelay,
        0.1,
        60
    ),
    keepBest = math.clamp(
        math.floor(parseNumberInput(savedSettings.autoFuseKeepBest) or DEFAULT_SETTINGS.autoFuseKeepBest),
        0,
        100
    ),
    sellBadStat = savedBool("autoFuseSellBadStat", DEFAULT_SETTINGS.autoFuseSellBadStat),
    renameIfUp = type(savedSettings.autoFuseRenameIfUp) == "string"
        and savedSettings.autoFuseRenameIfUp or DEFAULT_SETTINGS.autoFuseRenameIfUp,
    renameIfAlone = type(savedSettings.autoFuseRenameIfAlone) == "string"
        and savedSettings.autoFuseRenameIfAlone or DEFAULT_SETTINGS.autoFuseRenameIfAlone,
    status = "IDLE",
    lastActionAt = 0,
    busy = false,
    generationById = {},
    keepBestIds = {},
    aloneIds = {},
}
if type(savedSettings.autoFuseExceptions) == "table" then
    for _, id in ipairs(savedSettings.autoFuseExceptions) do
        if type(id) == "string" and id ~= "" then
            sharedEnv.ChickenAutoFuseState.exceptions[id] = true
        end
    end
end
sharedEnv.ChickenPromoteState = {
    enabled = savedBool("autoPromote", DEFAULT_SETTINGS.autoPromote),
    targetIds = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.promoteTargetIds),
    eggId = type(savedSettings.promoteEggId) == "string"
        and savedSettings.promoteEggId ~= "" and savedSettings.promoteEggId or nil,
    targetOrder = (function(value)
        local order = {}
        local seen = {}
        if type(value) == "table" then
            for _, id in ipairs(value) do
                if type(id) == "string" and id ~= "" and not seen[id] then
                    seen[id] = true
                    table.insert(order, id)
                end
            end
        end
        return order
    end)(savedSettings.promoteTargetOrder),
    keepCount = math.clamp(
        math.floor(parseNumberInput(savedSettings.promoteKeepCount) or DEFAULT_SETTINGS.promoteKeepCount),
        0,
        100
    ),
    excludeRarities = sharedEnv.ChickenSettingsSavedStringSet(savedSettings.promoteExcludeRarities),
    -- The default protects only material rarities strictly above the target;
    -- the separate >= toggle remains available for the stricter boundary.
    excludeHigher = savedBool("promoteExcludeHigher", DEFAULT_SETTINGS.promoteExcludeHigher),
    excludeHigherOrEqual = savedBool(
        "promoteExcludeHigherOrEqual",
        DEFAULT_SETTINGS.promoteExcludeHigherOrEqual
    ),
    delay = 1,
    status = "DISABLED",
    busy = false,
    lastActionAt = 0,
    lastTargetId = nil,
    lastResult = "—",
    targetDropdown = nil,
    targetOptionToId = {},
    targetIdToOption = {},
    eggDropdown = nil,
    eggOptions = {},
    eggOptionToId = {},
    eggIdToOption = {},
    eggOptionSignature = nil,
    excludeChickenTypes = sharedEnv.ChickenSettingsSavedStringSet(
        savedSettings.promoteExcludeChickenTypes
    ),
    excludeChickenDropdown = nil,
    excludeChickenOptions = {},
    excludeChickenOptionToType = {},
    excludeChickenTypeToOption = {},
    excludeChickenOptionSignature = nil,
    activeTargetIds = {},
    rarityDropdown = nil,
    rarityOptionToKey = {},
    rarityKeyToOption = {},
    targetOptionSignature = nil,
    rarityOptionSignature = nil,
    reordering = false,
    startupGuardUntil = os.clock() + 0.5,
}
sharedEnv.ChickenStatsState = {
    selected = {},
    baseLevel = math.max(
        1,
        math.floor(parseNumberInput(savedSettings.statsBaseLevel) or DEFAULT_SETTINGS.statsBaseLevel)
    ),
    genomeStat = math.max(
        0,
        math.floor(parseNumberInput(savedSettings.statsGenomeStat) or DEFAULT_SETTINGS.statsGenomeStat)
    ),
    selectedEggId = type(savedSettings.statsSelectedEggId) == "string"
        and savedSettings.statsSelectedEggId or nil,
}
-- v1.0.55-v1.0.57 accidentally persisted the complete Catalog as the
-- dropdown Default.  Treat that oversized selection as stale and fall back
-- to the active chicken instead of reopening with every option checked.
if type(savedSettings.statsSelectedTypeIds) == "table"
    and #savedSettings.statsSelectedTypeIds <= 50 then
    for _, typeId in ipairs(savedSettings.statsSelectedTypeIds) do
        if type(typeId) == "string" and typeId ~= "" then
            table.insert(sharedEnv.ChickenStatsState.selected, typeId)
        end
    end
end
print("[Arena UI] settings profile:", sharedEnv.ChickenSettingsProfile.file)
print("[Arena UI] loaded saved settings; Auto Arena:", autoArena and "on" or "off")
print("[Arena UI] embedded defaults v2; Auto Arena:", DEFAULT_SETTINGS.autoArena and "ON" or "OFF", "scrap delay:", scrapDepositDelay)
local uiToggleKey = Enum.KeyCode[DEFAULT_SETTINGS.uiToggleKey] or Enum.KeyCode.LeftShift
if type(savedSettings.uiToggleKey) == "string" then
    pcall(function()
        local savedKey = Enum.KeyCode[savedSettings.uiToggleKey]
        if savedKey then
            uiToggleKey = savedKey
        end
    end)
end
local loadingControls = true

local function saveSettings()
    if type(writefile) ~= "function" then
        return
    end

    local payload = {
        __schema = DEFAULT_SETTINGS_SCHEMA,
        __accountUserId = sharedEnv.ChickenSettingsProfile.ownerKey,
        autoArena = autoArena,
        arenaCombatEsp = sharedEnv.ChickenArenaCombatESPEnabled == true,
        smartSelection = smartSelection,
        autoTowerToRebirth = autoTowerToRebirth,
        autoTowerContinuous = autoTower,
        autoLeaveOnRebirth = sharedEnv.ChickenAutoLeaveOnRebirth,
        leaveWhenRebirth = sharedEnv.ChickenLeaveWhenRebirth,
        autoLeaveAfterMinutes = sharedEnv.ChickenAutoLeaveAfterMinutes,
        leaveAfterMinutes = sharedEnv.ChickenLeaveAfterMinutes,
        autoDismissTowerPopup = autoDismissTowerPopup,
        towerStartLatest = towerStartLatest,
        towerStartDelay = towerStartDelay,
        towerDeathDelay = towerDeathDelay,
        towerRunDuration = math.max(0, tonumber(sharedEnv.ChickenTowerTiming.runDuration) or 0),
        towerNextRunDelay = math.max(0, tonumber(sharedEnv.ChickenTowerTiming.nextRunDelay) or 0),
        autoIncubator = autoIncubator,
        autoHatching = sharedEnv.ChickenHatchingState.enabled,
        hatchingEggs = sharedEnv.ChickenSettingsStringSetArray(sharedEnv.ChickenHatchingState.selectedEggs),
        autoHatchSell = sharedEnv.ChickenHatchingState.autoSell,
        hatchingSellRarityExceptions = sharedEnv.ChickenSettingsStringSetArray(sharedEnv.ChickenHatchingState.sellRarityExceptions),
        hatchingSellChickenExceptions = sharedEnv.ChickenSettingsStringSetArray(sharedEnv.ChickenHatchingState.sellChickenExceptions),
        fastIncubator = sharedEnv.ChickenFastIncubatorEnabled,
        fastIncubatorSwapSeconds = sharedEnv.ChickenFastIncubatorSwapSeconds,
        fastIncubatorReturnSeconds = sharedEnv.ChickenFastIncubatorReturnSeconds,
        fastIncubatorSourceId = sharedEnv.ChickenFastIncubatorSourceId,
        fastIncubatorTargetId = sharedEnv.ChickenFastIncubatorTargetId,
        autoUfu = sharedEnv.ChickenUfuState.enabled == true,
        autoChaosEvents = (function()
            local values = {}
            for eventId, enabled in pairs(sharedEnv.ChickenUfuState.events or {}) do
                if enabled then
                    table.insert(values, eventId)
                end
            end
            table.sort(values)
            return values
        end)(),
        -- Keep the legacy aggregate key for older builds, while the current
        -- UI persists separate controls for normal Events and UFO.
        autoChaosUseAllEventChicken = sharedEnv.ChickenUfuState.useAllEventChicken == true,
        autoChaosUseUfoChicken = sharedEnv.ChickenUfuState.useUfoChicken == true,
        autoChaosUsePickedChicken = sharedEnv.ChickenUfuState.useAllEventChicken == true
            or sharedEnv.ChickenUfuState.useUfoChicken == true,
        autoChaosChickenId = sharedEnv.ChickenUfuState.pickedChickenId,
        autoChaosChickenIds = sharedEnv.ChickenSettingsStringSetArray(sharedEnv.ChickenUfuState.pickedChickenIds),
        autoChaosTargetRarity = sharedEnv.ChickenUfuState.targetRarity or "",
        autoLeaveOnUfoRarity = sharedEnv.ChickenUfuState.leaveWhenRarityEnabled == true,
        leaveWhenUfoRarity = tostring(sharedEnv.ChickenUfuState.leaveWhenRarity or ""),
        autoNest = autoNest,
        autoScrap = autoScrap,
        holdScrapBeforeRebirth = holdScrapBeforeRebirth,
        scrapTargetCount = scrapTargetCount,
        scrapDepositDelay = scrapDepositDelay,
        rebirthDelayTrigger = sharedEnv.ChickenRebirthDelayTrigger,
        scrapManualPauseSeconds = scrapManualPauseSeconds,
        upgradeEnabled = upgradeEnabled,
        upgradeCoop = upgradeCoop,
        upgradeFeeder = upgradeFeeder,
        feederWatchdog = sharedEnv.ChickenFeederWatchdog,
        upgradeRecycler = upgradeRecycler,
        keepMoneyForLastFloor = keepMoneyForLastFloor,
        upgradeOrder = upgradeOrder,
        upgradeDelay = upgradeDelay,
        autoFuse = sharedEnv.ChickenAutoFuseState.enabled,
        autoFuseConfigVersion = 5,
        autoFuseMode = sharedEnv.ChickenAutoFuseState.mode,
        autoFuseRarity = sharedEnv.ChickenAutoFuseState.rarity,
        autoFuseRarities = (function()
            local values = {}
            for rarity, enabled in pairs(sharedEnv.ChickenAutoFuseState.rarities or {}) do
                if enabled then
                    table.insert(values, rarity)
                end
            end
            table.sort(values)
            return values
        end)(),
        autoFuseChickenNames = sharedEnv.ChickenSettingsStringSetArray(
            sharedEnv.ChickenAutoFuseState.selectedNames
        ),
        autoFuseDelay = sharedEnv.ChickenAutoFuseState.delay,
        autoFuseKeepBest = sharedEnv.ChickenAutoFuseState.keepBest,
        autoFuseSellBadStat = sharedEnv.ChickenAutoFuseState.sellBadStat,
        autoFuseRenameIfUp = sharedEnv.ChickenAutoFuseState.renameIfUp,
        autoFuseRenameIfAlone = sharedEnv.ChickenAutoFuseState.renameIfAlone,
        autoFuseExceptions = (function()
            local ids = {}
            for id, enabled in pairs(sharedEnv.ChickenAutoFuseState.exceptions) do
                if enabled then
                    table.insert(ids, id)
                end
            end
            table.sort(ids)
            return ids
        end)(),
        autoPromote = sharedEnv.ChickenPromoteState.enabled == true,
        promoteTargetIds = sharedEnv.ChickenSettingsStringSetArray(
            sharedEnv.ChickenPromoteState.targetIds
        ),
        promoteTargetOrder = (function()
            local order = {}
            local seen = {}
            local selected = sharedEnv.ChickenPromoteState.targetIds or {}
            for _, id in ipairs(sharedEnv.ChickenPromoteState.targetOrder or {}) do
                if type(id) == "string" and selected[id] == true and not seen[id] then
                    seen[id] = true
                    table.insert(order, id)
                end
            end
            -- Include any legacy/newly-selected ids that are not in the
            -- in-memory order so they are not lost during a save.
            local missing = {}
            for id, enabled in pairs(selected) do
                if enabled == true and not seen[id] then
                    table.insert(missing, id)
                end
            end
            table.sort(missing)
            for _, id in ipairs(missing) do
                seen[id] = true
                table.insert(order, id)
            end
            return order
        end)(),
        promoteEggId = tostring(sharedEnv.ChickenPromoteState.eggId or ""),
        promoteExcludeChickenTypes = sharedEnv.ChickenSettingsStringSetArray(
            sharedEnv.ChickenPromoteState.excludeChickenTypes
        ),
        promoteKeepCount = math.clamp(
            math.floor(tonumber(sharedEnv.ChickenPromoteState.keepCount) or 0),
            0,
            100
        ),
        promoteKeepConfigVersion = DEFAULT_SETTINGS.promoteKeepConfigVersion,
        promoteExcludeRarities = sharedEnv.ChickenSettingsStringSetArray(
            sharedEnv.ChickenPromoteState.excludeRarities
        ),
        promoteExcludeHigher = sharedEnv.ChickenPromoteState.excludeHigher == true,
        promoteExcludeHigherOrEqual = sharedEnv.ChickenPromoteState.excludeHigherOrEqual == true,
        uiToggleKey = uiToggleKey.Name,
        uiWindowWidthPercent = sharedEnv.ChickenUiWindowScaleWidthPercent,
        uiWindowHeightPercent = sharedEnv.ChickenUiWindowScaleHeightPercent,
        statsBaseLevel = sharedEnv.ChickenStatsState.baseLevel,
        statsGenomeStat = sharedEnv.ChickenStatsState.genomeStat,
        statsSelectedTypeIds = sharedEnv.ChickenStatsState.selected,
        statsSelectedEggId = sharedEnv.ChickenStatsState.selectedEggId,
        discordWebhookEnabled = sharedEnv.ChickenWebhookState.enabled == true,
        discordWebhookUrl = sharedEnv.ChickenWebhookState.url or "",
        discordWebhookEvents = sharedEnv.ChickenSettingsStringSetArray(
            sharedEnv.ChickenWebhookState.events
        ),
        discordUpcomingEventsEnabled = sharedEnv.ChickenWebhookState.upcomingEnabled == true,
        discordUpcomingEventsUrl = tostring(
            sharedEnv.ChickenWebhookState.upcomingUrl or ""
        ),
        discordUpcomingEventsMessageId = tostring(
            sharedEnv.ChickenWebhookState.upcomingMessageId or ""
        ),
    }
    pcall(function()
        writefile(sharedEnv.ChickenSettingsProfile.file, HttpService:JSONEncode(payload))
    end)
end

-- Discord renders `<t:timestamp:R>` values live on the client, so the schedule
-- message only needs an occasional refresh rather than a five-second PATCH.
sharedEnv.ChickenWebhookUpcomingUpdateInterval = 60
-- Keep one Discord message current with the next occurrence of every rotating
-- event.  This is independent from LIVE event alerts and Auto Chaos; the
-- toggle in Settings only controls this schedule message.
sharedEnv.ChickenWebhookUpcomingEventsUpdate = function(force)
    local state = sharedEnv.ChickenWebhookState
    if type(state) ~= "table" or state.upcomingEnabled ~= true then
        return false
    end
    local url = tostring(state.upcomingUrl or "")
    if not url:match("^https?://") then
        state.lastStatus = "INVALID WEBHOOK URL"
        state.lastError = "URL must start with http:// or https://"
        return false
    end
    local now = os.clock()
    if state.upcomingPending == true then
        state.upcomingDirty = true
        return true
    end
    if force ~= true
        and now - (tonumber(state.upcomingLastUpdateAt) or 0)
            < (tonumber(sharedEnv.ChickenWebhookUpcomingUpdateInterval) or 60) then
        return false
    end
    local snapshot = sharedEnv.ChickenWebhookBuildUpcomingEvents()
    local embed = sharedEnv.ChickenWebhookBuildUpcomingEmbed(snapshot)
    local body = HttpService:JSONEncode({
        username = "gertitq",
        allowed_mentions = {parse = {}},
        embeds = {embed},
    })
    local messageId = tostring(state.upcomingMessageId or "")
    local method = messageId == "" and "POST" or "PATCH"
    local endpoint = url
    if method == "POST" then
        if not endpoint:find("wait=", 1, true) then
            endpoint = endpoint .. (endpoint:find("?", 1, true) and "&wait=true" or "?wait=true")
        end
    else
        endpoint = endpoint:gsub("/+$", "") .. "/messages/" .. messageId
    end
    local generation = tonumber(sharedEnv.ChickenWebhookCountdownGeneration) or 0
    state.upcomingLastUpdateAt = now
    state.upcomingPending = true
    state.upcomingDirty = false
    state.lastStatus = "UPDATING UPCOMING EVENTS"
    state.lastError = ""
    task.spawn(function()
        local requestFn
        pcall(function()
            if type(request) == "function" then
                requestFn = request
            end
        end)
        if not requestFn then
            pcall(function()
                if type(http_request) == "function" then
                    requestFn = http_request
                end
            end)
        end
        if not requestFn then
            pcall(function()
                if type(http) == "table" and type(http.request) == "function" then
                    requestFn = http.request
                end
            end)
        end
        if not requestFn then
            if sharedEnv.ChickenWebhookCountdownGeneration == generation then
                state.upcomingPending = false
                state.lastStatus = "WEBHOOK ERROR"
                state.lastError = "HTTP request is unavailable in this executor"
            end
            return
        end
        local ok, response = pcall(requestFn, {
            Url = endpoint,
            Method = method,
            Headers = { ["Content-Type"] = "application/json" },
            Body = body,
        })
        if sharedEnv.ChickenWebhookCountdownGeneration ~= generation then
            return
        end
        local statusCode = type(response) == "table"
            and tonumber(response.StatusCode or response.status_code or response.Status) or nil
        local success = ok and (type(response) ~= "table"
            or response.Success == true
            or (statusCode and statusCode >= 200 and statusCode < 300))
        if success then
            if method == "POST" and type(response) == "table" then
                local newMessageId = tostring(response.id or response.messageId or "")
                local responseBody = response.Body or response.body
                if newMessageId == "" and type(responseBody) == "string" and responseBody ~= "" then
                    local decodedOk, decoded = pcall(function()
                        return HttpService:JSONDecode(responseBody)
                    end)
                    if decodedOk and type(decoded) == "table" then
                        newMessageId = tostring(decoded.id or decoded.messageId or "")
                    end
                elseif newMessageId == "" and type(responseBody) == "table" then
                    newMessageId = tostring(responseBody.id or responseBody.messageId or "")
                end
                if newMessageId ~= "" then
                    state.upcomingMessageId = newMessageId
                    saveSettings()
                end
            end
            state.lastStatus = "UPDATED UPCOMING EVENTS"
            state.lastError = ""
        else
            state.lastStatus = "WEBHOOK ERROR"
            state.lastError = statusCode
                and ("HTTP " .. tostring(statusCode)) or "HTTP request rejected"
            if method == "PATCH" and statusCode == 404 then
                state.upcomingMessageId = ""
                state.upcomingDirty = true
                saveSettings()
            end
        end
        state.upcomingPending = false
        if state.upcomingDirty == true and state.upcomingEnabled == true then
            state.upcomingDirty = false
            sharedEnv.ChickenWebhookUpcomingEventsUpdate(true)
        end
    end)
    return true
end

local eggBusy = false
local scrapBusy = false
local scrapStatus = "IDLE"
local scrapRunToken = 0
local scrapReadyForDeposit = false
local scrapDepositAfterRebirthBusy = false
local scrapNextRunQueued = false
local scrapManualPauseUntil = 0
local scrapDepositConfirmed = false
local towerBusy = false
-- Separate the local request flag from the server-run flag.  A successful
-- TowerStart can arrive before TowerRunStarted, and a timeout must not make a
-- second start while the server is still running the first one.
local towerRunState = {
    active = false,
    busyRetryCount = 0,
    startRetryAt = 0,
    settleUntil = 0,
    afterRebirthPending = false,
    runDeadline = 0,
    actionAt = 0,
    -- Tower remotes are broadcast with a plotIndex for every active arena.
    -- Only the local player's plot may change our run latch/status.
    eventMatchesLocal = function(payload)
        if type(payload) ~= "table" then
            return true
        end
        local eventPlot = tonumber(payload.plotIndex)
        local localPlot = tonumber(Players.LocalPlayer:GetAttribute("Plot"))
        if eventPlot and localPlot then
            return eventPlot == localPlot
        end
        return true
    end,
    serverRunActive = function()
        local localPlot = tonumber(Players.LocalPlayer:GetAttribute("Plot"))
        if not localPlot then
            return false
        end
        local arenas = game:GetService("Workspace"):FindFirstChild("Arenas")
        local arena = arenas and arenas:FindFirstChild("Arena" .. tostring(localPlot))
        return arena and arena:GetAttribute("TowerActive") == true or false
    end,
}
sharedEnv.ChickenArmTowerRunDuration = function()
    local duration = math.max(0, tonumber(sharedEnv.ChickenTowerTiming
        and sharedEnv.ChickenTowerTiming.runDuration) or 0)
    towerRunState.runDeadline = duration > 0 and (os.clock() + duration) or 0
end
local towerRetreatBusy = false
local rebirthBusy = false
local towerNextStartAt = 0
local towerUfoPauseRetryAt = 0
local towerDefeatPending = false
local towerStatus = "IDLE"
local towerPopupVisible = false
local resumeState = sharedEnv.ChickenTowerResumeState
local towerResumeBest = 0
local towerResumeRebirthCount
if type(resumeState) == "table"
    and resumeState.jobId == game.JobId
    and tonumber(resumeState.rebirthCount) then
    towerResumeBest = tonumber(resumeState.best) or 0
    towerResumeRebirthCount = tonumber(resumeState.rebirthCount)
end
-- Measure one complete rebirth cycle from the moment a rebirth succeeds to
-- the moment the next rebirth succeeds.  Keep it in sharedEnv so a script
-- reload in the same server does not lose an in-progress measurement.  This
-- is deliberately stored behind shared functions rather than top-level local
-- bindings because this script is close to Luau's 200-register chunk limit.
(function()
    local timer = sharedEnv.ChickenRebirthCycleTimer
    if type(timer) ~= "table" or timer.jobId ~= game.JobId then
        timer = {
            jobId = game.JobId,
            startAt = 0,
            startCount = nil,
            lastSeconds = 0,
            lastCompletedCount = nil,
            lastMarkedCount = nil,
            observedCount = nil,
        }
    else
        timer.startAt = tonumber(timer.startAt) or 0
        timer.lastSeconds = math.max(0, tonumber(timer.lastSeconds) or 0)
        timer.startCount = tonumber(timer.startCount)
        timer.lastCompletedCount = tonumber(timer.lastCompletedCount)
        timer.lastMarkedCount = tonumber(timer.lastMarkedCount)
        timer.observedCount = tonumber(timer.observedCount)
    end
    sharedEnv.ChickenRebirthCycleTimer = timer
end)()

sharedEnv.ChickenMarkRebirthCycleComplete = function(completedCount)
    local timer = sharedEnv.ChickenRebirthCycleTimer
    if type(timer) ~= "table" then
        return
    end
    local completed = tonumber(completedCount)
    if completed and timer.lastMarkedCount == completed then
        return
    end

    local completedAt = os.clock()
    local startAt = tonumber(timer.startAt) or 0
    local startCount = tonumber(timer.startCount)
    if startAt > 0 and completedAt >= startAt
        and (not startCount or not completed or completed > startCount) then
        timer.lastSeconds = completedAt - startAt
        timer.lastCompletedCount = completed
    end

    timer.jobId = game.JobId
    timer.startAt = completedAt
    timer.startCount = completed
    timer.lastMarkedCount = completed
    timer.observedCount = completed or timer.observedCount
    if type(sharedEnv.ChickenMaybeLeaveWhenRebirth) == "function" then
        sharedEnv.ChickenMaybeLeaveWhenRebirth(completed)
    end
end

sharedEnv.ChickenObserveRebirthCycleCount = function(count)
    local timer = sharedEnv.ChickenRebirthCycleTimer
    if type(timer) ~= "table" then
        return
    end
    local current = tonumber(count)
    if not current then
        return
    end

    local observed = tonumber(timer.observedCount)
    if not observed then
        timer.observedCount = current
    elseif current > observed then
        -- Also catch a manual/server-side Rebirth that was not initiated by
        -- the Tower controller.
        sharedEnv.ChickenMarkRebirthCycleComplete(current)
    elseif current < observed then
        -- The server can briefly expose a reset/stale value during Rebirth;
        -- accept it as a new observation without discarding the timer.
        timer.observedCount = current
    end
    -- Check on every fresh observation, not only when the count changes.  This
    -- also arms Auto Leave after a reload/toggle when the saved target has
    -- already been reached and the count is stable.
    if type(sharedEnv.ChickenMaybeLeaveWhenRebirth) == "function" then
        sharedEnv.ChickenMaybeLeaveWhenRebirth(current)
    end
end
local upgradeBusy = false
local upgradeRunToken = 0
local upgradeStatus = "IDLE"
local recyclerUpgradeState = sharedEnv.ChickenRecyclerUpgradeState
    or {busy = false, token = 0, status = "IDLE", retryAt = 0}
sharedEnv.ChickenRecyclerUpgradeState = recyclerUpgradeState
recyclerUpgradeState.retryAt = tonumber(recyclerUpgradeState.retryAt) or 0
-- A need-floor latch is valid only for this script generation.  It prevents a
-- Recycler Remote call from being retried while Tower/Rebirth data is
-- unchanged, while the shared wait state still provides the status text.
recyclerUpgradeState.floorBlockedSignature = nil
recyclerUpgradeState.floorBlockedLabel = nil
recyclerUpgradeState.floorWarningKey = nil
local generation = (sharedEnv.ChickenArenaGeneration or 0) + 1
sharedEnv.ChickenArenaGeneration = generation

-- Auto Leave is armed only after a confirmed Rebirth count reaches the
-- configured absolute target.  The one-shot latch prevents the Rebirth loop
-- and the manual/server-side observer from scheduling duplicate leaves.
sharedEnv.ChickenRebirthLeaveTriggered = false
sharedEnv.ChickenRebirthLeaveState = {
    enabled = sharedEnv.ChickenAutoLeaveOnRebirth == true,
    target = sharedEnv.ChickenLeaveWhenRebirth,
    triggered = false,
    minutesEnabled = sharedEnv.ChickenAutoLeaveAfterMinutes == true,
    minutes = sharedEnv.ChickenLeaveAfterMinutes,
    minutesStartedAt = 0,
    minutesTriggered = false,
}
-- A minutes-based leave starts a fresh timer when the script is loaded with
-- the toggle already enabled.  Editing the field/toggle below resets it.
sharedEnv.ChickenLeaveAfterMinutesStartedAt =
    sharedEnv.ChickenAutoLeaveAfterMinutes
        and sharedEnv.ChickenLeaveAfterMinutes > 0
        and os.clock() or 0
sharedEnv.ChickenRebirthLeaveState.minutesStartedAt =
    sharedEnv.ChickenLeaveAfterMinutesStartedAt
sharedEnv.ChickenMaybeLeaveAfterMinutes = function()
    local minutes = tonumber(sharedEnv.ChickenLeaveAfterMinutes) or 0
    local startedAt = tonumber(sharedEnv.ChickenLeaveAfterMinutesStartedAt) or 0
    if not sharedEnv.ChickenAutoLeaveAfterMinutes
        or minutes <= 0
        or startedAt <= 0
        or (os.clock() - startedAt) < minutes * 60
        or sharedEnv.ChickenRebirthLeaveState.minutesTriggered then
        return false
    end

    sharedEnv.ChickenRebirthLeaveState.minutesEnabled = true
    sharedEnv.ChickenRebirthLeaveState.minutes = minutes
    sharedEnv.ChickenRebirthLeaveState.minutesTriggered = true
    towerStatus = "LEAVING AFTER " .. tostring(minutes) .. " MINUTES"
    task.delay(0.5, function()
        if sharedEnv.ChickenArenaGeneration ~= generation
            or not sharedEnv.ChickenAutoLeaveAfterMinutes
            or (tonumber(sharedEnv.ChickenLeaveAfterMinutes) or 0) ~= minutes
            or (tonumber(sharedEnv.ChickenLeaveAfterMinutesStartedAt) or 0) ~= startedAt then
            return
        end
        local player = Players.LocalPlayer
        if not player then
            return
        end
        local kicked = pcall(function()
            player:Kick("Auto Leave: " .. tostring(minutes) .. " minutes reached")
        end)
        if not kicked then
            pcall(function()
                game:Shutdown()
            end)
        end
    end)
    return true
end
sharedEnv.ChickenMaybeLeaveWhenRebirth = function(completedCount)
    local completed = math.floor(tonumber(completedCount) or -1)
    local target = math.floor(tonumber(sharedEnv.ChickenLeaveWhenRebirth) or 0)
    if not sharedEnv.ChickenAutoLeaveOnRebirth or target <= 0 or completed < target
        or sharedEnv.ChickenRebirthLeaveTriggered then
        return false
    end

    sharedEnv.ChickenRebirthLeaveTriggered = true
    sharedEnv.ChickenRebirthLeaveState.enabled = true
    sharedEnv.ChickenRebirthLeaveState.target = target
    sharedEnv.ChickenRebirthLeaveState.triggered = true
    towerStatus = "LEAVING AFTER REBIRTH #" .. tostring(completed)
    task.delay(0.5, function()
        if sharedEnv.ChickenArenaGeneration ~= generation
            or not sharedEnv.ChickenAutoLeaveOnRebirth
            or math.floor(tonumber(sharedEnv.ChickenLeaveWhenRebirth) or 0) <= 0 then
            return
        end
        local player = Players.LocalPlayer
        if not player then
            return
        end
        local kicked = pcall(function()
            player:Kick("Auto Leave: Rebirth #" .. tostring(completed) .. " reached")
        end)
        if not kicked then
            -- Some executors expose Shutdown instead of allowing a local Kick.
            pcall(function()
                game:Shutdown()
            end)
        end
    end)
    return true
end

-- UFO Auto Leave is a separate one-shot from the Rebirth leave controls.  The
-- UFO controller marks a session as started only after it has actually sent a
-- selected chicken to the Chaos pit, then calls this when the whole selected
-- rotation has reached the configured rarity.
sharedEnv.ChickenMaybeLeaveWhenUfoRarity = function()
    local state = sharedEnv.ChickenUfuState
    if type(state) ~= "table"
        or state.enabled ~= true
        or type(state.events) ~= "table"
        or state.events.ufo ~= true
        or state.currentEventId ~= "ufo"
        or state.phase ~= "LIVE"
        or state.leaveWhenRarityEnabled ~= true
        or type(state.leaveWhenRarity) ~= "string"
        or state.leaveWhenRarity == ""
        or state.ufoRotationComplete ~= true
        or state.ufoLeaveSessionStarted ~= true
        or state.ufoLeaveTriggered == true
        or type(sharedEnv.ChickenAutoChaos.selectedUfoChickenIds) ~= "function" then
        return false
    end

    local selectedIds = sharedEnv.ChickenAutoChaos.selectedUfoChickenIds()
    if type(selectedIds) ~= "table" or #selectedIds == 0 then
        return false
    end

    local target = state.leaveWhenRarity
    if sharedEnv.ChickenAutoChaos.rarityRank(target) <= 0 then
        return false
    end
    state.ufoLeaveTriggered = true
    state.status = "LEAVING AFTER UFO " .. string.upper(target)
    task.delay(0.5, function()
        if sharedEnv.ChickenArenaGeneration ~= generation
            or state.leaveWhenRarityEnabled ~= true
            or state.leaveWhenRarity ~= target
            or state.ufoLeaveTriggered ~= true then
            return
        end
        local player = Players.LocalPlayer
        if not player then
            return
        end
        local kicked = pcall(function()
            player:Kick("Auto Leave: UFO " .. string.upper(target) .. " reached")
        end)
        if not kicked then
            -- Some executors expose Shutdown instead of allowing a local Kick.
            pcall(function()
                game:Shutdown()
            end)
        end
    end)
    return true
end

-- Upgrade queues share one money pool and the server applies its own rate
-- limits. Keep the Remote lock/rate state shared, but keep money waits scoped
-- per queue so an expensive Recycler cannot block an affordable Feeder.
local upgradeWaitState = sharedEnv.ChickenUpgradeWaitState
if type(upgradeWaitState) ~= "table"
    or upgradeWaitState.jobId ~= game.JobId
    or upgradeWaitState.generation ~= generation then
    upgradeWaitState = {
        jobId = game.JobId,
        generation = generation,
        mainMoneyWaitCost = 0,
        mainMoneyRetryAt = 0,
        mainMoneyWaitSignature = nil,
        recyclerMoneyWaitCost = 0,
        recyclerMoneyRetryAt = 0,
        recyclerMoneyWaitSignature = nil,
        rateRetryAt = 0,
        needFloorSignature = nil,
        recyclerFloorSignature = nil,
    }
end
sharedEnv.ChickenUpgradeWaitState = upgradeWaitState

-- Only one upgrade RemoteFunction may spend money at a time. This prevents
-- the independent Recycler queue from racing the Coop/Feeder queue.
if type(upgradeWaitState.remoteLock) ~= "table"
    or upgradeWaitState.remoteLock.jobId ~= game.JobId then
    upgradeWaitState.remoteLock = {
        jobId = game.JobId,
        busy = false,
        busySince = 0,
        owner = nil,
        label = nil,
        kind = nil,
    }
end
sharedEnv.ChickenUpgradeRemoteLock = upgradeWaitState.remoteLock
-- Original Arena readiness cadence.  Keep the pre-lag behavior while we
-- compare it against a freshly restarted client.
local CHECK_INTERVAL = 0.25
local ERROR_INTERVAL = 8
-- A transient ArenaSkip/cursor race should be retried quickly. The old
-- 15-second gate made a completed match look stuck even after the arena was
-- already available again.
local ARENA_RETRY_DELAY = 0.75
local ARENA_RESULT_TRANSITION = 0.4
local ARENA_FIGHT_TRANSITION = 1
local retryAt = 0
local arenaTransitionUntil = 0
-- ArenaGetView can briefly return the previous READY snapshot immediately
-- after ArenaFight is accepted.  Keep this small gate in sharedEnv so a
-- reload/old controller cannot issue a second fight during that stale window.
if type(sharedEnv.ChickenArenaFightGate) ~= "table"
    or sharedEnv.ChickenArenaFightGate.jobId ~= game.JobId then
    sharedEnv.ChickenArenaFightGate = {
        jobId = game.JobId,
        busy = false,
        requestId = 0,
        startedAt = 0,
        expiresAt = 0,
    }
end
-- A server-side Arena match normally resolves within the game's 60-second
-- battle window.  Keep a per-job watchdog so a missing result/state event
-- cannot leave Auto Arena waiting forever.  Recovery is deliberately delayed
-- well past the normal window and only runs while the authoritative view still
-- says an active match exists; after cancelling the stale match the controller
-- refreshes and can start normally again.
if type(sharedEnv.ChickenArenaStallState) ~= "table"
    or sharedEnv.ChickenArenaStallState.jobId ~= game.JobId then
    sharedEnv.ChickenArenaStallState = {
        jobId = game.JobId,
        observedAt = 0,
        lastActive = false,
        lastBattles = nil,
        lastWins = nil,
        recoveryAttempted = false,
        timeout = 120,
    }
end
local arenaViewCache
local arenaViewCacheAt = 0
local arenaViewRequestBusy = false
local arenaViewOutstanding = 0
local arenaViewRequestId = 0
local arenaViewLastTimeoutAt = 0
local ARENA_VIEW_CACHE_TTL = 0.35
local ARENA_VIEW_TIMEOUT = 1.25
local ARENA_VIEW_TIMEOUT_RETRY = 0.5

-- RemoteFunctions can occasionally stall during the Arena result transition.
-- Never let that call block the controller loop indefinitely; keep one guarded
-- request in flight and reuse only a very recent response while it settles.
local function getArenaView(timeout, forceFresh)
    local now = os.clock()
    if not forceFresh
        and type(arenaViewCache) == "table"
        and now - arenaViewCacheAt <= ARENA_VIEW_CACHE_TTL then
        return true, arenaViewCache
    end

    if arenaViewRequestBusy then
        if type(arenaViewCache) == "table" and now - arenaViewCacheAt <= 1.5 then
            return true, arenaViewCache
        end
        return false, "busy"
    end

    if arenaViewOutstanding >= 2 then
        return false, "busy"
    end

    if arenaViewLastTimeoutAt > 0
        and now - arenaViewLastTimeoutAt < ARENA_VIEW_TIMEOUT_RETRY then
        return false, "timeout"
    end

    arenaViewRequestBusy = true
    arenaViewOutstanding += 1
    arenaViewRequestId += 1
    local requestId = arenaViewRequestId
    local requestStartedAt = now
    local done = false
    local callOk, response
    task.spawn(function()
        callOk, response = pcall(function()
            return arenaGetView:InvokeServer()
        end)
        -- A late response from a timed-out request must not overwrite a newer
        -- cache entry, but it still releases the in-flight guard.
        arenaViewOutstanding = math.max(0, arenaViewOutstanding - 1)
        if requestId == arenaViewRequestId then
            if callOk and type(response) == "table"
                and os.clock() - requestStartedAt <= (timeout or ARENA_VIEW_TIMEOUT) then
                arenaViewCache = response
                arenaViewCacheAt = os.clock()
            end
            arenaViewRequestBusy = false
        end
        done = true
    end)

    local deadline = os.clock() + math.max(0.25, tonumber(timeout) or ARENA_VIEW_TIMEOUT)
    while not done and os.clock() < deadline do
        task.wait(0.02)
    end
    if not done then
        -- Detach this request from the controller after timeout. Its eventual
        -- response is marked stale by the request id and cannot overwrite the
        -- active cache. A maximum of two outstanding calls prevents flooding.
        if requestId == arenaViewRequestId then
            arenaViewRequestId += 1
            arenaViewRequestBusy = false
        end
        arenaViewLastTimeoutAt = os.clock()
        return false, "timeout"
    end
    return callOk, response
end

local function invokeRemoteWithTimeout(remote, timeout, ...)
    local args = { ... }
    local done = false
    local callOk, response
    task.spawn(function()
        callOk, response = pcall(function()
            return remote:InvokeServer(table.unpack(args))
        end)
        done = true
    end)

    local deadline = os.clock() + math.max(0.25, tonumber(timeout) or 1)
    while not done and os.clock() < deadline do
        task.wait(0.02)
    end
    if not done then
        return false, "timeout"
    end
    return callOk, response
end

local function pauseAutoScrapForManualInput()
    if not autoScrap then
        return
    end
    local duration = math.max(0, tonumber(scrapManualPauseSeconds) or 0)
    if duration <= 0 then
        return
    end
    scrapManualPauseUntil = math.max(scrapManualPauseUntil, os.clock() + duration)
    scrapRunToken += 1
    scrapStatus = "PAUSED FOR MANUAL INPUT ("
        .. tostring(duration) .. "s)"
end

local manualScrapMovementKeys = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Right] = true,
    [Enum.KeyCode.Space] = true,
}
sharedEnv.ChickenScrapInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard
        and manualScrapMovementKeys[input.KeyCode] then
        pauseAutoScrapForManualInput()
    end
end)

local Window = MacLib:Window({
    Title = "gertitq",
    Subtitle = "Script " .. SCRIPT_VERSION,
    Size = UDim2.fromOffset(760, 600),
    DragStyle = 2,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = uiToggleKey,
    AcrylicBlur = true,
})

sharedEnv.ChickenArenaMacWindow = Window

local function unloadScript()
    print("[Arena UI] unload requested")
    sharedEnv.ChickenArenaGeneration = (sharedEnv.ChickenArenaGeneration or generation) + 1
    if sharedEnv.ChickenArenaMinimizeIconConnection then
        pcall(function()
            sharedEnv.ChickenArenaMinimizeIconConnection:Disconnect()
        end)
        sharedEnv.ChickenArenaMinimizeIconConnection = nil
    end
    if sharedEnv.ChickenArenaMinimizeIconGui then
        pcall(function()
            sharedEnv.ChickenArenaMinimizeIconGui:Destroy()
        end)
        sharedEnv.ChickenArenaMinimizeIconGui = nil
    end
    sharedEnv.ChickenArenaMinimizeIconTrackedGui = nil
    sharedEnv.ChickenArenaMinimizeIconTrackedBase = nil
    sharedEnv.ChickenArenaMacWindow = nil
    pcall(function()
        Window:Unload()
    end)
end

local MainGroup = Window:TabGroup()
local ArenaTab = MainGroup:Tab({
    Name = "Arena",
    Image = "rbxassetid://7743872758",
})
local RebirthTab = MainGroup:Tab({
    Name = "Rebirth",
    Image = "rbxassetid://7734051454",
})
local ScrapTab = MainGroup:Tab({
    Name = "Collect",
    Image = "rbxassetid://7734021469",
})
local UpgradeTab = MainGroup:Tab({
    Name = "Upgrade",
    Image = "rbxassetid://7743874262",
})
sharedEnv.ChickenHatchingUI = {}
sharedEnv.ChickenHatchingUI.Tab = MainGroup:Tab({
    Name = "Hatching",
    Image = "rbxassetid://7743872071",
})
sharedEnv.ChickenPromoteUI = {}
sharedEnv.ChickenPromoteUI.Tab = MainGroup:Tab({
    Name = "Promote",
    Image = "rbxassetid://7733765398",
})
sharedEnv.ChickenAutoFuseUI = {}
sharedEnv.ChickenAutoFuseUI.Tab = MainGroup:Tab({
    Name = "Fuse",
    Image = "rbxassetid://7733952195",
})
local EggTab = MainGroup:Tab({
    Name = "Egg",
    Image = "rbxassetid://8997385940",
})
sharedEnv.ChickenUfuUI = {}
sharedEnv.ChickenUfuUI.Tab = MainGroup:Tab({
    Name = "Event",
    Image = "rbxassetid://7733919198",
})
sharedEnv.ChickenStatsUI = {}
sharedEnv.ChickenStatsUI.Tab = MainGroup:Tab({
    Name = "Stats",
    Image = "rbxassetid://7733674319",
})
sharedEnv.ChickenFeederWatchdogTab = MainGroup:Tab({
    Name = "Feeder Watchdog",
    Image = "rbxassetid://7734056411",
})
local SettingsTab = MainGroup:Tab({
    Name = "Settings",
    Image = "rbxassetid://7734053495",
})

local ArenaSection = ArenaTab:Section({
    Side = "Left",
})
local ArenaInfoSection = ArenaTab:Section({
    Side = "Right",
})
local SettingsSection = SettingsTab:Section({
    Side = "Left",
})
local GameNotificationSection = SettingsTab:Section({
    Side = "Right",
})
GameNotificationSection:Paragraph({
    Header = "Active Config Profile",
    Body = "File: " .. tostring(sharedEnv.ChickenSettingsProfile.accountKey or "profile") .. ".json"
        .. "\nAccount: " .. tostring(sharedEnv.ChickenSettingsProfile.player
            and sharedEnv.ChickenSettingsProfile.player.Name or "Unknown")
        .. " (UserId " .. tostring(sharedEnv.ChickenSettingsProfile.userId or "Unknown") .. ")"
        .. "\nScope: PER-ACCOUNT"
        .. "\nLoaded: " .. (next(savedSettings) ~= nil and "SAVED PROFILE" or "EMBEDDED DEFAULTS"),
})
local RebirthSection = RebirthTab:Section({
    Side = "Left",
})
local RebirthInfoSection = RebirthTab:Section({
    Side = "Right",
})
local RebirthInfoParagraph = RebirthInfoSection:Paragraph({
    Header = "Tower / Rebirth Status",
    Body = "Loading tower status...",
})

RebirthInfoSection:Input({
    Name = "Leave When Rebirth",
    Placeholder = "blank = off",
    Default = sharedEnv.ChickenLeaveWhenRebirth > 0
        and tostring(sharedEnv.ChickenLeaveWhenRebirth) or "",
    Callback = function(value)
        if loadingControls then
            return
        end
        local text = tostring(value or "")
        if text:match("^%s*$") then
            sharedEnv.ChickenLeaveWhenRebirth = 0
            sharedEnv.ChickenRebirthLeaveState.target = 0
            sharedEnv.ChickenRebirthLeaveTriggered = false
            sharedEnv.ChickenRebirthLeaveState.triggered = false
            saveSettings()
            return
        end
        local parsed = parseNumberInput(text)
        if parsed and parsed >= 1 then
            sharedEnv.ChickenLeaveWhenRebirth = math.clamp(math.floor(parsed), 1, 1000000000)
            sharedEnv.ChickenRebirthLeaveState.target = sharedEnv.ChickenLeaveWhenRebirth
            sharedEnv.ChickenRebirthLeaveTriggered = false
            sharedEnv.ChickenRebirthLeaveState.triggered = false
            saveSettings()
        else
            Window:Notify({
                Title = "Leave When Rebirth",
                Description = "Enter a whole rebirth number, or leave blank to disable the target",
                Lifetime = 3,
            })
        end
    end,
}, "LeaveWhenRebirth")

RebirthInfoSection:Toggle({
    Name = "Auto Leave",
    Default = sharedEnv.ChickenAutoLeaveOnRebirth,
    Callback = function(state)
        if loadingControls then
            return
        end
        sharedEnv.ChickenAutoLeaveOnRebirth = state == true
        if not sharedEnv.ChickenAutoLeaveOnRebirth then
            sharedEnv.ChickenRebirthLeaveTriggered = false
            sharedEnv.ChickenRebirthLeaveState.triggered = false
        end
        sharedEnv.ChickenRebirthLeaveState.enabled = sharedEnv.ChickenAutoLeaveOnRebirth
        sharedEnv.ChickenRebirthLeaveState.target = sharedEnv.ChickenLeaveWhenRebirth
        saveSettings()
        Window:Notify({
            Title = "Auto Leave",
            Description = sharedEnv.ChickenAutoLeaveOnRebirth
                and (sharedEnv.ChickenLeaveWhenRebirth > 0
                    and ("Will leave at Rebirth #" .. tostring(sharedEnv.ChickenLeaveWhenRebirth))
                    or "Set Leave When Rebirth first")
                or "Disabled",
            Lifetime = 3,
        })
        print(
            "[Rebirth UI] Auto Leave:",
            sharedEnv.ChickenAutoLeaveOnRebirth and "on" or "off",
            sharedEnv.ChickenLeaveWhenRebirth
        )
    end,
}, "AutoLeaveOnRebirth")

RebirthInfoSection:Input({
    Name = "Leave After Minutes",
    Placeholder = "blank = off",
    Default = sharedEnv.ChickenLeaveAfterMinutes > 0
        and tostring(sharedEnv.ChickenLeaveAfterMinutes) or "",
    Callback = function(value)
        if loadingControls then
            return
        end
        local text = tostring(value or "")
        if text:match("^%s*$") then
            sharedEnv.ChickenLeaveAfterMinutes = 0
            sharedEnv.ChickenLeaveAfterMinutesStartedAt = 0
            sharedEnv.ChickenRebirthLeaveState.minutes = 0
            sharedEnv.ChickenRebirthLeaveState.minutesStartedAt = 0
            sharedEnv.ChickenRebirthLeaveState.minutesTriggered = false
            saveSettings()
            return
        end
        local parsed = parseNumberInput(text)
        if parsed and parsed > 0 then
            sharedEnv.ChickenLeaveAfterMinutes = math.clamp(parsed, 0.1, 1000000)
            sharedEnv.ChickenLeaveAfterMinutesStartedAt =
                sharedEnv.ChickenAutoLeaveAfterMinutes and os.clock() or 0
            sharedEnv.ChickenRebirthLeaveState.minutes = sharedEnv.ChickenLeaveAfterMinutes
            sharedEnv.ChickenRebirthLeaveState.minutesStartedAt =
                sharedEnv.ChickenLeaveAfterMinutesStartedAt
            sharedEnv.ChickenRebirthLeaveState.minutesTriggered = false
            saveSettings()
        else
            Window:Notify({
                Title = "Leave After Minutes",
                Description = "Enter minutes greater than 0, or leave blank to disable the timer",
                Lifetime = 3,
            })
        end
    end,
}, "LeaveAfterMinutes")

RebirthInfoSection:Toggle({
    Name = "Auto Leave After Minutes",
    Default = sharedEnv.ChickenAutoLeaveAfterMinutes,
    Callback = function(state)
        if loadingControls then
            return
        end
        sharedEnv.ChickenAutoLeaveAfterMinutes = state == true
        if sharedEnv.ChickenAutoLeaveAfterMinutes
            and sharedEnv.ChickenLeaveAfterMinutes > 0 then
            sharedEnv.ChickenLeaveAfterMinutesStartedAt = os.clock()
        else
            sharedEnv.ChickenLeaveAfterMinutesStartedAt = 0
            sharedEnv.ChickenRebirthLeaveState.minutesTriggered = false
        end
        sharedEnv.ChickenRebirthLeaveState.minutesEnabled =
            sharedEnv.ChickenAutoLeaveAfterMinutes
        sharedEnv.ChickenRebirthLeaveState.minutes = sharedEnv.ChickenLeaveAfterMinutes
        sharedEnv.ChickenRebirthLeaveState.minutesStartedAt =
            sharedEnv.ChickenLeaveAfterMinutesStartedAt
        saveSettings()
        Window:Notify({
            Title = "Auto Leave After Minutes",
            Description = sharedEnv.ChickenAutoLeaveAfterMinutes
                and (sharedEnv.ChickenLeaveAfterMinutes > 0
                    and ("Will leave after "
                        .. tostring(sharedEnv.ChickenLeaveAfterMinutes) .. " minutes")
                    or "Set Leave After Minutes first")
                or "Disabled",
            Lifetime = 3,
        })
        print(
            "[Rebirth UI] Auto Leave After Minutes:",
            sharedEnv.ChickenAutoLeaveAfterMinutes and "on" or "off",
            sharedEnv.ChickenLeaveAfterMinutes
        )
    end,
}, "AutoLeaveAfterMinutes")

-- MacLib's Paragraph:UpdateBody can raise a Plugin-capability error in
-- Potassium/Real after the window has been rebuilt.  That error used to be
-- swallowed by the status loop's pcall, leaving the first Rebirth snapshot
-- on screen forever.  The rendered ParagraphBody is a normal TextLabel, so
-- update that label directly first and only use MacLib as a creation-time
-- fallback.  Updating every matching copy also handles a brief overlap while
-- an old window is being unloaded during live-reload.
local function updateRebirthParagraphBody(body)
    local directUpdated = false
    pcall(function()
        for _, item in ipairs(CoreGui:GetDescendants()) do
            if item:IsA("TextLabel") and item.Text == "Tower / Rebirth Status" then
                local bodyLabel = item.Parent and item.Parent:FindFirstChild("ParagraphBody")
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    bodyLabel.Text = body
                    directUpdated = true
                end
            end
        end
    end)
    if directUpdated then
        return true
    end

    local ok = pcall(function()
        RebirthInfoParagraph:UpdateBody(body)
    end)
    return ok
end
local EggSection = EggTab:Section({
    Side = "Left",
})
local EggInfoSection = EggTab:Section({
    Side = "Right",
})
sharedEnv.ChickenUfuUI.Section = sharedEnv.ChickenUfuUI.Tab:Section({
    Side = "Left",
})
sharedEnv.ChickenUfuUI.InfoSection = sharedEnv.ChickenUfuUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenUfuUI.InfoParagraph = sharedEnv.ChickenUfuUI.InfoSection:Paragraph({
    Header = "Auto Chaos Status",
    Body = "Loading Event controller...",
})
sharedEnv.ChickenHatchingUI.Section = sharedEnv.ChickenHatchingUI.Tab:Section({
    Side = "Left",
})
sharedEnv.ChickenHatchingUI.InfoSection = sharedEnv.ChickenHatchingUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenAutoFuseUI.Section = sharedEnv.ChickenAutoFuseUI.Tab:Section({
    Side = "Left",
})
sharedEnv.ChickenAutoFuseUI.InfoSection = sharedEnv.ChickenAutoFuseUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenPromoteUI.Section = sharedEnv.ChickenPromoteUI.Tab:Section({
    Side = "Left",
})
sharedEnv.ChickenPromoteUI.InfoSection = sharedEnv.ChickenPromoteUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenPromoteUI.InfoParagraph = sharedEnv.ChickenPromoteUI.InfoSection:Paragraph({
    Header = "Auto Promote Status",
    Body = "Loading promotion controller...",
})
sharedEnv.ChickenAutoFuseUI.InfoParagraph = sharedEnv.ChickenAutoFuseUI.InfoSection:Paragraph({
    Header = "Auto Fuse Status",
    Body = "Disabled\nFavorite chickens are always protected.",
})
local EggInfoParagraph = EggInfoSection:Paragraph({
    Header = "Egg Collection Status",
    Body = "Loading egg status...",
})
sharedEnv.ChickenHatchingUI.InfoParagraph = sharedEnv.ChickenHatchingUI.InfoSection:Paragraph({
    Header = "Hatching Status",
    Body = "Loading hatching status...",
})
-- Egg catalog is informational only: it lets the player inspect where an egg
-- comes from and the normalized hatch chance of every chicken inside it.
sharedEnv.ChickenEggCatalogUI = {
    Section = EggTab:Section({
        Side = "Right",
    }),
}
local EggInventorySection = EggTab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Section = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Left",
})
sharedEnv.ChickenStatsUI.InfoSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5Section = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5AtkSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5HpAtkSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5SkillOverallSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5SkillDuelSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5SkillTankSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5SkillAoeSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.Top5LaySection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.CompareSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
sharedEnv.ChickenStatsUI.CardSection = sharedEnv.ChickenStatsUI.Tab:Section({
    Side = "Right",
})
local EggInventoryParagraph = EggInventorySection:Paragraph({
    Header = "Egg Inventory",
    Body = "Loading inventory...",
})
sharedEnv.ChickenStatsUI.InfoParagraph = sharedEnv.ChickenStatsUI.InfoSection:Paragraph({
    Header = "Chicken Stats Catalog",
    Body = "Loading 149 chicken types...",
})

-- Build the initial owned-chicken choices when the Egg page is created.  The
-- Fast Coop controller refreshes these choices from the roster after hatching;
-- the server still validates the chicken object when SetActiveChicken is invoked.
sharedEnv.ChickenFastIncubatorOptions = {}
sharedEnv.ChickenFastIncubatorSourceOptions = {}
sharedEnv.ChickenFastIncubatorTargetOptions = {}
sharedEnv.ChickenFastIncubatorOptionMap = {}
sharedEnv.ChickenFastIncubatorOptionSignature = nil
sharedEnv.ChickenFastIncubatorRosterById = {}
sharedEnv.ChickenFastIncubatorSourceDefault = nil
sharedEnv.ChickenFastIncubatorTargetDefault = nil
do
    local optionRows = {}
    local rosterOk, rosterData = pcall(function()
        return DataService.client:get({"roster"}) or {}
    end)
    local catalog
    local genomeModule
    pcall(function()
        catalog = loadModule(ReplicatedStorage:WaitForChild("Content"):WaitForChild("Catalog"):WaitForChild("ChickenTypes"))
    end)
    pcall(function()
        genomeModule = loadModule(ReplicatedStorage:WaitForChild("Features"):WaitForChild("Chicken"):WaitForChild("Genome"))
    end)
    local chickens = rosterOk and type(rosterData) == "table" and rosterData.chickens or {}
    if type(chickens) == "table" then
        for _, chicken in ipairs(chickens) do
            if type(chicken) == "table" and type(chicken.id) == "string" then
                local typeInfo = catalog and catalog[chicken.typeId]
                local layPeriod = tonumber(typeInfo and typeInfo.layPeriod) or 999999
                if genomeModule and type(genomeModule.layMult) == "function" then
                    local multOk, mult = pcall(genomeModule.layMult, chicken.genome)
                    if multOk and tonumber(mult) then
                        layPeriod = layPeriod * tonumber(mult)
                    end
                end
                local name
                if type(chicken.nickname) == "string" and chicken.nickname ~= "" then
                    -- Keep a player's custom chicken name exactly as entered.
                    name = chicken.nickname
                else
                    name = tostring(chicken.typeId or chicken.id)
                        :gsub("(%l)(%u)", "%1 %2")
                        :gsub("_", " ")
                end
                local display = name .. " (" .. tostring(math.floor(layPeriod + 0.5)) .. "s)"
                table.insert(optionRows, {
                    id = chicken.id,
                    display = display,
                    layPeriod = layPeriod,
                    chicken = chicken,
                })
                sharedEnv.ChickenFastIncubatorRosterById[chicken.id] = chicken
            end
        end
    end
    -- The active Incubator chicken is omitted from the roster snapshot while
    -- it is being incubated; include it so a saved source/target selection is
    -- not lost during a reload.
    local incubatorOk, incubatorSnapshot = pcall(function()
        return DataService.client:get({"incubator"}) or {}
    end)
    local activeIncubatorChicken = incubatorOk and type(incubatorSnapshot) == "table"
        and incubatorSnapshot.chicken
    if type(activeIncubatorChicken) == "table"
        and type(activeIncubatorChicken.id) == "string"
        and not sharedEnv.ChickenFastIncubatorRosterById[activeIncubatorChicken.id] then
        local typeInfo = catalog and catalog[activeIncubatorChicken.typeId]
        local layPeriod = tonumber(typeInfo and typeInfo.layPeriod) or 999999
        if genomeModule and type(genomeModule.layMult) == "function" then
            local multOk, mult = pcall(genomeModule.layMult, activeIncubatorChicken.genome)
            if multOk and tonumber(mult) then
                layPeriod = layPeriod * tonumber(mult)
            end
        end
        local name
        if type(activeIncubatorChicken.nickname) == "string" and activeIncubatorChicken.nickname ~= "" then
            name = activeIncubatorChicken.nickname
        else
            name = tostring(activeIncubatorChicken.typeId or activeIncubatorChicken.id)
                :gsub("(%l)(%u)", "%1 %2")
                :gsub("_", " ")
        end
        table.insert(optionRows, {
            id = activeIncubatorChicken.id,
            display = name .. " (" .. tostring(math.floor(layPeriod + 0.5)) .. "s)",
            layPeriod = layPeriod,
            chicken = activeIncubatorChicken,
        })
        sharedEnv.ChickenFastIncubatorRosterById[activeIncubatorChicken.id] = activeIncubatorChicken
    end
    table.sort(optionRows, function(a, b)
        if a.layPeriod == b.layPeriod then
            return a.display < b.display
        end
        return a.layPeriod < b.layPeriod
    end)
    local displayCounts = {}
    local displaySeen = {}
    for _, row in ipairs(optionRows) do
        displayCounts[row.display] = (displayCounts[row.display] or 0) + 1
    end
    for index, row in ipairs(optionRows) do
        displaySeen[row.display] = (displaySeen[row.display] or 0) + 1
        local display = row.display
        if (displayCounts[row.display] or 0) > 1 then
            display = display .. " #" .. tostring(displaySeen[row.display])
        end
        table.insert(sharedEnv.ChickenFastIncubatorOptions, display)
        sharedEnv.ChickenFastIncubatorOptionMap[display] = row.id
        if row.id == sharedEnv.ChickenFastIncubatorSourceId then
            sharedEnv.ChickenFastIncubatorSourceDefault = index
        end
        if row.id == sharedEnv.ChickenFastIncubatorTargetId then
            sharedEnv.ChickenFastIncubatorTargetDefault = index
        end
    end
    if #sharedEnv.ChickenFastIncubatorOptions == 0 then
        table.insert(sharedEnv.ChickenFastIncubatorOptions, "(No owned chickens)")
    end

    -- Keep the currently selected chicken at the top of each dropdown while
    -- preserving the fastest-to-slowest order for all remaining entries.
    local sourceSelected
    local targetSelected
    for _, display in ipairs(sharedEnv.ChickenFastIncubatorOptions) do
        local id = sharedEnv.ChickenFastIncubatorOptionMap[display]
        if id == sharedEnv.ChickenFastIncubatorSourceId then
            sourceSelected = display
        else
            table.insert(sharedEnv.ChickenFastIncubatorSourceOptions, display)
        end
        if id == sharedEnv.ChickenFastIncubatorTargetId then
            targetSelected = display
        else
            table.insert(sharedEnv.ChickenFastIncubatorTargetOptions, display)
        end
    end
    if sourceSelected then
        table.insert(sharedEnv.ChickenFastIncubatorSourceOptions, 1, sourceSelected)
        sharedEnv.ChickenFastIncubatorSourceDefault = 1
    else
        sharedEnv.ChickenFastIncubatorSourceOptions = sharedEnv.ChickenFastIncubatorOptions
    end
    if targetSelected then
        table.insert(sharedEnv.ChickenFastIncubatorTargetOptions, 1, targetSelected)
        sharedEnv.ChickenFastIncubatorTargetDefault = 1
    else
        sharedEnv.ChickenFastIncubatorTargetOptions = sharedEnv.ChickenFastIncubatorOptions
    end
end

-- Static Catalog stats page.  The Catalog contains every chicken type in the
-- game, including types that are not present in the current Flock.  The
-- displayed values are selected-level values with the chosen neutral genome
-- projection and no mutation;
-- SPD/PWR follow the game's +/- percentage modifier display;
-- owned nicknames are attached to the corresponding Catalog type when one is
-- available.
do
local CatalogData = loadModule(ReplicatedStorage.Content.Catalog)
local GameConfigData = loadModule(ReplicatedStorage.Content.GameConfig)
local DropTablesData = loadModule(ReplicatedStorage.Content.DropTables)
local statsState = sharedEnv.ChickenStatsState
local statsUi = sharedEnv.ChickenStatsUI
-- Stats maintenance is view-scoped.  MacLib lazy-mounts the page, so keep a
-- cheap flag updated by the tab switcher instead of repeatedly scanning all
-- CoreGui descendants while another tab is open.  Store it in sharedEnv to
-- avoid consuming another local register in this large Catalog scope.
sharedEnv.ChickenStatsTabVisible = false
sharedEnv.ChickenArenaTabVisible = false
local STATS_MAX_VISIBLE_CARDS = 12
local STATS_DROPDOWN_VISIBLE_ROWS = 5
local STATS_DROPDOWN_ROW_HEIGHT = 30
local STATS_DROPDOWN_ROW_GAP = 5
local STATS_DROPDOWN_LIST_HEIGHT = STATS_DROPDOWN_VISIBLE_ROWS * STATS_DROPDOWN_ROW_HEIGHT
    + math.max(0, STATS_DROPDOWN_VISIBLE_ROWS - 1) * STATS_DROPDOWN_ROW_GAP
local STATS_DROPDOWN_MAX_HEIGHT = 430
local statsCatalog = type(CatalogData) == "table" and CatalogData.chickenTypes or {}
local statsAbilities = type(CatalogData) == "table" and CatalogData.abilities or {}
-- The Catalog only contains the short, player-facing ability blurb.  The
-- combat module keeps the actual timing, hit pattern, damage multipliers and
-- effects in GameConfig.combat.abilities; keep that table alongside the
-- Catalog so the stat cards can expose the mechanics without inventing fixed
-- damage values.
local statsAbilityMechanics = type(GameConfigData) == "table"
    and type(GameConfigData.combat) == "table"
    and type(GameConfigData.combat.abilities) == "table"
    and GameConfigData.combat.abilities or {}
local statsAbilityMechanicAliases = {}
for mechanicId, mechanic in pairs(statsAbilityMechanics) do
    if type(mechanic) == "table" then
        statsAbilityMechanicAliases[string.lower(tostring(mechanicId))] = mechanic
    end
end
local statsEggCatalog = type(CatalogData) == "table" and CatalogData.eggs or {}
local statsEggPools = type(DropTablesData) == "table"
    and type(DropTablesData.eggPool) == "table" and DropTablesData.eggPool or {}
local statsEggInfoById = {}
local statsEggAliases = {}
local statsOwnedByType = {}
local statsOwnedCountByType = {}
local statsRows = {}
local statsOptionToType = {}
local statsTypeToOption = {}
-- Lightweight data fingerprint used only when Stats is opened.  The UI cache
-- stays hot between opens, while a changed Catalog/ability key or chicken
-- metadata triggers a targeted rebuild instead of rebuilding every 0.5s.
sharedEnv.ChickenStatsCatalogFingerprintOf = function(catalog, eggs, abilities, pools)
    local groups = {}
    local function appendGroup(tag, source)
        local entries = {}
        for key, value in pairs(type(source) == "table" and source or {}) do
            local detail = ""
            if type(value) == "table" then
                local archetype = type(value.archetype) == "table" and value.archetype or {}
                detail = table.concat({
                    tostring(value.name or ""),
                    tostring(value.rarity or ""),
                    tostring(value.signature or ""),
                    tostring(value.kind or ""),
                    tostring(value.type or ""),
                    tostring(value.blurb or value.description or value.desc or ""),
                    tostring(value.icon or ""),
                    tostring(value.layPeriod or ""),
                    tostring(archetype.hp or ""),
                    tostring(archetype.atk or ""),
                    tostring(archetype.speed or ""),
                    tostring(archetype.stamina or ""),
                }, ":")
            end
            table.insert(entries, tostring(key) .. "=" .. detail)
        end
        table.sort(entries)
        table.insert(groups, tag .. "{" .. table.concat(entries, ";") .. "}")
    end
    appendGroup("chicken", catalog)
    appendGroup("egg", eggs)
    appendGroup("ability", abilities)
    appendGroup("pool", pools)
    return table.concat(groups, "|")
end
local statsTop5State = {
    visible = false,
    skillVisible = false,
    layVisible = false,
    compareVisible = false,
}
local statsCompareState = {
    selected = {},
    optionToType = {},
    typeToOption = {},
    optionOrder = {},
    options = {},
    dropdown = nil,
    paragraph = nil,
    reordering = false,
}
local statsFullWidthState = {
    applied = false,
    left = nil,
    right = nil,
    leftSize = nil,
    rightVisible = nil,
    moved = {},
}
-- Cache the small set of Stats paragraph labels that MacLib mounts into
-- CoreGui.  Repeatedly walking every CoreGui descendant once per card/section
-- made opening Stats hitch noticeably (the picker has hundreds of option
-- buttons).  The cache is invalidated when a lazy-mounted Stats header appears.
sharedEnv.ChickenStatsGuiCache = {
    dirty = true,
    byHeader = {},
    headers = {
        ["Chicken Stats Catalog"] = true,
        ["TOP 5 Rank by Overall • Equal Weight"] = true,
        ["TOP 5 Rank by HP / ATK"] = true,
        ["TOP 5 Rank by ATK / HP"] = true,
        ["TOP 5 Skill • Overall"] = true,
        ["TOP 5 Skill • 1v1"] = true,
        ["TOP 5 Skill • Tank / Sustain"] = true,
        ["TOP 5 Skill • AOE"] = true,
        ["TOP 5 Lay Egg • Fastest"] = true,
        ["COMPARE Skill Damage"] = true,
        ["Chicken Stat Card 1"] = true,
    },
}
sharedEnv.ChickenStatsDropdownCache = {
    dirty = true,
    frames = {},
}

sharedEnv.ChickenStatsGetDropdownFrames = function()
    local cache = sharedEnv.ChickenStatsDropdownCache
    if not cache.dirty then
        return cache.frames
    end
    local frames = {}
    pcall(function()
        for _, dropdown in ipairs(CoreGui:GetDescendants()) do
            if dropdown:IsA("Frame") and dropdown.Name == "Dropdown" then
                local nameLabel = dropdown:FindFirstChild("DropdownName")
                if nameLabel
                    and string.find(nameLabel.Text or "", "Select Chickens (Multi-select)", 1, true) then
                    table.insert(frames, dropdown)
                end
            end
        end
    end)
    cache.frames = frames
    -- Keep looking until MacLib lazily mounts the Stats picker.  Once found,
    -- later refreshes use the cached Frame instead of scanning CoreGui.
    cache.dirty = #frames == 0
    return frames
end

sharedEnv.ChickenStatsEnsureGuiCache = function()
    local cache = sharedEnv.ChickenStatsGuiCache
    if not cache.dirty then
        return
    end
    local byHeader = {}
    pcall(function()
        for _, item in ipairs(CoreGui:GetDescendants()) do
            if item:IsA("TextLabel") and cache.headers[item.Text] then
                local list = byHeader[item.Text]
                if not list then
                    list = {}
                    byHeader[item.Text] = list
                end
                table.insert(list, item)
            end
        end
    end)
    cache.byHeader = byHeader
    cache.dirty = false
end

local function statsNumber(value)
    local number = tonumber(value) or 0
    if number ~= number then
        return "—"
    end
    if number == math.huge then
        return "∞"
    elseif number == -math.huge then
        return "-∞"
    end
    local magnitude = math.abs(number)
    local divisor = 1
    local suffix = ""
    if magnitude >= 1000000000000 then
        divisor = 1000000000000
        suffix = "t"
    elseif magnitude >= 1000000000 then
        divisor = 1000000000
        suffix = "b"
    elseif magnitude >= 1000000 then
        divisor = 1000000
        suffix = "m"
    elseif magnitude >= 1000 then
        divisor = 1000
        suffix = "k"
    end
    local display = number / divisor
    if divisor > 1 then
        return string.format("%.2f", display):gsub("0+$", ""):gsub("%.$", "") .. suffix
    end
    if math.floor(display) == display then
        return tostring(math.floor(display))
    end
    return string.format("%.2f", display):gsub("0+$", ""):gsub("%.$", "")
end

local function statsSignedPercent(multiplier)
    local number = tonumber(multiplier) or 1
    local percent = math.floor((number - 1) * 100 + 0.5)
    if percent > 0 then
        return "+" .. tostring(percent) .. "%"
    end
    return tostring(percent) .. "%"
end

sharedEnv.ChickenStatsLevelValue = function(base, growth, level)
    local baseValue = tonumber(base) or 0
    local growthValue = tonumber(growth) or 1
    local levelNumber = math.max(1, math.floor(tonumber(level) or 1))
    local cap = tonumber(sharedEnv.ChickenStatsLevelCap)
    if cap then
        levelNumber = math.min(levelNumber, math.max(1, math.floor(cap)))
    end
    return baseValue * (growthValue ^ math.max(0, levelNumber - 1))
end

sharedEnv.ChickenGenomeCap = function(rarity)
    local key = string.lower(tostring(rarity or ""))
    local cap = sharedEnv.ChickenGenomeCaps and sharedEnv.ChickenGenomeCaps[key]
    return tonumber(cap) or tonumber(sharedEnv.ChickenGenomeMax) or 31
end

sharedEnv.ChickenGenomeMultipliers = function(value)
    local maxValue = tonumber(sharedEnv.ChickenGenomeMax) or 31
    local gene = math.clamp(tonumber(value) or 0, 0, maxValue)
    local ratio = maxValue > 0 and gene / maxValue or 0
    return {
        strength = 1 + ratio * 0.5,
        pacing = 1 + ratio * 0.15,
        fertility = 1 - ratio * 0.4,
    }
end

local function statsRichText(value)
    local text = tostring(value or "")
    text = text:gsub("&", "&amp;")
        :gsub("<", "&lt;")
        :gsub(">", "&gt;")
        :gsub('"', "&quot;")
    return text
end

local statsRarityColors = {
    common = "#B8C0CC",
    rare = "#55D98A",
    epic = "#5BC0EB",
    legendary = "#C084FC",
    mythic = "#FF9F43",
    divine = "#FFD166",
    secret = "#FF6BCE",
}

local function statsRarityColor(rarity)
    return statsRarityColors[string.lower(tostring(rarity or ""))] or "#D7DEE9"
end

-- Build stable egg aliases once.  Catalog versions have used both ids and
-- display names for egg references, so source lookup accepts either form.
for eggId, eggInfo in pairs(statsEggCatalog) do
    local id = tostring(eggId)
    statsEggInfoById[id] = eggInfo
    statsEggAliases[string.lower(id)] = id
    if type(eggInfo) == "table" and eggInfo.name then
        statsEggAliases[string.lower(tostring(eggInfo.name))] = id
    end
end

do
    local rosterOk, rosterData = pcall(function()
        return DataService.client:get({"roster"}) or {}
    end)
    local roster = rosterOk and type(rosterData) == "table" and rosterData or {}
    if type(roster.roster) == "table" then
        roster = roster.roster
    end
    local chickens = type(roster.chickens) == "table" and roster.chickens or {}
    for _, chicken in ipairs(chickens) do
        if type(chicken) == "table" and type(chicken.typeId) == "string" then
            statsOwnedCountByType[chicken.typeId] = (statsOwnedCountByType[chicken.typeId] or 0) + 1
            local owned = statsOwnedByType[chicken.typeId]
            if not owned then
                owned = {}
                statsOwnedByType[chicken.typeId] = owned
            end
            local nickname = type(chicken.nickname) == "string" and chicken.nickname or ""
            if nickname ~= "" then
                table.insert(owned, nickname)
            end
        end
    end

    local baseStats = type(GameConfigData) == "table"
        and type(GameConfigData.chicken) == "table"
        and GameConfigData.chicken.base or {}
    local growthStats = type(GameConfigData) == "table"
        and type(GameConfigData.chicken) == "table"
        and GameConfigData.chicken.growth or {}
    -- The live game currently exposes chicken.maxLevel as "inf".  Keep a
    -- finite cap when a future game update adds one, otherwise the picker is
    -- intentionally unbounded just like the game's own progression.
    sharedEnv.ChickenStatsLevelCap = type(GameConfigData) == "table"
        and type(GameConfigData.chicken) == "table"
        and tonumber(GameConfigData.chicken.maxLevel) or nil
    if sharedEnv.ChickenStatsLevelCap and sharedEnv.ChickenStatsLevelCap < math.huge then
        sharedEnv.ChickenStatsLevelCap = math.max(1, math.floor(sharedEnv.ChickenStatsLevelCap))
        statsState.baseLevel = math.min(statsState.baseLevel, sharedEnv.ChickenStatsLevelCap)
    else
        sharedEnv.ChickenStatsLevelCap = nil
    end
    sharedEnv.ChickenGenomeCaps = type(GameConfigData) == "table"
        and type(GameConfigData.fusion) == "table"
        and type(GameConfigData.fusion.geneCap) == "table"
        and GameConfigData.fusion.geneCap or {}
    sharedEnv.ChickenGenomeMax = type(GameConfigData) == "table"
        and type(GameConfigData.fusion) == "table"
        and tonumber(GameConfigData.fusion.geneMax) or 31
    if sharedEnv.ChickenGenomeMax < 1 then
        sharedEnv.ChickenGenomeMax = 31
    end
    if sharedEnv.ChickenGenomeMax > 0 then
        statsState.genomeStat = math.min(statsState.genomeStat, sharedEnv.ChickenGenomeMax)
    end
    local function eggLabel(eggId)
        local eggInfo = statsEggInfoById[tostring(eggId)] or statsEggCatalog[eggId]
        if type(eggInfo) == "table" and type(eggInfo.name) == "string" then
            return eggInfo.name
        end
        return tostring(eggId):gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
    end

    local function eggSummary(info)
        local eggs = type(info.eggs) == "table" and info.eggs or {}
        local parts = {}
        for eggId, chance in pairs(eggs) do
            table.insert(parts, eggLabel(eggId) .. " " .. statsNumber(chance) .. "%")
        end
        table.sort(parts)
        return #parts > 0 and table.concat(parts, ", ") or "None"
    end

    local statsTypeAliases = {}
    for typeId, chickenInfo in pairs(statsCatalog) do
        local id = tostring(typeId)
        statsTypeAliases[string.lower(id)] = id
        if type(chickenInfo) == "table" and chickenInfo.name then
            statsTypeAliases[string.lower(tostring(chickenInfo.name))] = id
        end
    end

    local function statsResolveTypeId(value)
        if type(value) == "table" then
            value = value.typeId or value.chickenTypeId or value.chickenId
                or value.chicken or value.name or value.id
        end
        if value == nil then
            return nil
        end
        return statsTypeAliases[string.lower(tostring(value))]
    end

    local function statsResolveEggId(value)
        if type(value) == "table" then
            value = value.eggId or value.eggTypeId or value.egg
                or value.name or value.id
        end
        if value == nil then
            return nil
        end
        return statsEggAliases[string.lower(tostring(value))]
    end

    local function statsChanceValue(value)
        local number = tonumber(value)
        if number then
            return number
        end
        if type(value) ~= "table" then
            return nil
        end
        for _, key in ipairs({
            "chance", "Chance", "odds", "Odds", "probability", "Probability",
            "percent", "percentage", "Percent", "weight", "Weight", "rate", "Rate",
            "hatchChance", "dropChance", "chancePercent", "value",
        }) do
            number = tonumber(value[key])
            if number then
                return number
            end
        end
        return nil
    end

    -- Find the hatch chance for one chicken in an egg entry without assuming
    -- one exact Catalog schema.  This handles maps such as
    -- {ChickenType = 50}, records such as {typeId=..., chance=50}, and
    -- parallel arrays such as {chickens={...}, chances={...}}.
    local function statsFindEggChance(eggInfo, targetTypeId)
        local result
        local visited = {}
        local function visit(node, depth)
            if result ~= nil or type(node) ~= "table" or depth > 6 or visited[node] then
                return
            end
            visited[node] = true

            local nodeTypeId = statsResolveTypeId(node)
            if nodeTypeId == targetTypeId then
                local nodeChance = statsChanceValue(node)
                if nodeChance ~= nil then
                    result = nodeChance
                    return
                end
            end

            for _, poolKey in ipairs({
                "chickens", "chickenTypes", "contents", "drops", "pool", "items",
                "hatchPool", "entries", "results", "possibleChickens", "rewards",
                "chickenOdds", "hatchChances", "dropChances",
            }) do
                local pool = node[poolKey]
                if type(pool) == "table" then
                    local chances = node.chances or node.Chances or node.rates
                        or node.weights or node.odds or node.probabilities
                        or node.percentages or node.hatchChances or node.dropChances
                    for index, entry in ipairs(pool) do
                        if statsResolveTypeId(entry) == targetTypeId then
                            local entryChance = statsChanceValue(entry)
                                or (type(chances) == "table" and statsChanceValue(chances[index]))
                            if entryChance ~= nil then
                                result = entryChance
                                return
                            end
                        end
                    end
                end
            end

            for key, value in pairs(node) do
                if statsResolveTypeId(key) == targetTypeId then
                    local keyedChance = statsChanceValue(value)
                    if keyedChance ~= nil then
                        result = keyedChance
                        return
                    end
                end
                if type(value) == "table" then
                    visit(value, depth + 1)
                    if result ~= nil then
                        return
                    end
                end
            end
        end
        visit(eggInfo, 0)
        return result
    end

    local function statsCollectEggRefs(value, output, directChances, allowDirect)
        if type(value) == "string" or type(value) == "number" then
            local eggId = statsResolveEggId(value)
            if eggId then
                output[eggId] = true
            end
            return
        end
        if type(value) ~= "table" then
            return
        end
        local directEggId = statsResolveEggId(value)
        if directEggId then
            output[directEggId] = true
            local directChance = allowDirect and statsChanceValue(value) or nil
            if directChance ~= nil then
                directChances[directEggId] = directChance
            end
        end
        for key, item in pairs(value) do
            local eggId = statsResolveEggId(key)
            if eggId then
                output[eggId] = true
                if allowDirect then
                    local directChance = statsChanceValue(item)
                    if directChance ~= nil then
                        directChances[eggId] = directChance
                    end
                end
            end
            if type(item) == "table" then
                statsCollectEggRefs(item, output, directChances, allowDirect)
            elseif type(item) == "string" or type(item) == "number" then
                local itemEggId = statsResolveEggId(item)
                if itemEggId then
                    output[itemEggId] = true
                end
            end
        end
    end

    local function statsEggPoolTotal(eggInfo)
        if type(eggInfo) ~= "table" then
            return nil
        end
        local total = 0
        local count = 0
        -- Current game data is a direct { chickenTypeId = weight } map.
        for key, value in pairs(eggInfo) do
            if statsResolveTypeId(key) then
                local weight = statsChanceValue(value)
                if weight ~= nil and weight >= 0 then
                    total += weight
                    count += 1
                end
            end
        end
        if count > 0 then
            return total
        end

        -- Keep support for Catalog revisions that store parallel arrays.
        for _, poolKey in ipairs({
            "chickens", "chickenTypes", "contents", "drops", "pool", "items",
            "hatchPool", "entries", "results", "possibleChickens", "rewards",
            "chickenOdds", "hatchChances", "dropChances",
        }) do
            local pool = eggInfo[poolKey]
            if type(pool) == "table" then
                local chances = eggInfo.chances or eggInfo.Chances or eggInfo.rates
                    or eggInfo.weights or eggInfo.odds or eggInfo.probabilities
                    or eggInfo.percentages or eggInfo.hatchChances or eggInfo.dropChances
                for index, entry in ipairs(pool) do
                    local weight = statsChanceValue(entry)
                        or (type(chances) == "table" and statsChanceValue(chances[index]))
                    if weight ~= nil and weight >= 0 then
                        total += weight
                        count += 1
                    end
                end
            end
        end
        return count > 0 and total or nil
    end

    local function statsPercent(value)
        local number = tonumber(value)
        return number and string.format("%.1f", number) or nil
    end

    local function eggSourceSummary(info, typeId)
        local sourceRefs = {}
        local directChances = {}
        local sourceFields = {
            "hatchFrom", "hatchedFrom", "sourceEgg", "sourceEggs", "eggSource",
            "eggSources", "hatchSources", "sources", "fromEgg", "fromEggs",
            "hatch", "hatchEgg", "hatchEggs", "eggType", "eggTypes", "originEgg",
        }
        for _, field in ipairs(sourceFields) do
            if info[field] ~= nil then
                statsCollectEggRefs(info[field], sourceRefs, directChances, true)
            end
        end

        -- Some Catalog revisions only keep the egg ids on `eggs`.  Treat
        -- those as tentative references: in the current game this field is
        -- the chicken's lay table, not its hatch source list.
        if next(sourceRefs) == nil and type(info.eggs) == "table" then
            statsCollectEggRefs(info.eggs, sourceRefs, directChances, false)
        end

        local function buildSourceParts()
            local parts = {}
            for eggId in pairs(sourceRefs) do
                local poolChance = statsFindEggChance(statsEggPools[eggId], typeId)
                local chance = poolChance
                    or statsFindEggChance(statsEggInfoById[eggId], typeId)
                    or directChances[eggId]
                -- DropTables stores weights.  Normalize them against the
                -- whole egg pool so Found in matches the game's displayed
                -- chance (e.g. Charm Plush Chick: 24/164 = 14.6%).
                if poolChance ~= nil then
                    local total = statsEggPoolTotal(statsEggPools[eggId])
                    if total and total > 0 then
                        chance = poolChance / total * 100
                    end
                end
                -- Never use a chicken's lay chance as its hatch chance.
                if chance ~= nil then
                    table.insert(parts, eggLabel(eggId) .. " " .. statsPercent(chance) .. "%")
                end
            end
            table.sort(parts)
            return parts
        end

        local parts = buildSourceParts()
        -- If tentative/explicit references produced no confirmed source,
        -- reverse-index every real egg hatch pool.  This handles the current
        -- Catalog where `info.eggs` is lay-only and the source relation lives
        -- in DropTables.eggPool.
        if #parts == 0 then
            sourceRefs = {}
            directChances = {}
            for eggId, eggInfo in pairs(statsEggPools) do
                if statsFindEggChance(eggInfo, typeId) ~= nil then
                    sourceRefs[eggId] = true
                end
            end
            parts = buildSourceParts()
        end
        return #parts > 0 and table.concat(parts, ", ") or "Unknown"
    end

    -- Egg catalog ------------------------------------------------------------
    -- Catalog.eggs contains the player-facing egg names while DropTables.eggPool
    -- contains the actual weighted hatch pool.  Keep this viewer beside the
    -- Egg tab so the user can inspect both the chicken source and the normalized
    -- chance without changing any hatching/automation settings.
    sharedEnv.ChickenEggCatalog = (function()
        local state = {
            selectedEggId = statsState.selectedEggId,
            selectionTouched = false,
            visualReady = false,
            options = {},
            optionToId = {},
            defaultIndex = nil,
        }
        local ui = sharedEnv.ChickenEggCatalogUI

        local function getEggInfo(eggId)
            local id = tostring(eggId or "")
            return statsEggInfoById[id] or statsEggCatalog[id] or {}
        end

        local function eggName(eggId)
            local info = getEggInfo(eggId)
            if type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
                return info.name
            end
            return tostring(eggId):gsub("(%l)(%u)", "%1 %2")
                :gsub("_", " "):gsub("^%l", string.upper)
        end

        local function chickenName(typeId)
            local info = statsCatalog[typeId] or statsCatalog[tostring(typeId)]
            if type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
                return info.name
            end
            return tostring(typeId):gsub("(%l)(%u)", "%1 %2")
                :gsub("_", " "):gsub("^%l", string.upper)
        end

        local function chickenRarity(typeId)
            local info = statsCatalog[typeId] or statsCatalog[tostring(typeId)]
            return type(info) == "table" and tostring(info.rarity or "unknown") or "unknown"
        end

        local function rarityMarkup(rarity)
            local text = tostring(rarity or "unknown")
            return "<font color=\"" .. statsRarityColor(text) .. "\">["
                .. statsRichText(text) .. "]</font>"
        end

        local function percentText(value)
            local number = tonumber(value)
            return number and string.format("%.1f%%", number) or "—"
        end

        local function sourceRows(eggId)
            local rows = {}
            for typeId, info in pairs(statsCatalog) do
                if type(info) == "table" and type(info.eggs) == "table" then
                    local matched = false
                    local layChance
                    for key, value in pairs(info.eggs) do
                        if statsResolveEggId(key) == eggId then
                            matched = true
                            layChance = statsChanceValue(value)
                            break
                        end
                        if statsResolveEggId(value) == eggId then
                            matched = true
                            layChance = statsChanceValue(value)
                            break
                        end
                    end
                    if matched then
                        table.insert(rows, {
                            name = tostring(info.name or chickenName(typeId)),
                            rarity = tostring(info.rarity or "unknown"),
                            layChance = layChance,
                        })
                    end
                end
            end
            table.sort(rows, function(a, b)
                if a.layChance ~= b.layChance then
                    return (tonumber(a.layChance) or -math.huge)
                        > (tonumber(b.layChance) or -math.huge)
                end
                return string.lower(a.name) < string.lower(b.name)
            end)
            return rows
        end

        local function contentRows(eggId)
            local eggInfo = statsEggPools[eggId] or getEggInfo(eggId)
            local rows = {}
            local seen = {}
            local total = tonumber(statsEggPoolTotal(eggInfo)) or 0

            local function add(typeId, weight)
                typeId = statsResolveTypeId(typeId)
                weight = tonumber(weight)
                if typeId and weight and weight >= 0 and not seen[typeId] then
                    seen[typeId] = true
                    table.insert(rows, {typeId = typeId, weight = weight})
                    if total <= 0 then
                        total += weight
                    end
                end
            end

            if type(eggInfo) == "table" then
                -- Current game schema: { chickenTypeId = weight }.
                for key, value in pairs(eggInfo) do
                    add(key, statsChanceValue(value))
                end

                -- Compatibility with array/record schemas used by older data.
                if #rows == 0 then
                    for _, poolKey in ipairs({
                        "chickens", "chickenTypes", "contents", "drops", "pool", "items",
                        "hatchPool", "entries", "results", "possibleChickens", "rewards",
                        "chickenOdds", "hatchChances", "dropChances",
                    }) do
                        local pool = eggInfo[poolKey]
                        if type(pool) == "table" then
                            local chances = eggInfo.chances or eggInfo.Chances or eggInfo.rates
                                or eggInfo.weights or eggInfo.odds or eggInfo.probabilities
                                or eggInfo.percentages or eggInfo.hatchChances or eggInfo.dropChances
                            for index, entry in ipairs(pool) do
                                add(entry, statsChanceValue(entry)
                                    or (type(chances) == "table"
                                        and statsChanceValue(chances[index])))
                            end
                        end
                    end
                end
            end

            if total <= 0 then
                total = 1
            end
            for _, row in ipairs(rows) do
                row.name = chickenName(row.typeId)
                row.rarity = chickenRarity(row.typeId)
                row.percent = row.weight / total * 100
            end
            table.sort(rows, function(a, b)
                if a.percent == b.percent then
                    return string.lower(a.name) < string.lower(b.name)
                end
                return a.percent > b.percent
            end)
            return rows
        end

        local function buildBody(eggId)
            if type(eggId) ~= "string" or eggId == "" then
                return "<font color=\"#B8C0CC\">No egg selected. Choose an egg above to view its details.</font>"
            end
            local info = getEggInfo(eggId)
            local status = info.granted and "Granted" or (info.paid and "Paid" or "Free")
            local sources = sourceRows(eggId)
            local contents = contentRows(eggId)
            local lines = {
                "<font size=\"15\"><b>🥚 " .. statsRichText(eggName(eggId)) .. "</b></font>",
                "<font color=\"#B8C0CC\">ID: " .. statsRichText(eggId) .. " • " .. status .. "</font>",
                "",
                "<font color=\"#FFD166\"><b>FROM CHICKENS (" .. tostring(#sources) .. ")</b></font>",
            }
            if #sources == 0 then
                table.insert(lines, "<font color=\"#B8C0CC\">No source chicken (event/granted egg)</font>")
            else
                for index, row in ipairs(sources) do
                    local line = string.format("%d  %s %s  %s", index,
                        statsRichText(row.name), rarityMarkup(row.rarity), percentText(row.layChance))
                    table.insert(lines, line)
                end
            end

            table.insert(lines, "")
            table.insert(lines, "<font color=\"#7BE495\"><b>HATCH CHANCES (" .. tostring(#contents) .. ")</b></font>")
            if #contents == 0 then
                table.insert(lines, "<font color=\"#B8C0CC\">No hatch pool data found</font>")
            else
                for index, row in ipairs(contents) do
                    table.insert(lines, string.format("%d  %s %s  %s", index,
                        statsRichText(row.name), rarityMarkup(row.rarity), percentText(row.percent)))
                end
            end
            return table.concat(lines, "\n")
        end

        local function addOption(eggId)
            local id = tostring(eggId or "")
            if id == "" or state.optionToId[id] then
                return
            end
            local label = eggName(id)
            if state.optionToId[label] then
                label = label .. " [" .. id .. "]"
            end
            state.optionToId[label] = id
            state.optionToId[id] = id
            table.insert(state.options, label)
        end

        for eggId in pairs(statsEggCatalog) do
            addOption(eggId)
        end
        for eggId in pairs(statsEggPools) do
            addOption(eggId)
        end
        table.sort(state.options, function(a, b)
            return string.lower(a) < string.lower(b)
        end)
        if type(state.selectedEggId) ~= "string" or state.selectedEggId == ""
            or not state.optionToId[state.selectedEggId] then
            state.selectedEggId = nil
            statsState.selectedEggId = nil
        end
        for index, label in ipairs(state.options) do
            if state.optionToId[label] == state.selectedEggId then
                state.defaultIndex = index
                break
            end
        end

        local function setBody(body)
            if not ui or not ui.Paragraph then
                return
            end
            pcall(function()
                ui.Paragraph:UpdateBody(body)
            end)
            -- Keep long source lists inside the Egg page instead of letting a
            -- single name push the paragraph outside its card.
            pcall(function()
                for _, item in ipairs(CoreGui:GetDescendants()) do
                    if item:IsA("TextLabel") and item.Text == "Egg Catalog" then
                        local bodyLabel = item.Parent and item.Parent:FindFirstChild("ParagraphBody")
                        if bodyLabel and bodyLabel:IsA("TextLabel") then
                            bodyLabel.TextWrapped = true
                            bodyLabel.RichText = true
                            bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
                        end
                    end
                end
            end)
        end

        local function update(eggId)
            state.selectedEggId = type(eggId) == "string" and eggId or nil
            statsState.selectedEggId = state.selectedEggId
            setBody(buildBody(state.selectedEggId))
            pcall(function()
                ui.Dropdown:UpdateName(state.selectedEggId
                    and ("Select Egg • " .. eggName(state.selectedEggId)) or "Select Egg")
            end)
        end

        -- Catalog data can change after the controller has started (for
        -- example, a live game update adds an egg or chicken).  Keep the
        -- existing picker instance but rebuild its options on demand.
        state.rebuildOptions = function()
            local selectedEggId = state.selectedEggId
            state.options = {}
            state.optionToId = {}
            state.defaultIndex = nil
            for eggId in pairs(statsEggCatalog) do
                addOption(eggId)
            end
            for eggId in pairs(statsEggPools) do
                addOption(eggId)
            end
            table.sort(state.options, function(a, b)
                return string.lower(a) < string.lower(b)
            end)
            if type(selectedEggId) ~= "string" or selectedEggId == ""
                or not state.optionToId[selectedEggId] then
                selectedEggId = nil
            end
            state.selectedEggId = selectedEggId
            statsState.selectedEggId = selectedEggId
            local selectedOption
            for index, label in ipairs(state.options) do
                if state.optionToId[label] == selectedEggId then
                    state.defaultIndex = index
                    selectedOption = label
                    break
                end
            end
            if ui.Dropdown then
                pcall(function()
                    ui.Dropdown:ClearOptions()
                    ui.Dropdown:InsertOptions(state.options)
                    ui.Dropdown:UpdateSelection(selectedOption and {selectedOption} or {})
                end)
            end
            update(selectedEggId)
        end

        ui.Dropdown = ui.Section:Dropdown({
            Name = "Select Egg",
            Search = true,
            Multi = false,
            Required = false,
            Options = state.options,
            Default = state.defaultIndex,
            Callback = function(value)
                if loadingControls then
                    return
                end
                local selected = type(value) == "number" and state.options[value]
                    or type(value) == "table" and (value[1] or value.Value or value.Name)
                    or value
                local id = state.optionToId[selected]
                if type(id) ~= "string" or id == "" then
                    id = nil
                end
                state.selectionTouched = true
                update(id)
                saveSettings()
            end,
        }, "StatsEggCatalog")
        ui.Paragraph = ui.Section:Paragraph({
            Header = "Egg Catalog",
            Body = "Select an egg to view its source chickens and hatch chances.",
        })
        state.update = update
        local defaultOption = state.defaultIndex and state.options[state.defaultIndex]
        pcall(function()
            ui.Dropdown:UpdateSelection(defaultOption and {defaultOption} or {})
        end)
        update(state.selectedEggId)

        -- MacLib's single-select dropdown does not always fire its callback
        -- when the currently selected option is clicked to clear it.  Read the
        -- actual option checkmarks after the dropdown is mounted so clearing
        -- the selection also clears the catalog body (and its saved value).
        local function readVisualSelection()
            local mounted = false
            local optionCount = 0
            local selectedId
            pcall(function()
                for _, dropdownFrame in ipairs(CoreGui:GetDescendants()) do
                    if dropdownFrame:IsA("Frame") and dropdownFrame.Name == "Dropdown" then
                        local nameLabel = dropdownFrame:FindFirstChild("DropdownName")
                        local title = nameLabel and tostring(nameLabel.Text or "") or ""
                        if string.sub(title, 1, 10) == "Select Egg" then
                            local frame = dropdownFrame:FindFirstChild("DropdownFrame")
                            if frame then
                                local containers = {frame, frame:FindFirstChild("AllDropdownOptionsScroll")}
                                for _, container in ipairs(containers) do
                                    if container then
                                        for _, optionButton in ipairs(container:GetChildren()) do
                                            if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
                                                optionCount += 1
                                                local optionName = optionButton:FindFirstChild("OptionName")
                                                local checkmark = optionButton:FindFirstChild("Checkmark")
                                                local selected = checkmark
                                                    and checkmark:IsA("TextLabel")
                                                    and checkmark.TextTransparency < 0.5
                                                if selected and optionName and optionName:IsA("TextLabel") then
                                                    selectedId = state.optionToId[optionName.Text]
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            mounted = optionCount > 0
            return mounted, selectedId
        end

        state.sync = function()
            local mounted, visualId = readVisualSelection()
            if not mounted then
                return
            end
            if not state.visualReady then
                state.visualReady = true
                -- Preserve a saved selection on the first mount, but remove
                -- MacLib's implicit first-option check when no egg was saved.
                if state.selectedEggId then
                    local selectedLabel
                    for _, label in ipairs(state.options) do
                        if state.optionToId[label] == state.selectedEggId then
                            selectedLabel = label
                            break
                        end
                    end
                    if visualId ~= state.selectedEggId and selectedLabel then
                        pcall(function()
                            ui.Dropdown:UpdateSelection({selectedLabel})
                        end)
                    end
                elseif visualId then
                    pcall(function()
                        ui.Dropdown:UpdateSelection({})
                    end)
                end
                return
            end
            if visualId ~= state.selectedEggId then
                state.selectionTouched = true
                update(visualId)
                if not loadingControls then
                    saveSettings()
                end
            end
        end
        task.spawn(function()
            while sharedEnv.ChickenArenaGeneration == generation do
                -- The Egg Catalog picker belongs to the Stats tab.  MacLib
                -- keeps the tab lazy-mounted, so do not scan CoreGui while
                -- another tab is active; the tab switch handler wakes this
                -- worker when Stats is opened.
                if sharedEnv.ChickenStatsTabVisible == true then
                    pcall(state.sync)
                    task.wait(0.25)
                else
                    task.wait(1.5)
                end
            end
        end)
        return state
    end)()

    -- Keep the formatter helpers inside their own scope.  This stat page lives
    -- in a large top-level controller and Luau's 200-register limit is reached
    -- if every formatting helper remains live beside the catalog builders.
    local function makeStatsSkillDetails()
    local function statsSkillKeyLabel(key)
        return tostring(key):gsub("([a-z0-9])([A-Z])", "%1 %2")
            :gsub("_", " "):lower()
    end

    local function statsSkillNumber(value)
        local number = tonumber(value)
        if not number then
            return tostring(value)
        end
        return statsNumber(number)
    end

    local function statsSkillSeconds(value)
        local number = tonumber(value)
        if not number then
            return nil
        end
        local text = string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "")
        return text .. "s"
    end

    local function statsSkillMultiplier(value)
        local number = tonumber(value)
        if not number then
            return tostring(value)
        end
        local text = string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "")
        return text .. "×"
    end

    local function statsSkillPercent(value)
        local number = tonumber(value)
        if not number then
            return tostring(value)
        end
        local percent = math.abs(number) <= 1 and number * 100 or number
        local text = string.format("%.1f", percent):gsub("0+$", ""):gsub("%.$", "")
        return text .. "%"
    end

    -- These multipliers alter movement/stat buffs instead of dealing damage.
    -- Keep them in the effect section so a card does not imply that a haste or
    -- slow multiplier is an attack hit.
    local statsSkillNonDamagePrefixes = {
        buff = true,
        haste = true,
        slow = true,
        debuff = true,
        atk = true,
        attack = true,
        speed = true,
        health = true,
        hp = true,
        pacing = true,
        gain = true,
        heal = true,
        shield = true,
        revive = true,
        regen = true,
        scale = true,
        power = true,
    }

    -- A missing count means a named impact normally happens once.  Tick/zone
    -- effects are deliberately not included here because their real number of
    -- applications depends on how long the target stays in the zone.
    local statsSkillSingleDamagePrefixes = {
        base = true,
        blast = true,
        burst = true,
        bite = true,
        bolt = true,
        bomb = true,
        boom = true,
        burn = true,
        cut = true,
        drop = true,
        fire = true,
        final = true,
        gore = true,
        hit = true,
        hook = true,
        ignite = true,
        jab = true,
        kick = true,
        land = true,
        lick = true,
        pop = true,
        punch = true,
        release = true,
        ["return"] = true,
        scald = true,
        slash = true,
        slam = true,
        spite = true,
        strike = true,
        swing = true,
        throw = true,
        upper = true,
        wake = true,
        zap = true,
    }

    local statsSkillDamageRanks = {
        base = 1,
        hit = 10,
        jab = 10,
        punch = 10,
        swing = 12,
        slash = 14,
        cut = 14,
        bite = 16,
        kick = 16,
        gore = 16,
        bolt = 18,
        zap = 18,
        shot = 18,
        spit = 18,
        beam = 20,
        pulse = 22,
        wave = 22,
        tick = 24,
        spark = 26,
        strike = 28,
        burst = 80,
        blast = 90,
        final = 100,
    }

    -- Damage that only happens in response to another event (for example,
    -- Voodoo's riposte) cannot have one fixed total.  Keep it separate from
    -- direct hits so the ATK 100 comparison never pretends the trigger count
    -- is known.
    local statsSkillReactivePrefixes = {
        riposte = true,
        counter = true,
        reflect = true,
        retaliate = true,
        retaliation = true,
        revenge = true,
        vengeance = true,
        backlash = true,
        thorn = true,
        thorns = true,
        ["return"] = true,
    }
    local function statsSkillIsReactivePrefix(prefix)
        prefix = string.lower(tostring(prefix or ""))
        if statsSkillReactivePrefixes[prefix] then
            return true
        end
        -- Future configs sometimes use a longer field name (for example
        -- retaliationMult or thornsMult).  Treat those as trigger damage too
        -- so they are not folded into the fixed/direct total.
        return prefix:find("riposte", 1, true) ~= nil
            or prefix:find("counter", 1, true) ~= nil
            or prefix:find("reflect", 1, true) ~= nil
            or prefix:find("retaliat", 1, true) ~= nil
            or prefix:find("revenge", 1, true) ~= nil
            or prefix:find("vengeance", 1, true) ~= nil
            or prefix:find("backlash", 1, true) ~= nil
            or prefix:find("thorn", 1, true) ~= nil
    end
    local function statsSkillIsReactiveWindowKey(keyLower)
        keyLower = string.lower(tostring(keyLower or ""))
        if keyLower == "linkdur" or keyLower == "guarddur"
            or keyLower == "counterdur" or keyLower == "reflectdur"
            or keyLower == "ripostedur" or keyLower == "napdur"
            or keyLower == "markdur" then
            return true
        end
        -- Keep the duration heuristic narrow enough to avoid treating a
        -- generic damage duration as a counter window.
        return keyLower:match("(link|guard|counter|reflect|riposte|retaliat|revenge|vengeance|backlash|thorn|thorns)[a-z]*dur$") ~= nil
            or keyLower:match("(link|guard|counter|reflect|riposte|retaliat|revenge|vengeance|backlash|thorn|thorns)[a-z]*seconds$") ~= nil
    end
    local statsSkillOverTimePrefixes = {
        tick = true,
        dot = true,
        periodic = true,
        pulse = true,
        wave = true,
        linger = true,
        zone = true,
        field = true,
        mine = true,
    }
    local statsSkillDotPrefixes = {
        tick = true,
        dot = true,
        poison = true,
        bleed = true,
    }
    -- A skill can combine short repeated ticks with a final explosion.  Keep
    -- the burst marker separate so the type line does not incorrectly label
    -- the whole skill as DoT only (for example Black Sun Cataclysm).
    local statsSkillBurstPrefixes = {
        burst = true,
        blast = true,
        final = true,
        explosion = true,
        detonation = true,
        shockwave = true,
    }

    local function statsSkillCount(mechanic, prefix)
        return tonumber(mechanic[prefix .. "s"])
            or tonumber(mechanic[prefix .. "Count"])
            or tonumber(mechanic[prefix .. "count"])
    end

    local function statsSkillDetails(mechanic)
        if type(mechanic) ~= "table" then
            return "⚙️ Details unavailable in client config."
        end

        local lines = {}
        local damageParts = {}
        local hasConditionalDamage = false
        local hasReactiveDamage = false
        local hasOverTimeDamage = false
        local hasDotDamage = false
        local hasPeriodicDamage = false
        local hasDamageOverTimePart = false
        local hasReactiveWindow = false
        local reactiveWindowDuration = 0
        local hasMultiHitDamage = false
        local hasAreaDamage = false
        local hasBurstDamage = false
        local hasDefenseEffect = false
        for key, value in pairs(mechanic) do
            local keyText = tostring(key)
            local prefix = keyText:match("^(.*)Mult$")
            local prefixLower = prefix and string.lower(prefix) or ""
            local multiplier = tonumber(value)
            if prefix and prefix ~= "" and multiplier
                and not statsSkillNonDamagePrefixes[prefixLower] then
                local count = statsSkillCount(mechanic, prefix)
                local part = statsSkillKeyLabel(prefix) .. " " .. statsSkillMultiplier(multiplier)
                if count and count > 1 then
                    part = part .. " ×" .. statsSkillNumber(count)
                end
                table.insert(damageParts, {
                    prefix = prefixLower,
                    label = statsSkillKeyLabel(prefix),
                    multiplier = multiplier,
                    count = count,
                    text = part,
                })
                if count and count > 1 then
                    hasMultiHitDamage = true
                end
                if statsSkillIsReactivePrefix(prefixLower) then
                    hasReactiveDamage = true
                    hasConditionalDamage = true
                end
                if statsSkillBurstPrefixes[prefixLower] then
                    hasBurstDamage = true
                end
                if statsSkillOverTimePrefixes[prefixLower] then
                    hasOverTimeDamage = true
                    hasDamageOverTimePart = true
                    if statsSkillDotPrefixes[prefixLower] then
                        hasDotDamage = true
                    else
                        hasPeriodicDamage = true
                    end
                end
                if prefixLower == "execute" or prefixLower == "peak"
                    or prefixLower == "floor" or prefixLower == "alone"
                    or prefixLower == "max" or prefixLower == "min" then
                    hasConditionalDamage = true
                end
            end
        end
        table.sort(damageParts, function(a, b)
            local ar = statsSkillDamageRanks[a.prefix] or 50
            local br = statsSkillDamageRanks[b.prefix] or 50
            if ar == br then
                return a.label < b.label
            end
            return ar < br
        end)
        local skillDuration = 0
        for key, value in pairs(mechanic) do
            local keyLower = string.lower(tostring(key))
            local number = tonumber(value)
            if number then
                if keyLower == "radius" or keyLower == "reach"
                    or keyLower:match("radius$") or keyLower:match("reach$") then
                    hasAreaDamage = true
                end
                if (keyLower == "hits" or keyLower == "shots" or keyLower == "pulses"
                    or keyLower == "waves" or keyLower == "ticks" or keyLower == "strikes")
                    and number > 1 then
                    hasMultiHitDamage = true
                end
                if keyLower == "tickinterval" or keyLower == "pulseinterval"
                    or keyLower == "waveinterval" or keyLower == "dotinterval"
                    or keyLower == "zonedur" or keyLower == "fielddur"
                    or keyLower == "areadur" or keyLower == "lingerdur" then
                    hasOverTimeDamage = true
                    if keyLower == "tickinterval" or keyLower == "dotinterval"
                        or keyLower == "zonedur" or keyLower == "fielddur"
                        or keyLower == "areadur" or keyLower == "lingerdur" then
                        hasDotDamage = true
                    else
                        hasPeriodicDamage = true
                    end
                end
                -- Reactive skills reserve an active window too.  Include
                -- that window in the 30-second cycle estimate; otherwise a
                -- link/counter skill such as Voodoo would be counted as if
                -- it could be recast while its 7-second link is still live.
                if hasReactiveDamage and statsSkillIsReactiveWindowKey(keyLower) then
                    hasReactiveWindow = true
                    reactiveWindowDuration = math.max(reactiveWindowDuration, number)
                end
                if (keyLower:match("poison") or keyLower:match("bleed")
                    or keyLower:match("burn"))
                    and (keyLower:match("dur$") or keyLower:match("seconds$")) then
                    hasOverTimeDamage = true
                    hasDotDamage = true
                end
                if keyLower:match("dur$") or keyLower:match("seconds$") then
                    skillDuration = math.max(skillDuration, math.max(0, number))
                end
                if keyLower == "healfrac" or keyLower == "tickheal"
                    or keyLower == "regenfrac" or keyLower == "shieldfrac"
                    or keyLower == "revivefrac" or keyLower == "buffmult"
                    or keyLower == "hastemult" or keyLower == "atkmult"
                    or keyLower == "debuffmult" then
                    hasDefenseEffect = true
                end
            end
        end
        local periodicInterval = tonumber(mechanic.tickInterval)
            or tonumber(mechanic.pulseInterval)
            or tonumber(mechanic.waveInterval)
            or tonumber(mechanic.dotInterval)
            or tonumber(mechanic.interval)
        local estimatedPeriodicCount
        if hasOverTimeDamage and skillDuration > 0 and periodicInterval and periodicInterval > 0 then
            estimatedPeriodicCount = math.max(1, math.floor(skillDuration / periodicInterval + 0.0001))
        end
        local compareTotal = 0
        local compareWindowTotal = 0
        local hasUnknownCompareDamage = false
        local hasEstimatedCompareDamage = false
        local compareWindowCapped = false
        if #damageParts > 0 then
            local damageText = {}
            local total = 0
            local canTotal = not hasConditionalDamage
            local compareText = {}
            for _, part in ipairs(damageParts) do
                table.insert(damageText, part.text)
                local hitCount = part.count
                local estimatedCount = false
                if not hitCount and statsSkillOverTimePrefixes[part.prefix]
                    and estimatedPeriodicCount then
                    hitCount = estimatedPeriodicCount
                    estimatedCount = true
                    hasEstimatedCompareDamage = true
                    canTotal = false
                end
                local windowHitCount = hitCount
                if estimatedCount and periodicInterval and periodicInterval > 0 then
                    local maxWindowTicks = math.max(1, math.floor(30 / periodicInterval + 0.0001))
                    windowHitCount = math.min(hitCount, maxWindowTicks)
                    if windowHitCount < hitCount then
                        compareWindowCapped = true
                    end
                end
                local isConditionalPart = part.prefix == "execute" or part.prefix == "peak"
                    or part.prefix == "floor" or part.prefix == "alone"
                    or part.prefix == "max" or part.prefix == "min"
                if hitCount and hitCount > 0 then
                    total += part.multiplier * hitCount
                    local perHit = math.max(0, tonumber(part.multiplier) or 0) * 100
                    local amount = perHit * math.max(0, tonumber(hitCount) or 0)
                    compareTotal += amount
                    compareWindowTotal += perHit * math.max(0, tonumber(windowHitCount) or 0)
                    if hitCount > 1 then
                        table.insert(compareText, part.label .. " " .. (estimatedCount and "≈" or "")
                            .. statsSkillNumber(perHit)
                            .. " ×" .. statsSkillNumber(hitCount) .. " = " .. statsSkillNumber(amount))
                    else
                        table.insert(compareText, part.label .. " " .. statsSkillNumber(perHit))
                    end
                elseif statsSkillSingleDamagePrefixes[part.prefix] then
                    total += part.multiplier
                    local perHit = math.max(0, tonumber(part.multiplier) or 0) * 100
                    compareTotal += perHit
                    compareWindowTotal += perHit
                    table.insert(compareText, part.label .. " " .. statsSkillNumber(perHit))
                elseif not statsSkillOverTimePrefixes[part.prefix]
                    and not statsSkillIsReactivePrefix(part.prefix)
                    and not isConditionalPart then
                    -- Most named impacts (for example splash/impact) are one
                    -- direct hit even when the config omits an explicit count.
                    total += part.multiplier
                    local perHit = math.max(0, tonumber(part.multiplier) or 0) * 100
                    compareTotal += perHit
                    compareWindowTotal += perHit
                    table.insert(compareText, part.label .. " " .. statsSkillNumber(perHit))
                else
                    canTotal = false
                    hasUnknownCompareDamage = true
                    local perHit = math.max(0, tonumber(part.multiplier) or 0) * 100
                    local suffix = statsSkillIsReactivePrefix(part.prefix)
                        and " / triggered hit" or " / application"
                    table.insert(compareText, part.label .. " " .. statsSkillNumber(perHit) .. suffix)
                end
            end
            table.insert(lines, "💥 Damage (ATK×): " .. table.concat(damageText, " + "))
            table.insert(lines, "   • ATK 100: " .. table.concat(compareText, " • "))
            if compareTotal > 0 then
                if hasUnknownCompareDamage then
                    table.insert(lines, "   • Total: ≈" .. statsSkillNumber(compareTotal)
                        .. " damage (estimate; trigger damage excluded)")
                elseif hasEstimatedCompareDamage then
                    table.insert(lines, "   • Total: ≈" .. statsSkillNumber(compareTotal)
                        .. " damage (estimate; duration/interval)")
                else
                    table.insert(lines, "   • Total: ≈" .. statsSkillNumber(compareTotal)
                        .. " damage (all hits connect)")
                end
            end
            -- The ATK× breakdown and the ATK 100 total above already contain
            -- the same information as the old second "↳ Total" line.  Avoid
            -- repeating it in the stat card; the card should have one clear
            -- total instead of two nearly identical totals.
            if hasDamageOverTimePart and compareTotal > 0 and skillDuration > 0 then
                table.insert(lines, "⏳ DoT estimate: ≈" .. statsSkillNumber(compareTotal / skillDuration)
                    .. " damage/s over " .. statsSkillSeconds(skillDuration)
                    .. " (ATK 100; target must remain in range/status)")
            end
        end

        local pattern = {}
        local patternFields = {
            "hits", "shots", "pulses", "strikes", "beams", "waves", "sparks",
            "ticks", "bolts", "jolts", "zaps", "bursts", "slashes", "cuts",
            "swipes", "kicks", "gores", "beats", "cards", "pulls", "pushes",
            "slams", "crushes", "scrapes", "spits", "verses", "segments",
            "turns", "reps", "dominoes", "pearls", "lights", "spins", "sheds",
            "steps", "puffs", "fakes",
        }
        local damageCountFields = {}
        for _, part in ipairs(damageParts) do
            if part.count then
                damageCountFields[part.prefix .. "s"] = true
            end
        end
        for _, field in ipairs(patternFields) do
            local value = tonumber(mechanic[field])
            if value and value > 1 and not damageCountFields[field] then
                table.insert(pattern, statsSkillNumber(value) .. " " .. statsSkillKeyLabel(field))
            end
        end
        if #pattern > 0 then
            table.insert(lines, "🧩 Pattern: " .. table.concat(pattern, " • "))
        end

        local extra = {}
        for _, field in ipairs({
            {"finalBonus", "final bonus"},
            {"stepBonus", "step bonus"},
        }) do
            local value = tonumber(mechanic[field[1]])
            if value then
                table.insert(extra, field[2] .. " +" .. statsSkillMultiplier(value))
            end
        end
        if #extra > 0 then
            table.insert(lines, "➕ Extra: " .. table.concat(extra, " • "))
        end

        local timing = {}
        local timingFields = {
            {"windup", "wind-up"},
            {"cooldown", "cooldown"},
            {"between", "between hits"},
            {"pulseInterval", "pulse interval"},
            {"waveInterval", "wave interval"},
            {"tickInterval", "tick interval"},
            {"cardInterval", "card interval"},
            {"interval", "interval"},
            {"recover", "recover"},
        }
        for _, field in ipairs(timingFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                table.insert(timing, field[2] .. " " .. statsSkillSeconds(value))
            end
        end
        if #timing > 0 then
            table.insert(lines, "")
            table.insert(lines, "⏱ Timing: " .. table.concat(timing, " • "))
        end

        local area = {}
        local areaFields = {
            {"radius", "radius"},
            {"reach", "reach"},
            {"blastRadius", "blast radius"},
            {"burstRadius", "burst radius"},
            {"finalRadius", "final radius"},
            {"tickRadius", "tick radius"},
            {"circleRadius", "circle radius"},
            {"coreRadius", "core radius"},
            {"allyRadius", "ally radius"},
        }
        for _, field in ipairs(areaFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                table.insert(area, field[2] .. " " .. statsSkillNumber(value))
            end
        end
        if #area > 0 then
            table.insert(lines, "📍 Area: " .. table.concat(area, " • "))
        end

        local effects = {}
        local fractionFields = {
            {"healFrac", "heal"},
            {"tickHeal", "heal per tick"},
            {"shieldFrac", "shield"},
            {"reviveFrac", "revive"},
            {"stealFrac", "life steal"},
            {"pickupFrac", "pickup"},
            {"puffFrac", "puff"},
            {"pulseFrac", "pulse effect"},
        }
        for _, field in ipairs(fractionFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                table.insert(effects, field[2] .. " " .. statsSkillPercent(value))
            end
        end
        local effectMultipliers = {
            {"buffMult", "buff"},
            {"hasteMult", "haste"},
            {"atkMult", "ATK"},
            {"slowMult", "slow"},
            {"debuffMult", "debuff"},
            {"gainMult", "gain"},
            {"baseBuff", "base buff"},
            {"maxBuff", "max buff"},
        }
        for _, field in ipairs(effectMultipliers) do
            local value = tonumber(mechanic[field[1]])
            if value then
                table.insert(effects, field[2] .. " " .. statsSkillMultiplier(value))
            end
        end
        local durations = {}
        for key, value in pairs(mechanic) do
            local keyText = tostring(key)
            local number = tonumber(value)
            if number and (keyText:match("Dur$") or keyText:match("Seconds$")) then
                local label = keyText:gsub("Seconds$", ""):gsub("Dur$", "")
                table.insert(durations, statsSkillKeyLabel(label) .. " " .. statsSkillSeconds(number))
            end
        end
        table.sort(durations)
        for _, value in ipairs(durations) do
            table.insert(effects, value)
        end
        if #effects > 0 then
            table.insert(lines, "✨ Effects: " .. table.concat(effects, " • "))
        end

        local control = {}
        for key, value in pairs(mechanic) do
            local keyText = tostring(key)
            local keyLower = string.lower(keyText)
            local number = tonumber(value)
            if number and keyLower:match("knock$") then
                local label = keyText:sub(1, -6)
                label = label ~= "" and label or "default"
                table.insert(control, statsSkillKeyLabel(label) .. " knock " .. statsSkillNumber(number))
            elseif number and keyLower:match("up$") and keyLower ~= "windup" then
                local label = keyText:sub(1, -3)
                label = label ~= "" and label or "launch"
                table.insert(control, statsSkillKeyLabel(label) .. " up " .. statsSkillNumber(number))
            end
        end
        table.sort(control)
        if #control > 0 then
            table.insert(lines, "🎮 Control: " .. table.concat(control, " • "))
        end

        local summonName = mechanic.minionName or mechanic.minionType
        if summonName then
            local count = tonumber(mechanic.count) or tonumber(mechanic.copies) or 1
            local summon = statsSkillNumber(count) .. "× " .. tostring(summonName)
            if tonumber(mechanic.life) then
                summon = summon .. " (" .. statsSkillSeconds(mechanic.life) .. ")"
            end
            if mechanic.droneAbility then
                summon = summon .. " • ability " .. tostring(mechanic.droneAbility)
            elseif mechanic.fanAbility then
                summon = summon .. " • ability " .. tostring(mechanic.fanAbility)
            end
            table.insert(lines, "🧙 Summon: " .. summon)
        end

        local conditions = {}
        if tonumber(mechanic.executeBelow) then
            table.insert(conditions, "execute below " .. statsSkillPercent(mechanic.executeBelow) .. " HP")
        end
        if tonumber(mechanic.jackpotAt) then
            table.insert(conditions, "jackpot at " .. statsSkillPercent(mechanic.jackpotAt))
        end
        if tonumber(mechanic.fakes) then
            table.insert(conditions, statsSkillNumber(mechanic.fakes) .. " fake marker(s)")
        end
        if #conditions > 0 then
            table.insert(lines, "⚠️ Condition: " .. table.concat(conditions, " • "))
        end

        -- Compare every skill on the same baseline: ATK 100 over a 30 second
        -- window.  This is intentionally a config-based estimate, because the
        -- client config does not expose enemy armor, missed hits, AI decisions,
        -- or reactive-trigger counts.
        local statsSkillWindowSeconds = 30
        if compareTotal > 0 then
            local windup = math.max(0, tonumber(mechanic.windup) or 0)
            local recover = math.max(0, tonumber(mechanic.recover) or 0)
            local maxDamageCount = 1
            local hasExplicitOverTimeCount = false
            for _, part in ipairs(damageParts) do
                local count = tonumber(part.count)
                if count and count > 0 then
                    if statsSkillOverTimePrefixes[part.prefix] then
                        hasExplicitOverTimeCount = true
                    end
                    maxDamageCount = math.max(maxDamageCount, count)
                elseif statsSkillOverTimePrefixes[part.prefix] and estimatedPeriodicCount then
                    maxDamageCount = math.max(maxDamageCount, estimatedPeriodicCount)
                end
            end

            local sequenceInterval = 0
            local activeDamageDuration = 0
            for key, value in pairs(mechanic) do
                local keyLower = string.lower(tostring(key))
                local number = tonumber(value)
                if number and number > 0 then
                    if keyLower == "between" or keyLower:match("interval$") then
                        sequenceInterval = math.max(sequenceInterval, number)
                    end
                    if keyLower == "zonedur" or keyLower == "fielddur"
                        or keyLower == "areadur" or keyLower == "lingerdur" then
                        activeDamageDuration = math.max(activeDamageDuration, number)
                    end
                end
            end
            -- If a DoT has no explicit tick count, use its configured duration
            -- as the action span.  A poison/status duration must not stretch a
            -- skill that already has a concrete damage count (for example Venom).
            if hasDamageOverTimePart and not hasExplicitOverTimeCount
                and activeDamageDuration <= 0 then
                activeDamageDuration = math.max(0, skillDuration)
            end
            if hasReactiveWindow then
                activeDamageDuration = math.max(activeDamageDuration, reactiveWindowDuration)
            end
            local sequenceSpan = sequenceInterval * math.max(0, maxDamageCount - 1)
            if hasDamageOverTimePart or hasReactiveWindow then
                sequenceSpan = math.max(sequenceSpan, activeDamageDuration)
            end
            local cycleSeconds = windup + sequenceSpan + recover
            local configuredCooldown = math.max(0, tonumber(mechanic.cooldown) or 0)
            if configuredCooldown > 0 then
                cycleSeconds = math.max(cycleSeconds, configuredCooldown)
            end
            if cycleSeconds <= 0 then
                -- Keep an unknown timing from producing an absurd 300 casts.
                cycleSeconds = 1
            end
            cycleSeconds = math.max(0.1, cycleSeconds)
            local castsInWindow = math.max(1,
                math.floor(statsSkillWindowSeconds / cycleSeconds + 0.0001))
            local perCastWindowTotal = compareWindowTotal > 0
                and compareWindowTotal or compareTotal
            local totalWindowDamage = perCastWindowTotal * castsInWindow
            local estimateNotes = {}
            if configuredCooldown <= 0 then
                table.insert(estimateNotes, "no cooldown; uses wind-up/interval/recover")
            end
            if hasAreaDamage then
                table.insert(estimateNotes, "AOE shown per target; target count not multiplied")
            end
            if hasUnknownCompareDamage then
                table.insert(estimateNotes, "trigger/conditional damage excluded")
            end
            if hasReactiveWindow then
                table.insert(estimateNotes, "reactive window; trigger count varies")
            end
            if hasEstimatedCompareDamage then
                table.insert(estimateNotes, "tick count estimated from duration ÷ interval")
            end
            if compareWindowCapped then
                table.insert(estimateNotes, "effects after 30s are truncated")
            end
            table.insert(lines, "")
            table.insert(lines, "🕒 30s @ ATK 100:")
            table.insert(lines, "   • Max per cast ≈" .. statsSkillNumber(compareTotal)
                .. " damage (per target; all hits connect)")
            table.insert(lines, "   • Cycle ≈" .. statsSkillSeconds(cycleSeconds)
                .. " → ~" .. statsSkillNumber(castsInWindow) .. " casts")
            table.insert(lines, "   • Total damage in 30s ≈" .. statsSkillNumber(totalWindowDamage)
                .. " damage")
            if #estimateNotes > 0 then
                table.insert(lines, "   • Notes: " .. table.concat(estimateNotes, " • "))
            end
        end

        -- A skill may have several mechanics at once.  Compose the type
        -- instead of choosing the first matching branch, otherwise a short
        -- tick + area + final burst skill is shown as DoT only.
        local typeParts = {}
        if hasReactiveDamage then
            table.insert(typeParts, "Reactive / Counter")
        end
        if hasAreaDamage then
            table.insert(typeParts, "AOE")
        end
        if hasDotDamage then
            if hasAreaDamage then
                table.insert(typeParts, "short DoT-like ticks")
            else
                table.insert(typeParts, "DoT / Over Time")
            end
        elseif hasPeriodicDamage then
            table.insert(typeParts, "Periodic / Multi-hit")
        elseif hasMultiHitDamage then
            table.insert(typeParts, "Multi-hit")
        end
        if hasBurstDamage then
            table.insert(typeParts, "final Burst")
        end
        local typeText
        if #typeParts > 0 then
            typeText = table.concat(typeParts, " + ")
        elseif hasDefenseEffect then
            typeText = "ป้องกัน/สนับสนุน (Defense / Support)"
        elseif #damageParts > 0 then
            typeText = "Burst"
        else
            typeText = "เอฟเฟกต์พิเศษ (Utility)"
        end
        local thaiSummary
        local linkDuration = tonumber(mechanic.linkDur)
        local riposteMultiplier = tonumber(mechanic.riposteMult)
        local shieldFraction = tonumber(mechanic.shieldFrac)
        local pinCount = tonumber(mechanic.pins)
        local pinMultiplier = tonumber(mechanic.pinMult)
        if hasReactiveDamage then
            if linkDuration and riposteMultiplier then
                thaiSummary = "Voodoo Link: เปิดลิงก์นาน " .. statsSkillSeconds(linkDuration)
                    .. "; ระหว่างนี้เมื่อเกิด trigger/ถูกโจมตีตามเงื่อนไข จะคืนดาเมจ "
                    .. statsSkillMultiplier(riposteMultiplier) .. " ATK ต่อครั้ง"
                    .. " (ATK 100 = " .. statsSkillNumber(riposteMultiplier * 100)
                    .. " ต่อ trigger; ระยะ " .. statsSkillNumber(linkDuration)
                    .. " วินาทีไม่ได้แปลว่า " .. statsSkillNumber(linkDuration)
                    .. " hit หรือ " .. statsSkillMultiplier(linkDuration) .. ")"
                if pinCount and pinMultiplier then
                    thaiSummary = thaiSummary .. "; มี pin " .. statsSkillNumber(pinCount)
                        .. " ครั้ง × " .. statsSkillMultiplier(pinMultiplier)
                        .. " รวมดาเมจตรง " .. statsSkillMultiplier(pinCount * pinMultiplier)
                end
                if shieldFraction then
                    thaiSummary = thaiSummary .. "; มี shield " .. statsSkillPercent(shieldFraction)
                        .. " (เป็นบัฟป้องกัน ไม่ใช่ ATK buff)"
                end
                thaiSummary = thaiSummary .. "; ไม่มี ATK buff โดยตรง. ดาเมจสะท้อนรวมจะแรงขึ้นตามจำนวน trigger ที่เกิดจริง"
            else
                local reactiveParts = {}
                for _, part in ipairs(damageParts) do
                    if statsSkillIsReactivePrefix(part.prefix) then
                        table.insert(reactiveParts,
                            statsSkillKeyLabel(part.prefix) .. " "
                            .. statsSkillMultiplier(part.multiplier) .. " ATK ต่อ trigger")
                    end
                end
                thaiSummary = "Reactive/Counter: ตั้งเอฟเฟกต์ไว้ก่อน แล้วคืนดาเมจเมื่อเกิดเงื่อนไขหรือถูกโจมตี ไม่ใช่ดาเมจที่ออกเองทุกวินาที"
                if #reactiveParts > 0 then
                    thaiSummary = thaiSummary .. "; " .. table.concat(reactiveParts, " • ")
                end
                if reactiveWindowDuration > 0 then
                    thaiSummary = thaiSummary .. "; ช่วงรอ trigger " .. statsSkillSeconds(reactiveWindowDuration)
                elseif skillDuration > 0 then
                    thaiSummary = thaiSummary .. " (ช่วงผลประมาณ " .. statsSkillSeconds(skillDuration) .. ")"
                end
            end
            if hasAreaDamage then
                thaiSummary = thaiSummary .. "; ผลครอบคลุมพื้นที่ตามรัศมีที่ระบุ"
            end
        elseif hasAreaDamage and hasDotDamage and hasBurstDamage then
            thaiSummary = "AOE + tick สั้น + Burst: โจมตีได้หลายเป้าหมาย แบ่งดาเมจเป็น tick ตามจำนวน/interval แล้วมีระเบิดหรือดาเมจหลักปิดท้าย; เป็น DoT ช่วงสั้น ไม่ใช่ DoT ยาวแบบยืนค้างหลายวินาที"
        elseif hasAreaDamage and hasDotDamage then
            thaiSummary = "AOE DoT: ทำดาเมจเป็น tick ในพื้นที่หรือช่วงเวลาที่กำหนด; เป้าหมายหลุดรัศมีหรือหมดสถานะก่อน ดาเมจรวมจะลดลง"
        elseif hasDotDamage then
            thaiSummary = "DoT: แบ่งดาเมจเป็นหลาย tick ต่อเนื่องตาม interval; พลาดบาง tick หรือหมดสถานะก่อน ดาเมจรวมจะลดลง"
        elseif hasAreaDamage and hasMultiHitDamage and hasBurstDamage then
            thaiSummary = "AOE Multi-hit + Burst: โจมตีหลายเป้าหมายหลายฮิต แล้วปิดท้ายด้วยดาเมจระเบิด; ทุกฮิตต้องโดนจึงได้ยอดรวมสูงสุด"
        elseif hasAreaDamage and hasMultiHitDamage then
            thaiSummary = "AOE Multi-hit: โจมตีครอบคลุมพื้นที่และแบ่งเป็นหลายฮิต; จำนวนเป้าหมายกับตำแหน่งในรัศมีมีผลต่อดาเมจจริง"
        elseif hasPeriodicDamage then
            thaiSummary = "Periodic/Multi-hit: ดาเมจออกเป็นจังหวะตาม interval หรือหลายฮิต; พลาดบางจังหวะแล้วดาเมจจริงจะลดลง"
        elseif hasAreaDamage then
            thaiSummary = "AOE: โจมตีครอบคลุมพื้นที่หรือหลายเป้าหมาย; ดาเมจจริงขึ้นกับจำนวนศัตรูและตำแหน่งในรัศมี"
        elseif hasMultiHitDamage then
            thaiSummary = "Multi-hit: ดาเมจถูกแบ่งเป็นหลายฮิตในครั้งเดียว; ถ้าพลาดบางฮิตยอดรวมจะลดลง"
        elseif hasBurstDamage or #damageParts > 0 then
            thaiSummary = "Burst: รวมดาเมจหลักไว้ในจังหวะสั้น เหมาะกับการกดดันหรือปิดงานเร็ว แต่ต้องเข้าเป้าให้ได้"
        elseif hasDefenseEffect then
            thaiSummary = "Defense/Support: เน้นป้องกัน ฟื้นฟู หรือบัฟ มากกว่าดาเมจโดยตรง จึงไม่มีตัวเลขดาเมจ 30 วิให้เทียบ"
        else
            thaiSummary = "Utility: เป็นเอฟเฟกต์เสริมหรือควบคุม และไม่มีตัวคูณดาเมจที่ client เปิดเผยให้คำนวณ"
        end
        -- Keep the English mechanics block visually separate from the Thai
        -- explanation so mixed glyph sizes do not run together in the card.
        table.insert(lines, "")
        table.insert(lines, "🏷️ Skill pattern: " .. typeText)
        table.insert(lines, "")
        table.insert(lines, "🇹🇭 สรุปละเอียด: " .. thaiSummary)

        return #lines > 0 and table.concat(lines, "\n") or "⚙️ No numeric mechanics exposed."
    end
    return statsSkillDetails
    end
    local statsSkillDetails = makeStatsSkillDetails()

    -- Convert the live Catalog/GameConfig data into the same readable shape as
    -- the game's own chicken cards.  We deliberately build this from fields
    -- exposed by the client instead of copying prose or damage values from an
    -- external reference: a game update therefore changes the card naturally.
    -- Keep this formatter inside a closure: the large MacLib controller is
    -- already close to Luau's 200-register limit at top level.
    local statsSkillGameSummary = (function()
    local statsCompactNonDamagePrefixes = {
        buff = true, haste = true, slow = true, debuff = true, atk = true,
        attack = true, speed = true, health = true, hp = true, gain = true,
        heal = true, shield = true, revive = true, regen = true, scale = true,
        power = true,
    }
    local statsCompactReactivePrefixes = {
        riposte = true, counter = true, reflect = true, retaliate = true,
        retaliation = true, revenge = true, vengeance = true, backlash = true,
        thorn = true, thorns = true, ["return"] = true,
    }
    local statsCompactOverTimePrefixes = {
        tick = true, dot = true, periodic = true, pulse = true, wave = true,
        linger = true, zone = true, field = true, mine = true,
    }
    local statsCompactDamageRanks = {
        base = 1, hit = 10, jab = 10, punch = 10, swing = 12, slash = 14,
        cut = 14, bite = 16, kick = 16, gore = 16, bolt = 18, zap = 18,
        shot = 18, spit = 18, beam = 20, pulse = 22, wave = 22, tick = 24,
        spark = 26, strike = 28, burst = 80, blast = 90, final = 100,
    }
    local statsCompactConditionalPrefixes = {
        execute = true, peak = true, floor = true, alone = true,
        max = true, min = true,
    }

    local function statsCompactPercent(multiplier)
        local number = tonumber(multiplier)
        if not number then
            return tostring(multiplier)
        end
        local text = string.format("%.2f", number * 100)
            :gsub("0+$", ""):gsub("%.$", "")
        return text .. "%"
    end

    local function statsCompactSeconds(value)
        local number = tonumber(value)
        if not number then
            return tostring(value)
        end
        local text = string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "")
        return text .. "s"
    end

    local function statsCompactMultiplier(multiplier)
        local number = tonumber(multiplier)
        if not number then
            return tostring(multiplier)
        end
        local text = string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "")
        return text .. "×"
    end

    local function statsCompactClip(value, limit)
        local text = tostring(value or "")
        local maxLength = tonumber(limit) or 420
        if #text > maxLength then
            return string.sub(text, 1, math.max(1, maxLength - 2)) .. ".."
        end
        return text
    end

    local function statsCompactPrefixLabel(prefix, ability)
        prefix = string.lower(tostring(prefix or ""))
        local abilityText = string.lower(tostring(type(ability) == "table"
            and (ability.name or ability.blurb or "") or ""))
        if prefix == "final" then
            if abilityText:find("grandmaster", 1, true)
                or abilityText:find("command slash", 1, true) then
                return "command burst slash"
            elseif abilityText:find("royal flush", 1, true)
                or abilityText:find("ace lands", 1, true) then
                return "final ace"
            elseif abilityText:find("black sun", 1, true)
                or abilityText:find("detonat", 1, true) then
                return "detonation"
            end
            return "final burst"
        elseif prefix == "burst" or prefix == "blast" then
            return "burst"
        elseif prefix == "tick" or prefix == "dot" then
            return "damage per tick"
        elseif prefix == "wave" then
            return "damage per wave"
        elseif prefix == "pulse" then
            return "damage per pulse"
        elseif prefix == "card" then
            return "card"
        end
        return tostring(prefix):gsub("([a-z0-9])([A-Z])", "%1 %2")
            :gsub("_", " "):lower()
    end

    local function statsCompactDamagePhrase(part, ability)
        local percent = statsCompactPercent(part.multiplier)
        local label = statsCompactPrefixLabel(part.prefix, ability)
        if part.reactive then
            return percent .. " reflected damage per trigger"
        elseif label == "damage per tick" or label == "damage per wave"
            or label == "damage per pulse" then
            if part.count and part.count > 1 then
                return percent .. " " .. label .. " (" .. statsNumber(part.count)
                    .. " instances, " .. statsCompactPercent(part.multiplier * part.count)
                    .. " total)"
            end
            return percent .. " " .. label .. " (instance count varies)"
        elseif part.count and part.count > 1 then
            return percent .. " " .. label .. " damage ×" .. statsNumber(part.count)
                .. " (" .. statsCompactPercent(part.multiplier * part.count) .. " total)"
        end
        return percent .. " " .. label .. " damage"
    end

    local function buildSummary(mechanic, ability, chickenInfo)
        if type(mechanic) ~= "table" then
            return nil, nil
        end
        local damageParts = {}
        local totalMultiplier = 0
        local hasReactiveDamage = false
        local hasConditionalDamage = false
        local hasUnknownDamage = false
        for key, value in pairs(mechanic) do
            local keyText = tostring(key)
            local prefix = keyText:match("^(.*)Mult$")
            local multiplier = tonumber(value)
            local prefixLower = prefix and string.lower(prefix) or ""
            if prefix and prefix ~= "" and multiplier
                and not statsCompactNonDamagePrefixes[prefixLower] then
                local count = tonumber(mechanic[prefix .. "s"])
                    or tonumber(mechanic[prefix .. "Count"])
                    or tonumber(mechanic[prefix .. "count"])
                local reactive = statsCompactReactivePrefixes[prefixLower]
                    or prefixLower:find("counter", 1, true) ~= nil
                    or prefixLower:find("reflect", 1, true) ~= nil
                    or prefixLower:find("retaliat", 1, true) ~= nil
                    or prefixLower:find("revenge", 1, true) ~= nil
                    or prefixLower:find("thorn", 1, true) ~= nil
                local conditional = statsCompactConditionalPrefixes[prefixLower] == true
                table.insert(damageParts, {
                    prefix = prefixLower,
                    multiplier = multiplier,
                    count = count and count > 0 and count or nil,
                    reactive = reactive,
                    conditional = conditional,
                })
                if reactive then
                    hasReactiveDamage = true
                    hasUnknownDamage = true
                elseif conditional then
                    hasConditionalDamage = true
                elseif statsCompactOverTimePrefixes[prefixLower] and not count then
                    -- A tick/zone multiplier without a configured count has
                    -- no fixed total; do not pretend one tick is the whole
                    -- skill just to make the card look complete.
                    hasUnknownDamage = true
                else
                    totalMultiplier += multiplier * math.max(1, count or 1)
                end
            end
        end
        table.sort(damageParts, function(a, b)
            local ar = statsCompactDamageRanks[a.prefix] or 50
            local br = statsCompactDamageRanks[b.prefix] or 50
            if ar == br then
                return a.prefix < b.prefix
            end
            return ar < br
        end)

        local damagePhrases = {}
        for _, part in ipairs(damageParts) do
            table.insert(damagePhrases, statsCompactDamagePhrase(part, ability))
        end
        local damageText
        if #damagePhrases == 0 then
            damageText = "No direct damage exposed by client config."
        else
            damageText = table.concat(damagePhrases, #damagePhrases > 1 and " and " or "")
            if totalMultiplier > 0 then
                damageText = damageText .. ". Total Damage: " .. statsCompactPercent(totalMultiplier)
                if hasReactiveDamage or hasConditionalDamage then
                    damageText = damageText .. " (fixed hits only)"
                end
                damageText = damageText .. "."
            elseif hasReactiveDamage then
                damageText = damageText .. ". Total Damage: trigger-based; depends on events."
            elseif hasUnknownDamage then
                damageText = damageText .. ". Total Damage: not fixed by client config."
            else
                damageText = damageText .. "."
            end
        end

        local effects = {}
        local timingCount = 0
        local function addEffect(text)
            if text and text ~= "" then
                table.insert(effects, text)
            end
        end
        local timingFields = {
            {"windup", "wind-up"}, {"cooldown", "cooldown"},
            {"between", "between hits"}, {"pulseInterval", "between pulses"},
            {"waveInterval", "between waves"}, {"tickInterval", "between ticks"},
            {"cardInterval", "between cards"}, {"interval", "interval"},
            {"recover", "recover"},
        }
        for _, field in ipairs(timingFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                local label = field[2]
                if field[1] == "windup" then
                    label = "cast speed"
                elseif field[1] == "recover" then
                    label = "recovery"
                end
                addEffect(statsCompactSeconds(value) .. " " .. label)
                timingCount += 1
            end
        end

        local areaFields = {
            {"markRadius", "target radius"}, {"radius", "radius"},
            {"reach", "reach"}, {"blastRadius", "blast radius"},
            {"burstRadius", "burst radius"}, {"finalRadius", "final burst radius"},
            {"tickRadius", "tick radius"}, {"circleRadius", "circle radius"},
            {"coreRadius", "core radius"}, {"allyRadius", "ally radius"},
        }
        for _, field in ipairs(areaFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                addEffect(field[2] .. " " .. statsNumber(value))
            end
        end

        local effectFields = {
            {"abilityBoost", "ability boost"}, {"buffMult", "buff"},
            {"hasteMult", "haste"}, {"atkMult", "ATK"}, {"slowMult", "slow"},
            {"debuffMult", "debuff"}, {"gainMult", "gain"},
            {"baseBuff", "base buff"}, {"maxBuff", "max buff"},
        }
        for _, field in ipairs(effectFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                local bonus = math.abs(value - 1) > 0.0001
                    and " (" .. statsSignedPercent(value) .. ")" or ""
                addEffect(field[2] .. " " .. statsCompactMultiplier(value) .. bonus)
            end
        end
        local fractionFields = {
            {"healFrac", "heal"}, {"tickHeal", "heal per tick"},
            {"shieldFrac", "shield"}, {"reviveFrac", "revive"},
            {"stealFrac", "life steal"}, {"pickupFrac", "pickup"},
            {"puffFrac", "puff"}, {"pulseFrac", "pulse effect"},
        }
        for _, field in ipairs(fractionFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                addEffect(field[2] .. " " .. statsCompactPercent(value))
            end
        end

        local durationFields = {
            {"markDur", "mark lasts"}, {"linkDur", "link lasts"},
            {"guardDur", "guard lasts"}, {"counterDur", "counter lasts"},
            {"reflectDur", "reflect lasts"}, {"riposteDur", "riposte lasts"},
            {"zoneDur", "zone lasts"}, {"fieldDur", "field lasts"},
            {"areaDur", "area lasts"}, {"lingerDur", "linger lasts"},
        }
        for _, field in ipairs(durationFields) do
            local value = tonumber(mechanic[field[1]])
            if value then
                addEffect(field[2] .. " " .. statsCompactSeconds(value))
            end
        end

        for key, value in pairs(mechanic) do
            local keyText = tostring(key)
            local keyLower = string.lower(keyText)
            local number = tonumber(value)
            if number and keyLower:match("knock$") then
                local prefix = keyText:sub(1, -6)
                if string.lower(prefix) == "final" or prefix == "" then
                    addEffect("applies " .. statsNumber(number) .. " knockback")
                else
                    addEffect(string.lower(prefix) .. " knockback " .. statsNumber(number))
                end
            elseif number and keyLower:match("up$") and keyLower ~= "windup" then
                local prefix = keyText:sub(1, -3)
                if string.lower(prefix) == "final" or prefix == "" then
                    addEffect("applies " .. statsNumber(number) .. " knockup")
                else
                    addEffect(string.lower(prefix) .. " knockup " .. statsNumber(number))
                end
            end
        end

        local summonName = mechanic.minionName or mechanic.minionType
        if summonName then
            local count = tonumber(mechanic.count) or tonumber(mechanic.copies) or 1
            local summon = statsNumber(count) .. "× " .. tostring(summonName)
            if tonumber(mechanic.life) then
                summon = summon .. " for " .. statsCompactSeconds(mechanic.life)
            end
            addEffect("summons " .. summon)
        end
        if tonumber(mechanic.executeBelow) then
            addEffect("execute below " .. statsCompactPercent(mechanic.executeBelow) .. " HP")
        end
        if tonumber(mechanic.jackpotAt) then
            addEffect("jackpot at " .. statsCompactPercent(mechanic.jackpotAt))
        end
        if tonumber(mechanic.fakes) then
            addEffect(statsNumber(mechanic.fakes) .. " fake markers")
        end

        local effectText
        if #effects > 0 then
            local gameBlurb = type(chickenInfo) == "table"
                and type(chickenInfo.blurb) == "string" and chickenInfo.blurb
                or type(ability) == "table"
                    and type(ability.blurb) == "string" and ability.blurb or ""
            local rendered = {}
            if timingCount > 0 then
                table.insert(rendered, effects[1] .. ".")
                if gameBlurb ~= "" then
                    table.insert(rendered, gameBlurb)
                end
                for index = 2, #effects do
                    table.insert(rendered, effects[index])
                end
            elseif gameBlurb ~= "" then
                table.insert(rendered, gameBlurb)
                for _, effect in ipairs(effects) do
                    table.insert(rendered, effect)
                end
            else
                rendered = effects
            end
            for index, sentence in ipairs(rendered) do
                rendered[index] = tostring(sentence):gsub("%s*[%.!?]+$", "")
            end
            effectText = table.concat(rendered, ". ") .. "."
        elseif type(ability) == "table"
            and type(ability.blurb) == "string" and ability.blurb ~= "" then
            effectText = "No extra numeric effects exposed; " .. ability.blurb
        else
            effectText = "No additional effects exposed by client config."
        end
        return statsCompactClip(damageText, 420), statsCompactClip(effectText, 420)
    end

    return buildSummary
    end)()

    -- Fallback for a Catalog entry whose ability mechanic is not present in
    -- the current client.  The verbose parser still provides any information
    -- that is available, while the normal path above uses the live fields.
    local function statsSkillCompactSummary(details, ability, mechanic, chickenInfo)
        local liveDamage, liveEffects = statsSkillGameSummary(mechanic, ability, chickenInfo)
        if liveDamage and liveEffects then
            return liveDamage, liveEffects
        end
        local damageParts = {}
        local effectParts = {}
        for rawLine in string.gmatch(tostring(details or ""), "[^\n]+") do
            local line = rawLine:gsub("^%s+", "")
            if line:match("^💥 Damage %(ATK×%)") then
                local damageLine = line:gsub("^💥 Damage %(ATK×%):%s*", "")
                table.insert(damageParts, damageLine)
            elseif line:match("^• ATK 100:") then
                table.insert(damageParts, line)
            elseif line:match("^• Total:") then
                table.insert(damageParts, line)
            elseif line:match("^⏳ DoT estimate:") then
                table.insert(damageParts, line)
            elseif line:match("^⏱ Timing:") or line:match("^📍 Area:")
                or line:match("^✨ Effects:") or line:match("^🎮 Control:")
                or line:match("^🧙 Summon:") or line:match("^⚠️ Condition:")
                or line:match("^🧩 Pattern:") or line:match("^➕ Extra:") then
                table.insert(effectParts, line)
            end
        end
        local damageText = #damageParts > 0
            and table.concat(damageParts, " • ")
            or "No direct damage exposed"
        local effectText = #effectParts > 0
            and table.concat(effectParts, " • ")
            or "No additional effects exposed"
        if #effectText > 420 then
            effectText = string.sub(effectText, 1, 418) .. ".."
        end
        if #damageText > 420 then
            damageText = string.sub(damageText, 1, 418) .. ".."
        end
        if #effectParts == 0 then
            local description = type(chickenInfo) == "table"
                and type(chickenInfo.blurb) == "string" and chickenInfo.blurb
                or type(ability) == "table"
                    and type(ability.blurb) == "string" and ability.blurb
                or type(ability) == "table"
                    and type(ability.description) == "string" and ability.description
                or type(ability) == "table"
                    and type(ability.desc) == "string" and ability.desc or ""
            if description ~= "" then
                if #description > 420 then
                    description = string.sub(description, 1, 418) .. ".."
                end
                effectText = description
            end
        end
        return damageText, effectText
    end

    local function skillSummary(info)
        local signature = type(info.signature) == "string" and info.signature or ""
        local ability = signature ~= "" and statsAbilities[signature] or nil
        local mechanicKey = string.lower(tostring(signature or ""))
        local mechanic = mechanicKey ~= "" and statsAbilityMechanicAliases[mechanicKey] or nil
        local details = statsSkillDetails(mechanic)
        local damageText, effectText = statsSkillCompactSummary(details, ability, mechanic, info)
        if type(ability) ~= "table" then
            local fallback = signature ~= "" and signature or "None"
            return table.concat({
                "Ability: " .. fallback,
                "Type: —",
                "• Damage: " .. damageText,
                "• Other Effects: " .. effectText,
            }, "\n")
        end

        local abilityName = tostring(ability.name or signature)
        local skillType = ability.kind or ability.type or ""
        if skillType == "" and type(mechanic) == "table" then
            skillType = mechanic.kind or mechanic.type or ""
        end
        skillType = tostring(skillType)
        if skillType == "" then
            skillType = "—"
        else
            skillType = skillType:gsub("^%l", string.upper)
        end
        local description = type(info) == "table"
            and type(info.blurb) == "string" and info.blurb
            or type(ability.blurb) == "string" and ability.blurb
            or type(ability.description) == "string" and ability.description
            or type(ability.desc) == "string" and ability.desc or ""
        local lines = {
            "Ability: " .. abilityName,
            "Type: " .. skillType,
        }
        if description ~= "" then
            table.insert(lines, "Description: " .. description)
        end
        table.insert(lines, "• Damage: " .. damageText)
        table.insert(lines, "• Other Effects: " .. effectText)
        return table.concat(lines, "\n")
    end

    sharedEnv.ChickenStatsRebuildRows = function()
        statsRows = {}
        statsOptionToType = {}
        statsTypeToOption = {}
        for typeId, info in pairs(statsCatalog) do
            if type(info) == "table" then
                local archetype = type(info.archetype) == "table" and info.archetype or {}
                local hp = sharedEnv.ChickenStatsLevelValue(
                    tonumber(baseStats.hp) or 0,
                    tonumber(growthStats.hp) or 1,
                    statsState.baseLevel
                )
                    * (tonumber(archetype.hp) or 1)
                local atk = sharedEnv.ChickenStatsLevelValue(
                    tonumber(baseStats.atk) or 0,
                    tonumber(growthStats.atk) or 1,
                    statsState.baseLevel
                )
                    * (tonumber(archetype.atk) or 1)
                -- Speed and Power remain multipliers from the neutral base (1.0),
                -- not raw seconds or Arena power.  The selected Genome Stat is
                -- applied in refreshStatsLevelValues below.
                local owned = statsOwnedByType[typeId] or {}
                local option = tostring(info.name or typeId)
                -- Keep the picker compact and deterministic.  Nicknames remain
                -- visible on each stat card, while the list uses an owned count
                -- so custom names cannot make duplicate/long options.
                if (statsOwnedCountByType[typeId] or 0) > 0 then
                    option = option .. " [Owned x" .. tostring(statsOwnedCountByType[typeId] or 0) .. "]"
                end
                if statsOptionToType[option] then
                    option = option .. " (" .. tostring(info.rarity or "") .. ")"
                end
                table.insert(statsRows, {
                    typeId = tostring(typeId),
                    name = tostring(info.name or typeId),
                    rarity = tostring(info.rarity or "unknown"),
                    option = option,
                    nickname = #owned > 0 and table.concat(owned, ", ")
                        or ((statsOwnedCountByType[typeId] or 0) > 0
                            and "— (owned x" .. tostring(statsOwnedCountByType[typeId] or 0) .. ")"
                            or "— (not owned)"),
                    hp = hp,
                    atk = atk,
                    baseHp = tonumber(baseStats.hp) or 0,
                    baseAtk = tonumber(baseStats.atk) or 0,
                    growthHp = tonumber(growthStats.hp) or 1,
                    growthAtk = tonumber(growthStats.atk) or 1,
                    archetypeHp = tonumber(archetype.hp) or 1,
                    archetypeAtk = tonumber(archetype.atk) or 1,
                    archetypeSpeed = tonumber(archetype.speed) or 1,
                    archetypeStamina = tonumber(archetype.stamina) or 1,
                    spd = tonumber(archetype.speed) or 1,
                    pwr = tonumber(archetype.stamina) or 1,
                    layPeriod = tonumber(info.layPeriod) or 0,
                    baseLayPeriod = tonumber(info.layPeriod) or 0,
                    genomeCap = sharedEnv.ChickenGenomeCap(info.rarity),
                    genomeValue = 0,
                    eggs = eggSummary(info),
                    foundIn = eggSourceSummary(info, tostring(typeId)),
                    skillId = type(info.signature) == "string" and info.signature or "",
                    skill = skillSummary(info),
                })
                statsOptionToType[option] = tostring(typeId)
                statsTypeToOption[tostring(typeId)] = option
            end
        end
        table.sort(statsRows, function(a, b)
            return string.lower(a.name) < string.lower(b.name)
        end)

        local validSelected = {}
        local selectedSeen = {}
        for _, typeId in ipairs(statsState.selected) do
            if statsTypeToOption[typeId] and not selectedSeen[typeId] then
                table.insert(validSelected, typeId)
                selectedSeen[typeId] = true
            end
        end
        statsState.selected = validSelected
    end
    sharedEnv.ChickenStatsRebuildRows()

    sharedEnv.ChickenStatsRefreshCatalog = function()
        if sharedEnv.ChickenStatsCatalogRefreshing then
            return false
        end
        local catalogOk, newCatalog = pcall(function()
            return loadModule(ReplicatedStorage.Content.Catalog)
        end)
        if not catalogOk or type(newCatalog) ~= "table" then
            return false
        end
        local newChickenTypes = type(newCatalog.chickenTypes) == "table"
            and newCatalog.chickenTypes or {}
        local newAbilities = type(newCatalog.abilities) == "table"
            and newCatalog.abilities or {}
        local newEggs = type(newCatalog.eggs) == "table" and newCatalog.eggs or {}
        local dropOk, newDropTables = pcall(function()
            return loadModule(ReplicatedStorage.Content.DropTables)
        end)
        if not dropOk or type(newDropTables) ~= "table" then
            newDropTables = DropTablesData
        end
        if type(newDropTables) ~= "table" then
            newDropTables = {}
        end
        local newEggPools = type(newDropTables.eggPool) == "table"
            and newDropTables.eggPool or {}
        local fingerprint = sharedEnv.ChickenStatsCatalogFingerprintOf(
            newChickenTypes, newEggs, newAbilities, newEggPools)
        if fingerprint == sharedEnv.ChickenStatsCatalogFingerprint then
            return false
        end

        sharedEnv.ChickenStatsCatalogRefreshing = true
        local rebuilt = pcall(function()
            statsCatalog = newChickenTypes
            statsAbilities = newAbilities
            statsEggCatalog = newEggs
            DropTablesData = newDropTables
            statsEggPools = newEggPools

            local gameOk, newGameConfig = pcall(function()
                return loadModule(ReplicatedStorage.Content.GameConfig)
            end)
            if gameOk and type(newGameConfig) == "table" then
                GameConfigData = newGameConfig
            end
            statsAbilityMechanics = type(GameConfigData) == "table"
                and type(GameConfigData.combat) == "table"
                and type(GameConfigData.combat.abilities) == "table"
                and GameConfigData.combat.abilities or {}
            for key in pairs(statsAbilityMechanicAliases) do
                statsAbilityMechanicAliases[key] = nil
            end
            for mechanicId, mechanic in pairs(statsAbilityMechanics) do
                if type(mechanic) == "table" then
                    statsAbilityMechanicAliases[string.lower(tostring(mechanicId))] = mechanic
                end
            end

            for key in pairs(statsEggInfoById) do
                statsEggInfoById[key] = nil
            end
            for key in pairs(statsEggAliases) do
                statsEggAliases[key] = nil
            end
            for eggId, eggInfo in pairs(statsEggCatalog) do
                local id = tostring(eggId)
                statsEggInfoById[id] = eggInfo
                statsEggAliases[string.lower(id)] = id
                if type(eggInfo) == "table" and eggInfo.name then
                    statsEggAliases[string.lower(tostring(eggInfo.name))] = id
                end
            end

            for key in pairs(statsTypeAliases) do
                statsTypeAliases[key] = nil
            end
            for typeId, chickenInfo in pairs(statsCatalog) do
                local id = tostring(typeId)
                statsTypeAliases[string.lower(id)] = id
                if type(chickenInfo) == "table" and chickenInfo.name then
                    statsTypeAliases[string.lower(tostring(chickenInfo.name))] = id
                end
            end

            statsOwnedByType = {}
            statsOwnedCountByType = {}
            local rosterOk, rosterData = pcall(function()
                return DataService.client:get({"roster"}) or {}
            end)
            local roster = rosterOk and type(rosterData) == "table" and rosterData or {}
            if type(roster.roster) == "table" then
                roster = roster.roster
            end
            local chickens = type(roster.chickens) == "table" and roster.chickens or {}
            for _, chicken in ipairs(chickens) do
                if type(chicken) == "table" and type(chicken.typeId) == "string" then
                    statsOwnedCountByType[chicken.typeId] =
                        (statsOwnedCountByType[chicken.typeId] or 0) + 1
                    local owned = statsOwnedByType[chicken.typeId]
                    if not owned then
                        owned = {}
                        statsOwnedByType[chicken.typeId] = owned
                    end
                    local nickname = type(chicken.nickname) == "string"
                        and chicken.nickname or ""
                    if nickname ~= "" then
                        table.insert(owned, nickname)
                    end
                end
            end

            baseStats = type(GameConfigData) == "table"
                and type(GameConfigData.chicken) == "table"
                and GameConfigData.chicken.base or {}
            growthStats = type(GameConfigData) == "table"
                and type(GameConfigData.chicken) == "table"
                and GameConfigData.chicken.growth or {}
            sharedEnv.ChickenStatsLevelCap = type(GameConfigData) == "table"
                and type(GameConfigData.chicken) == "table"
                and tonumber(GameConfigData.chicken.maxLevel) or nil
            if sharedEnv.ChickenStatsLevelCap
                and sharedEnv.ChickenStatsLevelCap < math.huge then
                sharedEnv.ChickenStatsLevelCap = math.max(1,
                    math.floor(sharedEnv.ChickenStatsLevelCap))
                statsState.baseLevel = math.min(
                    tonumber(statsState.baseLevel) or 1,
                    sharedEnv.ChickenStatsLevelCap)
            else
                sharedEnv.ChickenStatsLevelCap = nil
            end
            sharedEnv.ChickenGenomeCaps = type(GameConfigData) == "table"
                and type(GameConfigData.fusion) == "table"
                and type(GameConfigData.fusion.geneCap) == "table"
                and GameConfigData.fusion.geneCap or {}
            sharedEnv.ChickenGenomeMax = type(GameConfigData) == "table"
                and type(GameConfigData.fusion) == "table"
                and tonumber(GameConfigData.fusion.geneMax) or 31
            if sharedEnv.ChickenGenomeMax < 1 then
                sharedEnv.ChickenGenomeMax = 31
            end
            statsState.genomeStat = math.min(
                tonumber(statsState.genomeStat) or 0,
                sharedEnv.ChickenGenomeMax)
            sharedEnv.ChickenStatsRebuildRows()
            if type(sharedEnv.ChickenStatsRefreshLevelValues) == "function" then
                sharedEnv.ChickenStatsRefreshLevelValues()
            end

            local eggState = sharedEnv.ChickenEggCatalog
            if type(eggState) == "table" and type(eggState.rebuildOptions) == "function" then
                pcall(eggState.rebuildOptions)
            end

            local selectedOptions = {}
            local orderedOptions = {}
            local selectedSeen = {}
            for _, typeId in ipairs(statsState.selected) do
                local option = statsTypeToOption[typeId]
                if option and not selectedSeen[option] then
                    table.insert(selectedOptions, option)
                    table.insert(orderedOptions, option)
                    selectedSeen[option] = true
                end
            end
            for _, row in ipairs(statsRows) do
                if not selectedSeen[row.option] then
                    table.insert(orderedOptions, row.option)
                    selectedSeen[row.option] = true
                end
            end
            if statsUi.Dropdown then
                statsUi.Reordering = true
                pcall(function()
                    statsUi.Dropdown:ClearOptions()
                    statsUi.Dropdown:InsertOptions(orderedOptions)
                    statsUi.Dropdown:UpdateSelection(selectedOptions)
                    statsUi.Dropdown:UpdateName(
                        "Select Chickens (Multi-select) • "
                            .. tostring(#statsState.selected) .. " selected")
                end)
                statsUi.Reordering = false
            end

            local previousCompare = statsCompareState.selected or {}
            local compareSelected = {}
            local compareSelectedSeen = {}
            for _, typeId in ipairs(previousCompare) do
                if statsTypeToOption[typeId] and not compareSelectedSeen[typeId] then
                    table.insert(compareSelected, typeId)
                    compareSelectedSeen[typeId] = true
                end
            end
            local compareOptions = {}
            local compareOptionSeen = {}
            local compareOptionToType = {}
            local compareTypeToOption = {}
            local compareOrder = {}
            for _, row in ipairs(statsRows) do
                local base = tostring(row.name or row.typeId)
                    .. " [" .. tostring(row.rarity or "unknown") .. "]"
                local option = base
                compareOptionSeen[base] = (compareOptionSeen[base] or 0) + 1
                if compareOptionSeen[base] > 1 then
                    option = base .. " #" .. tostring(compareOptionSeen[base])
                end
                table.insert(compareOptions, option)
                compareOptionToType[option] = row.typeId
                compareTypeToOption[row.typeId] = option
                compareOrder[option] = #compareOptions
            end
            if #compareOptions == 0 then
                table.insert(compareOptions, "(No chicken skills)")
            end
            statsCompareState.options = compareOptions
            statsCompareState.optionToType = compareOptionToType
            statsCompareState.typeToOption = compareTypeToOption
            statsCompareState.optionOrder = compareOrder
            statsCompareState.selected = compareSelected
            if statsCompareState.dropdown then
                statsCompareState.reordering = true
                local selectedCompareOptions = {}
                for _, typeId in ipairs(compareSelected) do
                    local option = compareTypeToOption[typeId]
                    if option then
                        table.insert(selectedCompareOptions, option)
                    end
                end
                pcall(function()
                    statsCompareState.dropdown:ClearOptions()
                    statsCompareState.dropdown:InsertOptions(compareOptions)
                    statsCompareState.dropdown:UpdateSelection(selectedCompareOptions)
                    statsCompareState.dropdown:UpdateName(
                        "Compare Skill Chickens (Multi-select) • "
                            .. tostring(#compareSelected) .. " selected")
                end)
                statsCompareState.reordering = false
            end
            sharedEnv.ChickenStatsDropdownCache.dirty = true
        end)
        sharedEnv.ChickenStatsCatalogRefreshing = false
        if not rebuilt then
            return false
        end
        sharedEnv.ChickenStatsCatalogFingerprint = fingerprint
        return true
    end
    sharedEnv.ChickenStatsCatalogFingerprint =
        sharedEnv.ChickenStatsCatalogFingerprintOf(
            statsCatalog, statsEggCatalog, statsAbilities, statsEggPools)
end

local function refreshStatsLevelValues()
    local level = math.max(1, math.floor(tonumber(statsState.baseLevel) or 1))
    local cap = tonumber(sharedEnv.ChickenStatsLevelCap)
    if cap then
        level = math.min(level, math.max(1, math.floor(cap)))
    end
    statsState.baseLevel = level
    local genomeSetting = math.max(0, math.floor(tonumber(statsState.genomeStat) or 0))
    local genomeMax = tonumber(sharedEnv.ChickenGenomeMax) or 31
    if genomeMax > 0 then
        genomeSetting = math.min(genomeSetting, genomeMax)
    end
    statsState.genomeStat = genomeSetting
    for _, row in ipairs(statsRows) do
        local genomeValue = math.min(genomeSetting, tonumber(row.genomeCap) or genomeMax)
        local multipliers = sharedEnv.ChickenGenomeMultipliers(genomeValue)
        row.genomeValue = genomeValue
        row.hp = sharedEnv.ChickenStatsLevelValue(row.baseHp, row.growthHp, level)
            * (tonumber(row.archetypeHp) or 1) * multipliers.strength
        row.atk = sharedEnv.ChickenStatsLevelValue(row.baseAtk, row.growthAtk, level)
            * (tonumber(row.archetypeAtk) or 1) * multipliers.strength
        row.spd = (tonumber(row.archetypeSpeed) or 1) * multipliers.pacing
        row.pwr = (tonumber(row.archetypeStamina) or 1) * multipliers.pacing
        row.layPeriod = (tonumber(row.baseLayPeriod) or 0) * multipliers.fertility
    end
end
sharedEnv.ChickenStatsRefreshLevelValues = refreshStatsLevelValues

refreshStatsLevelValues()

local StatsCardParagraphs = {}
for index = 1, STATS_MAX_VISIBLE_CARDS do
    StatsCardParagraphs[index] = statsUi.CardSection:Paragraph({
        Header = "Chicken Stat Card " .. tostring(index),
        Body = "",
    })
    -- Cards are populated only when a chicken is selected.  Hide the unused
    -- slots at creation time so the right column never shows empty cards.
    pcall(function()
        StatsCardParagraphs[index]:SetVisibility(false)
    end)
end

local function updateStatsParagraph(header, paragraph, body)
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    bodyLabel.Text = body
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            paragraph:UpdateBody(body)
        end)
    end
end

-- Keep the stat-card body compact and close to the game's tooltip layout.
-- Escape the complete skill string first so catalog text cannot inject markup;
-- only these fixed labels receive colors.
local function statsCardSkillMarkup(value)
    local text = statsRichText(value)
    text = text:gsub("Ability:", "<font color=\"#FFD166\"><b>Ability</b></font>:")
        :gsub("Type:", "<font color=\"#7DD3FC\"><b>Type</b></font>:")
        :gsub("Description:", "<font color=\"#B8C0CC\"><b><i>Description</i></b></font>:")
        :gsub("Damage and Effect:", "<font color=\"#FF9F43\"><b>Damage and Effect</b></font>:")
        :gsub("• Damage:", "<font color=\"#FF6B6B\"><b>• Damage</b></font>:")
        :gsub("• Other Effects:", "<font color=\"#FFD166\"><b>• Other Effects</b></font>:")
    return text
end

local function updateStatsCard(index, body, visible)
    local header = "Chicken Stat Card " .. tostring(index)
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                -- Keep the header as an internal section marker so MacLib can
                -- find and move the card, but do not spend a visible row on
                -- "Chicken Stat Card 1".  The numbered chicken title is the
                -- useful heading, matching the game's tooltip layout.
                item.Visible = false
                if card then
                    card.Visible = visible
                end
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    -- Use a medium-weight, wider face for the card.  The
                    -- default MacLib face is too thin/condensed once the
                    -- metadata and skill lines are combined.
                    bodyLabel.Font = Enum.Font.GothamMedium
                    bodyLabel.TextSize = 15
                    bodyLabel.TextScaled = false
                    bodyLabel.TextWrapped = true
                    bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
                    bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
                    bodyLabel.RichText = true
                    bodyLabel.Text = visible and body or ""
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            StatsCardParagraphs[index]:UpdateBody(visible and body or "")
            StatsCardParagraphs[index]:SetVisibility(visible)
        end)
    end
end

local function statsFindSection(header)
    local found
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                local section = card and card.Parent
                if bodyLabel and section and section:IsA("Frame") and section.Name == "Section" then
                    found = section
                    break
                end
            end
        end
    end)
    return found
end

local function setStatsSectionVisibility(header, visible)
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                -- The visible title is rendered inside the body below.  Hide
                -- MacLib's duplicate Paragraph header while keeping its text
                -- available as a stable lookup key for lazy mounting.
                if header == "TOP 5 Rank by Overall • Equal Weight"
                    or header == "TOP 5 Rank by HP / ATK"
                    or header == "TOP 5 Rank by ATK / HP"
                    or header == "TOP 5 Skill • Overall"
                    or header == "TOP 5 Skill • 1v1"
                    or header == "TOP 5 Skill • Tank / Sustain"
                    or header == "TOP 5 Skill • AOE"
                    or header == "TOP 5 Lay Egg • Fastest"
                    or header == "COMPARE Skill Damage" then
                    item.Visible = false
                end
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                local section = card and card.Parent
                if bodyLabel and section and section:IsA("Frame") and section.Name == "Section" then
                    section.Visible = visible
                end
            end
        end
    end)
end

local function statsVisibleInHierarchy(item)
    local current = item
    while current do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        current = current.Parent
    end
    return true
end

-- MacLib normally splits a tab into Left/Right columns.  The catalog and
-- selected-stat cards are much easier to read when they use the full tab
-- width, so move only these Stats sections into Left while Stats is active.
local function applyStatsFullWidthLayout()
    local targetHeaders = {
        "Chicken Stats Catalog",
        "TOP 5 Rank by Overall • Equal Weight",
        "TOP 5 Rank by ATK / HP",
        "TOP 5 Rank by HP / ATK",
        "TOP 5 Skill • Overall",
        "TOP 5 Skill • 1v1",
        "TOP 5 Skill • Tank / Sustain",
        "TOP 5 Skill • AOE",
        "TOP 5 Lay Egg • Fastest",
        "COMPARE Skill Damage",
        "Chicken Stat Card 1",
    }
    local sections = {}
    local seen = {}
    local statsActive = false
    for _, header in ipairs(targetHeaders) do
        local section = statsFindSection(header)
        if section and not seen[section] then
            table.insert(sections, section)
            seen[section] = true
            if statsVisibleInHierarchy(section) then
                statsActive = true
            end
        end
    end

    if statsActive then
        -- MacLib lazily mounts a paragraph with its default visibility when a
        -- tab is opened.  Re-apply the view state after that mount so a stale
        -- Top-5 card cannot replace the catalog/detail view.
        local showTop5 = statsTop5State.visible == true
        local showSkillTop5 = statsTop5State.skillVisible == true
        local showLayTop5 = statsTop5State.layVisible == true
        local showCompare = statsTop5State.compareVisible == true
        local showAnyTop5 = showTop5 or showSkillTop5 or showLayTop5 or showCompare
        local selectedCount = type(statsState.selected) == "table" and #statsState.selected or 0
        setStatsSectionVisibility("Chicken Stats Catalog", not showAnyTop5 and selectedCount == 0)
        setStatsSectionVisibility("Chicken Stat Card 1", not showAnyTop5 and selectedCount > 0)
        setStatsSectionVisibility("TOP 5 Rank by Overall • Equal Weight", showTop5)
        setStatsSectionVisibility("TOP 5 Rank by ATK / HP", showTop5)
        setStatsSectionVisibility("TOP 5 Rank by HP / ATK", showTop5)
        setStatsSectionVisibility("TOP 5 Skill • Overall", showSkillTop5)
        setStatsSectionVisibility("TOP 5 Skill • 1v1", showSkillTop5)
        setStatsSectionVisibility("TOP 5 Skill • Tank / Sustain", showSkillTop5)
        setStatsSectionVisibility("TOP 5 Skill • AOE", showSkillTop5)
        setStatsSectionVisibility("TOP 5 Lay Egg • Fastest", showLayTop5)
        setStatsSectionVisibility("COMPARE Skill Damage", showCompare)
        if not statsFullWidthState.applied then
            local left
            local right
            for _, section in ipairs(sections) do
                local side = section.Parent
                while side and side.Name ~= "Left" and side.Name ~= "Right" do
                    side = side.Parent
                end
                if side then
                    local scrolling = side.Parent
                    local leftCandidate = scrolling and scrolling:FindFirstChild("Left")
                    local rightCandidate = scrolling and scrolling:FindFirstChild("Right")
                    if leftCandidate and rightCandidate then
                        left = leftCandidate
                        right = rightCandidate
                    elseif side.Name == "Left" then
                        left = side
                    elseif side.Name == "Right" then
                        right = side
                    end
                end
            end
            if left and right then
                statsFullWidthState.left = left
                statsFullWidthState.right = right
                statsFullWidthState.leftSize = left.Size
                statsFullWidthState.rightVisible = right.Visible
                statsFullWidthState.moved = {}
                for _, section in ipairs(sections) do
                    if section.Parent == right then
                        table.insert(statsFullWidthState.moved, {
                            section = section,
                            parent = right,
                        })
                        section.Parent = left
                    end
                end
                if #statsFullWidthState.moved > 0 then
                    pcall(function()
                        left.Size = UDim2.new(
                            1,
                            -30,
                            statsFullWidthState.leftSize.Y.Scale,
                            statsFullWidthState.leftSize.Y.Offset
                        )
                        right.Visible = false
                    end)
                    statsFullWidthState.applied = true
                end
            end
        end
        -- A section can be mounted lazily after the first full-width pass.
        -- Move any newly-mounted Top-5 card into the same wide column too.
        if statsFullWidthState.applied and statsFullWidthState.left then
            for _, section in ipairs(sections) do
                if section.Parent ~= statsFullWidthState.left then
                    local alreadyTracked = false
                    for _, entry in ipairs(statsFullWidthState.moved or {}) do
                        if entry.section == section then
                            alreadyTracked = true
                            break
                        end
                    end
                    if not alreadyTracked then
                        table.insert(statsFullWidthState.moved, {
                            section = section,
                            parent = section.Parent,
                        })
                    end
                    section.Parent = statsFullWidthState.left
                end
            end
        end
    elseif statsFullWidthState.applied then
        pcall(function()
            for _, entry in ipairs(statsFullWidthState.moved) do
                if entry.section and entry.parent then
                    entry.section.Parent = entry.parent
                end
            end
            if statsFullWidthState.left and statsFullWidthState.leftSize then
                statsFullWidthState.left.Size = statsFullWidthState.leftSize
            end
            if statsFullWidthState.right then
                statsFullWidthState.right.Visible = statsFullWidthState.rightVisible ~= false
            end
        end)
        statsFullWidthState.applied = false
        statsFullWidthState.left = nil
        statsFullWidthState.right = nil
        statsFullWidthState.leftSize = nil
        statsFullWidthState.rightVisible = nil
        statsFullWidthState.moved = {}
    end
end

local refreshStatsCards
local function setStatsCardSectionVisibility(visible)
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader["Chicken Stat Card 1"] or {}) do
            if item:IsA("TextLabel") and item.Text == "Chicken Stat Card 1" then
                local paragraph = item.Parent
                local section = paragraph and paragraph.Parent
                if section and section:IsA("Frame") and section.Name == "Section" then
                    section.Visible = visible
                end
            end
        end
    end)
end

refreshStatsCards = function()
    local selected = {}
    local selectedSet = {}
    for _, typeId in ipairs(statsState.selected) do
        selectedSet[typeId] = true
    end
    for _, row in ipairs(statsRows) do
        if selectedSet[row.typeId] then
            table.insert(selected, row)
        end
    end

    local totalSelected = 0
    for _, typeId in ipairs(statsState.selected) do
        if selectedSet[typeId] then
            totalSelected += 1
        end
    end
    local shown = math.min(#selected, STATS_MAX_VISIBLE_CARDS)
    local infoLines = {
        "📚 <b>Catalog:</b> <font color=\"#7DD3FC\">" .. tostring(#statsRows) .. "</font> chicken types",
        "✅ <b>Selected:</b> <font color=\"#7BE495\">" .. tostring(totalSelected)
            .. "</font>  •  <b>Showing:</b> <font color=\"#7DD3FC\">" .. tostring(shown) .. "</font>",
        "🧬 <b>Base stats:</b> Lv." .. tostring(statsState.baseLevel)
            .. " / game cap: "
            .. (sharedEnv.ChickenStatsLevelCap and tostring(sharedEnv.ChickenStatsLevelCap) or "∞")
            .. " / no mutation",
        "🧬 <b>Genome Stat:</b> " .. tostring(statsState.genomeStat)
            .. " / max " .. tostring(sharedEnv.ChickenGenomeMax or 31)
            .. "  <font color=\"#B8C0CC\">(card cap follows Rarity)</font>",
        "📊 <b>SPD/PWR:</b> % modifier from base 1.0",
    }
    if #selected > STATS_MAX_VISIBLE_CARDS then
        table.insert(infoLines, "ℹ️ Showing first <font color=\"#FFD166\">"
            .. tostring(STATS_MAX_VISIBLE_CARDS) .. "</font>; narrow the search to view the rest.")
    end
    updateStatsParagraph("Chicken Stats Catalog", statsUi.InfoParagraph, table.concat(infoLines, "\n"))
    -- Base-stat tables, skill tables and selected stat cards are alternate
    -- views.  The two buttons toggle their own group, while the catalog or
    -- selected cards are shown only when neither Top-5 group is active.
    local showTop5 = statsTop5State.visible == true
    local showSkillTop5 = statsTop5State.skillVisible == true
    local showLayTop5 = statsTop5State.layVisible == true
    local showCompare = statsTop5State.compareVisible == true
    local showAnyTop5 = showTop5 or showSkillTop5 or showLayTop5 or showCompare
    setStatsSectionVisibility("Chicken Stats Catalog", not showAnyTop5 and #selected == 0)
    setStatsCardSectionVisibility(not showAnyTop5 and #selected > 0)
    setStatsSectionVisibility("TOP 5 Rank by Overall • Equal Weight", showTop5)
    setStatsSectionVisibility("TOP 5 Rank by ATK / HP", showTop5)
    setStatsSectionVisibility("TOP 5 Rank by HP / ATK", showTop5)
    setStatsSectionVisibility("TOP 5 Skill • Overall", showSkillTop5)
    setStatsSectionVisibility("TOP 5 Skill • 1v1", showSkillTop5)
    setStatsSectionVisibility("TOP 5 Skill • Tank / Sustain", showSkillTop5)
    setStatsSectionVisibility("TOP 5 Skill • AOE", showSkillTop5)
    setStatsSectionVisibility("TOP 5 Lay Egg • Fastest", showLayTop5)
    setStatsSectionVisibility("COMPARE Skill Damage", showCompare)

    for index = 1, STATS_MAX_VISIBLE_CARDS do
        local row = selected[index]
        if row then
            local rarityColor = statsRarityColor(row.rarity)
            local rarityLabel = tostring(row.rarity):gsub("^%l", string.upper)
            local layPeriod = tonumber(row.layPeriod) or 0
            local layText = layPeriod > 0 and (statsNumber(layPeriod) .. " sec") or "—"
            local body = tostring(index) .. ". <b>" .. statsRichText(row.name) .. "</b> "
                .. "<font color=\"" .. rarityColor .. "\"><b>["
                .. statsRichText(rarityLabel) .. "]</b></font>"
                .. "\n\n<b>Base Stats:</b> <font color=\"#FF6B6B\">HP: "
                .. statsNumber(row.hp) .. "</font>  <font color=\"#64748B\">|</font>  <font color=\"#FF9F43\">ATK: "
                .. statsNumber(row.atk) .. "</font>"
                .. "\n<b>SPD:</b> <font color=\"#5BC0EB\">" .. statsSignedPercent(row.spd)
                .. "</font>  <font color=\"#64748B\">|</font>  <b>PWR:</b> <font color=\"#C084FC\">"
                .. statsSignedPercent(row.pwr) .. "</font>"
                .. "\n<b>Egg:</b> " .. statsRichText(row.eggs)
                .. "\n<b>Found in:</b> " .. statsRichText(row.foundIn)
                .. "\n<b>Lay:</b> " .. statsRichText(layText)
                .. "\n\n" .. statsCardSkillMarkup(row.skill)
            updateStatsCard(index, body, true)
        else
            updateStatsCard(index, "No matching selected chicken.", false)
        end
    end
    -- A tab can mount/rebuild its Section immediately after the visibility
    -- update.  Apply the full-width move at the end of every refresh so the
    -- currently selected view is never left in the narrow Right column.
    pcall(applyStatsFullWidthLayout)
end

-- Show five selected-level base-stat rows in a wide table.  Rows use a balanced
-- Overall score: normalized HP, ATK, SPD and PWR contribute 25% each.
local function statsTop5Divider(widths)
    local chunks = {}
    for _, width in ipairs(widths or {}) do
        table.insert(chunks, string.rep("-", math.max(1, math.floor(tonumber(width) or 1))))
    end
    return "<font color=\"#64748B\">"
        .. table.concat(chunks, "--") .. "</font>"
end

local function statsTop5RankedRows()
    local rows = {}
    local keys = {"hp", "atk", "spd", "pwr"}
    local minimum = {}
    local maximum = {}
    for _, row in ipairs(statsRows) do
        table.insert(rows, row)
        for _, key in ipairs(keys) do
            local value = tonumber(row[key]) or 0
            minimum[key] = minimum[key] == nil and value or math.min(minimum[key], value)
            maximum[key] = maximum[key] == nil and value or math.max(maximum[key], value)
        end
    end
    local scored = {}
    for _, row in ipairs(rows) do
        local score = 0
        for _, key in ipairs(keys) do
            local value = tonumber(row[key]) or 0
            local low = minimum[key]
            local high = maximum[key]
            local normalized = high > low and ((value - low) / (high - low)) or 1
            score += normalized * 0.25
        end
        table.insert(scored, {row = row, score = score})
    end
    table.sort(scored, function(a, b)
        if a.score == b.score then
            local ap = tonumber(a.row.pwr) or 0
            local bp = tonumber(b.row.pwr) or 0
            if ap == bp then
                local aa = tonumber(a.row.atk) or 0
                local ba = tonumber(b.row.atk) or 0
                if aa == ba then
                    return string.lower(tostring(a.row.name)) < string.lower(tostring(b.row.name))
                end
                return aa > ba
            end
            return ap > bp
        end
        return a.score > b.score
    end)
    local ranked = {}
    for _, entry in ipairs(scored) do
        table.insert(ranked, entry.row)
    end
    return ranked
end

local function buildStatsTop5Body()
    local ranked = statsTop5RankedRows()
    local function top5Clip(value, width)
        local text = tostring(value or "")
        if #text > width then
            if width <= 2 then
                return string.sub(text, 1, width)
            end
            return string.sub(text, 1, width - 2) .. ".."
        end
        return text
    end
    local function top5Pad(value, width, rightAlign)
        local text = top5Clip(value, width)
        local padding = string.rep(" ", math.max(0, width - #text))
        return rightAlign and padding .. text or text .. padding
    end
    local function top5Color(value, width, color, rightAlign)
        return "<font color=\"" .. color .. "\">"
            .. statsRichText(top5Pad(value, width, rightAlign)) .. "</font>"
    end
    local function top5StatText(row, key)
        if key == "genome" then
            -- Genome is shown as the selected value clamped to the chicken's
            -- Rarity cap (for example, input 31 on a 27-cap chicken becomes
            -- 27/27).  The same clamped value drives the displayed stats.
            return statsNumber(row.genomeValue) .. "/" .. statsNumber(row.genomeCap)
        end
        if key == "spd" or key == "pwr" then
            return statsSignedPercent(row[key])
        end
        return statsNumber(row[key])
    end
    local function top5ValueWidth(key, label)
        local width = #label
        for rank = 1, 5 do
            local row = ranked[rank]
            if row then
                width = math.max(width, #top5StatText(row, key))
            end
        end
        return math.min(width, 6)
    end

    local nameWidth = #"Name"
    local rarityWidth = #"Rarity"
    for rank = 1, 5 do
        local row = ranked[rank]
        if row then
            nameWidth = math.max(nameWidth, #tostring(row.name))
            rarityWidth = math.max(rarityWidth, #tostring(row.rarity))
        end
    end
    -- Keep the table inside the card even if a future Catalog adds a very
    -- long display name; the clipped name still lines up with every column.
    nameWidth = math.min(nameWidth, 18)
    rarityWidth = math.min(rarityWidth, 9)
    local hpWidth = top5ValueWidth("hp", "HP")
    local atkWidth = top5ValueWidth("atk", "ATK")
    local spdWidth = top5ValueWidth("spd", "SPD")
    local pwrWidth = top5ValueWidth("pwr", "PWR")
    local genomeWidth = top5ValueWidth("genome", "Genome")
    local separator = "<font color=\"#64748B\">| </font>"
    local lines = {
        "🏆 <font size=\"14\"><b>TOP 5 Rank by Overall • Equal Weight</b></font>"
            .. " <font color=\"#B8C0CC\">(Lv." .. tostring(statsState.baseLevel)
            .. " • Genome " .. tostring(statsState.genomeStat) .. ")</font>",
        table.concat({
            top5Color("#", 1, "#FFD166", false),
            top5Color("Name", nameWidth, "#7DD3FC", false),
            top5Color("Rarity", rarityWidth, "#B8A1FF", false),
            top5Color("Genome", genomeWidth, "#7BE495", false),
            top5Color("HP", hpWidth, "#FF6B6B", false),
            top5Color("ATK", atkWidth, "#FF9F43", false),
            top5Color("SPD", spdWidth, "#5BC0EB", false),
            top5Color("PWR", pwrWidth, "#C084FC", false),
        }, separator),
        statsTop5Divider({1, nameWidth, rarityWidth, genomeWidth, hpWidth, atkWidth, spdWidth, pwrWidth}),
    }
    for rank = 1, 5 do
        local row = ranked[rank]
        if row then
            local rarityColor = statsRarityColor(row.rarity)
            table.insert(lines, table.concat({
                top5Color(tostring(rank), 1, "#FFD166", false),
                top5Color(row.name, nameWidth, "#7DD3FC", false),
                top5Color(row.rarity, rarityWidth, rarityColor, false),
                top5Color(top5StatText(row, "genome"), genomeWidth, "#7BE495", false),
                top5Color(top5StatText(row, "hp"), hpWidth, "#FF6B6B", false),
                top5Color(top5StatText(row, "atk"), atkWidth, "#FF9F43", false),
                top5Color(top5StatText(row, "spd"), spdWidth, "#5BC0EB", false),
                top5Color(top5StatText(row, "pwr"), pwrWidth, "#C084FC", false),
            }, separator))
        else
            table.insert(lines, table.concat({
                top5Color(tostring(rank), 1, "#FFD166", false),
                top5Color("—", nameWidth, "#64748B", false),
                top5Color("—", rarityWidth, "#64748B", false),
                top5Color("—", genomeWidth, "#64748B", false),
                top5Color("—", hpWidth, "#64748B", false),
                top5Color("—", atkWidth, "#64748B", false),
                top5Color("—", spdWidth, "#64748B", false),
                top5Color("—", pwrWidth, "#64748B", false),
            }, separator))
        end
    end
    return table.concat(lines, "\n")
end

local statsTop5Paragraph = statsUi.Top5Section:Paragraph({
    Header = "TOP 5 Rank by Overall • Equal Weight",
    Body = "",
})
statsTop5State.paragraph = statsTop5Paragraph

local function styleStatsTop5Body(bodyLabel)
    if bodyLabel and bodyLabel:IsA("TextLabel") then
        bodyLabel.Font = Enum.Font.Code
        -- The Top-5 table is a dense monospace layout.  Keep it compact enough
        -- for all columns (including PWR) to stay on the same line; at 13px
        -- the final column wrapped onto a separate line in narrower windows.
        bodyLabel.TextSize = 14
        bodyLabel.TextScaled = false
        bodyLabel.TextWrapped = true
        bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
        bodyLabel.RichText = true
    end
end

local function updateStatsTop5Paragraph(body, visible)
    local header = "TOP 5 Rank by Overall • Equal Weight"
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                item.Font = Enum.Font.GothamBold
                item.TextSize = 14
                item.TextScaled = false
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                if card then
                    card.Visible = visible
                end
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    styleStatsTop5Body(bodyLabel)
                    bodyLabel.Text = visible and body or ""
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            statsTop5Paragraph:UpdateBody(visible and body or "")
            statsTop5Paragraph:SetVisibility(visible)
        end)
    end
    setStatsSectionVisibility(header, visible)
end

sharedEnv.ChickenStatsBuildHpAtkBody = function()
    local ranked = {}
    for _, row in ipairs(statsRows) do
        table.insert(ranked, row)
    end
    -- Use one combined ranking: HP is the primary value and ATK breaks ties.
    -- This keeps the card as a single list instead of splitting HP and ATK
    -- into two separate tables.
    table.sort(ranked, function(a, b)
        local ahp = tonumber(a.hp) or 0
        local bhp = tonumber(b.hp) or 0
        if ahp ~= bhp then
            return ahp > bhp
        end
        local aatk = tonumber(a.atk) or 0
        local batk = tonumber(b.atk) or 0
        if aatk ~= batk then
            return aatk > batk
        end
        return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
    end)
    local function clip(value, width)
        local text = tostring(value or "")
        if #text > width then
            if width <= 2 then
                return string.sub(text, 1, width)
            end
            return string.sub(text, 1, width - 2) .. ".."
        end
        return text
    end
    local function pad(value, width, rightAlign)
        local text = clip(value, width)
        local padding = string.rep(" ", math.max(0, width - #text))
        return rightAlign and padding .. text or text .. padding
    end
    local function color(value, width, colorHex, rightAlign)
        return "<font color=\"" .. colorHex .. "\">"
            .. statsRichText(pad(value, width, rightAlign)) .. "</font>"
    end
    local nameWidth = 4
    local rarityWidth = 6
    for index = 1, 5 do
        local row = ranked[index]
        if row then
            nameWidth = math.max(nameWidth, #tostring(row.name))
            rarityWidth = math.max(rarityWidth, #tostring(row.rarity))
        end
    end
    nameWidth = math.min(nameWidth, 18)
    rarityWidth = math.min(rarityWidth, 9)
    local hpWidth = 2
    local atkWidth = 3
    local spdWidth = 3
    local pwrWidth = 3
    local genomeWidth = #"Genome"
    for index = 1, 5 do
        local row = ranked[index]
        if row then
            hpWidth = math.max(hpWidth, #statsNumber(row.hp))
            atkWidth = math.max(atkWidth, #statsNumber(row.atk))
            spdWidth = math.max(spdWidth, #statsSignedPercent(row.spd))
            pwrWidth = math.max(pwrWidth, #statsSignedPercent(row.pwr))
        end
    end
    hpWidth = math.min(hpWidth, 7)
    atkWidth = math.min(atkWidth, 7)
    spdWidth = math.min(spdWidth, 7)
    pwrWidth = math.min(pwrWidth, 7)
    local separator = "<font color=\"#64748B\">| </font>"
    local lines = {
        "🏆 <font size=\"14\"><b>TOP 5 Rank by HP / ATK</b></font>"
            .. " <font color=\"#B8C0CC\">(Lv." .. tostring(statsState.baseLevel)
            .. " • Genome " .. tostring(statsState.genomeStat) .. ")</font>",
        table.concat({
            color("#", 1, "#FFD166", false),
            color("Name", nameWidth, "#7DD3FC", false),
            color("Rarity", rarityWidth, "#B8A1FF", false),
            color("Genome", genomeWidth, "#7BE495", false),
            color("HP", hpWidth, "#FF6B6B", false),
            color("ATK", atkWidth, "#FF9F43", false),
            color("SPD", spdWidth, "#5BC0EB", false),
            color("PWR", pwrWidth, "#C084FC", false),
        }, separator),
        statsTop5Divider({1, nameWidth, rarityWidth, genomeWidth, hpWidth, atkWidth, spdWidth, pwrWidth}),
    }
    for rank = 1, 5 do
        local row = ranked[rank]
        if row then
            local rarityColor = statsRarityColor(row.rarity)
            table.insert(lines, table.concat({
                color(tostring(rank), 1, "#FFD166", false),
                color(row.name, nameWidth, "#7DD3FC", false),
                color(row.rarity, rarityWidth, rarityColor, false),
                color(statsNumber(row.genomeValue) .. "/" .. statsNumber(row.genomeCap), genomeWidth, "#7BE495", false),
                color(statsNumber(row.hp), hpWidth, "#FF6B6B", false),
                color(statsNumber(row.atk), atkWidth, "#FF9F43", false),
                color(statsSignedPercent(row.spd), spdWidth, "#5BC0EB", false),
                color(statsSignedPercent(row.pwr), pwrWidth, "#C084FC", false),
            }, separator))
        end
    end
    return table.concat(lines, "\n")
end

statsUi.Top5HpAtkParagraph = statsUi.Top5HpAtkSection:Paragraph({
    Header = "TOP 5 Rank by HP / ATK",
    Body = "",
})
statsTop5State.hpAtkParagraph = statsUi.Top5HpAtkParagraph

sharedEnv.ChickenStatsUpdateHpAtkParagraph = function(body, visible)
    local header = "TOP 5 Rank by HP / ATK"
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                item.Font = Enum.Font.GothamBold
                item.TextSize = 14
                item.TextScaled = false
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                if card then
                    card.Visible = visible
                end
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    styleStatsTop5Body(bodyLabel)
                    bodyLabel.Text = visible and body or ""
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            statsUi.Top5HpAtkParagraph:UpdateBody(visible and body or "")
            statsUi.Top5HpAtkParagraph:SetVisibility(visible)
        end)
    end
    setStatsSectionVisibility(header, visible)
end

-- Rank the same calculated base-stat rows by ATK first, then HP.  This gives
-- the ATK / HP view a deterministic tie-breaker without changing the other
-- base-stat ranking.
sharedEnv.ChickenStatsBuildAtkBody = function()
    local ranked = {}
    for _, row in ipairs(statsRows) do
        table.insert(ranked, row)
    end
    table.sort(ranked, function(a, b)
        local aatk = tonumber(a.atk) or 0
        local batk = tonumber(b.atk) or 0
        if aatk ~= batk then
            return aatk > batk
        end
        local ahp = tonumber(a.hp) or 0
        local bhp = tonumber(b.hp) or 0
        if ahp ~= bhp then
            return ahp > bhp
        end
        return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
    end)
    local function clip(value, width)
        local text = tostring(value or "")
        if #text > width then
            if width <= 2 then
                return string.sub(text, 1, width)
            end
            return string.sub(text, 1, width - 2) .. ".."
        end
        return text
    end
    local function pad(value, width, rightAlign)
        local text = clip(value, width)
        local padding = string.rep(" ", math.max(0, width - #text))
        return rightAlign and padding .. text or text .. padding
    end
    local function color(value, width, colorHex, rightAlign)
        return "<font color=\"" .. colorHex .. "\">"
            .. statsRichText(pad(value, width, rightAlign)) .. "</font>"
    end
    local nameWidth = 4
    local rarityWidth = 6
    for index = 1, 5 do
        local row = ranked[index]
        if row then
            nameWidth = math.max(nameWidth, #tostring(row.name))
            rarityWidth = math.max(rarityWidth, #tostring(row.rarity))
        end
    end
    nameWidth = math.min(nameWidth, 18)
    rarityWidth = math.min(rarityWidth, 9)
    local hpWidth = 2
    local atkWidth = 3
    local spdWidth = 3
    local pwrWidth = 3
    local genomeWidth = #"Genome"
    for index = 1, 5 do
        local row = ranked[index]
        if row then
            hpWidth = math.max(hpWidth, #statsNumber(row.hp))
            atkWidth = math.max(atkWidth, #statsNumber(row.atk))
            spdWidth = math.max(spdWidth, #statsSignedPercent(row.spd))
            pwrWidth = math.max(pwrWidth, #statsSignedPercent(row.pwr))
        end
    end
    hpWidth = math.min(hpWidth, 7)
    atkWidth = math.min(atkWidth, 7)
    spdWidth = math.min(spdWidth, 7)
    pwrWidth = math.min(pwrWidth, 7)
    local separator = "<font color=\"#64748B\">| </font>"
    local lines = {
        "🏆 <font size=\"14\"><b>TOP 5 Rank by ATK / HP</b></font>"
            .. " <font color=\"#B8C0CC\">(Lv." .. tostring(statsState.baseLevel)
            .. " • Genome " .. tostring(statsState.genomeStat) .. ")</font>",
        table.concat({
            color("#", 1, "#FFD166", false),
            color("Name", nameWidth, "#7DD3FC", false),
            color("Rarity", rarityWidth, "#B8A1FF", false),
            color("Genome", genomeWidth, "#7BE495", false),
            color("HP", hpWidth, "#FF6B6B", false),
            color("ATK", atkWidth, "#FF9F43", false),
            color("SPD", spdWidth, "#5BC0EB", false),
            color("PWR", pwrWidth, "#C084FC", false),
        }, separator),
        statsTop5Divider({1, nameWidth, rarityWidth, genomeWidth, hpWidth, atkWidth, spdWidth, pwrWidth}),
    }
    for rank = 1, 5 do
        local row = ranked[rank]
        if row then
            local rarityColor = statsRarityColor(row.rarity)
            table.insert(lines, table.concat({
                color(tostring(rank), 1, "#FFD166", false),
                color(row.name, nameWidth, "#7DD3FC", false),
                color(row.rarity, rarityWidth, rarityColor, false),
                color(statsNumber(row.genomeValue) .. "/" .. statsNumber(row.genomeCap), genomeWidth, "#7BE495", false),
                color(statsNumber(row.hp), hpWidth, "#FF6B6B", false),
                color(statsNumber(row.atk), atkWidth, "#FF9F43", false),
                color(statsSignedPercent(row.spd), spdWidth, "#5BC0EB", false),
                color(statsSignedPercent(row.pwr), pwrWidth, "#C084FC", false),
            }, separator))
        end
    end
    return table.concat(lines, "\n")
end

statsUi.Top5AtkParagraph = statsUi.Top5AtkSection:Paragraph({
    Header = "TOP 5 Rank by ATK / HP",
    Body = "",
})

sharedEnv.ChickenStatsUpdateAtkParagraph = function(body, visible)
    local header = "TOP 5 Rank by ATK / HP"
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                item.Font = Enum.Font.GothamBold
                item.TextSize = 14
                item.TextScaled = false
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                if card then
                    card.Visible = visible
                end
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    styleStatsTop5Body(bodyLabel)
                    bodyLabel.Text = visible and body or ""
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            statsUi.Top5AtkParagraph:UpdateBody(visible and body or "")
            statsUi.Top5AtkParagraph:SetVisibility(visible)
        end)
    end
    setStatsSectionVisibility(header, visible)
end

-- Skill rankings use the combat configuration rather than the selected
-- chicken's current HP/ATK.  The four lists are intentionally relative
-- (0-100) estimates: the same skill can perform differently depending on
-- target size, hit connection and battle positioning.  Keep the parser in a
-- nested scope because this Stats page already sits close to Luau's local
-- register limit.
sharedEnv.ChickenStatsSkillRanking = (function()
    local abilityAliases = {}
    for abilityId, ability in pairs(statsAbilities) do
        if type(ability) == "table" then
            local idText = string.lower(tostring(abilityId))
            abilityAliases[idText] = ability
            if ability.id then
                abilityAliases[string.lower(tostring(ability.id))] = ability
            end
            if ability.signature then
                abilityAliases[string.lower(tostring(ability.signature))] = ability
            end
            if ability.name then
                abilityAliases[string.lower(tostring(ability.name))] = ability
            end
        end
    end

    local nonDamagePrefixes = {
        buff = true, haste = true, slow = true, debuff = true,
        atk = true, attack = true, speed = true, health = true, hp = true,
        pacing = true, gain = true, heal = true, shield = true,
        revive = true, regen = true, scale = true, power = true,
    }

    local function keyText(value)
        return tostring(value):gsub("([a-z0-9])([A-Z])", "%1 %2")
            :gsub("_", " "):lower()
    end

    local function compactNumber(value)
        return statsNumber(tonumber(value) or 0)
    end

    local function compactMultiplier(value)
        local number = tonumber(value)
        if not number then
            return tostring(value)
        end
        return string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "") .. "×"
    end

    local function compactPercent(value)
        local number = tonumber(value) or 0
        local percent = math.abs(number) <= 1 and number * 100 or number
        return string.format("%.1f", percent):gsub("0+$", ""):gsub("%.$", "") .. "%"
    end

    local function countFor(mechanic, prefix)
        return tonumber(mechanic[prefix .. "s"])
            or tonumber(mechanic[prefix .. "Count"])
            or tonumber(mechanic[prefix .. "count"])
            or 1
    end

    local function fractionFor(value)
        local number = tonumber(value) or 0
        return math.abs(number) <= 1 and number or number / 100
    end

    local function mechanicMetrics(mechanic)
        local metrics = {
            damage = 0,
            burst = 0,
            hits = 0,
            area = 0,
            reach = 0,
            zone = 0,
            heal = 0,
            shield = 0,
            revive = 0,
            buff = 0,
            control = 0,
            summon = 0,
            duration = 0,
            statusDuration = 0,
            damageParts = {},
            timingParts = {},
            areaParts = {},
            effectParts = {},
            controlParts = {},
        }
        if type(mechanic) ~= "table" then
            return metrics
        end

        for key, value in pairs(mechanic) do
            local keyString = tostring(key)
            local lower = string.lower(keyString)
            local number = tonumber(value)
            if number then
                local prefix = keyString:match("^(.*)Mult$")
                local prefixLower = prefix and string.lower(prefix) or ""
                if prefix and prefix ~= "" and not nonDamagePrefixes[prefixLower] then
                    local count = countFor(mechanic, prefix)
                    local contribution = math.max(0, number) * math.max(1, count)
                    metrics.damage += contribution
                    metrics.burst = math.max(metrics.burst, math.max(0, number))
                    metrics.hits += math.max(1, count)
                    table.insert(metrics.damageParts, {
                        prefix = prefixLower,
                        text = keyText(prefix) .. " " .. compactMultiplier(number)
                            .. (count > 1 and " ×" .. compactNumber(count) or ""),
                    })
                end
                if lower == "radius" or lower:match("radius$") then
                    metrics.area = math.max(metrics.area, math.max(0, number))
                    table.insert(metrics.areaParts, keyText(keyString) .. " " .. compactNumber(number))
                elseif lower == "reach" or lower:match("reach$") then
                    metrics.reach = math.max(metrics.reach, math.max(0, number))
                    table.insert(metrics.areaParts, "reach " .. compactNumber(number))
                end
                if lower:match("dur$") or lower:match("seconds$") then
                    -- A poison/buff/revive timer is not an AOE zone.  Keep the
                    -- generic duration for the compact details line, but
                    -- only count explicit zone/field timers as AOE coverage.
                    metrics.duration = math.max(metrics.duration, math.max(0, number))
                    if lower == "zonedur" or lower == "fielddur"
                        or lower == "areadur" or lower == "lingerdur" then
                        metrics.zone = math.max(metrics.zone, math.max(0, number))
                    end
                    if lower:match("stundur$") or lower:match("silencedur$")
                        or lower:match("freezedur$") or lower:match("tauntdur$")
                        or lower:match("slowdur$") or lower:match("binddur$")
                        or lower:match("rootdur$") or lower:match("staggerdur$") then
                        metrics.statusDuration += math.max(0, number)
                    end
                    table.insert(metrics.effectParts, keyText(keyString) .. " " .. tostring(number) .. "s")
                end
                if lower == "windup" or lower == "cooldown" or lower == "between"
                    or lower == "pulseinterval" or lower == "waveinterval"
                    or lower == "tickinterval" or lower == "cardinterval"
                    or lower == "interval" or lower == "recover" then
                    table.insert(metrics.timingParts, keyText(keyString) .. " "
                        .. tostring(number) .. "s")
                end
                if lower:match("knock$") then
                    metrics.control += math.abs(number) / 10
                    table.insert(metrics.controlParts, keyText(keyString) .. " " .. compactNumber(number))
                elseif lower:match("up$") and lower ~= "windup" then
                    metrics.control += math.abs(number) / 20
                    table.insert(metrics.controlParts, keyText(keyString) .. " " .. compactNumber(number))
                end
                if lower == "healfrac" or lower == "tickheal" or lower == "regenfrac" then
                    local amount = math.max(0, fractionFor(number))
                    metrics.heal += amount * (lower == "tickheal" and 1.5 or 1)
                    table.insert(metrics.effectParts, "heal " .. compactPercent(number))
                elseif lower == "shieldfrac" then
                    metrics.shield += math.max(0, fractionFor(number))
                    table.insert(metrics.effectParts, "shield " .. compactPercent(number))
                elseif lower == "revivefrac" then
                    metrics.revive += math.max(0, fractionFor(number))
                    table.insert(metrics.effectParts, "revive " .. compactPercent(number))
                elseif lower == "buffmult" or lower == "hastemult"
                    or lower == "atkmult" or lower == "debuffmult" then
                    metrics.buff += math.max(0, number - 1) * 100
                    table.insert(metrics.effectParts, keyText(keyString) .. " " .. compactMultiplier(number))
                end
                if lower == "count" or lower == "copies" or lower == "summoncount"
                    or lower == "minioncount" or lower == "targetcount"
                    or lower == "maxtargets" then
                    metrics.summon = math.max(metrics.summon, math.max(0, number))
                    metrics.hits = math.max(metrics.hits, math.max(1, number))
                end
                if lower == "targets" or lower == "targetcount" or lower == "maxtargets"
                    or lower == "hitcount" or lower == "enemycount" then
                    metrics.hits = math.max(metrics.hits, math.max(1, number))
                end
            end
        end

        table.sort(metrics.damageParts, function(a, b)
            if a.prefix == "final" and b.prefix ~= "final" then
                return false
            elseif b.prefix == "final" and a.prefix ~= "final" then
                return true
            end
            return a.text < b.text
        end)
        table.sort(metrics.timingParts)
        table.sort(metrics.areaParts)
        table.sort(metrics.effectParts)
        table.sort(metrics.controlParts)
        return metrics
    end

    local function detailSummary(ability, mechanic, metrics)
        local parts = {}
        local function joinParts(items, separator)
            local values = {}
            for _, item in ipairs(items or {}) do
                table.insert(values, type(item) == "table" and tostring(item.text or "") or tostring(item))
            end
            return table.concat(values, separator or " • ")
        end
        if #metrics.damageParts > 0 then
            table.insert(parts, "ATK 100 ≈" .. compactNumber(metrics.damage * 100)
                .. " dmg • Damage " .. joinParts(metrics.damageParts, " + ")
                .. " ≈" .. compactMultiplier(metrics.damage) .. " total")
        end
        if #metrics.timingParts > 0 then
            table.insert(parts, "Timing " .. joinParts(metrics.timingParts))
        end
        if #metrics.areaParts > 0 then
            table.insert(parts, "Area " .. joinParts(metrics.areaParts))
        end
        if #metrics.effectParts > 0 then
            table.insert(parts, "Effects " .. joinParts(metrics.effectParts))
        end
        if #metrics.controlParts > 0 then
            table.insert(parts, "Control " .. joinParts(metrics.controlParts))
        end
        -- Numeric mechanics are the useful comparison in a ranking.  Keep
        -- the player-facing blurb only as a fallback when the game exposes no
        -- numbers for that ability, so the damage/timing/area/control summary
        -- does not get clipped before the important fields are shown.
        if #parts == 0 and type(ability) == "table" and type(ability.blurb) == "string"
            and ability.blurb ~= "" then
            local blurb = ability.blurb
            if #blurb > 170 then
                blurb = string.sub(blurb, 1, 168) .. ".."
            end
            table.insert(parts, blurb)
        end
        if #parts == 0 and type(mechanic) ~= "table" then
            return "No numeric mechanics exposed in client config."
        elseif #parts == 0 then
            return "Numeric mechanics are not exposed for this skill."
        end
        local text = table.concat(parts, " • ")
        if #text > 230 then
            text = string.sub(text, 1, 228) .. ".."
        end
        return text
    end

    local function collectEntries()
        local entries = {}
        local byId = {}
        for _, row in ipairs(statsRows) do
            local id = string.lower(tostring(row.skillId or ""))
            if id ~= "" then
                local entry = byId[id]
                if not entry then
                    local ability = abilityAliases[id]
                    local mechanic = statsAbilityMechanicAliases[id]
                    entry = {
                        id = id,
                        ability = ability,
                        mechanic = mechanic,
                        metrics = mechanicMetrics(mechanic),
                        owners = 0,
                        chickens = {},
                        chickenSeen = {},
                        name = ability and tostring(ability.name or row.skillId) or tostring(row.skillId),
                        rarity = ability and tostring(ability.rarity or row.rarity or "unknown")
                            or tostring(row.rarity or "unknown"),
                    }
                    local icon = ability and type(ability.icon) == "string" and ability.icon or ""
                    local kind = ability and type(ability.kind) == "string" and ability.kind or ""
                    entry.label = (icon ~= "" and icon .. " " or "") .. entry.name
                    entry.kind = kind
                    entry.detail = detailSummary(ability, mechanic, entry.metrics)
                    byId[id] = entry
                    table.insert(entries, entry)
                end
                entry.owners += 1
                local chickenName = tostring(row.name or row.typeId or "Unknown")
                if not entry.chickenSeen[chickenName] then
                    entry.chickenSeen[chickenName] = true
                    table.insert(entry.chickens, chickenName)
                end
            end
        end
        return entries
    end

    local function rawScore(metrics, category)
        local damage = metrics.damage
        local burst = metrics.burst
        local hits = math.max(1, metrics.hits)
        local area = metrics.area
        local reach = math.max(metrics.reach, area)
        local sustain = metrics.heal * 100 + metrics.shield * 110 + metrics.revive * 120
        local control = metrics.control + metrics.statusDuration * 3
        local buff = metrics.buff
        if category == "duel" then
            return burst * 10 + damage * 4 + control * 2 + reach * 0.8 + (1 / hits) * 8
        elseif category == "tank" then
            return sustain * 5 + buff * 2 + control * 1.5 + damage * 0.6 + metrics.statusDuration * 4
        elseif category == "aoe" then
            return area * 3 + hits * 2 + metrics.zone * 2 + damage * 3 + metrics.summon * 2
        end
        return damage * 6 + sustain * 1.5 + buff * 2 + control * 1.2 + area * 0.8 + hits
    end

    local function categorySummary(metrics, category)
        local area = math.max(metrics.area, metrics.reach)
        if category == "duel" then
            return "burst " .. compactMultiplier(metrics.burst)
                .. " • ATK100 " .. compactNumber(metrics.damage * 100) .. " dmg"
                .. " • reach " .. compactNumber(area)
        elseif category == "tank" then
            return "heal " .. compactPercent(metrics.heal)
                .. " • shield " .. compactPercent(metrics.shield)
                .. " • control " .. compactNumber(metrics.control)
                .. " • ATK100 " .. compactNumber(metrics.damage * 100) .. " dmg"
        elseif category == "aoe" then
            return compactNumber(metrics.hits) .. " hits • radius " .. compactNumber(metrics.area)
                .. " • zone " .. compactNumber(metrics.zone)
                .. " • ATK100 " .. compactNumber(metrics.damage * 100) .. " dmg"
        end
        return "dmg " .. compactMultiplier(metrics.damage)
            .. " (ATK100 " .. compactNumber(metrics.damage * 100) .. ")"
            .. " • " .. compactNumber(metrics.hits) .. " hits • radius " .. compactNumber(area)
    end

    local function build(category, title, basis)
        local entries = collectEntries()
        local maximum = 0
        for _, entry in ipairs(entries) do
            entry.raw = rawScore(entry.metrics, category)
            maximum = math.max(maximum, entry.raw)
        end
        table.sort(entries, function(a, b)
            if a.raw == b.raw then
                return string.lower(a.label) < string.lower(b.label)
            end
            return a.raw > b.raw
        end)

        local function clip(value, width)
            local text = tostring(value or "")
            if #text > width then
                if width <= 2 then
                    return string.sub(text, 1, width)
                end
                return string.sub(text, 1, width - 2) .. ".."
            end
            return text
        end
        local function pad(value, width, rightAlign)
            local text = clip(value, width)
            local padding = string.rep(" ", math.max(0, width - #text))
            return rightAlign and padding .. text or text .. padding
        end
        local function color(value, width, colorHex, rightAlign)
            return "<font color=\"" .. colorHex .. "\">"
                .. statsRichText(pad(value, width, rightAlign)) .. "</font>"
        end
        local function wrapText(value, width)
            local result = {}
            local current = ""
            for word in string.gmatch(tostring(value or ""), "%S+") do
                local candidate = current == "" and word or current .. " " .. word
                if current ~= "" and #candidate > width then
                    table.insert(result, current)
                    current = word
                else
                    current = candidate
                end
            end
            if current ~= "" then
                table.insert(result, current)
            end
            if #result == 0 then
                table.insert(result, "")
            end
            return result
        end
        local function ownerLines(entry)
            local result = {}
            local current = ""
            for _, chickenName in ipairs(entry.chickens or {}) do
                local name = tostring(chickenName)
                if #name > 42 then
                    name = string.sub(name, 1, 40) .. ".."
                end
                local candidate = current == "" and name or current .. ", " .. name
                if current ~= "" and #candidate > 46 then
                    table.insert(result, current)
                    current = name
                else
                    current = candidate
                end
            end
            if current ~= "" then
                table.insert(result, current)
            end
            if #result == 0 then
                table.insert(result, "Unknown")
            end
            return result
        end

        -- Keep the column row within the narrowest MacLib card.  Full
        -- mechanics are shown on wrapped detail lines below each row.
        local nameWidth = 5
        local rarityWidth = 6
        for index = 1, 5 do
            local entry = entries[index]
            if entry then
                nameWidth = math.max(nameWidth, #entry.label)
                rarityWidth = math.max(rarityWidth, #entry.rarity)
            end
        end
        nameWidth = math.min(nameWidth, 26)
        rarityWidth = math.min(rarityWidth, 9)
        local lines = {
            "🏆 <font size=\"14\"><b>" .. statsRichText(title) .. "</b></font>",
            "⚙️ <font color=\"#B8C0CC\">Config estimate • relative score 0-100</font>",
        }
        for _, basisLine in ipairs(wrapText("Basis: " .. basis, 48)) do
            table.insert(lines, "   <font color=\"#B8C0CC\">"
                .. statsRichText(basisLine) .. "</font>")
        end
        table.insert(lines, "")
        table.insert(lines, table.concat({
            color("#", 1, "#FFD166", false),
            color("Skill", nameWidth, "#7DD3FC", false),
            color("Rarity", rarityWidth, "#B8A1FF", false),
            color("Score", 5, "#FFD166", true),
        }, "<font color=\"#64748B\">| </font>"))
        table.insert(lines, statsTop5Divider({1, nameWidth, rarityWidth, 5}))
        for rank = 1, 5 do
            local entry = entries[rank]
            if entry then
                local score = maximum > 0 and math.floor(entry.raw / maximum * 100 + 0.5) or 0
                local rarityColor = statsRarityColor(entry.rarity)
                table.insert(lines, table.concat({
                    color(tostring(rank), 1, "#FFD166", false),
                    color(entry.label, nameWidth, "#7DD3FC", false),
                    color(entry.rarity, rarityWidth, rarityColor, false),
                    color(tostring(score), 5, "#FFD166", true),
                }, "<font color=\"#64748B\">| </font>"))
                for index, ownerLine in ipairs(ownerLines(entry)) do
                    table.insert(lines, "   🐔 <font color=\"#FFD166\"><b>"
                        .. (index == 1 and "Chicken: " or "          ")
                        .. statsRichText(ownerLine) .. "</b></font>")
                end
                for _, summaryLine in ipairs(wrapText("📊 "
                    .. categorySummary(entry.metrics, category), 52)) do
                    table.insert(lines, "   <font color=\"#7BE495\">"
                        .. statsRichText(summaryLine) .. "</font>")
                end
                local kind = entry.kind ~= "" and (" [" .. entry.kind .. "]") or ""
                for _, detailLine in ipairs(wrapText(entry.detail .. kind, 52)) do
                    table.insert(lines, "   ↳ <font color=\"#94A3B8\">"
                        .. statsRichText(detailLine) .. "</font>")
                end
                table.insert(lines, "")
            else
                table.insert(lines, color(tostring(rank), 1, "#FFD166", false)
                    .. "<font color=\"#64748B\"> | no skill config</font>")
            end
        end
        return table.concat(lines, "\n")
    end

    return {
        build = build,
    }
end)()

sharedEnv.ChickenStatsBuildSkillTop5Bodies = function()
    local ranking = sharedEnv.ChickenStatsSkillRanking
    return {
        overall = ranking.build("overall", "TOP 5 Skill • Overall", "damage + sustain + buffs + control + area"),
        duel = ranking.build("duel", "TOP 5 Skill • 1v1", "burst + single-target damage + control + reach"),
        tank = ranking.build("tank", "TOP 5 Skill • Tank / Sustain", "healing + shield + sustain + control"),
        aoe = ranking.build("aoe", "TOP 5 Skill • AOE", "area + hit count + zone duration + damage"),
    }
end

sharedEnv.ChickenStatsUI.Top5SkillParagraphs = {
    overall = sharedEnv.ChickenStatsUI.Top5SkillOverallSection:Paragraph({
        Header = "TOP 5 Skill • Overall",
        Body = "",
    }),
    duel = sharedEnv.ChickenStatsUI.Top5SkillDuelSection:Paragraph({
        Header = "TOP 5 Skill • 1v1",
        Body = "",
    }),
    tank = sharedEnv.ChickenStatsUI.Top5SkillTankSection:Paragraph({
        Header = "TOP 5 Skill • Tank / Sustain",
        Body = "",
    }),
    aoe = sharedEnv.ChickenStatsUI.Top5SkillAoeSection:Paragraph({
        Header = "TOP 5 Skill • AOE",
        Body = "",
    }),
}

sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs = function(visible)
    local bodies = visible and sharedEnv.ChickenStatsBuildSkillTop5Bodies() or {}
    local definitions = {
        {key = "overall", header = "TOP 5 Skill • Overall"},
        {key = "duel", header = "TOP 5 Skill • 1v1"},
        {key = "tank", header = "TOP 5 Skill • Tank / Sustain"},
        {key = "aoe", header = "TOP 5 Skill • AOE"},
    }
    for _, definition in ipairs(definitions) do
        local paragraph = sharedEnv.ChickenStatsUI.Top5SkillParagraphs[definition.key]
        local body = visible and bodies[definition.key] or ""
        local directUpdated = false
        sharedEnv.ChickenStatsEnsureGuiCache()
        pcall(function()
            for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[definition.header] or {}) do
                if item:IsA("TextLabel") and item.Text == definition.header then
                    item.Font = Enum.Font.GothamBold
                    item.TextSize = 14
                    item.TextScaled = false
                    item.Visible = false
                    local card = item.Parent
                    local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                    if card then
                        card.Visible = visible
                    end
                    if bodyLabel and bodyLabel:IsA("TextLabel") then
                        styleStatsTop5Body(bodyLabel)
                        bodyLabel.Text = body
                        directUpdated = true
                    end
                end
            end
        end)
        if not directUpdated then
            pcall(function()
                paragraph:UpdateBody(body)
                paragraph:SetVisibility(visible)
            end)
        end
        setStatsSectionVisibility(definition.header, visible)
    end
end

-- Rank the calculated egg-lay periods from fastest (fewest seconds) to
-- slowest.  Lay time uses the same selected Genome Stat and fertility
-- multiplier shown on each stat card, so changing Genome refreshes this list.
sharedEnv.ChickenStatsBuildLayBody = function()
    local ranked = {}
    for _, row in ipairs(statsRows) do
        local layPeriod = tonumber(row.layPeriod)
        if layPeriod and layPeriod > 0 and layPeriod < math.huge then
            table.insert(ranked, row)
        end
    end
    table.sort(ranked, function(a, b)
        local alay = tonumber(a.layPeriod) or math.huge
        local blay = tonumber(b.layPeriod) or math.huge
        if alay ~= blay then
            return alay < blay
        end
        return string.lower(tostring(a.name)) < string.lower(tostring(b.name))
    end)

    local function clip(value, width)
        local text = tostring(value or "")
        if #text > width then
            if width <= 2 then
                return string.sub(text, 1, width)
            end
            return string.sub(text, 1, width - 2) .. ".."
        end
        return text
    end
    local function pad(value, width)
        local text = clip(value, width)
        return text .. string.rep(" ", math.max(0, width - #text))
    end
    local function color(value, width, colorHex)
        return "<font color=\"" .. colorHex .. "\">"
            .. statsRichText(pad(value, width)) .. "</font>"
    end

    local nameWidth = 4
    local rarityWidth = 6
    local layWidth = 6
    for index = 1, 5 do
        local row = ranked[index]
        if row then
            nameWidth = math.max(nameWidth, #tostring(row.name))
            rarityWidth = math.max(rarityWidth, #tostring(row.rarity))
            layWidth = math.max(layWidth, #statsNumber(row.layPeriod) + 1)
        end
    end
    nameWidth = math.min(nameWidth, 20)
    rarityWidth = math.min(rarityWidth, 9)
    layWidth = math.min(layWidth, 8)
    local separator = "<font color=\"#64748B\">| </font>"
    local lines = {
        "🏆 <font size=\"14\"><b>TOP 5 Lay Egg • Fastest</b></font>"
            .. " <font color=\"#B8C0CC\">(Genome " .. tostring(statsState.genomeStat) .. ")</font>",
        "⚙️ <font color=\"#B8C0CC\">Lower seconds = faster egg laying</font>",
        table.concat({
            color("#", 1, "#FFD166"),
            color("Name", nameWidth, "#7DD3FC"),
            color("Rarity", rarityWidth, "#B8A1FF"),
            color("Lay(s)", layWidth, "#7BE495"),
        }, separator),
        statsTop5Divider({1, nameWidth, rarityWidth, layWidth}),
    }
    for rank = 1, 5 do
        local row = ranked[rank]
        if row then
            table.insert(lines, table.concat({
                color(tostring(rank), 1, "#FFD166"),
                color(row.name, nameWidth, "#7DD3FC"),
                color(row.rarity, rarityWidth, statsRarityColor(row.rarity)),
                color(statsNumber(row.layPeriod) .. "s", layWidth, "#7BE495"),
            }, separator))
        else
            table.insert(lines, table.concat({
                color(tostring(rank), 1, "#FFD166"),
                color("—", nameWidth, "#64748B"),
                color("—", rarityWidth, "#64748B"),
                color("—", layWidth, "#64748B"),
            }, separator))
        end
    end
    return table.concat(lines, "\n")
end

sharedEnv.ChickenStatsUI.Top5LayParagraph = statsUi.Top5LaySection:Paragraph({
    Header = "TOP 5 Lay Egg • Fastest",
    Body = "",
})

sharedEnv.ChickenStatsUpdateLayParagraph = function(body, visible)
    local header = "TOP 5 Lay Egg • Fastest"
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                item.Font = Enum.Font.GothamBold
                item.TextSize = 14
                item.TextScaled = false
                item.Visible = false
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                if card then
                    card.Visible = visible
                end
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    styleStatsTop5Body(bodyLabel)
                    bodyLabel.Text = body
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            sharedEnv.ChickenStatsUI.Top5LayParagraph:UpdateBody(body)
            sharedEnv.ChickenStatsUI.Top5LayParagraph:SetVisibility(visible)
        end)
    end
    setStatsSectionVisibility(header, visible)
end

-- Side-by-side comparison for the selected chickens' configured abilities.
-- Keep the table config-based: it compares the raw multipliers/timing exposed
-- by the client and does not pretend to know armor, misses, or AOE target count.
sharedEnv.ChickenStatsBuildCompareSkillBody = function()
    local rowById = {}
    for _, row in ipairs(statsRows) do
        rowById[row.typeId] = row
    end
    local selectedRows = {}
    local seen = {}
    for _, typeId in ipairs(statsCompareState.selected) do
        if not seen[typeId] and rowById[typeId] then
            table.insert(selectedRows, rowById[typeId])
            seen[typeId] = true
        end
    end

    local lines = {
        "⚖️ <font size=\"14\"><b>COMPARE Skill DMG</b></font>",
        "⚙️ <font color=\"#B8C0CC\">เลือกหลายตัวเพื่อเทียบค่าจาก config เดียวกัน</font>",
    }
    if #selectedRows == 0 then
        table.insert(lines, "")
        table.insert(lines, "📋 ยังไม่ได้เลือกไก่สำหรับเปรียบเทียบ")
        table.insert(lines, "   เลือกจาก Compare Skill Chickens (Multi-select) ด้านบน")
        return table.concat(lines, "\n")
    end

    local function multiplier(value)
        local number = tonumber(value)
        if not number then
            return tostring(value or "—")
        end
        return string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "") .. "×"
    end
    local function seconds(value)
        local number = tonumber(value)
        if not number then
            return "—"
        end
        return string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "") .. "s"
    end
    local function countFor(mechanic, prefix)
        return tonumber(mechanic[prefix .. "s"])
            or tonumber(mechanic[prefix .. "Count"])
            or tonumber(mechanic[prefix .. "count"])
            or 1
    end
    local function isReactive(prefix)
        prefix = string.lower(tostring(prefix or ""))
        return prefix:find("riposte", 1, true) ~= nil
            or prefix:find("counter", 1, true) ~= nil
            or prefix:find("reflect", 1, true) ~= nil
            or prefix:find("retaliat", 1, true) ~= nil
            or prefix:find("revenge", 1, true) ~= nil
            or prefix:find("vengeance", 1, true) ~= nil
            or prefix:find("backlash", 1, true) ~= nil
            or prefix:find("thorn", 1, true) ~= nil
            or prefix == "return"
    end
    local function isMain(prefix)
        prefix = string.lower(tostring(prefix or ""))
        return prefix == "final" or prefix == "burst" or prefix == "blast"
            or prefix == "explosion" or prefix == "detonation"
            or prefix == "shockwave" or prefix:find("final", 1, true) == 1
    end
    local nonDamage = {
        buff = true, haste = true, slow = true, debuff = true,
        atk = true, attack = true, speed = true, health = true, hp = true,
        pacing = true, gain = true, heal = true, shield = true,
        revive = true, regen = true, scale = true, power = true,
    }
    -- Compact non-damage effects for the compare table.  Keep this separate
    -- from the damage parser so an effect cell never counts a buff, shield or
    -- control value as damage.
    local function effectSummary(mechanic, ability)
        local parts = {}
        local function add(value)
            if value ~= nil and tostring(value) ~= "" then
                table.insert(parts, tostring(value))
            end
        end
        local function percent(value)
            local number = tonumber(value)
            if not number then
                return tostring(value)
            end
            local valuePercent = math.abs(number) <= 1 and number * 100 or number
            return string.format("%.1f", valuePercent):gsub("0+$", ""):gsub("%.$", "") .. "%"
        end
        local function mult(value)
            local number = tonumber(value)
            if not number then
                return tostring(value)
            end
            return string.format("%.2f", number):gsub("0+$", ""):gsub("%.$", "") .. "×"
        end
        local function keyLabel(value)
            return tostring(value):gsub("([a-z0-9])([A-Z])", "%1 %2")
                :gsub("_", " "):lower()
        end
        local function sec(value)
            return seconds(value) or (tostring(value) .. "s")
        end
        if type(mechanic) == "table" then
            for _, field in ipairs({
                {"healFrac", "heal"}, {"tickHeal", "heal/tick"},
                {"regenFrac", "regen"}, {"shieldFrac", "shield"},
                {"reviveFrac", "revive"}, {"stealFrac", "life steal"},
                {"pickupFrac", "pickup"}, {"puffFrac", "puff"},
                {"pulseFrac", "pulse effect"},
            }) do
                local value = tonumber(mechanic[field[1]])
                if value then
                    add(field[2] .. " " .. percent(value))
                end
            end
            for _, field in ipairs({
                {"buffMult", "buff"}, {"hasteMult", "haste"},
                {"atkMult", "ATK"}, {"slowMult", "slow"},
                {"debuffMult", "debuff"}, {"gainMult", "gain"},
                {"baseBuff", "base buff"}, {"maxBuff", "max buff"},
            }) do
                local value = tonumber(mechanic[field[1]])
                if value then
                    add(field[2] .. " " .. mult(value))
                end
            end
            for key, value in pairs(mechanic) do
                local lower = string.lower(tostring(key))
                local number = tonumber(value)
                if number and (lower:match("dur$") or lower:match("seconds$")) then
                    add(keyLabel(key):gsub(" seconds$", ""):gsub(" dur$", "")
                        .. " " .. sec(number))
                elseif number and lower:match("knock$") then
                    add(keyLabel(key) .. " " .. statsNumber(number))
                elseif number and lower:match("up$") and lower ~= "windup" then
                    add(keyLabel(key) .. " " .. statsNumber(number))
                end
            end
            local summonName = mechanic.minionName or mechanic.minionType
            if summonName then
                local count = tonumber(mechanic.count) or tonumber(mechanic.copies)
                    or tonumber(mechanic.summonCount) or 1
                local summon = "summon " .. statsNumber(count) .. "× " .. tostring(summonName)
                if tonumber(mechanic.life) then
                    summon = summon .. " (" .. sec(mechanic.life) .. ")"
                end
                add(summon)
            end
            if tonumber(mechanic.executeBelow) then
                add("execute <" .. percent(mechanic.executeBelow) .. " HP")
            end
            if tonumber(mechanic.jackpotAt) then
                add("jackpot " .. percent(mechanic.jackpotAt))
            end
            if tonumber(mechanic.fakes) then
                add(statsNumber(mechanic.fakes) .. " fake markers")
            end
        end
        if #parts == 0 and type(ability) == "table" then
            local description = type(ability.blurb) == "string" and ability.blurb
                or type(ability.description) == "string" and ability.description
                or type(ability.desc) == "string" and ability.desc or ""
            if #description > 80 then
                description = string.sub(description, 1, 78) .. ".."
            end
            if description ~= "" then
                add(description)
            end
        end
        return #parts > 0 and table.concat(parts, " • ") or "—"
    end
    local function skillEntry(row)
        local skillId = string.lower(tostring(row.skillId or ""))
        local ability = statsAbilities[row.skillId] or statsAbilities[skillId]
        if not ability then
            for abilityId, candidate in pairs(statsAbilities) do
                if string.lower(tostring(abilityId)) == skillId then
                    ability = candidate
                    break
                end
            end
        end
        local mechanic = statsAbilityMechanicAliases[skillId]
        local subParts = {}
        local mainParts = {}
        local fixedTotal = 0
        local reactive = false
        local multiHit = false
        local periodic = false
        local maxDamageCount = 1
        if type(mechanic) == "table" then
            for key, value in pairs(mechanic) do
                local keyText = tostring(key)
                local prefix = keyText:match("^(.*)Mult$")
                local lower = prefix and string.lower(prefix) or ""
                local number = tonumber(value)
                if prefix and prefix ~= "" and number and not nonDamage[lower] then
                    local count = countFor(mechanic, prefix)
                    maxDamageCount = math.max(maxDamageCount, count)
                    local text = multiplier(number)
                    if count > 1 then
                        multiHit = true
                        text = text .. " × " .. statsNumber(count)
                    end
                    if lower:find("tick", 1, true) ~= nil
                        or lower:find("pulse", 1, true) ~= nil
                        or lower:find("wave", 1, true) ~= nil
                        or lower:find("dot", 1, true) ~= nil then
                        periodic = true
                    end
                    if isReactive(lower) then
                        reactive = true
                        table.insert(mainParts, text .. " / trigger")
                    else
                        fixedTotal += number * math.max(1, count)
                        if isMain(lower) then
                            table.insert(mainParts, text)
                        else
                            table.insert(subParts, text)
                        end
                    end
                end
            end
        end
        table.sort(subParts)
        table.sort(mainParts)

        local intervalParts = {}
        for _, field in ipairs({
            {"cardInterval", "card"}, {"tickInterval", "tick"},
            {"pulseInterval", "pulse"}, {"waveInterval", "wave"},
            {"interval", "interval"}, {"between", "between"},
        }) do
            local value = tonumber(mechanic and mechanic[field[1]])
            if value then
                table.insert(intervalParts, field[2] .. " " .. seconds(value))
            end
        end
        local sequenceInterval = 0
        for _, field in ipairs({
            "cardInterval", "tickInterval", "pulseInterval", "waveInterval",
            "interval", "between",
        }) do
            sequenceInterval = math.max(sequenceInterval,
                tonumber(mechanic and mechanic[field]) or 0)
        end
        local activeDuration = 0
        for key, value in pairs(mechanic or {}) do
            local keyLower = string.lower(tostring(key))
            local number = tonumber(value)
            if number and number > 0 then
                local reactiveWindow = keyLower == "linkdur"
                    or keyLower == "guarddur"
                    or keyLower == "counterdur"
                    or keyLower == "reflectdur"
                    or keyLower == "ripostedur"
                    or keyLower:match("(link|guard|counter|reflect|riposte|retaliat|revenge|vengeance|backlash|thorn|thorns)[a-z]*dur$") ~= nil
                local damageDuration = keyLower == "zonedur"
                    or keyLower == "fielddur"
                    or keyLower == "areadur"
                    or keyLower == "lingerdur"
                    or keyLower:match("(poison|bleed|burn)[a-z]*dur$") ~= nil
                if reactiveWindow or damageDuration then
                    activeDuration = math.max(activeDuration, number)
                end
            end
        end
        local windupSeconds = math.max(0, tonumber(mechanic and mechanic.windup) or 0)
        local recoverSeconds = math.max(0, tonumber(mechanic and mechanic.recover) or 0)
        local cycleSeconds = windupSeconds
            + sequenceInterval * math.max(0, maxDamageCount - 1)
            + recoverSeconds
        cycleSeconds = math.max(cycleSeconds, activeDuration)
        local configuredCooldown = math.max(0,
            tonumber(mechanic and mechanic.cooldown)
                or tonumber(ability and ability.cooldown) or 0)
        cycleSeconds = math.max(cycleSeconds, configuredCooldown)
        local areaParts = {}
        for _, field in ipairs({
            {"circleRadius", "circle"}, {"tickRadius", "tick"},
            {"burstRadius", "burst"}, {"finalRadius", "final"},
            {"blastRadius", "blast"}, {"radius", "radius"},
            {"reach", "reach"},
        }) do
            local value = tonumber(mechanic and mechanic[field[1]])
            if value then
                -- Keep a visible gap between the radius label and its number
                -- so the compact table remains readable.
                table.insert(areaParts, field[2] .. " " .. statsNumber(value))
            end
        end
        local skillName = ability and tostring(ability.name or row.skillId)
            or tostring(row.skillId ~= "" and row.skillId or "Unknown")
        local rarity = ability and tostring(ability.rarity or row.rarity) or tostring(row.rarity)
        local chicken = tostring(row.name or row.typeId)
        local typeParts = {}
        if #areaParts > 0 then
            table.insert(typeParts, "AOE")
        end
        if multiHit then
            table.insert(typeParts, "multi")
        elseif periodic then
            table.insert(typeParts, "periodic")
        end
        if #mainParts > 0 then
            table.insert(typeParts, "burst")
        end
        if reactive then
            table.insert(typeParts, "reactive")
        end
        local skillPattern = #typeParts > 0 and table.concat(typeParts, "+") or ""
        local attackType = ability and (ability.kind or ability.type
            or ability.rangeType or ability.attackType) or ""
        if attackType == "" and type(mechanic) == "table" then
            attackType = mechanic.kind or mechanic.type or mechanic.rangeType or ""
        end
        attackType = tostring(attackType or "")
        if attackType == "" then
            attackType = "—"
        else
            attackType = attackType:gsub("^%l", string.upper)
        end
        return {
            chicken = chicken,
            rarity = rarity,
            skill = skillName,
            type = attackType,
            pattern = skillPattern ~= "" and skillPattern or "—",
            effect = effectSummary(mechanic, ability),
            sub = #subParts > 0 and table.concat(subParts, " + ") or "—",
            main = #mainParts > 0 and table.concat(mainParts, " + ") or "—",
            total = fixedTotal > 0 and multiplier(fixedTotal) or "—",
            reactive = reactive,
            windup = seconds(mechanic and mechanic.windup),
            interval = #intervalParts > 0 and table.concat(intervalParts, " / ") or "—",
            recover = seconds(mechanic and mechanic.recover),
            cooldown = cycleSeconds > 0 and seconds(cycleSeconds) or "—",
            area = #areaParts > 0 and table.concat(areaParts, " / ") or "—",
        }
    end

    local entries = {}
    local maxColumns = math.min(#selectedRows, 4)
    for index = 1, maxColumns do
        table.insert(entries, skillEntry(selectedRows[index]))
    end
    local function displayLength(value)
        local text = tostring(value or "")
        local length = utf8.len(text)
        return length or #text
    end
    local function clip(value, width)
        local text = tostring(value or "—")
        if displayLength(text) > width then
            if width <= 2 then
                return string.sub(text, 1, width)
            end
            return string.sub(text, 1, width - 2) .. ".."
        end
        return text
    end
    local function cell(value, width, colorHex)
        local text = clip(value, width)
        return "<font color=\"" .. colorHex .. "\">"
            .. statsRichText(text .. string.rep(" ",
                math.max(0, width - displayLength(text)))) .. "</font>"
    end
    local metricWidth = 14
    local valueWidth = maxColumns == 1 and 24
        or maxColumns == 2 and 19
        or maxColumns == 3 and 13 or 9
    local separator = "<font color=\"#64748B\">| </font>"
    local rowData = {
        {"Skill", "skill", "#B8A1FF"},
        {"Type", "type", "#7DD3FC"},
        {"Skill pattern", "pattern", "#C084FC"},
        {"Effect", "effect", "#FFD166"},
        {"Main damage", "main", "#FF6B6B"},
        {"Sub damage", "sub", "#FF9F43"},
        {"Total / cast", "total", "#FFFFFF"},
        {"Cooldown / cycle", "cooldown", "#FFD166"},
        {"Area", "area", "#7DD3FC"},
    }
    -- Put the chicken name in each value-column header.  The Skill row below
    -- identifies the configured ability, so names do not need a duplicate row.
    local header = {cell("Skill", metricWidth, "#FFD166")}
    for _, entry in ipairs(entries) do
        table.insert(header, cell(entry.chicken, valueWidth, "#FFD166"))
    end
    table.insert(lines, "")
    table.insert(lines, table.concat(header, separator))
    local widths = {metricWidth}
    for _ = 1, maxColumns do
        table.insert(widths, valueWidth)
    end
    table.insert(lines, statsTop5Divider(widths))
    for _, definition in ipairs(rowData) do
        local rowLine = {cell(definition[1], metricWidth, definition[3])}
        for _, entry in ipairs(entries) do
            local value = entry[definition[2]]
            if definition[2] == "total" and entry.reactive then
                value = value == "—" and "reactive / trigger"
                    or value .. " + reactive"
            end
            table.insert(rowLine, cell(value, valueWidth, definition[3]))
        end
        table.insert(lines, table.concat(rowLine, separator))
    end
    if #selectedRows > maxColumns then
        table.insert(lines, "")
        table.insert(lines, "ℹ️ แสดง 4 ตัวแรกเพื่อไม่ให้ตารางล้นหน้าต่าง")
    end
    return table.concat(lines, "\n")
end

-- The comparison picker lives in the comparison section so it appears next to
-- the table only when the user opens Compare Skill DMG.  Keep the display
-- labels human-readable while mapping each choice back to one catalog type.
do
    local optionSeen = {}
    for _, row in ipairs(statsRows) do
        local base = tostring(row.name or row.typeId)
            .. " [" .. tostring(row.rarity or "unknown") .. "]"
        local option = base
        optionSeen[base] = (optionSeen[base] or 0) + 1
        if optionSeen[base] > 1 then
            option = base .. " #" .. tostring(optionSeen[base])
        end
        table.insert(statsCompareState.options, option)
        statsCompareState.optionToType[option] = row.typeId
        statsCompareState.typeToOption[row.typeId] = option
        statsCompareState.optionOrder[option] = #statsCompareState.options
    end
    if #statsCompareState.options == 0 then
        table.insert(statsCompareState.options, "(No chicken skills)")
    end

    statsCompareState.dropdown = statsUi.CompareSection:Dropdown({
        Name = "Compare Skill Chickens (Multi-select)",
        Search = true,
        Multi = true,
        Required = false,
        Options = statsCompareState.options,
        Default = {},
        Callback = function(value)
            if loadingControls or statsCompareState.reordering then
                return
            end
            local selected = {}
            local selectedSeen = {}
            if type(value) == "table" then
                for key, state in pairs(value) do
                    local option
                    local enabled
                    if type(key) == "number" and type(state) == "string" then
                        option = state
                        enabled = true
                    else
                        option = key
                        enabled = state == true
                    end
                    local typeId = statsCompareState.optionToType[option]
                    if enabled and typeId and not selectedSeen[typeId] then
                        table.insert(selected, typeId)
                        selectedSeen[typeId] = true
                    end
                end
            end
            table.sort(selected, function(a, b)
                local aOrder = statsCompareState.optionOrder[
                    statsCompareState.typeToOption[a]] or math.huge
                local bOrder = statsCompareState.optionOrder[
                    statsCompareState.typeToOption[b]] or math.huge
                return aOrder < bOrder
            end)
            statsCompareState.selected = selected
            pcall(function()
                statsCompareState.dropdown:UpdateName(
                    "Compare Skill Chickens (Multi-select) • "
                        .. tostring(#selected) .. " selected"
                )
            end)
            if statsTop5State.compareVisible then
                sharedEnv.ChickenStatsUpdateCompareParagraph(
                    sharedEnv.ChickenStatsBuildCompareSkillBody(), true)
            end
        end,
    }, "StatsCompareSkillSelection")
    sharedEnv.ChickenStatsUI.CompareDropdown = statsCompareState.dropdown
    pcall(function()
        -- Do not inherit the main Stats picker selection from a MacLib config
        -- cache; comparison starts empty and is opt-in.
        statsCompareState.dropdown:UpdateSelection({})
        statsCompareState.dropdown:UpdateName(
            "Compare Skill Chickens (Multi-select) • 0 selected"
        )
    end)
end

sharedEnv.ChickenStatsUI.CompareParagraph = statsUi.CompareSection:Paragraph({
    Header = "COMPARE Skill Damage",
    Body = "",
})
statsCompareState.paragraph = sharedEnv.ChickenStatsUI.CompareParagraph

sharedEnv.ChickenStatsUpdateCompareParagraph = function(body, visible)
    local header = "COMPARE Skill Damage"
    local directUpdated = false
    sharedEnv.ChickenStatsEnsureGuiCache()
    pcall(function()
        for _, item in ipairs(sharedEnv.ChickenStatsGuiCache.byHeader[header] or {}) do
            if item:IsA("TextLabel") and item.Text == header then
                item.Font = Enum.Font.GothamBold
                item.TextSize = 14
                item.TextScaled = false
                item.Visible = false
                local card = item.Parent
                local bodyLabel = card and card:FindFirstChild("ParagraphBody")
                if card then
                    card.Visible = visible
                end
                if bodyLabel and bodyLabel:IsA("TextLabel") then
                    styleStatsTop5Body(bodyLabel)
                    bodyLabel.Text = body
                    directUpdated = true
                end
            end
        end
    end)
    if not directUpdated then
        pcall(function()
            sharedEnv.ChickenStatsUI.CompareParagraph:UpdateBody(body)
            sharedEnv.ChickenStatsUI.CompareParagraph:SetVisibility(visible)
        end)
    end
    setStatsSectionVisibility(header, visible)
end

updateStatsTop5Paragraph("", false)
sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
sharedEnv.ChickenStatsUpdateLayParagraph("", false)
sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
-- Keep Top-5 opt-in while the picker and stat inputs are mounted below it.
statsTop5State.visible = false
statsTop5State.skillVisible = false
statsTop5State.layVisible = false
statsTop5State.compareVisible = false
updateStatsTop5Paragraph("", false)
sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
sharedEnv.ChickenStatsUpdateLayParagraph("", false)
sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
refreshStatsCards()

local function ensureStatsDropdownScroller(dropdown, frame)
    if not frame then
        return nil
    end
    local scroll = frame:FindFirstChild("ChickenStatsOptionsScroll")
    if not scroll then
        scroll = Instance.new("ScrollingFrame")
        scroll.Name = "ChickenStatsOptionsScroll"
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Active = true
        scroll.ScrollingEnabled = true
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageTransparency = 0.15
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.Size = UDim2.new(1, 0, 0, STATS_DROPDOWN_LIST_HEIGHT)
        scroll.LayoutOrder = 0
        scroll.Parent = frame

        local list = Instance.new("UIListLayout")
        list.Name = "ChickenStatsOptionsLayout"
        list.Padding = UDim.new(0, STATS_DROPDOWN_ROW_GAP)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = scroll
    end

    scroll.Size = UDim2.new(1, 0, 0, STATS_DROPDOWN_LIST_HEIGHT)
    scroll.Active = true
    scroll.ScrollingEnabled = true

    local search = frame:FindFirstChild("Search")
    if search then
        search.LayoutOrder = -1
    end

    -- MacLib inserts/reinserts option buttons directly under DropdownFrame.
    -- Move only direct children into our scrolling viewport while retaining all
    -- existing button connections and MacLib's OptionObjs references.  Once
    -- mounted, the normal refresh path no longer loops over all 404 options.
    for _, optionButton in ipairs(frame:GetChildren()) do
        if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
            optionButton.Parent = scroll
            optionButton.Size = UDim2.new(1, 0, 0, STATS_DROPDOWN_ROW_HEIGHT)
        end
    end

    local list = scroll:FindFirstChild("ChickenStatsOptionsLayout")
    if list and not scroll:GetAttribute("ChickenStatsCanvasHook") then
        scroll:SetAttribute("ChickenStatsCanvasHook", true)
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    if list then
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
    end
    return scroll
end

local function setStatsDropdownOrder(orderedOptions)
    if type(orderedOptions) ~= "table" then
        orderedOptions = {}
        local orderedSeen = {}
        for _, typeId in ipairs(statsState.selected) do
            local option = statsTypeToOption[typeId]
            if option and not orderedSeen[option] then
                table.insert(orderedOptions, option)
                orderedSeen[option] = true
            end
        end
        for _, row in ipairs(statsRows) do
            if not orderedSeen[row.option] then
                table.insert(orderedOptions, row.option)
                orderedSeen[row.option] = true
            end
        end
    end
    local orderByOption = {}
    for index, option in ipairs(orderedOptions or {}) do
        orderByOption[option] = index
    end
    local dropdownFrames = sharedEnv.ChickenStatsGetDropdownFrames()
    pcall(function()
        for _, dropdown in ipairs(dropdownFrames) do
            local frame = dropdown:FindFirstChild("DropdownFrame")
            if frame then
                local optionContainer = ensureStatsDropdownScroller(dropdown, frame) or frame
                for _, optionButton in ipairs(optionContainer:GetChildren()) do
                    if optionButton:IsA("TextButton") then
                        local optionName = optionButton:FindFirstChild("OptionName")
                        local order = optionName and orderByOption[optionName.Text]
                        if order then
                            optionButton.LayoutOrder = order
                        end
                    end
                end
            end
        end
    end)
end

local function refreshStatsDropdownList()
    local dropdownFrames = sharedEnv.ChickenStatsGetDropdownFrames()
    local found = false
    pcall(function()
        for _, dropdown in ipairs(dropdownFrames) do
            found = true
            local frame = dropdown:FindFirstChild("DropdownFrame")
            local search = frame and frame:FindFirstChild("Search")
            local searchBox = search and search:FindFirstChild("SearchBox")
            local query = string.lower(tostring(searchBox and searchBox.Text or ""))
            if frame then
                local optionContainer = ensureStatsDropdownScroller(dropdown, frame) or frame
                for _, optionButton in ipairs(optionContainer:GetChildren()) do
                    if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
                        local optionName = optionButton:FindFirstChild("OptionName")
                        local optionText = string.lower(optionName and optionName.Text or "")
                        optionButton.Visible = query == ""
                            or string.find(optionText, query, 1, true) ~= nil
                    end
                end

                if frame.Visible then
                    local padding = frame:FindFirstChild("DropdownFrameUIPadding")
                    local paddingHeight = padding
                        and padding.PaddingTop.Offset + padding.PaddingBottom.Offset or 0
                    local searchHeight = search and search.AbsoluteSize.Y or 30
                    dropdown.Size = UDim2.new(1, 0, 0,
                        math.min(STATS_DROPDOWN_MAX_HEIGHT,
                            searchHeight + STATS_DROPDOWN_LIST_HEIGHT + paddingHeight + 8))
                    end
                end

            if not dropdown:GetAttribute("ChickenStatsListHooks") then
                dropdown:SetAttribute("ChickenStatsListHooks", true)
                if searchBox then
                    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                        local scroll = frame and frame:FindFirstChild("ChickenStatsOptionsScroll")
                        if scroll then
                            scroll.CanvasPosition = Vector2.new(0, 0)
                        end
                        task.defer(refreshStatsDropdownList)
                    end)
                end
                local interact = dropdown:FindFirstChild("Interact")
                if interact then
                    interact.MouseButton1Click:Connect(function()
                        local scroll = frame and frame:FindFirstChild("ChickenStatsOptionsScroll")
                        if scroll then
                            scroll.CanvasPosition = Vector2.new(0, 0)
                        end
                        task.defer(refreshStatsDropdownList)
                        -- MacLib's open/close tween recalculates the full
                        -- Catalog height after the click.  Run again after the
                        -- tween so the compact list height wins.
                        task.delay(0.3, refreshStatsDropdownList)
                        task.delay(0.7, refreshStatsDropdownList)
                    end
                    )
                end
            end
        end
    end)
    return found
end

local statsDefaultOptions = {}
local statsDropdownOptions = {}
local statsDefaultSeen = {}
for _, typeId in ipairs(statsState.selected) do
    local option = statsTypeToOption[typeId]
    if option and not statsDefaultSeen[option] then
        table.insert(statsDefaultOptions, option)
        table.insert(statsDropdownOptions, option)
        statsDefaultSeen[option] = true
    end
end
for _, row in ipairs(statsRows) do
    if not statsDefaultSeen[row.option] then
        table.insert(statsDropdownOptions, row.option)
        statsDefaultSeen[row.option] = true
    end
end

statsUi.Dropdown = statsUi.Section:Dropdown({
    Name = "Select Chickens (Multi-select)",
    Search = true,
    Multi = true,
    Required = false,
    Options = statsDropdownOptions,
    Default = statsDefaultOptions,
    Callback = function(value)
        if loadingControls then
            return
        end
        if statsUi.Reordering then
            return
        end
        local selected = {}
        local selectedSeen = {}
        if type(value) == "table" then
            for key, state in pairs(value) do
                local option
                local enabled
                if type(key) == "number" and type(state) == "string" then
                    option = state
                    enabled = true
                else
                    option = key
                    enabled = state == true
                end
                local typeId = statsOptionToType[option]
                if enabled and typeId and not selectedSeen[typeId] then
                    table.insert(selected, typeId)
                    selectedSeen[typeId] = true
                end
            end
        end
        statsState.selected = selected
        -- Choosing a chicken switches back to the detailed stat-card view.
        -- Top-5 remains a separate, mutually exclusive view.
        statsTop5State.visible = false
        statsTop5State.skillVisible = false
        statsTop5State.layVisible = false
        statsTop5State.compareVisible = false
        updateStatsTop5Paragraph("", false)
        sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
        sharedEnv.ChickenStatsUpdateLayParagraph("", false)
        sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
        saveSettings()
        refreshStatsCards()

        -- MacLib keeps dropdown options in their insertion order.  Rebuild
        -- this one picker after every change so selected entries stay above
        -- the remaining Catalog entries.  The guard prevents the internal
        -- UpdateSelection call from recursively rebuilding the list.
        local orderedOptions = {}
        local selectedOptions = {}
        local orderedSeen = {}
        for _, typeId in ipairs(statsState.selected) do
            local option = statsTypeToOption[typeId]
            if option and not orderedSeen[option] then
                table.insert(orderedOptions, option)
                table.insert(selectedOptions, option)
                orderedSeen[option] = true
            end
        end
        for _, row in ipairs(statsRows) do
            if not orderedSeen[row.option] then
                table.insert(orderedOptions, row.option)
                orderedSeen[row.option] = true
            end
        end
        statsUi.Reordering = true
        pcall(function()
            statsUi.Dropdown:ClearOptions()
            statsUi.Dropdown:InsertOptions(orderedOptions)
            setStatsDropdownOrder(orderedOptions)
            statsUi.Dropdown:UpdateSelection(selectedOptions)
            statsUi.Dropdown:UpdateName(
                "Select Chickens (Multi-select) • " .. tostring(#statsState.selected) .. " selected"
            )
            refreshStatsDropdownList()
        end)
        statsUi.Reordering = false
    end,
}, "StatsChickenSelection")

setStatsDropdownOrder(statsDropdownOptions)
refreshStatsDropdownList()
statsUi.Dropdown:UpdateName(
    "Select Chickens (Multi-select) • " .. tostring(#statsState.selected) .. " selected"
)

statsUi.LevelInput = statsUi.Section:Input({
    Name = "Chicken Level",
    Placeholder = sharedEnv.ChickenStatsLevelCap
        and ("1-" .. tostring(sharedEnv.ChickenStatsLevelCap)) or "1+",
    Default = tostring(statsState.baseLevel),
    Callback = function(value)
        if loadingControls then
            return
        end
        local parsed = parseNumberInput(value)
        if parsed and parsed >= 1 then
            statsState.baseLevel = math.max(1, math.floor(parsed + 0.5))
            if sharedEnv.ChickenStatsLevelCap then
                statsState.baseLevel = math.min(statsState.baseLevel, sharedEnv.ChickenStatsLevelCap)
            end
            refreshStatsLevelValues()
            saveSettings()
            refreshStatsCards()
            if statsTop5State.visible then
                updateStatsTop5Paragraph(buildStatsTop5Body(), true)
            end
            if statsTop5State.visible then
                sharedEnv.ChickenStatsUpdateHpAtkParagraph(sharedEnv.ChickenStatsBuildHpAtkBody(), true)
            end
            if statsTop5State.visible then
                sharedEnv.ChickenStatsUpdateAtkParagraph(sharedEnv.ChickenStatsBuildAtkBody(), true)
            end
            if statsTop5State.skillVisible then
                sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(true)
            end
            if statsTop5State.layVisible then
                sharedEnv.ChickenStatsUpdateLayParagraph(
                    sharedEnv.ChickenStatsBuildLayBody(), true)
            end
            print("[Stats UI] Base stat level:", statsState.baseLevel)
        else
            Window:Notify({
                Title = "Chicken Level",
                Description = "Enter a level from 1 to "
                    .. (sharedEnv.ChickenStatsLevelCap
                        and tostring(sharedEnv.ChickenStatsLevelCap) or "∞ (game cap)"),
                Lifetime = 3,
            })
        end
    end,
}, "StatsBaseLevel")

statsUi.GenomeInput = statsUi.Section:Input({
    Name = "Genome Stat",
    Placeholder = "0-" .. tostring(sharedEnv.ChickenGenomeMax or 31)
        .. " (Rarity cap)",
    Default = tostring(statsState.genomeStat),
    Callback = function(value)
        if loadingControls then
            return
        end
        local parsed = parseNumberInput(value)
        if parsed and parsed >= 0 then
            statsState.genomeStat = math.max(0, math.floor(parsed + 0.5))
            if sharedEnv.ChickenGenomeMax then
                statsState.genomeStat = math.min(statsState.genomeStat, sharedEnv.ChickenGenomeMax)
            end
            refreshStatsLevelValues()
            saveSettings()
            refreshStatsCards()
            if statsTop5State.visible then
                updateStatsTop5Paragraph(buildStatsTop5Body(), true)
            end
            if statsTop5State.visible then
                sharedEnv.ChickenStatsUpdateHpAtkParagraph(sharedEnv.ChickenStatsBuildHpAtkBody(), true)
            end
            if statsTop5State.visible then
                sharedEnv.ChickenStatsUpdateAtkParagraph(sharedEnv.ChickenStatsBuildAtkBody(), true)
            end
            if statsTop5State.skillVisible then
                sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(true)
            end
            if statsTop5State.layVisible then
                sharedEnv.ChickenStatsUpdateLayParagraph(
                    sharedEnv.ChickenStatsBuildLayBody(), true)
            end
            print("[Stats UI] Genome Stat:", statsState.genomeStat)
        else
            Window:Notify({
                Title = "Genome Stat",
                Description = "Enter a value from 0 to "
                    .. tostring(sharedEnv.ChickenGenomeMax or 31)
                    .. "; each card uses its Rarity cap",
                Lifetime = 3,
            })
        end
    end,
}, "StatsGenomeStat")

-- Create separate controls after the chicken picker and stat inputs so the
-- picker stays above both Top-5 views in the Stats tab.
statsUi.Top5Button = statsUi.Section:Button({
    Name = "Top 5 Base Stats",
    Callback = function()
        statsTop5State.visible = not statsTop5State.visible
        statsTop5State.skillVisible = false
        statsTop5State.layVisible = false
        statsTop5State.compareVisible = false
        updateStatsTop5Paragraph(
            statsTop5State.visible and buildStatsTop5Body() or "",
            statsTop5State.visible
        )
        sharedEnv.ChickenStatsUpdateHpAtkParagraph(
            statsTop5State.visible and sharedEnv.ChickenStatsBuildHpAtkBody() or "",
            statsTop5State.visible
        )
        sharedEnv.ChickenStatsUpdateAtkParagraph(
            statsTop5State.visible and sharedEnv.ChickenStatsBuildAtkBody() or "",
            statsTop5State.visible
        )
        sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
        sharedEnv.ChickenStatsUpdateLayParagraph("", false)
        sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
        refreshStatsCards()
    end,
})
statsUi.Top5SkillButton = statsUi.Section:Button({
    Name = "Top 5 Skill",
    Callback = function()
        statsTop5State.skillVisible = not statsTop5State.skillVisible
        statsTop5State.visible = false
        statsTop5State.layVisible = false
        statsTop5State.compareVisible = false
        updateStatsTop5Paragraph("", false)
        sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(statsTop5State.skillVisible)
        sharedEnv.ChickenStatsUpdateLayParagraph("", false)
        sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
        refreshStatsCards()
    end,
})
statsUi.Top5LayButton = statsUi.Section:Button({
    Name = "Top 5 Lay Egg",
    Callback = function()
        statsTop5State.layVisible = not statsTop5State.layVisible
        statsTop5State.visible = false
        statsTop5State.skillVisible = false
        statsTop5State.compareVisible = false
        updateStatsTop5Paragraph("", false)
        sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
        sharedEnv.ChickenStatsUpdateLayParagraph(
            statsTop5State.layVisible and sharedEnv.ChickenStatsBuildLayBody() or "",
            statsTop5State.layVisible
        )
        sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
        refreshStatsCards()
    end,
})
statsUi.CompareSkillButton = statsUi.Section:Button({
    Name = "Compare Skill DMG",
    Callback = function()
        statsTop5State.compareVisible = not statsTop5State.compareVisible
        statsTop5State.visible = false
        statsTop5State.skillVisible = false
        statsTop5State.layVisible = false
        updateStatsTop5Paragraph("", false)
        sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
        sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
        sharedEnv.ChickenStatsUpdateLayParagraph("", false)
        sharedEnv.ChickenStatsUpdateCompareParagraph(
            statsTop5State.compareVisible
                and sharedEnv.ChickenStatsBuildCompareSkillBody() or "",
            statsTop5State.compareVisible
        )
        refreshStatsCards()
    end,
})
-- Some MacLib builds invoke a newly-created Button callback while mounting
-- the tab.  Reset the view after creation so Top-5 is opt-in and never opens
-- as a stale/default card.
statsTop5State.visible = false
statsTop5State.skillVisible = false
statsTop5State.layVisible = false
statsTop5State.compareVisible = false
updateStatsTop5Paragraph("", false)
sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
sharedEnv.ChickenStatsUpdateLayParagraph("", false)
sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
refreshStatsCards()

task.spawn(function()
    -- The Stats tab is lazy-rendered by MacLib.  Re-apply LayoutOrder while
    -- the tab is mounted so selected entries are still at the top when the
    -- user opens Stats after the initial window creation.
    local statsViewReady = false
    while sharedEnv.ChickenArenaGeneration == generation do
        if sharedEnv.ChickenStatsTabVisible == true then
            -- A single pass is enough after the lazy mount.  The old 0.5s
            -- loop repeatedly scanned every dropdown/card while Stats was open,
            -- which caused the visible hitch.  Selection/search callbacks and
            -- the DescendantAdded mount hook still refresh when something
            -- actually changes.
            if not statsViewReady then
                setStatsDropdownOrder()
                local dropdownFrames = sharedEnv.ChickenStatsGetDropdownFrames()
                refreshStatsDropdownList()
                refreshStatsCards()
                applyStatsFullWidthLayout()
                statsViewReady = #dropdownFrames > 0
            end
            task.wait(1.5)
        else
            statsViewReady = false
            task.wait(1.5)
        end
    end
end)
refreshStatsCards()
applyStatsFullWidthLayout()

-- Stats content is lazy-mounted when its tab is opened.  Re-run the layout
-- and mutually-exclusive visibility pass as soon as those paragraph labels
-- appear so MacLib's default mount state cannot leave a stale empty card.
local statsMountHeaders = {
    ["Chicken Stats Catalog"] = true,
    ["TOP 5 Rank by Overall • Equal Weight"] = true,
    ["TOP 5 Rank by ATK / HP"] = true,
    ["TOP 5 Rank by HP / ATK"] = true,
    ["TOP 5 Skill • Overall"] = true,
    ["TOP 5 Skill • 1v1"] = true,
    ["TOP 5 Skill • Tank / Sustain"] = true,
    ["TOP 5 Skill • AOE"] = true,
    ["TOP 5 Lay Egg • Fastest"] = true,
    ["COMPARE Skill Damage"] = true,
    ["Chicken Stat Card 1"] = true,
}
sharedEnv.ChickenStatsMountConnection = CoreGui.DescendantAdded:Connect(function(item)
    if item:IsA("TextLabel") and string.find(item.Text or "", "Select Chickens (Multi-select)", 1, true) then
        sharedEnv.ChickenStatsDropdownCache.dirty = true
    end
    if item:IsA("TextLabel") and statsMountHeaders[item.Text] then
        sharedEnv.ChickenStatsGuiCache.dirty = true
        -- Paragraph children are mounted in several passes.  Re-check a few
        -- times after the header appears so both the body and the Section
        -- frame exist before visibility is applied.
        for _, delaySeconds in ipairs({0, 0.1, 0.3, 0.7, 1.2}) do
            task.delay(delaySeconds, function()
                if sharedEnv.ChickenArenaGeneration == generation
                    and sharedEnv.ChickenStatsTabVisible == true then
                    refreshStatsCards()
                    applyStatsFullWidthLayout()
                end
            end)
        end
    end
end)

local function scheduleStatsViewRefresh()
    -- Opening the Stats tab is a view reset.  This also neutralizes a MacLib
    -- lazy-mount callback that some builds fire for the Top-5 button itself.
    statsTop5State.visible = false
    statsTop5State.skillVisible = false
    statsTop5State.layVisible = false
    statsTop5State.compareVisible = false
    updateStatsTop5Paragraph("", false)
    sharedEnv.ChickenStatsUpdateHpAtkParagraph("", false)
    sharedEnv.ChickenStatsUpdateAtkParagraph("", false)
    sharedEnv.ChickenStatsUpdateSkillTop5Paragraphs(false)
    sharedEnv.ChickenStatsUpdateLayParagraph("", false)
    sharedEnv.ChickenStatsUpdateCompareParagraph("", false)
    -- MacLib mounts the Stats body lazily.  Two deferred passes are enough to
    -- catch that mount; the former five-pass burst repeatedly rebuilt every
    -- paragraph and made a tab click hitch for a moment.
    for _, delaySeconds in ipairs({0.35, 0.85}) do
        task.delay(delaySeconds, function()
            if sharedEnv.ChickenArenaGeneration == generation
                and sharedEnv.ChickenStatsTabVisible == true then
                pcall(refreshStatsCards)
                pcall(applyStatsFullWidthLayout)
            end
        end)
    end
end

sharedEnv.ChickenSetStatsTabVisible = function(visible)
    if sharedEnv.ChickenStatsTabVisible == (visible == true) then
        return
    end
    sharedEnv.ChickenStatsTabVisible = visible == true
    if sharedEnv.ChickenStatsTabVisible then
        scheduleStatsViewRefresh()
        -- Read the live Catalog after the tab switch yields once.  The
        -- fingerprint makes ordinary opens a no-op; only a changed Catalog
        -- rebuilds rows and picker options.
        task.defer(function()
            if sharedEnv.ChickenArenaGeneration == generation
                and sharedEnv.ChickenStatsTabVisible == true
                and type(sharedEnv.ChickenStatsRefreshCatalog) == "function" then
                local changed = sharedEnv.ChickenStatsRefreshCatalog()
                if changed then
                    pcall(refreshStatsCards)
                    pcall(applyStatsFullWidthLayout)
                end
            end
        end)
    end
end

-- One callback is shared by every tab switcher.  It reads MacLib's current-tab
-- label only after a click, so switching away from Stats also stops the worker
-- without adding a closure/local for every tab.
sharedEnv.ChickenStatsTabClick = function()
    task.defer(function()
        local visible = false
        local arenaVisible = false
        local currentTab = sharedEnv.ChickenStatsCurrentTabLabel
        if not (currentTab and currentTab.Parent) then
            pcall(function()
                for _, item in ipairs(CoreGui:GetDescendants()) do
                    if item:IsA("TextLabel") and item.Name == "CurrentTab" then
                        currentTab = item
                        sharedEnv.ChickenStatsCurrentTabLabel = item
                        break
                    end
                end
            end)
        end
        if currentTab then
            visible = currentTab.Text == "Stats"
            arenaVisible = currentTab.Text == "Arena"
        end
        sharedEnv.ChickenArenaTabVisible = arenaVisible
        if sharedEnv.ChickenArenaGeneration == generation
            and type(sharedEnv.ChickenSetStatsTabVisible) == "function" then
            sharedEnv.ChickenSetStatsTabVisible(visible)
        end
    end)
end

-- Tab switchers are persistent even when the tab body is lazy-mounted.  Hook
-- the Stats switcher so the full-width pass runs every time the page opens,
-- not only when a child paragraph is newly created.
sharedEnv.ChickenStatsTabConnections = {}
for _, button in ipairs(CoreGui:GetDescendants()) do
    if button:IsA("TextLabel") and button.Name == "CurrentTab" then
        sharedEnv.ChickenStatsCurrentTabLabel = button
    end
    if button:IsA("TextButton") and button.Name == "TabSwitcher" then
        table.insert(
            sharedEnv.ChickenStatsTabConnections,
            button.MouseButton1Click:Connect(sharedEnv.ChickenStatsTabClick)
        )
    end
end

end

-- Keep every MacLib dropdown compact and scrollable.  Stats has a custom
-- picker above (with its own ordering/filtering), so this pass leaves that
-- picker alone and applies the same five-row viewport to every other list.
local dropdownViewportState = {
    visibleRows = 5,
    rowHeight = 30,
    rowGap = 5,
    maxHeight = 430,
}

function dropdownViewportState.optionIsSelected(optionButton)
    local checkmark = optionButton and optionButton:FindFirstChild("Checkmark")
    if checkmark and checkmark:IsA("TextLabel") then
        -- MacLib keeps the Checkmark label mounted for every option and uses
        -- TextTransparency to mark selection (0 = selected, 1 = clear).
        return checkmark.TextTransparency < 0.5
    end
    local optionName = optionButton and optionButton:FindFirstChild("OptionName")
    return optionName
        and optionName:IsA("TextLabel")
        and optionName.TextTransparency < 0.35
        or false
end

function dropdownViewportState.orderOptions(frame, scroll)
    local buttons = {}
    local seen = {}
    for _, container in ipairs({frame, scroll}) do
        if container then
            for _, optionButton in ipairs(container:GetChildren()) do
                if optionButton:IsA("TextButton")
                    and optionButton.Name == "Option"
                    and not seen[optionButton] then
                    seen[optionButton] = true
                    table.insert(buttons, optionButton)
                end
            end
        end
    end

    local order = 0
    for _, selected in ipairs({true, false}) do
        for _, optionButton in ipairs(buttons) do
            if dropdownViewportState.optionIsSelected(optionButton) == selected then
                order += 1
                optionButton.LayoutOrder = order
            end
        end
    end
end

function dropdownViewportState.install(dropdown, frame)
    if not frame or frame:FindFirstChild("ChickenStatsOptionsScroll") then
        return nil
    end

    local scroll = frame:FindFirstChild("AllDropdownOptionsScroll")
    local optionCount = 0
    for _, container in ipairs({frame, scroll}) do
        if container then
            for _, optionButton in ipairs(container:GetChildren()) do
                if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
                    optionCount += 1
                end
            end
        end
    end

    -- Short lists keep MacLib's original compact dropdown.  If a previous
    -- refresh already wrapped one and the option set became short, restore
    -- the buttons to DropdownFrame and remove our viewport.
    if optionCount <= dropdownViewportState.visibleRows then
        if scroll then
            for _, optionButton in ipairs(scroll:GetChildren()) do
                if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
                    optionButton.Parent = frame
                end
            end
            scroll:Destroy()
            dropdown:SetAttribute("AllDropdownViewportHook", nil)
            local search = frame:FindFirstChild("Search")
            if search then
                local originalOrder = search:GetAttribute("AllDropdownOriginalLayoutOrder")
                if originalOrder ~= nil then
                    search.LayoutOrder = originalOrder
                    search:SetAttribute("AllDropdownOriginalLayoutOrder", nil)
                end
            end
        end
        dropdownViewportState.orderOptions(frame, nil)
        return nil
    end

    if not scroll then
        scroll = Instance.new("ScrollingFrame")
        scroll.Name = "AllDropdownOptionsScroll"
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Active = true
        scroll.ScrollingEnabled = true
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageTransparency = 0.15
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.LayoutOrder = 0
        scroll.Parent = frame

        local list = Instance.new("UIListLayout")
        list.Name = "AllDropdownOptionsLayout"
        list.Padding = UDim.new(0, dropdownViewportState.rowGap)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = scroll
    end

    local search = frame:FindFirstChild("Search")
    if search then
        if search:GetAttribute("AllDropdownOriginalLayoutOrder") == nil then
            search:SetAttribute("AllDropdownOriginalLayoutOrder", search.LayoutOrder)
        end
        search.LayoutOrder = -1
    end

    -- MacLib may insert new options after the dropdown is first rendered.
    -- Reparent them on every pass; existing button callbacks stay intact.
    for _, optionButton in ipairs(frame:GetChildren()) do
        if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
            optionButton.Parent = scroll
            optionButton.Size = UDim2.new(1, 0, 0, dropdownViewportState.rowHeight)
        end
    end

    -- Put selected options first while preserving the original order within
    -- the selected and unselected groups.  Re-running this is safe when
    -- MacLib inserts or rebuilds options after a selection change.
    dropdownViewportState.orderOptions(frame, scroll)
    for _, optionButton in ipairs(scroll:GetChildren()) do
        if optionButton:IsA("TextButton") and optionButton.Name == "Option" then
            local checkmark = optionButton:FindFirstChild("Checkmark")
            if checkmark and not checkmark:GetAttribute("SelectedOrderHook") then
                checkmark:SetAttribute("SelectedOrderHook", true)
                checkmark:GetPropertyChangedSignal("TextTransparency"):Connect(function()
                    task.defer(function()
                        if dropdown.Parent then
                            dropdownViewportState.orderOptions(frame, scroll)
                        end
                    end)
                end)
            end
        end
    end

    local list = scroll:FindFirstChild("AllDropdownOptionsLayout")
    local visibleRows = math.min(dropdownViewportState.visibleRows, math.max(1, optionCount))
    local viewportHeight = visibleRows * dropdownViewportState.rowHeight
        + math.max(0, visibleRows - 1) * dropdownViewportState.rowGap
    scroll.Size = UDim2.new(1, 0, 0, viewportHeight)

    if list and not scroll:GetAttribute("AllDropdownCanvasHook") then
        scroll:SetAttribute("AllDropdownCanvasHook", true)
        list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
        end)
    end
    if list then
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 8)
    end

    if not dropdown:GetAttribute("AllDropdownViewportHook") then
        dropdown:SetAttribute("AllDropdownViewportHook", true)
        local interact = dropdown:FindFirstChild("Interact")
        if interact then
            interact.MouseButton1Click:Connect(function()
                scroll.CanvasPosition = Vector2.new(0, 0)
                task.defer(function()
                    dropdownViewportState.install(dropdown, frame)
                end)
            end)
        end
    end

    if frame.Visible then
        local padding = frame:FindFirstChild("DropdownFrameUIPadding")
        local paddingHeight = padding
            and padding.PaddingTop.Offset + padding.PaddingBottom.Offset or 0
        local searchHeight = search and search.AbsoluteSize.Y or 30
        dropdown.Size = UDim2.new(1, 0, 0,
            math.min(dropdownViewportState.maxHeight,
                searchHeight + viewportHeight + paddingHeight + 8))
    end
    return scroll
end

function dropdownViewportState.refresh()
    pcall(function()
        for _, dropdown in ipairs(CoreGui:GetDescendants()) do
            if dropdown:IsA("Frame") and dropdown.Name == "Dropdown" then
                local nameLabel = dropdown:FindFirstChild("DropdownName")
                -- Stats is already managed by refreshStatsDropdownList; skip it
                -- so its selected-first ordering and search filter are preserved.
                local isStats = nameLabel
                    and string.find(nameLabel.Text or "", "Select Chickens (Multi-select)", 1, true)
                if not isStats then
                    dropdownViewportState.install(dropdown, dropdown:FindFirstChild("DropdownFrame"))
                end
            end
        end
    end)
end

dropdownViewportState.refresh()
task.spawn(function()
    while sharedEnv.ChickenArenaMacWindow == Window do
        dropdownViewportState.refresh()
        task.wait(0.5)
    end
end)

local ScrapSection = ScrapTab:Section({
    Side = "Left",
})
local ScrapInfoSection = ScrapTab:Section({
    Side = "Right",
})
local ScrapInfoParagraph = ScrapInfoSection:Paragraph({
    Header = "Scrap Collector Status",
    Body = "Loading scrap status...",
})
local ScrapConfigParagraph = ScrapInfoSection:Paragraph({
    Header = "Collection Settings",
    Body = "Pieces per run: " .. tostring(scrapTargetCount)
        .. "\nRebirth delay after send: " .. tostring(scrapDepositDelay) .. " sec"
        .. "\nManual pause: " .. tostring(scrapManualPauseSeconds) .. " sec"
        .. "\nPieces: 1-24 | Delays: 0-300 sec",
})
local UpgradeSection = UpgradeTab:Section({
    Side = "Left",
})
local UpgradeInfoSection = UpgradeTab:Section({
    Side = "Right",
})
local UpgradeInfoParagraph = UpgradeInfoSection:Paragraph({
    Header = "Coop / Feeder / Recycler",
    Body = "Loading upgrade status...",
})
sharedEnv.ChickenFeederWatchdogSection = sharedEnv.ChickenFeederWatchdogTab:Section({
    Side = "Left",
})
sharedEnv.ChickenFeederWatchdogInfoSection = sharedEnv.ChickenFeederWatchdogTab:Section({
    Side = "Right",
})
sharedEnv.ChickenFeederWatchdogInfoSection:Paragraph({
    Header = "Feeder Watchdog",
    Body = "When all feeders are empty, pauses the chicken's Coop target so it stops walking between empty feeders. When food returns, it restores the Coop target.",
})

ArenaSection:Paragraph({
    Header = "Arena Controller",
    Body = "Automatically starts the next match and uses equipped abilities.",
})

local AutoArenaToggle = ArenaSection:Toggle({
    Name = "Auto Arena",
    Default = autoArena,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoArena = state
        saveSettings()

        if state then
            setAutoAbility:FireServer(true)
        end

        Window:Notify({
            Title = "Auto Arena",
            Description = state and "Enabled" or "Disabled",
            Lifetime = 2,
        })

        print("[Arena UI] Auto Arena:", state)
    end,
}, "AutoArena")

ArenaSection:Toggle({
    Name = "Combat ESP",
    Default = sharedEnv.ChickenArenaCombatESPEnabled == true,
    Callback = function(state)
        if loadingControls then
            return
        end
        local enabled = state == true
        sharedEnv.ChickenArenaCombatESPEnabled = enabled
        local esp = sharedEnv.ChickenArenaCombatESP
        if type(esp) == "table" then
            esp.enabled = enabled
            if not enabled then
                esp.finishToken += 1
                esp.active = false
                if esp.gui then
                    esp.gui.Enabled = false
                end
            end
        end
        saveSettings()
        Window:Notify({
            Title = "Combat ESP",
            Description = enabled and "Enabled" or "Disabled",
            Lifetime = 2,
        })
        print("[Arena UI] Combat ESP:", enabled and "on" or "off")
    end,
}, "CombatESP")

local SmartSelectionToggle = ArenaSection:Toggle({
    Name = "Smart Opponent Selection",
    Default = smartSelection,
    Callback = function(state)
        if loadingControls then
            return
        end
        smartSelection = state
        saveSettings()
        Window:Notify({
            Title = "Opponent Selection",
            Description = state and "Fight when stronger; skip only stronger opponents" or "Always uses the current opponent",
            Lifetime = 3,
        })
    end,
}, "PickWeakest")

RebirthSection:Paragraph({
    Header = "Tower Climb",
    Body = "Choose a run mode. Run Duration returns the chicken to Coop; In Coop Duration controls how long it stays there. 0/blank means no extra delay.",
})

local AutoTowerToggle = RebirthSection:Toggle({
    Name = "Auto Tower (No Rebirth)",
    Default = autoTower,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoTower = state
        towerRunState.afterRebirthPending = false
        towerRunState.runDeadline = 0
        towerNextStartAt = 0
        towerStatus = state and "READY TO START" or "STOPPED"
        saveSettings()
        if state then
            setAutoAbility:FireServer(true)
        end
        Window:Notify({
            Title = "Auto Tower",
            Description = state and "Will keep climbing until defeat; no rebirth" or "Disabled",
            Lifetime = 3,
        })
        print("[Rebirth UI] Auto Tower continuous:", state)
    end,
}, "AutoTowerContinuous")

local AutoTowerToRebirthToggle = RebirthSection:Toggle({
    Name = "Auto Tower to Rebirth",
    Default = autoTowerToRebirth,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoTowerToRebirth = state
        towerRunState.afterRebirthPending = false
        towerRunState.runDeadline = 0
        towerNextStartAt = 0
        towerStatus = state and "READY TO START" or "STOPPED"
        saveSettings()
        if state then
            setAutoAbility:FireServer(true)
        end
        Window:Notify({
            Title = "Auto Tower",
            Description = state and "Will climb, then rebirth at the requirement" or "Disabled",
            Lifetime = 3,
        })
        print("[Rebirth UI] Auto Tower to Rebirth:", state)
    end,
}, "AutoTowerToRebirth")

local TowerStartLatestToggle = RebirthSection:Toggle({
    Name = "Start at Highest Floor",
    Default = towerStartLatest,
    Callback = function(state)
        if loadingControls then
            return
        end
        towerStartLatest = state
        saveSettings()
        Window:Notify({
            Title = "Tower Start Floor",
            Description = state and "New runs start at your highest cleared floor + 1" or "New runs start at floor 1",
            Lifetime = 3,
        })
        print("[Rebirth UI] Start from latest floor:", state)
    end,
}, "TowerStartLatest")

RebirthSection:Input({
    Name = "Delay After Rebirth (sec)",
    Placeholder = "0-300",
    Default = tostring(towerStartDelay),
    Callback = function(value)
        local parsed = parseNumberInput(value)
        if parsed then
            towerStartDelay = math.clamp(parsed, 0, 300)
            saveSettings()
        else
            Window:Notify({
                Title = "After Rebirth Delay",
                Description = "Enter a value from 0 to 300 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "TowerStartDelay")

RebirthSection:Input({
    Name = "Tower Run Duration (sec)",
    Placeholder = "0 = no timer",
    Default = tostring(sharedEnv.ChickenTowerTiming.runDuration or 0),
    Callback = function(value)
        if loadingControls then
            return
        end
        local text = tostring(value or "")
        local parsed = text:match("^%s*$") and 0 or parseNumberInput(text)
        if parsed then
            sharedEnv.ChickenTowerTiming.runDuration = math.clamp(parsed, 0, 300)
            towerRunState.runDeadline = 0
            saveSettings()
        else
            Window:Notify({
                Title = "Tower Run Duration",
                Description = "Enter 0, blank, or a value from 0 to 300 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "TowerRunDuration")

RebirthSection:Input({
    Name = "In Coop Duration (sec)",
    Placeholder = "0 = instant",
    Default = tostring(sharedEnv.ChickenTowerTiming.nextRunDelay or 0),
    Callback = function(value)
        if loadingControls then
            return
        end
        local text = tostring(value or "")
        local parsed = text:match("^%s*$") and 0 or parseNumberInput(text)
        if parsed then
            sharedEnv.ChickenTowerTiming.nextRunDelay = math.clamp(parsed, 0, 300)
            saveSettings()
        else
            Window:Notify({
                Title = "In Coop Duration",
                Description = "Enter 0, blank, or a value from 0 to 300 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "TowerNextRunDelay")

RebirthSection:Input({
    Name = "Delay After Defeat (sec)",
    Placeholder = "0-300",
    Default = tostring(towerDeathDelay),
    Callback = function(value)
        local parsed = parseNumberInput(value)
        if parsed then
            towerDeathDelay = math.clamp(parsed, 0, 300)
            saveSettings()
        else
        Window:Notify({
            Title = "Defeat Delay",
                Description = "Enter a value from 0 to 300 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "TowerDeathDelay")

EggSection:Paragraph({
    Header = "Fast Coop Deploy",
    Body = "Deploys Source first, waits for the configured delay, deploys Target, then returns to Source.",
})

sharedEnv.ChickenFastIncubatorSourceDropdown = EggSection:Dropdown({
    Name = "Fast Coop Source Chicken",
    Search = true,
    Multi = false,
    Required = false,
    Options = sharedEnv.ChickenFastIncubatorSourceOptions,
    Default = sharedEnv.ChickenFastIncubatorSourceDefault,
    Callback = function(value)
        if loadingControls or sharedEnv.ChickenFastIncubatorDropdownReordering then
            return
        end
        local selected = type(value) == "number" and sharedEnv.ChickenFastIncubatorSourceOptions[value]
            or type(value) == "table" and (value[1] or value.Value or value.Name)
            or value
        local id = sharedEnv.ChickenFastIncubatorOptionMap[selected]
        if type(id) ~= "string" or id == "" then
            id = nil
        end
        sharedEnv.ChickenFastIncubatorSourceId = id
        saveSettings()
        print("[Egg UI] Fast Incubator source:", id or "cleared")
    end,
}, "FastIncubatorSource")

sharedEnv.ChickenFastIncubatorTargetDropdown = EggSection:Dropdown({
    Name = "Fast Coop Target Chicken",
    Search = true,
    Multi = false,
    Required = false,
    Options = sharedEnv.ChickenFastIncubatorTargetOptions,
    Default = sharedEnv.ChickenFastIncubatorTargetDefault,
    Callback = function(value)
        if loadingControls or sharedEnv.ChickenFastIncubatorDropdownReordering then
            return
        end
        local selected = type(value) == "number" and sharedEnv.ChickenFastIncubatorTargetOptions[value]
            or type(value) == "table" and (value[1] or value.Value or value.Name)
            or value
        local id = sharedEnv.ChickenFastIncubatorOptionMap[selected]
        if type(id) ~= "string" or id == "" then
            id = nil
        end
        sharedEnv.ChickenFastIncubatorTargetId = id
        saveSettings()
        print("[Egg UI] Fast Incubator target:", id or "cleared")
    end,
}, "FastIncubatorTarget")

-- The Fast Coop Source/Target lists are backed by the owned roster, which can
-- change when an egg finishes hatching.  Rebuild both dropdowns from the
-- replicated roster instead of keeping the one-time startup snapshot above.
-- The selected ids are preserved, and an open dropdown is left untouched until
-- the next pass so the list cannot jump underneath the user's cursor.
sharedEnv.ChickenFastIncubatorDropdownReordering = false
sharedEnv.ChickenFastIncubatorDropdownPendingRefresh = false
sharedEnv.ChickenFastIncubatorDropdownOpen = function()
    local open = false
    pcall(function()
        local robloxGui = CoreGui:FindFirstChild("RobloxGui")
        local screenGui = robloxGui and robloxGui:FindFirstChild("ScreenGui")
        local base = screenGui and screenGui:FindFirstChild("Base")
        local content = base and base:FindFirstChild("Content")
        local elements = content and content:FindFirstChild("Elements")
        local scrolling = elements and elements:FindFirstChild("ElementsScrolling")
        if not scrolling then
            return
        end
        for _, item in ipairs(scrolling:GetDescendants()) do
            if item:IsA("Frame") and item.Name == "DropdownFrame" and item.Visible then
                local parent = item.Parent
                local nameLabel = parent and parent:FindFirstChild("DropdownName")
                local text = nameLabel and tostring(nameLabel.Text or "") or ""
                if text:find("Fast Coop Source Chicken", 1, true)
                    or text:find("Fast Coop Target Chicken", 1, true) then
                    open = true
                    break
                end
            end
        end
    end)
    return open
end

sharedEnv.ChickenFastIncubatorRefreshOptions = function(force)
    if sharedEnv.ChickenFastIncubatorDropdownReordering then
        return false
    end
    if not force and sharedEnv.ChickenFastIncubatorDropdownOpen() then
        sharedEnv.ChickenFastIncubatorDropdownPendingRefresh = true
        return false
    end
    sharedEnv.ChickenFastIncubatorDropdownPendingRefresh = false

    local rosterOk, rosterData = pcall(function()
        return DataService.client:get({"roster"}) or {}
    end)
    if not rosterOk or type(rosterData) ~= "table" then
        return false
    end
    local roster = type(rosterData.roster) == "table" and rosterData.roster or rosterData
    local chickens = type(roster) == "table" and roster.chickens or {}
    if type(chickens) ~= "table" then
        return false
    end

    local catalog
    local genomeModule
    pcall(function()
        local content = ReplicatedStorage:FindFirstChild("Content")
        local catalogFolder = content and content:FindFirstChild("Catalog")
        local module = catalogFolder and catalogFolder:FindFirstChild("ChickenTypes")
        local loaded = module and loadModule(module)
        if type(loaded) == "table" then
            catalog = type(loaded.chickenTypes) == "table" and loaded.chickenTypes or loaded
        end
    end)
    pcall(function()
        local features = ReplicatedStorage:FindFirstChild("Features")
        local chicken = features and features:FindFirstChild("Chicken")
        local module = chicken and chicken:FindFirstChild("Genome")
        genomeModule = module and loadModule(module)
    end)

    local optionRows = {}
    local rosterById = {}
    local function addChicken(chicken)
        if type(chicken) ~= "table" or type(chicken.id) ~= "string"
            or chicken.id == "" or rosterById[chicken.id] then
            return
        end
        local typeId = tostring(chicken.typeId or chicken.id)
        local typeInfo = catalog and catalog[typeId]
        local layPeriod = tonumber(typeInfo and typeInfo.layPeriod) or 999999
        if genomeModule and type(genomeModule.layMult) == "function" then
            local multOk, mult = pcall(genomeModule.layMult, chicken.genome)
            if multOk and tonumber(mult) then
                layPeriod = layPeriod * tonumber(mult)
            end
        end
        local name
        if type(chicken.nickname) == "string" and chicken.nickname ~= "" then
            name = chicken.nickname
        else
            name = typeId:gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
        end
        table.insert(optionRows, {
            id = chicken.id,
            display = name .. " (" .. tostring(math.floor(layPeriod + 0.5)) .. "s)",
            layPeriod = layPeriod,
            chicken = chicken,
        })
        rosterById[chicken.id] = chicken
    end
    for _, chicken in ipairs(chickens) do
        addChicken(chicken)
    end

    -- The incubating chicken may be omitted from roster while it is in the
    -- machine.  Keep it selectable so a saved Source/Target id is not lost.
    local incubatorOk, incubatorSnapshot = pcall(function()
        return DataService.client:get({"incubator"}) or {}
    end)
    local activeIncubatorChicken = incubatorOk and type(incubatorSnapshot) == "table"
        and incubatorSnapshot.chicken
    addChicken(activeIncubatorChicken)

    table.sort(optionRows, function(a, b)
        if a.layPeriod == b.layPeriod then
            return a.display < b.display
        end
        return a.layPeriod < b.layPeriod
    end)
    local displayCounts = {}
    for _, row in ipairs(optionRows) do
        displayCounts[row.display] = (displayCounts[row.display] or 0) + 1
    end
    local displaySeen = {}
    local options = {}
    local optionMap = {}
    for _, row in ipairs(optionRows) do
        displaySeen[row.display] = (displaySeen[row.display] or 0) + 1
        local display = row.display
        if (displayCounts[row.display] or 0) > 1 then
            display = display .. " #" .. tostring(displaySeen[row.display])
        end
        table.insert(options, display)
        optionMap[display] = row.id
    end
    if #options == 0 then
        table.insert(options, "(No owned chickens)")
    end

    local sourceOptions = {}
    local targetOptions = {}
    local sourceSelected
    local targetSelected
    local sourceId = sharedEnv.ChickenFastIncubatorSourceId
    local targetId = sharedEnv.ChickenFastIncubatorTargetId
    for _, display in ipairs(options) do
        local id = optionMap[display]
        if id == sourceId then
            sourceSelected = display
        else
            table.insert(sourceOptions, display)
        end
        if id == targetId then
            targetSelected = display
        else
            table.insert(targetOptions, display)
        end
    end
    if sourceSelected then
        table.insert(sourceOptions, 1, sourceSelected)
    else
        sourceOptions = options
    end
    if targetSelected then
        table.insert(targetOptions, 1, targetSelected)
    else
        targetOptions = options
    end

    local signature = table.concat(options, "\31") .. "\30"
        .. table.concat(sourceOptions, "\31") .. "\29"
        .. table.concat(targetOptions, "\31") .. "\28"
        .. tostring(sourceId or "") .. "\27" .. tostring(targetId or "")
    sharedEnv.ChickenFastIncubatorRosterById = rosterById
    if not force and sharedEnv.ChickenFastIncubatorOptionSignature == signature then
        return false
    end
    sharedEnv.ChickenFastIncubatorOptionSignature = signature
    sharedEnv.ChickenFastIncubatorOptions = options
    sharedEnv.ChickenFastIncubatorSourceOptions = sourceOptions
    sharedEnv.ChickenFastIncubatorTargetOptions = targetOptions
    sharedEnv.ChickenFastIncubatorOptionMap = optionMap

    local sourceDropdown = sharedEnv.ChickenFastIncubatorSourceDropdown
    local targetDropdown = sharedEnv.ChickenFastIncubatorTargetDropdown
    if sourceDropdown and targetDropdown then
        sharedEnv.ChickenFastIncubatorDropdownReordering = true
        pcall(function()
            sourceDropdown:ClearOptions()
            sourceDropdown:InsertOptions(sourceOptions)
            sourceDropdown:UpdateSelection(sourceSelected and {sourceSelected} or {})
            targetDropdown:ClearOptions()
            targetDropdown:InsertOptions(targetOptions)
            targetDropdown:UpdateSelection(targetSelected and {targetSelected} or {})
        end)
        sharedEnv.ChickenFastIncubatorDropdownReordering = false
    end
    return true
end

-- MacLib's optional single-select dropdown does not call its callback when a
-- selected option is clicked again to clear it.  Reconcile the visual control
-- state so clearing Source/Target is persisted instead of coming back after a
-- reload.  This is read-only UI state; it never sends a game remote.
sharedEnv.ChickenFastIncubatorSyncDropdownSelections = function()
    if sharedEnv.ChickenFastIncubatorDropdownReordering then
        return
    end
    local changed = false
    local function readId(dropdown)
        if not dropdown or type(dropdown.GetOptions) ~= "function" then
            return nil
        end
        local ok, states = pcall(function()
            return dropdown:GetOptions()
        end)
        if not ok or type(states) ~= "table" then
            return nil
        end
        for option, enabled in pairs(states) do
            if enabled == true then
                local id = sharedEnv.ChickenFastIncubatorOptionMap[option]
                if type(id) == "string" and id ~= "" then
                    return id
                end
            end
        end
        return nil
    end
    local sourceId = readId(sharedEnv.ChickenFastIncubatorSourceDropdown)
    local targetId = readId(sharedEnv.ChickenFastIncubatorTargetDropdown)
    if sourceId ~= sharedEnv.ChickenFastIncubatorSourceId then
        sharedEnv.ChickenFastIncubatorSourceId = sourceId
        changed = true
    end
    if targetId ~= sharedEnv.ChickenFastIncubatorTargetId then
        sharedEnv.ChickenFastIncubatorTargetId = targetId
        changed = true
    end
    if changed then
        saveSettings()
    end
end

sharedEnv.ChickenFastIncubatorToggle = EggSection:Toggle({
    Name = "Fast Coop Deploy",
    Default = sharedEnv.ChickenFastIncubatorEnabled,
    Callback = function(state)
        if loadingControls then
            return
        end
        sharedEnv.ChickenFastIncubatorEnabled = state
        saveSettings()
        Window:Notify({
            Title = "Fast Coop Deploy",
            Description = state and "Source/target deploy enabled" or "Disabled",
            Lifetime = 3,
        })
    end,
}, "FastIncubator")

EggSection:Input({
    Name = "Deploy Target Last (sec)",
    Placeholder = "1",
    Default = tostring(sharedEnv.ChickenFastIncubatorSwapSeconds),
    Callback = function(value)
        if loadingControls then
            return
        end
        local parsed = parseNumberInput(value)
        if parsed then
            sharedEnv.ChickenFastIncubatorSwapSeconds = math.clamp(parsed, 0.1, 60)
            saveSettings()
            Window:Notify({
                Title = "Fast Coop Deploy",
                Description = "Deploy Target in the last " .. tostring(sharedEnv.ChickenFastIncubatorSwapSeconds) .. " sec",
                Lifetime = 3,
            })
        else
            Window:Notify({
                Title = "Fast Coop Deploy",
                Description = "Enter 0.1-60 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "FastIncubatorSwapSeconds")

EggSection:Input({
    Name = "Deploy Back to Source (sec)",
    Placeholder = "3",
    Default = tostring(sharedEnv.ChickenFastIncubatorReturnSeconds),
    Callback = function(value)
        if loadingControls then
            return
        end
        local parsed = parseNumberInput(value)
        if parsed then
            sharedEnv.ChickenFastIncubatorReturnSeconds = math.clamp(parsed, 0.1, 60)
            saveSettings()
            Window:Notify({
                Title = "Fast Coop Deploy",
                Description = "Deploy Source after " .. tostring(sharedEnv.ChickenFastIncubatorReturnSeconds) .. " sec",
                Lifetime = 3,
            })
        else
            Window:Notify({
                Title = "Fast Coop Deploy",
                Description = "Enter 0.1-60 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "FastIncubatorReturnSeconds")

EggSection:Button({
    Name = "Deploy Target Now",
    Callback = function()
        local swap = sharedEnv.ChickenFastIncubatorSwapToTarget
        if type(swap) == "function" then
            task.spawn(swap)
        else
            Window:Notify({
                Title = "Fast Coop Deploy",
                Description = "Swap controller is not ready yet",
                Lifetime = 3,
            })
        end
    end,
})

-- Auto Chaos -----------------------------------------------------------------
-- The game publishes several interactive live-event ids.  Let the user pick
-- which ids should trigger the official Chaos order; the controller below
-- still verifies EventPhase == "live" before sending anything.
sharedEnv.ChickenAutoChaos.options = {}
sharedEnv.ChickenAutoChaos.optionToId = {}
sharedEnv.ChickenAutoChaos.idToOption = {}
for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
    table.insert(sharedEnv.ChickenAutoChaos.options, eventDef.label)
    sharedEnv.ChickenAutoChaos.optionToId[eventDef.label] = eventDef.id
    sharedEnv.ChickenAutoChaos.idToOption[eventDef.id] = eventDef.label
end

function sharedEnv.ChickenAutoChaos.selectedOptions()
    local output = {}
    for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
        if sharedEnv.ChickenUfuState.events[eventDef.id] then
            table.insert(output, eventDef.label)
        end
    end
    return output
end

function sharedEnv.ChickenAutoChaos.readSelection(value)
    local selected = {}
    if type(value) == "table" then
        for key, enabled in pairs(value) do
            local option
            local active
            if type(key) == "number" and type(enabled) == "string" then
                option = enabled
                active = true
            else
                option = key
                active = enabled == true
            end
            local eventId = sharedEnv.ChickenAutoChaos.optionToId[option]
            if active and eventId then
                selected[eventId] = true
            end
        end
    elseif type(value) == "string" then
        local eventId = sharedEnv.ChickenAutoChaos.optionToId[value]
        if eventId then
            selected[eventId] = true
        end
    end
    return selected
end

-- Keep the chicken picker owned-data-only.  Catalog names are used for a
-- readable label, while the id map remains private to the controller so a
-- duplicate nickname can never select the wrong chicken.
sharedEnv.ChickenAutoChaos.rarityKeys = {
    "common", "uncommon", "rare", "epic", "legendary",
    "mythic", "divine", "celestial", "cosmic", "secret",
}
sharedEnv.ChickenAutoChaos.rarityOptions = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Mythic", "Divine", "Celestial", "Cosmic", "Secret",
}
sharedEnv.ChickenAutoChaos.rarityOptionToKey = {
    Common = "common", Uncommon = "uncommon", Rare = "rare", Epic = "epic",
    Legendary = "legendary", Mythic = "mythic", Divine = "divine",
    Celestial = "celestial", Cosmic = "cosmic", Secret = "secret",
}
sharedEnv.ChickenAutoChaos.rarityKeyToOption = {
    common = "Common", uncommon = "Uncommon", rare = "Rare", epic = "Epic",
    legendary = "Legendary", mythic = "Mythic", divine = "Divine",
    celestial = "Celestial", cosmic = "Cosmic", secret = "Secret",
}
sharedEnv.ChickenAutoChaos.chickenOptions = {}
sharedEnv.ChickenAutoChaos.chickenOptionToId = {}
sharedEnv.ChickenAutoChaos.chickenIdToOption = {}
sharedEnv.ChickenAutoChaos.chickenById = {}

function sharedEnv.ChickenAutoChaos.refreshChickenOptions()
    local ok, data = pcall(function()
        return DataService.client:get({"roster"}) or {}
    end)
    if not ok or type(data) ~= "table" then
        return false
    end
    local roster = data.roster or data
    local chickens = type(roster) == "table" and roster.chickens or {}
    if type(chickens) ~= "table" then
        return false
    end

    local typeDefs = {}
    pcall(function()
        local module = ReplicatedStorage.Content.Catalog:FindFirstChild("ChickenTypes")
        local loaded = module and loadModule(module)
        if type(loaded) == "table" then
            if type(loaded.chickenTypes) == "table" then
                loaded = loaded.chickenTypes
            end
            for _, typeDef in pairs(loaded) do
                if type(typeDef) == "table" and type(typeDef.id) == "string" then
                    typeDefs[typeDef.id] = typeDef
                end
            end
        end
    end)

    local rows = {}
    local signatureParts = {}
    local byId = {}
    for _, chicken in ipairs(chickens) do
        if type(chicken) == "table" and type(chicken.id) == "string" and chicken.id ~= "" then
            local typeId = tostring(chicken.typeId or "chicken")
            local typeDef = typeDefs[typeId]
            local typeName = typeDef and typeDef.name
            if type(typeName) ~= "string" or typeName == "" then
                typeName = typeId:gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
            end
            local nickname = type(chicken.nickname) == "string" and chicken.nickname or ""
            local rarity = string.lower(tostring(chicken.rarity or (typeDef and typeDef.rarity) or "common"))
            local level = math.max(1, math.floor(tonumber(chicken.level) or 1))
            -- Nicknamed chickens are identified by the nickname alone in the
            -- Event/UFO picker; unnamed chickens keep their Catalog name.
            local baseName = nickname ~= "" and nickname or typeName
            local display = baseName .. " [" .. string.upper(rarity) .. "] Lv" .. tostring(level)
            local row = {
                id = chicken.id,
                display = display,
                nickname = nickname,
                typeName = typeName,
                rarity = rarity,
                level = level,
                chicken = chicken,
            }
            table.insert(rows, row)
            -- Keep the resolved catalog rarity alongside the raw roster row so
            -- UFO priority still works when the server omits rarity on an
            -- owned-chicken record.
            byId[chicken.id] = row
            table.insert(signatureParts, table.concat({
                chicken.id, nickname, typeId, rarity, tostring(level),
            }, "\31"))
        end
    end
    table.sort(rows, function(a, b)
        local al = string.lower(a.display)
        local bl = string.lower(b.display)
        if al == bl then
            return a.id < b.id
        end
        return al < bl
    end)
    table.sort(signatureParts)
    local signature = table.concat(signatureParts, "\30")
    local state = sharedEnv.ChickenUfuState
    state.chickenById = byId
    state.activeChickenId = type(roster.activeId) == "string" and roster.activeId or state.activeChickenId
    if state.chickenOptionSignature == signature and state.chickenOptionsReady then
        return true
    end

    local counts = {}
    for _, row in ipairs(rows) do
        counts[row.display] = (counts[row.display] or 0) + 1
    end
    local seen = {}
    local options = {}
    local optionToId = {}
    local idToOption = {}
    for _, row in ipairs(rows) do
        seen[row.display] = (seen[row.display] or 0) + 1
        local option = row.display
        if (counts[row.display] or 0) > 1 then
            option = option .. " #" .. tostring(seen[row.display])
        end
        table.insert(options, option)
        optionToId[option] = row.id
        idToOption[row.id] = option
    end
    if #options == 0 then
        table.insert(options, "(No owned chickens)")
    end
    sharedEnv.ChickenAutoChaos.chickenOptions = options
    sharedEnv.ChickenAutoChaos.chickenOptionToId = optionToId
    sharedEnv.ChickenAutoChaos.chickenIdToOption = idToOption
    state.chickenOptionSignature = signature
    state.chickenOptionsReady = true
    local ui = sharedEnv.ChickenUfuUI
    if ui and ui.UfoChickenDropdown then
        state.chickenReordering = true
        pcall(function()
            ui.UfoChickenDropdown:ClearOptions()
            ui.UfoChickenDropdown:InsertOptions(options)
            ui.UfoChickenDropdown:UpdateSelection(sharedEnv.ChickenAutoChaos.selectedUfoChickenOptions())
        end)
        state.chickenReordering = false
    end
    return true
end

function sharedEnv.ChickenAutoChaos.selectedChickenOption()
    return sharedEnv.ChickenAutoChaos.chickenIdToOption[sharedEnv.ChickenUfuState.pickedChickenId]
end

function sharedEnv.ChickenAutoChaos.selectedUfoChickenOptions()
    local output = {}
    -- Mirror the actual UFO rotation order in the selected-value list so the
    -- UI and the runtime both show higher-Rarity chickens first.
    for _, id in ipairs(sharedEnv.ChickenAutoChaos.selectedUfoChickenIds()) do
        local option = sharedEnv.ChickenAutoChaos.chickenIdToOption[id]
        if option then
            table.insert(output, option)
        end
    end
    return output
end

function sharedEnv.ChickenAutoChaos.readSingleChicken(value)
    local option = type(value) == "number" and sharedEnv.ChickenAutoChaos.chickenOptions[value]
        or type(value) == "table" and (value[1] or value.Value or value.Name)
        or value
    return sharedEnv.ChickenAutoChaos.chickenOptionToId[option]
end

function sharedEnv.ChickenAutoChaos.readMultiChicken(value)
    local selected = {}
    if type(value) ~= "table" then
        return selected
    end
    for key, enabled in pairs(value) do
        local option
        local active
        if type(key) == "number" and type(enabled) == "string" then
            option = enabled
            active = true
        else
            option = key
            active = enabled == true
        end
        local id = sharedEnv.ChickenAutoChaos.chickenOptionToId[option]
        if active and id then
            selected[id] = true
        end
    end
    return selected
end

function sharedEnv.ChickenAutoChaos.chickenLabel(id)
    return sharedEnv.ChickenAutoChaos.chickenIdToOption[id] or tostring(id or "Active Chicken")
end

function sharedEnv.ChickenAutoChaos.rarityRank(value)
    local rarity = string.lower(tostring(value or ""))
    for index, key in ipairs(sharedEnv.ChickenAutoChaos.rarityKeys) do
        if key == rarity then
            return index
        end
    end
    return 0
end

-- When UFO auto-leave is armed, its rarity is the stopping point for the
-- current UFO rotation.  This avoids continuing toward a higher normal UFO
-- target after the user has asked to leave as soon as every selected chicken
-- reaches the configured rarity.
function sharedEnv.ChickenAutoChaos.ufoStopRarity()
    local state = sharedEnv.ChickenUfuState
    if type(state) == "table"
        and state.leaveWhenRarityEnabled == true
        and type(state.leaveWhenRarity) == "string"
        and state.leaveWhenRarity ~= ""
        and sharedEnv.ChickenAutoChaos.rarityRank(state.leaveWhenRarity) > 0 then
        return state.leaveWhenRarity
    end
    return type(state) == "table" and tostring(state.targetRarity or "") or ""
end

function sharedEnv.ChickenAutoChaos.selectedUfoChickenIds()
    local output = {}
    local seen = {}
    local state = sharedEnv.ChickenUfuState
    local entries = {}
    for _, option in ipairs(sharedEnv.ChickenAutoChaos.chickenOptions) do
        local id = sharedEnv.ChickenAutoChaos.chickenOptionToId[option]
        if id and state.pickedChickenIds[id] then
            local row = state.chickenById[id]
            table.insert(entries, {
                id = id,
                rank = sharedEnv.ChickenAutoChaos.rarityRank(row and (row.rarity or row.tier)),
                order = #entries + 1,
            })
            seen[id] = true
        end
    end
    -- Preserve an id selected before a roster refresh until the server confirms
    -- that the chicken is gone; this prevents an accidental rotation reset.
    -- Both current and temporarily-missing selections use the same priority:
    -- higher Rarity first, then the existing picker order as a stable tie-break.
    for id in pairs(state.pickedChickenIds) do
        if not seen[id] then
            local row = state.chickenById[id]
            table.insert(entries, {
                id = id,
                rank = sharedEnv.ChickenAutoChaos.rarityRank(row and (row.rarity or row.tier)),
                order = math.huge,
            })
        end
    end
    table.sort(entries, function(a, b)
        if a.rank ~= b.rank then
            return a.rank > b.rank
        end
        if a.order ~= b.order then
            return a.order < b.order
        end
        return tostring(a.id) < tostring(b.id)
    end)
    for _, entry in ipairs(entries) do
        table.insert(output, entry.id)
    end
    return output
end

function sharedEnv.ChickenAutoChaos.getUfoTargetId()
    local state = sharedEnv.ChickenUfuState
    if state.ufoRotationComplete then
        return nil
    end
    local ids = sharedEnv.ChickenAutoChaos.selectedUfoChickenIds()
    if #ids == 0 then
        -- UFO has its own multi-select roster.  Never fall back to the
        -- legacy single-chicken value while UFO is live; with no UFO pick the
        -- game's currently active chicken remains in control.
        return nil
    end
    local targetRank = sharedEnv.ChickenAutoChaos.rarityRank(
        sharedEnv.ChickenAutoChaos.ufoStopRarity()
    )
    while state.ufoIndex <= #ids do
        local id = ids[state.ufoIndex]
        local row = state.chickenById[id]
        local rowRank = sharedEnv.ChickenAutoChaos.rarityRank(row and row.rarity)
        if targetRank <= 0 or rowRank < targetRank then
            return id
        end
        state.ufoIndex += 1
        state.ufoTargetReached = true
        state.ufoAdvancePending = false
    end
    state.ufoRotationComplete = true
    state.ufoActiveChickenId = nil
    return nil
end

function sharedEnv.ChickenAutoChaos.getDesiredChickenId(eventId)
    local state = sharedEnv.ChickenUfuState
    if eventId == "ufo" then
        if not state.useUfoChicken then
            return nil
        end
        return sharedEnv.ChickenAutoChaos.getUfoTargetId()
    end
    -- Normal events always use the game's currently active chicken.  The
    -- manual Pick Chicken / Use All Event Chicken controls were removed from
    -- the Event page; keep the legacy state only for saved-config migration.
    return nil
end

function sharedEnv.ChickenAutoChaos.ufoRotationText()
    local state = sharedEnv.ChickenUfuState
    local ids = sharedEnv.ChickenAutoChaos.selectedUfoChickenIds()
    if #ids == 0 then
        return "Active chicken"
    end
    local index = math.clamp(tonumber(state.ufoIndex) or 1, 1, #ids)
    return tostring(index) .. "/" .. tostring(#ids)
end

function sharedEnv.ChickenAutoChaos.refreshActiveChicken()
    sharedEnv.ChickenAutoChaos.refreshChickenOptions()
    return sharedEnv.ChickenUfuState.activeChickenId
end

function sharedEnv.ChickenAutoChaos.setActiveChicken(id)
    local state = sharedEnv.ChickenUfuState
    if type(id) ~= "string" or id == "" or state.activeSwitchBusy then
        return false
    end
    local now = os.clock()
    if now - (tonumber(state.lastActiveSwitchAt) or 0) < 0.35 then
        return false
    end
    state.activeSwitchBusy = true
    state.lastActiveSwitchAt = now
    local ok, response = pcall(function()
        local remote = remotes:FindFirstChild("SetActiveChicken")
        if not remote then
            error("SetActiveChicken remote not found")
        end
        return remote:InvokeServer(id)
    end)
    state.activeSwitchBusy = false
    if not ok or (type(response) == "table" and response.ok == false) then
        warn("[Event UI] SetActiveChicken failed:", tostring(type(response) == "table" and response.error or response))
        return false
    end
    state.activeChickenId = id
    return true
end

sharedEnv.ChickenAutoChaos.refreshChickenOptions()

sharedEnv.ChickenUfuUI.Section:Paragraph({
    Header = "Auto Chaos",
    Body = "Pick live events. Normal events use the currently active chicken. Use UFO Chicken controls the UFO multi-select list. UFO falls back to the active chicken when its toggle/list is off or empty, and restores the previous active chicken after the event.",
})
sharedEnv.ChickenUfuUI.EventDropdown = sharedEnv.ChickenUfuUI.Section:Dropdown({
    Name = "Pick Event",
    Search = true,
    Multi = true,
    Required = false,
    Options = sharedEnv.ChickenAutoChaos.options,
    Default = sharedEnv.ChickenAutoChaos.selectedOptions(),
    Callback = function(value)
        if loadingControls then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        ufuState.events = sharedEnv.ChickenAutoChaos.readSelection(value)
        ufuState.waitingReturn = false
        ufuState.orderIssued = false
        ufuState.deathPending = false
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        ufuState.status = next(ufuState.events) and "WAITING" or "SELECT EVENT"
        saveSettings()
        print("[Event UI] selected events:", table.concat(sharedEnv.ChickenAutoChaos.selectedOptions(), ", "))
    end,
}, "AutoChaosEvents")
sharedEnv.ChickenUfuUI.UfoChickenDropdown = sharedEnv.ChickenUfuUI.Section:Dropdown({
    Name = "UFO Chickens (Multi-select)",
    Search = true,
    Multi = true,
    Required = false,
    Options = sharedEnv.ChickenAutoChaos.chickenOptions,
    Default = sharedEnv.ChickenAutoChaos.selectedUfoChickenOptions(),
    Callback = function(value)
        if loadingControls or sharedEnv.ChickenUfuState.chickenReordering then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        ufuState.pickedChickenIds = sharedEnv.ChickenAutoChaos.readMultiChicken(value)
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        saveSettings()
        print("[Event UI] UFO chicken count:", tostring(#sharedEnv.ChickenAutoChaos.selectedUfoChickenOptions()))
    end,
}, "AutoChaosUfoChickens")
sharedEnv.ChickenUfuUI.UfoTargetRarityDropdown = sharedEnv.ChickenUfuUI.Section:Dropdown({
    Name = "UFO Target Rarity",
    Search = false,
    Multi = false,
    Required = false,
    Options = sharedEnv.ChickenAutoChaos.rarityOptions,
    -- MacLib's single-select dropdown expects the option index for Default.
    -- Use the saved rarity's index so the checkmark is restored immediately
    -- on reload instead of requiring a second click.
    Default = (function()
        local selected = sharedEnv.ChickenAutoChaos.rarityKeyToOption[sharedEnv.ChickenUfuState.targetRarity]
        if selected then
            for index, option in ipairs(sharedEnv.ChickenAutoChaos.rarityOptions) do
                if option == selected then
                    return index
                end
            end
        end
        return nil
    end)(),
    Callback = function(value)
        if loadingControls or sharedEnv.ChickenUfuState.chickenReordering then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        local option = type(value) == "number" and sharedEnv.ChickenAutoChaos.rarityOptions[value]
            or type(value) == "table" and (value[1] or value.Value or value.Name)
            or value
        ufuState.targetRarity = sharedEnv.ChickenAutoChaos.rarityOptionToKey[option] or ""
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        saveSettings()
        print("[Event UI] UFO target rarity:", ufuState.targetRarity ~= "" and ufuState.targetRarity or "none")
    end,
}, "AutoChaosTargetRarity")

sharedEnv.ChickenUfuUI.InfoSection:Paragraph({
    Header = "UFO Auto Leave",
    Body = "Leave the game after every selected UFO chicken reaches this rarity. Disabled by default.",
})
sharedEnv.ChickenUfuUI.LeaveWhenRarityDropdown = sharedEnv.ChickenUfuUI.InfoSection:Dropdown({
    Name = "Leave When Rarity",
    Search = false,
    Multi = false,
    Required = false,
    Options = sharedEnv.ChickenAutoChaos.rarityOptions,
    -- No selected rarity means the field stays blank and cannot arm Auto
    -- Leave.  MacLib accepts an option index for a single-select default.
    Default = (function()
        local selected = sharedEnv.ChickenAutoChaos.rarityKeyToOption[
            sharedEnv.ChickenUfuState.leaveWhenRarity
        ]
        if selected then
            for index, option in ipairs(sharedEnv.ChickenAutoChaos.rarityOptions) do
                if option == selected then
                    return index
                end
            end
        end
        return nil
    end)(),
    Callback = function(value)
        if loadingControls then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        local option = type(value) == "number" and sharedEnv.ChickenAutoChaos.rarityOptions[value]
            or type(value) == "table" and (value[1] or value.Value or value.Name)
            or value
        ufuState.leaveWhenRarity = sharedEnv.ChickenAutoChaos.rarityOptionToKey[option] or ""
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        saveSettings()
        print(
            "[Event UI] Leave When Rarity:",
            ufuState.leaveWhenRarity ~= "" and ufuState.leaveWhenRarity or "blank"
        )
    end,
}, "LeaveWhenUfoRarity")
sharedEnv.ChickenUfuUI.LeaveWhenRarityToggle = sharedEnv.ChickenUfuUI.InfoSection:Toggle({
    Name = "Auto Leave",
    Default = sharedEnv.ChickenUfuState.leaveWhenRarityEnabled,
    Callback = function(value)
        if loadingControls then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        ufuState.leaveWhenRarityEnabled = value == true
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        saveSettings()
        Window:Notify({
            Title = "UFO Auto Leave",
            Description = ufuState.leaveWhenRarityEnabled
                and (ufuState.leaveWhenRarity ~= ""
                    and ("Will leave when all selected chickens reach "
                        .. string.upper(ufuState.leaveWhenRarity))
                    or "Select Leave When Rarity first")
                or "Disabled",
            Lifetime = 3,
        })
        print(
            "[Event UI] Auto Leave When Rarity:",
            ufuState.leaveWhenRarityEnabled and "on" or "off",
            ufuState.leaveWhenRarity
        )
    end,
}, "AutoLeaveWhenUfoRarity")
sharedEnv.ChickenUfuUI.UseUfoChickenToggle = sharedEnv.ChickenUfuUI.Section:Toggle({
    Name = "Use UFO Chicken",
    Default = sharedEnv.ChickenUfuState.useUfoChicken,
    Callback = function(state)
        if loadingControls then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        ufuState.useUfoChicken = state == true
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        saveSettings()
        print("[Event UI] Use UFO Chicken:", ufuState.useUfoChicken and "on" or "off")
    end,
}, "AutoChaosUseUfoChicken")
sharedEnv.ChickenUfuUI.Toggle = sharedEnv.ChickenUfuUI.Section:Toggle({
    Name = "Auto Chaos",
    Default = sharedEnv.ChickenUfuState.enabled,
    Callback = function(state)
        if loadingControls then
            return
        end
        local ufuState = sharedEnv.ChickenUfuState
        ufuState.enabled = state == true
        ufuState.waitingReturn = false
        ufuState.orderIssued = false
        ufuState.deathPending = false
        ufuState.ufoIndex = 1
        ufuState.ufoActiveChickenId = nil
        ufuState.ufoAdvancePending = false
        ufuState.ufoRotationComplete = false
        ufuState.ufoLeaveSessionStarted = false
        ufuState.ufoLeaveTriggered = false
        ufuState.phase = ufuState.enabled and "WAITING" or "DISABLED"
        ufuState.status = ufuState.enabled
            and (next(ufuState.events) and "WAITING" or "SELECT EVENT")
            or "DISABLED"
        if not ufuState.enabled then
            -- The controller will restore the normal Coop order on its next
            -- tick.  Do not call a server remote from the UI callback.
            ufuState.restoreCoopPending = true
        end
        saveSettings()
        print("[Event UI] Auto Chaos:", ufuState.enabled and "enabled" or "disabled")
    end,
}, "AutoUfu")

-- Hatching ---------------------------------------------------------------
-- Hatch only eggs that are currently present in the player's Flock.  The
-- server's HatchEggs RemoteFunction is the same one used by the game's own
-- multi-hatch button; one request consumes at most ten eggs of one selected
-- type.  Auto Sell acts only on the result IDs returned by that hatch request
-- and never scans or sells the existing Flock on its own.
do
    local hatchingUi = sharedEnv.ChickenHatchingUI
    local hatchingState = sharedEnv.ChickenHatchingState
    local hatchEggsRemote = remotes:FindFirstChild("HatchEggs")
    local hatchingCatalog = {}
    local hatchingGameConfig = {}
    local hatchingEggPool = {}
    pcall(function()
        hatchingCatalog = loadModule(ReplicatedStorage.Content.Catalog) or {}
    end)
    pcall(function()
        hatchingGameConfig = loadModule(ReplicatedStorage.Content.GameConfig) or {}
    end)
    pcall(function()
        local dropTables = loadModule(ReplicatedStorage.Content.DropTables) or {}
        hatchingEggPool = type(dropTables.eggPool) == "table" and dropTables.eggPool or {}
    end)

    local chickenTypes = type(hatchingCatalog.chickenTypes) == "table"
        and hatchingCatalog.chickenTypes or {}
    local eggTypes = type(hatchingCatalog.eggs) == "table"
        and hatchingCatalog.eggs or {}
    local hatchBatchMax = 10
    pcall(function()
        local configured = hatchingGameConfig.roster
            and hatchingGameConfig.roster.hatch
            and hatchingGameConfig.roster.hatch.batchMax
        hatchBatchMax = math.clamp(math.floor(tonumber(configured) or 10), 1, 10)
    end)

    local eggDropdown
    local rarityDropdown
    local chickenDropdown
    local eggOptions = {}
    local eggOptionToId = {}
    local eggIdToOption = {}
    local eggOrder = {}
    local rarityOptions = {}
    local rarityOptionToKey = {}
    local rarityKeyToOption = {}
    local chickenOptions = {}
    local chickenOptionToType = {}
    local chickenTypeToOption = {}
    local currentEggCounts = {}
    local hatchingLastRosterAt = 0

    hatchingState.startupGuardUntil = os.clock() + 0.75
    hatchingState.startupEggs = sharedEnv.ChickenSettingsSavedStringSet(hatchingState.selectedEggs)
    hatchingState.startupRarityExceptions = sharedEnv.ChickenSettingsSavedStringSet(hatchingState.sellRarityExceptions)
    hatchingState.startupChickenExceptions = sharedEnv.ChickenSettingsSavedStringSet(hatchingState.sellChickenExceptions)

    -- The roster refresh runs every two seconds.  Do not rebuild an open
    -- multi-select dropdown while the player is clicking it: changing egg
    -- counts also changes the option labels, which can make MacLib lose the
    -- item being toggled or move the list underneath the mouse.  Updates are
    -- applied on the next refresh after the dropdown closes.
    sharedEnv.ChickenHatchingDropdownOpen = function()
        local open = false
        pcall(function()
            local robloxGui = CoreGui:FindFirstChild("RobloxGui")
            local screenGui = robloxGui and robloxGui:FindFirstChild("ScreenGui")
            local base = screenGui and screenGui:FindFirstChild("Base")
            local content = base and base:FindFirstChild("Content")
            local elements = content and content:FindFirstChild("Elements")
            local scrolling = elements and elements:FindFirstChild("ElementsScrolling")
            if not scrolling then
                return
            end
            for _, item in ipairs(scrolling:GetDescendants()) do
                if item:IsA("Frame") and item.Name == "DropdownFrame" and item.Visible then
                    local parent = item.Parent
                    local nameLabel = parent and parent:FindFirstChild("DropdownName")
                    local text = nameLabel and tostring(nameLabel.Text or "") or ""
                    if text:find("Eggs to Hatch", 1, true)
                        or text:find("Sell Rarity Exceptions", 1, true)
                        or text:find("Sell Chicken Exceptions", 1, true) then
                        open = true
                        break
                    end
                end
            end
        end)
        return open
    end

    local function hatchingGetRoster()
        local ok, data = pcall(function()
            return DataService.client:get({"roster"}) or {}
        end)
        if not ok or type(data) ~= "table" then
            return nil
        end
        local roster = data.roster or data
        return type(roster) == "table" and roster or nil
    end

    local function hatchingName(value)
        local text = tostring(value or "")
        text = text:gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
        return (text:gsub("^%l", string.upper))
    end

    local function hatchingEggName(eggId)
        local info = eggTypes[tostring(eggId)] or eggTypes[eggId]
        if type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
            return info.name
        end
        return hatchingName(eggId)
    end

    local function hatchingChickenTypeName(typeId)
        local info = chickenTypes[tostring(typeId)] or chickenTypes[typeId]
        if type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
            return info.name
        end
        return hatchingName(typeId)
    end

    local function hatchingChickenRarity(chicken)
        if type(chicken) ~= "table" then
            return nil
        end
        if type(chicken.rarity) == "string" and chicken.rarity ~= "" then
            return string.lower(chicken.rarity)
        end
        local info = chickenTypes[tostring(chicken.typeId)] or chickenTypes[chicken.typeId]
        if type(info) == "table" and type(info.rarity) == "string" then
            return string.lower(info.rarity)
        end
        return nil
    end

    local function hatchingIsInverted(chicken)
        if type(chicken) ~= "table" then
            return false
        end
        if chicken.inverted == true or chicken.isInverted == true then
            return true
        end
        local mutation = chicken.mutation
        if type(mutation) == "string" then
            return string.lower(mutation) == "inverted"
        end
        if type(mutation) == "table"
            and (string.lower(tostring(mutation.id or "")) == "inverted"
                or string.lower(tostring(mutation.name or "")) == "inverted") then
            return true
        end
        for _, key in ipairs({"mutations", "mutationIds", "mutationList"}) do
            local list = chicken[key]
            if type(list) == "table" then
                for listKey, value in pairs(list) do
                    if string.lower(tostring(listKey)) == "inverted"
                        or string.lower(tostring(value)) == "inverted"
                        or (type(value) == "table"
                            and (string.lower(tostring(value.id or "")) == "inverted"
                                or string.lower(tostring(value.name or "")) == "inverted")) then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function hatchingHasNickname(chicken)
        if type(chicken) ~= "table" or type(chicken.nickname) ~= "string" then
            return false
        end
        return chicken.nickname:match("%S") ~= nil
    end

    local function hatchingIsFavorite(chicken)
        return type(chicken) == "table"
            and (chicken.favorite == true or chicken.isFavorite == true or chicken.fav == true)
    end

    local function hatchingSelectedOptions(set, optionById)
        local output = {}
        for id, selected in pairs(set or {}) do
            if selected and optionById[id] then
                table.insert(output, optionById[id])
            end
        end
        table.sort(output)
        return output
    end

    local function hatchingReadMulti(value, optionToId)
        local selected = {}
        if type(value) == "table" then
            for key, enabled in pairs(value) do
                local option
                local active
                if type(key) == "number" and type(enabled) == "string" then
                    option = enabled
                    active = true
                else
                    option = key
                    active = enabled == true
                end
                local id = optionToId[option]
                if active and id then
                    selected[id] = true
                end
            end
        elseif type(value) == "string" then
            local id = optionToId[value]
            if id then
                selected[id] = true
            end
        end
        return selected
    end

    local function hatchingSelectedChickenTypes()
        local allowed = {}
        for eggId, selected in pairs(hatchingState.selectedEggs or {}) do
            if selected then
                local pool = hatchingEggPool[tostring(eggId)] or hatchingEggPool[eggId]
                if type(pool) == "table" then
                    for typeId, chance in pairs(pool) do
                        if type(typeId) == "string" then
                            local numericChance = tonumber(chance)
                            if numericChance == nil or numericChance > 0 then
                                allowed[typeId] = true
                            end
                        elseif type(chance) == "table" then
                            local candidateId = chance.typeId or chance.chickenTypeId
                                or chance.chickenId or chance.id
                            local candidateChance = tonumber(chance.chance or chance.rate
                                or chance.weight or chance.percent)
                            if type(candidateId) == "string"
                                and (candidateChance == nil or candidateChance > 0) then
                                allowed[candidateId] = true
                            end
                        end
                    end
                end
            end
        end
        return allowed
    end

    local function rebuildHatchingOptions(roster)
        roster = type(roster) == "table" and roster or {}
        currentEggCounts = type(roster.eggs) == "table" and roster.eggs or {}
        eggOptions = {}
        eggOptionToId = {}
        eggIdToOption = {}
        eggOrder = {}
        local eggRows = {}
        for rawId, rawCount in pairs(currentEggCounts) do
            local id = tostring(rawId)
            local count = tonumber(rawCount) or 0
            if count > 0 then
                table.insert(eggRows, {
                    id = id,
                    count = count,
                    selected = hatchingState.selectedEggs[id] == true,
                    name = hatchingEggName(id),
                })
            end
        end
        table.sort(eggRows, function(a, b)
            if a.selected ~= b.selected then
                return a.selected
            end
            if a.count ~= b.count then
                return a.count > b.count
            end
            return string.lower(a.name) < string.lower(b.name)
        end)
        for _, row in ipairs(eggRows) do
            local option = row.name .. " x" .. tostring(row.count)
            if eggOptionToId[option] then
                option = option .. " [" .. row.id .. "]"
            end
            eggOptionToId[option] = row.id
            eggIdToOption[row.id] = option
            table.insert(eggOptions, option)
            table.insert(eggOrder, row.id)
        end

        local raritySet = {}
        for _, info in pairs(chickenTypes) do
            if type(info) == "table" and type(info.rarity) == "string" and info.rarity ~= "" then
                raritySet[string.lower(info.rarity)] = true
            end
        end
        rarityOptions = {}
        rarityOptionToKey = {}
        rarityKeyToOption = {}
        for rarity in pairs(raritySet) do
            local option = hatchingName(rarity)
            rarityOptions[#rarityOptions + 1] = option
            rarityOptionToKey[option] = rarity
            rarityKeyToOption[rarity] = option
        end
        table.sort(rarityOptions)

        -- Build the exception list from every chicken in the selected egg
        -- pools, not from the player's existing Flock.  Auto Sell receives
        -- only the IDs returned by the current HatchEggs request, so this list
        -- is a catalogue of possible new results rather than a sell scan.
        local typeRows = {}
        local allowedChickenTypes = hatchingSelectedChickenTypes()
        for typeId in pairs(allowedChickenTypes) do
            if type(typeId) == "string" and typeId ~= "" then
                typeRows[typeId] = {
                    typeId = typeId,
                    selected = hatchingState.sellChickenExceptions[typeId] == true,
                    name = hatchingChickenTypeName(typeId),
                }
            end
        end
        chickenOptions = {}
        chickenOptionToType = {}
        chickenTypeToOption = {}
        local typeRowsList = {}
        for _, row in pairs(typeRows) do
            table.insert(typeRowsList, row)
        end
        table.sort(typeRowsList, function(a, b)
            if a.selected ~= b.selected then
                return a.selected
            end
            return string.lower(a.name) < string.lower(b.name)
        end)
        for _, row in ipairs(typeRowsList) do
            local option = row.name
            if chickenOptionToType[option] then
                option = option .. " (" .. row.typeId .. ")"
            end
            chickenOptionToType[option] = row.typeId
            chickenTypeToOption[row.typeId] = option
            table.insert(chickenOptions, option)
        end
    end

    local function refreshHatchingDropdowns(force)
        if not eggDropdown or not rarityDropdown or not chickenDropdown then
            return
        end
        if sharedEnv.ChickenHatchingDropdownOpen() then
            hatchingState.pendingRefresh = true
            return
        end
        hatchingState.pendingRefresh = false
        local selectedEggOptions = hatchingSelectedOptions(hatchingState.selectedEggs, eggIdToOption)
        local selectedRarityOptions = hatchingSelectedOptions(hatchingState.sellRarityExceptions, rarityKeyToOption)
        local selectedChickenOptions = hatchingSelectedOptions(hatchingState.sellChickenExceptions, chickenTypeToOption)
        local signature = table.concat(eggOptions, "\31") .. "\30"
            .. table.concat(selectedEggOptions, "\31") .. "\29"
            .. table.concat(rarityOptions, "\31") .. "\28"
            .. table.concat(selectedRarityOptions, "\31") .. "\27"
            .. table.concat(chickenOptions, "\31") .. "\26"
            .. table.concat(selectedChickenOptions, "\31")
        if not force and hatchingState.optionSignature == signature then
            return
        end
        hatchingState.optionSignature = signature
        hatchingState.reordering = true
        pcall(function()
            eggDropdown:ClearOptions()
            eggDropdown:InsertOptions(eggOptions)
            eggDropdown:UpdateSelection(selectedEggOptions)
            eggDropdown:UpdateName("Eggs to Hatch (" .. tostring(#selectedEggOptions) .. ")")
            rarityDropdown:ClearOptions()
            rarityDropdown:InsertOptions(rarityOptions)
            rarityDropdown:UpdateSelection(selectedRarityOptions)
            rarityDropdown:UpdateName("Sell Rarity Exceptions (" .. tostring(#selectedRarityOptions) .. ")")
            chickenDropdown:ClearOptions()
            chickenDropdown:InsertOptions(chickenOptions)
            chickenDropdown:UpdateSelection(selectedChickenOptions)
            chickenDropdown:UpdateName("Sell Chicken Exceptions (" .. tostring(#selectedChickenOptions) .. ")")
        end)
        hatchingState.reordering = false
    end

    local function hatchingStatusBody()
        local selectedEggCount = 0
        for _, selected in pairs(hatchingState.selectedEggs or {}) do
            if selected then
                selectedEggCount += 1
            end
        end
        local selectedRarityCount = 0
        for _, selected in pairs(hatchingState.sellRarityExceptions or {}) do
            if selected then
                selectedRarityCount += 1
            end
        end
        local selectedChickenCount = 0
        for _, selected in pairs(hatchingState.sellChickenExceptions or {}) do
            if selected then
                selectedChickenCount += 1
            end
        end
        local readyEggCount = 0
        for _, count in pairs(currentEggCounts or {}) do
            readyEggCount += math.max(0, tonumber(count) or 0)
        end
        return "Auto Hatching: " .. (hatchingState.enabled and "ON" or "OFF")
            .. "\nAuto Sell: " .. (hatchingState.autoSell and "ON" or "OFF")
            .. "\nEggs selected: " .. tostring(selectedEggCount)
            .. " | Ready: " .. tostring(readyEggCount)
            .. "\nBatch: " .. tostring(hatchBatchMax) .. " eggs"
            .. "\nHatched last: " .. tostring(hatchingState.lastHatchedCount or 0)
            .. " | Sold last: " .. tostring(hatchingState.lastSoldCount or 0)
            .. "\nRarity exceptions: " .. tostring(selectedRarityCount)
            .. " | Chicken exceptions: " .. tostring(selectedChickenCount)
            .. "\nStatus: " .. tostring(hatchingState.status or "IDLE")
            .. "\nNever sell: ⭐ Favorite + Inverted + Nickname"
    end

    local function updateHatchingInfo()
        pcall(function()
            hatchingUi.InfoParagraph:UpdateBody(hatchingStatusBody())
        end)
    end

    local function hatchingSellResults(results, fallbackRoster)
        if not hatchingState.autoSell or type(results) ~= "table" then
            return 0
        end
        task.wait(0.15)
        local roster = hatchingGetRoster() or fallbackRoster or {}
        local byId = {}
        for _, chicken in ipairs(roster.chickens or {}) do
            if type(chicken) == "table" and type(chicken.id) == "string" then
                byId[chicken.id] = chicken
            end
        end
        local sellIds = {}
        local seen = {}
        for _, result in ipairs(results) do
            if type(result) == "table" then
                local id = result.chickenId or result.id
                local typeId = result.typeId or result.chickenTypeId
                local current = type(id) == "string" and byId[id] or nil
                typeId = typeId or (current and current.typeId)
                local chicken = current or result
                local rarity = hatchingChickenRarity(chicken)
                local protected = hatchingIsInverted(chicken)
                    or hatchingIsFavorite(chicken)
                    or hatchingHasNickname(chicken)
                    or type(id) ~= "string"
                    or type(typeId) ~= "string"
                    or hatchingState.sellRarityExceptions[rarity] == true
                    or hatchingState.sellChickenExceptions[typeId] == true
                if not protected and not seen[id] then
                    seen[id] = true
                    table.insert(sellIds, id)
                end
            end
        end
        if #sellIds == 0 then
            return 0
        end
        local ok, response = invokeRemoteWithTimeout(sharedEnv.ChickenFuseRemotes.sell, 5, sellIds)
        if not ok or (type(response) == "table" and response.ok == false) then
            hatchingState.status = "SELL FAILED"
            return 0
        end
        return #sellIds
    end

    local function runHatchingCycle()
        if not hatchingState.enabled or hatchingState.busy then
            return
        end
        local remaining = (tonumber(hatchingState.lastActionAt) or 0) + 0.75 - os.clock()
        if remaining > 0 then
            hatchingState.status = "COOLDOWN " .. string.format("%.1fs", remaining)
            return
        end
        local roster = hatchingGetRoster()
        if not roster then
            hatchingState.status = "WAITING FOR FLOCK DATA"
            return
        end
        local chosenId
        local chosenCount = 0
        for _, id in ipairs(eggOrder) do
            if hatchingState.selectedEggs[id] == true then
                local count = tonumber((roster.eggs or {})[id]) or 0
                if count > 0 then
                    chosenId = id
                    chosenCount = count
                    break
                end
            end
        end
        if not chosenId then
            hatchingState.status = next(hatchingState.selectedEggs or {})
                and "WAITING FOR SELECTED EGGS"
                or "SELECT EGGS TO HATCH"
            return
        end
        local amount = math.min(hatchBatchMax, 10, chosenCount)
        if not hatchEggsRemote then
            hatchingState.status = "HATCH REMOTE NOT FOUND"
            return
        end
        hatchingState.busy = true
        hatchingState.lastEggId = chosenId
        hatchingState.status = "HATCHING " .. hatchingEggName(chosenId) .. " x" .. tostring(amount)
        updateHatchingInfo()
        local ok, response = invokeRemoteWithTimeout(hatchEggsRemote, 5, chosenId, amount)
        hatchingState.busy = false
        hatchingState.lastActionAt = os.clock()
        if not ok or type(response) ~= "table" or response.ok == false then
            hatchingState.lastHatchedCount = 0
            hatchingState.lastSoldCount = 0
            hatchingState.status = "HATCH FAILED"
            return
        end
        local data = type(response.data) == "table" and response.data or {}
        local results = type(data.results) == "table" and data.results or {}
        hatchingState.lastHatchedCount = #results
        hatchingState.lastSoldCount = hatchingSellResults(results, roster)
        hatchingState.status = "HATCHED " .. tostring(#results)
            .. (hatchingState.autoSell and (" / SOLD " .. tostring(hatchingState.lastSoldCount)) or "")
    end

    local initialRoster = hatchingGetRoster() or {}
    rebuildHatchingOptions(initialRoster)

    hatchingUi.Section:Paragraph({
        Header = "Hatching Controller",
        Body = "Opens eggs from your Flock in batches of up to 10. Auto Sell only handles newly hatched results. ⭐ Favorite, Inverted, and named chickens are always protected.",
    })

    hatchingUi.Section:Toggle({
        Name = "Auto Hatching",
        Default = hatchingState.enabled,
        Callback = function(value)
            if loadingControls then
                return
            end
            hatchingState.enabled = value == true
            hatchingState.status = hatchingState.enabled and "READY" or "DISABLED"
            saveSettings()
            updateHatchingInfo()
        end,
    }, "AutoHatching")

    eggDropdown = hatchingUi.Section:Dropdown({
        Name = "Eggs to Hatch (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = eggOptions,
        Default = hatchingSelectedOptions(hatchingState.selectedEggs, eggIdToOption),
        Callback = function(value)
            if loadingControls or hatchingState.reordering
                or os.clock() < (tonumber(hatchingState.startupGuardUntil) or 0) then
                return
            end
            hatchingState.selectedEggs = hatchingReadMulti(value, eggOptionToId)
            hatchingState.status = hatchingState.enabled and "READY" or "DISABLED"
            -- MacLib has already applied the checkbox click.  Rebuilding all
            -- options here would interrupt the dropdown's click animation and
            -- make the list visibly flash.  Let the periodic refresh apply the
            -- new counts/order after the dropdown is closed.
            hatchingState.pendingRefresh = true
            saveSettings()
            updateHatchingInfo()
        end,
    }, "HatchingEggs")

    hatchingUi.Section:Toggle({
        Name = "Auto Sell",
        Default = hatchingState.autoSell,
        Callback = function(value)
            if loadingControls then
                return
            end
            hatchingState.autoSell = value == true
            saveSettings()
            updateHatchingInfo()
        end,
    }, "HatchingAutoSell")

    rarityDropdown = hatchingUi.Section:Dropdown({
        Name = "Sell Rarity Exceptions (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = rarityOptions,
        Default = hatchingSelectedOptions(hatchingState.sellRarityExceptions, rarityKeyToOption),
        Callback = function(value)
            if loadingControls or hatchingState.reordering
                or os.clock() < (tonumber(hatchingState.startupGuardUntil) or 0) then
                return
            end
            hatchingState.sellRarityExceptions = hatchingReadMulti(value, rarityOptionToKey)
            hatchingState.pendingRefresh = true
            saveSettings()
            updateHatchingInfo()
        end,
    }, "HatchingSellRarityExceptions")

    chickenDropdown = hatchingUi.Section:Dropdown({
        Name = "Sell Chicken Exceptions (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = chickenOptions,
        Default = hatchingSelectedOptions(hatchingState.sellChickenExceptions, chickenTypeToOption),
        Callback = function(value)
            if loadingControls or hatchingState.reordering then
                return
            end
            hatchingState.sellChickenExceptions = hatchingReadMulti(value, chickenOptionToType)
            hatchingState.pendingRefresh = true
            saveSettings()
            updateHatchingInfo()
        end,
    }, "HatchingSellChickenExceptions")

    sharedEnv.ChickenHatchingRefresh = function()
        if sharedEnv.ChickenHatchingDropdownOpen() then
            hatchingState.pendingRefresh = true
            updateHatchingInfo()
            return
        end
        local roster = hatchingGetRoster()
        if roster then
            rebuildHatchingOptions(roster)
            hatchingLastRosterAt = os.clock()
            refreshHatchingDropdowns(false)
        end
        updateHatchingInfo()
    end
    sharedEnv.ChickenHatchingRun = runHatchingCycle
    sharedEnv.ChickenHatchingStatus = updateHatchingInfo

    task.delay(0.5, function()
        if sharedEnv.ChickenArenaGeneration ~= generation then
            return
        end
        hatchingState.selectedEggs = sharedEnv.ChickenSettingsSavedStringSet(hatchingState.startupEggs)
        hatchingState.sellRarityExceptions = sharedEnv.ChickenSettingsSavedStringSet(hatchingState.startupRarityExceptions)
        hatchingState.sellChickenExceptions = sharedEnv.ChickenSettingsSavedStringSet(hatchingState.startupChickenExceptions)
        hatchingState.startupGuardUntil = 0
        hatchingState.status = hatchingState.enabled and "READY" or "DISABLED"
        refreshHatchingDropdowns(true)
        saveSettings()
        updateHatchingInfo()
    end)

    refreshHatchingDropdowns(true)
    updateHatchingInfo()
end

-- Auto Fuse ---------------------------------------------------------------
-- This controller intentionally uses the same FuseChickens argument shape as
-- the game's CollectionController: (idA, idB, lockChoices, nil, nameSide).
-- It never selects Favorite, Inverted, active Coop, or explicit-exception
-- chickens for fusion.  Renamed chickens remain eligible for fusion but are
-- never sold by any Auto Fuse mode.  All decisions are made from the
-- replicated roster;
-- the server remains authoritative for every fuse/sell request.
do
    local fuseUi = sharedEnv.ChickenAutoFuseUI
    local fuseState = sharedEnv.ChickenAutoFuseState
    fuseState.startupGuardUntil = os.clock() + 0.5
    fuseState.startupMode = fuseState.mode
    fuseState.startupRarities = {}
    for rarity, enabled in pairs(fuseState.rarities or {}) do
        if enabled then
            fuseState.startupRarities[rarity] = true
        end
    end
    fuseState.startupNames = {}
    for typeId, enabled in pairs(fuseState.selectedNames or {}) do
        if enabled then
            fuseState.startupNames[typeId] = true
        end
    end
    local fuseCatalog
    local fuseGenome
    pcall(function()
        fuseCatalog = loadModule(ReplicatedStorage.Content.Catalog)
    end)
    pcall(function()
        fuseGenome = loadModule(ReplicatedStorage.Features.Chicken.Genome)
    end)

    local rarityKeys = {}
    local rarityKeyToOption = {}
    local rarityOptionToKey = {}
    local rarityRank = fuseCatalog and fuseCatalog.rarity and fuseCatalog.rarity.rank or {}
    for rarity, rank in pairs(rarityRank) do
        table.insert(rarityKeys, {key = rarity, rank = tonumber(rank) or 999})
    end
    table.sort(rarityKeys, function(a, b)
        if a.rank == b.rank then
            return a.key < b.key
        end
        return a.rank < b.rank
    end)
    local rarityOptions = {}
    for _, row in ipairs(rarityKeys) do
        local option = string.upper(row.key:sub(1, 1)) .. row.key:sub(2)
        rarityKeyToOption[row.key] = option
        rarityOptionToKey[option] = row.key
        table.insert(rarityOptions, option)
    end
    -- Keep the selector empty until the user explicitly chooses a rarity.
    -- Auto-selecting the first catalog entry made a blank/default setup look
    -- like "Rarity: common" and could arm the controller accidentally.

    local function selectedRarityKeys()
        local selected = fuseState.rarities or {}
        local keys = {}
        for _, row in ipairs(rarityKeys) do
            if selected[row.key] == true then
                table.insert(keys, row.key)
            end
        end
        return keys
    end

    local function syncLegacyRarity()
        local keys = selectedRarityKeys()
        fuseState.rarity = keys[1] or ""
        return keys
    end

    -- Keep the legacy single-rarity field useful for saved configs and older
    -- status consumers, while all decisions use the multi-select set.
    syncLegacyRarity()

    local modeOptions = {"1. Until No Pair", "2. Best Stats", "3. Same Type"}
    local modeToOption = {
        rarity = modeOptions[1],
        stats = modeOptions[2],
        sameName = modeOptions[3],
    }
    local optionToMode = {
        [modeOptions[1]] = "rarity",
        [modeOptions[2]] = "stats",
        [modeOptions[3]] = "sameName",
    }
    -- MacLib's single-select dropdown expects the default as an option index
    -- (the same form used by the Fast Coop selectors).  Passing the display
    -- string leaves the control visually blank after a reload even though
    -- the saved mode/state is still `sameName`.
    local modeDefaultIndex
    local modeDefaultOption = modeToOption[fuseState.mode]
    for index, option in ipairs(modeOptions) do
        if option == modeDefaultOption then
            modeDefaultIndex = index
            break
        end
    end
    local exceptionDropdown
    local exceptionOptionToId = {}
    local fuseBodyLabel
    local fuseBodyLastScanAt = 0
    local lastEligibleCount = 0
    local lastPairCount = 0
    local lastSummaryAt = 0

    local statKeys = {"vigor", "furia", "velocidad", "impetu", "fertility"}
    local statLabels = {"HP", "ATK", "SPD", "PWR", "EGG"}

    local function fuseRoster()
        local ok, data = pcall(function()
            return DataService.client:get({"roster"}) or {}
        end)
        if not ok or type(data) ~= "table" or type(data.chickens) ~= "table" then
            return nil, "ROSTER UNAVAILABLE"
        end
        return data, nil
    end

    local function chickenRarity(chicken)
        if type(chicken) ~= "table" then
            return nil
        end
        if type(chicken.rarity) == "string" and chicken.rarity ~= "" then
            return string.lower(chicken.rarity)
        end
        local typeInfo = fuseCatalog and fuseCatalog.chickenTypes and fuseCatalog.chickenTypes[chicken.typeId]
        return typeInfo and type(typeInfo.rarity) == "string"
            and string.lower(typeInfo.rarity) or nil
    end

    local function chickenName(chicken)
        if type(chicken.nickname) == "string" and chicken.nickname ~= "" then
            return chicken.nickname
        end
        local typeId = tostring(chicken.typeId or "Chicken")
        return typeId:gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
    end

    -- Mode 3 compares the actual chicken type/name, not its optional
    -- nickname. This prevents unrelated chickens both nicknamed "up" from
    -- becoming a false pair.
    local function chickenPairKey(chicken)
        if type(chicken) ~= "table" then
            return ""
        end
        return tostring(chicken.typeId or chicken.chickenTypeId or "")
    end

    local function isInverted(chicken)
        if type(chicken) ~= "table" then
            return false
        end
        if chicken.inverted == true or chicken.isInverted == true then
            return true
        end
        local mutation = chicken.mutation
        if type(mutation) == "string" then
            return mutation:lower() == "inverted"
        end
        if type(mutation) == "table" then
            if mutation.id == "inverted" or mutation.name == "Inverted" then
                return true
            end
        end
        for _, key in ipairs({"mutations", "mutationIds", "mutationList"}) do
            local list = chicken[key]
            if type(list) == "table" then
                for listKey, value in pairs(list) do
                    if (type(listKey) == "string" and listKey:lower() == "inverted")
                        or (type(value) == "string" and value:lower() == "inverted")
                        or (type(value) == "table" and (value.id == "inverted" or value.name == "Inverted")) then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function isProtected(chicken, roster)
        if isInverted(chicken) then
            return true, "INVERTED"
        end
        if chicken.favorite == true then
            return true, "FAVORITE"
        end
        if fuseState.exceptions[chicken.id] then
            return true, "EXCEPTION"
        end
        if roster and roster.activeId == chicken.id then
            return true, "ACTIVE COOP"
        end
        return false, nil
    end

    local function statSnapshot(chicken)
        local rarity = chickenRarity(chicken)
        local cap
        if fuseGenome and type(fuseGenome.cap) == "function" then
            local ok, value = pcall(fuseGenome.cap, rarity)
            if ok then
                cap = tonumber(value)
            end
        end
        cap = cap or 0
        local genome = type(chicken.genome) == "table" and chicken.genome or {}
        local values = {}
        local full = 0
        local nearFull = 0
        local known = 0
        for _, key in ipairs(statKeys) do
            local value = tonumber(genome[key])
            values[key] = value
            if value ~= nil then
                known += 1
                if cap > 0 and value >= cap then
                    full += 1
                end
                if cap > 0 and value >= cap - 1 then
                    nearFull += 1
                end
            end
        end
        return {
            cap = cap,
            values = values,
            full = full,
            nearFull = nearFull,
            known = known,
        }
    end

    local function candidateRows(roster)
        local rows = {}
        local chickens = roster and roster.chickens or {}
        local selected = fuseState.rarities or {}
        local selectedNames = fuseState.selectedNames or {}
        -- No name selected means no name restriction.  This keeps existing
        -- configs fully compatible while allowing a multi-select name filter
        -- to apply uniformly to all three Fuse modes.
        local restrictNames = next(selectedNames) ~= nil
        for _, chicken in ipairs(chickens) do
            local rarity = chickenRarity(chicken)
            if type(chicken) == "table"
                and type(chicken.id) == "string"
                and rarity ~= nil
                and selected[rarity] == true
                and (not restrictNames or selectedNames[chickenPairKey(chicken)] == true) then
                local protected, reason = isProtected(chicken, roster)
                table.insert(rows, {
                    chicken = chicken,
                    rarity = rarity,
                    protected = protected,
                    protectedReason = reason,
                    stats = statSnapshot(chicken),
                })
            end
        end
        return rows
    end

    local function updateFuseParagraph(body)
        local direct = false
        if fuseBodyLabel and fuseBodyLabel.Parent then
            local ok = pcall(function()
                fuseBodyLabel.Text = body
            end)
            direct = ok
        elseif os.clock() - fuseBodyLastScanAt >= 5 then
            fuseBodyLastScanAt = os.clock()
            pcall(function()
                for _, item in ipairs(CoreGui:GetDescendants()) do
                    if item:IsA("TextLabel") and item.Text == "Auto Fuse Status" then
                        local label = item.Parent and item.Parent:FindFirstChild("ParagraphBody")
                        if label and label:IsA("TextLabel") then
                            fuseBodyLabel = label
                            label.Text = body
                            direct = true
                            break
                        end
                    end
                end
            end)
        end
        if not direct then
            pcall(function()
                fuseUi.InfoParagraph:UpdateBody(body)
            end)
        end
    end

    local function refreshFuseExceptions()
        if not exceptionDropdown then
            return
        end
        local roster = select(1, fuseRoster())
        if not roster then
            return
        end
        local rows = {}
        exceptionOptionToId = {}
        local seenNames = {}
        local selected = fuseState.rarities or {}
        for _, chicken in ipairs(roster.chickens or {}) do
            local rarity = chickenRarity(chicken)
            if type(chicken) == "table" and rarity ~= nil and selected[rarity] == true then
                local name = chickenName(chicken)
                seenNames[name] = (seenNames[name] or 0) + 1
                local suffix = seenNames[name] > 1 and (" #" .. tostring(seenNames[name])) or ""
                local icon = chicken.favorite == true and "⭐ " or ""
                local option = icon .. name .. suffix
                if exceptionOptionToId[option] then
                    option = option .. " " .. tostring(chicken.id)
                end
                exceptionOptionToId[option] = chicken.id
                table.insert(rows, {
                    option = option,
                    id = chicken.id,
                    selected = fuseState.exceptions[chicken.id] == true,
                })
            end
        end
        table.sort(rows, function(a, b)
            if a.selected ~= b.selected then
                return a.selected
            end
            return a.option < b.option
        end)
        local options = {}
        local selected = {}
        for _, row in ipairs(rows) do
            table.insert(options, row.option)
            if row.selected then
                table.insert(selected, row.option)
            end
        end
        local signature = table.concat(options, "\31") .. "\30" .. table.concat(selected, "\31")
        if fuseState.optionSignature == signature then
            return
        end
        fuseState.optionSignature = signature
        fuseState.reordering = true
        pcall(function()
            exceptionDropdown:ClearOptions()
            exceptionDropdown:InsertOptions(options)
            exceptionDropdown:UpdateSelection(selected)
            exceptionDropdown:UpdateName("Exceptions (" .. tostring(#selected) .. ")")
        end)
        fuseState.reordering = false
    end

    -- Rarity options are owned-data aware as well.  This lets the player
    -- choose Pick to Fuse first: the rarity list then contains only rarities
    -- represented by those selected owned types.  With no name restriction it
    -- contains only rarities currently present in the Flock.
    sharedEnv.ChickenAutoFuseRefreshRarities = function(force)
        local dropdown = fuseState.rarityDropdown
        if not dropdown then
            return
        end
        local roster = select(1, fuseRoster())
        if not roster then
            return
        end
        local selectedNames = fuseState.selectedNames or {}
        local restrictNames = next(selectedNames) ~= nil
        local available = {}
        for _, chicken in ipairs(roster.chickens or {}) do
            if type(chicken) == "table" then
                local rarity = chickenRarity(chicken)
                local typeId = chickenPairKey(chicken)
                if rarity and (not restrictNames or selectedNames[typeId] == true) then
                    available[rarity] = true
                end
            end
        end

        local options = {}
        for _, row in ipairs(rarityKeys) do
            if available[row.key] and rarityKeyToOption[row.key] then
                table.insert(options, rarityKeyToOption[row.key])
            end
        end

        local filteredRarities = {}
        local changed = false
        for rarity, enabled in pairs(fuseState.rarities or {}) do
            if enabled and available[rarity] then
                filteredRarities[rarity] = true
            elseif enabled then
                changed = true
            end
        end
        if changed then
            fuseState.rarities = filteredRarities
            syncLegacyRarity()
            saveSettings()
        end

        local selectedOptions = {}
        for _, rarity in ipairs(selectedRarityKeys()) do
            if available[rarity] and rarityKeyToOption[rarity] then
                table.insert(selectedOptions, rarityKeyToOption[rarity])
            end
        end
        local signature = table.concat(options, "\31") .. "\30"
            .. table.concat(selectedOptions, "\31")
        if not force and fuseState.rarityOptionSignature == signature then
            return
        end
        fuseState.rarityOptionSignature = signature
        fuseState.reordering = true
        pcall(function()
            dropdown:ClearOptions()
            dropdown:InsertOptions(options)
            dropdown:UpdateSelection(selectedOptions)
        end)
        fuseState.reordering = false
    end

    sharedEnv.ChickenAutoFuseRefreshNames = function(force)
        local dropdown = fuseState.nameDropdown
        if not dropdown then
            return
        end
        local roster = select(1, fuseRoster())
        if not roster then
            return
        end
        local typeRows = {}
        local selectedRarities = fuseState.rarities or {}
        local restrictRarities = next(selectedRarities) ~= nil
        for _, chicken in ipairs(roster.chickens or {}) do
            if type(chicken) == "table" then
                local rarity = chickenRarity(chicken)
                local typeId = chickenPairKey(chicken)
                if typeId ~= "" and rarity ~= nil
                    and (not restrictRarities or selectedRarities[rarity] == true) then
                    local row = typeRows[typeId]
                    if not row then
                        local info = fuseCatalog and fuseCatalog.chickenTypes
                            and fuseCatalog.chickenTypes[typeId]
                        local name = info and info.name
                        if type(name) ~= "string" or name == "" then
                            name = typeId:gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
                        end
                        row = {
                            typeId = typeId,
                            name = name,
                            count = 0,
                            selected = (fuseState.selectedNames or {})[typeId] == true,
                        }
                        typeRows[typeId] = row
                    end
                    row.count += 1
                end
            end
        end

        local rows = {}
        for _, row in pairs(typeRows) do
            table.insert(rows, row)
        end
        table.sort(rows, function(a, b)
            if a.selected ~= b.selected then
                return a.selected
            end
            local nameA = string.lower(tostring(a.name))
            local nameB = string.lower(tostring(b.name))
            if nameA == nameB then
                return tostring(a.typeId) < tostring(b.typeId)
            end
            return nameA < nameB
        end)

        fuseState.nameOptionToType = {}
        fuseState.nameTypeToOption = {}
        local options = {}
        local selectedOptions = {}
        for _, row in ipairs(rows) do
            local option = tostring(row.name) .. " [Owned x" .. tostring(row.count) .. "]"
            if fuseState.nameOptionToType[option] then
                option = option .. " (" .. tostring(row.typeId) .. ")"
            end
            fuseState.nameOptionToType[option] = row.typeId
            fuseState.nameTypeToOption[row.typeId] = option
            table.insert(options, option)
            if row.selected then
                table.insert(selectedOptions, option)
            end
        end

        local signature = table.concat(options, "\31") .. "\30"
            .. table.concat(selectedOptions, "\31")
        if not force and fuseState.nameOptionSignature == signature then
            return
        end
        fuseState.nameOptionSignature = signature
        fuseState.reordering = true
        pcall(function()
            dropdown:ClearOptions()
            dropdown:InsertOptions(options)
            dropdown:UpdateSelection(selectedOptions)
            dropdown:UpdateName("Pick to Fuse (" .. tostring(#selectedOptions) .. ")")
        end)
        fuseState.reordering = false
    end

    local function fuseStatusBody()
        local modeText = fuseState.mode == "stats" and "BEST STATS"
            or fuseState.mode == "rarity" and "UNTIL NO PAIR"
            or fuseState.mode == "sameName" and "SAME TYPE"
            or "NOT SELECTED"
        local selected = selectedRarityKeys()
        local rarityText = #selected > 0 and table.concat(selected, ", ") or "NOT SELECTED"
        local selectedNames = fuseState.selectedNames or {}
        local visibleNameOptions = fuseState.nameTypeToOption or {}
        local selectedNameCount = 0
        for typeId, enabled in pairs(selectedNames) do
            if enabled and visibleNameOptions[typeId] then
                selectedNameCount += 1
            end
        end
        local nameText = selectedNameCount > 0 and (tostring(selectedNameCount) .. " selected") or "ALL"
        local stateText = fuseState.enabled and tostring(fuseState.status) or "DISABLED"
        local cooldown = math.max(0, (tonumber(fuseState.lastActionAt) or 0)
            + (tonumber(fuseState.delay) or 0.5) - os.clock())
        local cooldownText = cooldown > 0 and ("COOLDOWN " .. string.format("%.1fs", cooldown)) or "READY"
        local keepText = fuseState.mode == "stats"
            and (tostring(fuseState.lastKeptCount or 0) .. " / " .. tostring(fuseState.keepBest or 0)
                .. " total (incl. no-pair)")
            or "OFF (Mode 2 only)"
        return "Mode: " .. modeText
            .. "\nRarity: " .. rarityText
            .. "\nNames: " .. nameText
            .. "\nStatus: " .. stateText
            .. "\nEligible: " .. tostring(lastEligibleCount)
            .. " | Pairs: " .. tostring(lastPairCount)
            .. "\nKeep Best stat: " .. keepText
            .. "\nNext action: " .. cooldownText
            .. "\nNickname Tier Up: " .. ((fuseState.renameIfUp or "") ~= "" and fuseState.renameIfUp or "OFF")
            .. "\nProtected: ⭐ Favorite + Inverted + Exceptions"
            .. "\nNamed: safe from selling; still fuseable"
            .. "\nMode 2: incomplete stats are fused; no selling"
    end

    local function refreshFuseStatus(force)
        if force or os.clock() - lastSummaryAt >= 0.5 then
            lastSummaryAt = os.clock()
            updateFuseParagraph(fuseStatusBody())
        end
    end

    local function generationNumber(chicken)
        local known = fuseState.generationById[chicken.id]
        if known then
            return known
        end
        local nickname = type(chicken.nickname) == "string" and chicken.nickname or ""
        local letter = nickname:match("^([A-Z])$")
        if letter then
            return string.byte(letter) - string.byte("A") + 1
        end
        return 0
    end

    local function nicknameForGeneration(generation)
        local value = math.clamp(tonumber(generation) or 1, 1, 26)
        return string.char(string.byte("A") + value - 1)
    end

    local function pairScore(a, b)
        local unionFull = 0
        local progress = 0
        for _, key in ipairs(statKeys) do
            local cap = math.max(a.stats.cap, b.stats.cap)
            local av = tonumber(a.stats.values[key]) or 0
            local bv = tonumber(b.stats.values[key]) or 0
            local value = math.max(av, bv)
            if cap > 0 and value >= cap then
                unionFull += 1
            end
            if cap > 0 then
                progress += math.clamp(value / cap, 0, 1)
            end
        end
        -- Prefer pairs that preserve the most complete genes, then total
        -- progress; generation/name are only deterministic tie-breakers.
        return unionFull * 100000 + progress * 1000
            - math.abs(generationNumber(a.chicken) - generationNumber(b.chicken))
    end

    local function refreshKeepBest(rows)
        -- Keep Best is a stat-completion safeguard and therefore applies only
        -- to Mode 2. The count is a total across all non-protected candidates,
        -- including chickens that currently have no possible pair. Mode 1
        -- must be free to use every non-protected chicken in its progression.
        if fuseState.mode ~= "stats" then
            fuseState.keepBestIds = {}
            fuseState.lastKeptCount = 0
            for _, row in ipairs(rows) do
                row.keepBest = false
            end
            return
        end
        local candidates = {}
        for _, row in ipairs(rows) do
            if not row.protected then
                table.insert(candidates, row)
            end
            row.keepBest = false
        end
        table.sort(candidates, function(a, b)
            local scoreA = pairScore(a, a)
            local scoreB = pairScore(b, b)
            if scoreA == scoreB then
                return tostring(a.chicken.id) < tostring(b.chicken.id)
            end
            return scoreA > scoreB
        end)
        fuseState.keepBestIds = {}
        local keepCount = math.clamp(math.floor(tonumber(fuseState.keepBest) or 0), 0, 100)
        local kept = math.min(keepCount, #candidates)
        for index = 1, kept do
            local row = candidates[index]
            row.keepBest = true
            fuseState.keepBestIds[row.chicken.id] = true
        end
        fuseState.lastKeptCount = kept
    end

    local function choosePair(rows)
        -- Both modes use the same best-pair scoring.  The mode changes what
        -- happens after a fuse (rarity progression vs. stat completion),
        -- while pairing always stays inside one selected rarity. Mode 3 adds
        -- an exact chicken-type/name requirement on top of that.
        local bestA, bestB, bestScore
        for i = 1, #rows - 1 do
            if not rows[i].protected and not rows[i].keepBest then
                for j = i + 1, #rows do
                    if not rows[j].protected and not rows[j].keepBest
                        and rows[j].rarity == rows[i].rarity
                        and (fuseState.mode ~= "sameName"
                            or chickenPairKey(rows[j].chicken) == chickenPairKey(rows[i].chicken)) then
                        local score = pairScore(rows[i], rows[j])
                        if not bestScore or score > bestScore then
                            bestA, bestB, bestScore = rows[i], rows[j], score
                        end
                    end
                end
            end
        end
        return bestA, bestB
    end

    local function requestFuse(a, b)
        if fuseState.busy then
            return false
        end
        fuseState.busy = true
        fuseState.status = "FUSING " .. chickenName(a.chicken) .. " + " .. chickenName(b.chicken)
        refreshFuseStatus(true)
        local ok, response = invokeRemoteWithTimeout(
            sharedEnv.ChickenFuseRemotes.fuse,
            8,
            a.chicken.id,
            b.chicken.id,
            {},
            nil,
            "a"
        )
        fuseState.busy = false
        if not ok or type(response) ~= "table" or response.ok ~= true or type(response.data) ~= "table" then
            local reason = type(response) == "table" and tostring(response.error or "rejected") or tostring(response)
            fuseState.status = "FUSE ERROR: " .. reason
            refreshFuseStatus(true)
            return false
        end
        local result = response.data
        local resultId = type(result.chickenId) == "string" and result.chickenId or nil
        if resultId then
            local sourceRank = tonumber(rarityRank[a.rarity]) or tonumber(rarityRank[fuseState.rarity]) or 0
            local resultRank = tonumber(rarityRank[result.rarity]) or sourceRank
            if result.ascended == true or resultRank > sourceRank then
                -- Both modes can produce an ascended rarity.  Use the same
                -- configurable name whenever that happens.
                local desiredName = fuseState.mode == "sameName"
                    and "up"
                    or tostring(fuseState.renameIfUp or "")
                if desiredName == "" then
                    fuseState.status = "FUSED UP; RENAME DISABLED"
                else
                    local nameOk, nameResponse = invokeRemoteWithTimeout(
                        sharedEnv.ChickenFuseRemotes.nickname,
                        3,
                        resultId,
                        desiredName
                    )
                    if not nameOk or (type(nameResponse) == "table" and nameResponse.ok == false) then
                        fuseState.status = "FUSED UP; NICKNAME RETRY"
                    else
                        fuseState.status = "FUSED -> " .. desiredName
                    end
                end
            elseif fuseState.mode == "stats" then
                -- A same-rarity Mode 2 result keeps the generation marker.
                local nextGeneration = math.max(generationNumber(a.chicken), generationNumber(b.chicken)) + 1
                fuseState.generationById[resultId] = nextGeneration
                local nickname = nicknameForGeneration(nextGeneration)
                local nameOk, nameResponse = invokeRemoteWithTimeout(
                    sharedEnv.ChickenFuseRemotes.nickname,
                    3,
                    resultId,
                    nickname
                )
                if not nameOk or (type(nameResponse) == "table" and nameResponse.ok == false) then
                    fuseState.status = "FUSED; NICKNAME RETRY " .. nickname
                else
                    fuseState.status = "FUSED -> " .. nickname
                end
            else
                fuseState.status = "FUSED SUCCESSFULLY"
            end
        else
            fuseState.status = "FUSED SUCCESSFULLY"
        end
        fuseState.lastActionAt = os.clock()
        refreshFuseStatus(true)
        return true
    end

    local function renameAlone(row)
        -- Mark the last unpaired chicken in every fuse mode.  Mode 1 groups
        -- by rarity, Mode 2 groups by rarity for stat optimization, and
        -- Mode 3 groups by rarity + chicken type (same-name pairing).
        if not row or row.protected or row.keepBest then
            return false
        end
        local id = type(row.chicken.id) == "string" and row.chicken.id or nil
        local desiredName = tostring(fuseState.renameIfAlone or "alone")
        if not id or desiredName == "" or fuseState.aloneIds[id] then
            return false
        end
        local currentNickname = type(row.chicken.nickname) == "string"
            and row.chicken.nickname or ""
        if currentNickname == desiredName then
            fuseState.aloneIds[id] = true
            return false
        end
        fuseState.status = "RENAMING " .. chickenName(row.chicken) .. " -> " .. desiredName
        refreshFuseStatus(true)
        local ok, response = invokeRemoteWithTimeout(
            sharedEnv.ChickenFuseRemotes.nickname,
            3,
            id,
            desiredName
        )
        if ok and not (type(response) == "table" and response.ok == false) then
            fuseState.aloneIds[id] = true
            fuseState.lastActionAt = os.clock()
            fuseState.status = "RENAMED -> " .. desiredName
            return true
        end
        -- Treat a failed rename as an action for cooldown purposes too, so a
        -- transient server rejection cannot spam SetChickenNickname.
        fuseState.lastActionAt = os.clock()
        fuseState.status = "ALONE RENAME RETRY"
        return false
    end

    local function runFuseCycle()
        if not fuseState.enabled or fuseState.busy then
            return
        end
        local selectedRarities = selectedRarityKeys()
        if (fuseState.mode ~= "rarity" and fuseState.mode ~= "stats"
            and fuseState.mode ~= "sameName")
            or #selectedRarities == 0 then
            fuseState.status = "SELECT MODE AND RARITY"
            refreshFuseStatus(false)
            return
        end
        local remaining = (tonumber(fuseState.lastActionAt) or 0)
            + (tonumber(fuseState.delay) or 0.5) - os.clock()
        if remaining > 0 then
            fuseState.status = "WAITING FOR DELAY"
            refreshFuseStatus(false)
            return
        end
        local roster, rosterError = fuseRoster()
        if not roster then
            fuseState.status = rosterError or "ROSTER UNAVAILABLE"
            refreshFuseStatus(false)
            return
        end
        local rows = candidateRows(roster)
        refreshKeepBest(rows)
        local eligible = {}
        for _, row in ipairs(rows) do
            if not row.protected and not row.keepBest then
                table.insert(eligible, row)
            end
        end
        lastEligibleCount = #eligible
        local eligibleByRarity = {}
        for _, row in ipairs(eligible) do
            local groupKey = row.rarity
            if fuseState.mode == "sameName" then
                groupKey = row.rarity .. "\31" .. chickenPairKey(row.chicken)
            end
            eligibleByRarity[groupKey] = (eligibleByRarity[groupKey] or 0) + 1
        end
        lastPairCount = 0
        for _, count in pairs(eligibleByRarity) do
            lastPairCount += math.floor(count / 2)
        end
        local first, second = choosePair(rows)
        if first and second then
            requestFuse(first, second)
            return
        end
        -- A singleton left after pairing/Keep Best is marked once so it is
        -- easy to identify.  Mode 3 uses the same-name group key; Modes 1/2
        -- use rarity, matching the pair-selection rules above.
        local desiredName = tostring(fuseState.renameIfAlone or "alone")
        local aloneRow
        for _, row in ipairs(eligible) do
            local groupKey = row.rarity
            if fuseState.mode == "sameName" then
                groupKey = row.rarity .. "\31" .. chickenPairKey(row.chicken)
            end
            if eligibleByRarity[groupKey] == 1
                and tostring(row.chicken.nickname or "") ~= desiredName
                and not fuseState.aloneIds[row.chicken.id] then
                aloneRow = row
                break
            end
        end
        if aloneRow and renameAlone(aloneRow) then
            refreshFuseStatus(true)
            return
        end
        if fuseState.mode == "sameName" then
            -- Mode 3 never sells.  Once every same-name pair is exhausted,
            -- leave all remaining chickens untouched and wait for a new pair.
            fuseState.status = "NO SAME-NAME PAIR"
            refreshFuseStatus(false)
            return
        end
        if #eligible < 2 then
            fuseState.status = "NO PAIR AVAILABLE"
            refreshFuseStatus(false)
            return
        end
        if not first or not second then
            fuseState.status = "NO SAFE PAIR"
            refreshFuseStatus(false)
            return
        end
    end

    -- Keep the long controller explanation with the right-side status cards;
    -- the left column remains reserved for controls and selectors.
    fuseUi.InfoSection:Paragraph({
        Header = "Auto Fuse Controller",
        Body = "Fuses only chickens in the selected Rarities. Pick to Fuse lists owned chicken types from those rarities; if Rarity is empty, it starts with all owned types so you can pick first. The Rarity list is then narrowed to the selected owned types. The filter applies to every mode. Mode 3 requires the same chicken name/type and stops when no pair remains; it never sells. Mode 2 fuses incomplete-stat chickens to build Genome Stat instead of selling them. Keep Best stat protects the selected total number of top chickens, including no-pair chickens. ⭐ Favorite, Inverted, active Coop, and Exceptions are never used.",
    })

    fuseUi.Section:Toggle({
        Name = "Auto Fuse",
        Default = fuseState.enabled,
        Callback = function(value)
            if loadingControls or fuseState.reordering then
                return
            end
            fuseState.enabled = value == true
            fuseState.status = fuseState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshFuseStatus(true)
        end,
    }, "AutoFuse")

    fuseState.modeDropdown = fuseUi.Section:Dropdown({
        Name = "Fuse Mode",
        Search = false,
        Multi = false,
        Required = false,
        Options = modeOptions,
        Default = modeDefaultIndex,
        Callback = function(value)
            if loadingControls or os.clock() < (tonumber(fuseState.startupGuardUntil) or 0) then
                return
            end
            local selected
            if type(value) == "number" then
                selected = modeOptions[value]
            elseif type(value) == "table" then
                selected = value[1] or value.Value or value.Name
                if not selected then
                    for option, enabled in pairs(value) do
                        if enabled == true and optionToMode[option] then
                            selected = option
                            break
                        end
                    end
                end
            else
                selected = value
            end
            fuseState.mode = optionToMode[selected] or ""
            fuseState.status = fuseState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshFuseStatus(true)
        end,
    }, "AutoFuseMode")

    fuseState.nameDropdown = fuseUi.Section:Dropdown({
        Name = "Pick to Fuse (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = {},
        Default = {},
        Callback = function(value)
            if loadingControls or fuseState.reordering
                or os.clock() < (tonumber(fuseState.startupGuardUntil) or 0) then
                return
            end
            local selectedNames = {}
            if type(value) == "table" then
                for key, enabled in pairs(value) do
                    local option
                    local active
                    if type(key) == "number" and type(enabled) == "string" then
                        option = enabled
                        active = true
                    else
                        option = key
                        active = enabled == true
                    end
                    local typeId = (fuseState.nameOptionToType or {})[option]
                    if active and typeId then
                        selectedNames[typeId] = true
                    end
                end
            elseif type(value) == "string" then
                local typeId = (fuseState.nameOptionToType or {})[value]
                if typeId then
                    selectedNames[typeId] = true
                end
            end
            fuseState.selectedNames = selectedNames
            fuseState.nameOptionSignature = nil
            fuseState.status = fuseState.enabled and "READY" or "DISABLED"
            saveSettings()
            sharedEnv.ChickenAutoFuseRefreshRarities(true)
            sharedEnv.ChickenAutoFuseRefreshNames(true)
            refreshFuseStatus(true)
        end,
    }, "AutoFuseChickenNames")

    fuseState.rarityDropdown = fuseUi.Section:Dropdown({
        Name = "Rarity to Fuse",
        Search = true,
        Multi = true,
        Required = false,
        Options = rarityOptions,
        Default = (function()
            local options = {}
            for _, rarity in ipairs(selectedRarityKeys()) do
                if rarityKeyToOption[rarity] then
                    table.insert(options, rarityKeyToOption[rarity])
                end
            end
            return options
        end)(),
        Callback = function(value)
            if loadingControls or os.clock() < (tonumber(fuseState.startupGuardUntil) or 0) then
                return
            end
            local selectedRarities = {}
            if type(value) == "table" then
                for key, enabled in pairs(value) do
                    local option
                    local active
                    if type(key) == "number" and type(enabled) == "string" then
                        option = enabled
                        active = true
                    else
                        option = key
                        active = enabled == true
                    end
                    local rarity = rarityOptionToKey[option]
                    if active and rarity then
                        selectedRarities[rarity] = true
                    end
                end
            elseif type(value) == "string" then
                local rarity = rarityOptionToKey[value]
                if rarity then
                    selectedRarities[rarity] = true
                end
            end
            fuseState.rarities = selectedRarities
            syncLegacyRarity()
            fuseState.status = fuseState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshFuseExceptions()
            sharedEnv.ChickenAutoFuseRefreshNames(true)
            refreshFuseStatus(true)
        end,
    }, "AutoFuseRarity")

    exceptionDropdown = fuseUi.Section:Dropdown({
        Name = "Exceptions (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = {},
        Default = {},
        Callback = function(value)
            if loadingControls or fuseState.reordering then
                return
            end
            local selectedIds = {}
            if type(value) == "table" then
                for key, enabled in pairs(value) do
                    local option
                    local active
                    if type(key) == "number" and type(enabled) == "string" then
                        option = enabled
                        active = true
                    else
                        option = key
                        active = enabled == true
                    end
                    local id = exceptionOptionToId[option]
                    if active and id then
                        selectedIds[id] = true
                    end
                end
            end
            fuseState.exceptions = selectedIds
            saveSettings()
            refreshFuseExceptions()
            refreshFuseStatus(true)
        end,
    }, "AutoFuseExceptions")

    fuseUi.Section:Input({
        Name = "Keep Best stat (Mode 2; total)",
        Placeholder = "0-100 total",
        Default = tostring(fuseState.keepBest or 0),
        Callback = function(value)
            if loadingControls then
                return
            end
            local parsed = parseNumberInput(value)
            if parsed then
                fuseState.keepBest = math.clamp(math.floor(parsed), 0, 100)
                saveSettings()
                refreshFuseStatus(true)
            end
        end,
    }, "AutoFuseKeepBest")

    fuseUi.Section:Input({
        Name = "Nickname Tier Up",
        Placeholder = "up (blank = no rename)",
        Default = tostring(fuseState.renameIfUp or ""),
        Callback = function(value)
            if loadingControls then
                return
            end
            local text = tostring(value or "")
                :gsub("^%s+", "")
                :gsub("%s+$", "")
            -- Keep the nickname within the game's normal short-name range.
            if #text > 24 then
                text = text:sub(1, 24)
            end
            fuseState.renameIfUp = text
            saveSettings()
            refreshFuseStatus(true)
        end,
    }, "AutoFuseRenameIfUp")

    fuseUi.Section:Input({
        Name = "Fuse Delay (sec)",
        Placeholder = "0.1-60",
        Default = tostring(fuseState.delay),
        Callback = function(value)
            if loadingControls then
                return
            end
            local parsed = parseNumberInput(value)
            if parsed then
                fuseState.delay = math.clamp(parsed, 0.1, 60)
                saveSettings()
                refreshFuseStatus(true)
            end
        end,
    }, "AutoFuseDelay")

    -- MacLib gives inputs a compact 21px box.  Give text/numeric fields enough
    -- room for their values after the UI mounts, while keeping the right-side
    -- anchor intact.  Tabs mount lazily, so also watch for InputName later.
    local inputWidths = {
        ["Nickname Tier Up"] = 88,
        ["Delay After Rebirth (sec)"] = 64,
        ["Tower Run Duration (sec)"] = 64,
        ["In Coop Duration (sec)"] = 64,
        ["Delay After Defeat (sec)"] = 64,
    }
    local function widenInput(item)
        if not item or not item:IsA("TextLabel") or item.Name ~= "InputName" then
            return
        end
        local width = inputWidths[item.Text]
        if not width then
            return
        end
        local inputBox = item.Parent and item.Parent:FindFirstChild("InputBox")
        if inputBox and inputBox:IsA("TextBox") then
            inputBox.Size = UDim2.fromOffset(width, 21)
            inputBox.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
    sharedEnv.ChickenAutoFuseInputMountConnection = CoreGui.DescendantAdded:Connect(function(item)
        if item:IsA("TextLabel") and item.Name == "InputName" then
            task.defer(function()
                pcall(widenInput, item)
            end)
        end
    end)
    task.delay(0.25, function()
        pcall(function()
            for _, item in ipairs(CoreGui:GetDescendants()) do
                widenInput(item)
                end
        end)
    end)

    -- MacLib may emit a default-selection callback a few frames after a
    -- dropdown is created.  Keep the saved blank/default selection intact
    -- until those mount callbacks finish, then enable user interaction.
    task.delay(0.35, function()
        if sharedEnv.ChickenArenaGeneration ~= generation then
            return
        end
        fuseState.mode = fuseState.startupMode
        fuseState.rarities = fuseState.startupRarities or {}
        fuseState.selectedNames = fuseState.startupNames or {}
        syncLegacyRarity()
        fuseState.startupGuardUntil = 0
        if not fuseState.enabled then
            fuseState.status = "DISABLED"
        elseif (fuseState.mode ~= "rarity" and fuseState.mode ~= "stats"
            and fuseState.mode ~= "sameName")
            or #selectedRarityKeys() == 0 then
            fuseState.status = "SELECT MODE AND RARITY"
        else
            fuseState.status = "READY"
        end
        saveSettings()
        refreshFuseExceptions()
        sharedEnv.ChickenAutoFuseRefreshRarities(true)
        sharedEnv.ChickenAutoFuseRefreshNames(true)
        refreshFuseStatus(true)
    end)

    refreshFuseExceptions()
    sharedEnv.ChickenAutoFuseRefreshRarities(true)
    sharedEnv.ChickenAutoFuseRefreshNames(true)
    refreshFuseStatus(true)

    sharedEnv.ChickenAutoFuseRunCycle = runFuseCycle
    sharedEnv.ChickenAutoFuseRefresh = function()
        refreshFuseExceptions()
        sharedEnv.ChickenAutoFuseRefreshRarities()
        sharedEnv.ChickenAutoFuseRefreshNames()
    end
    sharedEnv.ChickenAutoFuseStatus = refreshFuseStatus
end

-- Auto Promote -------------------------------------------------------------
-- PromoteChicken is the same server-authoritative call used by the game's
-- Flock UI: (targetChickenId, materialChickenIds).  Targets are selected by
-- id, while materials are picked at run time from the same chicken type.  A
-- material is never Favorite, Inverted, active in Coop, or another selected
-- target.  Rarity filters are applied before the request is sent, and the
-- server remains the final authority for every promotion.
(function()
    local promoteUi = sharedEnv.ChickenPromoteUI
    local promoteState = sharedEnv.ChickenPromoteState
    promoteState.startupTargetIds = {}
    for id, enabled in pairs(promoteState.targetIds or {}) do
        if enabled then
            promoteState.startupTargetIds[id] = true
        end
    end
    -- Keep a stable processing order for selected targets.  Saved configs
    -- from before this field existed are completed deterministically by id.
    promoteState.startupTargetOrder = {}
    local startupOrderSeen = {}
    for _, id in ipairs(promoteState.targetOrder or {}) do
        if promoteState.startupTargetIds[id] == true and not startupOrderSeen[id] then
            startupOrderSeen[id] = true
            table.insert(promoteState.startupTargetOrder, id)
        end
    end
    local startupOrderMissing = {}
    for id, enabled in pairs(promoteState.startupTargetIds) do
        if enabled == true and not startupOrderSeen[id] then
            table.insert(startupOrderMissing, id)
        end
    end
    table.sort(startupOrderMissing)
    for _, id in ipairs(startupOrderMissing) do
        startupOrderSeen[id] = true
        table.insert(promoteState.startupTargetOrder, id)
    end
    promoteState.targetOrder = promoteState.startupTargetOrder
    promoteState.startupEggId = promoteState.eggId
    promoteState.startupExcludeRarities = {}
    for rarity, enabled in pairs(promoteState.excludeRarities or {}) do
        if enabled then
            promoteState.startupExcludeRarities[rarity] = true
        end
    end
    promoteState.startupExcludeHigher = promoteState.excludeHigher == true
    promoteState.startupExcludeHigherOrEqual = promoteState.excludeHigherOrEqual == true
    -- Treat the two rarity-boundary toggles as a radio pair.  If an older
    -- settings file contains both values enabled, keep the stricter option.
    if promoteState.excludeHigher and promoteState.excludeHigherOrEqual then
        promoteState.excludeHigher = false
        promoteState.startupExcludeHigher = false
    end
    promoteState.excludeHigherToggle = nil
    promoteState.excludeHigherOrEqualToggle = nil
    promoteState.exclusionSyncing = false

    local promoteCatalog
    local promoteView
    pcall(function()
        promoteCatalog = loadModule(ReplicatedStorage.Content.Catalog)
    end)
    pcall(function()
        promoteView = loadModule(ReplicatedStorage.Features.Chicken.PromotionView)
    end)

    -- Build the egg source picker from the same Catalog/DropTables modules
    -- used by the game's hatching UI.  DropTables.eggPool contains the actual
    -- chicken type ids inside each egg (for example golden = Fortune Egg).
    local promoteEggCatalog = {}
    local promoteEggPools = {}
    pcall(function()
        local catalogData = loadModule(ReplicatedStorage.Content.Catalog) or {}
        promoteEggCatalog = type(catalogData.eggs) == "table" and catalogData.eggs or {}
        if not promoteCatalog then
            promoteCatalog = catalogData
        end
    end)
    pcall(function()
        local dropTables = loadModule(ReplicatedStorage.Content.DropTables) or {}
        promoteEggPools = type(dropTables.eggPool) == "table" and dropTables.eggPool or {}
    end)

    local promoteChickenTypes = promoteCatalog
        and type(promoteCatalog.chickenTypes) == "table"
        and promoteCatalog.chickenTypes or {}
    local promoteEggTypeAliases = {}
    for rawTypeId, typeInfo in pairs(promoteChickenTypes) do
        local typeId = tostring(rawTypeId)
        promoteEggTypeAliases[string.lower(typeId)] = typeId
        if type(typeInfo) == "table" and type(typeInfo.name) == "string" then
            promoteEggTypeAliases[string.lower(typeInfo.name)] = typeId
        end
    end

    local function promoteEggResolveTypeId(value)
        if type(value) == "table" then
            value = value.typeId or value.chickenTypeId or value.chickenId
                or value.chicken or value.id or value.name
        end
        if value == nil then
            return nil
        end
        local text = tostring(value)
        if type(promoteChickenTypes[text]) == "table" then
            return text
        end
        return promoteEggTypeAliases[string.lower(text)]
    end

    local promoteEggTypesById = {}
    local function promoteEggTypeSet(eggId)
        local id = tostring(eggId or "")
        if promoteEggTypesById[id] then
            return promoteEggTypesById[id]
        end
        local result = {}
        local pool = promoteEggPools[id] or promoteEggPools[eggId]
        local visited = {}
        local function visit(node, depth)
            if type(node) ~= "table" or depth > 6 or visited[node] then
                return
            end
            visited[node] = true
            for key, value in pairs(node) do
                local keyTypeId = promoteEggResolveTypeId(key)
                local keyChance = tonumber(value)
                if keyTypeId and (keyChance == nil or keyChance > 0) then
                    result[keyTypeId] = true
                end
                if type(value) == "table" then
                    local valueTypeId = promoteEggResolveTypeId(value)
                    local valueChance = tonumber(value.chance or value.rate
                        or value.weight or value.percent)
                    if valueTypeId and (valueChance == nil or valueChance > 0) then
                        result[valueTypeId] = true
                    end
                    visit(value, depth + 1)
                end
            end
        end
        visit(pool, 0)
        promoteEggTypesById[id] = result
        return result
    end

    local function promoteEggName(eggId)
        local info = promoteEggCatalog[tostring(eggId)] or promoteEggCatalog[eggId]
        if type(info) == "table" and type(info.name) == "string" and info.name ~= "" then
            return info.name
        end
        return tostring(eggId):gsub("(%l)(%u)", "%1 %2")
            :gsub("_", " "):gsub("^%l", string.upper)
    end

    local promoteEggOptionToId = {}
    local promoteEggIdToOption = {}
    local promoteEggOptions = {"(Manual targets)"}
    promoteEggOptionToId[promoteEggOptions[1]] = ""
    local promoteEggIds = {}
    for rawId in pairs(promoteEggCatalog) do
        promoteEggIds[tostring(rawId)] = true
    end
    for rawId in pairs(promoteEggPools) do
        promoteEggIds[tostring(rawId)] = true
    end
    local promoteEggRows = {}
    for eggId in pairs(promoteEggIds) do
        if next(promoteEggTypeSet(eggId)) ~= nil then
            table.insert(promoteEggRows, {id = eggId, name = promoteEggName(eggId)})
        end
    end
    table.sort(promoteEggRows, function(a, b)
        local nameA = string.lower(a.name)
        local nameB = string.lower(b.name)
        if nameA ~= nameB then
            return nameA < nameB
        end
        return a.id < b.id
    end)
    for _, row in ipairs(promoteEggRows) do
        local option = row.name
        if promoteEggOptionToId[option] then
            option = option .. " [" .. row.id .. "]"
        end
        promoteEggOptionToId[option] = row.id
        promoteEggIdToOption[row.id] = option
        table.insert(promoteEggOptions, option)
    end
    promoteState.eggOptions = promoteEggOptions
    promoteState.eggOptionToId = promoteEggOptionToId
    promoteState.eggIdToOption = promoteEggIdToOption
    if promoteState.eggId and not promoteEggIdToOption[promoteState.eggId] then
        promoteState.eggId = nil
    end
    promoteState.startupEggId = promoteState.eggId
    promoteState.startupExcludeChickenTypes = {}
    for typeId, enabled in pairs(promoteState.excludeChickenTypes or {}) do
        if type(enabled) == "boolean" and enabled == true
            and type(typeId) == "string" and typeId ~= "" then
            promoteState.startupExcludeChickenTypes[typeId] = true
        end
    end

    local fallbackRarityKeys = {
        "common", "uncommon", "rare", "epic", "legendary", "mythic",
        "divine", "celestial", "cosmic", "secret",
    }
    local promoteRarityRows = {}
    local promoteRarityRank = {}
    local catalogRanks = promoteCatalog
        and promoteCatalog.rarity
        and promoteCatalog.rarity.rank
    if type(catalogRanks) == "table" then
        for rarity, rank in pairs(catalogRanks) do
            if type(rarity) == "string" then
                local key = string.lower(rarity)
                promoteRarityRank[key] = tonumber(rank) or 999
            end
        end
    end
    for index, rarity in ipairs(fallbackRarityKeys) do
        if promoteRarityRank[rarity] == nil then
            promoteRarityRank[rarity] = index
        end
    end
    for rarity, rank in pairs(promoteRarityRank) do
        table.insert(promoteRarityRows, {key = rarity, rank = rank})
    end
    table.sort(promoteRarityRows, function(a, b)
        if a.rank == b.rank then
            return a.key < b.key
        end
        return a.rank < b.rank
    end)
    local promoteRarityOptions = {}
    local promoteRarityOptionToKey = {}
    local promoteRarityKeyToOption = {}
    for _, row in ipairs(promoteRarityRows) do
        local option = string.upper(row.key:sub(1, 1)) .. row.key:sub(2)
        promoteRarityKeyToOption[row.key] = option
        promoteRarityOptionToKey[option] = row.key
        table.insert(promoteRarityOptions, option)
    end
    promoteState.rarityOptionToKey = promoteRarityOptionToKey
    promoteState.rarityKeyToOption = promoteRarityKeyToOption

    local promoteBodyLabel
    local promoteBodyLastScanAt = 0

    local function promoteRoster()
        local ok, data = pcall(function()
            return DataService.client:get({"roster"}) or {}
        end)
        if not ok or type(data) ~= "table" or type(data.chickens) ~= "table" then
            return nil, "ROSTER UNAVAILABLE"
        end
        return data, nil
    end

    local function promoteChickenRarity(chicken)
        if type(chicken) ~= "table" then
            return nil
        end
        if type(chicken.rarity) == "string" and chicken.rarity ~= "" then
            return string.lower(chicken.rarity)
        end
        local typeInfo = promoteCatalog
            and promoteCatalog.chickenTypes
            and promoteCatalog.chickenTypes[chicken.typeId]
        if type(typeInfo) == "table" and type(typeInfo.rarity) == "string" then
            return string.lower(typeInfo.rarity)
        end
        return nil
    end

    local function promoteChickenName(chicken)
        if type(chicken) ~= "table" then
            return "Chicken"
        end
        if type(chicken.nickname) == "string" and chicken.nickname ~= "" then
            return chicken.nickname
        end
        local typeId = tostring(chicken.typeId or "Chicken")
        local typeInfo = promoteCatalog
            and promoteCatalog.chickenTypes
            and promoteCatalog.chickenTypes[typeId]
        if type(typeInfo) == "table" and type(typeInfo.name) == "string"
            and typeInfo.name ~= "" then
            return typeInfo.name
        end
        return typeId:gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
    end

    local function promoteIsInverted(chicken)
        if type(chicken) ~= "table" then
            return false
        end
        if chicken.inverted == true or chicken.isInverted == true then
            return true
        end
        local mutation = chicken.mutation
        if type(mutation) == "string" then
            return mutation:lower() == "inverted"
        end
        if type(mutation) == "table" then
            if tostring(mutation.id or ""):lower() == "inverted"
                or tostring(mutation.name or ""):lower() == "inverted" then
                return true
            end
        end
        for _, key in ipairs({"mutations", "mutationIds", "mutationList"}) do
            local list = chicken[key]
            if type(list) == "table" then
                for listKey, value in pairs(list) do
                    if (type(listKey) == "string" and listKey:lower() == "inverted")
                        or (type(value) == "string" and value:lower() == "inverted")
                        or (type(value) == "table"
                            and (tostring(value.id or ""):lower() == "inverted"
                                or tostring(value.name or ""):lower() == "inverted")) then
                        return true
                    end
                end
            end
        end
        return false
    end

    local function promoteTargetAtCap(chicken)
        -- The game promotion system caps at ten stars.  Reading the replicated
        -- promo field directly avoids invoking PromotionView once per roster
        -- chicken on every Auto Promote tick.
        return math.floor(tonumber(chicken and chicken.promo) or 0) >= 10
    end

    -- Egg-source mode deliberately chooses a priority tier instead of
    -- targeting every zero-star chicken at once:
    --   1) all non-capped Inverted chickens in the egg,
    --   2) otherwise all non-capped chickens that already have stars,
    --   3) otherwise ordered non-capped plain chickens as starter candidates;
    --      runPromoteCycle tries the next one when the first has no materials.
    -- runPromoteCycle can request the next tier when every target in the
    -- current tier is temporarily unavailable (for example, Keep Count has
    -- reserved all of its safe materials).
    local function promoteEggTargetRows(roster, requestedStage)
        local eggId = promoteState.eggId
        if type(eggId) ~= "string" or eggId == "" then
            return nil, nil
        end
        local allowedTypes = promoteEggTypeSet(eggId)
        local inverted = {}
        local starred = {}
        local plain = {}
        for _, chicken in ipairs(roster and roster.chickens or {}) do
            if type(chicken) == "table" and type(chicken.id) == "string"
                and type(chicken.typeId) == "string"
                and allowedTypes[chicken.typeId] == true
                and (promoteState.excludeChickenTypes or {})[chicken.typeId] ~= true
                and not promoteTargetAtCap(chicken) then
                local promo = math.max(0, math.floor(tonumber(chicken.promo) or 0))
                local row = {chicken = chicken, promo = promo,
                    dupes = math.max(0, math.floor(tonumber(chicken.promoDupes) or 0))}
                if promoteIsInverted(chicken) then
                    table.insert(inverted, row)
                elseif promo > 0 then
                    table.insert(starred, row)
                else
                    table.insert(plain, row)
                end
            end
        end
        local function sortPriority(a, b)
            if a.promo ~= b.promo then
                return a.promo > b.promo
            end
            if a.dupes ~= b.dupes then
                return a.dupes > b.dupes
            end
            local nameA = string.lower(promoteChickenName(a.chicken))
            local nameB = string.lower(promoteChickenName(b.chicken))
            if nameA ~= nameB then
                return nameA < nameB
            end
            return tostring(a.chicken.id) < tostring(b.chicken.id)
        end
        table.sort(inverted, sortPriority)
        table.sort(starred, sortPriority)
        table.sort(plain, sortPriority)
        local groups = {inverted, starred, plain}
        local chosenRows = {}
        local selectedStage
        if requestedStage ~= nil then
            selectedStage = math.clamp(math.floor(tonumber(requestedStage) or 1), 1, 3)
            if selectedStage == 3 then
                chosenRows = plain
            else
                chosenRows = groups[selectedStage] or {}
            end
        else
            for stage, group in ipairs(groups) do
                if #group > 0 then
                    selectedStage = stage
                    chosenRows = group
                    break
                end
            end
        end
        local targets = {}
        local rows = {}
        for _, row in ipairs(chosenRows) do
            targets[row.chicken.id] = true
            table.insert(rows, row.chicken)
        end
        -- Plain egg candidates are tried one at a time.  Reserve only the
        -- first candidate so that later candidates of the same type remain
        -- usable as materials if that first target is skipped.
        if selectedStage == 3 and #rows > 1 then
            targets = {[rows[1].id] = true}
        end
        return rows, targets, selectedStage
    end

    local promoteRarityAbbreviations = {
        common = "COM",
        uncommon = "UNC",
        rare = "RAR",
        epic = "EPI",
        legendary = "LEG",
        mythic = "MYT",
        divine = "DIV",
        celestial = "CEL",
        cosmic = "COS",
        secret = "SEC",
    }

    local function promoteChickenOptionBase(chicken)
        local name = promoteChickenName(chicken)
        local rarityKey = promoteChickenRarity(chicken) or "unknown"
        local rarity = promoteRarityAbbreviations[rarityKey]
            or string.upper(rarityKey:sub(1, 3))
        local stars = math.max(0, math.floor(tonumber(chicken and chicken.promo) or 0))
        local prefixParts = {}
        if stars > 0 then
            table.insert(prefixParts, tostring(stars) .. "*")
        end
        -- Keep protected mutations visible in compact form so duplicate names
        -- can be distinguished without the picker truncating the label.
        if promoteIsInverted(chicken) then
            table.insert(prefixParts, "[inv]")
        end
        if chicken and chicken.favorite == true then
            table.insert(prefixParts, "[fav]")
        end
        table.insert(prefixParts, "[" .. rarity .. "]")
        local prefix = #prefixParts > 0 and (table.concat(prefixParts, " ") .. " ") or ""
        return prefix .. name
    end

    local function promoteSelectedOptionSet(value, optionToId)
        local selected = {}
        if type(value) == "table" then
            for key, enabled in pairs(value) do
                local option
                local active
                if type(key) == "number" and type(enabled) == "string" then
                    option = enabled
                    active = true
                else
                    option = key
                    active = enabled == true
                end
                local id = optionToId and optionToId[option]
                if active and id then
                    selected[id] = true
                end
            end
        elseif type(value) == "string" then
            local id = optionToId and optionToId[value]
            if id then
                selected[id] = true
            end
        end
        return selected
    end

    -- Dropdown callbacks can provide either an ordered array of options or a
    -- map of option -> enabled.  Preserve the previous order first, then add
    -- newly selected options in callback order; this keeps click order stable
    -- even when MacLib sends the full selection again after each click.
    local function promoteSelectedOptionSelection(value, optionToId, previousOrder)
        local selected = promoteSelectedOptionSet(value, optionToId)
        local incomingOrder = {}
        local incomingSeen = {}
        local function remember(option)
            local id = optionToId and optionToId[option]
            if id and selected[id] == true and not incomingSeen[id] then
                incomingSeen[id] = true
                table.insert(incomingOrder, id)
            end
        end
        if type(value) == "table" then
            -- Arrays carry the only reliable order when multiple options are
            -- selected at once.
            for _, entry in ipairs(value) do
                if type(entry) == "string" then
                    remember(entry)
                end
            end
            -- Also support MacLib's map form.  Existing ids are already
            -- ordered from previousOrder; new ids are completed below.
            for key, enabled in pairs(value) do
                if type(key) == "number" and type(enabled) == "string" then
                    remember(enabled)
                elseif enabled == true then
                    remember(key)
                end
            end
        elseif type(value) == "string" then
            remember(value)
        end

        local order = {}
        local seen = {}
        local function append(id)
            if selected[id] == true and not seen[id] then
                seen[id] = true
                table.insert(order, id)
            end
        end
        for _, id in ipairs(previousOrder or {}) do
            append(id)
        end
        for _, id in ipairs(incomingOrder) do
            append(id)
        end
        -- A map has no guaranteed iteration order.  Any still-unordered
        -- selections are appended deterministically so they remain stable
        -- after saving/reloading the script.
        local leftovers = {}
        for id, enabled in pairs(selected) do
            if enabled == true and not seen[id] then
                table.insert(leftovers, id)
            end
        end
        table.sort(leftovers)
        for _, id in ipairs(leftovers) do
            append(id)
        end
        return selected, order
    end

    local function updatePromoteParagraph(body)
        local direct = false
        if promoteBodyLabel and promoteBodyLabel.Parent then
            direct = pcall(function()
                promoteBodyLabel.Text = body
            end)
        elseif os.clock() - promoteBodyLastScanAt >= 5 then
            promoteBodyLastScanAt = os.clock()
            pcall(function()
                for _, item in ipairs(CoreGui:GetDescendants()) do
                    if item:IsA("TextLabel") and item.Text == "Auto Promote Status" then
                        local label = item.Parent and item.Parent:FindFirstChild("ParagraphBody")
                        if label and label:IsA("TextLabel") then
                            promoteBodyLabel = label
                            label.Text = body
                            direct = true
                            break
                        end
                    end
                end
            end)
        end
        if not direct then
            pcall(function()
                promoteUi.InfoParagraph:UpdateBody(body)
            end)
        end
    end

    local function selectedPromoteTargets(roster, eggStage)
        local rows = {}
        local targets = promoteState.targetIds or {}
        if type(promoteState.eggId) == "string" and promoteState.eggId ~= "" then
            local eggRows, eggTargets, selectedStage = promoteEggTargetRows(roster, eggStage)
            promoteState.activeTargetIds = eggTargets or {}
            return eggRows or {}, selectedStage or eggStage or 0
        end
        promoteState.activeTargetIds = targets
        local orderIndex = {}
        for index, id in ipairs(promoteState.targetOrder or {}) do
            if type(id) == "string" and orderIndex[id] == nil then
                orderIndex[id] = index
            end
        end
        for _, chicken in ipairs(roster and roster.chickens or {}) do
            if type(chicken) == "table" and type(chicken.id) == "string"
                and targets[chicken.id] == true
                and (type(chicken.typeId) ~= "string"
                    or (promoteState.excludeChickenTypes or {})[chicken.typeId] ~= true) then
                table.insert(rows, chicken)
            end
        end
        table.sort(rows, function(a, b)
            local orderA = orderIndex[a.id] or math.huge
            local orderB = orderIndex[b.id] or math.huge
            if orderA ~= orderB then
                return orderA < orderB
            end
            local rarityA = promoteChickenRarity(a) or ""
            local rarityB = promoteChickenRarity(b) or ""
            local rankA = tonumber(promoteRarityRank[rarityA]) or 999
            local rankB = tonumber(promoteRarityRank[rarityB]) or 999
            if rankA ~= rankB then
                return rankA > rankB
            end
            local nameA = string.lower(promoteChickenName(a))
            local nameB = string.lower(promoteChickenName(b))
            if nameA ~= nameB then
                return nameA < nameB
            end
            return tostring(a.id) < tostring(b.id)
        end)
        return rows, 0
    end

    local function rarityBoundaryAllows(materialRarity, targetRarity)
        local materialRank = tonumber(promoteRarityRank[materialRarity])
        local targetRank = tonumber(promoteRarityRank[targetRarity])
        if not materialRank or not targetRank then
            return true
        end
        -- If both toggles are on, the >= boundary is intentionally stricter
        -- and wins.  With only the > toggle on, equal rarity remains allowed.
        if promoteState.excludeHigherOrEqual == true then
            return materialRank < targetRank
        end
        if promoteState.excludeHigher == true then
            return materialRank <= targetRank
        end
        return true
    end

    local function promoteMaterialAllowed(material, target, roster, keepProtectedIds)
        if type(material) ~= "table" or type(target) ~= "table"
            or material.id == target.id then
            return false
        end
        if type(material.id) ~= "string"
            or tostring(material.typeId or "") ~= tostring(target.typeId or "") then
            return false
        end
        if (promoteState.excludeChickenTypes or {})[tostring(material.typeId or "")] == true then
            return false
        end
        if material.favorite == true or promoteIsInverted(material) then
            return false
        end
        if roster and roster.activeId == material.id then
            return false
        end
        -- A chicken selected as a future target is reserved, even when it
        -- would otherwise satisfy the rarity/type filters.
        local activeTargetIds = promoteState.activeTargetIds or promoteState.targetIds or {}
        if activeTargetIds[material.id] == true then
            return false
        end
        if keepProtectedIds and keepProtectedIds[material.id] == true then
            return false
        end
        local rarity = promoteChickenRarity(material)
        local targetRarity = promoteChickenRarity(target)
        if rarity and (promoteState.excludeRarities or {})[rarity] == true then
            return false
        end
        if rarity and targetRarity and not rarityBoundaryAllows(rarity, targetRarity) then
            return false
        end
        return true
    end

    -- Reserve a configurable number of additional, otherwise-usable chickens
    -- of the current target type before choosing promotion materials.  Selected
    -- targets are deliberately excluded from this count because they are
    -- already protected separately.
    local function promoteKeepProtectedIds(target, roster)
        local keepCount = math.clamp(
            math.floor(tonumber(promoteState.keepCount) or 0),
            0,
            100
        )
        local protected = {}
        if keepCount <= 0 then
            promoteState.keepProtectedCount = 0
            return protected
        end
        local candidates = {}
        for _, chicken in ipairs(roster and roster.chickens or {}) do
            if promoteMaterialAllowed(chicken, target, roster, nil) then
                table.insert(candidates, chicken)
            end
        end
        table.sort(candidates, function(a, b)
            local rarityA = promoteChickenRarity(a) or ""
            local rarityB = promoteChickenRarity(b) or ""
            local rankA = tonumber(promoteRarityRank[rarityA]) or 999
            local rankB = tonumber(promoteRarityRank[rarityB]) or 999
            if rankA ~= rankB then
                return rankA > rankB
            end
            local promoA = tonumber(a.promo) or 0
            local promoB = tonumber(b.promo) or 0
            if promoA ~= promoB then
                return promoA > promoB
            end
            local levelA = tonumber(a.level) or 1
            local levelB = tonumber(b.level) or 1
            if levelA ~= levelB then
                return levelA > levelB
            end
            return tostring(a.id) < tostring(b.id)
        end)
        local limit = math.min(keepCount, #candidates)
        for index = 1, limit do
            protected[candidates[index].id] = true
        end
        promoteState.keepProtectedCount = limit
        return protected
    end

    local function promotionProgress(target)
        if promoteView and type(promoteView.progress) == "function" then
            local ok, progress = pcall(promoteView.progress, target)
            if ok and type(progress) == "table" then
                return progress
            end
        end
        local promo = math.max(0, math.floor(tonumber(target and target.promo) or 0))
        return {
            stars = promo,
            dupes = math.max(0, math.floor(tonumber(target and target.promoDupes) or 0)),
            need = 1,
            atCap = promo >= 10,
        }
    end

    local function choosePromoteMaterials(target, roster)
        local progress = promotionProgress(target)
        if progress.atCap then
            return nil, "MAX PROMOTION", progress, 0
        end
        local need = tonumber(progress.need)
        if not need or need < 1 then
            return nil, "NO REQUIREMENT", progress, 0
        end
        need = math.floor(need)
        local keepProtectedIds = promoteKeepProtectedIds(target, roster)
        local candidates = {}
        for _, chicken in ipairs(roster.chickens or {}) do
            if promoteMaterialAllowed(chicken, target, roster, keepProtectedIds) then
                table.insert(candidates, chicken)
            end
        end
        local targetRarity = promoteChickenRarity(target) or ""
        local targetRank = tonumber(promoteRarityRank[targetRarity]) or 999
        table.sort(candidates, function(a, b)
            local rarityA = promoteChickenRarity(a) or ""
            local rarityB = promoteChickenRarity(b) or ""
            local rankA = tonumber(promoteRarityRank[rarityA]) or 999
            local rankB = tonumber(promoteRarityRank[rarityB]) or 999
            -- Use the highest allowed material rarity first, but never let a
            -- same/higher rarity leapfrog a lower rarity under the boundary.
            local distanceA = math.abs(targetRank - rankA)
            local distanceB = math.abs(targetRank - rankB)
            if distanceA ~= distanceB then
                return distanceA < distanceB
            end
            local promoA = tonumber(a.promo) or 0
            local promoB = tonumber(b.promo) or 0
            if promoA ~= promoB then
                return promoA < promoB
            end
            local levelA = tonumber(a.level) or 1
            local levelB = tonumber(b.level) or 1
            if levelA ~= levelB then
                return levelA < levelB
            end
            return tostring(a.id) < tostring(b.id)
        end)
        if #candidates == 0 then
            return nil, "NO SAFE MATERIAL", progress, 0
        end
        local ids = {}
        -- The game's PromoteChicken flow accepts partial material batches and
        -- carries the remainder in promoDupes.  Send every safe candidate
        -- beyond Keep Count so a target can advance as far as the available
        -- materials allow, even when this batch is smaller than Req.
        for index = 1, #candidates do
            table.insert(ids, candidates[index].id)
        end
        return ids, nil, progress, #candidates
    end

    local function promoteStatusBody()
        local selectedCount = 0
        for _, enabled in pairs(promoteState.targetIds or {}) do
            if enabled then
                selectedCount += 1
            end
        end
        local sourceText = "MANUAL TARGETS"
        if type(promoteState.eggId) == "string" and promoteState.eggId ~= "" then
            sourceText = promoteEggName(promoteState.eggId)
        end
        local excluded = {}
        for _, row in ipairs(promoteRarityRows) do
            if (promoteState.excludeRarities or {})[row.key] == true then
                table.insert(excluded, row.key)
            end
        end
        local excludeText = #excluded > 0 and table.concat(excluded, ", ") or "NONE"
        local excludedChickenCount = 0
        for _, enabled in pairs(promoteState.excludeChickenTypes or {}) do
            if enabled == true then
                excludedChickenCount += 1
            end
        end
        local boundaryText
        if promoteState.excludeHigherOrEqual == true then
            boundaryText = ">= TARGET (ON)"
        elseif promoteState.excludeHigher == true then
            boundaryText = "> TARGET (ON)"
        else
            boundaryText = "OFF"
        end
        local cooldown = math.max(0, (tonumber(promoteState.lastActionAt) or 0)
            + (tonumber(promoteState.delay) or 1) - os.clock())
        local cooldownText = cooldown > 0 and ("COOLDOWN " .. string.format("%.1fs", cooldown)) or "READY"
        local autoText = promoteState.enabled == true and "ON" or "OFF"
        local targetText = type(promoteState.eggId) == "string"
            and promoteState.eggId ~= "" and "AUTO (egg priority)"
            or tostring(selectedCount) .. " selected"
        local keepCount = math.clamp(
            math.floor(tonumber(promoteState.keepCount) or 0),
            0,
            100
        )
        return "Auto Promote: " .. autoText
            .. "\nSource egg: " .. sourceText
            .. "\nTargets: " .. targetText
            .. "\nKeep: " .. tostring(keepCount) .. " per target type (targets not counted)"
            .. "\nExclude Chicken: " .. tostring(excludedChickenCount) .. " type(s)"
            .. "\nExclude Rarity: " .. excludeText
            .. "\nRarity boundary: " .. boundaryText
            .. "\nStatus: " .. tostring(promoteState.status or "IDLE")
            .. "\nNext action: " .. cooldownText
            .. "\nLast: " .. tostring(promoteState.lastResult or "—")
            .. "\nProtected materials: ⭐ Favorite + Inverted + active Coop + selected targets"
    end

    local function refreshPromoteStatus(force)
        if force or os.clock() - (promoteState.lastStatusAt or 0) >= 0.5 then
            promoteState.lastStatusAt = os.clock()
            updatePromoteParagraph(promoteStatusBody())
        end
    end

    local eggDropdown
    local excludeChickenDropdown
    local targetDropdown
    local rarityDropdown

    -- MacLib leaves 15px of horizontal padding inside each dropdown.  The
    -- Promote picker needs a little more room for status markers such as
    -- "[INVERTED]"; reduce only this picker’s padding so its option text is
    -- not replaced by an ellipsis while keeping the surrounding column size.
    local function widenPromoteTargetPicker()
        for _, item in ipairs(CoreGui:GetDescendants()) do
            if item:IsA("TextLabel")
                and string.find(item.Text or "", "Pick Chicken to Promote", 1, true) then
                local dropdown = item.Parent
                local padding = dropdown and dropdown:FindFirstChild("DropdownUIPadding")
                if padding and padding:IsA("UIPadding") then
                    padding.PaddingLeft = UDim.new(0, 5)
                    padding.PaddingRight = UDim.new(0, 5)
                end
                return
            end
        end
    end

    local function refreshPromoteEggDropdown(force)
        if not eggDropdown then
            return
        end
        local options = promoteState.eggOptions or promoteEggOptions
        local selectedOption = promoteState.eggId
            and (promoteState.eggIdToOption or promoteEggIdToOption)[promoteState.eggId]
            or options[1]
        local signature = table.concat(options, "\31") .. "\30" .. tostring(selectedOption or "")
        if not force and promoteState.eggOptionSignature == signature then
            return
        end
        promoteState.eggOptionSignature = signature
        promoteState.reordering = true
        pcall(function()
            eggDropdown:ClearOptions()
            eggDropdown:InsertOptions(options)
            eggDropdown:UpdateSelection(selectedOption and {selectedOption} or {})
            eggDropdown:UpdateName(promoteState.eggId
                and ("Promote from Egg • " .. promoteEggName(promoteState.eggId))
                or "Promote from Egg (Manual)")
        end)
        promoteState.reordering = false
    end

    local function rebuildPromoteExcludeChickenOptions(roster)
        local typeIds = {}
        local allowedEggTypes
        local selectedEggId = promoteState.eggId
        if type(selectedEggId) == "string" and selectedEggId ~= "" then
            local eggTypes = promoteEggTypeSet(selectedEggId)
            if next(eggTypes) ~= nil then
                allowedEggTypes = eggTypes
                -- When an egg is selected, expose the complete hatch pool,
                -- including types that are not currently owned yet.
                for typeId in pairs(allowedEggTypes) do
                    typeIds[typeId] = true
                end
            end
        end
        for _, chicken in ipairs(roster and roster.chickens or {}) do
            local typeId = type(chicken) == "table" and chicken.typeId or nil
            if type(typeId) == "string" and typeId ~= ""
                and (not allowedEggTypes or allowedEggTypes[typeId] == true) then
                typeIds[typeId] = true
            end
        end
        -- Keep saved exclusions visible even when that type is temporarily
        -- absent from the current roster, so a reload cannot silently clear it.
        for typeId, enabled in pairs(promoteState.excludeChickenTypes or {}) do
            if enabled == true and type(typeId) == "string" and typeId ~= ""
                and (not allowedEggTypes or allowedEggTypes[typeId] == true) then
                typeIds[typeId] = true
            end
        end

        local rows = {}
        for typeId in pairs(typeIds) do
            local chicken = {typeId = typeId}
            local name = promoteChickenName(chicken)
            local rarity = promoteChickenRarity(chicken) or "unknown"
            local abbreviation = promoteRarityAbbreviations[rarity]
                or string.upper(rarity:sub(1, 3))
            table.insert(rows, {
                typeId = typeId,
                name = name,
                rarity = rarity,
                selected = (promoteState.excludeChickenTypes or {})[typeId] == true,
                label = name .. " [" .. abbreviation .. "]",
            })
        end
        table.sort(rows, function(a, b)
            if a.selected ~= b.selected then
                return a.selected
            end
            local rankA = tonumber(promoteRarityRank[a.rarity]) or 999
            local rankB = tonumber(promoteRarityRank[b.rarity]) or 999
            if rankA ~= rankB then
                return rankA > rankB
            end
            local nameA = string.lower(a.name)
            local nameB = string.lower(b.name)
            if nameA ~= nameB then
                return nameA < nameB
            end
            return a.typeId < b.typeId
        end)

        local options = {}
        local optionToType = {}
        local typeToOption = {}
        local labelCounts = {}
        for _, row in ipairs(rows) do
            labelCounts[row.label] = (labelCounts[row.label] or 0) + 1
        end
        local selected = {}
        for _, row in ipairs(rows) do
            local option = row.label
            if (labelCounts[option] or 0) > 1 then
                option = option .. " (" .. row.typeId .. ")"
            end
            optionToType[option] = row.typeId
            typeToOption[row.typeId] = option
            table.insert(options, option)
            if row.selected then
                table.insert(selected, option)
            end
        end
        promoteState.excludeChickenOptions = options
        promoteState.excludeChickenOptionToType = optionToType
        promoteState.excludeChickenTypeToOption = typeToOption
        return options, selected
    end

    local function refreshPromoteExcludeChickenDropdown(force)
        local roster = select(1, promoteRoster())
        local options, selected = rebuildPromoteExcludeChickenOptions(roster)
        if not excludeChickenDropdown then
            return
        end
        local signature = table.concat(options, "\31") .. "\30"
            .. table.concat(selected, "\31")
        if not force and promoteState.excludeChickenOptionSignature == signature then
            return
        end
        promoteState.excludeChickenOptionSignature = signature
        promoteState.reordering = true
        pcall(function()
            excludeChickenDropdown:ClearOptions()
            excludeChickenDropdown:InsertOptions(options)
            excludeChickenDropdown:UpdateSelection(selected)
            excludeChickenDropdown:UpdateName("Exclude Chicken (" .. tostring(#selected) .. ")")
        end)
        promoteState.reordering = false
    end

    local function refreshPromoteRarityDropdown(force)
        if not rarityDropdown then
            return
        end
        local options = {}
        for _, row in ipairs(promoteRarityRows) do
            table.insert(options, promoteRarityKeyToOption[row.key])
        end
        local selected = {}
        for _, row in ipairs(promoteRarityRows) do
            if (promoteState.excludeRarities or {})[row.key] == true then
                table.insert(selected, promoteRarityKeyToOption[row.key])
            end
        end
        local signature = table.concat(options, "\31") .. "\30" .. table.concat(selected, "\31")
        if not force and promoteState.rarityOptionSignature == signature then
            return
        end
        promoteState.rarityOptionSignature = signature
        promoteState.reordering = true
        pcall(function()
            rarityDropdown:ClearOptions()
            rarityDropdown:InsertOptions(options)
            rarityDropdown:UpdateSelection(selected)
            rarityDropdown:UpdateName("Exclude Rarity (" .. tostring(#selected) .. ")")
        end)
        promoteState.reordering = false
    end

    local function refreshPromoteTargetDropdown(force)
        if not targetDropdown then
            return
        end
        widenPromoteTargetPicker()
        local roster = select(1, promoteRoster())
        if not roster then
            return
        end
        local rows = {}
        local seen = {}
        local counts = {}
        local orderIndex = {}
        for index, id in ipairs(promoteState.targetOrder or {}) do
            if type(id) == "string" and orderIndex[id] == nil then
                orderIndex[id] = index
            end
        end
        for _, chicken in ipairs(roster.chickens or {}) do
            if type(chicken) == "table" and type(chicken.id) == "string" then
                local base = promoteChickenOptionBase(chicken)
                counts[base] = (counts[base] or 0) + 1
                table.insert(rows, {
                    chicken = chicken,
                    base = base,
                    selected = (promoteState.targetIds or {})[chicken.id] == true
                        and (type(chicken.typeId) ~= "string"
                            or (promoteState.excludeChickenTypes or {})[chicken.typeId] ~= true),
                    order = orderIndex[chicken.id] or math.huge,
                })
            end
        end
        table.sort(rows, function(a, b)
            if a.selected ~= b.selected then
                return a.selected
            end
            if a.selected and b.selected and a.order ~= b.order then
                return a.order < b.order
            end
            local ca, cb = a.chicken, b.chicken
            local ra = tonumber(promoteRarityRank[promoteChickenRarity(ca) or ""]) or 999
            local rb = tonumber(promoteRarityRank[promoteChickenRarity(cb) or ""]) or 999
            if ra ~= rb then
                return ra > rb
            end
            local na = string.lower(a.base)
            local nb = string.lower(b.base)
            if na ~= nb then
                return na < nb
            end
            return tostring(ca.id) < tostring(cb.id)
        end)
        promoteState.targetOptionToId = {}
        promoteState.targetIdToOption = {}
        local options = {}
        local selected = {}
        for _, row in ipairs(rows) do
            local chicken = row.chicken
            seen[row.base] = (seen[row.base] or 0) + 1
            local suffix = (counts[row.base] or 0) > 1
                and (" #" .. tostring(seen[row.base])) or ""
            local option = row.base .. suffix
            promoteState.targetOptionToId[option] = chicken.id
            promoteState.targetIdToOption[chicken.id] = option
            table.insert(options, option)
            if row.selected then
                table.insert(selected, option)
            end
        end
        local signature = table.concat(options, "\31") .. "\30" .. table.concat(selected, "\31")
        if not force and promoteState.targetOptionSignature == signature then
            return
        end
        promoteState.targetOptionSignature = signature
        promoteState.reordering = true
        pcall(function()
            targetDropdown:ClearOptions()
            targetDropdown:InsertOptions(options)
            targetDropdown:UpdateSelection(selected)
            targetDropdown:UpdateName("Pick Chicken to Promote (" .. tostring(#selected) .. ")")
        end)
        promoteState.reordering = false
        widenPromoteTargetPicker()
    end

    local function runPromoteCycle(force)
        if not force and promoteState.enabled ~= true then
            return false
        end
        if promoteState.busy then
            return false
        end
        local remaining = (tonumber(promoteState.lastActionAt) or 0)
            + (tonumber(promoteState.delay) or 1) - os.clock()
        if remaining > 0 then
            promoteState.status = "WAITING FOR DELAY"
            refreshPromoteStatus(false)
            return false
        end
        local roster, rosterError = promoteRoster()
        if not roster then
            promoteState.status = rosterError or "ROSTER UNAVAILABLE"
            refreshPromoteStatus(false)
            return false
        end
        local targets, primaryStage = selectedPromoteTargets(roster)
        if #targets == 0 then
            promoteState.status = promoteState.eggId
                and "NO MATCHING CHICKEN FROM EGG" or "SELECT TARGET CHICKENS"
            refreshPromoteStatus(false)
            return false
        end
        if type(sharedEnv.ChickenAutoFuseState) == "table"
            and sharedEnv.ChickenAutoFuseState.busy == true then
            promoteState.status = "WAITING FOR FUSE"
            refreshPromoteStatus(false)
            return false
        end
        local function tryPromoteTargets(targetList)
            local lastReason = "NO SAFE MATERIAL"
            for _, target in ipairs(targetList) do
                if roster.activeId == target.id then
                    lastReason = "TARGET ACTIVE: " .. promoteChickenName(target)
                else
                    local ids, reason, progress, safeCount = choosePromoteMaterials(target, roster)
                    if ids then
                        promoteState.busy = true
                        promoteState.lastTargetId = target.id
                        promoteState.status = "PROMOTING " .. promoteChickenName(target)
                        refreshPromoteStatus(true)
                        local ok, response = invokeRemoteWithTimeout(
                            sharedEnv.ChickenPromoteRemote,
                            8,
                            target.id,
                            ids
                        )
                        promoteState.busy = false
                        promoteState.lastActionAt = os.clock()
                        if ok and type(response) == "table" and response.ok == true then
                            local starText = progress and tostring(progress.stars or 0) or "?"
                            promoteState.status = "PROMOTED " .. promoteChickenName(target)
                            promoteState.lastResult = promoteChickenName(target)
                                .. " · " .. tostring(#ids) .. " material(s) · tier " .. starText
                            refreshPromoteStatus(true)
                            return true, nil, false
                        end
                        local errorText = type(response) == "table"
                            and tostring(response.error or "REJECTED") or tostring(response or "TIMEOUT")
                        promoteState.status = "PROMOTE ERROR: " .. errorText
                        promoteState.lastResult = promoteState.status
                        refreshPromoteStatus(true)
                        -- A server rejection is not a target-readiness issue;
                        -- stop instead of trying to spend another target.
                        return false, promoteState.status, true
                    end
                    lastReason = reason
                        or ("NEED SAFE MATERIAL (" .. tostring(safeCount or 0) .. ")")
                end
            end
            return false, lastReason, false
        end

        local promoted, lastReason, hardError = tryPromoteTargets(targets)
        if promoted or hardError then
            return promoted
        end
        -- Egg mode falls through to the next priority tier only after every
        -- target in the current tier was skipped as not ready.  This keeps
        -- Inverted first, but lets a ready Golden Goose/Baron Cluck proceed
        -- instead of making the whole controller appear stuck.
        if promoteState.eggId and primaryStage > 0 and primaryStage < 3 then
            for stage = primaryStage + 1, 3 do
                local fallbackTargets = selectedPromoteTargets(roster, stage)
                if #fallbackTargets > 0 then
                    local fallbackPromoted, fallbackReason, fallbackHardError =
                        tryPromoteTargets(fallbackTargets)
                    if fallbackPromoted or fallbackHardError then
                        return fallbackPromoted
                    end
                    lastReason = fallbackReason or lastReason
                end
            end
        end
        promoteState.status = lastReason
        refreshPromoteStatus(false)
        return false
    end

    promoteUi.InfoSection:Paragraph({
        Header = "Auto Promote Controller",
        Body = "Choose an egg source or use Manual targets. Egg mode tries non-capped Inverted chickens first; if every one is unavailable, it skips to starred chickens, then tries plain chickens in order and skips any target without safe materials. Manual targets run in picker order (1 → 2 → 3), with each target filled to its promotion cap before the next same-name/same-rarity target. Materials must be the same chicken type. Keep Count reserves that many extra chickens of each target type and does not include selected targets. Exclude Chicken blocks every copy of the selected type from becoming a target or material. Excluded rarities and the selected rarity boundary are never used. Favorite, Inverted, active Coop, and other selected target chickens stay protected.",
    })

    promoteUi.Section:Toggle({
        Name = "Auto Promote",
        Default = promoteState.enabled,
        Callback = function(value)
            if loadingControls then
                return
            end
            promoteState.enabled = value == true
            promoteState.status = promoteState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshPromoteStatus(true)
        end,
    }, "AutoPromote")

    eggDropdown = promoteUi.Section:Dropdown({
        Name = "Promote from Egg (Manual)",
        Search = true,
        Multi = false,
        Required = false,
        Options = promoteEggOptions,
        Default = (function()
            local selected = promoteState.eggId
                and promoteState.eggIdToOption[promoteState.eggId]
            if selected then
                for index, option in ipairs(promoteEggOptions) do
                    if option == selected then
                        return index
                    end
                end
            end
            return 1
        end)(),
        Callback = function(value)
            if loadingControls or promoteState.reordering
                or os.clock() < (tonumber(promoteState.startupGuardUntil) or 0) then
                return
            end
            local option = type(value) == "number" and promoteEggOptions[value]
                or type(value) == "table" and (value[1] or value.Value or value.Name)
                or value
            local eggId = promoteState.eggOptionToId[option]
            promoteState.eggId = type(eggId) == "string" and eggId ~= "" and eggId or nil
            promoteState.activeTargetIds = {}
            promoteState.eggOptionSignature = nil
            promoteState.status = promoteState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshPromoteEggDropdown(true)
            refreshPromoteExcludeChickenDropdown(true)
            refreshPromoteStatus(true)
        end,
    }, "PromoteEggSource")
    promoteState.eggDropdown = eggDropdown

    targetDropdown = promoteUi.Section:Dropdown({
        Name = "Pick Chicken to Promote (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = {},
        Default = {},
        Callback = function(value)
            if loadingControls or promoteState.reordering
                or os.clock() < (tonumber(promoteState.startupGuardUntil) or 0) then
                return
            end
            local selected, order = promoteSelectedOptionSelection(
                value,
                promoteState.targetOptionToId,
                promoteState.targetOrder
            )
            promoteState.targetIds = selected
            promoteState.targetOrder = order
            promoteState.targetOptionSignature = nil
            promoteState.status = promoteState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshPromoteTargetDropdown(true)
            refreshPromoteStatus(true)
        end,
    }, "PromoteTargets")
    promoteState.targetDropdown = targetDropdown

    promoteUi.Section:Input({
        Name = "Keep Count (per type)",
        Placeholder = "0 = none",
        Default = tostring(promoteState.keepCount or 0),
        AcceptedCharacters = "Numeric",
        Callback = function(value)
            if loadingControls then
                return
            end
            local parsed = parseNumberInput(value)
            if parsed and parsed >= 0 then
                promoteState.keepCount = math.clamp(math.floor(parsed), 0, 100)
                promoteState.keepProtectedCount = nil
                saveSettings()
                refreshPromoteStatus(true)
            else
                Window:Notify({
                    Title = "Keep Count",
                    Description = "Enter a number from 0 to 100",
                    Lifetime = 3,
                })
            end
        end,
    }, "PromoteKeepCount")

    rarityDropdown = promoteUi.Section:Dropdown({
        Name = "Exclude Rarity (0)",
        Search = false,
        Multi = true,
        Required = false,
        Options = promoteRarityOptions,
        Default = (function()
            local selected = {}
            for _, row in ipairs(promoteRarityRows) do
                if (promoteState.excludeRarities or {})[row.key] == true then
                    table.insert(selected, promoteRarityKeyToOption[row.key])
                end
            end
            return selected
        end)(),
        Callback = function(value)
            if loadingControls or promoteState.reordering
                or os.clock() < (tonumber(promoteState.startupGuardUntil) or 0) then
                return
            end
            local selected = {}
            if type(value) == "table" then
                for key, enabled in pairs(value) do
                    local option
                    local active
                    if type(key) == "number" and type(enabled) == "string" then
                        option = enabled
                        active = true
                    else
                        option = key
                        active = enabled == true
                    end
                    local rarity = promoteRarityOptionToKey[option]
                    if active and rarity then
                        selected[rarity] = true
                    end
                end
            elseif type(value) == "string" then
                local rarity = promoteRarityOptionToKey[value]
                if rarity then
                    selected[rarity] = true
                end
            end
            promoteState.excludeRarities = selected
            promoteState.rarityOptionSignature = nil
            saveSettings()
            refreshPromoteRarityDropdown(true)
            refreshPromoteStatus(true)
        end,
    }, "PromoteExcludeRarity")
    promoteState.rarityDropdown = rarityDropdown

    -- Build the type-level exclusion list from the current Flock or, when an
    -- egg source is selected, from that egg's hatch pool.  The list is kept
    -- directly under Exclude Rarity so the two material filters stay together.
    refreshPromoteExcludeChickenDropdown(true)
    excludeChickenDropdown = promoteUi.Section:Dropdown({
        Name = "Exclude Chicken (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = promoteState.excludeChickenOptions,
        Default = (function()
            local selected = {}
            for _, option in ipairs(promoteState.excludeChickenOptions or {}) do
                local typeId = promoteState.excludeChickenOptionToType[option]
                if typeId and (promoteState.excludeChickenTypes or {})[typeId] == true then
                    table.insert(selected, option)
                end
            end
            return selected
        end)(),
        Callback = function(value)
            if loadingControls or promoteState.reordering
                or os.clock() < (tonumber(promoteState.startupGuardUntil) or 0) then
                return
            end
            promoteState.excludeChickenTypes = promoteSelectedOptionSet(
                value,
                promoteState.excludeChickenOptionToType
            )
            promoteState.excludeChickenOptionSignature = nil
            promoteState.activeTargetIds = {}
            promoteState.status = promoteState.enabled and "READY" or "DISABLED"
            saveSettings()
            refreshPromoteExcludeChickenDropdown(true)
            refreshPromoteTargetDropdown(true)
            refreshPromoteStatus(true)
        end,
    }, "PromoteExcludeChicken")
    promoteState.excludeChickenDropdown = excludeChickenDropdown

    promoteState.excludeHigherToggle = promoteUi.Section:Toggle({
        Name = "Exclude > Target",
        Default = promoteState.excludeHigher,
        Callback = function(value)
            if loadingControls or promoteState.exclusionSyncing then
                return
            end
            promoteState.excludeHigher = value == true
            if promoteState.excludeHigher and promoteState.excludeHigherOrEqual then
                promoteState.exclusionSyncing = true
                promoteState.excludeHigherOrEqual = false
                if promoteState.excludeHigherOrEqualToggle then
                    promoteState.excludeHigherOrEqualToggle:UpdateState(false)
                end
                promoteState.exclusionSyncing = false
            end
            saveSettings()
            refreshPromoteStatus(true)
        end,
    }, "PromoteExcludeHigher")

    promoteState.excludeHigherOrEqualToggle = promoteUi.Section:Toggle({
        Name = "Exclude >= Target",
        Default = promoteState.excludeHigherOrEqual,
        Callback = function(value)
            if loadingControls or promoteState.exclusionSyncing then
                return
            end
            promoteState.excludeHigherOrEqual = value == true
            if promoteState.excludeHigherOrEqual and promoteState.excludeHigher then
                promoteState.exclusionSyncing = true
                promoteState.excludeHigher = false
                if promoteState.excludeHigherToggle then
                    promoteState.excludeHigherToggle:UpdateState(false)
                end
                promoteState.exclusionSyncing = false
            end
            saveSettings()
            refreshPromoteStatus(true)
        end,
    }, "PromoteExcludeHigherOrEqual")

    promoteUi.Section:Button({
        Name = "Promote Selected Now",
        Callback = function()
            task.spawn(function()
                runPromoteCycle(true)
            end)
        end,
    })

    task.delay(0.35, function()
        if sharedEnv.ChickenArenaGeneration ~= generation then
            return
        end
        promoteState.targetIds = promoteState.startupTargetIds or {}
        promoteState.targetOrder = promoteState.startupTargetOrder or {}
        promoteState.eggId = promoteState.startupEggId
        promoteState.excludeChickenTypes = promoteState.startupExcludeChickenTypes or {}
        promoteState.excludeRarities = promoteState.startupExcludeRarities or {}
        promoteState.excludeHigher = promoteState.startupExcludeHigher == true
        promoteState.excludeHigherOrEqual = promoteState.startupExcludeHigherOrEqual == true
        promoteState.startupGuardUntil = 0
        promoteState.status = promoteState.enabled and "READY" or "DISABLED"
        saveSettings()
        refreshPromoteEggDropdown(true)
        refreshPromoteExcludeChickenDropdown(true)
        refreshPromoteTargetDropdown(true)
        refreshPromoteRarityDropdown(true)
        refreshPromoteStatus(true)
    end)

    refreshPromoteEggDropdown(true)
    refreshPromoteExcludeChickenDropdown(true)
    refreshPromoteTargetDropdown(true)
    refreshPromoteRarityDropdown(true)
    promoteState.status = promoteState.enabled and "READY" or "DISABLED"
    refreshPromoteStatus(true)
    sharedEnv.ChickenPromoteRunCycle = runPromoteCycle
    sharedEnv.ChickenPromoteRefresh = function()
        refreshPromoteEggDropdown()
        refreshPromoteExcludeChickenDropdown()
        refreshPromoteTargetDropdown()
        refreshPromoteRarityDropdown()
    end
    sharedEnv.ChickenPromoteStatus = refreshPromoteStatus
end)()

ScrapSection:Paragraph({
    Header = "Auto Collect",
    Body = "Automatically collect finished Incubator eggs and owned Nest eggs without changing the Egg setup.",
})

ScrapSection:Toggle({
    Name = "Auto Collect Incubator",
    Default = autoIncubator,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoIncubator = state
        saveSettings()
        print("[Collect UI] Auto Incubator:", state)
        Window:Notify({
            Title = "Incubator Collector",
            Description = state and "Will claim finished eggs automatically" or "Disabled",
            Lifetime = 3,
        })
    end,
}, "AutoIncubator")

ScrapSection:Toggle({
    Name = "Auto Collect Nest",
    Default = autoNest,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoNest = state
        saveSettings()
        print("[Collect UI] Auto Nest:", state)
        Window:Notify({
            Title = "Nest Collector",
            Description = state and "Will collect owned Nest eggs automatically" or "Disabled",
            Lifetime = 3,
        })
    end,
}, "AutoNest")

ScrapSection:Paragraph({
    Header = "Middle-map Plates",
    Body = "Walks to meteor plates, collects them, then walks back to your Recycler. No teleporting.",
})

local AutoScrapToggle = ScrapSection:Toggle({
    Name = "Auto Collect Scrap",
    Default = autoScrap,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoScrap = state
        scrapRunToken += 1
        if not state then
            scrapManualPauseUntil = 0
        end
        if not state then
            scrapStatus = "STOPPING"
        end
        saveSettings()
        print("[Scrap UI] Auto Scrap:", state)
        Window:Notify({
            Title = "Scrap Collector",
            Description = state and "Walking to plates and Recycler" or "Disabled",
            Lifetime = 3,
        })
    end,
}, "AutoScrap")

local HoldScrapToggle = ScrapSection:Toggle({
    Name = "Hold Scrap Before Rebirth",
    Default = holdScrapBeforeRebirth,
    Callback = function(state)
        if loadingControls then
            return
        end
        holdScrapBeforeRebirth = state
        scrapRunToken += 1
        scrapReadyForDeposit = false
        scrapStatus = state and "HOLD MODE ENABLED" or "HOLD MODE DISABLED"
        saveSettings()
        Window:Notify({
            Title = "Scrap Deposit",
            Description = state
                and "Will wait outside Recycler, then deposit automatically after Rebirth"
                or "Will deposit normally after collecting",
            Lifetime = 4,
        })
    end,
}, "HoldScrapBeforeRebirth")

ScrapSection:Paragraph({
    Header = "Rebirth Delay Trigger",
    Body = "Choose when Rebirth Delay starts. Only one trigger can be enabled at a time.",
})

-- These two controls behave like a radio pair while retaining the familiar
-- on/off toggle UI. Turning one on automatically turns the other off; turning
-- the active one off disables the delay trigger entirely.
sharedEnv.ChickenRebirthDelayDepositToggle = ScrapSection:Toggle({
    Name = "Delay After Scrap Deposit",
    Default = sharedEnv.ChickenRebirthDelayTrigger == "deposit",
    Callback = function(state)
        if loadingControls or sharedEnv.ChickenRebirthDelaySyncing then
            return
        end
        if state then
            sharedEnv.ChickenRebirthDelayTrigger = "deposit"
            sharedEnv.ChickenRebirthDelaySyncing = true
            if sharedEnv.ChickenRebirthDelayWalkToggle then
                sharedEnv.ChickenRebirthDelayWalkToggle:UpdateState(false)
            end
            sharedEnv.ChickenRebirthDelaySyncing = false
            saveSettings()
            Window:Notify({
                Title = "Rebirth Delay Trigger",
                Description = "Delay starts after Scrap deposit is confirmed",
                Lifetime = 3,
            })
        elseif sharedEnv.ChickenRebirthDelayTrigger == "deposit" then
            sharedEnv.ChickenRebirthDelayTrigger = "none"
            saveSettings()
            Window:Notify({
                Title = "Rebirth Delay Trigger",
                Description = "Delay trigger disabled",
                Lifetime = 3,
            })
        end
    end,
}, "RebirthDelayAfterDeposit")

sharedEnv.ChickenRebirthDelayWalkToggle = ScrapSection:Toggle({
    Name = "Delay After Recycler Walk Starts",
    Default = sharedEnv.ChickenRebirthDelayTrigger == "walk",
    Callback = function(state)
        if loadingControls or sharedEnv.ChickenRebirthDelaySyncing then
            return
        end
        if state then
            sharedEnv.ChickenRebirthDelayTrigger = "walk"
            sharedEnv.ChickenRebirthDelaySyncing = true
            if sharedEnv.ChickenRebirthDelayDepositToggle then
                sharedEnv.ChickenRebirthDelayDepositToggle:UpdateState(false)
            end
            sharedEnv.ChickenRebirthDelaySyncing = false
            saveSettings()
            Window:Notify({
                Title = "Rebirth Delay Trigger",
                Description = "Delay starts when the walk to the Recycler begins",
                Lifetime = 3,
            })
        elseif sharedEnv.ChickenRebirthDelayTrigger == "walk" then
            sharedEnv.ChickenRebirthDelayTrigger = "none"
            saveSettings()
            Window:Notify({
                Title = "Rebirth Delay Trigger",
                Description = "Delay trigger disabled",
                Lifetime = 3,
            })
        end
    end,
}, "RebirthDelayAfterWalk")

local function updateScrapTargetLabel()
    ScrapConfigParagraph:UpdateBody(
        "Pieces per run: " .. tostring(scrapTargetCount)
            .. "\nRebirth delay after send: " .. tostring(scrapDepositDelay) .. " sec"
            .. "\nDelay trigger: " .. (sharedEnv.ChickenRebirthDelayTrigger == "walk" and "Recycler walk starts"
                or sharedEnv.ChickenRebirthDelayTrigger == "deposit" and "Scrap deposit confirmed"
                or "Disabled")
            .. "\nManual pause: " .. tostring(scrapManualPauseSeconds) .. " sec"
            .. "\nPieces: 1-24 | Delays: 0-300 sec"
    )
end

ScrapSection:Input({
    Name = "Rebirth Delay (sec)",
    Placeholder = "0.5",
    Default = tostring(scrapDepositDelay),
    Callback = function(value)
        local parsed = parseNumberInput(value)
        if parsed then
            scrapDepositDelay = math.clamp(parsed, 0, 60)
            saveSettings()
            updateScrapTargetLabel()
        else
            Window:Notify({
                Title = "Scrap Collector",
                Description = "Enter a delay from 0 to 60 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "ScrapDepositDelay")

ScrapSection:Input({
    Name = "Manual Pause (sec)",
    Placeholder = "30",
    Default = tostring(scrapManualPauseSeconds),
    Callback = function(value)
        local parsed = parseNumberInput(value)
        if parsed then
            scrapManualPauseSeconds = math.clamp(parsed, 0, 300)
            saveSettings()
            updateScrapTargetLabel()
        else
            Window:Notify({
                Title = "Scrap Collector",
                Description = "Enter a pause from 0 to 300 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "ScrapManualPauseSeconds")

ScrapSection:Input({
    Name = "Pieces per Run",
    Placeholder = "1-24",
    Default = tostring(scrapTargetCount),
    AcceptedCharacters = "Numeric",
    Callback = function(value)
        local parsed = parseNumberInput(value)
        if parsed then
            scrapTargetCount = math.clamp(math.floor(parsed), 1, 24)
            saveSettings()
            updateScrapTargetLabel()
        else
            Window:Notify({
                Title = "Scrap Collector",
                Description = "Enter a number from 1 to 24",
                Lifetime = 3,
            })
        end
    end,
}, "ScrapTargetCount")

-- Forward declarations used by the Egg tab callbacks (helpers are defined below).
local claimIncubatorEggs
local collectNestEggs
local collectScrapRun
local depositHeldScrap
local scheduleNextScrapRun
local runUpgradeCycle
local updateUpgradeInfo

EggSection:Button({
    Name = "Claim Incubator Eggs",
    Callback = function()
        claimIncubatorEggs()
    end,
})

UpgradeSection:Paragraph({
    Header = "Shared Upgrade Queue / Money Lock",
    Body = "Feeder and Recycler share one money lock before every upgrade request. The queues cannot spend the same money at once. WAITING FOR MONEY pauses until funds are available; WAITING FOR FLOOR pauses only that queue until Tower/Rebirth data changes; COOLDOWN pauses after a server rate limit.",
})

local AutoUpgradeToggle = UpgradeSection:Toggle({
    Name = "Auto Upgrade",
    Default = upgradeEnabled,
    Callback = function(state)
        if loadingControls then
            return
        end
        upgradeEnabled = state
        upgradeRunToken += 1
        recyclerUpgradeState.token += 1
        upgradeStatus = state and "READY" or "STOPPED"
        saveSettings()
        -- Upgrade status is refreshed only after an explicit toggle action;
        -- the background scheduler never polls DataService for the card.
        if type(updateUpgradeInfo) == "function" then
            task.spawn(function()
                pcall(updateUpgradeInfo)
            end)
        end
        if state then
            task.spawn(runUpgradeCycle)
            task.spawn(function()
                local run = sharedEnv.ChickenRunRecyclerUpgradeCycle
                if type(run) == "function" then
                    run()
                end
            end)
        end
        Window:Notify({
            Title = "Auto Upgrade",
            Description = state and "Queue enabled" or "Disabled",
            Lifetime = 3,
        })
    end,
}, "AutoUpgrade")

UpgradeSection:Dropdown({
    Name = "Upgrade Items (Multi-select)",
    Search = false,
    Multi = true,
    Required = false,
    Options = {
        "Coop Expansion",
        "Feeder Create / Upgrade",
        "Recycler Upgrade",
    },
    Default = (function()
        local defaults = {}
        if upgradeCoop then
            table.insert(defaults, "Coop Expansion")
        end
        if upgradeFeeder then
            table.insert(defaults, "Feeder Create / Upgrade")
        end
        if upgradeRecycler then
            table.insert(defaults, "Recycler Upgrade")
        end
        return defaults
    end)(),
    Callback = function(value)
        if loadingControls then
            return
        end
        local selected = type(value) == "table" and value or {}
        upgradeCoop = selected["Coop Expansion"] == true
        upgradeFeeder = selected["Feeder Create / Upgrade"] == true
        upgradeRecycler = selected["Recycler Upgrade"] == true
        upgradeRunToken += 1
        recyclerUpgradeState.token += 1
        saveSettings()
    end,
}, "UpgradeItems")

sharedEnv.ChickenFeederWatchdogSection:Paragraph({
    Header = "Feeder Watchdog Controller",
    Body = "When enabled, the script switches to Follow while every feeder is empty, then restores Coop once any feeder has food again.",
})

sharedEnv.ChickenFeederWatchdogSection:Toggle({
    Name = "Feeder Watchdog",
    Default = sharedEnv.ChickenFeederWatchdog,
    Callback = function(state)
        if loadingControls then
            return
        end
        sharedEnv.ChickenFeederWatchdog = state
        saveSettings()
        Window:Notify({
            Title = "Feeder Watchdog",
            Description = state and "Will refresh the Coop target after all Feeders refill" or "Disabled",
            Lifetime = 3,
        })
        print("[Feeder Watchdog UI] Feeder Watchdog:", state)
    end,
}, "FeederWatchdog")

local KeepMoneyForLastFloorToggle = UpgradeSection:Toggle({
    Name = "Tower Reserve Money",
    Default = keepMoneyForLastFloor,
    Callback = function(state)
        if loadingControls then
            return
        end
        keepMoneyForLastFloor = state
        upgradeRunToken += 1
        recyclerUpgradeState.token += 1
        saveSettings()
        Window:Notify({
            Title = "Tower Funds Reserve",
            Description = state
                and "Upgrade queue will reserve the elevator cost for the last floor"
                or "No Tower money reserve",
            Lifetime = 3,
        })
    end,
}, "KeepMoneyForLastFloor")

UpgradeSection:Dropdown({
    Name = "Upgrade Priority Order",
    Multi = false,
    Required = true,
    Options = {
        "Lowest cost first",
        "Highest cost first",
        "Feeder first (max one at a time)",
    },
    Default = upgradeOrder == "low" and 1 or (upgradeOrder == "high" and 2 or 3),
    Callback = function(value)
        if loadingControls then
            return
        end
        local selected = value
        if type(value) == "number" then
            selected = value == 2 and "Highest cost first"
                or value == 3 and "Feeder first (max one at a time)"
                or "Lowest cost first"
        elseif type(value) == "table" then
            selected = value[1] or value.Value or value.Name
        end
        local selectedText = tostring(selected)
        upgradeOrder = selectedText == "Highest cost first" and "high"
            or selectedText == "Feeder first (max one at a time)" and "feeder"
            or "low"
        upgradeRunToken += 1
        recyclerUpgradeState.token += 1
        saveSettings()
    end,
}, "UpgradeOrder")

UpgradeSection:Input({
    Name = "Upgrade Delay (sec)",
    Placeholder = "0.05-60",
    Default = tostring(upgradeDelay),
    Callback = function(value)
        local parsed = parseNumberInput(value)
        if parsed then
            upgradeDelay = math.clamp(parsed, 0.05, 60)
            saveSettings()
        else
            Window:Notify({
                Title = "Auto Upgrade",
                Description = "Enter a delay from 0.05 to 60 seconds",
                Lifetime = 3,
            })
        end
    end,
}, "UpgradeDelay")

UpgradeSection:Button({
    Name = "Run Upgrade Queue Now",
    Callback = function()
        print("[Upgrade UI] manual upgrade queue requested")
        task.spawn(runUpgradeCycle)
        task.spawn(function()
            local run = sharedEnv.ChickenRunRecyclerUpgradeCycle
            if type(run) == "function" then
                run()
            end
        end)
    end,
})

EggSection:Button({
    Name = "Collect Nest Eggs",
    Callback = function()
        print("[Egg UI] manual Nest collection requested")
        task.spawn(collectNestEggs)
    end,
})

local BattleParagraph = ArenaInfoSection:Paragraph({
    Header = "Current Battle",
    Body = "Loading Arena status...",
})

local OpponentsParagraph = ArenaInfoSection:Paragraph({
    Header = "Opponent List",
    Body = "Loading 5 opponents...",
})

GameNotificationSection:Header({
    Text = "Interface",
})

GameNotificationSection:Header({
    Text = "Game UI Scale",
})

GameNotificationSection:Paragraph({
    Header = "Window Size",
    Body = "Resize all game windows and popups. Blank or 0 = native size.",
})

GameNotificationSection:Input({
    Name = "Game Window Width (%)",
    Placeholder = "",
    AcceptedCharacters = "All",
    Default = sharedEnv.ChickenUiWindowScaleWidthPercent > 0
        and tostring(sharedEnv.ChickenUiWindowScaleWidthPercent) or "",
    Callback = function(value)
        if loadingControls then
            return
        end
        sharedEnv.ChickenUiWindowScaleWidthPercent = sharedEnv.ChickenParsePercentInput(value)
        sharedEnv.ChickenUiWindowScale.apply()
        saveSettings()
    end,
}, "GameWindowWidth")

GameNotificationSection:Input({
    Name = "Game Window Height (%)",
    Placeholder = "",
    AcceptedCharacters = "All",
    Default = sharedEnv.ChickenUiWindowScaleHeightPercent > 0
        and tostring(sharedEnv.ChickenUiWindowScaleHeightPercent) or "",
    Callback = function(value)
        if loadingControls then
            return
        end
        sharedEnv.ChickenUiWindowScaleHeightPercent = sharedEnv.ChickenParsePercentInput(value)
        sharedEnv.ChickenUiWindowScale.apply()
        saveSettings()
    end,
}, "GameWindowHeight")

-- Discord Webhook ---------------------------------------------------------
-- Event notifications are opt-in, independent from Auto Chaos, and sent only
-- once when an event transitions into LIVE.  The webhook URL is never printed
-- or included in the in-game status text.
do
    local webhookState = sharedEnv.ChickenWebhookState
    local eventOptions = sharedEnv.ChickenWebhookEventOptions or {}
    local eventOptionToId = sharedEnv.ChickenWebhookEventOptionToId or {}

    local function readWebhookEvents(value)
        local selected = {}
        if type(value) == "table" then
            for key, enabled in pairs(value) do
                local option
                local active
                if type(key) == "number" and type(enabled) == "string" then
                    option = enabled
                    active = true
                else
                    option = key
                    active = enabled == true
                end
                local eventId = eventOptionToId[option]
                if active and eventId then
                    selected[eventId] = true
                end
            end
        elseif type(value) == "string" then
            local eventId = eventOptionToId[value]
            if eventId then
                selected[eventId] = true
            end
        end
        return selected
    end

    SettingsSection:Header({
        Text = "Discord Webhook",
    })

    SettingsSection:Paragraph({
        Header = "Event Alerts",
        Body = "Sends one Discord alert when a selected event enters LIVE. Auto Chaos does not need to be enabled.",
    })

    sharedEnv.ChickenWebhookEventDropdown = SettingsSection:Dropdown({
        Name = "Webhook Events (0)",
        Search = true,
        Multi = true,
        Required = false,
        Options = eventOptions,
        Default = sharedEnv.ChickenWebhookSelectedOptions(),
        Callback = function(value)
            if loadingControls then
                return
            end
            webhookState.events = readWebhookEvents(value)
            webhookState.lastAttemptKey = ""
            webhookState.lastStatus = next(webhookState.events) and "READY" or "NO EVENTS SELECTED"
            webhookState.lastError = ""
            if sharedEnv.ChickenUfuState then
                sharedEnv.ChickenUfuState.webhookLastLiveKey = ""
            end
            local selected = sharedEnv.ChickenWebhookSelectedOptions()
            saveSettings()
            -- MacLib's multi-select label is not updated by the callback on
            -- every version, so keep the count visible ourselves.
            pcall(function()
                if sharedEnv.ChickenWebhookEventDropdown then
                    sharedEnv.ChickenWebhookEventDropdown:UpdateName(
                        "Webhook Events (" .. tostring(#selected) .. ")"
                    )
                end
            end)
        end,
    }, "DiscordWebhookEvents")
    pcall(function()
        if sharedEnv.ChickenWebhookEventDropdown then
            sharedEnv.ChickenWebhookEventDropdown:UpdateName(
                "Webhook Events (" .. tostring(#sharedEnv.ChickenWebhookSelectedOptions()) .. ")"
            )
        end
    end)

    SettingsSection:Input({
        Name = "Discord Webhook URL",
        Placeholder = "https://discord.com/api/webhooks/...",
        Default = tostring(webhookState.url or ""),
        Callback = function(value)
            if loadingControls then
                return
            end
            local url = tostring(value or "")
                :gsub("^%s+", "")
                :gsub("%s+$", "")
            if #url > 500 then
                url = url:sub(1, 500)
            end
            webhookState.url = url
            webhookState.lastAttemptKey = ""
            webhookState.lastStatus = url ~= "" and "READY" or "URL REQUIRED"
            webhookState.lastError = ""
            if sharedEnv.ChickenUfuState then
                sharedEnv.ChickenUfuState.webhookLastLiveKey = ""
            end
            saveSettings()
        end,
    }, "DiscordWebhookUrl")

    SettingsSection:Toggle({
        Name = "Event Alert",
        Default = webhookState.enabled,
        Callback = function(value)
            if loadingControls then
                return
            end
            webhookState.enabled = value == true
            webhookState.lastAttemptKey = ""
            webhookState.lastStatus = webhookState.enabled and "READY" or "DISABLED"
            webhookState.lastError = ""
            if sharedEnv.ChickenUfuState then
                sharedEnv.ChickenUfuState.webhookLastLiveKey = ""
            end
            saveSettings()
            print("[Webhook UI] Discord Webhook:", webhookState.enabled and "on" or "off")
        end,
    }, "DiscordWebhook")

    SettingsSection:Paragraph({
        Header = "Enable Upcoming",
        Body = "Posts every scheduled event with an icon, name, and live countdown. The same Discord message is edited every 5 seconds. Use the separate URL below.",
    })

    SettingsSection:Input({
        Name = "Discord Webhook URL",
        Placeholder = "https://discord.com/api/webhooks/...",
        Default = tostring(webhookState.upcomingUrl or ""),
        Callback = function(value)
            if loadingControls then
                return
            end
            local url = tostring(value or "")
                :gsub("^%s+", "")
                :gsub("%s+$", "")
            if #url > 500 then
                url = url:sub(1, 500)
            end
            if webhookState.upcomingUrl ~= url then
                webhookState.upcomingMessageId = ""
                webhookState.upcomingLastUpdateAt = 0
                webhookState.upcomingDirty = false
            end
            webhookState.upcomingUrl = url
            webhookState.lastStatus = url ~= ""
                and "UPCOMING URL READY" or "UPCOMING URL REQUIRED"
            webhookState.lastError = ""
            saveSettings()
        end,
    }, "UpcomingEventsWebhookUrl")

    SettingsSection:Toggle({
        Name = "Upcoming Events Webhook",
        Default = webhookState.upcomingEnabled,
        Callback = function(value)
            if loadingControls then
                return
            end
            webhookState.upcomingEnabled = value == true
            webhookState.upcomingLastUpdateAt = 0
            webhookState.upcomingDirty = false
            webhookState.lastError = ""
            webhookState.lastStatus = webhookState.upcomingEnabled and "READY" or "DISABLED"
            saveSettings()
            if webhookState.upcomingEnabled
                and type(sharedEnv.ChickenWebhookUpcomingEventsUpdate) == "function" then
                task.spawn(function()
                    sharedEnv.ChickenWebhookUpcomingEventsUpdate(true)
                end)
            end
        end,
    }, "UpcomingEventsWebhook")
end

GameNotificationSection:Paragraph({
    Header = "Game Notification",
    Body = "Controls the Tower death notification popup.",
})

GameNotificationSection:Toggle({
    Name = "Disable Tower Notification",
    Default = autoDismissTowerPopup,
    Callback = function(state)
        if loadingControls then
            return
        end
        autoDismissTowerPopup = state
        saveSettings()
        Window:Notify({
            Title = "Game Notification",
            Description = state and "Tower notification disabled" or "Tower notification enabled",
            Lifetime = 3,
        })
    end,
}, "AutoDismissTowerPopup")

GameNotificationSection:Keybind({
    Name = "UI Toggle Key",
    Default = uiToggleKey,
    Callback = function()
        -- Maclib handles window visibility with this key.
    end,
    onBinded = function(bind)
        if loadingControls then
            return
        end
        uiToggleKey = bind
        saveSettings()
        Window:SetKeybind(bind)
        Window:Notify({
            Title = "UI Toggle Key",
            Description = "Changed to " .. tostring(bind.Name),
            Lifetime = 3,
        })
        print("[Arena UI] toggle key:", bind.Name)
    end,
}, "UIToggleKey")

GameNotificationSection:Button({
    Name = "Unload / Close Script",
    Callback = function()
        unloadScript()
    end,
})

-- The loaded values are supplied through each Toggle's Default field.
-- Do not call UpdateState here because Maclib invokes the callback again.
-- That initialization callback could overwrite a saved Off state.
loadingControls = false
sharedEnv.ChickenUiWindowScale.start()
sharedEnv.ChickenRefreshInterfaceLayout = function()
    local mainScreen = sharedEnv.ChickenArenaMaclibScreenGui
    local robloxGui = CoreGui:FindFirstChild("RobloxGui")
    local function isCurrentMainScreen(candidate)
        if not candidate or not candidate:IsA("ScreenGui") or not candidate.Parent then
            return false
        end
        if robloxGui and candidate.Parent ~= robloxGui then
            return false
        end
        for _, label in ipairs(candidate:GetDescendants()) do
            if label:IsA("TextLabel") and label.Text == "Script " .. SCRIPT_VERSION then
                return true
            end
        end
        return false
    end
    if not isCurrentMainScreen(mainScreen) then
        mainScreen = nil
        for _, candidate in ipairs(CoreGui:GetDescendants()) do
            if isCurrentMainScreen(candidate) then
                mainScreen = candidate
                break
            end
        end
        sharedEnv.ChickenArenaMaclibScreenGui = mainScreen
    end
    if not mainScreen then
        return
    end
    for _, item in ipairs(mainScreen:GetDescendants()) do
        if item:IsA("TextBox") then
            local section = item.Parent and item.Parent.Parent
            local isScaleInput = false
            if section then
                for _, label in ipairs(section:GetChildren()) do
                    if label:IsA("TextLabel")
                        and (label.Text == "Game Window Width (%)"
                            or label.Text == "Game Window Height (%)") then
                        isScaleInput = true
                        break
                    end
                end
            end
            if isScaleInput then
                item.AutomaticSize = Enum.AutomaticSize.None
                local sizeConstraint = item:FindFirstChild("InputBoxUISizeConstraint")
                if sizeConstraint and sizeConstraint:IsA("UISizeConstraint") then
                    sizeConstraint.MaxSize = Vector2.new(88, 1000000000)
                end
                item.Size = UDim2.fromOffset(88, 21)
                item.TextXAlignment = Enum.TextXAlignment.Left
            end
        elseif item:IsA("GuiButton")
            and (item.Name == "Exit" or item.Name == "Minimize" or item.Name == "Maximize")
            and item.Parent and item.Parent.Name == "Controls" then
            item.Size = UDim2.fromOffset(14, 14)
            item.Visible = true
        end
    end
end
sharedEnv.ChickenRefreshInterfaceLayout()
sharedEnv.ChickenInterfaceLayoutPending = false
sharedEnv.ChickenScheduleInterfaceLayout = function()
    if sharedEnv.ChickenInterfaceLayoutPending then
        return
    end
    sharedEnv.ChickenInterfaceLayoutPending = true
    task.delay(0.2, function()
        sharedEnv.ChickenInterfaceLayoutPending = false
        if sharedEnv.ChickenArenaGeneration == generation then
            sharedEnv.ChickenRefreshInterfaceLayout()
        end
    end)
end
sharedEnv.ChickenInterfaceLayoutConnection = CoreGui.DescendantAdded:Connect(function(item)
    if sharedEnv.ChickenArenaGeneration ~= generation then
        return
    end
    if item:IsA("TextBox") then
        if item.Name ~= "InputBox" then
            return
        end
    elseif item:IsA("GuiButton") then
        if item.Name ~= "Exit"
            and item.Name ~= "Minimize"
            and item.Name ~= "Maximize" then
            return
        end
    else
        return
    end
    sharedEnv.ChickenScheduleInterfaceLayout()
end)
if autoArena or autoTowerToRebirth or autoTower then
    setAutoAbility:FireServer(true)
end
if autoTowerToRebirth or autoTower then
    -- The configured delay is now reserved for the period immediately after
    -- a successful Rebirth. Enabling the mode or reloading the script is
    -- ready to start immediately.
    towerRunState.afterRebirthPending = false
    towerRunState.runDeadline = 0
    towerNextStartAt = 0
    towerStatus = "READY TO START"
end
saveSettings()
-- Start visible so a freshly-run/public script always shows its controls.
-- Pressing Minimize (or the UI toggle key) hides the window and leaves the
-- floating restore icon created in styleTopRightMinimize().
Window:SetState(true)
-- Keep the bottom-right notification stack completely hidden.
Window:SetNotificationsState(false)

-- Auto to Chaos controller -----------------------------------------------
-- The event itself owns the gameplay/upgrade logic; this controller only
-- sends the official Chaos order for a selected live event, waits for the
-- chicken to return, and repeats.  It deliberately does not teleport or edit
-- chicken data.
do
    local ufuState = sharedEnv.ChickenUfuState
    local ufuUi = sharedEnv.ChickenUfuUI
    local ufuToken = (sharedEnv.ChickenUfuLoopToken or 0) + 1
    sharedEnv.ChickenUfuLoopToken = ufuToken
    local ufuController
    local ufuOrderRemote = remotes:FindFirstChild("SetChickenOrder")
    local localPlayer = Players.LocalPlayer
    local lastLive = false
    local lastOrderRetryAt = 0

    pcall(function()
        local controllers = localPlayer:WaitForChild("PlayerScripts")
            :WaitForChild("Features")
            :WaitForChild("Chicken")
            :WaitForChild("controllers")
        ufuController = loadModule(controllers:WaitForChild("ChickenController"))
    end)

    local function formatUfuTime(seconds)
        local value = math.max(0, math.ceil(tonumber(seconds) or 0))
        return string.format("%02d:%02d", math.floor(value / 60), value % 60)
    end

    local function eventLabel(eventId)
        for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
            if eventDef.id == eventId then
                return eventDef.label
            end
        end
        return eventId ~= "" and eventId or "None"
    end

    local function selectedEventText()
        local labels = {}
        for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
            if ufuState.events[eventDef.id] then
                table.insert(labels, eventDef.label)
            end
        end
        return #labels > 0 and table.concat(labels, ", ") or "None"
    end

    local function getUfuEventState()
        local rawEventId = tostring(workspace:GetAttribute("EventId") or "")
        local eventId = rawEventId
        local loweredEventId = string.lower(rawEventId)
        for _, eventDef in ipairs(sharedEnv.ChickenAutoChaos.defs) do
            if string.lower(eventDef.id) == loweredEventId then
                -- Keep the canonical camelCase id used by the saved selection
                -- table (e.g. goldenGoose, chickenBoss).
                eventId = eventDef.id
                break
            end
        end
        local phase = string.lower(tostring(workspace:GetAttribute("EventPhase") or "idle"))
        local deadline = tonumber(workspace:GetAttribute("EventDeadline"))
        local selected = ufuState.events[eventId] == true
        local live = selected and phase == "live"
        return live, eventId, phase, deadline, selected
    end

    -- Webhook alerts observe the server's raw event phase, independently of
    -- Auto Chaos selection.  Keep a per-event latch so a polling loop sends
    -- one notification per LIVE cycle instead of repeating the same request.
    local function observeWebhookEvent(eventId, phase, deadline)
        local rawLive = eventId ~= "" and phase == "live"
        local eventKey = tostring(eventId or "") .. "|" .. tostring(deadline or "")
        local webhookState = sharedEnv.ChickenWebhookState
        local notifyEnabled = type(webhookState) == "table"
            and webhookState.enabled == true
            and type(webhookState.events) == "table"
            and webhookState.events[eventId] == true
        local wasRawLive = ufuState.webhookRawLive == true
        local previousEventId = ufuState.webhookRawLiveEventId
        local previousDeadline = ufuState.webhookRawLiveDeadline

        local function finishPreviousUfoRound()
            if not wasRawLive or previousEventId ~= "ufo" then
                return
            end
            local endKey = "ufo|" .. tostring(previousDeadline or "")
            if ufuState.webhookUfoEndKey == endKey then
                return
            end
            ufuState.webhookUfoEndKey = endKey
            if type(sharedEnv.ChickenWebhookSendUfoRoundEnd) == "function" then
                pcall(function()
                    sharedEnv.ChickenWebhookSendUfoRoundEnd(
                        "live",
                        previousDeadline,
                        ufuState.ufoChaosRounds,
                        ufuState.ufoMutationCount
                    )
                end)
            end
        end

        if rawLive then
            local newLiveWindow = not wasRawLive
                or previousEventId ~= eventId
                or tostring(previousDeadline or "") ~= tostring(deadline or "")
            if newLiveWindow then
                -- If polling crossed directly into another LIVE event, close
                -- the previous UFO window before starting the new latch.
                finishPreviousUfoRound()
                ufuState.webhookRawLive = true
                ufuState.webhookRawLiveEventId = eventId
                ufuState.webhookRawLiveDeadline = deadline
                if eventId == "ufo" then
                    ufuState.ufoMutationCount = 0
                    ufuState.ufoChaosRounds = 0
                    ufuState.ufoEventStartedAt = os.clock()
                    ufuState.webhookUfoEndKey = ""
                end
            end
            if notifyEnabled then
                if ufuState.webhookLastLiveKey ~= eventKey then
                    ufuState.webhookLastLiveKey = eventKey
                    if eventId == "ufo" then
                        -- UFO uses one message for the whole live window: post
                        -- the LIVE alert here, then mutation reports and the
                        -- round-end summary PATCH this same message.
                        if type(sharedEnv.ChickenWebhookUfoRoundUpdate) == "function" then
                            sharedEnv.ChickenWebhookUfoRoundUpdate(
                                deadline,
                                deadline,
                                nil,
                                ufuState.ufoChaosRounds,
                                false,
                                false
                            )
                        end
                    elseif type(sharedEnv.ChickenWebhookSendEvent) == "function" then
                        -- Other selected events retain their standalone LIVE
                        -- notification behaviour.
                        sharedEnv.ChickenWebhookSendEvent(eventId, deadline)
                    end
                end
            else
                -- Allow the user to enable/select this event while it is
                -- already LIVE and still receive one start notification.
                ufuState.webhookLastLiveKey = ""
            end
        else
            finishPreviousUfoRound()
            ufuState.webhookRawLive = false
            ufuState.webhookRawLiveEventId = nil
            ufuState.webhookRawLiveDeadline = nil
            ufuState.webhookLastLiveKey = ""
        end
    end

    local function getLocalChickenBody()
        local bodies = workspace:FindFirstChild("ChickenBodies")
        if not bodies or not localPlayer then
            return nil
        end
        for _, body in ipairs(bodies:GetChildren()) do
            if tonumber(body:GetAttribute("ovOwner")) == localPlayer.UserId then
                return body
            end
        end
        return nil
    end

    local function isBodyAlive(body)
        if not body then
            return nil
        end
        local life = body:GetAttribute("ovLife")
        if life == false or life == 0 or tostring(life):lower() == "false" then
            return false
        end
        return true
    end

    local function getUfoCarrying()
        local ufo = workspace:FindFirstChild("Ufo", true)
        if not ufo then
            return 0
        end
        local carrying = ufo:GetAttribute("Carrying")
        if carrying == true then
            return 1
        end
        return math.max(0, tonumber(carrying) or 0)
    end

    local function setChickenOrder(order)
        if ufuController and type(ufuController.setOrder) == "function" then
            local ok, result = pcall(function()
                return ufuController:setOrder(order)
            end)
            if ok and result ~= false then
                return true
            end
        end
        if ufuOrderRemote then
            local ok = pcall(function()
                ufuOrderRemote:FireServer(order)
            end)
            return ok
        end
        return false
    end

    local function updateUfuBody(bodyText)
        if ufuState.lastStatusBody == bodyText then
            return
        end
        ufuState.lastStatusBody = bodyText
        local directUpdated = false
        pcall(function()
            for _, item in ipairs(CoreGui:GetDescendants()) do
                if item:IsA("TextLabel")
                    and (item.Text == "Auto Chaos Status"
                        or item.Text == "Auto to Chaos Status"
                        or item.Text == "UFO Status") then
                    local bodyLabel = item.Parent and item.Parent:FindFirstChild("ParagraphBody")
                    if bodyLabel and bodyLabel:IsA("TextLabel") then
                        bodyLabel.Text = bodyText
                        directUpdated = true
                    end
                end
            end
        end)
        if not directUpdated and ufuUi and ufuUi.InfoParagraph then
            pcall(function()
                ufuUi.InfoParagraph:UpdateBody(bodyText)
            end)
        end
    end

    local function updateUfuStatus(live, eventId, phase, deadline, bodyState, carrying)
        local now = workspace:GetServerTimeNow()
        local remaining = deadline and math.max(0, deadline - now) or 0
        local eventLine
        if live then
            eventLine = string.upper(eventLabel(eventId)) .. " • LIVE " .. formatUfuTime(remaining)
        elseif ufuState.events[eventId] and phase == "warmup" then
            eventLine = string.upper(eventLabel(eventId)) .. " • WARMUP"
        elseif ufuState.events[eventId] and eventId ~= "" then
            eventLine = string.upper(eventLabel(eventId)) .. " • " .. string.upper(phase)
        else
            eventLine = "WAITING FOR SELECTED EVENT"
        end
        local bodyLine = bodyState and string.upper(bodyState) or "NOT VISIBLE"
        local carryLine = carrying > 0 and ("CARRYING " .. tostring(carrying)) or "CLEAR"
        local action = tostring(ufuState.status or "IDLE")
        local activePick = eventId == "ufo"
            and (ufuState.useUfoChicken and ufuState.ufoActiveChickenId or nil)
            or nil
        local selectedChickenLine
        if eventId == "ufo" and not ufuState.useUfoChicken then
            selectedChickenLine = "ACTIVE CHICKEN (UFO PICK OFF)"
        elseif activePick then
            selectedChickenLine = sharedEnv.ChickenAutoChaos.chickenLabel(activePick)
        elseif eventId == "ufo" then
            selectedChickenLine = "ACTIVE CHICKEN (UFO LIST EMPTY)"
        else
            selectedChickenLine = "ACTIVE CHICKEN"
        end
        local targetLine = eventId == "ufo" and (ufuState.targetRarity ~= ""
            and string.upper(ufuState.targetRarity) or "NONE") or "—"
        local leaveTargetLine = eventId == "ufo" and (
            ufuState.leaveWhenRarityEnabled == true
                and ufuState.leaveWhenRarity ~= ""
                and (string.upper(ufuState.leaveWhenRarity) .. " (ON)")
                or "OFF"
        ) or "—"
        local body = "Selected: " .. selectedEventText()
            .. "\nEvent: " .. eventLine
            .. "\nPick: " .. selectedChickenLine
            .. "\nUFO target: " .. targetLine
            .. "\nLeave when rarity: " .. leaveTargetLine
            .. "\nRotation: " .. sharedEnv.ChickenAutoChaos.ufoRotationText()
            .. "\nChicken: " .. bodyLine
            .. "\nBeam: " .. carryLine
            .. "\nCycles: " .. tostring(ufuState.cycles or 0)
            .. "\nAction: " .. action
        updateUfuBody(body)
    end

    -- ChickenMutated is the authoritative UFO result signal.  Capture it once
    -- per script generation so the rotation advances only after the selected
    -- chicken actually reaches the configured target rarity.
    sharedEnv.ChickenUfuEventConnections = {}
    pcall(function()
        local mutationRemote = remotes:FindFirstChild("ChickenMutated")
        if mutationRemote and mutationRemote:IsA("RemoteEvent") then
            table.insert(sharedEnv.ChickenUfuEventConnections, mutationRemote.OnClientEvent:Connect(function(payload)
                if type(payload) ~= "table" then
                    return
                end
                ufuState.lastMutation = payload
                ufuState.lastMutationAt = os.clock()
                -- ChickenMutated is the server-authoritative result for an
                -- UFO Chaos attempt.  Count/report it independently from
                -- Auto Chaos so webhook notifications still work when the
                -- automation itself is turned off.
                local rawMutationEventId = string.lower(tostring(workspace:GetAttribute("EventId") or ""))
                if rawMutationEventId == "ufo"
                    or (rawMutationEventId == "" and ufuState.currentEventId == "ufo") then
                    ufuState.ufoMutationCount = (tonumber(ufuState.ufoMutationCount) or 0) + 1
                    local mutationDeadline = tonumber(workspace:GetAttribute("EventDeadline"))
                        or tonumber(ufuState.eventEndsAt)
                    if type(sharedEnv.ChickenWebhookSendUfoMutation) == "function" then
                        pcall(function()
                            sharedEnv.ChickenWebhookSendUfoMutation(
                                payload,
                                ufuState.ufoMutationCount,
                                mutationDeadline
                            )
                        end)
                    end
                end
                if ufuState.currentEventId ~= "ufo" or not ufuState.useUfoChicken then
                    return
                end
                local targetRank = sharedEnv.ChickenAutoChaos.rarityRank(
                    sharedEnv.ChickenAutoChaos.ufoStopRarity()
                )
                if targetRank <= 0 then
                    return
                end
                local resultId = type(payload.chickenId) == "string" and payload.chickenId or nil
                local activeId = ufuState.ufoActiveChickenId
                if resultId and activeId and resultId ~= activeId then
                    return
                end
                local resultRank = sharedEnv.ChickenAutoChaos.rarityRank(payload.rarity)
                if resultRank >= targetRank and (payload.ascended == true or resultRank > 0) then
                    ufuState.ufoTargetReached = true
                    ufuState.ufoAdvancePending = true
                    ufuState.status = "TARGET "
                        .. string.upper(sharedEnv.ChickenAutoChaos.ufoStopRarity())
                        .. " REACHED"
                end
            end))
        end
    end)

    task.spawn(function()
        local function issueChaos(statusText)
            if os.clock() < lastOrderRetryAt then
                return false
            end
            local sent = setChickenOrder("chaos")
            if sent then
                ufuState.cycles = (tonumber(ufuState.cycles) or 0) + 1
                if ufuState.currentEventId == "ufo" then
                    ufuState.ufoChaosRounds = (tonumber(ufuState.ufoChaosRounds) or 0) + 1
                    if ufuState.useUfoChicken
                        and ufuState.leaveWhenRarityEnabled == true
                        and ufuState.leaveWhenRarity ~= ""
                        and type(sharedEnv.ChickenAutoChaos.selectedUfoChickenIds) == "function"
                        and #(sharedEnv.ChickenAutoChaos.selectedUfoChickenIds() or {}) > 0 then
                        ufuState.ufoLeaveSessionStarted = true
                    end
                end
                ufuState.lastActionAt = os.clock()
                ufuState.waitingReturn = true
                ufuState.orderIssued = true
                ufuState.status = statusText or "CHAOS SENT"
                lastOrderRetryAt = os.clock() + 0.5
                return true
            end
            ufuState.status = statusText == "CHAOS SENT AFTER DEATH"
                and "CHAOS RETRY AFTER DEATH" or "CHAOS ORDER FAILED"
            lastOrderRetryAt = os.clock() + 2
            return false
        end

        local function advanceUfoTarget()
            ufuState.ufoIndex = (tonumber(ufuState.ufoIndex) or 1) + 1
            ufuState.ufoTargetReached = false
            ufuState.ufoAdvancePending = false
            ufuState.ufoActiveChickenId = nil
            ufuState.waitingReturn = false
            ufuState.orderIssued = false
            local nextId = sharedEnv.ChickenAutoChaos.getUfoTargetId()
            if nextId then
                ufuState.status = "SWITCHING TO " .. sharedEnv.ChickenAutoChaos.chickenLabel(nextId)
            else
                ufuState.ufoRotationComplete = true
                ufuState.status = "UFO ROTATION COMPLETE"
                if type(sharedEnv.ChickenMaybeLeaveWhenUfoRarity) == "function" then
                    sharedEnv.ChickenMaybeLeaveWhenUfoRarity()
                end
            end
        end

        local function restoreActiveChicken(activeId, body, bodyState, carrying)
            local originalId = ufuState.originalActiveChickenId
            if not originalId then
                ufuState.restoreActivePending = false
                return true
            end
            if activeId == originalId then
                ufuState.restoreActivePending = false
                ufuState.originalActiveChickenId = nil
                return true
            end
            if body and bodyState == "corral" and carrying <= 0 then
                if sharedEnv.ChickenAutoChaos.setActiveChicken(originalId) then
                    ufuState.restoreActivePending = false
                    ufuState.originalActiveChickenId = nil
                    ufuState.status = "RESTORED ACTIVE CHICKEN"
                    return true
                end
            end
            ufuState.restoreActivePending = true
            ufuState.status = "RESTORING ACTIVE CHICKEN"
            return false
        end

        print("[Event UI] controller loaded; Auto Chaos:", ufuState.enabled and "on" or "off")
        while sharedEnv.ChickenArenaGeneration == generation
            and sharedEnv.ChickenUfuLoopToken == ufuToken do
            local now = os.clock()
            if now >= (tonumber(ufuState.nextChickenRefreshAt) or 0) then
                ufuState.nextChickenRefreshAt = now + 2
                pcall(sharedEnv.ChickenAutoChaos.refreshActiveChicken)
            end
            local live, eventId, phase, deadline = getUfuEventState()
            observeWebhookEvent(eventId, phase, deadline)
            local body = getLocalChickenBody()
            -- ChickenBodyProxy.readStats (the game's own reader) treats a
            -- missing ovState attribute as "corral".  A fresh join commonly
            -- omits this attribute until the first order change; treating it
            -- as blank here left Auto Chaos stuck at WAITING FOR CHICKEN.
            local bodyState = body and tostring(body:GetAttribute("ovState") or "corral") or nil
            local bodyAlive = isBodyAlive(body)
            local carrying = getUfoCarrying()
            local activeId = ufuState.activeChickenId
            ufuState.eventEndsAt = deadline or 0
            ufuState.lastBodyState = bodyState
            ufuState.lastCarrying = carrying
            ufuState.lastBodyLife = bodyAlive

            if not ufuState.enabled then
                if ufuState.restoreCoopPending then
                    pcall(function()
                        setChickenOrder("coop")
                    end)
                    ufuState.restoreCoopPending = false
                end
                local restored = restoreActiveChicken(activeId, body, bodyState, carrying)
                ufuState.waitingReturn = false
                ufuState.orderIssued = false
                ufuState.deathPending = false
                ufuState.phase = "DISABLED"
                if restored then
                    -- Clear the session latch while disabled. If the user
                    -- enables Auto Chaos again during the same live event,
                    -- the current active chicken is captured as the new
                    -- restore point instead of reusing a stale event id.
                    ufuState.currentEventId = nil
                    ufuState.ufoIndex = 1
                    ufuState.ufoActiveChickenId = nil
                    ufuState.ufoAdvancePending = false
                    ufuState.ufoRotationComplete = false
                    ufuState.status = "DISABLED"
                elseif not ufuState.restoreActivePending then
                    ufuState.status = "DISABLED"
                end
            elseif not live then
                if lastLive or ufuState.orderIssued or ufuState.waitingReturn then
                    -- Restore the ordinary Coop order once the selected event
                    -- ends, including a beam carry at the exact boundary.
                    pcall(function()
                        setChickenOrder("coop")
                    end)
                end
                lastLive = false
                ufuState.waitingReturn = false
                ufuState.orderIssued = false
                ufuState.deathPending = false
                ufuState.phase = phase == "warmup" and "WARMUP" or "WAITING"
                local restored = restoreActiveChicken(activeId, body, bodyState, carrying)
                if restored then
                    ufuState.currentEventId = nil
                    ufuState.ufoIndex = 1
                    ufuState.ufoActiveChickenId = nil
                    ufuState.ufoAdvancePending = false
                    ufuState.ufoRotationComplete = false
                    if not next(ufuState.events) then
                        ufuState.status = "SELECT EVENT"
                    elseif ufuState.events[eventId] and phase == "warmup" then
                        ufuState.status = "WAITING FOR " .. string.upper(eventLabel(eventId))
                    else
                        ufuState.status = "WAITING FOR SELECTED EVENT"
                    end
                end
            else
                if ufuState.currentEventId ~= eventId then
                    ufuState.currentEventId = eventId
                    local pickingForEvent = eventId == "ufo"
                        and ufuState.useUfoChicken
                    if not ufuState.originalActiveChickenId and pickingForEvent then
                        ufuState.originalActiveChickenId = activeId
                    end
                    ufuState.restoreActivePending = false
                    ufuState.ufoIndex = 1
                    ufuState.ufoActiveChickenId = nil
                    ufuState.ufoTargetReached = false
                    ufuState.ufoAdvancePending = false
                    ufuState.ufoRotationComplete = false
                end
                lastLive = true
                ufuState.phase = "LIVE"
                if bodyAlive == false then
                    -- A KO can leave the proxy visible for a few frames.  Arm
                    -- a respawn gate and never issue Chaos against the dead
                    -- proxy; the next living corral state sends it again.
                    ufuState.deathPending = true
                    ufuState.waitingReturn = false
                    ufuState.orderIssued = false
                    ufuState.status = "CHICKEN DEAD - WAITING RESPAWN"
                elseif ufuState.deathPending then
                    if body and bodyState == "corral" and carrying <= 0 then
                        local desiredId = sharedEnv.ChickenAutoChaos.getDesiredChickenId(eventId)
                        if desiredId and activeId ~= desiredId then
                            ufuState.status = "SWITCHING TO " .. sharedEnv.ChickenAutoChaos.chickenLabel(desiredId)
                            if eventId == "ufo" then
                                ufuState.ufoActiveChickenId = desiredId
                            end
                            sharedEnv.ChickenAutoChaos.setActiveChicken(desiredId)
                        elseif eventId == "ufo" and ufuState.ufoAdvancePending then
                            ufuState.deathPending = false
                            advanceUfoTarget()
                        else
                            ufuState.deathPending = false
                            issueChaos("CHAOS SENT AFTER DEATH")
                        end
                    else
                        ufuState.status = "WAITING RESPAWN"
                    end
                elseif eventId == "ufo" and ufuState.ufoRotationComplete then
                    ufuState.status = "UFO ROTATION COMPLETE"
                elseif eventId == "ufo" and ufuState.ufoAdvancePending then
                    if body and bodyState == "corral" and carrying <= 0 then
                        advanceUfoTarget()
                    elseif carrying > 0 then
                        ufuState.waitingReturn = true
                        ufuState.orderIssued = true
                        ufuState.status = "TARGET REACHED - WAITING RETURN"
                    else
                        ufuState.status = bodyState and ("TARGET REACHED - WAITING " .. string.upper(bodyState))
                            or "TARGET REACHED - WAITING RETURN"
                    end
                elseif carrying > 0 then
                    ufuState.waitingReturn = true
                    ufuState.orderIssued = true
                    ufuState.status = "IN UFO BEAM"
                elseif ufuState.waitingReturn or ufuState.orderIssued then
                    -- A body can disappear while the UFO is hauling it.  Do
                    -- not send another Chaos order until it is visibly back
                    -- in the Coop/corral.
                    if body and bodyState == "corral" then
                        if eventId == "ufo" and ufuState.ufoAdvancePending then
                            advanceUfoTarget()
                        else
                            ufuState.waitingReturn = false
                            ufuState.orderIssued = false
                            ufuState.status = "RETURNED - NEXT CHAOS"
                        end
                    else
                        ufuState.status = bodyState and ("WAITING RETURN (" .. string.upper(bodyState) .. ")")
                            or "WAITING RETURN"
                    end
                elseif body and bodyState == "pit" then
                    -- A reload can occur after Chaos was sent; the Pit state is
                    -- enough evidence to arm the return gate.
                    ufuState.waitingReturn = true
                    ufuState.orderIssued = true
                    ufuState.status = "IN CHAOS PIT"
                elseif body and bodyState == "corral" then
                    local desiredId = sharedEnv.ChickenAutoChaos.getDesiredChickenId(eventId)
                    if desiredId and activeId ~= desiredId then
                        ufuState.status = "SWITCHING TO " .. sharedEnv.ChickenAutoChaos.chickenLabel(desiredId)
                        if eventId == "ufo" then
                            ufuState.ufoActiveChickenId = desiredId
                        end
                        sharedEnv.ChickenAutoChaos.setActiveChicken(desiredId)
                    elseif eventId == "ufo" and not desiredId and ufuState.useUfoChicken
                        and ufuState.ufoRotationComplete then
                        ufuState.status = "UFO ROTATION COMPLETE"
                    else
                        issueChaos()
                    end
                else
                    ufuState.status = "WAITING FOR CHICKEN"
                end
            end

            -- A roster can already be at/above the stop rarity when the UFO
            -- rotation is first evaluated.  Check the one-shot leave latch on
            -- every LIVE tick as well as after an explicit target advance.
            if eventId == "ufo" and live
                and type(sharedEnv.ChickenMaybeLeaveWhenUfoRarity) == "function" then
                sharedEnv.ChickenMaybeLeaveWhenUfoRarity()
            end

            updateUfuStatus(live, eventId, phase, deadline, bodyState, carrying)
            task.wait(live and 0.25 or 0.5)
        end
    end)
end

-- Upcoming-event webhook refresh loop.  It runs independently from Auto
-- Chaos, coalesces an in-flight request, and edits one Discord message so a
-- five-second countdown does not create a new message every tick.
task.spawn(function()
    while sharedEnv.ChickenArenaGeneration == generation do
        if type(sharedEnv.ChickenWebhookUpcomingEventsUpdate) == "function"
            and type(sharedEnv.ChickenWebhookState) == "table"
            and sharedEnv.ChickenWebhookState.upcomingEnabled == true then
            pcall(sharedEnv.ChickenWebhookUpcomingEventsUpdate, false)
        end
        task.wait(1)
    end
end)

-- Auto Fuse runs as one guarded loop per script generation.  live_reload
-- increments ChickenArenaGeneration, so the previous loop exits before the
-- replacement can issue another Fuse/Sell request.
task.spawn(function()
    local nextRosterRefresh = 0
    while sharedEnv.ChickenArenaGeneration == generation do
        local fuseState = sharedEnv.ChickenAutoFuseState
        if type(fuseState) == "table" then
            if os.clock() >= nextRosterRefresh then
                nextRosterRefresh = os.clock() + 2
                if type(sharedEnv.ChickenAutoFuseRefresh) == "function" then
                    pcall(sharedEnv.ChickenAutoFuseRefresh)
                end
            end
            if fuseState.enabled and type(sharedEnv.ChickenAutoFuseRunCycle) == "function" then
                pcall(sharedEnv.ChickenAutoFuseRunCycle)
            end
            if type(sharedEnv.ChickenAutoFuseStatus) == "function" then
                pcall(sharedEnv.ChickenAutoFuseStatus, false)
            end
        end
        task.wait(0.25)
    end
end)

-- Auto Promote runs independently from Auto Fuse but waits for an in-flight
-- fuse request before consuming any material.  The selected target/material
-- ids are re-read from the replicated roster for every request, so a reload
-- or a completed promotion cannot make the loop reuse stale chickens.
task.spawn(function()
    local nextRosterRefresh = 0
    while sharedEnv.ChickenArenaGeneration == generation do
        local promoteState = sharedEnv.ChickenPromoteState
        if type(promoteState) == "table" then
            if os.clock() >= nextRosterRefresh then
                nextRosterRefresh = os.clock() + 2
                if type(sharedEnv.ChickenPromoteRefresh) == "function" then
                    pcall(sharedEnv.ChickenPromoteRefresh)
                end
            end
            if promoteState.enabled == true
                and type(sharedEnv.ChickenPromoteRunCycle) == "function" then
                pcall(sharedEnv.ChickenPromoteRunCycle, false)
            end
            if type(sharedEnv.ChickenPromoteStatus) == "function" then
                pcall(sharedEnv.ChickenPromoteStatus, false)
            end
        end
        task.wait(0.35)
    end
end)

-- Feeder cycle recovery: when every Feeder is empty at the same time, the
-- game's existing Coop order can keep the chicken circling its previous target
-- after the next refill. Also recover the less obvious case where one feeder
-- has refilled but the chicken remains idle at the previous target instead of
-- selecting the next ready feeder. This is deliberately limited to the real
-- Coop/corral state and never runs during Tower/Arena.
task.spawn(function()
    local allFeedersWereEmpty = false
    local emptyHoldActive = false
    local lastRecoveryAt = 0
    local lastProgressAt = os.clock()
    local lastActivityAt = os.clock()
    local progressAnchor
    local retargetAt = 0
    local retargetCooldownAt = 0
    while sharedEnv.ChickenArenaGeneration == generation do
        local inCoop = false
        if ChickenMode then
            pcall(function()
                inCoop = ChickenMode.order() == "coop" and ChickenMode.where() == "corral"
            end)
        end

        if sharedEnv.ChickenFeederWatchdog and (inCoop or emptyHoldActive or retargetAt > 0) then
            local coop = DataService.client:get({"coop"}) or {}
            local generators = type(coop.generators) == "table" and coop.generators or {}
            local allEmpty = #generators > 0
            local hasFood = false
            for _, generator in ipairs(generators) do
                local corn = tonumber(generator.corn) or 0
                if corn > 0 then
                    allEmpty = false
                    hasFood = true
                end
            end

            -- Sample the real owned Coop chicken. Its replicated `pose`
            -- becomes `peck` while it is actually eating; a stationary
            -- `idle` chicken with food available is the stuck signature.
            local body
            local bodies = workspace:FindFirstChild("ChickenBodies")
            if bodies then
                for _, item in ipairs(bodies:GetChildren()) do
                    if item:IsA("BasePart")
                        and item.Name:sub(1, 17) == "ChickenBody_coop:"
                        and item:GetAttribute("ovOwner") == Players.LocalPlayer.UserId then
                        body = item
                        break
                    end
                end
            end
            if body then
                local position = body.Position
                if not progressAnchor then
                    progressAnchor = position
                elseif (position - progressAnchor).Magnitude >= 4 then
                    -- Small back-and-forth pathfinding jitter is not real
                    -- progress. Advance the watchdog window only after the
                    -- chicken has moved a meaningful distance.
                    progressAnchor = position
                    lastProgressAt = os.clock()
                end
                if body:GetAttribute("pose") == "peck" then
                    lastActivityAt = os.clock()
                end
            else
                progressAnchor = nil
                lastProgressAt = os.clock()
                lastActivityAt = os.clock()
            end

            local setChickenOrder = remotes:FindFirstChild("SetChickenOrder")
            -- Follow briefly to clear the server's previous feeder target,
            -- then issue Coop again so the normal target selector starts from
            -- the first feeder that currently has food.
            if retargetAt > 0 and os.clock() >= retargetAt then
                if setChickenOrder and setChickenOrder:IsA("RemoteEvent") and hasFood then
                    pcall(function()
                        setChickenOrder:FireServer("coop")
                    end)
                    print("[Feeder Watchdog] refreshed Coop target after stuck feeder")
                end
                retargetAt = 0
                lastProgressAt = os.clock()
                lastActivityAt = os.clock()
            end

            if allEmpty then
                if not emptyHoldActive and inCoop then
                    if setChickenOrder and setChickenOrder:IsA("RemoteEvent") then
                        pcall(function()
                            -- Follow is the game's supported idle order. It
                            -- stops the chicken from retargeting empty feeders.
                            setChickenOrder:FireServer("follow")
                        end)
                        print("[Feeder Watchdog] all Feeders empty; paused Coop target")
                    end
                    emptyHoldActive = true
                end
                allFeedersWereEmpty = true
            elseif emptyHoldActive and hasFood and os.clock() - lastRecoveryAt >= 2 then
                if setChickenOrder and setChickenOrder:IsA("RemoteEvent") then
                    pcall(function()
                        setChickenOrder:FireServer("coop")
                    end)
                    lastRecoveryAt = os.clock()
                    print("[Feeder Watchdog] Feeders refilled; restored Coop target")
                end
                emptyHoldActive = false
                allFeedersWereEmpty = false
            elseif inCoop
                and hasFood
                and not emptyHoldActive
                and retargetAt == 0
                and os.clock() >= retargetCooldownAt
                and os.clock() - lastProgressAt >= 6
                and os.clock() - lastActivityAt >= 3 then
                if setChickenOrder and setChickenOrder:IsA("RemoteEvent") then
                    pcall(function()
                        setChickenOrder:FireServer("follow")
                    end)
                    retargetAt = os.clock() + 0.45
                    retargetCooldownAt = os.clock() + 8
                    print("[Feeder Watchdog] Coop chicken stuck; refreshing feeder target")
                end
            end
        else
            if not sharedEnv.ChickenFeederWatchdog then
                emptyHoldActive = false
                allFeedersWereEmpty = false
                retargetAt = 0
                retargetCooldownAt = 0
            elseif not emptyHoldActive then
                allFeedersWereEmpty = false
            end
        end

        task.wait(0.5)
    end
end)

local function parsePower(value)
    if type(value) == "number" then
        return value
    end

    local amount, suffix = string.match(tostring(value), "([%d%.]+)%s*([KMBT]?)")
    amount = tonumber(amount)
    if not amount then
        return math.huge
    end

    local multipliers = {
        K = 1e3,
        M = 1e6,
        B = 1e9,
        T = 1e12,
    }
    return amount * (multipliers[suffix] or 1)
end

local function formatPower(value)
    if value == math.huge then
        return "?"
    end

    local sign = value < 0 and "-" or ""
    value = math.abs(value)
    if value >= 1e9 then
        return sign .. string.format("%.2fB", value / 1e9)
    elseif value >= 1e6 then
        return sign .. string.format("%.2fM", value / 1e6)
    elseif value >= 1e3 then
        return sign .. string.format("%.2fK", value / 1e3)
    end
    return sign .. string.format("%.0f", value)
end

local function formatCountdown(value)
    local seconds = math.max(0, math.ceil(tonumber(value) or 0))
    return string.format("%02d:%02d", math.floor(seconds / 60), seconds % 60)
end

do
-- Arena Combat ESP ---------------------------------------------------------
-- ArenaBattleState already contains the authoritative combat snapshot used by
-- the game's own Arena HUD: myHpPct, oppHpPct and incremental hit records.
-- Mirror those values in a small executor overlay so HP percentages and damage
-- remain visible while the Arena window is minimized or another tab is open.
local arenaBattleStateRemote = remotes:WaitForChild("ArenaBattleState")
local arenaCombatEsp = {
    gui = nil,
    panel = nil,
    create = nil,
    title = nil,
    youLabel = nil,
    oppLabel = nil,
    youSkillLabel = nil,
    oppSkillLabel = nil,
    youBar = nil,
    oppBar = nil,
    dpsLabel = nil,
    totalLabel = nil,
    youMovesLabel = nil,
    oppMovesLabel = nil,
    enabled = sharedEnv.ChickenArenaCombatESPEnabled == true,
    active = false,
    dealt = 0,
    taken = 0,
    lastHit = "LAST —",
    lastRoundMoveStats = {},
    youSkill = "—",
    oppSkill = "—",
    youSkillAt = 0,
    oppSkillAt = 0,
    skillHoldSeconds = 3.5,
    skillMode = "ARENA",
    skillToken = 0,
    skillOwnerRefreshBusy = false,
    skillOwnerRefreshAt = 0,
    lastElapsed = 0,
    lastUiUpdate = 0,
    lastMetricsUpdate = 0,
    startedAt = 0,
    moveStats = {},
    moveNames = {},
    -- ArenaBattleState hit records contain the victim side/slot, not the
    -- chicken/ability that caused the damage.  Keep a short caster timeline
    -- from ChickenFx so damage rows are attributed to the source skill.
    castHistory = {
        you = {},
        opp = {},
    },
    castDedupe = {},
    moveNameRefreshBusy = false,
    finishToken = 0,
}

local arenaAbilityNames = {}
pcall(function()
    local catalog = loadModule(ReplicatedStorage.Content.Catalog)
    for key, ability in pairs((catalog and catalog.abilities) or {}) do
        if type(ability) == "table" then
            local id = ability.id or key
            local name = ability.name or id
            if id and name then
                arenaAbilityNames[string.lower(tostring(id))] = tostring(name)
            end
        end
    end
end)

-- Give each ability a stable, readable color in the combat overlay.  Known
-- abilities use intentional colors; any new ability receives a deterministic
-- palette color so it stays consistent for the rest of the session.
local arenaSkillColors = {
    ["royal flush"] = "#F6C453",
    ["reaction ring"] = "#7EE787",
    ["stormcall"] = "#66B3FF",
    ["voodoo"] = "#C792EA",
    ["black sun cataclysm"] = "#FF7B72",
    ["safe light"] = "#FFE08A",
    ["devil's due"] = "#F07178",
    ["devils due"] = "#F07178",
    ["ascendant core"] = "#FF9F43",
    ["turbo boost"] = "#F78C6C",
    ["metamorphosis"] = "#82AAFF",
    ["suit up"] = "#00D4FF",
}
local arenaSkillPalette = {
    "#F6C453", "#66B3FF", "#C792EA", "#7EE787",
    "#FF7B72", "#FF9F43", "#F78C6C", "#82AAFF",
}

local function richTextEscape(value)
    local text = tostring(value or "")
    text = string.gsub(text, "&", "&amp;")
    text = string.gsub(text, "<", "&lt;")
    text = string.gsub(text, ">", "&gt;")
    return text
end

local function arenaSkillColor(name)
    local raw = tostring(name or "")
    local known = arenaSkillColors[string.lower(raw)]
    if known then
        return known
    end
    local hash = 0
    for index = 1, #raw do
        hash += (string.byte(raw, index) or 0) * index
    end
    return arenaSkillPalette[(hash % #arenaSkillPalette) + 1]
end

local function arenaSkillMarkup(name)
    local text = tostring(name or "—")
    return "<font color=\"" .. arenaSkillColor(text) .. "\">"
        .. richTextEscape(text) .. "</font>"
end

local function skillLabelText(side, skill)
    local upperSide = side == "you" and "YOU" or "OPP"
    local sideColor = side == "you" and "#77EBAA" or "#FF9578"
    return "<font color=\"" .. sideColor .. "\">✨ " .. upperSide
        .. " SKILL</font>  " .. arenaSkillMarkup(skill)
end

local function arenaHitExplicitName(hit)
    if type(hit) ~= "table" then
        return nil
    end
    local candidate = hit.abilityName or hit.ability or hit.skillName
        or hit.skill or hit.moveName or hit.move or hit.attackName
        or hit.attack or hit.abilityId or hit.skillId or hit.moveId
    if type(candidate) == "table" then
        candidate = candidate.name or candidate.id or candidate.ability
    end
    if candidate == nil or tostring(candidate) == "" then
        return nil
    end
    local raw = tostring(candidate)
    return arenaAbilityNames[string.lower(raw)] or raw
end

local function arenaCastWindow(rawName, displayName)
    local key = string.lower(tostring(rawName or displayName or ""))
    -- Most ability damage lands during the cast and its short recovery.  A
    -- bounded window prevents ordinary attacks many seconds later from being
    -- mislabeled as the last special.  Longer persistent zones are given a
    -- little extra time, while the common burst abilities stay tighter.
    if key == "reactionring" or key == "reaction ring"
        or key == "lavafloor" or key == "lava floor"
        or key == "burnline" or key == "burn line"
        or key == "minefield" then
        return 5
    end
    return 3
end

local function arenaRecordCast(side, displayName, rawName, payloadId, effect, now)
    local history = arenaCombatEsp.castHistory[side]
    if type(history) ~= "table" then
        return nil
    end
    now = tonumber(now) or os.clock()
    local raw = tostring(rawName or displayName or "")
    local display = tostring(displayName or raw)
    local id = tostring(payloadId or "")
    local dedupeKey = string.lower(id .. "|" .. raw)
    local previous = arenaCombatEsp.castDedupe[dedupeKey]
    -- ChickenFx normally emits ability.banner immediately followed by the
    -- ability's .cast event.  Treat that pair as one cast.
    if type(previous) == "table" and now - (previous.at or 0) <= 0.15 then
        previous.at = now
        previous.effect = effect
        previous.name = display
        previous.expiresAt = now + arenaCastWindow(raw, display)
        return previous
    end
    local cast = {
        at = now,
        name = display,
        raw = raw,
        id = id,
        effect = effect,
        expiresAt = now + arenaCastWindow(raw, display),
    }
    table.insert(history, cast)
    arenaCombatEsp.castDedupe[dedupeKey] = cast
    -- Keep the timeline bounded; reset() clears it at every new battle.
    while #history > 24 do
        table.remove(history, 1)
    end
    return cast
end

local function arenaHitMoveName(hit, victimSide, now)
    local explicit = arenaHitExplicitName(hit)
    if explicit then
        return explicit
    end

    -- `side` is the victim side.  The caster is therefore on the other side.
    local attackerSide = tostring(victimSide or (type(hit) == "table" and hit.side or "")) == "mine"
        and "opp" or "you"
    local history = arenaCombatEsp.castHistory[attackerSide]
    now = tonumber(now) or os.clock()
    if type(history) == "table" then
        for index = #history, 1, -1 do
            local cast = history[index]
            if type(cast) == "table" then
                local age = now - (tonumber(cast.at) or now)
                if age >= -0.25 and now <= (tonumber(cast.expiresAt) or 0) then
                    return tostring(cast.name or "Basic ATK")
                end
                if age > 8 then
                    break
                end
            end
        end
    end
    -- No source cast was observed for this hit.  Keep it explicit rather than
    -- guessing from the target slot (which is what caused the old mismatch).
    return "Basic ATK"
end

-- Keep the latest cast separate for each side.  ArenaBattleState labels a hit
-- by its victim (`mine`/`opp`), while ChickenFx labels the caster in `id`; the
-- two helpers below normalize both sources into YOU/OPP skill labels.
arenaCombatEsp.refreshSkillLabels = function(now)
    now = tonumber(now) or os.clock()
    local hold = math.max(0.5, tonumber(arenaCombatEsp.skillHoldSeconds) or 3.5)
    local you = arenaCombatEsp.youSkill or "—"
    local opp = arenaCombatEsp.oppSkill or "—"
    if (arenaCombatEsp.youSkillAt or 0) <= 0 or now - arenaCombatEsp.youSkillAt > hold then
        you = "—"
    end
    if (arenaCombatEsp.oppSkillAt or 0) <= 0 or now - arenaCombatEsp.oppSkillAt > hold then
        opp = "—"
    end
    if arenaCombatEsp.youSkillLabel then
        arenaCombatEsp.youSkillLabel.Text = skillLabelText("you", you)
    end
    if arenaCombatEsp.oppSkillLabel then
        arenaCombatEsp.oppSkillLabel.Text = skillLabelText("opp", opp)
    end
end

arenaCombatEsp.inferSkillSide = function(entityId, params)
    local idText = tostring(entityId or "")
    local lowerId = string.lower(idText)
    -- Arena IDs are authoritative and must be checked before the local user
    -- id (the opponent id can contain the same match/user prefix).
    if string.find(lowerId, ":mine:", 1, true)
        or string.find(lowerId, ":you:", 1, true) then
        return "you"
    end
    if string.find(lowerId, ":opp:", 1, true)
        or string.find(lowerId, ":enemy:", 1, true) then
        return "opp"
    end

    local localPlayer = Players.LocalPlayer
    local userId = localPlayer and tostring(localPlayer.UserId) or ""
    if userId ~= "" and string.find(idText, userId, 1, true) then
        return "you"
    end

    -- In Chaos the caster id is commonly the owned roster id rather than an
    -- arena slot id.  Reuse the roster cache when it is already available.
    local rosterById = sharedEnv.ChickenFastIncubatorRosterById
    if type(rosterById) == "table" then
        if rosterById[idText] ~= nil then
            return "you"
        end
        for knownId in pairs(rosterById) do
            local knownText = tostring(knownId)
            if knownText ~= "" and #knownText >= 8
                and string.find(idText, knownText, 1, true) then
                return "you"
            end
        end
    end

    -- Pit bodies expose the owner user id through the same replicated
    -- `ovOwner` attribute used by the game's own chicken billboards.  This
    -- resolves a Chaos caster immediately, even before the roster refresh
    -- above has completed.
    local bodies = workspace:FindFirstChild("ChickenBodies")
    if bodies then
        for _, body in ipairs(bodies:GetChildren()) do
            if tostring(body:GetAttribute("entityId") or "") == idText then
                local owner = tonumber(body:GetAttribute("ovOwner"))
                if owner and localPlayer and owner == localPlayer.UserId then
                    return "you"
                elseif owner and owner ~= 0 then
                    return "opp"
                end
            end
        end
    end

    local victimId = type(params) == "table" and params.victimId or nil
    local victimText = tostring(victimId or "")
    local lowerVictim = string.lower(victimText)
    if string.find(lowerVictim, ":mine:", 1, true)
        or string.find(lowerVictim, ":you:", 1, true) then
        return "opp"
    end
    if string.find(lowerVictim, ":opp:", 1, true)
        or string.find(lowerVictim, ":enemy:", 1, true) then
        return "you"
    end
    if userId ~= "" and string.find(victimText, userId, 1, true) then
        return "opp"
    end
    return nil
end

arenaCombatEsp.refreshSkillOwnerCache = function()
    local now = os.clock()
    if arenaCombatEsp.skillOwnerRefreshBusy
        or now - (arenaCombatEsp.skillOwnerRefreshAt or 0) < 5 then
        return
    end
    arenaCombatEsp.skillOwnerRefreshBusy = true
    arenaCombatEsp.skillOwnerRefreshAt = now
    task.spawn(function()
        local ok, data = pcall(function()
            return DataService.client:get({"roster"}) or {}
        end)
        if ok and type(data) == "table" then
            local roster = data.roster or data
            local byId = {}
            for _, chicken in ipairs(type(roster) == "table" and roster.chickens or {}) do
                if type(chicken) == "table" and type(chicken.id) == "string" then
                    byId[chicken.id] = chicken
                end
            end
            if next(byId) then
                sharedEnv.ChickenFastIncubatorRosterById = byId
                sharedEnv.ChickenFastIncubatorRosterAt = os.clock()
            end
        end
        arenaCombatEsp.skillOwnerRefreshBusy = false
    end)
end

arenaCombatEsp.captureSkillFx = function(payload)
    -- Respect the Arena page toggle.  ChickenFx can arrive independently of
    -- ArenaBattleState, so without this guard a disabled ESP would pop back
    -- open whenever any ability effect was broadcast.
    if arenaCombatEsp.enabled ~= true then
        return
    end
    if type(payload) ~= "table" then
        return
    end
    local params = payload.params
    local effect = string.lower(tostring(payload.effect or ""))
    local candidate = type(params) == "table"
        and (params.abilityId or params.ability or params.skillId or params.skillName)
        or nil
    if type(candidate) == "table" then
        candidate = candidate.name or candidate.id or candidate.abilityId
    end
    -- Ability effects are emitted as `ability.banner` followed by
    -- `<ability>.cast`; ignore hit/status/zone ticks so a single cast does not
    -- make the displayed skill jump between internal effect names.
    local isCast = effect == "ability.banner"
        or string.sub(effect, -5) == ".cast"
    if (candidate == nil or tostring(candidate) == "") and isCast then
        local prefix = string.match(effect, "^([^%.]+)")
        if prefix and prefix ~= "ability" and prefix ~= "status" then
            candidate = prefix
        end
    end
    if not isCast or candidate == nil or tostring(candidate) == "" then
        return
    end

    local side = arenaCombatEsp.inferSkillSide(payload.id, params)
    if not side then
        arenaCombatEsp.refreshSkillOwnerCache()
        return
    end
    local raw = tostring(candidate)
    local display = arenaAbilityNames[string.lower(raw)] or raw
    local idText = string.lower(tostring(payload.id or ""))
    arenaCombatEsp.skillMode = string.find(idText, "arena:", 1, true)
        and "ARENA" or "CHAOS"
    local now = os.clock()
    arenaRecordCast(side, display, raw, payload.id, effect, now)
    if side == "you" then
        arenaCombatEsp.youSkill = display
        arenaCombatEsp.youSkillAt = now
    else
        arenaCombatEsp.oppSkill = display
        arenaCombatEsp.oppSkillAt = now
    end
    arenaCombatEsp.skillToken += 1
    arenaCombatEsp.create()
    arenaCombatEsp.active = true
    arenaCombatEsp.gui.Enabled = true
    if arenaCombatEsp.skillMode ~= "ARENA" then
        -- Chaos does not publish Arena HP/damage snapshots; clear those fields
        -- rather than showing stale Arena numbers beside the skill names.
        arenaCombatEsp.title.Text = "⚔️ CHAOS • COMBAT SKILL"
        arenaCombatEsp.youLabel.Text = "🟢 YOU   --"
        arenaCombatEsp.oppLabel.Text = "🔴 OPP   --"
        arenaCombatEsp.youBar.Size = UDim2.fromScale(0, 1)
        arenaCombatEsp.oppBar.Size = UDim2.fromScale(0, 1)
        arenaCombatEsp.dpsLabel.Text = "⚡ DPS --"
        arenaCombatEsp.totalLabel.Text = "📊 TOTAL --"
        arenaCombatEsp.youMovesLabel.Text = "💥 YOU DAMAGE  —\nLAST DAMAGE  —"
        arenaCombatEsp.oppMovesLabel.Text = "💢 OPP DAMAGE  —\nLAST DAMAGE  —"
    end
    arenaCombatEsp.refreshSkillLabels(now)
    local token = arenaCombatEsp.skillToken
    task.delay(arenaCombatEsp.skillHoldSeconds, function()
        if arenaCombatEsp.skillToken == token and arenaCombatEsp.skillMode ~= "ARENA" then
            arenaCombatEsp.refreshSkillLabels(os.clock())
            arenaCombatEsp.active = false
            if arenaCombatEsp.gui then
                arenaCombatEsp.gui.Enabled = false
            end
        end
    end)
end

local function arenaMoveSummary(moveStats, direction, labelPrefix)
    local prefix = labelPrefix
        or (direction == "in" and "💢 OPP DAMAGE  " or "💥 YOU DAMAGE  ")
    local prefixColor
    if type(labelPrefix) == "string" and string.find(labelPrefix, "LAST DAMAGE", 1, true) then
        prefixColor = "#FFFFFF"
    else
        prefixColor = direction == "in" and "#FFB0A0" or "#FFD28A"
    end
    local damageColor = "#FFFFFF"
    local hitsColor = "#FFFFFF"
    local grouped = {}
    for key, stats in pairs(moveStats) do
        if type(stats) == "table" then
            local amount = direction == "in" and (stats.incoming or 0) or (stats.out or 0)
            if amount > 0 then
                local name = tostring(stats.name or key)
                local groupKey = string.lower(name)
                local row = grouped[groupKey]
                if not row then
                    row = {
                        name = name,
                        out = 0,
                        incoming = 0,
                        outHits = 0,
                        inHits = 0,
                    }
                    grouped[groupKey] = row
                end
                row.out += stats.out or 0
                row.incoming += stats.incoming or 0
                row.outHits += stats.outHits or 0
                row.inHits += stats.inHits or 0
            end
        end
    end
    local rows = {}
    for _, row in pairs(grouped) do
        table.insert(rows, row)
    end
    table.sort(rows, function(a, b)
        local left = direction == "in" and a.incoming or a.out
        local right = direction == "in" and b.incoming or b.out
        if left == right then
            local leftHits = direction == "in" and a.inHits or a.outHits
            local rightHits = direction == "in" and b.inHits or b.outHits
            return leftHits > rightHits
        end
        return left > right
    end)
    local parts = {}
    for index = 1, math.min(#rows, 4) do
        local row = rows[index]
        local amount = direction == "in" and row.incoming or row.out
        local hits = direction == "in" and row.inHits or row.outHits
        local part = arenaSkillMarkup(row.name) .. " "
            .. "<font color=\"" .. damageColor .. "\"><b>"
            .. formatPower(amount) .. "</b></font>"
            .. "<font color=\"" .. hitsColor .. "\"> ("
            .. tostring(hits) .. "x)</font>"
        table.insert(parts, part)
    end
    if #rows > #parts then
        table.insert(parts, "+" .. tostring(#rows - #parts) .. " more")
    end
    if #parts == 0 then
        return "<font color=\"" .. prefixColor .. "\">"
            .. richTextEscape(prefix) .. "—</font>"
    end
    return "<font color=\"" .. prefixColor .. "\">"
        .. richTextEscape(prefix) .. "</font>" .. table.concat(parts, " • ")
end

local function cloneArenaMoveStats(source)
    local copy = {}
    if type(source) ~= "table" then
        return copy
    end
    for key, stats in pairs(source) do
        if type(stats) == "table" then
            copy[key] = {
                name = stats.name,
                sourceSide = stats.sourceSide,
                side = stats.side,
                slot = stats.slot,
                targetSlot = stats.targetSlot,
                out = stats.out or 0,
                incoming = stats.incoming or 0,
                outHits = stats.outHits or 0,
                inHits = stats.inHits or 0,
            }
        end
    end
    return copy
end

local arenaStateModule
pcall(function()
    local playerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
    local ui = playerScripts:WaitForChild("UI")
    local twoD = ui:WaitForChild("2d")
    local arena = twoD:WaitForChild("Arena")
    arenaStateModule = require(arena:WaitForChild("ArenaState"))
end)

function arenaCombatEsp.refreshMoveNames(sourceView)
    local names = {}
    local view = sourceView
    local ok = true
    if type(view) ~= "table" then
        ok, view = pcall(function()
            return arenaStateModule and arenaStateModule.view()
        end)
    end
    if type(view) ~= "table" and type(arenaViewCache) == "table" then
        view = arenaViewCache.data
    end
    if not ok or type(view) ~= "table" then
        arenaCombatEsp.moveNames = names
        return
    end

    local function addTeam(team, side)
        if type(team) ~= "table" then
            return
        end
        for slot, chicken in pairs(team) do
            if type(chicken) == "table" then
                local id = chicken.abilityId or chicken.ability
                if id then
                    local raw = tostring(id)
                    names[side .. ":" .. tostring(slot)] = arenaAbilityNames[string.lower(raw)] or raw
                end
            end
        end
    end

    -- Keep a source-side roster map for diagnostics.  ArenaBattleState hit
    -- records use `side`/`slot` for the victim, so these names must not be
    -- used to label damage rows; those rows are resolved from ChickenFx casts.
    addTeam(view.team, "you")
    local opponents = view.opponents
    if type(opponents) == "table" then
        local cursor = tonumber(view.cursor) or 0
        local opponent = opponents[math.min(cursor + 1, #opponents)]
        if type(opponent) == "table" then
            addTeam(opponent.team, "opp")
        end
    end
    arenaCombatEsp.moveNames = names
end

function arenaCombatEsp.requestMoveNames()
    if arenaCombatEsp.moveNameRefreshBusy then
        return
    end
    arenaCombatEsp.moveNameRefreshBusy = true
    task.spawn(function()
        local ok, response = pcall(function()
            return arenaGetView:InvokeServer()
        end)
        if ok and sharedEnv.ChickenArenaGeneration == generation then
            local view = type(response) == "table" and (response.data or response) or nil
            if type(view) == "table" then
                arenaCombatEsp.refreshMoveNames(view)
            end
        end
        arenaCombatEsp.moveNameRefreshBusy = false
    end)
end

local function combatPct(value)
    local number = tonumber(value)
    if not number then
        return nil
    end
    if number > 1 then
        number = number / 100
    end
    return math.clamp(number, 0, 1)
end

local function combatPctText(value)
    local pct = combatPct(value)
    if pct == nil then
        return "--"
    end
    return string.format("%d%%", math.floor(pct * 100 + 0.5))
end

local function combatLabel(parent, name, text, position, size, textSize, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = color
    label.TextSize = textSize
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextStrokeTransparency = 0.7
    label.Parent = parent
    return label
end

function arenaCombatEsp.create()
    if arenaCombatEsp.gui and arenaCombatEsp.gui.Parent then
        return
    end

    local parent = CoreGui
    pcall(function()
        if type(gethui) == "function" then
            local hidden = gethui()
            if hidden then
                parent = hidden
            end
        end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "ChickenArenaCombatESP"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 2000
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = false
    gui.Parent = parent

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(1, 0)
    -- Start in an uncluttered top-right position.  The panel remains draggable
    -- so the player can move it if that corner overlaps the game's buttons.
    panel.Position = UDim2.new(1, -20, 0, 70)
    panel.Size = UDim2.fromOffset(640, 300)
    panel.Active = true
    panel.Draggable = true
    panel.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
    panel.BackgroundTransparency = 0.12
    panel.BorderSizePixel = 0
    panel.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = panel

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(110, 118, 138)
    stroke.Transparency = 0.25
    stroke.Thickness = 1
    stroke.Parent = panel

    local title = combatLabel(
        panel,
        "Title",
        "⚔️ ARENA • COMBAT ESP",
        UDim2.fromOffset(12, 5),
        UDim2.new(1, -24, 0, 25),
        15,
        Color3.fromRGB(255, 220, 115)
    )

    local youRow = Instance.new("Frame")
    youRow.Name = "YouRow"
    youRow.BackgroundTransparency = 1
    youRow.Position = UDim2.fromOffset(12, 31)
    youRow.Size = UDim2.new(1, -24, 0, 24)
    youRow.Parent = panel
    local youLabel = combatLabel(
        youRow,
        "Value",
        "🟢 YOU   --",
        UDim2.fromOffset(0, 0),
        UDim2.fromOffset(112, 24),
        13,
        Color3.fromRGB(115, 235, 170)
    )
    local youBack = Instance.new("Frame")
    youBack.Name = "BarBack"
    youBack.Position = UDim2.fromOffset(120, 3)
    youBack.Size = UDim2.new(1, -120, 0, 16)
    youBack.BackgroundColor3 = Color3.fromRGB(45, 54, 65)
    youBack.BorderSizePixel = 0
    youBack.Parent = youRow
    local youBackCorner = Instance.new("UICorner")
    youBackCorner.CornerRadius = UDim.new(1, 0)
    youBackCorner.Parent = youBack
    local youBar = Instance.new("Frame")
    youBar.Name = "Fill"
    youBar.Size = UDim2.fromScale(0, 1)
    youBar.BackgroundColor3 = Color3.fromRGB(55, 210, 135)
    youBar.BorderSizePixel = 0
    youBar.Parent = youBack
    local youBarCorner = Instance.new("UICorner")
    youBarCorner.CornerRadius = UDim.new(1, 0)
    youBarCorner.Parent = youBar

    local oppRow = Instance.new("Frame")
    oppRow.Name = "OpponentRow"
    oppRow.BackgroundTransparency = 1
    oppRow.Position = UDim2.fromOffset(12, 57)
    oppRow.Size = UDim2.new(1, -24, 0, 24)
    oppRow.Parent = panel
    local oppLabel = combatLabel(
        oppRow,
        "Value",
        "🔴 OPP   --",
        UDim2.fromOffset(0, 0),
        UDim2.fromOffset(112, 24),
        13,
        Color3.fromRGB(255, 125, 125)
    )
    local oppBack = Instance.new("Frame")
    oppBack.Name = "BarBack"
    oppBack.Position = UDim2.fromOffset(120, 3)
    oppBack.Size = UDim2.new(1, -120, 0, 16)
    oppBack.BackgroundColor3 = Color3.fromRGB(65, 48, 55)
    oppBack.BorderSizePixel = 0
    oppBack.Parent = oppRow
    local oppBackCorner = Instance.new("UICorner")
    oppBackCorner.CornerRadius = UDim.new(1, 0)
    oppBackCorner.Parent = oppBack
    local oppBar = Instance.new("Frame")
    oppBar.Name = "Fill"
    oppBar.Size = UDim2.fromScale(0, 1)
    oppBar.BackgroundColor3 = Color3.fromRGB(235, 75, 85)
    oppBar.BorderSizePixel = 0
    oppBar.Parent = oppBack
    local oppBarCorner = Instance.new("UICorner")
    oppBarCorner.CornerRadius = UDim.new(1, 0)
    oppBarCorner.Parent = oppBar

    local youSkillLabel = combatLabel(
        panel,
        "YouSkill",
        "✨ YOU SKILL  —",
        UDim2.fromOffset(12, 83),
        UDim2.new(1, -24, 0, 20),
        11,
        Color3.fromRGB(115, 235, 170)
    )
    youSkillLabel.RichText = true
    local oppSkillLabel = combatLabel(
        panel,
        "OpponentSkill",
        "✨ OPP SKILL  —",
        UDim2.fromOffset(12, 158),
        UDim2.new(1, -24, 0, 20),
        11,
        Color3.fromRGB(255, 145, 120)
    )
    oppSkillLabel.RichText = true
    local youMovesLabel = combatLabel(
        panel,
        "YouDamage",
        "💥 YOU DAMAGE  —",
        UDim2.fromOffset(12, 105),
        UDim2.new(1, -24, 0, 50),
        11,
        Color3.fromRGB(255, 205, 130)
    )
    youMovesLabel.RichText = true
    youMovesLabel.TextWrapped = true
    youMovesLabel.LineHeight = 1.12
    youMovesLabel.TextYAlignment = Enum.TextYAlignment.Top

    local oppMovesLabel = combatLabel(
        panel,
        "OpponentDamage",
        "💢 OPP DAMAGE  —",
        UDim2.fromOffset(12, 181),
        UDim2.new(1, -24, 0, 50),
        12,
        Color3.fromRGB(255, 175, 150)
    )
    oppMovesLabel.RichText = true
    oppMovesLabel.TextWrapped = true
    oppMovesLabel.LineHeight = 1.12
    oppMovesLabel.TextYAlignment = Enum.TextYAlignment.Top

    local dpsLabel = combatLabel(
        panel,
        "DPS",
        "⚡ DPS OUT 0  |  IN 0",
        UDim2.fromOffset(12, 235),
        UDim2.new(1, -24, 0, 20),
        11,
        Color3.fromRGB(150, 220, 255)
    )
    local totalLabel = combatLabel(
        panel,
        "Total",
        "📊 TOTAL OUT 0  |  IN 0",
        UDim2.fromOffset(12, 259),
        UDim2.new(1, -24, 0, 20),
        11,
        Color3.fromRGB(235, 235, 245)
    )
    arenaCombatEsp.gui = gui
    arenaCombatEsp.panel = panel
    arenaCombatEsp.title = title
    arenaCombatEsp.youLabel = youLabel
    arenaCombatEsp.oppLabel = oppLabel
    arenaCombatEsp.youSkillLabel = youSkillLabel
    arenaCombatEsp.oppSkillLabel = oppSkillLabel
    arenaCombatEsp.youMovesLabel = youMovesLabel
    arenaCombatEsp.oppMovesLabel = oppMovesLabel
    arenaCombatEsp.youBar = youBar
    arenaCombatEsp.oppBar = oppBar
    arenaCombatEsp.dpsLabel = dpsLabel
    arenaCombatEsp.totalLabel = totalLabel
    sharedEnv.ChickenArenaCombatESPGui = gui
end

function arenaCombatEsp.reset()
    arenaCombatEsp.dealt = 0
    arenaCombatEsp.taken = 0
    arenaCombatEsp.lastHit = "LAST —"
    if next(arenaCombatEsp.moveStats) ~= nil then
        arenaCombatEsp.lastRoundMoveStats = cloneArenaMoveStats(arenaCombatEsp.moveStats)
    end
    arenaCombatEsp.youSkill = "—"
    arenaCombatEsp.oppSkill = "—"
    arenaCombatEsp.youSkillAt = 0
    arenaCombatEsp.oppSkillAt = 0
    arenaCombatEsp.skillMode = "ARENA"
    arenaCombatEsp.skillToken += 1
    arenaCombatEsp.lastElapsed = 0
    arenaCombatEsp.lastUiUpdate = 0
    arenaCombatEsp.lastMetricsUpdate = 0
    arenaCombatEsp.startedAt = os.clock()
    arenaCombatEsp.moveStats = {}
    arenaCombatEsp.moveNames = {}
    arenaCombatEsp.castHistory = {
        you = {},
        opp = {},
    }
    arenaCombatEsp.castDedupe = {}
    arenaCombatEsp.refreshSkillLabels(os.clock())
end

function arenaCombatEsp.render(state)
    if arenaCombatEsp.enabled == false then
        return
    end
    if type(state) ~= "table" then
        return
    end
    arenaCombatEsp.create()

    local phase = string.lower(tostring(state.phase or ""))
    local duration = math.max(0, tonumber(state.duration) or 60)
    local elapsed = math.max(0, tonumber(state.elapsed) or 0)
    local now = os.clock()
    arenaCombatEsp.skillMode = "ARENA"
    if phase == "started"
        or (arenaCombatEsp.active and elapsed + 1 < arenaCombatEsp.lastElapsed) then
        arenaCombatEsp.reset()
        arenaCombatEsp.refreshMoveNames()
        if next(arenaCombatEsp.moveNames) == nil then
            -- ArenaState can be cleared for one frame during the transition.
            -- Fetch the current view off the event thread once, then relabel
            -- any slot-based hits that arrived during that transition.
            arenaCombatEsp.requestMoveNames()
        end
    end
    if phase == "started" or state.myHpPct ~= nil or state.oppHpPct ~= nil then
        arenaCombatEsp.active = true
        if arenaCombatEsp.startedAt <= 0 then
            arenaCombatEsp.startedAt = now
        end
        arenaCombatEsp.finishToken += 1
    end
    if arenaCombatEsp.active and next(arenaCombatEsp.moveNames) == nil then
        arenaCombatEsp.requestMoveNames()
    end
    arenaCombatEsp.lastElapsed = elapsed

    local dealtNow = 0
    local takenNow = 0
    if type(state.hits) == "table" then
        for _, hit in pairs(state.hits) do
            if type(hit) == "table" then
                local amount = tonumber(hit.amount)
                if not amount then
                    local parsed = parsePower(hit.amount)
                    amount = parsed ~= math.huge and parsed or 0
                end
                if amount > 0 then
                    local side = tostring(hit.side)
                    local slot = tonumber(hit.slot)
                    -- `side`/`slot` identify the victim in the server hit
                    -- payload.  Resolve the source from an explicit ability
                    -- field when present, otherwise from the short ChickenFx
                    -- caster timeline; never use the victim slot as a skill
                    -- name.
                    local attackerSide = side == "mine" and "opp" or "you"
                    local moveName = arenaHitMoveName(hit, side, now)
                    local moveKey = attackerSide .. ":" .. string.lower(moveName)
                    local move = arenaCombatEsp.moveStats[moveKey]
                    if not move then
                        move = {
                            name = moveName,
                            sourceSide = attackerSide,
                            side = side,
                            targetSlot = slot,
                            out = 0,
                            incoming = 0,
                            outHits = 0,
                            inHits = 0,
                        }
                        arenaCombatEsp.moveStats[moveKey] = move
                    elseif moveName ~= "Basic ATK" then
                        move.name = moveName
                    end
                    if side == "mine" then
                        if moveName ~= "Basic ATK" then
                            arenaCombatEsp.oppSkill = moveName
                            arenaCombatEsp.oppSkillAt = now
                        end
                        arenaCombatEsp.taken += amount
                        takenNow += amount
                        move.incoming += amount
                        move.inHits += 1
                    else
                        if moveName ~= "Basic ATK" then
                            arenaCombatEsp.youSkill = moveName
                            arenaCombatEsp.youSkillAt = now
                        end
                        arenaCombatEsp.dealt += amount
                        dealtNow += amount
                        move.out += amount
                        move.outHits += 1
                    end
                end
            end
        end
    end

    if dealtNow > 0 or takenNow > 0 then
        if dealtNow > 0 and takenNow > 0 then
            arenaCombatEsp.lastHit = "LAST OUT -" .. formatPower(dealtNow)
                .. "  |  IN -" .. formatPower(takenNow)
        elseif dealtNow > 0 then
            arenaCombatEsp.lastHit = "LAST OUT -" .. formatPower(dealtNow)
        else
            arenaCombatEsp.lastHit = "LAST IN -" .. formatPower(takenNow)
        end
    end

    -- Restore the pre-lag event-driven redraw cadence for this test.  Every
    -- authoritative ArenaBattleState snapshot updates the overlay, matching
    -- the behavior from before the temporary performance throttles.
    arenaCombatEsp.lastUiUpdate = now

    local combatSeconds = math.max(elapsed, now - (arenaCombatEsp.startedAt or now), 0.25)
    local dpsOut = arenaCombatEsp.dealt / combatSeconds
    local dpsIn = arenaCombatEsp.taken / combatSeconds

    arenaCombatEsp.title.Text = "⚔️ ARENA • COMBAT ESP  "
        .. formatCountdown(elapsed) .. "/" .. formatCountdown(duration)

    local myPct = combatPct(state.myHpPct)
    local oppPct = combatPct(state.oppHpPct)
    local mySuffix = state.myAlive == false and " KO" or ""
    local oppSuffix = state.oppAlive == false and " KO" or ""
    arenaCombatEsp.youLabel.Text = "🟢 YOU   " .. combatPctText(state.myHpPct) .. mySuffix
    arenaCombatEsp.oppLabel.Text = "🔴 OPP   " .. combatPctText(state.oppHpPct) .. oppSuffix
    arenaCombatEsp.youBar.Size = UDim2.new(myPct or 0, 0, 1, 0)
    arenaCombatEsp.oppBar.Size = UDim2.new(oppPct or 0, 0, 1, 0)
    arenaCombatEsp.lastMetricsUpdate = now
    arenaCombatEsp.dpsLabel.Text = "⚡ DPS OUT " .. formatPower(dpsOut)
        .. "  |  IN " .. formatPower(dpsIn)
    arenaCombatEsp.totalLabel.Text = "📊 TOTAL OUT " .. formatPower(arenaCombatEsp.dealt)
        .. "  |  IN " .. formatPower(arenaCombatEsp.taken)
    arenaCombatEsp.youMovesLabel.Text = arenaMoveSummary(arenaCombatEsp.moveStats, "out")
        .. "\n" .. arenaMoveSummary(
            arenaCombatEsp.lastRoundMoveStats,
            "out",
            "LAST DAMAGE  "
        )
    arenaCombatEsp.oppMovesLabel.Text = arenaMoveSummary(arenaCombatEsp.moveStats, "in")
        .. "\n" .. arenaMoveSummary(
            arenaCombatEsp.lastRoundMoveStats,
            "in",
            "LAST DAMAGE  "
        )
    arenaCombatEsp.refreshSkillLabels(now)
    arenaCombatEsp.gui.Enabled = arenaCombatEsp.active
end

function arenaCombatEsp.hide(delaySeconds)
    arenaCombatEsp.finishToken += 1
    local token = arenaCombatEsp.finishToken
    local delay = math.max(0, tonumber(delaySeconds) or 0)
    if delay > 0 then
        task.delay(delay, function()
            if arenaCombatEsp.finishToken == token then
                arenaCombatEsp.active = false
                if arenaCombatEsp.gui then
                    arenaCombatEsp.gui.Enabled = false
                end
            end
        end)
    else
        arenaCombatEsp.active = false
        if arenaCombatEsp.gui then
            arenaCombatEsp.gui.Enabled = false
        end
    end
end

sharedEnv.ChickenArenaCombatESP = arenaCombatEsp
sharedEnv.ChickenArenaCombatESPConnection = arenaBattleStateRemote.OnClientEvent:Connect(function(state)
    if sharedEnv.ChickenArenaGeneration == generation then
        pcall(function()
            arenaCombatEsp.render(state)
        end)
    end
end)
sharedEnv.ChickenArenaCombatESPResultConnection = arenaBattleResult.OnClientEvent:Connect(function()
    if sharedEnv.ChickenArenaGeneration == generation then
        arenaCombatEsp.hide(1.5)
    end
end)
if remotes:FindFirstChild("ChickenFx") then
    sharedEnv.ChickenArenaCombatESPFxConnection = remotes.ChickenFx.OnClientEvent:Connect(function(payload)
        if sharedEnv.ChickenArenaGeneration == generation then
            pcall(function()
                arenaCombatEsp.captureSkillFx(payload)
            end)
        end
    end)
end
if remotes:FindFirstChild("ChickenFxFast") then
    sharedEnv.ChickenArenaCombatESPFxFastConnection = remotes.ChickenFxFast.OnClientEvent:Connect(function(payload)
        if sharedEnv.ChickenArenaGeneration == generation then
            pcall(function()
                arenaCombatEsp.captureSkillFx(payload)
            end)
        end
    end)
end
end

local function isOwnedChickenInsideCoop()
    local player = Players.LocalPlayer
    local chickenPosition
    for _, body in ipairs(CollectionService:GetTagged("ChickenBody")) do
        if body:GetAttribute("ovOwner") == player.UserId then
            local ok, position = pcall(function()
                return body:IsA("Model") and body:GetPivot().Position or body.Position
            end)
            if ok and typeof(position) == "Vector3" then
                chickenPosition = position
            end
            break
        end
    end
    if not chickenPosition then
        return false
    end

    local coops = workspace:FindFirstChild("Coops")
    if not coops then
        return false
    end
    for _, coop in ipairs(coops:GetChildren()) do
        if coop:IsA("Model") and coop.Name ~= "CoopUI" then
            local ok, boxCFrame, boxSize = pcall(function()
                return coop:GetBoundingBox()
            end)
            if ok and boxCFrame and boxSize then
                local localPosition = boxCFrame:PointToObjectSpace(chickenPosition)
                -- A small margin handles the chicken's pivot being just inside
                -- the gate while its body extends across the boundary.
                if math.abs(localPosition.X) <= boxSize.X / 2 + 3
                    and math.abs(localPosition.Z) <= boxSize.Z / 2 + 3
                    and math.abs(localPosition.Y) <= boxSize.Y / 2 + 4 then
                    return true
                end
            end
        end
    end
    return false
end

local function getRebirthState()
    local tower = DataService.client:get({"tower"}) or {}
    local rebirth = DataService.client:get({"rebirth"}) or {}
    local variant = false
    pcall(function()
        variant = RebirthExperiment.armOf(game:GetService("Players").LocalPlayer) == RebirthExperiment.VARIANT
    end)

    local count = tonumber(rebirth.count) or 0
    local best = tonumber(tower.best) or 0
    local requirement = RebirthBonus.requirementFloorFor(count, variant)
    return tower, rebirth, count, best, requirement
end

-- The Rebirth window only enables its real confirm action when the chicken is
-- back at the coop/corral. Tower progress alone is not enough: the server
-- otherwise rejects the Rebirth request with the equivalent of notAtCoop.
local function isRebirthPromptReady()
    if not ChickenMode then
        return false
    end
    local order, where, bodyState
    local physicalAtCoop = false
    local ok = pcall(function()
        order = ChickenMode.order()
        where = ChickenMode.where()
        if ChickenOverlay then
            local bodies = ChickenOverlay.bodies()
            for _, body in pairs(bodies) do
                if type(body) == "table" and body.owner == Players.LocalPlayer.UserId then
                    bodyState = body.state
                    break
                end
            end
        end
        physicalAtCoop = isOwnedChickenInsideCoop()
    end)
    -- Require the actual owned chicken body to report corral as well as the
    -- UI atoms. This prevents pressing Rebirth while the overlay still shows
    -- the chicken in campaign/tower during the retreat transition.
    return ok and order == "coop" and where == "corral" and bodyState == "corral" and physicalAtCoop
end

local function waitForRebirthPrompt(timeout)
    local deadline = os.clock() + (tonumber(timeout) or 8)
    local stableSince
    repeat
        if isRebirthPromptReady() then
            stableSince = stableSince or os.clock()
            -- ChickenMode flips before the server-side coop guard in some
            -- retreat transitions. Require a short uninterrupted stable
            -- window so the actual Rebirth request is accepted as well.
            -- ChickenMode can report coop a little before the server-side
            -- Rebirth guard updates. Keep it stable long enough to avoid the
            -- first request being rejected as notAtCoop.
            if os.clock() - stableSince >= 0.75 then
                return true
            end
        else
            stableSince = nil
        end
        task.wait(0.05)
    until os.clock() >= deadline or sharedEnv.ChickenArenaGeneration ~= generation
    return isRebirthPromptReady()
end

local function countOwnedNestEggs()
    local player = game:GetService("Players").LocalPlayer
    local count = 0
    for _, egg in ipairs(CollectionService:GetTagged("NestEgg")) do
        if egg:GetAttribute("owner") == player.UserId then
            count += 1
        end
    end
    return count
end

collectNestEggs = function()
    if eggBusy then
        return
    end
    eggBusy = true
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and type(firetouchinterest) == "function" then
        for _, egg in ipairs(CollectionService:GetTagged("NestEgg")) do
            if egg:IsA("BasePart") and egg:GetAttribute("owner") == player.UserId then
                pcall(function()
                    firetouchinterest(egg, root, 1)
                    task.wait(0.1)
                    firetouchinterest(egg, root, 0)
                end)
                task.wait(0.15)
            end
        end
    else
        warn("[Egg UI] firetouchinterest is unavailable; Nest collection skipped")
    end
    eggBusy = false
end

local function getScrapItems()
    local folder = workspace:FindFirstChild("PitScrap")
    local items = {}
    if not folder then
        return items
    end

    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("BasePart") and item:GetAttribute("StackKind") then
            table.insert(items, item)
        end
    end

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        table.sort(items, function(a, b)
            return (a.Position - root.Position).Magnitude < (b.Position - root.Position).Magnitude
        end)
    end
    return items
end

local function getRecyclerPosition()
    local player = game:GetService("Players").LocalPlayer
    local recyclers = workspace:FindFirstChild("Recyclers")
    if not recyclers then
        return nil
    end

    local plot = player:GetAttribute("Plot")
    local recycler = plot and recyclers:FindFirstChild("Recycler" .. tostring(plot))
    if not recycler then
        recycler = recyclers:FindFirstChildWhichIsA("Model")
    end
    if not recycler then
        return nil
    end

    local origin = recycler:GetAttribute("Origin")
    if typeof(origin) == "CFrame" then
        return origin.Position
    end
    return recycler:GetPivot().Position
end

local function waitBeforeSendingScrap(token)
    local delay = math.max(0, tonumber(scrapDepositDelay) or 0)
    if delay <= 0 then
        return true
    end

    local deadline = os.clock() + delay
    scrapStatus = "WAITING BEFORE SEND SCRAP (" .. tostring(delay) .. "s)"
    while os.clock() < deadline do
        if token ~= scrapRunToken or sharedEnv.ChickenArenaGeneration ~= generation then
            return false
        end
        task.wait(math.min(0.1, math.max(0.01, deadline - os.clock())))
    end
    return true
end

local function moveWithoutTeleport(humanoid, root, destination, token, arrivalRadius)
    arrivalRadius = arrivalRadius or 3
    local function forceJump()
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall then
            return false
        end
        humanoid.Jump = true
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        return true
    end

    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        WaypointSpacing = 4,
    })
    local computeOk = pcall(function()
        path:ComputeAsync(root.Position, destination)
    end)

    local waypoints
    if computeOk and path.Status == Enum.PathStatus.Success then
        waypoints = path:GetWaypoints()
    else
        waypoints = {{Position = destination, Action = Enum.PathWaypointAction.Walk}}
    end

    for _, waypoint in ipairs(waypoints) do
        if token ~= scrapRunToken or sharedEnv.ChickenArenaGeneration ~= generation then
            humanoid:MoveTo(root.Position)
            return false, "CANCELLED"
        end

        if (root.Position - waypoint.Position).Magnitude > 3 then
            if waypoint.Action == Enum.PathWaypointAction.Jump then
                forceJump()
            end
            humanoid:MoveTo(waypoint.Position)

            local reached = false
            for attempt = 1, 3 do
                if attempt > 1 then
                    forceJump()
                end
                humanoid:MoveTo(waypoint.Position)
                local result = nil
                local connection = humanoid.MoveToFinished:Connect(function(success)
                    result = success
                end)
                local startedAt = os.clock()
                local lastDistance = (root.Position - waypoint.Position).Magnitude
                local lastProgressAt = startedAt
                while result == nil and os.clock() - startedAt < 4 do
                    if token ~= scrapRunToken or sharedEnv.ChickenArenaGeneration ~= generation then
                        connection:Disconnect()
                        humanoid:MoveTo(root.Position)
                        return false, "CANCELLED"
                    end
                    if (root.Position - waypoint.Position).Magnitude <= arrivalRadius then
                        result = true
                        break
                    end
                    local currentDistance = (root.Position - waypoint.Position).Magnitude
                    if lastDistance - currentDistance > 0.1 then
                        lastDistance = currentDistance
                        lastProgressAt = os.clock()
                    elseif os.clock() - lastProgressAt > 0.25 then
                        -- A circular fence can leave MoveToFinished pending for a long time.
                        -- Interrupt the wait quickly, jump, and retry the same waypoint.
                        scrapStatus = "JUMPING OVER FENCE"
                        forceJump()
                        break
                    end
                    task.wait(0.08)
                end
                connection:Disconnect()
                if result == true then
                    reached = true
                    break
                end
            end
            if not reached then
                humanoid:MoveTo(root.Position)
                return false, "BLOCKED"
            end
        end
    end
    return true, "OK"
end

collectScrapRun = function()
    if scrapBusy then
        return
    end
    if autoScrap and os.clock() < scrapManualPauseUntil then
        return
    end
    scrapBusy = true
    local token = scrapRunToken
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not (humanoid and root) then
        scrapStatus = "NO CHARACTER"
        scrapBusy = false
        return
    end

    local function stillRunning()
        return token == scrapRunToken and sharedEnv.ChickenArenaGeneration == generation
    end

    local function walkToRecycler(forceDeposit)
        local recyclerPosition = getRecyclerPosition()
        if not recyclerPosition then
            scrapStatus = "RECYCLER NOT FOUND"
            return false
        end
        local holdingForRebirth = holdScrapBeforeRebirth and not forceDeposit
        local targetY = root.Position.Y
        local targetPosition = recyclerPosition
        if holdingForRebirth then
            local flatDirection = Vector3.new(
                root.Position.X - recyclerPosition.X,
                0,
                root.Position.Z - recyclerPosition.Z
            )
            if flatDirection.Magnitude < 0.1 then
                flatDirection = Vector3.new(1, 0, 0)
            end
            -- Stay just outside the automatic deposit radius while waiting
            -- for the Rebirth condition. The final step into the Recycler is
            -- performed immediately before the Rebirth request.
            -- Keep a safe margin outside the Recycler's interaction radius;
            -- path waypoints can cut inward slightly while approaching.
            targetPosition = recyclerPosition + flatDirection.Unit * SCRAP_RECYCLER_STAGING_DISTANCE
            scrapStatus = "MOVING TO RECYCLER STAGING"
        else
            scrapStatus = "RETURNING TO RECYCLER"
        end
        local target = Vector3.new(targetPosition.X, targetY, targetPosition.Z)
        if not holdingForRebirth and not waitBeforeSendingScrap(token) then
            return false
        end
        local ok, reason = moveWithoutTeleport(humanoid, root, target, token)
        if not ok then
            scrapStatus = reason == "BLOCKED" and "BLOCKED BEFORE RECYCLER" or reason
            return false
        end
        if holdingForRebirth then
            scrapReadyForDeposit = true
            scrapStatus = "HOLDING SCRAP - WAITING FOR REBIRTH"
        else
            scrapReadyForDeposit = false
            -- Leave as soon as the Recycler confirms the deposit instead of
            -- standing still for a fixed delay.
            local depositDeadline = os.clock() + 1.2
            while (tonumber(player:GetAttribute("scrapCarry")) or 0) > 0
                and os.clock() < depositDeadline do
                task.wait(0.1)
            end
        end
        return true
    end

    local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
    if holdScrapBeforeRebirth and carrying < scrapTargetCount then
        -- A partial pickup run must continue collecting; do not treat the
        -- staging position as ready until the absolute Carrying target is met.
        scrapReadyForDeposit = false
    end
    if carrying > 0 then
        if holdScrapBeforeRebirth and scrapReadyForDeposit then
            scrapStatus = "HOLDING SCRAP - WAITING FOR REBIRTH ("
                .. tostring(carrying) .. "/" .. tostring(scrapTargetCount) .. " carrying)"
            scrapBusy = false
            return
        end
        local continueForTarget = holdScrapBeforeRebirth and carrying < scrapTargetCount
        if continueForTarget then
            -- Stay in the field and fill Carrying up to the configured target.
        elseif not walkToRecycler(false) then
            scrapBusy = false
            return
        elseif not stillRunning() then
            scrapBusy = false
            return
        elseif holdScrapBeforeRebirth then
            scrapBusy = false
            return
        end
    end

    local items = getScrapItems()
    if #items == 0 then
        scrapStatus = "NO PLATES AVAILABLE"
        scrapBusy = false
        return
    end

    local runStartCarry = tonumber(player:GetAttribute("scrapCarry")) or 0
    local collectedUnits = 0
    local collectedPlates = 0
    local targetCount = math.max(0, scrapTargetCount - runStartCarry)
    local pendingItems = table.clone(items)
    local itemAttempts = {}
    local attempts = 0
    local attemptLimit = math.max(targetCount * 2, #items * 2)
    while collectedUnits < targetCount and #pendingItems > 0 and attempts < attemptLimit do
        if not stillRunning() then
            scrapBusy = false
            return
        end

        -- Recalculate the nearest remaining plate after every pickup. A
        -- one-time sort from the starting position can make the character
        -- walk past closer plates after it moves.
        local nearestIndex
        local item
        local nearestDistance = math.huge
        for candidateIndex, candidate in ipairs(pendingItems) do
            if candidate.Parent and candidate:GetAttribute("StackKind") then
                local distance = (candidate.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestIndex = candidateIndex
                    item = candidate
                end
            end
        end
        if not item then
            break
        end
        table.remove(pendingItems, nearestIndex)
        attempts += 1
        itemAttempts[item] = (itemAttempts[item] or 0) + 1
        local itemAttempt = itemAttempts[item]
        scrapStatus = "WALKING TO PLATE " .. tostring(collectedPlates + 1) .. " ("
            .. tostring(runStartCarry + collectedUnits) .. "/" .. tostring(scrapTargetCount) .. " carrying)"
        local targetY = root.Position.Y
        local ok, reason = moveWithoutTeleport(
            humanoid,
            root,
            Vector3.new(item.Position.X, targetY, item.Position.Z),
            token,
            4
        )
        if not ok then
            scrapStatus = reason == "BLOCKED"
                and "BLOCKED AT PLATE (RETRY " .. tostring(itemAttempt) .. ")"
                or reason
            if item.Parent and item:GetAttribute("StackKind") and itemAttempt < 2 then
                table.insert(pendingItems, item)
            end
            continue
        end

        local before = tonumber(player:GetAttribute("scrapCarry")) or 0
        -- Scrap pickup is radius-based, so do not pause on the plate.
        -- A tiny yield lets the server attribute update while the next walk starts.
        task.wait(0.05)
        local after = tonumber(player:GetAttribute("scrapCarry")) or 0
        local pickupDeadline = os.clock() + 0.5
        while after <= before and os.clock() < pickupDeadline do
            task.wait(0.05)
            after = tonumber(player:GetAttribute("scrapCarry")) or 0
        end
        if after > before then
            collectedUnits += after - before
            collectedPlates += 1
        elseif item.Parent and item:GetAttribute("StackKind") and itemAttempt < 2 then
            -- The pickup radius may not have fired yet; retry this plate once
            -- instead of silently counting fewer pieces than requested.
            table.insert(pendingItems, item)
        end
    end

    local currentCarry = tonumber(player:GetAttribute("scrapCarry")) or 0
    if stillRunning() and currentCarry > 0 then
        local reached = currentCarry >= scrapTargetCount and walkToRecycler(false) or false
        if stillRunning() then
            if holdScrapBeforeRebirth and reached then
                scrapReadyForDeposit = true
                scrapStatus = "HOLDING SCRAP - WAITING FOR REBIRTH ("
                    .. tostring(currentCarry) .. "/" .. tostring(scrapTargetCount) .. " carrying)"
            elseif holdScrapBeforeRebirth and currentCarry < scrapTargetCount then
                scrapReadyForDeposit = false
                scrapStatus = "COLLECTED " .. tostring(currentCarry) .. "/"
                    .. tostring(scrapTargetCount) .. " CARRYING - CONTINUING"
            else
                task.wait(1.2)
                local remaining = tonumber(player:GetAttribute("scrapCarry")) or 0
                scrapStatus = remaining == 0
                    and "DEPOSITED (" .. tostring(collectedUnits) .. " carrying from "
                        .. tostring(collectedPlates) .. " plates)"
                    or "RECYCLER NOT REACHED"
                if remaining == 0 then
                    scheduleNextScrapRun()
                end
            end
        end
    elseif stillRunning() then
        local carryGained = math.max(0, currentCarry - runStartCarry)
        scrapStatus = carryGained > 0
            and ("COLLECTED " .. tostring(currentCarry) .. "/" .. tostring(scrapTargetCount) .. " CARRYING")
            or "NO PLATE PICKUP"
    end

    scrapBusy = false
end

depositHeldScrap = function(skipDelay)
    if scrapBusy then
        scrapStatus = "SCRAP RUN BUSY"
        return
    end

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
    if not (humanoid and root) then
        scrapStatus = "NO CHARACTER"
        return
    end
    if carrying <= 0 then
        scrapReadyForDeposit = false
        scrapStatus = "NO HELD SCRAP"
        return
    end

    scrapBusy = true
    scrapRunToken += 1
    local token = scrapRunToken
    scrapDepositConfirmed = false
    local recyclerPosition = getRecyclerPosition()
    if not recyclerPosition then
        scrapStatus = "RECYCLER NOT FOUND"
        scrapBusy = false
        return
    end

    scrapReadyForDeposit = false
    scrapStatus = "DEPOSITING HELD SCRAP"
    if not skipDelay and not waitBeforeSendingScrap(token) then
        scrapBusy = false
        return
    end
    local target = Vector3.new(recyclerPosition.X, root.Position.Y, recyclerPosition.Z)
    -- The Recycler accepts Scrap from its interaction radius, so deposit as
    -- soon as the player is close enough instead of walking to its center.
    local ok, reason = moveWithoutTeleport(humanoid, root, target, token, 12)
    if not ok then
        scrapStatus = reason == "BLOCKED" and "BLOCKED BEFORE RECYCLER" or reason
        scrapBusy = false
        return
    end

    local depositDeadline = os.clock() + 1.2
    local remaining = tonumber(player:GetAttribute("scrapCarry")) or 0
    while remaining > 0 and os.clock() < depositDeadline do
        task.wait(0.1)
        remaining = tonumber(player:GetAttribute("scrapCarry")) or 0
    end
    scrapStatus = remaining == 0 and "DEPOSITED HELD SCRAP" or "RECYCLER NOT REACHED"
    scrapBusy = false
    if remaining == 0 then
        scheduleNextScrapRun()
    end
end

-- Start walking into the Recycler immediately before the normal Rebirth call.
local function startHeldScrapWalkBeforeRebirth()
    if not holdScrapBeforeRebirth then
        return true
    end

    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
    if carrying <= 0 then
        return true
    end
    if not (humanoid and root) then
        scrapStatus = "NO CHARACTER FOR REBIRTH"
        return false
    end

    local recyclerPosition = getRecyclerPosition()
    if not recyclerPosition then
        scrapStatus = "RECYCLER NOT FOUND"
        return false
    end

    scrapBusy = true
    scrapRunToken += 1
    local token = scrapRunToken
    scrapReadyForDeposit = false
    scrapDepositConfirmed = false
    scrapStatus = "WALKING TO RECYCLER - REBIRTH AFTER DELAY"
    local walkStartedAt = os.clock()
    sharedEnv.ChickenRebirthTiming = {
        generation = generation,
        walkStartedAt = walkStartedAt,
    }
    print("[Rebirth Timing] Scrap walk started")
    local target = Vector3.new(recyclerPosition.X, root.Position.Y, recyclerPosition.Z)
    task.spawn(function()
        local ok, reason = moveWithoutTeleport(humanoid, root, target, token, 12)
        if token ~= scrapRunToken or sharedEnv.ChickenArenaGeneration ~= generation then
            scrapBusy = false
            return
        end
        if ok then
            scrapStatus = "AT RECYCLER - WAITING FOR SCRAP SEND"
            local timing = sharedEnv.ChickenRebirthTiming
            if type(timing) == "table" and timing.generation == generation then
                timing.recyclerReachedAt = os.clock()
                print("[Rebirth Timing] Recycler reached after", string.format("%.2fs", timing.recyclerReachedAt - timing.walkStartedAt))
            end
            local depositDeadline = os.clock() + 8
            while token == scrapRunToken
                and sharedEnv.ChickenArenaGeneration == generation
                and os.clock() < depositDeadline do
                local remaining = tonumber(player:GetAttribute("scrapCarry")) or 0
                if remaining < carrying then
                    scrapDepositConfirmed = true
                    scrapStatus = "SCRAP SENT - WAITING BEFORE REBIRTH"
                    local confirmedAt = os.clock()
                    local currentTiming = sharedEnv.ChickenRebirthTiming
                    if type(currentTiming) == "table" and currentTiming.generation == generation then
                        currentTiming.scrapDepositConfirmedAt = confirmedAt
                        print("[Rebirth Timing] Scrap deposit confirmed after", string.format("%.2fs", confirmedAt - (currentTiming.recyclerReachedAt or confirmedAt)))
                    end
                    break
                end
                task.wait(0.05)
            end
            if not scrapDepositConfirmed then
                scrapStatus = "SCRAP SEND NOT CONFIRMED - REBIRTH FALLBACK"
                warn("[Rebirth Timing] Scrap deposit was not confirmed before timeout")
            end
        else
            scrapStatus = reason == "BLOCKED" and "BLOCKED BEFORE RECYCLER" or reason
        end
        scrapBusy = false
    end)
    return true
end

local function continueHeldScrapWalkAfterRebirth()
    if not holdScrapBeforeRebirth then
        return true
    end
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
    if carrying <= 0 then
        return true
    end
    local recyclerPosition = getRecyclerPosition()
    if not (humanoid and root and recyclerPosition) then
        return false
    end

    scrapBusy = true
    scrapReadyForDeposit = false
    scrapRunToken += 1
    local token = scrapRunToken
    scrapStatus = "REBIRTH ACCEPTED - ENTERING RECYCLER"
    local target = Vector3.new(recyclerPosition.X, root.Position.Y, recyclerPosition.Z)
    task.spawn(function()
        if not waitBeforeSendingScrap(token) then
            scrapBusy = false
            return
        end
        local ok, reason = moveWithoutTeleport(humanoid, root, target, token, 12)
        if token ~= scrapRunToken or sharedEnv.ChickenArenaGeneration ~= generation then
            return
        end
        scrapBusy = false
        if ok then
            scrapStatus = "AT RECYCLER - SCRAP DEPOSITING"
        else
            scrapStatus = reason == "BLOCKED" and "BLOCKED BEFORE RECYCLER" or reason
        end
    end)
    return true
end

scheduleNextScrapRun = function()
    if not autoScrap or scrapNextRunQueued or os.clock() < scrapManualPauseUntil then
        return
    end
    scrapNextRunQueued = true
    task.defer(function()
        -- Give the Recycler's server update one scheduler turn, then collect
        -- again immediately instead of waiting for the 3-second controller tick.
        task.wait(0.1)
        scrapNextRunQueued = false
        local player = game:GetService("Players").LocalPlayer
        local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
        if sharedEnv.ChickenArenaGeneration == generation
            and os.clock() >= scrapManualPauseUntil
            and not scrapBusy and carrying <= 0 then
            collectScrapRun()
        end
    end)
end

local function queueHeldScrapDepositAfterRebirth()
    if not holdScrapBeforeRebirth or scrapDepositAfterRebirthBusy then
        return
    end

    scrapDepositAfterRebirthBusy = true
    task.spawn(function()
        -- Give the Rebirth request a scheduler turn first, then enter the Recycler
        -- while the server is still processing that request.
        task.wait(0.03)
        local deadline = os.clock() + 20
        local player = game:GetService("Players").LocalPlayer
        while sharedEnv.ChickenArenaGeneration == generation and os.clock() < deadline do
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
            if carrying > 0 and humanoid and root and not scrapBusy then
                scrapStatus = "AFTER REBIRTH - WALKING TO RECYCLER"
                -- The pre-Rebirth walk already waited for the configured
                -- delay; enter the Recycler immediately after Rebirth.
                depositHeldScrap(true)
                local timing = sharedEnv.ChickenRebirthTiming
                if type(timing) == "table" and timing.generation == generation then
                    timing.depositFinishedAt = os.clock()
                    print("[Rebirth Timing] Scrap deposit worker finished after", string.format("%.2fs", timing.depositFinishedAt - (timing.walkStartedAt or timing.depositFinishedAt)))
                end
                scrapDepositAfterRebirthBusy = false
                return
            end
            task.wait(0.25)
        end

        if sharedEnv.ChickenArenaGeneration == generation then
            local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
            scrapStatus = carrying > 0
                and "AFTER REBIRTH - DEPOSIT WAIT TIMEOUT"
                or "NO HELD SCRAP AFTER REBIRTH"
        end
        scrapDepositAfterRebirthBusy = false
    end)
end

claimIncubatorEggs = function()
    local ok, response = pcall(function()
        return incubatorClaim:InvokeServer()
    end)
    if ok and type(response) == "table" and response.ok then
        print("[Egg UI] incubator eggs claimed")
    elseif not ok or (type(response) == "table" and response.ok == false) then
        local reason = type(response) == "table" and response.error or response
        warn("[Egg UI] incubator claim failed:", tostring(reason))
    end
end

sharedEnv.ChickenFastIncubatorStatus = "OFF"
sharedEnv.ChickenFastIncubatorBusy = false
sharedEnv.ChickenFastIncubatorLastActionAt = 0
sharedEnv.ChickenFastIncubatorTargetSwappedAt = 0

sharedEnv.ChickenFastIncubatorSwapToTarget = function()
    if sharedEnv.ChickenFastIncubatorBusy then
        return
    end
    local roster = sharedEnv.ChickenFastIncubatorRosterById or {}
    local target = sharedEnv.ChickenFastIncubatorTargetId
        and roster[sharedEnv.ChickenFastIncubatorTargetId]
    if not target then
        sharedEnv.ChickenFastIncubatorStatus = "SELECT A TARGET CHICKEN"
        warn("[Egg UI] Fast Incubator manual swap: target is not available")
        return
    end
    local incubatorOk, incubatorData = pcall(function()
        return DataService.client:get({"incubator"}) or {}
    end)
    if not incubatorOk or type(incubatorData) ~= "table" then
        sharedEnv.ChickenFastIncubatorStatus = "WAITING FOR INCUBATOR DATA"
        return
    end
    local incubator = incubatorData.incubator or incubatorData
    local current = type(incubator.chicken) == "table" and incubator.chicken or nil
    if current and current.id == target.id then
        sharedEnv.ChickenFastIncubatorStatus = "TARGET ALREADY ACTIVE"
        return
    end
    local insertRemote = remotes:FindFirstChild("IncubatorInsert")
    local removeRemote = remotes:FindFirstChild("IncubatorRemove")
    if not insertRemote or not removeRemote then
        sharedEnv.ChickenFastIncubatorStatus = "INCUBATOR REMOTE NOT FOUND"
        return
    end
    sharedEnv.ChickenFastIncubatorBusy = true
    sharedEnv.ChickenFastIncubatorLastActionAt = os.clock()
    local ok, err = pcall(function()
        -- This is the same sequence used by the game's own Incubator picker.
        if current then
            removeRemote:InvokeServer()
            task.wait(0.05)
        end
        local response = insertRemote:InvokeServer(target.id)
        if type(response) == "table" and response.ok == false then
            error(tostring(response.error or "incubator insert rejected"))
        end
    end)
    sharedEnv.ChickenFastIncubatorBusy = false
    if ok then
        sharedEnv.ChickenFastIncubatorStatus = "SWAPPED TO TARGET"
        sharedEnv.ChickenFastIncubatorTargetSwappedAt = os.clock()
        print("[Egg UI] Fast Incubator manual swap:", target.id)
    else
        sharedEnv.ChickenFastIncubatorStatus = "SWAP FAILED"
        warn("[Egg UI] Fast Incubator manual swap failed:", tostring(err))
    end
end

sharedEnv.ChickenFastIncubatorSwapToSource = function()
    if sharedEnv.ChickenFastIncubatorBusy then
        return
    end
    local roster = sharedEnv.ChickenFastIncubatorRosterById or {}
    local source = sharedEnv.ChickenFastIncubatorSourceId
        and roster[sharedEnv.ChickenFastIncubatorSourceId]
    if not source then
        sharedEnv.ChickenFastIncubatorStatus = "SELECT A SOURCE CHICKEN"
        return
    end
    local incubatorOk, incubatorData = pcall(function()
        return DataService.client:get({"incubator"}) or {}
    end)
    if not incubatorOk or type(incubatorData) ~= "table" then
        sharedEnv.ChickenFastIncubatorStatus = "WAITING FOR INCUBATOR DATA"
        return
    end
    local incubator = incubatorData.incubator or incubatorData
    local current = type(incubator.chicken) == "table" and incubator.chicken or nil
    if current and current.id == source.id then
        sharedEnv.ChickenFastIncubatorTargetSwappedAt = 0
        sharedEnv.ChickenFastIncubatorStatus = "SOURCE ALREADY ACTIVE"
        return
    end
    local insertRemote = remotes:FindFirstChild("IncubatorInsert")
    local removeRemote = remotes:FindFirstChild("IncubatorRemove")
    if not insertRemote or not removeRemote then
        sharedEnv.ChickenFastIncubatorStatus = "INCUBATOR REMOTE NOT FOUND"
        return
    end
    sharedEnv.ChickenFastIncubatorBusy = true
    sharedEnv.ChickenFastIncubatorLastActionAt = os.clock()
    local ok, err = pcall(function()
        -- Match the game's own Swap action: remove the active chicken and
        -- insert Source. A ready egg can remain in the Incubator; do not claim
        -- it here because Fast Incubator must respect Auto Collect being off.
        if current then
            removeRemote:InvokeServer()
            task.wait(0.05)
        end
        local response = insertRemote:InvokeServer(source.id)
        if type(response) == "table" and response.ok == false then
            error(tostring(response.error or "source insert rejected"))
        end
    end)
    sharedEnv.ChickenFastIncubatorBusy = false
    if ok then
        sharedEnv.ChickenFastIncubatorTargetSwappedAt = 0
        sharedEnv.ChickenFastIncubatorStatus = "SWAPPED BACK TO SOURCE"
        print("[Egg UI] Fast Incubator swapped back to source:", source.id)
    else
        sharedEnv.ChickenFastIncubatorStatus = "SOURCE SWAP FAILED"
        warn("[Egg UI] Fast Incubator source swap failed:", tostring(err))
    end
end

sharedEnv.ChickenFastIncubatorRun = function()
    if not sharedEnv.ChickenFastIncubatorEnabled or sharedEnv.ChickenFastIncubatorBusy then
        return
    end
    if os.clock() - (sharedEnv.ChickenFastIncubatorLastActionAt or 0) < 0.35 then
        return
    end

    local incubatorOk, incubatorData = pcall(function()
        return DataService.client:get({"incubator"}) or {}
    end)
    if not incubatorOk or type(incubatorData) ~= "table" then
        sharedEnv.ChickenFastIncubatorStatus = "WAITING FOR INCUBATOR DATA"
        return
    end
    local incubator = incubatorData.incubator or incubatorData
    local readyEggs = type(incubator.eggs) == "table" and next(incubator.eggs) ~= nil
    local sourceId = sharedEnv.ChickenFastIncubatorSourceId
    local targetId = sharedEnv.ChickenFastIncubatorTargetId
    local current = type(incubator.chicken) == "table" and incubator.chicken or nil

    -- Keep the Target active briefly so its near-finished egg can settle, then
    -- use the game's normal remove/insert swap to return to Source. The ready
    -- egg stays in the Incubator when Auto Collect is off.
    local rosterReady = type(sharedEnv.ChickenFastIncubatorRosterById) == "table"
        and type(sourceId) == "string"
        and sharedEnv.ChickenFastIncubatorRosterById[sourceId] ~= nil
    if current and current.id == targetId and rosterReady then
        local swappedAt = tonumber(sharedEnv.ChickenFastIncubatorTargetSwappedAt) or 0
        if swappedAt <= 0 then
            swappedAt = os.clock()
            sharedEnv.ChickenFastIncubatorTargetSwappedAt = swappedAt
        end
        local returnDelay = math.max(0.1, tonumber(sharedEnv.ChickenFastIncubatorReturnSeconds) or 3)
        local elapsed = os.clock() - swappedAt
        if elapsed < returnDelay then
            sharedEnv.ChickenFastIncubatorStatus = "TARGET HOLD "
                .. tostring(math.max(0, math.ceil(returnDelay - elapsed))) .. "s"
            return
        end
        sharedEnv.ChickenFastIncubatorStatus = "RETURNING TO SOURCE"
        sharedEnv.ChickenFastIncubatorSwapToSource()
        return
    end

    -- If normal Auto Collect is enabled, claim ready eggs. Fast swaps themselves
    -- use only the game's remove/insert sequence and never claim an egg.
    if readyEggs then
        if not autoIncubator then
            -- A ready egg does not prevent the game's normal Swap action. If a
            -- different chicken is active, reset to Source while preserving
            -- the egg. When Source is already active, continue through the
            -- normal progress/timer logic below instead of swapping Target
            -- immediately and creating a Target/Source loop.
            if current and current.id ~= sourceId and current.id ~= targetId then
                -- The selected Source may have changed while another chicken
                -- is still active. Reset it through the normal Swap sequence;
                -- keep the ready egg and never call IncubatorClaim here.
                sharedEnv.ChickenFastIncubatorStatus = "RESETTING TO SOURCE - READY EGG KEPT"
                sharedEnv.ChickenFastIncubatorSwapToSource()
            elseif not current then
                -- Let the normal insert-source path below run. An empty
                -- Incubator can accept Source even when an egg is ready.
                -- (No claim is needed.)
            end
            if current then
                if current.id ~= sourceId and current.id ~= targetId then
                    return
                end
            else
                -- Continue below so Source can be inserted without claiming.
            end
        end
        if autoIncubator then
            sharedEnv.ChickenFastIncubatorBusy = true
            sharedEnv.ChickenFastIncubatorLastActionAt = os.clock()
            claimIncubatorEggs()
            sharedEnv.ChickenFastIncubatorBusy = false
            sharedEnv.ChickenFastIncubatorStatus = "CLAIMED READY EGG"
            return
        end
    end

    if type(sharedEnv.ChickenFastIncubatorRosterById) ~= "table"
        or os.clock() - (sharedEnv.ChickenFastIncubatorRosterAt or 0) > 5 then
        local rosterOk, rosterData = pcall(function()
            return DataService.client:get({"roster"}) or {}
        end)
        if rosterOk and type(rosterData) == "table" and type(rosterData.chickens) == "table" then
            local previousRoster = sharedEnv.ChickenFastIncubatorRosterById or {}
            local refreshedRoster = {}
            for _, chicken in ipairs(rosterData.chickens) do
                if type(chicken) == "table" and type(chicken.id) == "string" then
                    refreshedRoster[chicken.id] = chicken
                end
            end
            -- A chicken currently inside the Incubator is removed from the
            -- roster snapshot. Preserve it so the next source/target swap can
            -- still resolve its id.
            for _, id in ipairs({sharedEnv.ChickenFastIncubatorSourceId, sharedEnv.ChickenFastIncubatorTargetId}) do
                if type(id) == "string" and previousRoster[id] then
                    refreshedRoster[id] = previousRoster[id]
                end
            end
            if type(incubator.chicken) == "table" and type(incubator.chicken.id) == "string" then
                refreshedRoster[incubator.chicken.id] = incubator.chicken
            end
            sharedEnv.ChickenFastIncubatorRosterById = refreshedRoster
            sharedEnv.ChickenFastIncubatorRosterAt = os.clock()
        end
    end

    local source = sourceId and sharedEnv.ChickenFastIncubatorRosterById[sourceId]
    local target = targetId and sharedEnv.ChickenFastIncubatorRosterById[targetId]
    if not source then
        sharedEnv.ChickenFastIncubatorStatus = "SELECT A SOURCE CHICKEN"
        return
    end
    if not target or target.id == source.id then
        sharedEnv.ChickenFastIncubatorStatus = "SELECT A DIFFERENT TARGET CHICKEN"
        return
    end

    local currentId = current and current.id
    local catalog = sharedEnv.ChickenFastIncubatorCatalog
    if not catalog then
        pcall(function()
            sharedEnv.ChickenFastIncubatorCatalog = loadModule(ReplicatedStorage:WaitForChild("Content"):WaitForChild("Catalog"):WaitForChild("ChickenTypes"))
        end)
        catalog = sharedEnv.ChickenFastIncubatorCatalog
    end
    local typeInfo = catalog and catalog[current and current.typeId or source.typeId]
    local layPeriod = tonumber(typeInfo and typeInfo.layPeriod) or 0
    if not sharedEnv.ChickenFastIncubatorGenome then
        pcall(function()
            sharedEnv.ChickenFastIncubatorGenome = loadModule(ReplicatedStorage:WaitForChild("Features"):WaitForChild("Chicken"):WaitForChild("Genome"))
        end)
    end
    if sharedEnv.ChickenFastIncubatorGenome
        and type(sharedEnv.ChickenFastIncubatorGenome.layMult) == "function" then
        local multOk, mult = pcall(sharedEnv.ChickenFastIncubatorGenome.layMult, (current and current.genome) or source.genome)
        if multOk and tonumber(mult) then
            layPeriod = layPeriod * tonumber(mult)
        end
    end
    local progress = math.clamp(tonumber(incubator.progress) or 0, 0, 1)
    local remaining = layPeriod > 0 and layPeriod * (1 - progress) or math.huge
    -- DataService's progress field is a snapshot and does not tick locally.
    -- The game's Incubator UI uses the machine's server-synchronised
    -- NextHatchAt attribute, so prefer that realtime countdown when available.
    local workspaceService = game:GetService("Workspace")
    local incubatorsFolder = workspaceService:FindFirstChild("Incubators")
    if incubatorsFolder then
        for _, machine in ipairs(incubatorsFolder:GetChildren()) do
            local occupant = machine:GetAttribute("Occupant")
            local nextHatchAt = tonumber(machine:GetAttribute("NextHatchAt"))
            if occupant ~= nil and tostring(occupant) ~= "" and nextHatchAt and nextHatchAt > 0 then
                local serverRemaining = nextHatchAt - workspaceService:GetServerTimeNow()
                remaining = math.max(0, serverRemaining)
                break
            end
        end
    end
    local swapSeconds = math.max(0.1, tonumber(sharedEnv.ChickenFastIncubatorSwapSeconds) or 1)

    local action = nil
    local chosen = nil
    if not current then
        action = "insert source"
        chosen = source
    elseif currentId == source.id and remaining <= swapSeconds + 0.05 then
        action = "swap to target"
        chosen = target
    elseif currentId ~= source.id and currentId ~= target.id then
        action = "reset to source"
        chosen = source
    end

    local remainingDisplay = string.format("%.1f", math.max(0, remaining))
    sharedEnv.ChickenFastIncubatorStatus = current
        and ("RUNNING " .. remainingDisplay .. "s - " .. tostring(action or "waiting"))
        or "INSERTING SOURCE"
    if not action or not chosen then
        return
    end

    if action == "swap to target" then
        -- Use the exact same remove-then-insert sequence as the manual Swap
        -- button and the game's own Incubator picker.
        sharedEnv.ChickenFastIncubatorSwapToTarget()
        return
    end

    local insertRemote = remotes:FindFirstChild("IncubatorInsert")
    local removeRemote = remotes:FindFirstChild("IncubatorRemove")
    if not insertRemote or not removeRemote then
        sharedEnv.ChickenFastIncubatorStatus = "INCUBATOR REMOTE NOT FOUND"
        return
    end
    sharedEnv.ChickenFastIncubatorBusy = true
    sharedEnv.ChickenFastIncubatorLastActionAt = os.clock()
    local ok, err = pcall(function()
        if current then
            removeRemote:InvokeServer()
            task.wait(0.05)
        end
        -- IncubatorInsert expects the roster chicken id, matching the game's
        -- own picker callback (it passes rep.id, not the full chicken table).
        local response = insertRemote:InvokeServer(chosen.id)
        if type(response) == "table" and response.ok == false then
            error(tostring(response.error or "incubator insert rejected"))
        end
    end)
    sharedEnv.ChickenFastIncubatorBusy = false
    if ok then
        sharedEnv.ChickenFastIncubatorStatus = string.upper(action)
        print("[Egg UI] Fast Incubator:", action, chosen.id)
    else
        sharedEnv.ChickenFastIncubatorStatus = "SWAP FAILED"
        warn("[Egg UI] Fast Incubator swap failed:", tostring(err))
    end
end

local function formatEggName(value)
    local name = tostring(value):gsub("(%l)(%u)", "%1 %2"):gsub("_", " ")
    return (name:gsub("^%l", string.upper))
end

local function updateEggInfo()
    local data = DataService.client:get({}) or {}
    local incubator = data.incubator or {}
    local readyEggs = incubator.eggs or {}
    local chicken = incubator.chicken or {}
    local roster = data.roster or {}
    local activeId = roster.activeId or "?"
    local inventory = data.roster and data.roster.eggs or {}
    local nestCount = countOwnedNestEggs()
    local lines = {
        "Ready eggs: " .. tostring(#readyEggs),
        "Incubator status: " .. (#readyEggs > 0 and "READY" or "EMPTY"),
        "Incubator chicken: " .. tostring(chicken.nickname or chicken.typeId or "?"),
        "Owned Nest eggs: " .. tostring(nestCount),
        "Collector: Incubator " .. (autoIncubator and "ON" or "OFF") .. "  |  Nest " .. (autoNest and "ON" or "OFF"),
        "Farm active chicken: " .. tostring(activeId),
        "Fast Coop Deploy: " .. (sharedEnv.ChickenFastIncubatorEnabled and "ON" or "OFF"),
        "Deploy Target last: " .. tostring(sharedEnv.ChickenFastIncubatorSwapSeconds or 1) .. " sec",
        "Deploy Source after Target: " .. tostring(sharedEnv.ChickenFastIncubatorReturnSeconds or 3) .. " sec",
        "Coop source: " .. tostring(sharedEnv.ChickenFastIncubatorSourceId or "not selected"),
        "Coop target: " .. tostring(sharedEnv.ChickenFastIncubatorTargetId or "not selected"),
        "Coop status: " .. tostring(sharedEnv.ChickenFastIncubatorStatus or "OFF"),
    }

    local inventoryLines = {}
    for eggId, count in pairs(inventory) do
        count = tonumber(count) or 0
        if count > 0 then
            table.insert(inventoryLines, formatEggName(eggId) .. " x" .. tostring(count))
        end
    end
    table.sort(inventoryLines)
    if #inventoryLines == 0 then
        table.insert(inventoryLines, "(empty)")
    end
    EggInfoParagraph:UpdateBody(table.concat(lines, "\n"))
    EggInventoryParagraph:UpdateBody(table.concat(inventoryLines, "\n"))
end

local function updateScrapInfo()
    local player = game:GetService("Players").LocalPlayer
    local items = getScrapItems()
    local carrying = tonumber(player:GetAttribute("scrapCarry")) or 0
    local recyclerPosition = getRecyclerPosition()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local distance = recyclerPosition and root
        and math.floor((root.Position - recyclerPosition).Magnitude + 0.5)
        or nil
    local manualPauseRemaining = math.max(0, scrapManualPauseUntil - os.clock())
    local lines = {
        "Middle-map plates: " .. tostring(#items),
        "Carrying: " .. tostring(carrying),
        "Target per run: " .. tostring(scrapTargetCount),
        "Recycler distance: " .. (distance and (tostring(distance) .. " studs") or "?"),
        "Status: " .. scrapStatus,
        "Mode: Pathfinding walk only (no teleport)",
        "Auto Scrap: " .. (autoScrap and "ON" or "OFF"),
        "Hold before Rebirth: " .. (holdScrapBeforeRebirth and "ON" or "OFF"),
        "Manual pause: " .. (manualPauseRemaining > 0
            and formatCountdown(manualPauseRemaining) or "READY"),
    }
    ScrapInfoParagraph:UpdateBody(table.concat(lines, "\n"))
end

local function numericCost(value)
    if type(value) == "number" then
        return value
    end
    if type(value) == "string" then
        return tonumber(value)
    end
    if type(value) == "table" then
        if type(value.toNumber) == "function" then
            local ok, result = pcall(function()
                return value:toNumber()
            end)
            if ok and type(result) == "number" then
                return result
            end
        end
        if type(value.ToNumber) == "function" then
            local ok, result = pcall(function()
                return value:ToNumber()
            end)
            if ok and type(result) == "number" then
                return result
            end
        end
        if value.value ~= nil then
            return numericCost(value.value)
        end
    end
    local ok, result = pcall(function()
        return tonumber(value)
    end)
    return ok and result or nil
end

local function getTowerStartFloorAndReserve()
    local tower = DataService.client:get({ "tower" }) or {}
    local best = math.max(tonumber(tower.best) or 0, towerResumeBest)
    local startFloor = towerStartLatest and math.max(1, best + 1) or 1
    if not keepMoneyForLastFloor or startFloor <= 1 then
        return startFloor, 0, best
    end

    local reserve = 0
    for floor = 1, startFloor - 1 do
        local ok, info = pcall(function()
            return TowerFloor.at(floor)
        end)
        if ok and type(info) == "table" then
            reserve += numericCost(info.money) or 0
        end
    end
    return startFloor, reserve, best
end

local function getCurrentMoney()
    return numericCost(DataService.client:get({ "money" }))
end

local UpgradeOps = {}

function UpgradeOps.getUpgradeProgressSignature()
    local tower = DataService.client:get({ "tower" }) or {}
    local rebirth = DataService.client:get({ "rebirth" }) or {}
    return table.concat({
        tostring(tower.best or 0),
        tostring(tower.peak or 0),
        tostring(rebirth.count or 0),
    }, ":")
end

function UpgradeOps.getUpgradeReserve()
    local _, reserve = getTowerStartFloorAndReserve()
    return tonumber(reserve) or 0
end

function UpgradeOps.hasUpgradeFunds(cost, money)
    local currentMoney = money
    if currentMoney == nil then
        currentMoney = getCurrentMoney()
    end
    if not currentMoney then
        return false, nil, UpgradeOps.getUpgradeReserve()
    end
    local reserve = UpgradeOps.getUpgradeReserve()
    return currentMoney - (tonumber(cost) or math.huge) >= reserve, currentMoney, reserve
end

function UpgradeOps.clearUpgradeMoneyWait(scope)
    local costKey = scope == "recycler" and "recyclerMoneyWaitCost" or "mainMoneyWaitCost"
    local retryKey = scope == "recycler" and "recyclerMoneyRetryAt" or "mainMoneyRetryAt"
    local signatureKey = scope == "recycler" and "recyclerMoneyWaitSignature" or "mainMoneyWaitSignature"
    upgradeWaitState[costKey] = 0
    upgradeWaitState[retryKey] = 0
    upgradeWaitState[signatureKey] = nil
end

function UpgradeOps.clearUpgradeRateWait(clearRecycler)
    upgradeWaitState.rateRetryAt = 0
    if clearRecycler then
        recyclerUpgradeState.retryAt = 0
    end
end

function UpgradeOps.setUpgradeMoneyWait(cost, scope)
    local costKey = scope == "recycler" and "recyclerMoneyWaitCost" or "mainMoneyWaitCost"
    local retryKey = scope == "recycler" and "recyclerMoneyRetryAt" or "mainMoneyRetryAt"
    local signatureKey = scope == "recycler" and "recyclerMoneyWaitSignature" or "mainMoneyWaitSignature"
    upgradeWaitState[costKey] = math.max(0, tonumber(cost) or 0)
    -- This is only a status poll gate; no remote is sent during the wait.
    upgradeWaitState[retryKey] = os.clock() + 1
    local signatureOk, signature = pcall(UpgradeOps.getUpgradeProgressSignature)
    upgradeWaitState[signatureKey] = signatureOk and tostring(signature) or nil
end

function UpgradeOps.setUpgradeRateWait(seconds)
    local retryAt = os.clock() + math.max(0.25, tonumber(seconds) or 1)
    upgradeWaitState.rateRetryAt = math.max(tonumber(upgradeWaitState.rateRetryAt) or 0, retryAt)
    recyclerUpgradeState.retryAt = math.max(tonumber(recyclerUpgradeState.retryAt) or 0, retryAt)
end

function UpgradeOps.setUpgradeFloorWait(scope)
    local signatureOk, signature = pcall(UpgradeOps.getUpgradeProgressSignature)
    local floorKey = scope == "recycler" and "recyclerFloorSignature" or "needFloorSignature"
    local blockedSignature = signatureOk and tostring(signature) or "unknown"
    upgradeWaitState[floorKey] = blockedSignature
    if scope == "recycler" then
        recyclerUpgradeState.floorBlockedSignature = blockedSignature
    end
    upgradeWaitState.rateRetryAt = 0
    if scope == "recycler" then
        recyclerUpgradeState.retryAt = 0
    end
end

function UpgradeOps.getUpgradeWaitStatus(scope)
    local now = os.clock()
    local floorKey = scope == "recycler" and "recyclerFloorSignature" or "needFloorSignature"
    local floorSignature = upgradeWaitState[floorKey]
    if floorSignature then
        local currentOk, currentSignature = pcall(UpgradeOps.getUpgradeProgressSignature)
        if not currentOk or tostring(currentSignature) == tostring(floorSignature) then
            return "WAITING FOR FLOOR (until Tower/Rebirth changes)"
        end
        -- Tower best/peak or Rebirth changed; allow a fresh candidate scan.
        upgradeWaitState[floorKey] = nil
        if scope == "recycler" then
            recyclerUpgradeState.floorBlockedSignature = nil
            recyclerUpgradeState.floorBlockedLabel = nil
        end
    end

    local rateRetryAt = tonumber(upgradeWaitState.rateRetryAt) or 0
    if rateRetryAt > now then
        return "COOLDOWN (" .. string.format("%.1fs", rateRetryAt - now) .. ")"
    end
    if rateRetryAt > 0 then
        UpgradeOps.clearUpgradeRateWait(true)
    end

    local costKey = scope == "recycler" and "recyclerMoneyWaitCost" or "mainMoneyWaitCost"
    local retryKey = scope == "recycler" and "recyclerMoneyRetryAt" or "mainMoneyRetryAt"
    local signatureKey = scope == "recycler" and "recyclerMoneyWaitSignature" or "mainMoneyWaitSignature"
    local waitCost = tonumber(upgradeWaitState[costKey]) or 0
    local waitSignature = upgradeWaitState[signatureKey]
    if waitCost > 0 and waitSignature then
        local currentOk, currentSignature = pcall(UpgradeOps.getUpgradeProgressSignature)
        if currentOk and tostring(currentSignature) ~= tostring(waitSignature) then
            -- Rebirth/Tower progress can reset the actual upgrade level and
            -- price. Never carry an old expensive wait into the new cycle.
            UpgradeOps.clearUpgradeMoneyWait(scope)
            waitCost = 0
        end
    end
    if waitCost > 0 then
        local affordable = UpgradeOps.hasUpgradeFunds(waitCost)
        if affordable then
            UpgradeOps.clearUpgradeMoneyWait(scope)
        else
            upgradeWaitState[retryKey] = math.max(
                tonumber(upgradeWaitState[retryKey]) or 0,
                now + 0.5
            )
            return "WAITING FOR MONEY ($" .. formatPower(waitCost) .. ")"
        end
    end
    return nil
end

function UpgradeOps.invokeUpgradeCandidate(candidate)
    local lock = upgradeWaitState.remoteLock
    local deadline = os.clock() + 2
    while lock.busy do
        if sharedEnv.ChickenArenaGeneration ~= generation then
            return false, "cancelled"
        end
        if os.clock() >= deadline then
            return false, "upgrade-queue-busy"
        end
        task.wait(0.01)
    end

    lock.busy = true
    lock.owner = generation
    lock.busySince = os.clock()
    lock.label = candidate.label
    lock.kind = candidate.kind or "upgrade"
    -- Recheck inside the shared lock. The other queue may have spent money
    -- after this candidate was scanned but before it acquired the lock.
    local affordable = UpgradeOps.hasUpgradeFunds(candidate.cost)
    if not affordable then
        lock.busy = false
        lock.owner = nil
        lock.busySince = 0
        lock.label = nil
        lock.kind = nil
        return false, {error = "not-enough-money"}
    end
    local ok, response = pcall(candidate.invoke)
    lock.busy = false
    lock.owner = nil
    lock.busySince = 0
    lock.label = nil
    lock.kind = nil
    return ok, response
end

local function addUpgradeCandidate(candidates, label, cost, invoke, kind, slot, action)
    local numeric = numericCost(cost)
    if numeric then
        table.insert(candidates, {
            label = label,
            cost = numeric,
            invoke = invoke,
            kind = kind or "other",
            slot = slot,
            action = action,
        })
    end
end

-- RecyclerView exposes the same floor gate the server checks.  Filter a
-- locked Recycler before invoking its RemoteFunction; the old flow relied on
-- the server to reject it with need-floor, which produced repeated warnings
-- while Tower was climbing.
local function getRecyclerFloorGate()
    local scrap = DataService.client:get({ "scrap" }) or {}
    local rebirth = DataService.client:get({ "rebirth" }) or {}
    local level = tonumber(scrap.recyclerLevel) or 0
    local rebirthCount = tonumber(rebirth.count) or 0
    local canUpgrade = false
    pcall(function()
        canUpgrade = RecyclerView.canUpgrade(level, rebirthCount) == true
    end)
    if not canUpgrade then
        return nil
    end

    local tower = DataService.client:get({ "tower" }) or {}
    local clearedFloor = math.max(
        tonumber(tower.best) or 0,
        tonumber(towerResumeBest) or 0
    )
    local gateFloor
    local gateOk = pcall(function()
        gateFloor = tonumber(RecyclerView.gateFloor(level))
    end)
    if not gateOk or not gateFloor or gateFloor <= clearedFloor then
        return nil
    end
    return gateFloor, clearedFloor, level
end

local function getUpgradeCandidates(includeRecycler)
    if includeRecycler == nil then
        includeRecycler = true
    end
    local candidates = {}
    local coop = DataService.client:get({ "coop" }) or {}
    local scrap = DataService.client:get({ "scrap" }) or {}
    local rebirth = DataService.client:get({ "rebirth" }) or {}
    local generators = type(coop.generators) == "table" and coop.generators or {}
    local slots = tonumber(coop.slots) or 0

    if upgradeCoop then
        local canExpand = false
        pcall(function()
            canExpand = CoopView.canExpand(slots) == true
        end)
        if canExpand then
            local expandCost
            pcall(function()
                expandCost = CoopView.expandCost(slots)
            end)
            addUpgradeCandidate(candidates, "Expand Coop (" .. tostring(slots) .. " slots)", expandCost, function()
                return expandCoopRemote:InvokeServer()
            end, "coop", slots, "expand")
        end
    end

    if upgradeFeeder then
        if #generators < slots then
            local buyCost
            pcall(function()
                buyCost = CoopView.buyGeneratorCost(#generators)
            end)
            local nextSlot = #generators + 1
            addUpgradeCandidate(candidates, "Create Feeder #" .. tostring(nextSlot), buyCost, function()
                return buyGeneratorRemote:InvokeServer(nextSlot)
            end, "feeder", nextSlot, "create")
        end

        for _, generator in ipairs(generators) do
            local slot = tonumber(generator.slot)
            local level = tonumber(generator.level)
            if slot and level then
                local canUpgrade = false
                pcall(function()
                    canUpgrade = CoopView.canUpgrade(level) == true
                end)
                if canUpgrade then
                    local upgradeCost
                    pcall(function()
                        upgradeCost = CoopView.upgradeCost(level)
                    end)
                    addUpgradeCandidate(
                        candidates,
                        "Upgrade Feeder #" .. tostring(slot) .. " Lv." .. tostring(level),
                        upgradeCost,
                        function()
                            return upgradeGeneratorRemote:InvokeServer(slot)
                        end,
                        "feeder",
                        slot,
                        "upgrade"
                    )
                end
            end
        end
    end

    if includeRecycler and upgradeRecycler then
        local level = tonumber(scrap.recyclerLevel) or 0
        local rebirthCount = tonumber(rebirth.count) or 0
        local canUpgrade = false
        pcall(function()
            canUpgrade = RecyclerView.canUpgrade(level, rebirthCount) == true
        end)
        local gateFloor = getRecyclerFloorGate()
        if canUpgrade and not gateFloor then
            local recyclerCost
            pcall(function()
                recyclerCost = RecyclerView.upgradeCost(level)
            end)
            addUpgradeCandidate(candidates, "Upgrade Recycler Lv." .. tostring(level), recyclerCost, function()
                return upgradeRecyclerRemote:InvokeServer()
            end, "recycler", nil, "upgrade")
        end
    end

    if keepMoneyForLastFloor then
        local _, reserve = getTowerStartFloorAndReserve()
        local money = getCurrentMoney()
        if money and reserve > 0 then
            local spendableCandidates = {}
            for _, candidate in ipairs(candidates) do
                if money - candidate.cost >= reserve then
                    table.insert(spendableCandidates, candidate)
                end
            end
            candidates = spendableCandidates
        end
    end

    if upgradeOrder == "feeder" then
        -- Progress one feeder completely before moving to the next coop step:
        -- upgrade the first unfinished feeder, otherwise create the next one
        -- if a slot already exists, otherwise expand the Coop first.
        local focusSlot
        for _, candidate in ipairs(candidates) do
            if candidate.kind == "feeder" and candidate.action == "upgrade" then
                local slot = tonumber(candidate.slot)
                if slot and (not focusSlot or slot < focusSlot) then
                    focusSlot = slot
                end
            end
        end

        local primary = {}
        if focusSlot then
            local focus = {}
            local fallbackFeeders = {}
            for _, candidate in ipairs(candidates) do
                if candidate.kind == "feeder" then
                    if tonumber(candidate.slot) == focusSlot then
                        candidate.priority = 0
                        table.insert(focus, candidate)
                    else
                        candidate.priority = 1
                        table.insert(fallbackFeeders, candidate)
                    end
                end
            end
            table.sort(fallbackFeeders, function(a, b)
                if a.cost == b.cost then
                    return a.label < b.label
                end
                return a.cost < b.cost
            end)
            for _, candidate in ipairs(focus) do
                table.insert(primary, candidate)
            end
            for _, candidate in ipairs(fallbackFeeders) do
                table.insert(primary, candidate)
            end
        elseif #generators < slots then
            for _, candidate in ipairs(candidates) do
                if candidate.kind == "feeder" and candidate.action == "create" then
                    candidate.priority = 0
                    table.insert(primary, candidate)
                    break
                end
            end
        else
            for _, candidate in ipairs(candidates) do
                if candidate.kind == "coop" then
                    candidate.priority = 0
                    table.insert(primary, candidate)
                    break
                end
            end
        end

        local recycler = {}
        for _, candidate in ipairs(candidates) do
            if candidate.kind == "recycler" then
                candidate.priority = 2
                table.insert(recycler, candidate)
            end
        end
        candidates = primary
        for _, candidate in ipairs(recycler) do
            table.insert(candidates, candidate)
        end
    end

    table.sort(candidates, function(a, b)
        if upgradeOrder == "feeder" and a.priority ~= b.priority then
            return (a.priority or 1) < (b.priority or 1)
        end
        if a.cost == b.cost then
            return a.label < b.label
        end
        if upgradeOrder == "high" then
            return a.cost > b.cost
        end
        return a.cost < b.cost
    end)
    return candidates
end

local function responseSucceeded(response)
    return type(response) ~= "table" or response.ok ~= false
end

updateUpgradeInfo = function()
    local ok, body = pcall(function()
        local coop = DataService.client:get({ "coop" }) or {}
        local scrap = DataService.client:get({ "scrap" }) or {}
        local generators = type(coop.generators) == "table" and coop.generators or {}
        local candidates = getUpgradeCandidates()
        local startFloor, towerReserve = getTowerStartFloorAndReserve()
        local money = getCurrentMoney()
        local mainWaitStatus = UpgradeOps.getUpgradeWaitStatus("main")
        local recyclerWaitStatus = UpgradeOps.getUpgradeWaitStatus("recycler")
        local sharedLock = upgradeWaitState.remoteLock
        local nextAction = #candidates > 0
            and (candidates[1].label .. "  ($" .. formatPower(candidates[1].cost) .. ")")
            or "None available / maxed / locked"
        local highestCleared = math.max(0, startFloor - 1)
        local startDescription = towerStartLatest
            and ("ON -> floor " .. tostring(startFloor)) or "OFF -> floor 1"
        local reserveDescription = keepMoneyForLastFloor
            and ("ON -> $" .. formatPower(towerReserve)) or "OFF -> $0"
        local spendable = math.max(0, (money or 0) - towerReserve)
        local lockDescription = sharedLock and sharedLock.busy
            and ("BUSY (" .. tostring(sharedLock.kind or "upgrade") .. ")") or "FREE"
        local mainStatusText = mainWaitStatus or upgradeStatus
        local recyclerStatusText = recyclerWaitStatus or recyclerUpgradeState.status
        if string.find(tostring(mainStatusText), "WAITING FOR FLOOR", 1, true) then
            mainStatusText = "WAITING FOR FLOOR"
        end
        if string.find(tostring(recyclerStatusText), "WAITING FOR FLOOR", 1, true) then
            recyclerStatusText = "WAITING FOR FLOOR"
        end
        local lines = {
            "[ STATUS ]",
            "Auto Upgrade   : " .. (upgradeEnabled and "ON" or "OFF"),
            "Money lock     : " .. lockDescription,
            "Floor gate     : waits for Tower/Rebirth change",
            "",
            "[ QUEUE ]",
            "Feeder / Coop  : " .. (upgradeBusy and "RUNNING" or mainStatusText),
            "Recycler       : " .. (recyclerUpgradeState.busy and "RUNNING" or recyclerStatusText),
            "Priority       : " .. (upgradeOrder == "high" and "Highest cost first"
                or upgradeOrder == "feeder" and "Feeder first (max one at a time)"
                or "Lowest cost first"),
            "Delay          : " .. string.format("%.2fs", math.max(0.05, upgradeDelay)),
            "Coop / Feeders : " .. tostring(coop.slots or 0) .. " / " .. tostring(#generators),
            "Recycler level : " .. tostring(scrap.recyclerLevel or 0),
            "",
            "[ TOWER FUNDS ]",
            "Start Highest  : " .. startDescription,
            "Highest cleared: floor " .. tostring(highestCleared),
            "Reserve money  : " .. reserveDescription,
            "Current money  : $" .. formatPower(money or 0),
            "Spendable      : $" .. formatPower(spendable) .. " (after reserve)",
            "",
            "[ NEXT ] " .. nextAction,
        }
        return table.concat(lines, "\n")
    end)
    if ok then
        UpgradeInfoParagraph:UpdateBody(body)
    else
        UpgradeInfoParagraph:UpdateBody("Unable to read upgrade data.")
    end
end

runUpgradeCycle = function()
    if upgradeBusy or not upgradeEnabled then
        return
    end
    local initialWait = UpgradeOps.getUpgradeWaitStatus("main")
    if initialWait then
        upgradeStatus = initialWait
        return
    end
    upgradeBusy = true
    upgradeRunToken += 1
    local token = upgradeRunToken
    upgradeStatus = "SCANNING"
    local actions = 0
    local blockedCandidates = {}

    for _ = 1, 200 do
        if token ~= upgradeRunToken or sharedEnv.ChickenArenaGeneration ~= generation then
            upgradeStatus = "CANCELLED"
            break
        end
        local waitStatus = UpgradeOps.getUpgradeWaitStatus("main")
        if waitStatus then
            upgradeStatus = waitStatus
            break
        end
        local candidatesOk, candidates = pcall(function()
            return getUpgradeCandidates(false)
        end)
        if not candidatesOk then
            upgradeStatus = "SCAN ERROR"
            warn("[Upgrade UI] candidate scan failed:", tostring(candidates))
            break
        end
        local candidate
        local currentMoney = getCurrentMoney()
        local _, towerReserve = getTowerStartFloorAndReserve()
        local lowestCost
        local hasUnaffordable = false
        for _, item in ipairs(candidates) do
            lowestCost = math.min(lowestCost or item.cost, item.cost)
            local canAfford = currentMoney ~= nil
                and currentMoney - item.cost >= (tonumber(towerReserve) or 0)
            if not canAfford then
                hasUnaffordable = true
            end
            if canAfford and not blockedCandidates[item.label] then
                candidate = item
                break
            end
        end
        if not candidate then
            if hasUnaffordable and lowestCost then
                UpgradeOps.setUpgradeMoneyWait(lowestCost, "main")
                upgradeStatus = "WAITING FOR MONEY ($" .. formatPower(lowestCost) .. ")"
            else
                upgradeStatus = actions > 0 and "DONE" or "NO AVAILABLE UPGRADES"
            end
            break
        end

        upgradeStatus = "RUNNING: " .. candidate.label .. " ($" .. formatPower(candidate.cost) .. ")"
        -- Recheck affordability immediately before acquiring the shared remote
        -- lock; the Recycler queue may have just spent the same money pool.
        local affordable = UpgradeOps.hasUpgradeFunds(candidate.cost)
        if not affordable then
            UpgradeOps.setUpgradeMoneyWait(candidate.cost, "main")
            upgradeStatus = "WAITING FOR MONEY ($" .. formatPower(candidate.cost) .. ")"
            break
        end
        local invokeOk, response = UpgradeOps.invokeUpgradeCandidate(candidate)
        if not invokeOk or not responseSucceeded(response) then
            local reason = type(response) == "table" and response.error or response
            warn("[Upgrade UI] action failed:", candidate.label, tostring(reason))
            if reason == "not-enough-money" or reason == "notEnoughMoney" then
                UpgradeOps.setUpgradeMoneyWait(candidate.cost, "main")
                upgradeStatus = "WAITING FOR MONEY ($" .. formatPower(candidate.cost) .. ")"
                break
            elseif tostring(reason) == "no-generator"
                or tostring(reason) == "no_generator"
                or tostring(reason) == "generator-not-found" then
                -- Rebirth/Coop reset can invalidate a candidate that was
                -- scanned just before the reset (for example Feeder #6).
                -- Cancel both queues and force the next cycle to rescan the
                -- live Coop data instead of retrying a stale generator id.
                upgradeRunToken += 1
                recyclerUpgradeState.token += 1
                UpgradeOps.clearUpgradeMoneyWait("main")
                UpgradeOps.clearUpgradeMoneyWait("recycler")
                UpgradeOps.clearUpgradeRateWait(true)
                upgradeWaitState.needFloorSignature = nil
                upgradeWaitState.recyclerFloorSignature = nil
                recyclerUpgradeState.floorBlockedSignature = nil
                recyclerUpgradeState.floorBlockedLabel = nil
                recyclerUpgradeState.floorWarningKey = nil
                upgradeStatus = "WAITING FOR REBIRTH DATA"
                recyclerUpgradeState.status = "WAITING FOR REBIRTH DATA"
                break
            elseif reason == "need-floor" then
                UpgradeOps.setUpgradeFloorWait("main")
                upgradeStatus = "WAITING FOR FLOOR (until Tower/Rebirth changes)"
                break
            elseif reason == "rateLimited" then
                UpgradeOps.setUpgradeRateWait(1)
                upgradeStatus = "COOLDOWN (1.0s)"
                break
            elseif reason == "upgrade-queue-busy" then
                UpgradeOps.setUpgradeRateWait(0.25)
                upgradeStatus = "WAITING FOR UPGRADE QUEUE"
                break
            else
                blockedCandidates[candidate.label] = true
                upgradeStatus = "SKIPPED: " .. candidate.label
                task.wait(math.max(0.05, upgradeDelay))
            end
        else
            UpgradeOps.clearUpgradeMoneyWait("main")
            UpgradeOps.clearUpgradeRateWait(false)
            actions += 1
            print("[Upgrade UI] completed:", candidate.label, "cost", candidate.cost)
            task.wait(math.max(0.05, upgradeDelay))
        end
    end

    upgradeBusy = false
end

-- Recycler has a separate scan so a long Feeder/Coop progression does not hide
-- its status, but every invocation still passes through the shared money lock.
sharedEnv.ChickenRunRecyclerUpgradeCycle = function()
    if recyclerUpgradeState.busy
        or not upgradeEnabled
        or not upgradeRecycler then
        return
    end
    local initialWait = UpgradeOps.getUpgradeWaitStatus("recycler")
    if initialWait then
        recyclerUpgradeState.status = initialWait
        return
    end
    if os.clock() < (tonumber(recyclerUpgradeState.retryAt) or 0) then
        recyclerUpgradeState.status = "COOLDOWN ("
            .. string.format("%.1fs", recyclerUpgradeState.retryAt - os.clock()) .. ")"
        return
    end
    recyclerUpgradeState.busy = true
    recyclerUpgradeState.token += 1
    local token = recyclerUpgradeState.token
    recyclerUpgradeState.status = "SCANNING"
    local actions = 0

    for _ = 1, 200 do
        if token ~= recyclerUpgradeState.token or sharedEnv.ChickenArenaGeneration ~= generation then
            recyclerUpgradeState.status = "CANCELLED"
            break
        end
        local ok, candidates = pcall(function()
            return getUpgradeCandidates(true)
        end)
        if not ok then
            recyclerUpgradeState.status = "SCAN ERROR"
            warn("[Upgrade UI] Recycler candidate scan failed:", tostring(candidates))
            break
        end

        local gateFloor, clearedFloor, recyclerLevel = getRecyclerFloorGate()
        if gateFloor then
            -- The client can calculate this gate locally, so wait without
            -- touching the RemoteFunction.  UpgradeOps will release the wait
            -- only after Tower/Rebirth progress changes.
            UpgradeOps.setUpgradeFloorWait("recycler")
            recyclerUpgradeState.status = "WAITING FOR FLOOR (need "
                .. tostring(gateFloor) .. ", current " .. tostring(clearedFloor) .. ")"
            recyclerUpgradeState.floorBlockedLabel = "Recycler Lv." .. tostring(recyclerLevel)
            break
        end

        local candidate
        for _, item in ipairs(candidates) do
            if item.kind == "recycler" then
                candidate = item
                break
            end
        end
        if not candidate then
            recyclerUpgradeState.status = actions > 0 and "DONE" or "NO AVAILABLE UPGRADES"
            break
        end

        recyclerUpgradeState.status = "RUNNING: " .. candidate.label .. " ($" .. formatPower(candidate.cost) .. ")"
        local affordable = UpgradeOps.hasUpgradeFunds(candidate.cost)
        if not affordable then
            UpgradeOps.setUpgradeMoneyWait(candidate.cost, "recycler")
            recyclerUpgradeState.status = "WAITING FOR MONEY ($"
                .. formatPower(candidate.cost) .. ")"
            break
        end
        local invokeOk, response = UpgradeOps.invokeUpgradeCandidate(candidate)
        if not invokeOk or not responseSucceeded(response) then
            local reason = type(response) == "table" and response.error or response
            if reason == "need-floor" then
                -- A floor-gated Recycler can be checked again only after the
                -- Tower/Rebirth progress signature changes.  Keep one warning
                -- per signature/candidate so a long Tower run does not fill
                -- the console with the same expected server rejection.
                local sigOk, signature = pcall(UpgradeOps.getUpgradeProgressSignature)
                local warningKey = (sigOk and tostring(signature) or "unknown")
                    .. "|" .. tostring(candidate.label)
                if recyclerUpgradeState.floorWarningKey ~= warningKey then
                    warn("[Upgrade UI] Recycler action failed:", candidate.label, tostring(reason))
                    recyclerUpgradeState.floorWarningKey = warningKey
                end
                recyclerUpgradeState.floorBlockedLabel = candidate.label
            else
                warn("[Upgrade UI] Recycler action failed:", candidate.label, tostring(reason))
            end
            if reason == "not-enough-money" or reason == "notEnoughMoney" then
                UpgradeOps.setUpgradeMoneyWait(candidate.cost, "recycler")
                recyclerUpgradeState.status = "WAITING FOR MONEY ($"
                    .. formatPower(candidate.cost) .. ")"
            elseif reason == "need-floor" then
                UpgradeOps.setUpgradeFloorWait("recycler")
                recyclerUpgradeState.status = "WAITING FOR FLOOR (until Tower/Rebirth changes)"
            elseif reason == "rateLimited" then
                UpgradeOps.setUpgradeRateWait(1)
                recyclerUpgradeState.status = "COOLDOWN (1.0s)"
            elseif reason == "upgrade-queue-busy" then
                UpgradeOps.setUpgradeRateWait(0.25)
                recyclerUpgradeState.status = "WAITING FOR UPGRADE QUEUE"
            else
                recyclerUpgradeState.status = "SKIPPED: " .. candidate.label
            end
            break
        end

        actions += 1
        UpgradeOps.clearUpgradeMoneyWait("recycler")
        UpgradeOps.clearUpgradeRateWait(true)
        print("[Upgrade UI] completed:", candidate.label, "cost", candidate.cost, "(shared lock)")
        task.wait(math.max(0.05, upgradeDelay))
    end

    recyclerUpgradeState.busy = false
end

sharedEnv.ChickenRenderRebirthInfo = function(count, best, requirement, actualCoopReady)
    if not sharedEnv.ChickenRebirthInfoCache then
        return
    end

    local gap = math.max(0, requirement - best)
    local mode = autoTowerToRebirth and "TO REBIRTH" or (autoTower and "CONTINUOUS" or "OFF")
    local now = os.clock()
    local waitRemaining = math.max(0, towerNextStartAt - now)
    local towerPausedForUfo = autoTowerToRebirth
        and type(sharedEnv.ChickenTowerShouldPauseForUfo) == "function"
        and select(1, sharedEnv.ChickenTowerShouldPauseForUfo())
    local rebirthState = autoTowerToRebirth
        and (towerPausedForUfo and "PAUSED FOR UFO"
            or rebirthBusy and "PROCESSING"
            or (best < requirement and "LOCKED"
                or (towerBusy or towerRetreatBusy) and "READY - RETREATING"
                or (actualCoopReady and "READY" or "READY - WAITING FOR COOP")))
        or "DISABLED (continuous/off)"
    local towerStateText = towerBusy and "RUNNING"
        or (towerRetreatBusy and "RETREATING" or towerStatus)
    if towerPausedForUfo and not towerRetreatBusy and not rebirthBusy then
        towerStateText = towerRunState.active
            and "RUNNING - PAUSED FOR UFO"
            or "PAUSED FOR UFO"
    end
    local startFloorText = towerStartLatest and "LATEST +1" or "FLOOR 1"
    local afterRebirthWaitText = towerRunState.afterRebirthPending
        and (waitRemaining > 0 and formatCountdown(waitRemaining) or "READY")
        or "READY"
    local deathWaitText = towerDefeatPending
        and (waitRemaining > 0 and formatCountdown(waitRemaining) or "READY")
        or "READY"
    local runDuration = math.max(0, tonumber(sharedEnv.ChickenTowerTiming
        and sharedEnv.ChickenTowerTiming.runDuration) or 0)
    local runDeadline = tonumber(towerRunState.runDeadline) or 0
    local runWaitText
    if towerRunState.active and runDeadline > 0 then
        runWaitText = "RUNNING " .. formatCountdown(math.max(0, runDeadline - now))
    elseif runDuration > 0 then
        runWaitText = "SET " .. formatCountdown(runDuration)
    else
        runWaitText = "OFF"
    end
    local nextTowerDelay = math.max(0, tonumber(sharedEnv.ChickenTowerTiming
        and sharedEnv.ChickenTowerTiming.nextRunDelay) or 0)
    local nextTowerWaitText
    if not towerBusy and not towerDefeatPending and not towerRunState.afterRebirthPending
        and waitRemaining > 0 then
        nextTowerWaitText = "WAITING " .. formatCountdown(waitRemaining)
    elseif nextTowerDelay > 0 then
        nextTowerWaitText = "SET " .. formatCountdown(nextTowerDelay)
    else
        nextTowerWaitText = "NO DELAY"
    end
    local rebirthCycleText = "WAITING FOR FIRST REBIRTH"
    local lastCycleSeconds = math.max(0, tonumber(
        sharedEnv.ChickenRebirthCycleTimer
        and sharedEnv.ChickenRebirthCycleTimer.lastSeconds
    ) or 0)
    local cycleStartAt = tonumber(
        sharedEnv.ChickenRebirthCycleTimer
        and sharedEnv.ChickenRebirthCycleTimer.startAt
    ) or 0
    if cycleStartAt > 0 then
        local currentCycleText = formatCountdown(math.max(0, now - cycleStartAt))
        if lastCycleSeconds > 0 then
            rebirthCycleText = "LAST " .. formatCountdown(lastCycleSeconds)
                .. " | NOW " .. currentCycleText
        else
            rebirthCycleText = "RUNNING " .. currentCycleText
        end
    elseif lastCycleSeconds > 0 then
        rebirthCycleText = "LAST " .. formatCountdown(lastCycleSeconds)
    end
    local popupText = (autoDismissTowerPopup and "AUTO NO THANKS" or "MANUAL")
        .. (towerPopupVisible and " (OPEN)" or "")
    -- Keep the status card readable in MacLib's narrow right column.  Each
    -- line has one stable label and short values so the card does not wrap
    -- long compound sentences into hard-to-scan fragments.
    local lines = {
        "Mode: " .. mode,
        "Tower: " .. towerStateText,
        "Floor: " .. tostring(best) .. " -> " .. tostring(best + 1)
            .. " | Start " .. startFloorText,
        "Progress: " .. tostring(best) .. "/" .. tostring(requirement)
            .. " | Left " .. tostring(gap),
        "Prompt: " .. rebirthState,
        "Wait: Rebirth " .. afterRebirthWaitText,
        "Wait: Death " .. deathWaitText,
        "Run: " .. runWaitText,
        "Next: " .. nextTowerWaitText,
        "Cycle: " .. rebirthCycleText,
        "Popup: " .. popupText,
    }
    updateRebirthParagraphBody(table.concat(lines, "\n"))
end

local function updateRebirthInfo()
    local ok, tower, rebirth, count, best, requirement = pcall(getRebirthState)
    if not ok then
        updateRebirthParagraphBody("Unable to read Tower/Rebirth data.")
        return
    end

    local coopReady = autoTowerToRebirth and isRebirthPromptReady() or false
    sharedEnv.ChickenRebirthInfoCache = {
        count = count,
        best = best,
        requirement = requirement,
        actualCoopReady = coopReady,
    }
    sharedEnv.ChickenRenderRebirthInfo(count, best, requirement, coopReady)
end

sharedEnv.ChickenUpdateRebirthCountdown = function()
    local snapshot = sharedEnv.ChickenRebirthInfoCache
    if snapshot then
        sharedEnv.ChickenRenderRebirthInfo(snapshot.count, snapshot.best, snapshot.requirement, snapshot.actualCoopReady)
    end
end

-- Avoid rebuilding MacLib paragraphs when the Arena snapshot is unchanged.
-- Keep the cache in sharedEnv so this large top-level chunk does not gain
-- more closure registers (Luau's 200-register limit is tight here).
sharedEnv.ChickenArenaLastBattleBody = nil
sharedEnv.ChickenArenaLastOpponentsBody = nil

local function updateArenaInfo(data)
    if type(data) ~= "table" then
        local battleBody = "Arena data unavailable.\nRetrying..."
        local opponentsBody = "Unable to read opponents."
        if sharedEnv.ChickenArenaLastBattleBody ~= battleBody then
            sharedEnv.ChickenArenaLastBattleBody = battleBody
            BattleParagraph:UpdateBody(battleBody)
        end
        if sharedEnv.ChickenArenaLastOpponentsBody ~= opponentsBody then
            sharedEnv.ChickenArenaLastOpponentsBody = opponentsBody
            OpponentsParagraph:UpdateBody(opponentsBody)
        end
        return
    end

    local opponents = data.opponents or {}
    local currentIndex = #opponents > 0
        and math.min((tonumber(data.cursor) or 0) + 1, #opponents)
        or 0
    local current = opponents[currentIndex]
    local teamPower = parsePower(data.teamPower)
    local skipsLeft = math.max(0, tonumber(data.skips) or 0)
    local maxSkips = math.max(0, tonumber(data.maxSkips) or 0)
    local refreshIn = math.max(0, tonumber(data.refreshIn) or 0)
    local skipStatus
    if skipsLeft <= 0 and refreshIn > 0 then
        skipStatus = "Skip: COOLDOWN " .. formatCountdown(refreshIn)
    elseif skipsLeft <= 0 then
        skipStatus = "Skip: UNAVAILABLE"
    else
        skipStatus = "Skip: READY (" .. tostring(skipsLeft) .. "/" .. tostring(maxSkips) .. ")"
    end

    local battleLines = {
        "Our power: " .. tostring(data.teamPower or "?"),
        "Rank: " .. tostring(data.rank or "?") .. "  |  Trophies: " .. tostring(data.trophies or "?"),
        "Status: " .. (data.hasActiveMatch and "FIGHTING" or (data.available and "READY" or "WAITING"))
            .. "  |  " .. skipStatus,
    }
    local eventPause = sharedEnv.ChickenArenaEventPause
    if type(eventPause) == "table" and eventPause.active then
        table.insert(battleLines, 1, "Arena: PAUSED FOR " .. tostring(eventPause.reason or "UFO"))
    end

    if current then
        local enemyPower = parsePower(current.power)
        local difference = teamPower - enemyPower
        table.insert(battleLines, "")
        table.insert(battleLines, "Opponent: #" .. currentIndex .. " " .. tostring(current.name or "?"))
        table.insert(battleLines, "Enemy power: " .. tostring(current.power or "?"))
        table.insert(battleLines, "Power gap: " .. (difference >= 0 and "+" or "") .. formatPower(difference))
        table.insert(battleLines, difference >= 0 and "Advantage: OUR TEAM" or "Advantage: OPPONENT")
    else
        table.insert(battleLines, "\nOpponent: none")
    end
    local battleBody = table.concat(battleLines, "\n")
    if sharedEnv.ChickenArenaLastBattleBody ~= battleBody then
        sharedEnv.ChickenArenaLastBattleBody = battleBody
        BattleParagraph:UpdateBody(battleBody)
    end

    local weakestIndex
    local weakestPower = math.huge
    for i, opponent in ipairs(opponents) do
        local power = parsePower(opponent.power)
        if power < weakestPower then
            weakestPower = power
            weakestIndex = i
        end
    end

    local opponentLines = {}
    for i, opponent in ipairs(opponents) do
        local markers = {}
        if i == weakestIndex then
            table.insert(markers, "WEAKEST")
        end
        if i == currentIndex then
            table.insert(markers, data.hasActiveMatch and "FIGHTING" or "SELECTED")
        end
        local marker = #markers > 0 and "  [" .. table.concat(markers, ", ") .. "]" or ""
        table.insert(opponentLines, string.format(
            "%d. %s\n    %s%s",
            i,
            tostring(opponent.name or "?"),
            tostring(opponent.power or "?"),
            marker
        ))
    end

    if #opponentLines == 0 then
        table.insert(opponentLines, "No opponents available.")
    end
    table.insert(opponentLines, "")
    table.insert(opponentLines, string.format(
        "Skips: %s/%s  |  Pos: %s/5",
        tostring(skipsLeft),
        tostring(maxSkips),
        tostring(currentIndex)
    ))
    table.insert(opponentLines, skipStatus)
    local opponentsBody = table.concat(opponentLines, "\n")
    if sharedEnv.ChickenArenaLastOpponentsBody ~= opponentsBody then
        sharedEnv.ChickenArenaLastOpponentsBody = opponentsBody
        OpponentsParagraph:UpdateBody(opponentsBody)
    end
end

local function selectSmartOpponent(data)
    local opponents = data and data.opponents
    if type(opponents) ~= "table" or #opponents == 0 then
        return data, nil, true
    end

    local currentIndex = math.min((tonumber(data.cursor) or 0) + 1, #opponents)
    local ourPower = parsePower(data.teamPower)
    if ourPower == math.huge then
        ourPower = 0
    end

    local skipsLeft = math.max(0, tonumber(data.skips) or 0)
    local reachableEnd = math.min(#opponents, currentIndex + skipsLeft)
    local targetIndex

    -- Prefer the first reachable opponent we already overpower; this saves skips.
    for i = currentIndex, reachableEnd do
        if ourPower >= parsePower(opponents[i] and opponents[i].power) then
            targetIndex = i
            break
        end
    end

    -- If every reachable opponent is stronger, pick the weakest reachable one.
    if not targetIndex then
        targetIndex = currentIndex
        local lowestPower = parsePower(opponents[currentIndex] and opponents[currentIndex].power)
        for i = currentIndex + 1, reachableEnd do
            local power = parsePower(opponents[i] and opponents[i].power)
            if power < lowestPower then
                lowestPower = power
                targetIndex = i
            end
        end
    end

    print(
        "[Arena UI] plan:",
        "current", currentIndex,
        "target", targetIndex,
        "skips", skipsLeft,
        "our", tostring(data.teamPower),
        "enemy", tostring(opponents[targetIndex] and opponents[targetIndex].power)
    )

    if targetIndex == currentIndex then
        return data, currentIndex, false
    end

    local attempts = 0
    while currentIndex < targetIndex and attempts < 5 do
        attempts += 1

        local skipOk, skipResponse = invokeRemoteWithTimeout(arenaSkip, 0.75)
        if not skipOk or type(skipResponse) ~= "table" or not skipResponse.ok then
            local reason = type(skipResponse) == "table" and skipResponse.error or skipResponse
            warn("[Arena UI] ArenaSkip failed:", tostring(reason))
            if tostring(reason) == "match-in-progress" or tostring(reason) == "battle_in_progress" then
                return data, currentIndex, true
            end
            warn("[Arena UI] skip unavailable; fighting current opponent")
            return data, currentIndex, false
        end

        local previousIndex = currentIndex
        task.wait(0.5)
        local refreshOk, refreshed = getArenaView(1.0, true)
        if not (refreshOk and type(refreshed) == "table" and refreshed.ok and type(refreshed.data) == "table") then
            warn("[Arena UI] could not refresh after ArenaSkip")
            return data, currentIndex, true
        end

        data = refreshed.data
        opponents = data.opponents or opponents
        currentIndex = math.min((tonumber(data.cursor) or 0) + 1, #opponents)
        print("[Arena UI] skip moved to:", currentIndex, "/ target", targetIndex)

        if currentIndex <= previousIndex then
            -- The Skip response can arrive before the server updates the
            -- cursor. Re-read briefly before deciding that Skip was unusable.
            local settleAttempts = 0
            while currentIndex <= previousIndex and settleAttempts < 3 do
                settleAttempts += 1
                task.wait(0.35)
                local settleOk, settled = getArenaView(1.0, true)
                if settleOk and type(settled) == "table"
                    and settled.ok and type(settled.data) == "table" then
                    data = settled.data
                    opponents = data.opponents or opponents
                    currentIndex = math.min((tonumber(data.cursor) or 0) + 1, #opponents)
                end
            end
            if currentIndex <= previousIndex then
                warn("[Arena UI] cursor did not advance; fighting current opponent")
                return data, currentIndex, false
            end
            print("[Arena UI] skip cursor settled at:", currentIndex, "/ target", targetIndex)
        end
    end

    return data, currentIndex, currentIndex ~= targetIndex
end

local function styleTopRightMinimize()
    -- Match the main script title exactly.  Looking for the username (or a
    -- generic title) can accidentally select the standalone UI Scale window,
    -- because both Maclib windows show the same user info.
    local gui
    for _, item in CoreGui:GetDescendants() do
        if item:IsA("TextLabel") and item.Text == "Script " .. SCRIPT_VERSION then
            gui = item:FindFirstAncestorOfClass("ScreenGui")
            break
        end
    end

    local base = gui and gui:FindFirstChild("Base")
    local sidebar = base and base:FindFirstChild("Sidebar")
    local controls = sidebar and sidebar:FindFirstChild("WindowControls")
    local controlsHolder = controls and controls:FindFirstChild("Controls")
    local minimize = (base and base:FindFirstChild("Minimize"))
        or (controlsHolder and controlsHolder:FindFirstChild("Minimize"))

    if not (base and controls and minimize) then
        warn("[Arena UI] could not style minimize button")
        return
    end

    minimize.Parent = base

    local closeButton = base:FindFirstChild("ChickenFighterClose")
    if not closeButton then
        closeButton = Instance.new("TextButton")
        closeButton.Name = "ChickenFighterClose"
        closeButton.Parent = base
        closeButton.Activated:Connect(unloadScript)
    end

    minimize.AnchorPoint = Vector2.new(1, 0)
    minimize.Position = UDim2.new(1, -40, 0, 4)
    minimize.Size = UDim2.fromOffset(34, 26)
    minimize.BackgroundTransparency = 1
    minimize.Text = "-"
    minimize.TextColor3 = Color3.fromRGB(235, 235, 235)
    minimize.TextSize = 18
    minimize.Font = Enum.Font.GothamMedium
    minimize.ZIndex = 100
    minimize.Visible = true

    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -8, 0, 4)
    closeButton.Size = UDim2.fromOffset(26, 26)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(235, 235, 235)
    closeButton.TextSize = 15
    closeButton.Font = Enum.Font.GothamMedium
    closeButton.ZIndex = 100
    closeButton.Visible = true

    local corner = minimize:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(0, 4)
    end

    controls.Visible = false

    -- MacLib hides the whole window when Minimize is pressed.  Keep a small
    -- floating restore button in a separate ScreenGui so the window can be
    -- opened again even while the main Base is invisible.  The monitor also
    -- covers the configured UI toggle key, not only the mouse button.
    local iconGui = sharedEnv.ChickenArenaMinimizeIconGui
    if not (iconGui and iconGui.Parent) then
        iconGui = Instance.new("ScreenGui")
        iconGui.Name = "ChickenArenaMinimizeIconV2"
        iconGui.ResetOnSpawn = false
        iconGui.IgnoreGuiInset = true
        iconGui.DisplayOrder = 100000
        iconGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        iconGui.Parent = CoreGui
        sharedEnv.ChickenArenaMinimizeIconGui = iconGui
    end

    local restoreIcon = iconGui:FindFirstChild("Restore")
    if not (restoreIcon and restoreIcon:IsA("TextButton")) then
        if restoreIcon then
            restoreIcon:Destroy()
        end
        restoreIcon = Instance.new("TextButton")
        restoreIcon.Name = "Restore"
        restoreIcon.Parent = iconGui
    end

    -- Keep the clickable surface transparent and draw the Q on a separate
    -- circular Frame.  This removes the rectangular ImageButton background.
    for _, child in restoreIcon:GetChildren() do
        child:Destroy()
    end
    restoreIcon.AnchorPoint = Vector2.new(0, 0)
    restoreIcon.Size = UDim2.fromOffset(42, 42)
    restoreIcon.BackgroundTransparency = 1
    restoreIcon.BorderSizePixel = 0
    restoreIcon.AutoButtonColor = false
    restoreIcon.Text = ""
    restoreIcon.ZIndex = 200

    local circleFace = Instance.new("Frame")
    circleFace.Name = "CircleFace"
    circleFace.Size = UDim2.fromScale(1, 1)
    circleFace.BackgroundColor3 = Color3.fromRGB(31, 37, 45)
    -- Keep only the circular outline visible.  Some executors render a
    -- Frame fill as a rectangle even when a UICorner is present.
    circleFace.BackgroundTransparency = 1
    circleFace.BorderSizePixel = 0
    circleFace.ClipsDescendants = true
    circleFace.Active = false
    circleFace.ZIndex = 201
    circleFace.Parent = restoreIcon

    local iconCorner = Instance.new("UICorner")
    iconCorner.Name = "Circle"
    iconCorner.CornerRadius = UDim.new(0.5, 0)
    iconCorner.Parent = circleFace

    local iconStroke = Instance.new("UIStroke")
    iconStroke.Name = "CircleStroke"
    iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    iconStroke.Color = Color3.fromRGB(100, 190, 255)
    iconStroke.Thickness = 1
    iconStroke.Transparency = 0.15
    iconStroke.Parent = circleFace

    local glyph = Instance.new("TextLabel")
    glyph.Name = "Glyph"
    glyph.Size = UDim2.fromScale(1, 1)
    glyph.BackgroundTransparency = 1
    glyph.Text = "Q"
    glyph.TextColor3 = Color3.fromRGB(235, 245, 255)
    glyph.TextSize = 21
    glyph.Font = Enum.Font.GothamBold
    glyph.TextXAlignment = Enum.TextXAlignment.Center
    glyph.TextYAlignment = Enum.TextYAlignment.Center
    glyph.ZIndex = 202
    glyph.Parent = circleFace

    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
        or Vector2.new(800, 600)
    local iconWidth, iconHeight = 42, 42
    local savedPosition = sharedEnv.ChickenArenaMinimizeIconPosition
    local iconX = type(savedPosition) == "table" and tonumber(savedPosition.x) or nil
    local iconY = type(savedPosition) == "table" and tonumber(savedPosition.y) or nil
    if not iconX then
        iconX = 14
    end
    if not iconY then
        iconY = 60
    end
    iconX = math.clamp(iconX, 4, math.max(4, viewport.X - iconWidth - 4))
    iconY = math.clamp(iconY, 4, math.max(4, viewport.Y - iconHeight - 4))
    restoreIcon.Position = UDim2.fromOffset(iconX, iconY)

    local dragState = sharedEnv.ChickenArenaMinimizeIconDragState
    if type(dragState) ~= "table" then
        dragState = {
            active = false,
            moved = false,
            input = nil,
            startInput = nil,
            startPosition = nil,
            ignoreNextClick = false,
        }
        sharedEnv.ChickenArenaMinimizeIconDragState = dragState
    end

    if sharedEnv.ChickenArenaMinimizeIconDragBound ~= restoreIcon then
        if sharedEnv.ChickenArenaMinimizeIconDragConnections then
            for _, connection in ipairs(sharedEnv.ChickenArenaMinimizeIconDragConnections) do
                pcall(function()
                    connection:Disconnect()
                end)
            end
        end
        local connections = {}
        sharedEnv.ChickenArenaMinimizeIconDragConnections = connections
        sharedEnv.ChickenArenaMinimizeIconDragBound = restoreIcon

        table.insert(connections, restoreIcon.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            dragState.active = true
            dragState.moved = false
            dragState.ignoreNextClick = false
            dragState.input = input
            dragState.startInput = input.Position
            dragState.startPosition = restoreIcon.Position
        end))

        table.insert(connections, restoreIcon.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragState.input = input
            end
        end))

        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if not dragState.active or input ~= dragState.input
                or not dragState.startInput or not dragState.startPosition then
                return
            end
            local delta = input.Position - dragState.startInput
            if math.abs(delta.X) + math.abs(delta.Y) > 4 then
                dragState.moved = true
            end
            if not dragState.moved then
                return
            end
            local currentViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                or viewport
            local x = dragState.startPosition.X.Offset + delta.X
            local y = dragState.startPosition.Y.Offset + delta.Y
            x = math.clamp(x, 4, math.max(4, currentViewport.X - iconWidth - 4))
            y = math.clamp(y, 4, math.max(4, currentViewport.Y - iconHeight - 4))
            restoreIcon.Position = UDim2.fromOffset(x, y)
            sharedEnv.ChickenArenaMinimizeIconPosition = {x = x, y = y}
        end))

        table.insert(connections, UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if not dragState.active then
                return
            end
            dragState.active = false
            if dragState.moved then
                dragState.ignoreNextClick = true
            end
            dragState.input = nil
            dragState.startInput = nil
            dragState.startPosition = nil
        end))

        restoreIcon.Activated:Connect(function()
            if dragState.ignoreNextClick or dragState.moved then
                dragState.ignoreNextClick = false
                dragState.moved = false
                return
            end
            if sharedEnv.ChickenArenaMacWindow ~= Window then
                return
            end
            restoreIcon.Visible = false
            pcall(function()
                Window:SetState(true)
            end)
            task.defer(styleTopRightMinimize)
        end)
    end

    local trackedGui = sharedEnv.ChickenArenaMinimizeIconTrackedGui
    local trackedBase = sharedEnv.ChickenArenaMinimizeIconTrackedBase
    if trackedGui ~= gui or trackedBase ~= base
        or not sharedEnv.ChickenArenaMinimizeIconConnection then
        if sharedEnv.ChickenArenaMinimizeIconConnection then
            pcall(function()
                sharedEnv.ChickenArenaMinimizeIconConnection:Disconnect()
            end)
        end
        sharedEnv.ChickenArenaMinimizeIconTrackedGui = gui
        sharedEnv.ChickenArenaMinimizeIconTrackedBase = base
        local elapsed = 0
        sharedEnv.ChickenArenaMinimizeIconConnection = RunService.Heartbeat:Connect(function(delta)
            elapsed += delta
            if elapsed < 0.1 then
                return
            end
            elapsed = 0
            if not iconGui.Parent then
                return
            end
            if not gui.Parent or not base.Parent then
                restoreIcon.Visible = false
                return
            end
            restoreIcon.Visible = not (gui.Enabled and base.Visible)
        end)
    end
    restoreIcon.Visible = not (gui.Enabled and base.Visible)
end

task.defer(styleTopRightMinimize)

setAutoAbility:FireServer(true)
ArenaTab:Select()
-- ArenaGetView for the status card is view-scoped.  Sync the initial tab
-- state after MacLib finishes applying the default selection; subsequent
-- tab clicks are handled by ChickenStatsTabClick below.
if type(sharedEnv.ChickenStatsTabClick) == "function" then
    sharedEnv.ChickenStatsTabClick()
end

sharedEnv.ChickenArenaCoreConnections = {}

local function dismissArenaResult()
    local clickedOverlay = false
    -- Do not activate the result button: the game's result callback opens the
    -- Arena Home screen again. Clear state and close the window directly.
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local playerScripts = player and player:FindFirstChild("PlayerScripts")
        local ui = playerScripts and playerScripts:FindFirstChild("UI")
        local twoD = ui and ui:FindFirstChild("2d")
        local arena = twoD and twoD:FindFirstChild("Arena")
        local hud = twoD and twoD:FindFirstChild("HUD")
        local arenaStateModule = arena and arena:FindFirstChild("ArenaState")
        local windowStateModule = hud and hud:FindFirstChild("WindowState")
        if arenaStateModule and windowStateModule then
            -- ArenaController already clears ArenaState when it receives the
            -- authoritative ArenaBattleResult.  Do not call
            -- ArenaClient.cancelBattle() here: that method fires the
            -- ArenaBattleCancel RemoteEvent and can race the completed
            -- result, leaving the next match in a slow/stale transition.
            require(arenaStateModule).result(nil)
            require(windowStateModule).arena(false)
            -- React can finish the result transition on the next frame. Close
            -- once more after that transition so Arena Home cannot reopen.
            task.delay(0.15, function()
                pcall(function()
                    require(windowStateModule).arena(false)
                end)
            end)
        end
    end)
    print("[Arena UI] result window dismissed", clickedOverlay and "(overlay click)" or "(state fallback)")
end

table.insert(sharedEnv.ChickenArenaCoreConnections, arenaBattleResult.OnClientEvent:Connect(function(result)
    if sharedEnv.ChickenArenaGeneration ~= generation or type(result) ~= "table" or result.won == nil then
        return
    end
    -- The result is authoritative: release the cross-generation gate before
    -- the next ArenaGetView request so the next match can be started cleanly.
    sharedEnv.ChickenArenaFightGate.busy = false
    sharedEnv.ChickenArenaFightGate.startedAt = 0
    sharedEnv.ChickenArenaFightGate.expiresAt = 0
    -- The server briefly reports the old match as ending. Give it a short
    -- transition window instead of allowing ArenaFight to hit battle_in_progress.
    arenaTransitionUntil = os.clock() + ARENA_RESULT_TRANSITION
    arenaViewCache = nil
    arenaViewCacheAt = 0
    task.delay(0.05, function()
        if sharedEnv.ChickenArenaGeneration == generation then
            dismissArenaResult()
        end
    end)
end))

local function getTowerRunClientState()
    if not ChickenMode then
        return nil
    end
    local ok, order, where = pcall(function()
        return ChickenMode.order(), ChickenMode.where()
    end)
    if not ok then
        return nil
    end

    local orderText = string.lower(tostring(order or ""))
    local whereText = string.lower(tostring(where or ""))
    if orderText == "tower" or orderText == "battle"
        or string.find(orderText, "tower", 1, true)
        or string.find(orderText, "battle", 1, true)
        or string.find(whereText, "tower", 1, true)
        or string.find(whereText, "battle", 1, true) then
        return true
    end
    if orderText == "coop" or whereText == "corral" or whereText == "campaign" then
        return false
    end
    return nil
end

-- A reload can happen while the server still owns the previous Tower run and
-- before its TowerRunStarted event is delivered again.  Rehydrate the local
-- latch from the authoritative Arena attribute so we do not send a duplicate
-- TowerStart immediately after reload.
if towerRunState.serverRunActive() then
    towerBusy = true
    towerRunState.active = true
    towerStatus = "RUNNING - SERVER ACTIVE"
    towerRunState.actionAt = os.clock()
    if type(sharedEnv.ChickenArmTowerRunDuration) == "function" then
        sharedEnv.ChickenArmTowerRunDuration()
    end
end
table.insert(sharedEnv.ChickenArenaCoreConnections, towerRunStarted.OnClientEvent:Connect(function(payload)
    if sharedEnv.ChickenArenaGeneration == generation
        and towerRunState.eventMatchesLocal(payload) then
        towerBusy = true
        towerRunState.active = true
        towerRunState.busyRetryCount = 0
        towerRunState.startRetryAt = 0
        towerRunState.settleUntil = 0
        towerRunState.afterRebirthPending = false
        if type(sharedEnv.ChickenArmTowerRunDuration) == "function" then
            sharedEnv.ChickenArmTowerRunDuration()
        end
        towerDefeatPending = false
        towerStatus = "RUNNING"
        towerRunState.actionAt = os.clock()
        print("[Rebirth UI] tower run started")
    end
end))
table.insert(sharedEnv.ChickenArenaCoreConnections, towerRunEnded.OnClientEvent:Connect(function(payload)
    if sharedEnv.ChickenArenaGeneration == generation
        and towerRunState.eventMatchesLocal(payload) then
        towerBusy = false
        towerRunState.active = false
        towerRunState.busyRetryCount = 0
        towerRunState.runDeadline = 0
        if towerDefeatPending then
            towerStatus = "DEFEATED - WAITING"
        elseif towerRunState.afterRebirthPending then
            -- A late TowerRunEnded event must not erase the post-Rebirth
            -- delay that was scheduled by the successful Rebirth response.
            towerStatus = "REBIRTH COMPLETE - WAITING"
        else
            -- TowerRunEnded can arrive just before the server finishes
            -- releasing the previous Tower session.  Keep a short local
            -- settle gate so the next TowerStart cannot race that cleanup,
            -- then apply the user-configured delay before the next loop.
            local settleAt = os.clock() + 1
            local nextDelay = math.max(0, tonumber(sharedEnv.ChickenTowerTiming
                and sharedEnv.ChickenTowerTiming.nextRunDelay) or 0)
            towerRunState.settleUntil = settleAt
            towerNextStartAt = math.max(settleAt, os.clock() + nextDelay)
            towerStatus = nextDelay > 0
                and "COOP - WAITING FOR NEXT TOWER"
                or "FLOOR CLEARED - SETTLING"
        end
        print("[Rebirth UI] tower run ended")
    end
end))
table.insert(sharedEnv.ChickenArenaCoreConnections, towerDefeat.OnClientEvent:Connect(function(payload)
    if sharedEnv.ChickenArenaGeneration == generation
        and towerRunState.eventMatchesLocal(payload) then
        -- Keep the server-run latch until TowerRunEnded arrives.  Clearing it
        -- here would allow the 0-second death-delay path to start another run
        -- while the old Tower instance is still being torn down.
        towerRunState.active = true
        towerRunState.afterRebirthPending = false
        towerRunState.runDeadline = 0
        towerBusy = false
        towerDefeatPending = true
        towerNextStartAt = os.clock() + towerDeathDelay
        towerStatus = towerDeathDelay > 0 and "DEFEATED - WAITING" or "DEFEATED - READY"
        print("[Rebirth UI] tower run defeated")
    end
end))
table.insert(sharedEnv.ChickenArenaCoreConnections, towerContinueOffer.OnClientEvent:Connect(function(payload)
    if sharedEnv.ChickenArenaGeneration ~= generation
        or not towerRunState.eventMatchesLocal(payload) then
        return
    end

    towerPopupVisible = true
    towerStatus = "DEATH POPUP"
    if autoDismissTowerPopup then
        task.delay(0.1, function()
            if sharedEnv.ChickenArenaGeneration ~= generation then
                return
            end
            local ok, err = pcall(function()
                towerContinueDecline:FireServer()
            end)
            towerPopupVisible = false
            if ok then
                towerStatus = "NO THANKS"
                print("[Rebirth UI] dismissed tower continue popup")
            else
                warn("[Rebirth UI] could not dismiss tower popup:", tostring(err))
            end
        end)
    end
end))

task.spawn(function()
    local nextDataPollAt = 0
    while sharedEnv.ChickenArenaGeneration == generation do
        -- MacLib can throw a Plugin-capability error while the Rebirth card
        -- is being rebuilt. Keep that UI error from terminating this loop.
        local now = os.clock()
        if now >= nextDataPollAt then
            pcall(updateRebirthInfo)
            nextDataPollAt = now + 2
        else
            -- Countdown rendering is local-only; do not poll DataService more
            -- often just to make the displayed timer feel real-time.
            pcall(sharedEnv.ChickenUpdateRebirthCountdown)
        end
        task.wait(0.2)
    end
end)

task.spawn(function()
    print("[Egg UI] controller loaded; collectors are off by default")
    while sharedEnv.ChickenArenaGeneration == generation do
        pcall(updateEggInfo)

        local dataOk, data = pcall(function()
            return DataService.client:get({}) or {}
        end)
        if dataOk and type(data) == "table" then
            local incubator = data.incubator or {}
            local readyEggs = incubator.eggs or {}
            if autoIncubator and #readyEggs > 0 then
                claimIncubatorEggs()
            end
        end

        if autoNest and not eggBusy then
            task.spawn(collectNestEggs)
        end

        task.wait(3)
    end
end)

task.spawn(function()
    print("[Hatching UI] controller loaded; Auto Hatching:", sharedEnv.ChickenHatchingState.enabled and "on" or "off")
    local nextRosterRefresh = 0
    while sharedEnv.ChickenArenaGeneration == generation do
        local now = os.clock()
        if now >= nextRosterRefresh then
            nextRosterRefresh = now + 2
            pcall(sharedEnv.ChickenHatchingRefresh)
        end
        if sharedEnv.ChickenHatchingState.enabled then
            pcall(sharedEnv.ChickenHatchingRun)
        end
        pcall(sharedEnv.ChickenHatchingStatus)
        task.wait(0.25)
    end
end)

-- Fast Coop Deploy controller. This intentionally uses SetActiveChicken (the
-- same remote as the game's Collection UI) rather than Incubator remotes.
sharedEnv.ChickenFastIncubatorCoopPhase = nil
sharedEnv.ChickenFastIncubatorCoopPhaseAt = 0
sharedEnv.ChickenFastIncubatorCoopBusy = false
sharedEnv.ChickenFastIncubatorCoopLastActionAt = 0

sharedEnv.ChickenFastCoopGetRoster = function()
    local ok, data = pcall(function()
        return DataService.client:get({"roster"}) or {}
    end)
    if not ok or type(data) ~= "table" then
        return nil
    end
    local roster = data.roster or data
    if type(roster) ~= "table" then
        return nil
    end
    local byId = {}
    if type(roster.chickens) == "table" then
        for _, chicken in ipairs(roster.chickens) do
            if type(chicken) == "table" and type(chicken.id) == "string" then
                byId[chicken.id] = chicken
            end
        end
    end
    if next(byId) then
        sharedEnv.ChickenFastIncubatorRosterById = byId
        sharedEnv.ChickenFastIncubatorRosterAt = os.clock()
    end
    return type(roster.activeId) == "string" and roster.activeId or nil
end

sharedEnv.ChickenFastCoopGetNextEggRemaining = function()
    local workspaceService = game:GetService("Workspace")
    local chickenBodies = workspaceService:FindFirstChild("ChickenBodies")
    local localPlayer = Players.LocalPlayer
    if not chickenBodies or not localPlayer then
        return nil
    end
    local now = workspaceService:GetServerTimeNow()
    local bestRemaining = nil
    for _, body in ipairs(chickenBodies:GetChildren()) do
        local entityId = tostring(body:GetAttribute("entityId") or "")
        local owner = tonumber(body:GetAttribute("ovOwner"))
        local nextEgg = tonumber(body:GetAttribute("ovNextEgg"))
        if string.sub(entityId, 1, 5) == "coop:"
            and owner == localPlayer.UserId
            and nextEgg and nextEgg > 0 then
            local remaining = math.max(0, nextEgg - now)
            if not bestRemaining or remaining < bestRemaining then
                bestRemaining = remaining
            end
        end
    end
    return bestRemaining
end

sharedEnv.ChickenFastCoopDeployChicken = function(id, label)
    if sharedEnv.ChickenFastIncubatorCoopBusy then
        return false
    end
    if type(id) ~= "string" or id == "" then
        sharedEnv.ChickenFastIncubatorStatus = "SELECT SOURCE/TARGET CHICKENS"
        return false
    end
    sharedEnv.ChickenFastIncubatorCoopBusy = true
    sharedEnv.ChickenFastIncubatorCoopLastActionAt = os.clock()
    local ok, response = pcall(function()
        local deployRemote = remotes:FindFirstChild("SetActiveChicken")
        if not deployRemote then
            error("SetActiveChicken remote not found")
        end
        return deployRemote:InvokeServer(id)
    end)
    sharedEnv.ChickenFastIncubatorCoopBusy = false
    if not ok or (type(response) == "table" and response.ok == false) then
        local reason = type(response) == "table" and response.error or response
        sharedEnv.ChickenFastIncubatorStatus = "DEPLOY FAILED"
        warn("[Egg UI] Fast Coop deploy failed:", tostring(reason))
        return false
    end
    sharedEnv.ChickenFastIncubatorCoopPhase = label
    sharedEnv.ChickenFastIncubatorCoopPhaseAt = os.clock()
    sharedEnv.ChickenFastIncubatorStatus = "DEPLOYED " .. string.upper(label)
    print("[Egg UI] Fast Coop deployed " .. label .. ":", id)
    return true
end

sharedEnv.ChickenFastIncubatorSwapToTarget = function()
    local targetId = sharedEnv.ChickenFastIncubatorTargetId
    return sharedEnv.ChickenFastCoopDeployChicken(targetId, "target")
end

sharedEnv.ChickenFastIncubatorSwapToSource = function()
    local sourceId = sharedEnv.ChickenFastIncubatorSourceId
    return sharedEnv.ChickenFastCoopDeployChicken(sourceId, "source")
end

sharedEnv.ChickenFastIncubatorRun = function()
    if not sharedEnv.ChickenFastIncubatorEnabled or sharedEnv.ChickenFastIncubatorCoopBusy then
        return
    end

    local sourceId = sharedEnv.ChickenFastIncubatorSourceId
    local targetId = sharedEnv.ChickenFastIncubatorTargetId
    if type(sourceId) ~= "string" or type(targetId) ~= "string" or sourceId == targetId then
        sharedEnv.ChickenFastIncubatorStatus = "SELECT DIFFERENT SOURCE/TARGET"
        return
    end

    local activeId = sharedEnv.ChickenFastCoopGetRoster()
    if not activeId then
        sharedEnv.ChickenFastIncubatorStatus = "WAITING FOR COOP DATA"
        return
    end

    local now = os.clock()
    local phase = sharedEnv.ChickenFastIncubatorCoopPhase
    local phaseAt = tonumber(sharedEnv.ChickenFastIncubatorCoopPhaseAt) or 0
    local actionAge = now - (tonumber(sharedEnv.ChickenFastIncubatorCoopLastActionAt) or 0)
    local targetDelay = math.max(0.1, tonumber(sharedEnv.ChickenFastIncubatorSwapSeconds) or 1)
    local returnDelay = math.max(0.1, tonumber(sharedEnv.ChickenFastIncubatorReturnSeconds) or 3)

    if not phase then
        if activeId == targetId then
            phase = "target"
            phaseAt = now
        elseif activeId == sourceId then
            phase = "source"
            phaseAt = now
        else
            sharedEnv.ChickenFastCoopDeployChicken(sourceId, "source")
            return
        end
        sharedEnv.ChickenFastIncubatorCoopPhase = phase
        sharedEnv.ChickenFastIncubatorCoopPhaseAt = phaseAt
    end

    if phase == "target" then
        if activeId ~= targetId and actionAge < 1.5 then
            -- Roster snapshots can lag the SetActiveChicken response. Trust
            -- the just-completed deploy briefly instead of resetting the
            -- phase and issuing another deploy from stale activeId data.
            sharedEnv.ChickenFastIncubatorStatus = "DEPLOYING TARGET"
            return
        elseif activeId == sourceId then
            -- A manual change outside the controller starts a fresh Source
            -- phase instead of forcing an immediate Target deploy.
            sharedEnv.ChickenFastIncubatorCoopPhase = "source"
            sharedEnv.ChickenFastIncubatorCoopPhaseAt = now
            phase = "source"
            phaseAt = now
        elseif activeId ~= targetId then
            sharedEnv.ChickenFastIncubatorStatus = "DEPLOYING TARGET"
            if now - (sharedEnv.ChickenFastIncubatorCoopLastActionAt or 0) > 5 then
                sharedEnv.ChickenFastCoopDeployChicken(targetId, "target")
            end
            return
        else
            local remaining = math.max(0, returnDelay - (now - phaseAt))
            if remaining <= 0 then
                sharedEnv.ChickenFastCoopDeployChicken(sourceId, "source")
            else
                sharedEnv.ChickenFastIncubatorStatus = "TARGET ACTIVE - SOURCE IN " .. string.format("%.1fs", remaining)
            end
            return
        end
    end

    if phase == "source" then
        if activeId ~= sourceId and actionAge < 1.5 then
            sharedEnv.ChickenFastIncubatorStatus = "DEPLOYING SOURCE"
            return
        elseif activeId == targetId then
            sharedEnv.ChickenFastIncubatorCoopPhase = "target"
            sharedEnv.ChickenFastIncubatorCoopPhaseAt = now
            phase = "target"
            phaseAt = now
        elseif activeId ~= sourceId then
            sharedEnv.ChickenFastIncubatorStatus = "DEPLOYING SOURCE"
            if now - (sharedEnv.ChickenFastIncubatorCoopLastActionAt or 0) > 5 then
                sharedEnv.ChickenFastCoopDeployChicken(sourceId, "source")
            end
            return
        else
            local nextEggRemaining = sharedEnv.ChickenFastCoopGetNextEggRemaining()
            if nextEggRemaining and nextEggRemaining <= targetDelay then
                sharedEnv.ChickenFastCoopDeployChicken(targetId, "target")
            elseif nextEggRemaining then
                sharedEnv.ChickenFastIncubatorStatus = "SOURCE ACTIVE - TARGET LAST "
                    .. string.format("%.1fs", nextEggRemaining)
            else
                sharedEnv.ChickenFastIncubatorStatus = "SOURCE ACTIVE - WAITING COOP TIMER"
            end
            return
        end
    end
end

task.spawn(function()
    print("[Egg UI] Fast Coop Deploy controller loaded")
    local nextOptionsRefresh = 0
    while sharedEnv.ChickenArenaGeneration == generation do
        local now = os.clock()
        if now >= nextOptionsRefresh then
            nextOptionsRefresh = now + 2
            pcall(sharedEnv.ChickenFastIncubatorRefreshOptions)
        end
        pcall(sharedEnv.ChickenFastIncubatorSyncDropdownSelections)
        pcall(function()
            sharedEnv.ChickenFastIncubatorRun()
        end)
        task.wait(0.25)
    end
end)

task.spawn(function()
    print("[Scrap UI] controller loaded; Auto Scrap:", autoScrap and "on" or "off")
    while sharedEnv.ChickenArenaGeneration == generation do
        pcall(updateScrapInfo)
        if autoScrap and os.clock() >= scrapManualPauseUntil and not scrapBusy then
            task.spawn(collectScrapRun)
        end
        task.wait(3)
    end
end)

task.spawn(function()
    print("[Upgrade UI] controller loaded; Auto Upgrade:", upgradeEnabled and "on" or "off")
    while sharedEnv.ChickenArenaGeneration == generation do
        if upgradeEnabled and not upgradeBusy then
            task.spawn(runUpgradeCycle)
        end
        if upgradeEnabled and upgradeRecycler and not recyclerUpgradeState.busy then
            task.spawn(function()
                local run = sharedEnv.ChickenRunRecyclerUpgradeCycle
                if type(run) == "function" then
                    run()
                end
            end)
        end
        task.wait(0.75)
    end
end)

task.spawn(function()
    print("[Rebirth UI] controller loaded; toggles are off by default")
    while sharedEnv.ChickenArenaGeneration == generation do
        if type(sharedEnv.ChickenMaybeLeaveAfterMinutes) == "function" then
            sharedEnv.ChickenMaybeLeaveAfterMinutes()
        end
        -- A configured timed run owns its deadline.  Do not let the generic
        -- 45-second missing-event watchdog clear that run before its timer
        -- fires (for example, a 50-second run would be reset at 45s).  The
        -- watchdog remains unchanged for untimed Tower runs.
        local timedRunArmed = (tonumber(towerRunState.runDeadline) or 0) > 0
        if towerBusy and not timedRunArmed and os.clock() - towerRunState.actionAt > 45 then
            -- A missing/delayed TowerRunStarted event used to clear towerBusy
            -- unconditionally.  The next tick then sent TowerStart again and
            -- the server answered busy while the original run was alive.
            -- Keep the request latched until the client state proves that the
            -- chicken is no longer in Tower; an unknown state is retried as a
            -- probe instead of starting a duplicate run.
            local clientRunState = getTowerRunClientState()
            if clientRunState == false then
                warn("[Rebirth UI] tower action timed out; client is back in coop, allowing retry")
                towerBusy = false
                towerRunState.active = false
                towerStatus = "TOWER RETRY READY"
                towerNextStartAt = math.max(towerNextStartAt, os.clock() + 5)
            else
                towerStatus = clientRunState == true
                    and "RUNNING - SERVER ACTIVE"
                    or "RUNNING - CHECKING SERVER"
                towerRunState.actionAt = os.clock()
                towerRunState.startRetryAt = os.clock() + 5
            end
        end

        local ok, _, _, count, best, requirement = pcall(getRebirthState)
        if ok then
            if type(sharedEnv.ChickenObserveRebirthCycleCount) == "function" then
                sharedEnv.ChickenObserveRebirthCycleCount(count)
            end
            -- Keep the remembered highest floor only inside the current
            -- rebirth cycle. The raw tower.best can briefly reset to 0 after
            -- rebirth, but the reserve must not leak into the next cycle.
            if towerResumeRebirthCount == nil then
                towerResumeRebirthCount = count
            elseif towerResumeRebirthCount ~= count then
                -- DataService can briefly report a stale/empty rebirth value
                -- during reload. Do not erase the current tower progress on
                -- that refresh; only a confirmed Rebirth clears it below.
                -- If a real new rebirth is observed with tower.best reset,
                -- clear the remembered floor for that externally-triggered
                -- rebirth as well.
                if count > 0 and best <= 0 and towerResumeBest > 0 then
                    towerResumeBest = 0
                end
                towerResumeRebirthCount = count
            end
            towerResumeBest = math.max(towerResumeBest, best)
            sharedEnv.ChickenTowerResumeState = {
                jobId = game.JobId,
                rebirthCount = towerResumeRebirthCount,
                best = towerResumeBest,
            }
            -- Auto UFO has priority over Auto Tower to Rebirth because both
            -- modes use the same active chicken.  Pause the tower controller
            -- immediately while UFO is enabled/selected.  If a Tower run is
            -- already active, retreat once so the chicken is returned to Coop
            -- for the event; all new Tower/Rebirth requests stay blocked until
            -- Auto UFO is turned off.
            local towerPausedForUfo = autoTowerToRebirth
                and type(sharedEnv.ChickenTowerShouldPauseForUfo) == "function"
                and select(1, sharedEnv.ChickenTowerShouldPauseForUfo())
            if towerPausedForUfo then
                if towerRunState.active and not towerRetreatBusy and not rebirthBusy
                    and os.clock() >= towerUfoPauseRetryAt then
                    towerRetreatBusy = true
                    towerStatus = "RETURNING FOR AUTO UFO"
                    local pauseRetreatOk, pauseRetreatResponse = pcall(function()
                        return towerSurrender:InvokeServer()
                    end)
                    towerRetreatBusy = false
                    local pauseRetreatAccepted = pauseRetreatOk
                        and not (type(pauseRetreatResponse) == "table"
                            and pauseRetreatResponse.ok == false)
                    if pauseRetreatAccepted then
                        towerBusy = false
                        towerRunState.active = false
                        towerRunState.runDeadline = 0
                        towerRunState.busyRetryCount = 0
                        towerRunState.afterRebirthPending = false
                        towerRunState.settleUntil = os.clock() + 1
                        towerNextStartAt = 0
                        towerUfoPauseRetryAt = 0
                        towerStatus = "PAUSED FOR AUTO UFO"
                        print("[Rebirth UI] Tower paused for Auto UFO; chicken returned to Coop")
                    else
                        local reason = type(pauseRetreatResponse) == "table"
                            and pauseRetreatResponse.error or pauseRetreatResponse
                        towerUfoPauseRetryAt = os.clock() + 2
                        towerStatus = "PAUSED FOR AUTO UFO (RETURN RETRY)"
                        warn("[Rebirth UI] Tower pause retreat failed:", tostring(reason))
                    end
                elseif not towerRetreatBusy and not rebirthBusy then
                    towerStatus = "PAUSED FOR AUTO UFO"
                end
                task.wait(0.25)
                continue
            end
            local arenaBusy = false
            local arenaViewOk, arenaView = getArenaView(0.75)
            if arenaViewOk and type(arenaView) == "table" and arenaView.ok and type(arenaView.data) == "table" then
                arenaBusy = arenaView.data.hasActiveMatch == true
            end

            local heldScrap = tonumber(game:GetService("Players").LocalPlayer:GetAttribute("scrapCarry")) or 0
            local waitingForRecycler = holdScrapBeforeRebirth
                and heldScrap > 0
                and not scrapReadyForDeposit

            -- Optional timed Tower loop: after the chicken has been sent to
            -- Tower for the configured duration, retreat it back to Coop and
            -- hold the next start until the configured inter-run delay.  The
            -- Rebirth requirement branch below still has priority, so a run
            -- that reaches the requirement rebirths instead of being timed
            -- out.
            local runDeadline = tonumber(towerRunState.runDeadline) or 0
            local timedRunReady = (autoTowerToRebirth or autoTower)
                and towerRunState.active
                and not towerDefeatPending
                and runDeadline > 0
                and os.clock() >= runDeadline
                and (not autoTowerToRebirth or best < requirement)
            if timedRunReady and not rebirthBusy and not towerRetreatBusy and not arenaBusy then
                towerRetreatBusy = true
                towerStatus = "RUN DURATION COMPLETE - RETURNING TO COOP"
                local timedRetreatOk, timedRetreatResponse = pcall(function()
                    return towerSurrender:InvokeServer()
                end)
                towerRetreatBusy = false
                local timedRetreatAccepted = timedRetreatOk
                    and not (type(timedRetreatResponse) == "table"
                        and timedRetreatResponse.ok == false)
                if timedRetreatAccepted then
                    towerBusy = false
                    towerRunState.active = false
                    towerRunState.runDeadline = 0
                    towerRunState.busyRetryCount = 0
                    towerRunState.afterRebirthPending = false
                    towerDefeatPending = false
                    local settleAt = os.clock() + 1
                    local nextRunDelay = math.max(0, tonumber(sharedEnv.ChickenTowerTiming
                        and sharedEnv.ChickenTowerTiming.nextRunDelay) or 0)
                    towerRunState.settleUntil = settleAt
                    towerNextStartAt = math.max(settleAt, os.clock() + nextRunDelay)
                    towerStatus = nextRunDelay > 0
                        and "COOP - WAITING FOR NEXT TOWER"
                        or "COOP - READY FOR NEXT TOWER"
                    print("[Rebirth UI] timed Tower run returned to Coop; next run in",
                        string.format("%.1fs", math.max(0, towerNextStartAt - os.clock())))
                else
                    local reason = type(timedRetreatResponse) == "table"
                        and timedRetreatResponse.error or timedRetreatResponse
                    towerStatus = "RETURN TO COOP BLOCKED"
                    warn("[Rebirth UI] timed Tower retreat failed:", tostring(reason))
                    -- Move the deadline forward so a transient server busy
                    -- response cannot cause a tight retry loop.
                    towerRunState.runDeadline = os.clock() + 2
                    towerNextStartAt = math.max(towerNextStartAt, os.clock() + 2)
                end
            end

            if autoTowerToRebirth and not towerPausedForUfo
                and not rebirthBusy and not towerRetreatBusy
                and not arenaBusy and not waitingForRecycler and best >= requirement then
                -- The game requires leaving/retreating from the Tower before Rebirth.
                towerRetreatBusy = true
                towerStatus = "RETREATING BEFORE REBIRTH"
                local retreatOk, retreatResponse = pcall(function()
                    return towerSurrender:InvokeServer()
                end)
                towerRetreatBusy = false
                local retreatAccepted = retreatOk
                    and not (type(retreatResponse) == "table" and retreatResponse.ok == false)
                if retreatAccepted then
                    -- Surrender is the action that ends the active Tower run;
                    -- do not wait for TowerRunEnded before preparing Rebirth.
                    towerBusy = false
                    towerRunState.active = false
                    towerRunState.runDeadline = 0
                    towerRunState.busyRetryCount = 0
                    towerDefeatPending = false
                    task.wait(0.05)
                    -- Match the game's real Rebirth prompt condition: the
                    -- chicken must already be back in the coop/corral.
                    local promptReady = waitForRebirthPrompt(8)
                    if not promptReady then
                        towerStatus = "WAITING FOR REBIRTH PROMPT"
                        warn("[Rebirth UI] retreat finished but Rebirth prompt is not ready at coop")
                        towerNextStartAt = os.clock() + 2
                    elseif autoTowerToRebirth and not towerPausedForUfo
                        and not rebirthBusy and not arenaBusy then
                        -- Start walking into the Recycler, then wait the
                        -- configured hold delay before invoking Rebirth.
                        -- Begin the Recycler walk immediately once the prompt
                        -- is ready; the hold-delay is applied after walking
                        -- starts and before Rebirth.
                        local walkStarted = startHeldScrapWalkBeforeRebirth()
                        local heldScrapReady = not holdScrapBeforeRebirth
                            or (tonumber(game:GetService("Players").LocalPlayer:GetAttribute("scrapCarry")) or 0) <= 0
                            or walkStarted
                        if not heldScrapReady then
                            towerStatus = "SCRAP WALK NOT STARTED"
                            towerNextStartAt = os.clock() + 2
                        else
                            local heldScrap = tonumber(game:GetService("Players").LocalPlayer:GetAttribute("scrapCarry")) or 0
                            if walkStarted and heldScrap > 0 then
                                local rebirthDelay = math.max(0, tonumber(scrapDepositDelay) or 0)
                                local delayTrigger = sharedEnv.ChickenRebirthDelayTrigger == "walk" and "walk"
                                    or sharedEnv.ChickenRebirthDelayTrigger == "deposit" and "deposit"
                                    or "none"
                                local timing = sharedEnv.ChickenRebirthTiming
                                if type(timing) == "table" and timing.generation == generation then
                                    timing.delayTrigger = delayTrigger
                                    timing.rebirthDelay = rebirthDelay
                                end
                                if delayTrigger == "deposit" then
                                    -- Current mode: wait until the carry count
                                    -- drops, which confirms that Scrap entered
                                    -- the Recycler, then start the delay.
                                    local confirmationDeadline = os.clock() + 8.5
                                    while not scrapDepositConfirmed
                                        and os.clock() < confirmationDeadline
                                        and sharedEnv.ChickenArenaGeneration == generation do
                                        task.wait(0.05)
                                    end
                                    scrapStatus = (scrapDepositConfirmed and "SCRAP SENT" or "SCRAP SEND TIMEOUT")
                                        .. " - REBIRTH IN "
                                        .. tostring(rebirthDelay) .. "s"
                                    if type(timing) == "table" and timing.generation == generation then
                                        timing.delayStartedAt = os.clock()
                                    end
                                    task.wait(rebirthDelay)
                                elseif delayTrigger == "walk" then
                                    -- Legacy mode: do not wait for the deposit
                                    -- confirmation; the delay is anchored to
                                    -- the moment the Recycler walk started.
                                    scrapStatus = "SCRAP WALK STARTED - REBIRTH IN " .. tostring(rebirthDelay) .. "s"
                                    local delayStartedAt = type(timing) == "table"
                                        and timing.generation == generation
                                        and timing.walkStartedAt
                                    if delayStartedAt then
                                        local remaining = math.max(0, rebirthDelay - (os.clock() - delayStartedAt))
                                        if type(timing) == "table" and timing.generation == generation then
                                            timing.delayStartedAt = delayStartedAt
                                        end
                                        task.wait(remaining)
                                    else
                                        task.wait(rebirthDelay)
                                    end
                                else
                                    -- Both delay triggers are off: keep the
                                    -- normal Scrap walk, then Rebirth without
                                    -- an additional wait.
                                    scrapStatus = "SCRAP SENT - REBIRTH NOW"
                                    if type(timing) == "table" and timing.generation == generation then
                                        timing.delayStartedAt = os.clock()
                                    end
                                end
                            end
                            rebirthBusy = true
                            towerStatus = "REBIRTH PROCESSING"
                            -- Keep the post-request fallback used by the old
                            -- flow in case the walk reaches the Recycler later.
                            queueHeldScrapDepositAfterRebirth()
                            local timing = sharedEnv.ChickenRebirthTiming
                            local requestAt = os.clock()
                            if type(timing) == "table" and timing.generation == generation then
                                timing.rebirthRequestAt = requestAt
                                print("[Rebirth Timing] Rebirth request sent; walk delta", string.format("%.3fs", requestAt - (timing.walkStartedAt or requestAt)))
                            else
                                print("[Rebirth Timing] Rebirth request sent")
                            end
                            local invokeOk, response = pcall(function()
                                return rebirthRemote:InvokeServer()
                            end)
                            timing = sharedEnv.ChickenRebirthTiming
                            if type(timing) == "table" and timing.generation == generation then
                                timing.rebirthResponseAt = os.clock()
                                print("[Rebirth Timing] Rebirth response after", string.format("%.2fs", timing.rebirthResponseAt - requestAt), type(response) == "table" and (response.ok and "OK" or tostring(response.error)) or "unknown")
                            else
                                print("[Rebirth Timing] Rebirth response after", string.format("%.2fs", os.clock() - requestAt), type(response) == "table" and (response.ok and "OK" or tostring(response.error)) or "unknown")
                            end
                            rebirthBusy = false
                            if invokeOk and type(response) == "table" and response.ok then
                                if type(sharedEnv.ChickenMarkRebirthCycleComplete) == "function" then
                                    sharedEnv.ChickenMarkRebirthCycleComplete(count + 1)
                                end
                                -- A successful rebirth starts a new tower cycle;
                                -- clear the old floor/reserve immediately.
                                towerResumeBest = 0
                                towerResumeRebirthCount = count + 1
                                towerRunState.active = false
                                towerBusy = false
                                towerRunState.runDeadline = 0
                                towerRunState.busyRetryCount = 0
                                towerRunState.startRetryAt = 0
                                towerRunState.settleUntil = 0
                                towerRunState.afterRebirthPending = true
                                sharedEnv.ChickenTowerResumeState = {
                                    jobId = game.JobId,
                                    rebirthCount = towerResumeRebirthCount,
                                    best = 0,
                                }
                            -- A successful Rebirth resets Coop/Feeder data.
                            -- Invalidate any upgrade candidate scanned before
                            -- that reset, then let the next cycle rescan fresh
                            -- generators instead of sending stale IDs.
                            upgradeRunToken += 1
                            recyclerUpgradeState.token += 1
                            UpgradeOps.clearUpgradeMoneyWait("main")
                            UpgradeOps.clearUpgradeMoneyWait("recycler")
                            UpgradeOps.clearUpgradeRateWait(true)
                            upgradeWaitState.needFloorSignature = nil
                            upgradeWaitState.recyclerFloorSignature = nil
                            recyclerUpgradeState.floorBlockedSignature = nil
                            recyclerUpgradeState.floorBlockedLabel = nil
                            recyclerUpgradeState.floorWarningKey = nil
                            upgradeStatus = "WAITING FOR REBIRTH DATA"
                            recyclerUpgradeState.status = "WAITING FOR REBIRTH DATA"
                            towerStatus = "REBIRTH COMPLETE - WAITING"
                            towerNextStartAt = os.clock() + towerStartDelay
                            print("[Rebirth UI] rebirth complete:", count + 1)
                                Window:Notify({
                                    Title = "Rebirth Complete",
                                    Description = "Tower retreated; rebirth successful.",
                                    Lifetime = 4,
                                })
                            else
                                local reason = type(response) == "table" and response.error or response
                                towerStatus = "REBIRTH BLOCKED"
                                warn("[Rebirth UI] rebirth failed:", tostring(reason))
                                -- Avoid hammering the Rebirth remote. A short
                                -- retry is enough for the coop transition;
                                -- rate limits/busyPit need a longer cooldown.
                                local retryDelay = 8
                                if reason == "notAtCoop" then
                                    retryDelay = 0.8
                                elseif reason == "rateLimited" or reason == "busyPit" then
                                    retryDelay = 3
                                end
                                towerNextStartAt = os.clock() + retryDelay
                            end
                        end
                    end
                else
                    local reason = type(retreatResponse) == "table" and retreatResponse.error or retreatResponse
                    towerStatus = "RETREAT BLOCKED"
                    warn("[Rebirth UI] TowerSurrender failed:", tostring(reason))
                    towerNextStartAt = os.clock() + 5
                end
            elseif (autoTowerToRebirth or autoTower) and not towerBusy and not towerRunState.active and not towerRetreatBusy
                and not arenaBusy
                and ((not autoTowerToRebirth) or best < requirement)
                and getTowerRunClientState() ~= true
                and not towerRunState.serverRunActive()
                and os.clock() >= towerNextStartAt
                and os.clock() >= towerRunState.startRetryAt
                and os.clock() >= (tonumber(towerRunState.settleUntil) or 0) then
                -- Read the live tower value again at the moment of starting;
                -- this keeps both tower modes from using a stale 0 captured
                -- during a reload or right after a run ended.
                local startFloor, towerReserve, liveBest = getTowerStartFloorAndReserve()
                towerResumeBest = math.max(towerResumeBest, liveBest)
                local nextFloor = towerStartLatest and startFloor or 1
                local currentMoney = getCurrentMoney()
                local reserveShort = nextFloor > 1
                    and keepMoneyForLastFloor
                    and towerReserve > 0
                    and currentMoney
                    and currentMoney < towerReserve
                if reserveShort then
                    -- If the latest-floor elevator cannot be afforded, use the
                    -- free/bottom start instead of waiting or sending a
                    -- guaranteed no-money request.
                    nextFloor = 1
                    towerStatus = "STARTING FLOOR 1 (RESERVE SHORT)"
                end
                local startInfoOk, startInfo = pcall(function()
                    return TowerFloor.at(nextFloor)
                end)
                local startCost = startInfoOk and type(startInfo) == "table"
                    and numericCost(startInfo.money) or nil
                local requiredTowerFunds = nextFloor > 1
                    and keepMoneyForLastFloor and towerReserve > 0
                    and towerReserve or startCost
                if requiredTowerFunds and currentMoney and currentMoney < requiredTowerFunds then
                    -- Even the bottom floor still has its own small entry cost.
                    towerStatus = "WAITING FOR TOWER FUNDS ($"
                        .. formatPower(requiredTowerFunds) .. ")"
                    towerNextStartAt = os.clock() + 3
                else
                    towerBusy = true
                    towerRunState.afterRebirthPending = false
                    towerRunState.runDeadline = 0
                    towerRunState.settleUntil = 0
                    towerDefeatPending = false
                    if not reserveShort then
                        towerStatus = "STARTING FLOOR " .. tostring(nextFloor)
                    end
                    towerRunState.actionAt = os.clock()
                    -- The game's elevator flow is two calls: choose the paid
                    -- elevator floor first, then start the tower with no floor
                    -- argument. Calling TowerStart(nextFloor) directly leaves
                    -- the Skip Ahead window open and falls back to floor 1.
                    local elevatorOk, elevatorResponse = true, nil
                    if nextFloor > 1 then
                        elevatorOk, elevatorResponse = pcall(function()
                            return towerElevator:InvokeServer(nextFloor)
                        end)
                    end
                    local invokeOk, response = false, elevatorResponse
                    if elevatorOk and responseSucceeded(elevatorResponse) then
            task.wait(0.03)
                        invokeOk, response = pcall(function()
                            return towerStart:InvokeServer()
                        end)
                    end
                    if not invokeOk or not responseSucceeded(response) then
                        towerBusy = false
                        towerRunState.active = false
                        local reason = type(response) == "table" and response.error or response
                        if not elevatorOk or not responseSucceeded(elevatorResponse) then
                            reason = type(elevatorResponse) == "table" and elevatorResponse.error or elevatorResponse
                        end
                        if tostring(reason) == "busy" then
                            -- busy means the server already owns a Tower run;
                            -- back off instead of hammering TowerStart.
                            towerRunState.busyRetryCount = math.min(5, towerRunState.busyRetryCount + 1)
                            local retryDelay = math.min(30, 5 * (2 ^ math.max(0, towerRunState.busyRetryCount - 1)))
                            towerRunState.startRetryAt = os.clock() + retryDelay
                            towerNextStartAt = math.max(towerNextStartAt, towerRunState.startRetryAt)
                            towerStatus = "TOWER SERVER BUSY - WAITING " .. string.format("%.1fs", retryDelay)
                            warn("[Rebirth UI] Tower server busy; retry in", string.format("%.1fs", retryDelay))
                        else
                            towerRunState.busyRetryCount = 0
                            towerStatus = "TOWER START BLOCKED"
                            warn("[Rebirth UI] Tower elevator/start failed:", tostring(reason))
                            towerNextStartAt = os.clock() + 8
                        end
                    else
                        towerRunState.active = true
                        towerRunState.busyRetryCount = 0
                        towerRunState.startRetryAt = 0
                        if type(sharedEnv.ChickenArmTowerRunDuration) == "function" then
                            sharedEnv.ChickenArmTowerRunDuration()
                        end
                        print("[Rebirth UI] starting tower floor:", nextFloor)
                    end
                end
            end
        end
        -- Check more often while a timed run is active so the return-to-Coop
        -- deadline is responsive even in Auto Tower (No Rebirth) mode.
        local loopDelay = autoTowerToRebirth and (best >= requirement and 0.15 or 1) or 1
        if towerRunState.active and (tonumber(towerRunState.runDeadline) or 0) > 0 then
            loopDelay = math.min(loopDelay, 0.15)
        end
        task.wait(loopDelay)
    end
end)

task.spawn(function()
    while sharedEnv.ChickenArenaGeneration == generation do
        if autoArena then
            -- Auto Arena's controller owns ArenaGetView while enabled. Use
            -- its recent cache for the card instead of issuing a second
            -- RemoteFunction request every 0.5 seconds.
            if type(arenaViewCache) == "table"
                and os.clock() - arenaViewCacheAt <= 1.5 then
                pcall(updateArenaInfo, arenaViewCache.data)
            end
        else
            -- The status-card poll must not keep calling ArenaGetView when
            -- the Arena tab/window is not visible.  Auto Arena remains
            -- independent below, so enabling automation still keeps its
            -- authoritative controller alive even while this page is closed.
            local arenaWindowOpen = true
            pcall(function()
                arenaWindowOpen = Window:GetState() == true
            end)
            if not arenaWindowOpen or sharedEnv.ChickenArenaTabVisible ~= true then
                task.wait(1.5)
                continue
            end
            local ok, response = getArenaView(1.0)
            if ok and type(response) == "table" and response.ok then
                updateArenaInfo(response.data)
            elseif response ~= "busy" and response ~= "timeout" then
                updateArenaInfo(nil)
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    print("[Arena UI] Maclib loaded; Auto Arena:", autoArena and "enabled" or "disabled")

    while sharedEnv.ChickenArenaGeneration == generation and task.wait(CHECK_INTERVAL) do
        if not autoArena then
            continue
        end

        -- Reserve the chicken for a selected UFO event from warmup through
        -- live.  This prevents a completed Arena match from immediately
        -- starting another one just before Chaos becomes available.  If a
        -- battle was already running when warmup began, it is left alone and
        -- the controller simply stops issuing new ArenaFight requests.
        if type(sharedEnv.ChickenArenaShouldPauseForUfo) == "function"
            and select(1, sharedEnv.ChickenArenaShouldPauseForUfo()) then
            if type(arenaViewCache) == "table"
                and os.clock() - arenaViewCacheAt <= 1.5 then
                pcall(updateArenaInfo, arenaViewCache.data)
            else
                pcall(function()
                    BattleParagraph:UpdateBody("Arena: PAUSED FOR UFO WARMUP/LIVE\\nWaiting for UFO event window...")
                end)
            end
            continue
        end

        local viewOk, view = getArenaView(1.0)

        if not viewOk or type(view) ~= "table" or not view.ok then
            if view ~= "busy" and view ~= "timeout" then
                warn("[Arena UI] ArenaGetView failed")
                task.wait(ERROR_INTERVAL)
            else
                task.wait(CHECK_INTERVAL)
                continue
            end
        end

        local data = view.data
        if type(data) ~= "table" then
            warn("[Arena UI] invalid arena view")
            task.wait(ERROR_INTERVAL)
            continue
        end

        if not data.unlocked then
            autoArena = false
            warn("[Arena UI] arena is locked; requires rebirth " .. tostring(data.unlockRebirth))
            continue
        end

        -- If the server stops sending ArenaBattleState/ArenaBattleResult, the
        -- view can remain on hasActiveMatch=true forever.  Track that state
        -- and recover only after a full 120-second grace period (twice the
        -- normal 60-second battle duration), so ordinary slow matches are not
        -- interrupted.  The local controller is also cleared so the HUD does
        -- not keep displaying a frozen 01:00 battle after cancellation.
        local arenaStall = sharedEnv.ChickenArenaStallState
        if type(arenaStall) == "table" then
            local stallNow = os.clock()
            if data.hasActiveMatch ~= true then
                arenaStall.observedAt = 0
                arenaStall.lastActive = false
                arenaStall.lastBattles = data.battles
                arenaStall.lastWins = data.wins
                arenaStall.recoveryAttempted = false
            else
                local changed = arenaStall.lastActive ~= true
                    or data.battles ~= arenaStall.lastBattles
                    or data.wins ~= arenaStall.lastWins
                if changed then
                    arenaStall.observedAt = stallNow
                    arenaStall.lastActive = true
                    arenaStall.lastBattles = data.battles
                    arenaStall.lastWins = data.wins
                    arenaStall.recoveryAttempted = false
                elseif (tonumber(arenaStall.observedAt) or 0) > 0
                    and stallNow - tonumber(arenaStall.observedAt)
                        >= (tonumber(arenaStall.timeout) or 120)
                    and not arenaStall.recoveryAttempted then
                    arenaStall.recoveryAttempted = true
                    warn("[Arena UI] stale active match; cancelling after 120s")
                    pcall(function()
                        local playerScripts = Players.LocalPlayer
                            and Players.LocalPlayer:FindFirstChild("PlayerScripts")
                        local twoD = playerScripts
                            and playerScripts:FindFirstChild("UI")
                            and playerScripts.UI:FindFirstChild("2d")
                        local arenaFolder = twoD and twoD:FindFirstChild("Arena")
                        local clientModule = arenaFolder
                            and arenaFolder:FindFirstChild("ArenaClient")
                        local client = clientModule and require(clientModule)
                        if client and type(client.cancelBattle) == "function" then
                            client.cancelBattle()
                        else
                            local cancelRemote = remotes:FindFirstChild("ArenaBattleCancel")
                            if cancelRemote then
                                cancelRemote:FireServer()
                            end
                        end
                    end)
                    sharedEnv.ChickenArenaFightGate.busy = false
                    sharedEnv.ChickenArenaFightGate.startedAt = 0
                    sharedEnv.ChickenArenaFightGate.expiresAt = 0
                    arenaViewCache = nil
                    arenaViewCacheAt = 0
                    arenaTransitionUntil = stallNow + 1
                    retryAt = stallNow + 2
                end
            end
        end

        -- The controller owns the fresh response while Auto Arena is on;
        -- keep the visible card in sync without another remote call.
        pcall(updateArenaInfo, data)

        if os.clock() < retryAt then
            continue
        end

        if os.clock() < arenaTransitionUntil then
            continue
        end

        local fightGate = sharedEnv.ChickenArenaFightGate
        if type(fightGate) == "table"
            and fightGate.busy == true
            and (tonumber(fightGate.expiresAt) or 0) > 0
            and os.clock() >= tonumber(fightGate.expiresAt) then
            -- A missing result event must not deadlock Arena forever.  The
            -- authoritative view below is still required to be READY before
            -- another fight can be sent.
            fightGate.busy = false
            fightGate.startedAt = 0
            fightGate.expiresAt = 0
        end

        if data.available and not data.hasActiveMatch
            and not (type(fightGate) == "table" and fightGate.busy == true) then
            if smartSelection then
                local selectedData, selectedIndex, blocked = selectSmartOpponent(data)
                if selectedData then
                    data = selectedData
                    -- Show a fresh cursor/opponent snapshot immediately after
                    -- Smart Selection and any Skip operations complete.
                    pcall(function()
                        updateArenaInfo(data)
                    end)
                    local currentSelectedIndex = math.min((tonumber(data.cursor) or 0) + 1, #(data.opponents or {}))
                    local selected = data.opponents and data.opponents[currentSelectedIndex]
                    if selected then
                        if blocked then
                            retryAt = os.clock() + ARENA_RETRY_DELAY
                        elseif currentSelectedIndex == selectedIndex then
                            print("[Arena UI] selected opponent:", selected.name, selected.power)
                        else
                            retryAt = os.clock() + ARENA_RETRY_DELAY
                            warn("[Arena UI] target cursor mismatch; waiting")
                        end
                    end
                end
            end

            if os.clock() < retryAt then
                continue
            end

            if data.available and not data.hasActiveMatch
                and not (type(fightGate) == "table" and fightGate.busy == true) then
                -- Claim before invoking the RemoteFunction.  ArenaGetView can
                -- still show the previous READY snapshot for a short period,
                -- so this claim is what prevents duplicate ArenaFight calls.
                fightGate.requestId = (tonumber(fightGate.requestId) or 0) + 1
                fightGate.busy = true
                fightGate.startedAt = os.clock()
                fightGate.expiresAt = fightGate.startedAt + 75
                local fightOk, response = invokeRemoteWithTimeout(arenaFight, 1.25)

                if fightOk and type(response) == "table" and response.ok then
                    -- Do not carry a previous skip/cursor retry gate into the
                    -- next completed match.
                    retryAt = 0
                    -- The first ArenaGetView response after starting can still
                    -- be the pre-battle READY snapshot. Block only duplicate
                    -- Fight calls while that state settles.
                    arenaTransitionUntil = os.clock() + ARENA_FIGHT_TRANSITION
                    arenaViewCache = nil
                    arenaViewCacheAt = 0
                    print("[Arena UI] battle started")
                else
                    local reason = type(response) == "table" and response.error or response
                    warn("[Arena UI] fight failed:", tostring(reason))
                    if tostring(reason) == "battle_in_progress" or tostring(reason) == "match-in-progress" then
                        -- Another controller/server request owns the match;
                        -- keep the gate briefly while the authoritative view
                        -- catches up instead of immediately retrying.
                        fightGate.expiresAt = os.clock() + 5
                        arenaTransitionUntil = os.clock() + 1
                        retryAt = os.clock() + 1
                    elseif tostring(reason) == "timeout" then
                        -- The underlying InvokeServer may still be accepted by
                        -- the server after our local timeout.  Keep a short
                        -- safety window to avoid submitting a duplicate.
                        fightGate.expiresAt = os.clock() + 10
                    else
                        -- A rejected request did not create a match, so it is
                        -- safe to let the normal retry policy run.
                        fightGate.busy = false
                        fightGate.startedAt = 0
                        fightGate.expiresAt = 0
                        task.wait(ERROR_INTERVAL)
                    end
                end
            end
        end
    end

    print("[Arena UI] Maclib loop stopped")
end)

-- The tab that was selected before a reload may already be mounted by the
-- time the remaining controls are built.  Run one final synchronous pass so
-- that list receives the compact viewport immediately; the loop above catches
-- tabs that MacLib mounts lazily later.
dropdownViewportState.refresh()

return "Maclib Auto Arena loaded"
