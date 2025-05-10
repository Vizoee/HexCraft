while true do
    local e = {os.pullEvent()}
    print(table.unpack(e))
end