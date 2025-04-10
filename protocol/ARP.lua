package.path = package.path .. ";../?.lua"

local ipUtils = require('ipUtils')
local serialization = require('serialization')
local multiport = require('multiport')

local arpProtocol = {}
_G.IP.ARPtable = {}
--OPCODES
arpProtocol.OPCODES = {
    REQUEST = 1,
    REPLY = 2
}
arpProtocol.sendArpRequest = function(ip)
    local packet = {
        protocol = ipUtils.ProtocolTable.ARP,
        senderIP = _G.IP.clientIP,
        targetIP = ip,
        senderMAC = _G.IP.MAC,
        targetMAC = 'FF:FF:FF:FF:FF:FF',
        opcode = arpProtocol.OPCODES.REQUEST
    }
    multiport.outboundOrganizer(packet)
end

arpProtocol.handleARP = function(packet)
    if packet.opcode == arpProtocol.OPCODES.REQUEST then
            local replyPacket = {
                protocol = ipUtils.ProtocolTable.ARP,
                senderIP = _G.IP.clientIP,
                targetIP = packet.senderIP,
                senderMAC = _G.IP.MAC,
                targetMAC = packet.senderMAC,
                opcode = arpProtocol.OPCODES.REPLY
            }
            multiport.outboundOrganizer(replyPacket)
    elseif packet.opcode == arpProtocol.OPCODES.REPLY then
        _G.IP.ARPtable[packet.senderIP] = packet.senderMAC
    end

end


return arpProtocol



