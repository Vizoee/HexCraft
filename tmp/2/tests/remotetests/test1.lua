-- local co = coroutine.create(function()
--     while true do
--         print("Got:", os.pullEvent("key"))
--     end
-- end)


local co = coroutine.create(function()
    (shell.execute or shell.run)("ls")
end)

-- A simple event loop that resumes the coroutine with events
while true do
    local event = {os.pullEvent()}
    -- print(textutils.serialize(event))
    -- coroutine.resume(co, table.unpack(event))
    coroutine.resume(co, table.unpack({"key","65"}))
    coroutine.resume(co, table.unpack({"char","a"}))
    coroutine.resume(co, table.unpack({"key_up","65"}))
end