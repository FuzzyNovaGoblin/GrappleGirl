
    -- will hold the currently playing sources


function playAudio(audio, audio_type, loop)
    local src = audio
    if type(audio) ~= "userdata" or not audio:typeOf("Source") then
        src = love.audio.newSource(audio, audio_type)
        src:setLooping(loop or false)
    end
    print(type(audio) )

    love.audio.play(src)
    return src
end


    -- stops a source
function stopAudio(src)
    if not src then return end
    love.audio.stop(src)
end
