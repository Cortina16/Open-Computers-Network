local modem = require("component").modem
local serialization = require("serialization")
local ipUtils = require("ipUtils")
local event = require("event")

--funny pulling of all protocols for the proper use of ports so this will be listening then calling protocols. At least I hope.
local dhcpServer = require("protocol/dhcpServer")
local dhcpClient = require("protocol/dhcpClient")
local arpProtocol = require("protocol/ARP")

local multiport = {}
local multiportPort = 700

multiport.outboundOrganizer = function (packet)
    if packet.targetIP == ipUtils.IPnumberToCondense('255.255.255.255') or packet.targetMAC == 'FF:FF:FF:FF:FF:FF' then
        multiport.outboundMultiPortBroadcast(packet)
    else
        multiport.outboundMultiPortIndividual(packet)
    end
end


multiport.outboundMultiPortIndividual = function (packet)
   local sentPacket = serialization.serialize(packet)
    if _G.IP.ARPtable[packet.targetIP] then
        modem.send(_G.ARPtable[packet.targetIP], multiportPort, sentPacket)
        return
    else
        arpProtocol.sendArpRequest(packet.targetIP)
        while not _G.IP.ARPtable[packet.targetIP] do
            os.sleep(0.1)
        end
    end
        --TODO: make macs work on OC
end

multiport.outboundMultiPortBroadcast = function (packet)
    local sentPacket = serialization.serialize(packet)

    modem.broadcast(multiportPort, sentPacket)
end
--inbound handling
event.listen("modem_message", function(_, _, _, port, _, packet)
    packet = serialization.unserialize(packet)
    if not packet then return end
    if packet.targetMAC ~= 'FF:FF:FF:FF:FF:FF' and packet.targetMAC ~= _G.IP.MAC then return end
    if packet.targetIP ~= ipUtils.IPnumberToCondense("255.255.255.255") and packet.targetIP ~= _G.IP.clientIP then return end

    if packet.Protocol == ipUtils.ProtocolTable.ARP then
        arpProtocol.handleARP(packet)
    end
            if port == multiportPort then
                event.push("multiport_message", nil, n3il, packet.port, nil, serialization.serialize(packet))
            elseif port == 67 then
                dhcpServer.primaryPacketHandling(packet)
            elseif port == 68 then
                dhcpClient.primaryPacketHandling(packet)
            elseif port == 1982 then
                --TODO: turn this into protocol instead of port cause this don't really exist

            else
                return
            end
end)

return multiport