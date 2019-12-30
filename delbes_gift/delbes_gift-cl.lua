ESX                           = nil

Citizen.CreateThread(function ()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		if (GetDistanceBetweenCoords(coords, -63.478, -1100.056, 26.238, false) < 5) then
			DrawText3DsEventoNatal(-63.478, -1100.056, 26.238, '[Noel Baba] ile konuşmak için /prendinhagg yazın!')
			DrawText3DsEventoNatal(-63.478, -1100.056, 26.038, 'Altın oyun mutlu noeller diler!')
		end
	end
end)


local jafezcomandoparaobterprenda = false
RegisterCommand("prendinhagg", function(source, args, rawCommand)
	local pos = GetEntityCoords(GetPlayerPed(-1), false)
    if (Vdist(-63.478, -1100.056, 26.238, pos.x, pos.y, pos.z - 1) < 5.0) then
		ESX.TriggerServerCallback('goldengaming:verificarrecebeu', function(jarecebeu)
			if jafezcomandoparaobterprenda == false then
				jafezcomandoparaobterprenda = true
				if jarecebeu == 0 then
					jafezcomandoparaobterprenda = true

					local novamatricula = GeneratePlate2()
					TriggerServerEvent('goldengaming:receberprenda', novamatricula)

					exports['mythic_notify']:SendAlert('success', 'Altın oyun size mutlu noeller diler!', 15000)
					exports['mythic_notify']:SendAlert('inform', 'Arabaları alın ve küçük hediyelerinizin tadını çıkarın!', 5000)
				else
					exports['mythic_notify']:SendAlert('error', 'Noel Baba sadece bir hediye sunuyor!', 5000)
				end
			else
				exports['mythic_notify']:SendAlert('error', 'Noel Baba sesiz olmanız için hediye verir!')
			end
		end)
	else
		exports['mythic_notify']:SendAlert('error', 'Noel ağacının yakınında değilseniz!')
	end
end)



function DrawText3DsEventoNatal(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end



-------------------------------------------
-------------------------------------------
--BELOW IS THE CODE TO GENERATE THE PLATE--
---------CREDITS TO ESX_VEHICLESHOP--------
-------------------------------------------




local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate2()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
			generatedPlate = string.upper(GetRandomLetter(1) .. ' GG ' .. GetRandomNumber(4))

		ESX.TriggerServerCallback('esx_vehicleshop_delbes:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop_delbes:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end