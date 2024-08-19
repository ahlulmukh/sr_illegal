if GetResourceState('qb-core') ~= 'started' then return end

local QBCore       = exports['qb-core']:GetCoreObject()
local Config       = lib.require('config')

local ox_inventory = exports.ox_inventory

function DoNotification(text, nType)
    QBCore.Functions.Notify(text, nType)
end

function SpawnLocalObject(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end

function deleteObject(object)
    SetEntityAsMissionEntity(object, false, true)
    DeleteObject(object)
end

function GetCoordZWeed(x, y)
    local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end

    return 43.0
end

function createPed(name, ...)
    local model = lib.requestModel(name)

    if not model then return end

    local ped = CreatePed(0, model, ...)

    SetEntityInvincible(ped, true)
    SetModelAsNoLongerNeeded(model)
    return ped
end

function hasItem(item, _quantity)
    local quantity = _quantity or 1

    if ox_inventory then
        return ox_inventory:Search('count', item) >= quantity
    end

    return false
end

function useItem(item, value)
    local data = {}
    data.item = item
    data.value = value
    TriggerServerEvent("sr_illegal:removeitem", data)
end

function addRemoveItem(type, item, quantity)
    local data = {}
    data.toggle = type == "remove"
    data.item = item
    data.quantity = quantity

    TriggerServerEvent("sr_illegal:removAddItem", data)
end

function canCarry(item, quantity)
    local data = {}
    data.item = item
    data.quantity = quantity

    TriggerServerEvent("sr_illegal:checkCarry", data)
end
