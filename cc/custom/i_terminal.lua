local test = {}

function test.write(text)
    print("Function not implemented")
end

function test.scroll(y)
    print("Function not implemented")
end

function test.getCursorPos()
    print("Function not implemented")
    return 0
end

function test.setCursorPos(x, y)
    print("Function not implemented")
end

function test.getCursorBlink()
    print("Function not implemented")
    return false
end

function test.setCursorBlink(blink)
    print("Function not implemented")
end

function test.getSize()
    print("Function not implemented")
    return 0, 0
end

function test.clear()
    print("Function not implemented")
end

function test.clearLine()
    print("Function not implemented")
end

function test.getTextColour()
    return test.getTextColor()
end

function test.getTextColor()
    print("Function not implemented")
    return 0
end

function test.setTextColour(colour)
    test.setTextColor(colour)
end

function test.setTextColor(colour)
    print("Function not implemented")
end

function test.getBackgroundColour()
    return test.getBackgroundColor()
end

function test.getBackgroundColor()
    print("Function not implemented")
    return 0
end

function test.setBackgroundColour(colour)
    test.setBackgroundColor(colour)
end

function test.setBackgroundColor(colour)
    print("Function not implemented")
end

function test.isColour()
    return test.isColor()
end

function test.isColor()
    print("Function not implemented")
    return false
end

function test.blit(text, textColour, backgroundColour)
    print("Function not implemented")
end

function test.setPaletteColour(index, r, g, b)
    test.setPaletteColor(index, r, g, b)
end

function test.setPaletteColor(index, r, g, b)
    print("Function not implemented")
end

function test.getPaletteColour(colour)
    return test.getPaletteColor(colour)
end

function test.getPaletteColor(colour)
    return 0, 0, 0
end


return test