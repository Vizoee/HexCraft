shell.setAlias("pt", "/programfiles/pterminal/pt.lua")

local function complete(shell, index, text, previous)
    return shell.completeProgram(text)
end

shell.setCompletionFunction("programfiles/pterminal/pt.lua", complete)

shell.run("bg shell")
shell.run("pt shell")
