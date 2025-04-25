peripheral.find("modem", rednet.open)
local protocol = "protocol:viz_pc"

while true do
    local message = rednet.receive(protocol)
end