local test = {}

function test.write(text)
    -- os.queueEvent("customMessage", "Function not implemented")
    os.queueEvent("customMessage", tostring(text).."w")
end

function test.scroll(y)
    os.queueEvent("customMessage", "Function not implemented")
end

function test.getCursorPos()
    os.queueEvent("customMessage", "Function not implemented")
    return 1, 1
end

function test.setCursorPos(x, y)
    os.queueEvent("customMessage", "Function not implemented")
end

function test.getCursorBlink()
    os.queueEvent("customMessage", "Function not implemented")
    return false
end

function test.setCursorBlink(blink)
    os.queueEvent("customMessage", "Function not implemented")
end

function test.getSize()
    os.queueEvent("customMessage", "Function not implemented")
    return 100, 100
end

function test.clear()
    os.queueEvent("customMessage", "Function not implemented")
end

function test.clearLine()
    os.queueEvent("customMessage", "Function not implemented")
end

function test.getTextColour()
    return test.getTextColor()
end

function test.getTextColor()
    os.queueEvent("customMessage", "Function not implemented")
    return 1
end

function test.setTextColour(colour)
    test.setTextColor(colour)
end

function test.setTextColor(colour)
    os.queueEvent("customMessage", "Function not implemented")
end

function test.getBackgroundColour()
    return test.getBackgroundColor()
end

function test.getBackgroundColor()
    os.queueEvent("customMessage", "Function not implemented")
    return colors.black
end

function test.setBackgroundColour(colour)
    test.setBackgroundColor(colour)
end

function test.setBackgroundColor(colour)
    os.queueEvent("customMessage", "Function not implemented")
end

function test.isColour()
    return test.isColor()
end

function test.isColor()
    os.queueEvent("customMessage", "Function not implemented")
    return false
end

function test.blit(text, textColour, backgroundColour)
    -- os.queueEvent("customMessage", "Function not implemented")
    os.queueEvent("customMessage", tostring(text).."b")
end

function test.setPaletteColour(index, r, g, b)
    test.setPaletteColor(index, r, g, b)
end

function test.setPaletteColor(index, r, g, b)
    os.queueEvent("customMessage", "Function not implemented")
end

function test.getPaletteColour(colour)
    return test.getPaletteColor(colour)
end

function test.getPaletteColor(colour)
    return 1, 1, 1
end


return test