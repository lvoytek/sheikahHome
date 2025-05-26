local Rune = {}
Rune.__index = Rune

local rune_background
local rune_background_selected
local rune_background_empty

-- "static" function to load images initially
function Rune:load()
    rune_background = love.graphics.newImage("img/rune_background.png")
    rune_background_selected = love.graphics.newImage("img/rune_background_selected.png")
    rune_background_empty = love.graphics.newImage("img/rune_empty.png")
end

-- Create a new Rune instance
function Rune:new(app, width)
    local self = setmetatable({}, Rune)
    self.selected = false
    self.width = width or 256
    self.canvas = love.graphics.newCanvas(self.width, self.width)
    self.app = app or nil

    self.needsUpdate = true
    return self
end

-- Mark this Rune as selected
function Rune:select()
    self.selected = true
    self.needsUpdate = true
end

-- Mark this Rune as deselected
function Rune:deselect()
    self.selected = false
    self.needsUpdate = true

end

function Rune:execute()
    if self.app then
        self.app:execute()
    end

    return false
end

function Rune:getAppName()
    if self.app and self.app.name then
        return self.app.name
    end
    return ""
end

function Rune:update(dt)
end

-- Draw the rune and its app icon
function Rune:draw(x, y)
    if self.needsUpdate then
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        if not self.app then
            love.graphics.draw(rune_background_empty, 0, 0, 0, self.width / rune_background_empty:getWidth(), self.width / rune_background_empty:getHeight())
        else
            if self.selected then
                love.graphics.draw(rune_background_selected, 0, 0, 0, self.width / rune_background_selected:getWidth(), self.width / rune_background_selected:getHeight())
            else
                love.graphics.draw(rune_background, 0, 0, 0, self.width / rune_background:getWidth(), self.width / rune_background:getHeight())
            end

            local icon = self.app:getIcon()
            if icon then
                local iconSize = self.width * 0.75
                local iconX = (self.width - iconSize) / 2
                local iconY = (self.width - iconSize) / 2
                love.graphics.draw(icon, iconX, iconY, 0, iconSize / icon:getWidth(), iconSize / icon:getHeight())
            end
        end

        self.needsUpdate = false
        love.graphics.setCanvas()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, x, y)
end

return Rune
