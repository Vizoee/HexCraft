

-- local original = [[
-- line 1
-- line 2
-- line 3
-- line 4
-- ]]

local patch = [[
@@ -2,2 +2,3 @@
 line 2
+inserted line
 line 3
@@ -5,3 +5,2 @@
 line 4
-line 5
 line 6
]]

local gitResponseJson
local gitLastCommit


local function apply_patch(original_text, patch_text)
    -- Split the original text into lines
    local lines = {}
    for line in original_text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    local patch_lines = {}
  
    -- Split the patch text into lines
    for line in patch_text:gmatch("[^\r\n]+") do
        table.insert(patch_lines, line)
    end
  
    local i = 1
    while i <= #patch_lines do
        local line = patch_lines[i]
        -- Match the hunk header (e.g., @@ -2,2 +2,3 @@)
        local hunk_start = line:match("^@@%s%-(%d+),?%d*%s+%+(%d+),?%d*%s@@")
        if hunk_start then
            local src_idx = tonumber(hunk_start)
            local out = {}
            i = i + 1
    
            -- Adjust the index since Lua is 1-based
            src_idx = src_idx - 1
    
            -- Copy lines from the original up to the hunk start
            for j = 1, src_idx do
            table.insert(out, lines[j])
            end
    
            -- Apply the patch (handling lines that are added, modified, or removed)
            while i <= #patch_lines and not patch_lines[i]:match("^@@") do
            local l = patch_lines[i]
            local prefix, content = l:sub(1, 1), l:sub(2)
            if prefix == ' ' then
                table.insert(out, content)  -- No change: add the line
                src_idx = src_idx + 1
            elseif prefix == '-' then
                src_idx = src_idx + 1  -- Skip this line in the original
            elseif prefix == '+' then
                table.insert(out, content)  -- Add this new line
            end
            i = i + 1
            end

            -- Add any remaining lines from the original text
            for j = src_idx + 1, #lines do
            table.insert(out, lines[j])
            end

            -- Update the result with the patched lines
            lines = out
        else
            i = i + 1
        end
    end
  
    -- Join the lines back into a single string
    return table.concat(lines, "\n")
  end

local function patch_file(filename, patch)
    local readFile = fs.open(filename, "r")
    local content = readFile.readAll()
    readFile.close()
    local updatedContent = apply_patch(content, patch)
    local writeFile = fs.open(filename, "w")
    writeFile.write(updatedContent)
    writeFile.close()
end

local function request(url)
    return http.get(url)
end

local function pull()
    local file = fs.open("/.config/git/HexAkasha.git", "r")
    local config = textutils.unserializeJSON(file.readAll())
    file.close()
    if config then
        print("No config file.")
        return
    end
    local url = config.url
    local currentCommit = config.commit
    local branch = config.branch

    local request_url = url .. "/compare/" .. currentCommit .. "..." .. branch
    local response = textutils.unserializeJSON(request(request_url).readAll())

    for _, file in ipairs(response.files) do
        local filename = "/tests/"..file.filename
        if file.status == "added" then
            local f = fs.open(filename, "w")
            f.close()
            patch_file(filename, file.patch)
            goto continue
        end
        if file.status == "modified" then
            patch_file(filename, file.patch)
            goto continue
        end
        if file.status == "deleted" then
            fs.delete(filename)
            goto continue
        end
        ::continue::
    end

    config.commit = response.commits[#response.commits].sha

    local file = fs.open("/.config/git/HexAkasha.git", "w")
    file.write(textutils.serializeJSON(config))
    file.close()
end

pull()