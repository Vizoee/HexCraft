local git = require"/git/pull"


while true do
    git.pull()

    sleep(10)
end