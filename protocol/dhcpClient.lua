package.path = package.path .. ";../?.lua"


local ipUtils = require("ipUtils")
local serialization = require("serialization")
local multiport = require("multiport")
local dhcpClient = {}
local dhcpClientPort = 68
local dhcpServerPort = require("dhcpServer").dhcpServerPort

dhcpClient.primaryPacketHandling = function(packet)
    packet = serialization.unserialize(packet)
    --TODO handle the rest of shit here
end
dhcpClient.discovery = function()
    packet = ipUtils.createPacket(
            'nil',
            dhcpClientPort,
            dhcpServerPort,
            _G.IP.clientIP,
            ipUtils.IPnumberToCondense("255.255.255.255"),
            _G.IP.MAC,
            'FF:FF:FF:FF:FF:FF',
            '')
    multiport.outboundMultiPortBroadcast(packet)
end

return dhcpClient

