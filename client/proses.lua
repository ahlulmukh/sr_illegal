local ladang = lib.load("config")
local isProcessing = false

local function createProcessZone(processConfig, eventName, label)
    exports.ox_target:addBoxZone({
        coords = processConfig,
        size = vec3(2, 2, 2),
        rotation = 45,
        options = {
            name = "proses_" .. eventName,
            icon = 'fa-solid fa-road',
            label = label,
            event = eventName
        }
    })
end

createProcessZone(ladang.Sirih.proses, "sr_illegal:prosesSirih", "Proses Sirih")
createProcessZone(ladang.Jahe.proses, "sr_illegal:prosesJahe", "Proses Jahe")

RegisterNetEvent("sr_illegal:prosesSirih", function()
    local playerPed = PlayerPedId()

    if not isProcessing then
        local hasItem = hasItem("sirihmentah", 4)
        if not hasItem then
            return DoNotification("Minimal 4 Sirih Untuk proses", 'error')
        end
        isProcessing = true
        local success = lib.progressBar({
            duration = 6000,
            label = "Sedang Proses",
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                clip = 'machinic_loop_mechandplayer'
            },
        })

        if success then
            addRemoveItem("add", "sirihsaset", 1)
            addRemoveItem("remove", "sirihmentah", 4)
        else
            DoNotification('Proses dibatalkan.', 'error')
        end

        ClearPedTasks(playerPed)
        isProcessing = false
    end
end)

RegisterNetEvent("sr_illegal:prosesJahe", function()
    local playerPed = PlayerPedId()

    if not isProcessing then
        local hasItem = hasItem("jahementah", 4)
        if not hasItem then
            return DoNotification("Minimal 4 Jahe Untuk proses", 'error')
        end

        isProcessing = true

        local success = lib.progressBar({
            duration = 6000,
            label = "Sedang Proses",
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                clip = 'machinic_loop_mechandplayer'
            },
        })

        if success then
            addRemoveItem("add", "jahesaset", 1)
            addRemoveItem("remove", "jahementah", 4)
        else
            DoNotification('Proses dibatalkan.', 'error')
        end

        ClearPedTasks(playerPed)
        isProcessing = false
    end
end)
