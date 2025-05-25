local Rune = require("rune")
Rune:load()

local RuneManager = {}
RuneManager.__index = RuneManager

-- Create a new RuneManager instance
function RuneManager:new(runeWidth, margin)
    local self = setmetatable({}, RuneManager)
    self.runes = {}
    self.selectedRune = nil
    self.runeWidth = runeWidth or 256
    self.margin = margin or 25
    return self
end

-- Add a new Rune to the manager
function RuneManager:addRune(app)
    table.insert(self.runes, Rune:new(app, self.runeWidth))
end

-- Remove a Rune from the manager
function RuneManager:removeRune(rune)
    for i, r in ipairs(self.runes) do
        if r == rune then
            table.remove(self.runes, i)
            return true
        end
    end
    return false
end

-- Get all runes
function RuneManager:getRunes()
    return self.runes
end

-- Get the X position of a rune based on its index
function RuneManager:getRuneX(index)
    if index < 1 or index > #self.runes then
        return nil
    end
    return (index - 1) * (self.runeWidth + self.margin) + love.graphics.getWidth() / 2 - (#self.runes * (self.runeWidth + self.margin)) / 2
end

-- Select a rune by its index, deselecting any previously selected rune
function RuneManager:selectRune(index)
    if self.selectedRune == index then
        return
    end

    for i, rune in ipairs(self.runes) do
        if i == index then
            rune:select()
        else
            rune:deselect()
        end
    end

    self.selectedRune = index
end

-- Deselect all runes
function RuneManager:deselectAllRunes()
    if not self.selectedRune then
        return
    end

    for _, rune in ipairs(self.runes) do
        rune:deselect()
    end

    self.selectedRune = nil
end

-- Check if the mouse is over a rune and select it if so
function RuneManager:CheckMouseOverRune(x, y)
    for i, rune in ipairs(self.runes) do
        local runeX = self:getRuneX(i)
        if x >= runeX and x <= runeX + self.runeWidth and
           y >= love.graphics.getHeight() / 2 - self.runeWidth / 2 and
           y <= love.graphics.getHeight() / 2 + self.runeWidth / 2 then
            self:selectRune(i)
            return i
        end
    end
    self:deselectAllRunes()
    return nil
end

-- Run the update function for each rune
function RuneManager:update(dt)
    for _, rune in ipairs(self.runes) do
        rune:update(dt)
    end
end

-- Draw all runes
function RuneManager:draw()
    for i, rune in ipairs(self.runes) do
        rune:draw(self:getRuneX(i), love.graphics.getHeight() / 2 - self.runeWidth / 2)
    end
end

return RuneManager