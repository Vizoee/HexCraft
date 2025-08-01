peripheral.find("modem", rednet.open)
local protocol = "viz network :3"
rednet.host(protocol, "viz ni")

while true do
    local id, message = rednet.receive(protocol)
    print("received: "..message)
end