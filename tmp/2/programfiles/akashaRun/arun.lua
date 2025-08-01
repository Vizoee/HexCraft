local akashaRun = require"akashaRun"


local pos = {
    ["x"] = 375.5,
    ["y"] = 53.5,
    ["z"] = 2484.5
}
local commandString = arg[1]
local arguments = {table.unpack(arg, 2)}
akashaRun.runAkashicCassette(pos, commandString, arguments)