local QBCore       = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory


RegisterNetEvent("sr_illegal:removAddItem", function(data)
	local source = source
	local method = data.toggle and removeItem or addItem
	if exports.ox_inventory:CanCarryItem(source, data.item, data.quantity) then
		method(source, data.item, data.quantity)
	else
		QBCore.Functions.Notify(source, "Inventory Sudah Penuh", 'error')
	end
end)

RegisterNetEvent("sr_illegal:removeitem", function(data)
	removeItem(source, data.item, data.value)
end)

lib.versionCheck('ahlulmukh/sr_illegal')
