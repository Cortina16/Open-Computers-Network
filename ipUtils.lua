local tools = {}
local serialization = require("serialization")
--#TODO either void this usage of MAC or fix it
tools.encodeAsMAC = function(UUID)
    UUID:gsub("%-", "")
    UUIDsect:sub(1, 12)

end
tools.MACtoCondense = function(MAC)
    local intMAC = 0
    MACarray = MAC:gmatch('[:%-]')
    for hexpair in MAC:gmatch('%x%x') do
        local hexPortion = tonumber(hexpair, 16)
        intMAC = intMAC * 256 + hexPortion
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
    condensedIP = math.floor(condensedIP %256^3)
    parts[2] = math.floor(condensedIP / 256^2)
    condensedIP = math.floor(condensedIP % 256^2)
    parts[3] = math.floor(condensedIP / 256)
    condensedIP = math.floor(condensedIP % 256)

    parts[4] = math.floor(condensedIP % 256)
    return table.concat(parts, ".")
end





--[[
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
    return packet
end
]]--
tools.createPacket.dataLink = function(protocol, fromMAC, toMAC, data)
    local DataLinkPacket = {
        protocol = protocol,
        senderMAC = fromMAC,
        targetMAC = toMAC,
        data = data
    }
    return  DataLinkPacket
end
tools.createPacket.Network = function(protocol, fromIP, toIP, DataLinkPacket, data)
    local NetworkPacket = {
        protocol = protocol,
        senderIP = fromIP,
        targetIP = toIP,
        DataLinkPacket = DataLinkPacket,
        data = data

    }
    return  NetworkPacket
end
tools.createPacket.Transport = function(protocol, fromPort, toPort, NetworkPacket, data)
    local TransportPacket = {
        protocol = protocol,
        senderPort = fromPort,
        targetPort = toPort,
        NetworkPacket = NetworkPacket,
        data = data
    }
    end
tools.createPacket.Session = function()

end
tools.createPacket.Presentation = function()

end
tools.createPacket.Application = function()

end

tools.ProtocolTable = {
    ARP = 1,
    DHCP = 2,
    DNS = 3,
    HTTP = 4,
    HTTPS = 5,
    FTP = 6,
}



return tools


