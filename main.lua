local AppManager = require("app_manager")

local runes
local available_apps
local background_image

function love.load()
    love.window.setFullscreen(true)

    background_image = love.graphics.newImage("img/background.png")

    local RuneManager = require("rune_manager")
    RuneManager:load()

    runes = RuneManager:new()

    local appManager = AppManager:new()
    availableApps = appManager:getAllApps()
    runes:addRune(availableApps[1])
    runes:addRune(availableApps[6])
    runes:addRune(availableApps[17])

    for i=1, 5 do
        runes:addRune()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    runes:CheckMouseOverRune(x, y)
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        runes:ClickRune(x, y)
    end
end

function love.update(dt)
    runes:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(background_image, 0, 0, 0, love.graphics.getWidth() / background_image:getWidth(), love.graphics.getHeight() / background_image:getHeight())

    runes:draw()
end
