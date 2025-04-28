local keycodes = {
    ["esc"] = 256,
    ["`"] = 96
}
local events = {
    ["key"] = true,
    ["key_up"] = true,
    ["char"] = true
}
KeyboardBlocker_enabled = false
KeyboardBlocker_startKeyPressed = false

local function keyboardBlocker(tEvent)
    if not events[tEvent[1]] then
        return tEvent
    end

    local result = tEvent


    if KeyboardBlocker_startKeyPressed and tEvent[2] == "`" then
        result = nil
    end
    if tEvent[2] == keycodes["`"] then
        if not KeyboardBlocker_enabled and tEvent[1] == "key" then
            KeyboardBlocker_enabled = true
            KeyboardBlocker_startKeyPressed = true
            result = nil
        end
        if KeyboardBlocker_startKeyPressed and tEvent[1] == "key_up" then
            KeyboardBlocker_startKeyPressed = false
            result = nil
        end
    end

    if KeyboardBlocker_enabled and 
            tEvent[1] == "key_up" and 
            tEvent[2] == keycodes["esc"] then
        KeyboardBlocker_enabled = false
        result = nil
    end

    if not KeyboardBlocker_enabled then
        result = nil
    end

    return result
end

return keyboardBlocker