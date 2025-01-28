local modem = require("component").modem
local serialization = require("serialization")
local multiport = {}
local multiportPort = 1003

multiport.outBoundMultiPortIndividual = function (packet)
    sentPacket = serialization.serialize(packet)

    _G.IP.MAC.send(packet.targetMAC, multiPort, Packet)
end

multiport.outBoundMultiPortBroadcast = function (packet)
    sentPacket = serialization.serialize(packet)

    _G.IP.MAC.broadcast(multiPort, Packet)
end

    multiport.packet = event.listen("modem_message", function(_, _, _, port, _, data)
        packet = serialization.unserialize(packet)
       if port == 1003 then
           event.push("multiport_message", nil, nil, packet.port, nil, serialization.serialize(packet))
       else
           return packet
       end

    end)
