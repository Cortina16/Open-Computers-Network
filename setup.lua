local ipUtils = require("ipUtils")
local multiport = require('multiport')
local ARP = require('protocol/ARP')
local dhcpServer = require('protocol/dhcpServer')
local dhcpClient = require('protocol/dhcpClient')
local icmp = require('protocol/icmp')
local setup = function()
    _G.IP = {}
    _G.IP.clientIP = dhcpClient.discovery()
    _G.IP.subnetMask = ipUtils.IPnumberToCondense('0.0.0.0')
    _G.IP.defaultGateway = ipUtils.IPnumberToCondense('0.0.0.0')
    _G.IP.MAC = require("component").modem.address
    _G.IP.TYPE = 'DHCP'
    _G.IP.IPDeclaredFlag = false

    --requiring of everything right now, pulling all essential functions and variables
    dhcpClient.discovery()
end


setup()