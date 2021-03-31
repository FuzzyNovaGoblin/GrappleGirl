require("Character")
require("love")
require("Music")

function love.load()
    gGirl = Character:new(nil);
    music = love.audio.play("audio/music/Dioma.mp3", "stream", true)
    music:setVolume(0.75)
end

function love.update(dt)
    gGirl:update(dt);
end

function love.keypressed(key)
    if key == 'p' then
        -- plays from stopped position
        love.audio.play(music)
    elseif key == 's' then
        -- only pauses audio doesn't reset
        love.audio.stop(music)
    end
end

function love.draw()
    gGirl:draw()
end
