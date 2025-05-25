local application_connector = require("gio_application_connector")

local runes
local available_apps

function love.load()
    love.window.setTitle("Home")
    love.window.setFullscreen(true)

    local RuneManager = require("rune_manager")
    runes = RuneManager:new()

    available_apps = application_connector.get_all_applications()
    runes:addRune(available_apps[1])
    runes:addRune(available_apps[6])
    runes:addRune(available_apps[17])
end

function love.mousemoved(x, y, dx, dy, istouch)
    runes:CheckMouseOverRune(x, y)
end

function love.update(dt)
    runes:update(dt)
end

function love.draw()
    runes:draw()
end