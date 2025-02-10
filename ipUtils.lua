local tools = {}
local serialization = require("serialization")

tools.encodeAsMAC = function(UUID)
    UUID:gsub("%-", "")
    UUIDsect:sub(1, 12)

end
tools.MACtoCondense = function(MAC)
    local intMAC = 0
    MACarray = MAC:gmatch('[:%-]')
    for hexpair in MAC:gmatch('%x%x') do
        local hexPortion = tonumber(hexpair, 16)
        intMAC = intMAC * 256 + hexportion
    end
end

tools.CondensedToMAC = function (condensedMAC)
    local partMACarray = {}
    local a
    for i = 1, 6 do
        partMACarray[7-i] = string.format("%02X", math.floor(condensedMAC % 256))
        condensedMAC = math.floor(condensedMAC /256)
        a = table.concat(partMACarray, ':')
    end
    return a
end

tools.IPnumberToCondense = function(readableIP)
    local ipArray = {}
    for i in readableIP:gmatch("%d+") do
        table.insert(ipArray, tonumber(i))
    end

    local internalIPnum = 0
    for i=1, #ipArray do
        internalIPnum = internalIPnum + ipArray[i]*256^(4-i)
    end
    return math.floor(internalIPnum)
end

tools.IPcondensedToNumber = function(condensedIP)
    local parts = {}
    parts[1] = math.floor(condensedIP / 256^3)
    condensedIP = condensedIP %256^3
    parts[2] = math.floor(condensedIP / 256^2)
    condensedIP = condensedIP % 256^2
    parts[3] = math.floor(condensedIP / 256)
    condensedIP = condensedIP % 256
    parts[4] = condensedIP % 256
    local a = table.concat(parts, "."):reverse()
    a = a:sub(3)
    a=a:reverse()
    return a
end

tools.createPacket = function(protocol, senderPort, targetPort, senderIP, targetIP, senderMAC, targetMAC, data)
    local packet = {
        protocol = protocol,
        senderPort = senderPort,
        targetPort = targetPort,
        senderIP = senderIP,
        targetIP = targetIP,
        senderMAC = senderMAC,
        targetMAC = targetMAC,
        data = data
    }
    packet = serialization.serialize(packet)
    return packet
end

local setup = function()
    _G.IP = {}
    _G.IP.packet = {
        protocol = nil,
        senderPort = nil,
        targetPort = nil,
        senderIP = nil,
        targetIP = nil,
        senderMAC = nil,
        targetMAC = nil,
        data = nil
    }
    _G.IP.clientIP = tools.numberToCondense('0.0.0.0')
    _G.IP.subnetMask = tools.numberToCondense('0.0.0.0')
    _G.IP.defaultGateway = tools.numberToCondense('0.0.0.0')
    _G.IP.MAC = require("component").modem.address
end

local a = '192.168.1.1'
print(tools.numberToCondense(a))
print(tools.condensedToNumber(tools.numberToCondense(a)))
print(string.format('%q', _G.IP.packet))

return tools
