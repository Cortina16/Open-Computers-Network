package.path = package.path .. ";../?.lua"

local multiport = require("multiport")
local ipUtils = require("ipUtils")
local serialization = require("serialization")

local dhcpServer = {}
local assignedIPs = {}
dhcpServer.dhcpServerPort = 67
local settings = {subnetMask = ipUtils.IPnumberToCondense('192.168.1.1'), defaultGateway = ipUtils.IPnumberToCondense('192.168.1.1')}


--TODO set a value for the subnetMask and defaultGateway
_G.IP.clientIP = ipUtils.IPnumberToCondense('192.168.1.2')
--Incoming stuff
dhcpServer.primaryPacketHandling = function(packet)
    if packet.data == '' then
        dhcpServer.assignIP(packet)
    elseif packet.data == 'ACK' then
        dhcpServer.acknowledgment(packet)
    end
end

dhcpServer.assignIP = function(packet) --packet has protocol, senderPort, targetPort, senderIP, targetIP, senderMAC, targetMAC, data
    local ip = {}
    repeat
        ip[1] = math.random(1, 255)
        ip[2] = math.random(1, 255)
        ip[3] = math.random(1, 255)
        ip[4] = math.random(1, 255)
        local clientIPRequest = table.concat(ip, ".")
        local clientIPRequestStoring = ipUtils.IPnumberToCondense(clientIPRequest)
            --handle packet data changing

    until assignedIPs[clientIPRequestStoring] == nil or not ipUtils.IPnumberToCondense('255.255.255.255') == clientIPRequestStoring or not ipUtils.IPnumberToCondense('192.168.1.2') == clientIPRequestStoring or ip[4] == 1 or ip[4] == 0
    settings.clientIPRequest = clientIPRequest
    local sendingPacket = ipUtils.createPacket(packet.protocol, packet.targetPort, packet.senderPort, packet.targetIP, packet.senderIP, packet.targetMAC, packet.senderMAC, settings)
    multiport.outboundOrganizer(sendingPacket) --TODO check out if this packet is right
    return clientIPRequest
end

dhcpServer.acknowledgment = function(packet)
    if packet.data == 'ACK' then

        assignedIPs[ipUtils.IPnumberToCondense(packet.senderIP)] = packet.senderMAC
    end
end

return dhcpServer