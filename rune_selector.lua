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
function RuneSelector:new(runeManager, x, y, width, height, cornerOffset, animationCycleDistance, animationCycleTime)
    local self = setmetatable({}, RuneSelector)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 800
    self.height = height or 600
    self.baseOffset = cornerOffset or self.width / 50
    self.animationOffset = 0
    self.currentOffset = 0
    self.animationCycleDistance = animationCycleDistance or self.baseOffset / 2
    self.animationCycleTime = animationCycleTime or .4
    self.canvas = love.graphics.newCanvas(self.width, self.width)
    return self
end

-- Check if the mouse is currently over the menu
function RuneSelector:checkMouseOverMenu(x, y)
    return x >= self.x and x <= self.x + self.width and
           y >= self.y and y <= self.y + self.height
end

-- Update offset such that the border oscillates animationCycleDistance/2 pixels each way
function RuneSelector:update(dt)
    self.animationOffset = (self.animationOffset + self.animationCycleDistance * dt / self.animationCycleTime) % self.animationCycleDistance

    if self.animationOffset > self.animationCycleDistance / 2 then
        self.currentOffset = self.baseOffset + self.animationCycleDistance - self.animationOffset
    else
        self.currentOffset = self.baseOffset + self.animationOffset
    end
end

-- Draw the menu and app list on its own canvas
function RuneSelector:draw()

    -- Draw the background and menu border, filling the canvas
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height, self.baseOffset)

    love.graphics.setColor(1, 1, 1)

    -- Draw menu corner decorations
    love.graphics.draw(menuBorder[1], self.currentOffset, self.currentOffset)
    love.graphics.draw(menuBorder[2], self.width - menuBorder[2]:getWidth() - self.currentOffset, self.currentOffset)
    love.graphics.draw(menuBorder[3], self.currentOffset, self.height - menuBorder[3]:getHeight() - self.currentOffset)
    love.graphics.draw(menuBorder[4], self.width - menuBorder[4]:getWidth() - self.currentOffset, self.height - menuBorder[4]:getHeight() - self.currentOffset)

    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

return RuneSelector