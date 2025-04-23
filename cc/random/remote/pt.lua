
local tArgs = { ... }
if #tArgs < 1 then
    print("Usage: " .. tArgs[0] .. " <program>")
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
local terminal = te2.create(325, 0, 39, 12)
local previousTerm = term.redirect(terminal)

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
local protocol = "protocol:viz_ni"
-- rednet.host(protocol, "viz ni")

local ok, param = pcall(function()
    local sFilter = resume()
    while coroutine.status(co) ~= "dead" do
        local tEvent = table.pack(os.pullEventRaw())

        if sFilter == nil or tEvent[1] == sFilter or tEvent[1] == "terminate" then
            
            if tEvent[1] == "rednet_message" and tEvent[4] == protocol then
                tEvent = textutils.unserialize(tEvent[3])
                os.queueEvent(table.unpack(tEvent))
            else
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