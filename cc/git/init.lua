local tArgs = {...}

if #tArgs < 1 then
    print("Usage: "..arg[0].." <repo link>")
    return
end
local repo_url = tArgs[1]
local ok, err = http.checkURL(repo_url)
if not ok then
    printError(err or "Incorrect url link")
    return
end

local config = {}

config.owner, config.repo = tArgs[1]:match("github%.com/([^/]+)/([^/]+)")
config.branch = tArgs[2] or nil

local function ensureTrailingSlash(str)
    return str:match("/$") and str or str .. "/"
end

local function removeTrailingSlash(str)
    return str:match("/$") and str:sub(1, -2) or str
end

local function getApiUrl()
    return "https://api.github.com/repos/"..config.owner.."/"..config.repo
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

local api_url = getApiUrl()

if not config.branch then
    print("Branch not specified. Selecting default branch.")
    config.branch = getDefaultBranch(api_url)
    config.commit_sha = getLatestCommitSha(api_url, config.branch)
else
    config.commit_sha = getLatestCommitSha(api_url, config.branch)
end

print("Please provide token if you have it.")
config.token = read()

local config_file = fs.open(shell.dir().."/.git/config", "w")
config_file.write(textutils.serializeJSON(config))
config_file.close()