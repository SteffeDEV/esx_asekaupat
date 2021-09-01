ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local kaupat = {
    [1] = {
        pos = vector3(-625.4, -131.74, 46.94),
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
        pos = vector3(-1297.25, -1048.81, 28.72),
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
        else
            local puuttuva = hinta22 - massit
            TriggerClientEvent("karpo_asekaupat:notifi", source, "Sinulta puuttuu vielä: ~g~$" ..puuttuva.."")
        end
    end

end)

RegisterNetEvent("karpo_asekaupat:lol")
AddEventHandler("karpo_asekaupat:lol", function()
    TriggerClientEvent("karpo_asekaupat:dumpperitpois", source, kaupat)
end)
