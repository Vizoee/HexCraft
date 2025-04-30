-- Script for keyboard pc handler
local id = 32 -- Id of Neural Interface

peripheral.find("modem", rednet.open)
local protocol = "protocol:viz_ni"

local filterKeyTypes = {
    "char",
    "key",
    "key_up",
    "mouse_click",
    "mouse_drag",
    "mouse_up"
}
local filter = {}

for _, value in ipairs(filterKeyTypes) do
    filter[value] = true
end

while true do
    local e = table.pack(os.pullEvent())
    if filter[e[1]] then
        if id then
            print("Sending "..e[1].." "..e[2])
            
            local message = textutils.serialise(e)
            rednet.send(id, message, protocol)
        else
            print("No receiver")
        end
    end
end



