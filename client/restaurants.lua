ESX = exports['es_extended']:getSharedObject()


local odebrane = false

local spawned = {}
local interiors = {}
CreateThread(function()

    for k, v in pairs(Config.Restaurants) do
        interiors[k] = GetInteriorAtCoords(v.coords.x, v.coords.y, v.coords.z)
    end
    while true do
        Wait(1000)
        local int = GetInteriorFromEntity(PlayerPedId())
        for k,v in pairs(interiors) do
            if int == v then
                if spawned[int] then Wait(10000) else
                    spawned[int] = true
                    local table = Config.Restaurants[k]
                    RequestModel(GetHashKey(table.ped_model))
                    TriggerServerEvent('vgroupcore:jedzenie:rastaurants:spawnped', table)
                end
            end
        end
    end
end)

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:loadanimation', function(siad, siadd, siaddd, spoko)
    ESX.Streaming.RequestAnimDict(siad, function()
        Wait(1000)
        local ped = NetworkGetEntityFromNetworkId(siaddd)
        TaskPlayAnim(ped, siad, siadd, 1.0, -1.0, -1, 1, 1, false, false, false)
        PlayPedAmbientSpeechNative(ped, "SHOP_GREET", "SPEECH_PARAMS_STANDARD")
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        exports.ox_target:addEntity(siaddd, {
            {
                icon = "fa-solid fa-utensils",
                label = Config.Locales.Order,
                distance = 2.0,
                onSelect = function(data)
                    OpenMenuResta(spoko)
                    LocalPlayer.state.ped = data.entity
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    return IsEntityPlayingAnim(entity, siad, siadd, 3)
                end
            }
        })
        repeat
            Wait(1000)
            if not IsEntityPlayingAnim(ped, siad, siadd, 3) and IsPedStill(ped) then
                TaskPlayAnim(ped, siad, siadd, 3.0, -8, -1, 1, 0, 0, 0, 0 )
            end
        until not DoesEntityExist(ped)
    end)
end)

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:przygotuj', function(table, netid, source)
    local ped = NetworkGetEntityFromNetworkId(netid)
    local interior = GetInteriorFromEntity(ped)
    local name = ''
    for k, v in pairs(interiors) do
        if interior == v then 
            name = k
        end
    end
    PlayPedAmbientSpeechNative(ped, "SHOP_SELL", "SPEECH_PARAMS_STANDARD") 
    FreezeEntityPosition(ped, false)
    local c = Config.Restaurants[name]
    for k,v in ipairs(c.ped_route2) do
        TaskGoStraightToCoord(ped, v.xyz, 1.0, -1, v.w, 0.5)
        repeat
            Wait(100)
            TaskGoStraightToCoord(ped, v.xyz, 1.0, -1, v.w, 0.5)
        until ( #(GetEntityCoords(ped) - v.xyz) < 2 )
        SetEntityHeading(ped, v.w)
    end
    Wait(1000)
    ESX.Streaming.RequestAnimDict('missheistfbisetup1', function()
        TaskPlayAnim(ped, 'missheistfbisetup1', 'hassle_intro_loop_f', 1.0, -1.0, -1, 1, 1, false, false, false)
    end)
    Wait(5000)
    ClearPedTasks(ped)
    local prop = CreateObject('prop_food_tray_03', GetEntityCoords(ped), false, false, false)
    AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 60309), 0.25, 0.05, 0.23, -55.0, 290.0, 0.0, true, true, false, true, 1, true)
    ESX.Streaming.RequestAnimDict('anim@heists@box_carry@', function()
        TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
    end)
    Wait(1000)
    for k,v in ipairs(c.ped_route3) do
        TaskGoStraightToCoord(ped, v.xyz, 1.0, -1, v.w, 0.5)
        repeat
            Wait(100)
            TaskGoStraightToCoord(ped, v.xyz, 1.0, -1, v.w, 0.5)
        until ( #(GetEntityCoords(ped) - v.xyz) < 2 )
        if k == #c.ped_route3 then SetEntityCoords(ped, v.x, v.y - 0.5, v.z -0.9) end
        SetEntityHeading(ped, v.w)
    end
    ClearPedTasks(ped)
    odebrane = false
    DetachEntity(prop, false, false)
    SetEntityCoords(prop, c.take.x, c.take.y, c.take.z)
    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    PlayPedAmbientSpeechNative(ped, "SHOP_GOODBYE", "SPEECH_PARAMS_STANDARD") 
    exports.ox_target:addLocalEntity(prop, {
        {
            icon = "fa-solid fa-utensils",
            label = Config.Locales.Tray,
            distance = 1.5,
            onSelect = function(data)
                TriggerServerEvent('vgroupcore:jedzenie:rastaurants:dajtace', table, source)
            end
        }
    })
    repeat
        Wait(2000)
    until odebrane
    ClearPedTasks(ped)
    ESX.Streaming.RequestAnimDict("mp_fbi_heist", function()
        TaskPlayAnim(ped, "mp_fbi_heist", "loop", 1.0, -1.0, -1, 1, 1, false, false, false)
        FreezeEntityPosition(ped, true)
        DeleteEntity(prop)
    end)
end)

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:niestace', function(tabela)
    local playerPed = PlayerPedId()
    taca = 0
    ESX.TriggerServerCallback('vgroupcore:jedzenie:cb:spawnprop', function(spawnedProp) 
        taca = NetworkGetEntityFromNetworkId(spawnedProp)
    end, 'prop_food_tray_03', GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, 1.0))
    while taca == 0 do
        Wait(10)
    end
    lib.notify({
        description = Config.Locales.TrayTwo,
        type = 'success'
    })
    niesie = true
    AttachEntityToEntity(taca, playerPed, GetPedBoneIndex(playerPed, 60309), 0.25, 0.05, 0.23, -55.0, 290.0, 0.0, true, true, false, true, 1, true)
    ESX.Streaming.RequestAnimDict('anim@heists@box_carry@', function()
        TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
    end)
    repeat
        Wait(100)
    until not niesie
    TriggerServerEvent('vgroupcore:jedzenie:rastaurants:dajnatace', tabela)
    Wait(60000)
    DeleteEntity(taca)
end)

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:odebrane', function()
    odebrane = true
end)

local function odloz()
    DetachEntity(taca)
    ClearPedTasks(PlayerPedId())
    local finalCoords = exports['object_gizmo']:useGizmo(taca)
    niesie = false
end

CreateThread(function()
    local w8 = 0
    while true do
        local ped = PlayerPedId()
        if niesie then
            Wait(w8)
            if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then
                TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            end
            if IsControlPressed(0, 38) then
                odloz()
            end
        else
            w8 = 1000
            Wait(w8)
        end
    end
end)

function OpenMenuResta(spoko)

    local itemy = spoko

    local elements = {}

    if #itemy.items > 0 then
        for i=1, #itemy.items do
            table.insert(elements, {label = itemy.items[i].label.." -  $"..itemy.items[i].price, name = itemy.items[i].name, price = itemy.items[i].price})
        end
    else
        table.insert(elements, {label = "No menu in this restaurant", value = "brak"})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'in_restaurant',
	{
		title    = "Restaurant Menu",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
        if tostring(value) ~= "brak" then
            local value = data.current.name
            local price = data.current.price
            TriggerServerEvent('vgroupcore:jedzenie:rastaurants:kup', value, price, NetworkGetNetworkIdFromEntity(LocalPlayer.state.ped))
        end
	end, function(data, menu)
		menu.close()
	end)
end