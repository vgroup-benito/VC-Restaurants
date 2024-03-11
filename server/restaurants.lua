ESX = exports['es_extended']:getSharedObject()

local ox_inventory = exports[Config.OxInventoryName]

local spawned = {}

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:spawnped', function(table)
    if spawned[table.coords] then else
        local callbackValue = 0
        ::sync::
        ESX.OneSync.SpawnPed(table.ped_model, table.ped_spawn.xyz, table.ped_spawn.w, function(obj)
            callbackValue = obj
        end)
        while callbackValue == 0 do
            Wait(10)
        end
        entity = NetworkGetEntityFromNetworkId(callbackValue)
        spawned[table.coords] = callbackValue
        if DoesEntityExist(entity) then else goto sync end
        for k,v in ipairs(table.ped_route) do
            TaskGoStraightToCoord(entity, v.xyz, 1.0, -1, v.w, 0.5)
            repeat
                Wait(100)
                TaskGoStraightToCoord(entity, v.xyz, 1.0, -1, v.w, 0.5)
            until ( #(GetEntityCoords(entity) - v.xyz) < 2 )
            SetEntityHeading(entity, v.w)
        end
        TriggerClientEvent('vgroupcore:jedzenie:rastaurants:loadanimation', -1, "mp_fbi_heist", "loop", callbackValue, table)
        Wait(1000)
        FreezeEntityPosition(entity, true)
    end
end)


RegisterNetEvent('vgroupcore:jedzenie:rastaurants:kup', function(table, price, netid)
    local count = ox_inventory.GetItemCount(source, 'money')
    if count >= price then ox_inventory.RemoveItem(source, 'money', price) else return TriggerClientEvent('ox_lib:notify', source, {
        description = Config.Locales.NoMoney.. price - count ,
        type = 'error'
    }) end
    TriggerClientEvent('vgroupcore:jedzenie:rastaurants:przygotuj', source, table, netid, source)
end)

ESX.RegisterServerCallback('vgroupcore:jedzenie:cb:restaurants:target', function(src, cb)
    cb(spawned)
end)

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:dajtace', function(tabela, sourcee)
    if source == sourcee then

        TriggerClientEvent('vgroupcore:jedzenie:rastaurants:niestace', source, tabela)
        TriggerClientEvent('vgroupcore:jedzenie:rastaurants:odebrane', -1)
    end
end)

RegisterNetEvent('vgroupcore:jedzenie:rastaurants:dajnatace', function(tabela)

    ox_inventory.AddItem(source, tabela, 1)

end)

ESX.RegisterServerCallback('vgroupcore:jedzenie:cb:spawnprop', function(src, cb, model, coords)
    local callbackValue = 0
    ::sync::
    ESX.OneSync.SpawnObject(model, coords, GetEntityHeading(GetPlayerPed(src)), function(obj)
        callbackValue = obj
    end)
    while callbackValue == 0 do
        Wait(10)
    end
    if DoesEntityExist(NetworkGetEntityFromNetworkId(callbackValue)) then else goto sync end
    cb(callbackValue)
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    DeleteEntity(entity)
end)
