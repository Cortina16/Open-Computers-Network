package.path = package.path .. ";../?.lua"

local ipUtils = require('ipUtils')
local setup = require('setup')
local multiport = require('multiport')
local arp = require('ARP')
local icmp = require('icmp')

local ping = {}

ping.name = 'ping'
ping.description = 'Ping a specified device with default 32 byte packet'
ping.ping = function(ip)
    if not ping.coroutine or coroutine.status(ping.coroutine) == "dead" then
        ping.coroutine = coroutine.create(function()
            local packet = ipUtils.createPacket('icmp', icmp.port, _G.IP.clientIP, ip, _G.IP.MAC, _G.IP.ARPtable[ip], '32 bytes' ) --TODO create a byte size generator, ipUtuils.byteSizeGen = function(wantedSize) ... end. wanted size is the desired data size
            print('Pinging ' .. ip .. " with " .. packet.data .. ' bytes of data:')
            for i = 1, 5 do
                multiport.outboundOrganizer(packet)
                local startTime = os.clock()
                coroutine.yield(ping.ping)
                print('Reply from ' + ip + ': time=' + startTime + 'ms')

                --have this listen for the return before mathing time
            end
        end)
    end
end

ping.receive = function(packet)
    if packet.data == '32 bytes' then
        startTime = os.clock() - startTime
        if ping.coroutine and coroutine.status(ping.coroutine) == "suspended" then
            coroutine.resume(ping.coroutine)
        end
    end
end