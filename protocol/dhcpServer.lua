local multiport = require("./multiport")
local ipUtils = require("./ipUtils").tools
local serialization = require("serialization")

local dhcpServer = {}
local assignedIPs = {}
local dhcpServerPort = 67
local subnetMask = nil
local defaultGateway = nil

--TODO set a value for the subnetMask and defaultGateway
_G.IP.clientIP = numberToCondense('192.168.1.2')

dhcpServer.primaryPacketHandling = function(packet)
    packet = serialization.unserialize(packet)
    if packet.data == '' then
        packet = serialization.serialize(packet)
        dhcpServer.assignIP(packet)
    elseif packet.data == 'ACK' then
        packet = serialization.serialize(packet)
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
        clientIPRequestStoring = ipUtils.numberToCondense(clientIPRequest)
            --handle packet data changing

    until not assignedIPs[clientIPRequestStoring] == clientIPRequestStoring or ipUtils.numberToCondense('255.255.255.255') == clientIPRequestStoring or ipUtils.numberToCondense('192.168.1.2') == clientIPRequestStoring or ip[4] == 1 or ip[4] == 0
    sendingPacket = ipUtils.createPacket(packet.protocol, packet.receiverPort, packet.senderPort, packet.targetIP, packet.senderIP, packet.targetMAC, packet.senderMAC, clientIPRequest)
    multiport.outboundOrganizer(sendingPacket) --TODO check out if this packet is right
    return clientIPRequest
end

dhcpServer.acknowledgment = function(packet)
    packet = serialization.unserialize(packet)
    if packet.data == 'ACK' then
        assignedIPs[packet.senderIP] = packet.senderMAC
    end
end