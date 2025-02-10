package.path = package.path .. ";../?.lua"

local ipUtils = require('ipUtils.lua')
local serialization = require('serialization')
local multiport = require('multiport')

local ARPtable = {}

local arp = function(ip, mac)
    --active check when recieve passive thign

end


