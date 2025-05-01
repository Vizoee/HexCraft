local git_config_file = ".git/config"

local sha
local owner
local repo

local file_count = 0

local function getApiUrl()
    return "https://api.github.com/repos/"..owner.."/"..repo
end

local function getRawUrl()
    return "https://raw.githubusercontent.com/"..owner.."/"..repo
end

local function request(url)
    return http.get(url)
end

local function initTreeUrl()
    return getApiUrl().."/git/trees/"..sha
end

local function requestFile(dir)
    return request(getRawUrl().."/"..sha.."/"..dir)
end

local function createFile(path)
    local file_content = requestFile(path).readAll()
    local file = fs.open(shell.dir()..path, "w")
    file.write(file_content)
    file.close()
    file_count = file_count + 1
    print("Created "..path)
end

local function traverseTree(url, tree_dir)
    tree_dir = tree_dir or ""
    local response = textutils.unserializeJSON(request(url).readAll())
    for _, value in ipairs(response.tree) do
        local path = tree_dir.."/"..value.path
        if value.type == "blob" then
            createFile(path)
        elseif value.type == "tree" then
            traverseTree(value.url, path)
        end
    end
end

local function copy()
    local config_path = shell.dir().."/"..git_config_file
    local file = fs.open(config_path, "r")
    local config = textutils.unserializeJSON(file.readAll())
    file.close()
    if not config then
        printError("No config file.")
        return
    end
    sha = config.commit_sha
    owner = config.owner
    repo = config.repo

    traverseTree(initTreeUrl(), "")
    print("Downloaded "..file_count.." files.")
end

if debug.getinfo(3) then
    return {copy=copy}
else
    copy()
end

