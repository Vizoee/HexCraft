
local focal = peripheral.find("focal_link")

while true do
    local request = focal.receiveIota()
    if type(request) == "table" and request.null == true then
    else
        print(request)
    end
end