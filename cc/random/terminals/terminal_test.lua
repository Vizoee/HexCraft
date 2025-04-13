local test = {}

local xCursor = 1
local yCursor = 1

function test.write(text)
    -- os.queueEvent("customMessage", "Function 'write' not implemented")
    xCursor = #text + 1
    -- os.queueEvent("customMessage", text.." "..tostring(text).."w "..#text.." "..xCursor.." "..yCursor)
    os.queueEvent("customMessage", text)
end

function test.scroll(y)
    os.queueEvent("customMessage", "Function 'scroll' not implemented")
end

function test.getCursorPos()
    -- os.queueEvent("customMessage", "Function 'getCursorPos' not implemented")
    return 1, 1
end

function test.setCursorPos(x, y)
    -- os.queueEvent("customMessage", "Function 'setCursorPos' not implemented")
    xCursor, yCursor = x, y
end

function test.getCursorBlink()
    os.queueEvent("customMessage", "Function 'getCursorBlink' not implemented")
    return false
end

function test.setCursorBlink(blink)
    os.queueEvent("customMessage", "Function 'setCursorBlink' not implemented")
end

function test.getSize()
    -- os.queueEvent("customMessage", "Function 'getSize' not implemented")
    return 100, 100
end

function test.clear()
    os.queueEvent("customMessage", "Function 'clear' not implemented")
end

function test.clearLine()
    os.queueEvent("customMessage", "Function 'clearLine' not implemented")
end

function test.getTextColour()
    return test.getTextColor()
end

function test.getTextColor()
    os.queueEvent("customMessage", "Function 'getTextColor' not implemented")
    return colors.write
end

function test.setTextColour(colour)
    test.setTextColor(colour)
end

function test.setTextColor(colour)
    -- os.queueEvent("customMessage", "Function 'setTextColor' not implemented")
end

function test.getBackgroundColour()
    return test.getBackgroundColor()
end

function test.getBackgroundColor()
    os.queueEvent("customMessage", "Function 'getBackgroundColor' not implemented")
    return colors.black
end

function test.setBackgroundColour(colour)
    test.setBackgroundColor(colour)
end

function test.setBackgroundColor(colour)
    -- os.queueEvent("customMessage", "Function 'setBackgroundColor' not implemented")
end

function test.isColour()
    return test.isColor()
end

function test.isColor()
    -- os.queueEvent("customMessage", "Function 'isColor' not implemented")
    return false
end

function test.blit(text, textColour, backgroundColour)
    -- os.queueEvent("customMessage", "Function 'blit' not implemented")
    os.queueEvent("customMessage", text)
end

function test.setPaletteColour(index, r, g, b)
    test.setPaletteColor(index, r, g, b)
end

function test.setPaletteColor(index, r, g, b)
    os.queueEvent("customMessage", "Function 'setPaletteColor' not implemented")
end

function test.getPaletteColour(colour)
    return test.getPaletteColor(colour)
end

function test.getPaletteColor(colour)
    os.queueEvent("customMessage", "Function 'getPaletteColor' not implemented")
    return 0, 0, 0
end


return test