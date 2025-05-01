local git_config_file = ".git/config"

local config

local function getFilename(file)
    return shell.dir().."/"..file
end

local function openFile(path, flag)
    return fs.open(getFilename(path), flag)
end

local function getApiUrl()
    return "https://api.github.com/repos/"..config.owner.."/"..config.repo
end

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
    local readFile = openFile(filename, "r")
    local content = readFile.readAll()
    readFile.close()
    local updatedContent = apply_patch(content, patch)
    local writeFile = openFile(filename, "w")
    writeFile.write(updatedContent)
    writeFile.close()
end

local function request(url)
    if config.token and config.token ~= "" then
        local header = {
            ["Authorization"] = "Bearer " .. config.token,
            ["User-Agent"] = "ComputerCraft"
        }
        return http.get(url, header)
    else
        return http.get(url)
    end
end

local function pull()
    local file = openFile(git_config_file, "r")
    config = textutils.unserializeJSON(file.readAll())
    file.close()
    if not config then
        printError("No config file.")
        return
    end
    local url = getApiUrl()
    local currentCommit = config.commit_sha
    local branch = config.branch

    local request_url = url .. "/compare/" .. currentCommit .. "..." .. branch
    local response = textutils.unserializeJSON(request(request_url).readAll())
    
    if #response.commits < 1 then
        print("No new updates.")
        return
    end

    for _, file in ipairs(response.files) do
        local filename = file.filename
        if file.status == "added" then
            print("Creating  "..filename)
            local f = openFile(filename, "w")
            f.close()
            patch_file(filename, file.patch)
        elseif file.status == "modified" then
            print("Updating  "..filename)
            patch_file(filename, file.patch)
        elseif file.status == "removed" then
            print("Deleting  "..filename)
            fs.delete(getFilename(filename))
        end
    end
    
    config.commit_sha = response.commits[#response.commits].sha

    local file = openFile(git_config_file, "w")
    file.write(textutils.serializeJSON(config))
    file.close()
    print("Updated files: "..#response.files)
end

if debug.getinfo(3) then
    return {pull=pull}
else
    pull()
end