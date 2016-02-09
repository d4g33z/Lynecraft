--easy module finding
local folderOfThisFile = string.match(..., ".+/")
require(folderOfThisFile..'utils')
require("socket")


Connection = {

    new = function (self, address, port)
        --address = address or '127.0.0.1'
        --port = port or 4711
        local obj = { socket = assert(socket.connect(address, port)), lastSent="" }
        setmetatable(obj, self)
        self.__index=self
        return obj
    end,

    drain = function(self)

        self.socket:settimeout(0.01)
        while true do
            local readable,writeable,err = socket.select({self.socket}, {}, 0.0)
            if not readable[self.socket] then
                break
            end
-- DUMB
-- set timeout so that drain works
-- TODO determine if should just set timeout as 0.01 in create() and leave it as such
-- Note this requires the conn:settimeout(0.01) done in create() otherwise this blocks indefinitely
            local data = self.socket:receive(1500)
            if data == '' or not data then
                break
            end
        end

        if data then
            print('~Drained Data:'..data..'~')
            print('~Last Message:'..self.lastSent..'~')
        end

        -- set back to blocking mode
        self.socket:settimeout(nil)
    end,

    send = function (self, f, ...)
        self:drain()
        local msg= f..'('
        local msgData = {}
        for k,v in pairs({...}) do
            if type(v) == "string" then 
                msgData[#msgData+1] = v 
            elseif type(v) == "number" then 
                msgData[#msgData+1] = tostring(v)
            elseif type(v) == "table" then 
                tmp = value_map(tostring,v)
                start_idx=#msgData
                for i,w in pairs(tmp) do
                    msgData[start_idx+i] = w
                end
            end
        end

        if (msgData ~= nil and msgData ~= "") then
            msg = msg..table.concat(msgData,',')
        end

        msg= msg..')'
        --print ("~"..msg.."~")
        self.lastSent=msg
        self.socket:send(msg.."\n")
    end,

    receive = function (self)
        local line = self.socket:receive()
        --print ('~'..line..'~')
        return line
    end,

    sendAndReceive = function (self, ...)
--print ("in sendAndReceive")
--print (...)
        self:send(...)
        local response = self:receive()
--print("local response = "..response)
        return response
    end,

    close = function (self)
        self.socket:close()
    end

}
