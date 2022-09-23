Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

local displayCount = 1

function Animation(ped, dict, name)
    if not DoesAnimDictExist(dict) then
      return
    end
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
    Citizen.Wait(0)
    end
    TaskPlayAnim(ped, dict, name, -1.0, -0.5, 2000, 1, 0, true, 0, false, 0, false)
    RemoveAnimDict(dict)
end


RegisterNetEvent("diceroll:client:roll")
AddEventHandler("diceroll:client:roll", function(sourceId, maxDinstance, rollTable, sides)
    local rollString = CreateRollString(rollTable, sides)
    local offset = 1 + (displayCount*0.2)
    Citizen.InvokeNative(0xB31A277C1AC7B7FF,PlayerPedId(),1,2,GetHashKey("KIT_EMOTE_ACTION_FIST_PUMP_1"),0,0,0,0,0)
    -- RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
    -- while (not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank")) do
    --     Citizen.Wait(0)
    -- end
    -- TaskPlayAnim(GetPlayerPed(GetPlayerFromServerId(sourceId)), "anim@mp_player_intcelebrationmale@wank" ,"wank" ,8.0, -8.0, -1, 49, 0, false, false, false )
    -- Citizen.Wait(2400)
    -- ClearPedTasks(GetPlayerPed(GetPlayerFromServerId(sourceId)))
    ShowRoll(rollString, GetPlayerFromServerId(sourceId), maxDinstance, offset)
end)

function ShowRoll(text, sourcePlayer, maxDistance, offset)
    local display = true
    Citizen.CreateThread(function()
        Wait(7000) -- display seconden (nu 7s)
        display = false
    end)

    Citizen.CreateThread(function()
        displayCount = displayCount + 1
        while display do
            Wait(3)
            local sourcePos = GetEntityCoords(GetPlayerPed(sourcePlayer), false)
            local pos = GetEntityCoords(PlayerPedId(), false)
            if (GetDistanceBetweenCoords(pos.x, pos.y, pos.z, sourcePos.x, sourcePos.y, sourcePos.z, true) < maxDistance) then
                DrawText3D(sourcePos.x, sourcePos.y, sourcePos.z + offset - 1.25, text)
            end
        end
        displayCount = displayCount - 1
    end)
end

function CreateRollString(rollTable, sides)
    local s = "Roll: "
    local total = 0
    for k, roll in pairs(rollTable, sides) do
        total = total + roll
        if k == 1 then
            s = s .. roll .. "/" .. sides
        else
            s = s .. " | " .. roll .. "/" .. sides
        end
    end
    s = s .. " | (Total: "..total..")"
    return s
end

function DrawText3D(x,y,z,text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    SetTextScale(0.25, 0.25)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    local factor = (string.len(text)) / 150
end