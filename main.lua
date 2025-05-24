local runes

function love.load()
    love.window.setTitle("Home")
    love.window.setFullscreen(true)

    local RuneManager = require("rune_manager")
    runes = RuneManager:new()
    runes:addRune()
    runes:addRune()
    runes:addRune()
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