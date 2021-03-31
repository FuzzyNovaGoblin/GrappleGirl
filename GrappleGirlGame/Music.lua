
    -- will hold the currently playing sources

    -- overwrite love.audio.play to create and register source if needed
local play = love.audio.play
function love.audio.play(audio, audio_type, loop)
    local src = audio
    if type(audio) ~= "userdata" or not audio:typeOf("Source") then
        src = love.audio.newSource(audio, audio_type)
        src:setLooping(loop or false)
    end

    play(src)
    return src
end

    -- stops a source
local stop = love.audio.stop
function love.audio.stop(src)
    if not src then return end
    stop(src)
end
