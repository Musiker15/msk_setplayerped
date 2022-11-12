ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		local alterTable = MySQL.query.await("ALTER TABLE users ADD COLUMN IF NOT EXISTS `pedModel` varchar(255) DEFAULT NULL;")

		if alterTable and alterTable.warningStatus < 1 then
			print('^2 Successfully ^3 altered ^2 table ^3 users ^0')
		end
	end
end)

ESX.RegisterServerCallback('msk_setPlayerModel:getPedModelFromDB', function(source, cb)
    local model = MySQL.query.await("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = ESX.GetPlayerFromId(source).identifier})

    if model[1] then
        cb(model[1])
    else
        cb(false)
    end
end)

RegisterCommand('setPlayerModel', function(source, args, rawCommand)
    if (source == 0) then
		if args[1] and args[2] then
            local xPlayer = ESX.GetPlayerFromId(args[1])

            MySQL.query("UPDATE users SET pedModel = @pedModel WHERE identifier = @identifier", { 
                ['@identifier'] = xPlayer.identifier,
                ['@pedModel'] = args[2],
            })
            xPlayer.triggerEvent('msk_setPlayerModel:setPlayerModel', args[2])
		else
			print('^1 SYNTAX ERROR:^5 setPlayerModel <playerID> <model> ^0')
		end
    end
end)

RegisterCommand('setDefaultModel', function(source, args, rawCommand)
    if (source == 0) then
		if args[1] then
            local xPlayer = ESX.GetPlayerFromId(args[1])

            MySQL.query("UPDATE users SET pedModel = @pedModel WHERE identifier = @identifier", { 
                ['@identifier'] = xPlayer.identifier,
                ['@pedModel'] = NULL,
            })
            xPlayer.triggerEvent('msk_setPlayerModel:setDefaultModel')
		else
			print('^1 SYNTAX ERROR:^5 setDefaultModel <playerID> ^0')
		end
    end
end)

---- Github Updater ----
local VersionChecker = true

function GetCurrentVersion()
	return GetResourceMetadata( GetCurrentResourceName(), "version" )
end

local CurrentVersion = GetCurrentVersion()
local resourceName = "^4["..GetCurrentResourceName().."]^0"

if VersionChecker then
	PerformHttpRequest('https://raw.githubusercontent.com/Musiker15/msk_setplayerped/main/VERSION', function(Error, NewestVersion, Header)
		print("###############################")
    	if CurrentVersion == NewestVersion then
	    	print(resourceName .. '^2 ✓ Resource is Up to Date^0 - ^5Current Version: ^2' .. CurrentVersion .. '^0')
    	elseif CurrentVersion ~= NewestVersion then
        	print(resourceName .. '^1 ✗ Resource Outdated. Please Update!^0 - ^5Current Version: ^1' .. CurrentVersion .. '^0')
	    	print('^5Newest Version: ^2' .. NewestVersion .. '^0 - ^6Download here: ^9https://github.com/Musiker15/msk_setplayerped/releases/tag/v'.. NewestVersion .. '^0')
    	end
		print("###############################")
	end)
else
	print("###############################")
	print(resourceName .. '^2 ✓ Resource loaded^0')
	print("###############################")
end