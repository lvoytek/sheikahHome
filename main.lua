function love.load()
    love.window.setTitle("Home")
    love.window.setFullscreen(true)

    local Rune = require("rune")
    Rune:load()

    rune = Rune.new()
    rune:select()
end

function love.update(dt)
    rune:update(dt)
end

function love.draw()
    rune:draw(100, 100)
end