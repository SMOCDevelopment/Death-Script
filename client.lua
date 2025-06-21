local config = {
    enableRespawn = true,
    enableRevive = true,
    respawnDelay = 15,
    reviveDelay = 10,
}

local isDead = false
local canRespawn = false
local canRevive = false

local reviveTimeLeft = 0
local respawnTimeLeft = 0

local hospitals = {
    vector3(306.2, -601.07, 43.28),
    vector3(1839.74, 3672.15, 34.28),
    vector3(-247.76, 6331.23, 32.42)
}

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        exports.spawnmanager:setAutoSpawn(false)
    end
end)

local reviveThread = nil
local respawnThread = nil
local controlThread = nil

local function sendUI(data)
    SendNUIMessage(data)
end

local function showDeathUI()
    SetNuiFocus(false, false)
    reviveTimeLeft = config.reviveDelay
    respawnTimeLeft = config.respawnDelay
    sendUI({ action = "show", revive = reviveTimeLeft, respawn = respawnTimeLeft })
end

local function hideDeathUI()
    sendUI({ action = "hide" })
end

local function stopTimers()
    canRevive = false
    canRespawn = false
    reviveThread = nil
    respawnThread = nil
    controlThread = nil
end

local function updateCountdowns()
    canRevive = false
    canRespawn = false
    reviveTimeLeft = config.reviveDelay
    respawnTimeLeft = config.respawnDelay

    reviveThread = CreateThread(function()
        for i = reviveTimeLeft, 1, -1 do
            if reviveThread == nil then return end
            reviveTimeLeft = i
            sendUI({ action = "reviveTick", value = i })
            if i <= 3 then
                lib.notify({ title = "Revive", description = i .. "s", type = "info" })
            end
            Wait(1000)
        end
        canRevive = true
        sendUI({ action = "reviveReady" })
    end)

    respawnThread = CreateThread(function()
        for i = respawnTimeLeft, 1, -1 do
            if respawnThread == nil then return end
            respawnTimeLeft = i
            sendUI({ action = "respawnTick", value = i })
            if i <= 3 then
                lib.notify({ title = "Respawn", description = i .. "s", type = "info" })
            end
            Wait(1000)
        end
        canRespawn = true
        sendUI({ action = "respawnReady" })
    end)
end

local function respawn()
    if not canRespawn then return end
    stopTimers()
    local ped = PlayerPedId()
    local loc = hospitals[math.random(#hospitals)]
    NetworkResurrectLocalPlayer(loc.x, loc.y, loc.z, 0.0, true, true, false)
    SetEntityCoords(ped, loc.x, loc.y, loc.z)
    hideDeathUI()
    isDead = false
end

local function revive()
    if not canRevive then return end
    stopTimers()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    hideDeathUI()
    isDead = false
end

local function alertEMS()
    local coords = GetEntityCoords(PlayerPedId())
    local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local road = GetStreetNameFromHashKey(streetHash)
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {'[911 Dispatch System]', 'Local saw a person lying down on ' .. road .. ' and appears to be unconscious. Can we get units to check it out?'}
    })
end

CreateThread(function()
    while true do
        Wait(0)
        if isDead then
            local ped = PlayerPedId()
            if not IsEntityDead(ped) then
                SetEntityHealth(ped, 0)
            end
            SetEntityInvincible(ped, true)
            if not IsPedRagdoll(ped) then
                SetPedToRagdoll(ped, 1000, 1000, 0, false, false, false)
            end
            HideHudComponentThisFrame(19)
            DisableControlAction(0, 322, true) 
            DisableControlAction(0, 73, true)  
            DisableControlAction(0, 288, true)
        else
            local ped = PlayerPedId()
            SetEntityInvincible(ped, false)
        end
    end
end)


CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        if IsEntityDead(ped) and not isDead then
            isDead = true
            canRespawn = false
            canRevive = false
            showDeathUI()
            updateCountdowns()

            controlThread = CreateThread(function()
                while isDead do
                    Wait(0)
                    DisableAllControlActions(0)
                    EnableControlAction(0, 38, true) -- E
                    EnableControlAction(0, 45, true) -- R
                    EnableControlAction(0, 47, true) -- G

                    if IsControlJustPressed(0, 38) and canRevive then
                        revive()
                    elseif IsControlJustPressed(0, 45) and canRespawn then
                        respawn()
                    elseif IsControlJustPressed(0, 47) then
                        alertEMS()
                    end
                end
            end)
        end
    end
end)
