local isProcessing = false
local ped = lib.load("config").cuciduit
local ped2 = createPed(ped.model, ped.pos)

FreezeEntityPosition(ped2, true)
SetEntityInvincible(ped2, true)
SetBlockingOfNonTemporaryEvents(ped2, true)

exports.ox_target:addLocalEntity(ped2, {
    {
        label = "Cuci Uang",
        icon  = '',
        event = "sr_illegal:cuciduit"
    }
})

RegisterNetEvent("sr_illegal:cuciduit", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if not isProcessing then
        local hasItem = hasItem("black_money", 50000)
        if not hasItem then
            return DoNotification("Minimal 50000 Untuk Cuci Duit", 'error')
        end
        isProcessing = true
        local success = lib.progressBar({
            duration = 6000,
            label = "Menyuci duit",
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = 'mp_common',
                clip = 'givetake1_a',
                flag = 49,
            },
        })

        if success then
            local jumlah = ped.randomHargaCuci and math.random(ped.hargaMinimumCuci, ped.hargaCuci) or
                ped.hargaCuci
            useItem("black_money", 50000)
            addRemoveItem("add", "money", jumlah)
        else
            DoNotification('Proses dibatalkan', 'error')
        end
        ClearPedTasks(playerPed)
        isProcessing = false
    end
end)
