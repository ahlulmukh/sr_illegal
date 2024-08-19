local isPickingUp      = false
local spawnSirih       = 0
local ladangSirih      = {}

local spawnjahe        = 0
local ladangJahe       = {}

local ladangCoords     = lib.load("config").Sirih.Ladang
local ladangJaheCoords = lib.load("config").Jahe.Ladang
local ladang           = lib.load("config").nyabut
local zones            = lib.load("config")

local inLadang         = false
local isSpawning       = false
local isSpawningJahe   = false

local function isInAnyLadang(coords)
    for _, zone in pairs(zones) do
        if type(zone) == "table" and zone.Zones then
            local dx = coords.x - zone.Zones.x
            local dy = coords.y - zone.Zones.y
            local dz = coords.z - zone.Zones.z
            local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

            if distance < zone.Zones.radius then
                return true
            end
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local inLadangs = isInAnyLadang(coords)

        if inLadangs and not inLadang then
            inLadang = true
            print("Entered Ladang")
            SpawnJahe()
            SpawnSirih()
        elseif not inLadangs and inLadang then
            inLadang = false
            print("Leaved Ladang")
            RemoveJahe()
            RemoveSirih()
        end
    end
end)


function RemoveSirih()
    if isSpawning then
        isSpawning = false
    end

    for k, v in pairs(ladangSirih) do
        DeleteObject(v)
    end

    ladangSirih = {}
    spawnSirih = 0
end

function SpawnSirih()
    if isSpawning then return end
    isSpawning = true

    Citizen.CreateThread(function()
        while isSpawning and spawnSirih < 20 do
            Citizen.Wait(0)
            local weedCoords = BuatCoordsSirih()

            SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
                if not isSpawning then
                    DeleteObject(obj)
                    return
                end
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
                table.insert(ladangSirih, obj)
                spawnSirih = spawnSirih + 1
            end)

            Citizen.Wait(100)
        end

        if isSpawning then
            Citizen.Wait(45 * 60000)
        end
    end)
end

function ValidasiCoordsSirih(plantCoord)
    if spawnSirih > 0 then
        local validate = true

        for k, v in pairs(ladangSirih) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, ladangCoords, false) > 50 then
            validate = false
        end

        return validate
    else
        return true
    end
end

function BuatCoordsSirih()
    while true do
        Wait(1)

        local weedCoordX, weedCoordY

        math.randomseed(GetGameTimer())
        local modX = math.random(-90, 90)

        Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(-90, 90)

        weedCoordX = ladangCoords.x + modX
        weedCoordY = ladangCoords.y + modY

        local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
        local coord = vector3(weedCoordX, weedCoordY, coordZ)

        if ValidasiCoordsSirih(coord) then
            return coord
        end
    end
end

CreateThread(function()
    local isTextDisplayed = false

    while true do
        Wait(10)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local nearbyObject, nearbyID

        for i = 1, #ladangSirih, 1 do
            if GetDistanceBetweenCoords(coords, GetEntityCoords(ladangSirih[i]), false) < 1 then
                nearbyObject, nearbyID = ladangSirih[i], i
            end
        end

        if nearbyObject and IsPedOnFoot(playerPed) then
            if not isPickingUp and not isTextDisplayed then
                exports["qb-textuii"]:displayTextUI("Tekan E Untuk Ambil", "E")
                isTextDisplayed = true
            end

            if IsControlJustReleased(0, 38) and not isPickingUp then
                isPickingUp = true
                local success = lib.progressBar({
                    duration = 6000,
                    label = "Mengambil Jahe",
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                    },
                    anim = {
                        dict = 'creatures@rottweiler@tricks@',
                        clip = 'petting_franklin',
                        flag = 49,
                    },
                })
                if success then
                    deleteObject(nearbyObject)
                    table.remove(ladangSirih, nearbyID)
                    spawnSirih = spawnSirih - 1
                    local jumlah = ladang.randomNyabut and math.random(ladang.minimumNyabut, ladang.jumlahNyabut) or
                        ladang.jumlahNyabut
                    addRemoveItem("add", "sirihmentah", jumlah)
                    exports["qb-textuii"]:hideTextUI()
                    isTextDisplayed = false
                    isPickingUp = false
                else
                    isTextDisplayed = false
                    isPickingUp = false
                    DoNotification('dibatalkan', 'error')
                end
            end
        else
            if isTextDisplayed then
                exports["qb-textuii"]:hideTextUI()
                isTextDisplayed = false
            end
            Wait(500)
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(ladangSirih) do
            deleteObject(v)
        end
    end
end)


-- Ladang Jahe

function RemoveJahe()
    if isSpawningJahe then
        isSpawningJahe = false
    end

    for k, v in pairs(ladangJahe) do
        DeleteObject(v)
    end

    ladangJahe = {}
    spawnjahe = 0
end

function SpawnJahe()
    if isSpawningJahe then return end
    isSpawningJahe = true

    Citizen.CreateThread(function()
        while isSpawningJahe and spawnjahe < 20 do
            Citizen.Wait(0)
            local weedCoords = BuatCoordsJahe()

            SpawnLocalObject('hei_prop_hei_drug_pack_01b', weedCoords, function(obj)
                if not isSpawningJahe then
                    DeleteObject(obj)
                    return
                end
                PlaceObjectOnGroundProperly(obj)
                FreezeEntityPosition(obj, true)
                table.insert(ladangJahe, obj)
                spawnjahe = spawnjahe + 1
            end)

            Citizen.Wait(100)
        end

        if isSpawningJahe then
            Citizen.Wait(45 * 60000)
        end
    end)
end

function ValidasiCoordsJahe(plantCoord)
    if spawnjahe > 0 then
        local validate = true

        for k, v in pairs(ladangJahe) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, ladangJaheCoords, false) > 50 then
            validate = false
        end

        return validate
    else
        return true
    end
end

function BuatCoordsJahe()
    while true do
        Wait(1)

        local weedCoordX, weedCoordY

        math.randomseed(GetGameTimer())
        local modX = math.random(-90, 90)

        Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(-90, 90)

        weedCoordX = ladangJaheCoords.x + modX
        weedCoordY = ladangJaheCoords.y + modY

        local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
        local coord = vector3(weedCoordX, weedCoordY, coordZ)

        if ValidasiCoordsJahe(coord) then
            return coord
        end
    end
end

CreateThread(function()
    local isTextDisplayed = false

    while true do
        Wait(10)

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local nearbyObject, nearbyID

        for i = 1, #ladangJahe, 1 do
            if GetDistanceBetweenCoords(coords, GetEntityCoords(ladangJahe[i]), false) < 1 then
                nearbyObject, nearbyID = ladangJahe[i], i
            end
        end

        if nearbyObject and IsPedOnFoot(playerPed) then
            if not isPickingUp and not isTextDisplayed then
                exports["qb-textuii"]:displayTextUI("Tekan E Untuk Ambil", "E")
                isTextDisplayed = true
            end

            if IsControlJustReleased(0, 38) and not isPickingUp then
                isPickingUp = true
                local success = lib.progressBar({
                    duration = 6000,
                    label = "Mengambil Jahe",
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                    },
                    anim = {
                        dict = 'creatures@rottweiler@tricks@',
                        clip = 'petting_franklin',
                        flag = 49,
                    },
                })
                if success then
                    deleteObject(nearbyObject)
                    table.remove(ladangJahe, nearbyID)
                    spawnjahe = spawnjahe - 1
                    local jumlah = ladang.randomNyabut and math.random(ladang.minimumNyabut, ladang.jumlahNyabut) or
                        ladang.jumlahNyabut
                    addRemoveItem("add", "jahementah", jumlah)
                    exports["qb-textuii"]:hideTextUI()
                    isTextDisplayed = false
                    isPickingUp = false
                else
                    isTextDisplayed = false
                    isPickingUp = false
                    DoNotification('dibatalkan', 'error')
                end
            end
        else
            if isTextDisplayed then
                exports["qb-textuii"]:hideTextUI()
                isTextDisplayed = false
            end
            Wait(500)
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(ladangJahe) do
            deleteObject(v)
        end
    end
end)
