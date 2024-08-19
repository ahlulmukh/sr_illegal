if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()
local Config = lib.require('config')
local ox_inventory = exports.ox_inventory


function addItem(source, item, amount)
    if ox_inventory then
        return ox_inventory:AddItem(source, item, amount)
    end
end

function removeItem(source, item, amount)
    if ox_inventory then
        return ox_inventory:RemoveItem(source, item, amount)
    end
end
