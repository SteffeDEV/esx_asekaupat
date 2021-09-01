ESX = nil
local label,label2,hinta,hinta2

local cordinaatit = {
    --vituttaako kun et saanu dumpattua?
}

--made by karpo#1943

CreateThread(function()
    while ESX == nil do
        Wait(10)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
    TriggerServerEvent("karpo_asekaupat:lol")
    Wait(300) --venataan et saadaan servun puolelta asekaupat
    while true do
        local wait = 1500
        local coords = GetEntityCoords(PlayerPedId())
        for i=1, #cordinaatit do
            local aika = GetClockHours()
            local asekauppa = #(cordinaatit[i].pos - coords) --OMG MATEMATIIKKA OLI YHDEKSÄN OMFGFOGMFGMFG
            if asekauppa < 1.5 then 
                wait = 5
                if aika < 4 or aika >= 22 then
                    ESX.ShowHelpNotification("Paina ~INPUT_CONTEXT~ avataksesi "..cordinaatit[i].raha.." asekauppa")
                    if IsControlJustPressed(0, 38) then
                        menu(i)
                    end
                else
                    ESX.ShowHelpNotification("Tule takaisin 22.00-4.00")
                end
            end
        end
        Wait(wait)
    end
end)


--tää on ihan vitun spagettikoodia XDDD
menu = function(kauppa)
    local elements = {}
    for i=1, #cordinaatit[kauppa].aseet do --loopataan aseiden läpi
        local tykki = cordinaatit[kauppa].aseet[i].ase
        label = cordinaatit[kauppa].aseet[i].label
        hinta = cordinaatit[kauppa].aseet[i].hinta
        table.insert(elements, {label = label.. '  <span style = "color:green;">$' ..cordinaatit[kauppa].aseet[i].hinta.."</span>", value = tykki, lol = "ase", hinta = hinta, label22 = label})
    end
    for i=1, #cordinaatit[kauppa].itemit do --loopataan itemeiden läpi
        local itemi = cordinaatit[kauppa].itemit[i].itemi
        label2 = cordinaatit[kauppa].itemit[i].label
        hinta2 = cordinaatit[kauppa].itemit[i].hinta
        table.insert(elements, {label = label2.. '  <span style = "color:green;">$' ..cordinaatit[kauppa].itemit[i].hinta.."</span>", value = itemi, lol = "itemi", hinta = hinta2, label22 = label2})
    end
    local raha = cordinaatit[kauppa].raha
    ESX.UI.Menu.Open(
	    'default', GetCurrentResourceName(), 'npc',
	    {
	        title    = 'Myyjä',
	        align    = 'bottom',
	        elements = elements, 
	    },
		function(data, menu)
        local a = data.current.value
        local b = data.current.lol
        local c = data.current.hinta
        local d = data.current.label22
        if b == "ase" then
            TriggerServerEvent("karpo_asekaupat:osta", a, b, raha, c, d)
        end
        if b == "itemi" then
            TriggerServerEvent("karpo_asekaupat:osta", a, b, raha, c, d)
        end
    end,
	function(data, menu)  
		menu.close()
    end)
    CreateThread(function() --ei vittu nauran vieläki tälle :DDDDDDDDDDDDDDDDDDDDDD MUTTA HEI SE TOIMII LMFAO
        while true do
            Wait(1000)
            local nopeus = GetEntitySpeed(PlayerPedId())
            if nopeus > 1.6 then
                ESX.UI.Menu.CloseAll()
                break --sitku menu kiinni nii rikkoo loopin
            end
        end
    end)
end

RegisterNetEvent("karpo_asekaupat:notifi")
AddEventHandler("karpo_asekaupat:notifi", function(msg)
    ESX.ShowAdvancedNotification('Asekauppa', msg, '', "CHAR_AMMUNATION", 1)
end)

RegisterNetEvent("karpo_asekaupat:dumpperitpois")
AddEventHandler("karpo_asekaupat:dumpperitpois", function(mad)
    cordinaatit = mad
end)
