ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local webhook = "Webhook here as string"

local kaupat = {
    [1] = {
        pos = vector3(-241.9, -948.5, 31.2),
        raha = "puhdas",
        aseet = {
            {label = "MK2", ase = "WEAPON_PISTOL_MK2", hinta = 24000},
            {label = "REVOLVER", ase = "WEAPON_REVOLVER", hinta = 38000},
            {label = "SNSMK2", ase = "WEAPON_SNSPISTOL_MK2", hinta = 17000},
            {label = "VINTAGE", ase = "WEAPON_VINTAGEPISTOL", hinta = 25000}
        },
        itemit = {
            {itemi = "luotiliivi", label = "LUOTILIIVIT", hinta = 4500},
            {itemi = "lipas", label = "LIPAS", hinta = 200},
            {itemi = "silu", label = "SILU", hinta = 1500},
            {itemi = "superskini", label = "ASEMAALI", hinta = 3500}
        }
    },
    [2] = {
        pos = vector3(-236.5, -940.2, 31.2),
        raha = "likainen",
        aseet = {
            {label = "SMG", ase = "WEAPON_SMG", hinta = 70000},
            {label = "AK-47", ase = "WEAPON_ASSAULTRIFLE", hinta = 70000},
            {label = "COMBAT-PDW", ase = "WEAPON_COMBATPDW", hinta = 56000},
            {label = "MICRO-SMG", ase = "WEAPON_MICROSMG", hinta = 55000},
            {label = "BULLPUP SHOTGUN", ase = "WEAPON_BULLPUPSHOTGUN", hinta = 42000}
        },
        itemit = {
            {itemi = "luotiliivi", label = "LUOTILIIVIT", hinta = 6500},
            {itemi = "lipas", label = "LIPAS", hinta = 300},
            {itemi = "silu", label = "SILU", hinta = 3500},
            {itemi = "superskini", label = "ASEMAALI", hinta = 7500}
        }
    }
}

RegisterNetEvent("karpo_asekaupat:osta")
AddEventHandler("karpo_asekaupat:osta", function(tavara, tapa, raha, hinta22, label22)
    local xPlayer = ESX.GetPlayerFromId(source)
    local massit = xPlayer.getMoney()
    local likaset = xPlayer.getAccount('black_money').money
    if raha == "likainen" then
        if likaset >= hinta22 then
            xPlayer.removeAccountMoney("black_money", hinta22)
            if tapa == "ase" then
                xPlayer.addWeapon(tavara, 420)
            end
            if tapa == "itemi" then
                xPlayer.addInventoryItem(tavara, 1)
            end
            TriggerClientEvent("karpo_asekaupat:notifi", source, "Ostit: "..label22.. " hintaan: ~g~$" ..hinta22.."")
            Log("**Item**: " .. label22.. "\n**Price**: " ..hinta22.. "$", '3863105', GetPlayerName(source), "Weapon shop logs")
        else
            local puuttuva = hinta22 - likaset
            TriggerClientEvent("karpo_asekaupat:notifi", source, "Sinulta puuttuu vielä: ~g~$" ..puuttuva.."")
        end
    end
    if raha == "puhdas" then
        if massit >= hinta22 then
            xPlayer.removeMoney(hinta22)
            if tapa == "ase" then
                xPlayer.addWeapon(tavara, 420)
            end
            if tapa == "itemi" then
                xPlayer.addInventoryItem(tavara, 1)
            end
            TriggerClientEvent("karpo_asekaupat:notifi", source, "Ostit: "..label22.. " hintaan: ~g~$" ..hinta22.."")
            Log("**Item**: " .. label22.. "\n**Price**: " ..hinta22.. "$", '3863105', GetPlayerName(source), "Weapon shop logs")
        else
            local puuttuva = hinta22 - massit
            TriggerClientEvent("karpo_asekaupat:notifi", source, "Sinulta puuttuu vielä: ~g~$" ..puuttuva.."")
        end
    end

end)

function Log(m, c, t, n)
    local co = {
        {
            ["color"] = c,
            ["title"] = t,
            ["description"] = m,
            ["footer"] = {
                ["text"] = os.date("%x | %X")
            },
        }
    }

    PerformHttpRequest(webhook, 
        function(status, text, headers)
            if status ~= 204 then
                print("Error while making log [POST] request!\n" .. err)
            end
        end, 'POST', json.encode({username = n, embeds = co}), { ['Content-Type'] = 'application/json'}
    )
end

RegisterNetEvent("karpo_asekaupat:lol")
AddEventHandler("karpo_asekaupat:lol", function()
    TriggerClientEvent("karpo_asekaupat:dumpperitpois", source, kaupat)
end)
