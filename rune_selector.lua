local RuneSelector = {}
RuneSelector.__index = RuneSelector

local menuBorder

-- "static" function to load images initially
function RuneSelector:load()
    menuBorder = {
        love.graphics.newImage("img/menu_border_1.png"),
        love.graphics.newImage("img/menu_border_2.png"),
        love.graphics.newImage("img/menu_border_3.png"),
        love.graphics.newImage("img/menu_border_4.png"),
    }
end

-- Create a new menu for selecting a new rune application
function RuneSelector:new(runeManager, x, y, width, height, cornerOffset)
    local self = setmetatable({}, RuneSelector)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 800
    self.height = height or 600
    self.offset = cornerOffset or self.width / 50
    self.canvas = love.graphics.newCanvas(self.width, self.width)
    return self
end

-- Check if the mouse is currently over the menu
function RuneSelector:checkMouseOverMenu(x, y)
    return x >= self.x and x <= self.x + self.width and
           y >= self.y and y <= self.y + self.height
end

-- Draw the menu and app list on its own canvas
function RuneSelector:draw()

    -- Draw the background and menu border, filling the canvas
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height, self.offset)

    love.graphics.setColor(1, 1, 1)

    -- Draw menu corner decorations
    love.graphics.draw(menuBorder[1], self.offset, self.offset)
    love.graphics.draw(menuBorder[2], self.width - menuBorder[2]:getWidth() - self.offset, self.offset)
    love.graphics.draw(menuBorder[3], self.offset, self.height - menuBorder[3]:getHeight() - self.offset)
    love.graphics.draw(menuBorder[4], self.width - menuBorder[4]:getWidth() - self.offset, self.height - menuBorder[4]:getHeight() - self.offset)

    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

return RuneSelector