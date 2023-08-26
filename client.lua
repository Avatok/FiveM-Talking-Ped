
local NPCPosition = {x = -74.931, y = -818.786, z = 325.168, rot = 233.98} --Top Maze Bank Tower

local isNearPed = false
local isAtPed = false
local isPedLoaded = false
local pedModel = GetHashKey("u_m_y_rsranger_01")
local npc

Citizen.CreateThread(function()

    while true do

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local distance = Vdist(playerCoords, NPCPosition.x, NPCPosition.y, NPCPosition.z)
        isNearPed = false
        isAtPed = false

        if distance < 20.0 then
            isNearPed = true
            if not isPedLoaded then
                RequestModel(pedModel)
                while not HasModelLoaded(pedModel) do
                    Wait(10)
                end

                npc = CreatePed(4, pedModel, NPCPosition.x, NPCPosition.y, NPCPosition.z - 1.0, NPCPosition.rot, false, false)
                FreezeEntityPosition(npc, true)
                SetEntityHeading(npc, NPCPosition.rot)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)

                isPedLoaded = true
            end
        end

        if isPedLoaded and not isNearPed then
            DeleteEntity(npc)
            SetModelAsNoLongerNeeded(pedModel)
            isPedLoaded = false
        end

        if distance < 2.0 then
            isAtPed = true
        end
        Citizen.Wait(500)
    end

end)

Citizen.CreateThread(function()
    while true do
        if isAtPed then
            showInfobar('Drücke ~g~E~s~, um mit dem Ped zu sprechen')
            if IsControlJustReleased(0, 38) then
                ShowNotification('~b~Ped: ~s~Hallo, ich bin ein Ped!')
            end
        end
        Citizen.Wait(1)
    end
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end