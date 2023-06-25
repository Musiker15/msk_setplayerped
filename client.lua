ESX = exports["es_extended"]:getSharedObject()

-- NetworkIsSessionStarted() -- Ignore this!
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
    Wait(1000) -- Please Do Not Touch! // This is for slower PCs

    ESX.TriggerServerCallback('msk_setPlayerModel:getPedModelFromDB', function(ped)
       if ped then setPedModel(ped) end
    end)
end)

RegisterNetEvent('msk_setPlayerModel:setPlayerModel')
AddEventHandler('msk_setPlayerModel:setPlayerModel', function(model)
    if IsModelValid(model) then
        setPedModel(model)
    end
end)

RegisterNetEvent('msk_setPlayerModel:setDefaultModel')
AddEventHandler('msk_setPlayerModel:setDefaultModel', function()
    setDefaultPed()
end)

setPedModel = function(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(1)
    end

    SetPlayerModel(PlayerId(), model)
    SetEntityMaxHealth(PlayerPedId(), 200)
    SetEntityHealth(PlayerPedId(), 200)
    SetPedComponentVariation(PlayerPedId(), 0, 0, 1, 0)
    Wait(1000)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(model)
end

setDefaultPed = function() 
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        local model

        if skin.sex == 0 then
			model = GetHashKey("mp_m_freemode_01")
		else
			model = GetHashKey("mp_f_freemode_01")
		end

        RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(1)
		end

        SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
		TriggerEvent('skinchanger:loadSkin', skin)
		TriggerEvent('esx:restoreLoadout')
		SetEntityCanBeDamaged(PlayerPedId(), true)
    end)
end