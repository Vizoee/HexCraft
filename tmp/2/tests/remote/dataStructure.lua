local remote = {}


remote.packetRequestType = "request"
remote.packetResponseType = "response"

remote.packetTouchRequestType = "touch_request"
remote.packetTouchResponseType = "touch_response"
remote.requestTimeout = 3
remote.connectionTimeoutRetries = 3

local timeSinceLastMessageReceived = 0


remote.protocol = nil

function remote.createPacket(type, content)
    return {
        type = type,
        content = content
    }
end

function remote.decode(message)
    return textutils.unserializeJSON(message)
end

function remote.encode(message)
    return textutils.serializeJSON(message)
end

function remote.setProtocol(protocol)
    remote.protocol = protocol
end

function remote.send(id, message)
    rednet.send(id, remote.encode(message), remote.protocol)
end

function remote.receive()
    while true do
        local id, messageString = rednet.receive(remote.protocol, remote.requestTimeout)
        local message = textutils.unserializeJSON(messageString)
        if message.type == remote.packetTouchRequestType then
            local response = remote.createPacket(remote.packetTouchResponseType)
            remote.send(id, response)
        elseif message.type == remote.packetTouchRequestType then
            return id, message
        end
    end
end

function remote.sendTouchRequest(receiver)
    if type(receiver) == "string" then
        receiver = rednet.lookup(remote.protocol, receiver)
    end
    local request = remote.createPacket(remote.packetTouchRequestType)
    remote.send(receiver, request)
end

return remote