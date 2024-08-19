local isProcessing = false
local ladang = lib.load("config")

local jualan = lib.load("config").jualPaket

local function spawnPed(pedConfig, trigger, label)
    local model = pedConfig.model
    local pos = pedConfig.pos

    local ped = createPed(model, pos)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "jual_" .. trigger,
            icon = 'fa-solid fa-road',
            label = label,
            groups = false,
            event = trigger
        }
    })
end

spawnPed(ladang.Sirih.ped, "sr_illegal:jualSirih", "Jual Sirih Saset")
spawnPed(ladang.Jahe.ped, "sr_illegal:jualJahe", "Jual Jahe Saset")

RegisterNetEvent("sr_illegal:jualSirih", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if not isProcessing then
        local hasItem = hasItem("sirihsaset", 5)
        if not hasItem then
            return DoNotification("Minimal 5 Sirih Saset", 'error')
        end

        isProcessing = true
        local success = lib.progressBar({
            duration = 6000,
            label = "Sedang Jual Sirih",
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
            local harga = jualan.randomHarga and math.random(jualan.hargaMinimum, jualan.hargaJual) or jualan.hargaJual
            addRemoveItem("add", "black_money", harga)
            addRemoveItem("remove", "sirihsaset", 5)
        else
            DoNotification('Proses dibatalkan', 'error')
        end

        ClearPedTasks(playerPed)
        isProcessing = false
    end
end)

RegisterNetEvent("sr_illegal:jualJahe", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    if not isProcessing then
        local hasItem = hasItem("jahesaset", 5)
        if not hasItem then
            return DoNotification("Minimal 5 Jahe Saset", 'error')
        end
        isProcessing = true
        local success = lib.progressBar({
            duration = 6000,
            label = "Sedang Jual Jahe",
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
            local harga = jualan.randomHarga and math.random(jualan.hargaMinimum, jualan.hargaJual) or jualan.hargaJual
            addRemoveItem("add", "black_money", harga)
            useItem("jahesaset", 5)
        else
            DoNotification('Proses dibatalkan', 'error')
        end

        ClearPedTasks(playerPed)
        isProcessing = false
    end
end)
