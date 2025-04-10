package.path = package.path .. ";../?.lua"


local ipUtils = require("ipUtils")
local serialization = require("serialization")
local multiport = require("multiport")
local dhcpClient = {}
local dhcpClientPort = 68
local dhcpServerPort = require("dhcpServer").dhcpServerPort

dhcpClient.primaryPacketHandling = function(packet)
    if packet.data:find('IP') then
        dhcpClient.ACK(packet)
    end
    --TODO handle the rest of stuff here

end
dhcpClient.discovery = function() --Should run on startup TODO make it run on startup
   local packet = ipUtils.createPacket(
            'dhcp',
            dhcpClientPort,
            dhcpServerPort,
            _G.IP.clientIP,
            ipUtils.IPnumberToCondense("255.255.255.255"),
            _G.IP.MAC,
            'FF:FF:FF:FF:FF:FF',
            '')
    multiport.outboundMultiPortBroadcast(packet)
end

dhcpClient.ACK = function(packet)
    packet.data:gsub('IP', '')
    if not _G.IP.IPDeclaredFlag then return end
    _G.IP.clientIP = ipUtils.IPnumberToCondense(packet.data)
    ipUtils.createPacket('dhcp', packet.targetPort, packet.senderPort, packet.targetIP, packet.senderIP, packet.targetMAC, packet.senderMAC, 'ACK')
end

return dhcpClient

