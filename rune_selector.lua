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
function RuneSelector:new(appList, x, y, width, height, appSize, margin, cornerOffset, animationCycleDistance, animationCycleTime)
    local self = setmetatable({}, RuneSelector)
    self.appList = appList or {}

    self.x = x or 0
    self.y = y or 0
    self.width = width or 800
    self.height = height or 600

    self.appSize = appSize or 128
    self.margin = margin or 6

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

    -- Calculate available area inside the border
    local innerX = self.baseOffset + self.margin
    local innerY = self.baseOffset + self.margin
    local innerWidth = self.width - 2 * (self.baseOffset + self.margin)
    local innerHeight = self.height - 2 * (self.baseOffset + self.margin)

    -- Calculate how many icons fit per row and column
    local iconsPerRow = math.floor((innerWidth + self.margin) / (self.appSize + self.margin))
    local iconsPerCol = math.floor((innerHeight + self.margin) / (self.appSize + self.margin))

    local maxIcons = iconsPerRow * iconsPerCol

    for i = 1, math.min(#self.appList, maxIcons) do
        local row = math.floor((i - 1) / iconsPerRow)
        local col = (i - 1) % iconsPerRow

        local iconX = innerX + col * (self.appSize + self.margin)
        local iconY = innerY + row * (self.appSize + self.margin)

        local app = self.appList[i]
        local icon = app:getIcon()
        if icon then
            love.graphics.draw(icon, iconX, iconY, 0, self.appSize / icon:getWidth(), self.appSize / icon:getHeight())
        end
    end

    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x, self.y)
end

return RuneSelector