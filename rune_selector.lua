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
function RuneSelector:new(runeManager, x, y, width, height)
    local self = setmetatable({}, RuneSelector)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 800
    self.height = height or 600
    self.canvas = love.graphics.newCanvas(self.width, self.width)
    return self
end

-- Draw the menu and app list on its own canvas
function RuneSelector:draw()

    -- Draw the background and menu border, filling the canvas
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height, self.width / 50)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(menuBorder[1], 0, 0)
    love.graphics.draw(menuBorder[2], self.width - menuBorder[2]:getWidth(), 0)
    love.graphics.draw(menuBorder[3], 0, self.height - menuBorder[3]:getHeight())
    love.graphics.draw(menuBorder[4], self.width - menuBorder[4]:getWidth(), self.height - menuBorder[4]:getHeight())

    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

return RuneSelector