local protocol = "protocol:viz_ni"
local acceptedComputers = {241}


local tArgs = { ... }
if #tArgs < 1 then
    print("Hello")
    return
end

local sProgram = tArgs[1]
local sPath = shell.resolveProgram(sProgram)
if sPath == nil then
    print("No such program: " .. sProgram)
    return
end

print("Running " .. sProgram)

local te2 = require"glasses"
local terminal = te2.create(325, 0, 40, 40) -- Position and size of terminal
local previousTerm = term.redirect(terminal)
term.current().setVisible(false)

local co = coroutine.create(function()
    (shell.execute or shell.run)(sProgram, table.unpack(tArgs, 2))
end)

local function resume(...)
    local ok, param = coroutine.resume(co, ...)
    if not ok then
        printError(param)
    end
    return param
end

peripheral.find("modem", rednet.open)

local idFilter = {}

for _, value in ipairs(acceptedComputers) do
    idFilter[value] = true
end


local keyboardBlocker = require"keyboardBlocker"

local ok, param = pcall(function()
    local sFilter = resume()
    while coroutine.status(co) ~= "dead" do
        local tEvent = table.pack(os.pullEventRaw())
        if sFilter == nil or tEvent[1] == sFilter or tEvent[1] == "terminate" then
            if tEvent[1] == "rednet_message" and tEvent[4] == protocol and idFilter[tEvent[2]] then
                tEvent = textutils.unserialise(tEvent[3])
                tEvent.n = #tEvent
            end
            tEvent = keyboardBlocker(tEvent)
            if tEvent then
                sFilter = resume(table.unpack(tEvent, 1, tEvent.n))
            end
        end
    end
end)
terminal.cleanup()
term.redirect(previousTerm)
if not ok then
    printError(param)
end