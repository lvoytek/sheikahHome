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
function Rune:new()
    local self = setmetatable({}, Rune)
    self.selected = false
    return self
end

-- Mark this Rune as selected
function Rune:select()
    self.selected = true
end

-- Mark this Rune as deselected
function Rune:deselect()
    self.selected = false
end

function Rune:update(dt)
end

-- Draw the rune and its app icon
function Rune:draw(x, y)
    if self.selected then
        love.graphics.draw(rune_background_selected, x, y)
    else
        love.graphics.draw(rune_background, x, y)
    end
end

return Rune