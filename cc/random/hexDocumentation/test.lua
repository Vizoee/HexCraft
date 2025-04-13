-- Function to extract the documentation from a Lua file
local function extractDocFromFile(filePath)
    local file = io.open(filePath, "r")
    if not file then
        return nil, "Unable to open file"
    end

    local doc = {}
    local inDoc = false

    for line in file:lines() do
        -- Skip empty lines or lines with only spaces
        if line:match("^%s*$") then
            if inDoc then
                table.insert(doc, line)
            end
        elseif line:match("^%-%-%-") then
            -- If we encounter a line starting with "---", start capturing doc
            print(":/")
            inDoc = true
            table.insert(doc, line:sub(5))  -- Remove "--- " from the beginning
        elseif inDoc then
            -- If we are capturing doc and encounter a non-doc line, stop
            if not line:match("^%-%-%-") then
                inDoc = false
                break
            end
            table.insert(doc, line:sub(5))  -- Remove "--- " from the beginning
        end
    end

    file:close()

    -- If documentation was not found, return nil
    if #doc == 0 then
        return nil
    end

    -- Create a parsed result with description, parameters, and returns
    local parsed = {
        description = "",
        parameters = {},
        returns = ""
    }

    -- Parse the doc lines
    for _, line in ipairs(doc) do
        line = line:match("^%s*(.-)%s*$")  -- Remove leading/trailing spaces

        if line:match("^Description:") then
            parsed.description = line:sub(12)  -- Remove "Description:" part
        elseif line:match("^Parameters:") then
            local paramPart = line:sub(12)
            local paramLines = {}
            for param in paramPart:gmatch("([^\n]+)") do
                table.insert(paramLines, param)
            end
            for _, param in ipairs(paramLines) do
                table.insert(parsed.parameters, param)
            end
        elseif line:match("^Returns:") then
            parsed.returns = line:sub(9)  -- Remove "Returns:" part
        end
    end

    return parsed
end

print(textutils.serialise(extractDocFromFile("/h/test.hexpattern")))