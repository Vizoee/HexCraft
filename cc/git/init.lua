

local tArgs = {...}

-- TODO: add arg checks

local repo_url = tArgs[1]
local branch = tArgs[2] or nil

local ok, err = http.checkURL(repo_url)
if not ok then
    printError(err or "Incorrect url link")
    return
end

local function ensureTrailingSlash(str)
    return str:match("/$") and str or str .. "/"
end

local function removeTrailingSlash(str)
    return str:match("/$") and str:sub(1, -2) or str
end

local function request(url)
    return http.get(url)
end

local function getDefaultBranch(repo_url)
    local response = textutils.unserializeJSON(request(repo_url).readAll())
    return response.default_branch
end

local function getLatestCommitSha(repo_url, branch)
    local request_url = repo_url .. "/branches/" .. branch
    local response = textutils.unserializeJSON(request(request_url).readAll())
    return response.commit.sha
end

local config = {}

config.url = removeTrailingSlash(repo_url)

if not branch then
    print("Branch not specified. Selecting default branch.")
    config.branch = getDefaultBranch(config.url)
end

config.commit_sha = getLatestCommitSha(config.url, config.branch)
config.token = ""

local config_file = fs.open(".git/config", "w")
config_file.write(textutils.serializeJSON(config))
config_file.close()