local AppManager = require("app_manager")
local ConfigManager = require("config_manager")

local runes
local availableApps
local backgroundImage

function love.load()
    love.window.setFullscreen(true)

    backgroundImage = love.graphics.newImage("img/background.png")

    local RuneManager = require("rune_manager")
    RuneManager:load()

    runes = RuneManager:new()

    local appManager = AppManager:new()
    availableApps = appManager:getAllApps()

    -- Loading rune layout from config file
    local configManager = ConfigManager:new()
    configuredApps = configManager:getApplications()

    for i=1, configManager:getRunes() do
        if i > #configuredApps then
            runes:addRune()
        else
            appExists = false
            for j=1, #availableApps do
                if availableApps[j]:getAppID() == configuredApps[i] then
                    runes:addRune(availableApps[j])
                    appExists = true
                    break
                end
            end
            if not appExists then
                runes:addRune()
            end
        end
    end

    -- Saving rune layout to config file
    configManager:setApplicationsAndRunes(
        runes:exportAppIDs(),
        runes:getRuneCount()
    )
end

function love.mousemoved(x, y, dx, dy, istouch)
    runes:checkMouseOverRune(x, y)
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        runes:clickRune(x, y)
    elseif button == 2 then
        runes:configureRune(x, y)
    end
end

function love.update(dt)
    runes:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(backgroundImage, 0, 0, 0, love.graphics.getWidth() / backgroundImage:getWidth(), love.graphics.getHeight() / backgroundImage:getHeight())

    runes:draw()
end
