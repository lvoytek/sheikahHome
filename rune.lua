local Rune = {}
Rune.__index = Rune

local runeBackground
local runeBackgroundSelected
local runeBackgroundEmpty

-- "static" function to load images initially
function Rune:load()
    runeBackground = love.graphics.newImage("img/rune_background.png")
    runeBackgroundSelected = love.graphics.newImage("img/rune_background_selected.png")
    runeBackgroundEmpty = love.graphics.newImage("img/rune_empty.png")
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

function Rune:getAppID()
    if self.app then
        return self.app:getAppID()
    end
    return ""
end

function Rune:getAppName()
    if self.app then
        return self.app:getName()
    end
    return ""
end

function Rune:getAppDescription()
    if self.app then
        return self.app:getDescription()
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
            love.graphics.draw(runeBackgroundEmpty, 0, 0, 0, self.width / runeBackgroundEmpty:getWidth(), self.width / runeBackgroundEmpty:getHeight())
        else
            if self.selected then
                love.graphics.draw(runeBackgroundSelected, 0, 0, 0, self.width / runeBackgroundSelected:getWidth(), self.width / runeBackgroundSelected:getHeight())
            else
                love.graphics.draw(runeBackground, 0, 0, 0, self.width / runeBackground:getWidth(), self.width / runeBackground:getHeight())
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
