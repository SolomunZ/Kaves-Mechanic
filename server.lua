local vehData = {}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll("SELECT * FROM kaves_mechanics",{}, function(result)
        for plate, data in pairs(result) do
            vehData[data.plate] = json.decode(data.data)
        end
    end)
end)

vRP.prepare("mec/get","SELECT * FROM kaves_mechanics WHERE plate = @plate")
vRP.prepare("mec/update","UPDATE kaves_mechanics SET data = @data WHERE plate = @plate")
vRP.prepare("mec/save","INSERT INTO kaves_mechanics (plate, data) VALUES (@plate, @data)")

RegisterServerEvent("kaves_mechanic:server:syncFitment", function(vehicleId, fitmentData)
    TriggerClientEvent("kaves_mechanic:client:syncFitment", -1, vehicleId, fitmentData)
end)

RegisterServerEvent("kaves_mechanic:server:useNitro", function(vehicleId)
    TriggerClientEvent("kaves_mechanic:client:useNitro", -1, vehicleId)
end)

RegisterNetEvent("kaves_mechanic:server:addElement")
AddEventHandler("kaves_mechanic:server:addElement",function(section, data)
    print("teste")
    print(json.encode(data))

    if not vehData[data.plate] then
        vehData[data.plate] = {}
    end

    if section == "fitment" then
        vehData[data.plate][section] = data.fitment
    elseif data.component.mod == "Stock" then
        vehData[data.plate][section] = nil
    else
        vehData[data.plate][section] = data.component.mod
    end

    local output = vRP.query("mec/get",{plate = data.plate})
        print(#output)
        if #output > 0 then
            vRP.execute("mec/update",{
                ["@plate"] = data.plate,
                ["@data"] = json.encode(vehData[data.plate]),
            })
        else
            vRP.execute("mec/save",{
                ["@plate"] = data.plate,
                ["@data"] = json.encode(vehData[data.plate]),
            })
        end

    return TriggerClientEvent("kaves_mechanic:client:updateVehData", -1, vehData)
end)


Citizen.CreateThread(function()
    
    function src.buyComponent(data)
        local source = source
        local xPlayer = GetPlayer(source)

        if not xPlayer then
            return
        end

        local pMoney = GetMoney(source)

        if pMoney >= data.price then
            RemoveMoney(source, data.price)
            return true
        end

        Notification(Config.Locale["dont_have_money"])
        return false

    end

    function src.VehData()
        return (vehData)
    end

end)

function src.verifyMec()
    local source = source
    local xPlayer = vRP.getUserId(source)
    if vRP.hasPermission(xPlayer, "mecanico.permissao") then
        return true
    else
        TriggerClientEvent("Notify",source,"negado","Você não é um mecânico!",8000)
        return false
    end
end
