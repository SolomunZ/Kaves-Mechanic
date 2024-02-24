local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

Citizen.CreateThread(function()

    GetPlayer = function(Id)
        return vRP.getUserId(Id)
    end

    AddInventoryItem = function(Id, item, count)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
           vRP.giveInventoryItem(xPlayer, item, count)
        end
    end

    RemoveInventoryItem = function(Id, item, count)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
            vRP.tryGetInventoryItem(xPlayer, item, count)
        end
    end

    GetInventoryItem = function(Id, item)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
            return vRP.getInventoryItemAmount(xPlayer, item)
        end
    end

    --UsableItem = Framework.RegisterUsableItem 

    AddMoney = function(Id, amount)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
            vRP.giveBankMoney(xPlayer,amount)
        end
    end
    
    GetMoney = function(Id)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
            return (vRP.getBankMoney(xPlayer)+vRP.getMoney(xPlayer))
        end
    end

    RemoveMoney = function(Id, amount)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
            vRP.tryFullPayment(xPlayer,amount)
        end
    end

    Notification = function(Id, message)
        local xPlayer = vRP.getUserId(Id)
        if xPlayer then
            TriggerClientEvent("Notify",Id,"info",message) 
        end
    end
end)