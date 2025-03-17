while true do
    local event, message = os.pullEvent("customMessage")
    print("Received: " .. message)
end