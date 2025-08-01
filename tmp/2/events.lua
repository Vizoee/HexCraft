peripheral.find("modem", rednet.open)

while true do
    local e = table.pack(os.pullEvent())
    if e[1] ~= "timer" then
        print(table.unpack(e))
    end
end