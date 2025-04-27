
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

-- local terminal = require"terminal_test"

-- local te2 = require"terminal_test2"
-- local termMain = term.current()
-- local terminal = te2.create(termMain, 1, 1, 20, 5)

function safePrintTable(tbl, indent)
    indent = indent or ""
    for key, value in pairs(tbl) do
        local keyStr = tostring(key)
        local valueType = type(value)

        if valueType == "table" then
            print(indent .. keyStr .. " = {")
            safePrintTable(value, indent .. "  ")
            print(indent .. "}")
        elseif valueType == "function" or valueType == "userdata" or valueType == "thread" then
            print(indent .. keyStr .. " = <" .. valueType .. ">")
        else
            print(indent .. keyStr .. " = " .. tostring(value))
        end
    end
end

local te2 = require"terminal_test3"
local terminal = te2.create(325, 0, 40, 40)
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

local timers = {}

local ok, param = pcall(function()
    local sFilter = resume()
    while coroutine.status(co) ~= "dead" do
        local tEvent = table.pack(os.pullEventRaw())
        if sFilter == nil or tEvent[1] == sFilter or tEvent[1] == "terminate" then
            sFilter = resume(table.unpack(tEvent, 1, tEvent.n))
        end
    end
end)
terminal.cleanup()
term.redirect(previousTerm)
if not ok then
    printError(param)
end