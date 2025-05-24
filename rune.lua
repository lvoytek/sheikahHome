local Rune = {}
Rune.__index = Rune

local rune_background
local rune_background_selected

-- "static" function to load images initially
function Rune:load()
    rune_background = love.graphics.newImage("img/rune_background.png")
    rune_background_selected = love.graphics.newImage("img/rune_background_selected.png")
end

-- Create a new Rune instance
function Rune:new(width)
    local self = setmetatable({}, Rune)
    self.selected = false
    self.width = width or 256
    self.canvas = love.graphics.newCanvas(self.width, self.width)
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

function Rune:update(dt)
end

-- Draw the rune and its app icon
function Rune:draw(x, y)
    if self.needsUpdate then
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        if self.selected then
            love.graphics.draw(rune_background_selected, 0, 0, 0, self.width / rune_background_selected:getWidth(), self.width / rune_background_selected:getHeight())
        else
            love.graphics.draw(rune_background, 0, 0, 0, self.width / rune_background:getWidth(), self.width / rune_background:getHeight())
        end

        self.needsUpdate = false
        love.graphics.setCanvas()
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, x, y)
end

return Rune