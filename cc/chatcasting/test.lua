local commandFolder = "/commands"

local function executeCommand(input)
    -- Extract first word (command) and the rest of the string (parameters)
    local command, params = input:match("^(%S+)%s*(.*)")
    if not command then
        print("No command entered")
        return
    end

    -- Construct command path
    local commandPath = fs.combine(commandFolder, command .. ".lua")
    
    if fs.exists(commandPath) and not fs.isDir(commandPath) then
        local success, err = pcall(function()
            shell.run(commandPath, params)
        end)
        
        if not success then
            print("failed")
        end
    else
        print("Command not found")
    end
end

-- Example usage
print("Enter command:")
local input = read()
executeCommand(input)