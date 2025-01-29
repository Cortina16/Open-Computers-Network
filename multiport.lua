local modem = require("component").modem
local serialization = require("serialization")
local ipUtils = require("ipUtils")

--funny pulling of all protocols for the proper use of ports so this will be listening then calling protocols. At least I hope.
local dhcpServer = require("protocol/dhcpServer").dhcpServer


local multiport = {}
local multiportPort = 700

multiport.outboundOrganizer = function (packet)
    packet = serialization.unserialize(packet)
    if packet.targetIP == '255.255.255.255' then
        packet = serialization.serialize(packet)
        multiport.outboundMultiPortBroadcast(packet)
    else
        packet = serialization.serialize(packet)
        multiport.outboundMultiPortIndividual(packet)
    end
end


multiport.outboundMultiPortIndividual = function (packet)
    sentPacket = serialization.serialize(packet)

    modem.send(packet.targetMAC, multiportPort, sentPacket) --TODO packetcreate function
end

multiport.outboundMultiPortBroadcast = function (packet)
    sentPacket = serialization.serialize(packet)

    modem.broadcast(multiportPort, Packet)
end

event.listen("modem_message", function(_, _, _, port, _, packet)
    packet = serialization.unserialize(packet)
    if port == multiportPort then
       event.push("multiport_message", nil, nil, packet.port, nil, serialization.serialize(packet))
    elseif port == 67 then
       dhcpServer.assignIP(packet)
    end
end)

