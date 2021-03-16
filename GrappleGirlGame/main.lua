require("Character")
require("love")
require("Music")

function love.load()
    gGirl = Character:new(nil);
    music = love.audio.play("Dioma.mp3", "stream", true)
    music:setVolume(0.75)
end

function love.update(dt)
    love.audio.update()
    gGirl:update(dt);
end

function love.keypressed(key)
    if key == 'p' then
        love.audio.play(music)
    elseif key == 's' then
        love.audio.stop(music)
    end
end

function love.draw()
    gGirl:draw()
end
