local Rune = require("rune")
local RuneSelector = require("rune_selector")
local AppManager = require("app_manager")

local RuneManager = {}
RuneManager.__index = RuneManager

local titleFont
local descriptionFont

-- "static" function to load images and fonts initially
function RuneManager:load()
    Rune:load()
    RuneSelector:load()

    titleFont = love.graphics.newFont("fonts/Roboto-Medium.ttf", 52)
    descriptionFont = love.graphics.newFont("fonts/Roboto-Medium.ttf", 38)
end

-- Create a new RuneManager instance
function RuneManager:new(runeWidth, margin)
    local self = setmetatable({}, RuneManager)
    self.runes = {}
    self.runeSelector = nil
    self.appManager = AppManager:new()
    self.availableApps = self.appManager:getAllApps()

    self.selectedRune = nil
    self.runeWidth = runeWidth or 256
    self.margin = margin or 25
    return self
end

-- Add a new Rune to the manager
function RuneManager:addRune(app)
    table.insert(self.runes, Rune:new(app, self.runeWidth))
end

-- Add a new Rune with the app associated with the provided app id
function RuneManager:addRuneByID(appID)
    appExists = false
    for j=1, #self.availableApps do
        if self.availableApps[j]:getAppID() == appID then
            self:addRune(self.availableApps[j])
            appExists = true
            break
        end
    end
    if not appExists then
        self:addRune()
    end
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

-- Get the number of runes
function RuneManager:getRuneCount()
    return #self.runes
end

-- Export apps as list of app IDs
function RuneManager:exportAppIDs()
    local appIDs = {}
    for _, rune in ipairs(self.runes) do
        local appID = rune:getAppID()
        if appID and appID ~= "" then
            table.insert(appIDs, appID)
        end
    end
    return appIDs
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
function RuneManager:checkMouseOverRune(x, y)
    if self:isConfigureMenuOpen() then
        return nil
    end

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

-- Open the application connected to the selected rune
function RuneManager:clickRune(x, y)
    if self:isConfigureMenuOpen() then
        if not self.runeSelector:checkMouseOverMenu(x, y) then
            self:closeConfigureMenu()
        end
    else
        local runeIndex = self:checkMouseOverRune(x, y)
        if runeIndex then
            success = self.runes[runeIndex]:execute()
            if success then
                print("Application launched")
            end
        end
    end
end

-- Open a list of applications to let the user decide a new app for the selected rune
function RuneManager:configureRune(x, y)
    local runeIndex = self:checkMouseOverRune(x, y)
    if runeIndex then
        self:createConfigureMenu(x, y)
    end
end

-- Create a menu for application selection
function RuneManager:createConfigureMenu(x, y)
    if self.runeSelector then
        return
    end
    self.runeSelector = RuneSelector:new(self.availableApps, x, y)
end

-- Close the application selection menu
function RuneManager:closeConfigureMenu()
    self.runeSelector = nil
end

-- Check if the configuration menu is currently open
function RuneManager:isConfigureMenuOpen()
    return self.runeSelector ~= nil
end

-- Run the update function for each rune
function RuneManager:update(dt)
    if self:isConfigureMenuOpen() then
        self.runeSelector:update(dt)
    else
        for _, rune in ipairs(self.runes) do
            rune:update(dt)
        end
    end
end

-- Draw all runes
function RuneManager:draw()
    if self.selectedRune ~= nil then
        -- Display rune name and description
        local runeName = self.runes[self.selectedRune]:getAppName()
        local runeDescription = self.runes[self.selectedRune]:getAppDescription()
        if runeName ~= "" then
            love.graphics.setColor(0x3C / 255, 0xD3 / 255, 0xFC / 255, 1)
            love.graphics.setFont(titleFont)
            love.graphics.print(runeName, love.graphics.getWidth() / 2 - titleFont:getWidth(runeName) / 2, love.graphics.getHeight() / 3)

            -- Show description if it exists and is different from the name
            if runeDescription ~= "" and runeDescription ~= runeName then
                love.graphics.setFont(descriptionFont)
                love.graphics.print(runeDescription, love.graphics.getWidth() / 2 - descriptionFont:getWidth(runeDescription) / 2, love.graphics.getHeight() * 2 / 3)
            end

            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    for i, rune in ipairs(self.runes) do
        rune:draw(self:getRuneX(i), love.graphics.getHeight() / 2 - self.runeWidth / 2)
    end

    if self.runeSelector then
        self.runeSelector:draw()
    end
end

return RuneManager
