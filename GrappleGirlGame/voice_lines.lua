require("love")
require("Music")

VOICE_TYPES = {
    OOF = {'oof1.mp3','oof2.mp3', 'oof3.mp3'},
    DEATH = {'death.mp3'},
    BIG_DROP = {'bigdrop1.mp3', 'bigdrop2.mp3'},
    CONGRATULATIONS = {'congratulations1.mp3'},
    GO = {'go1.mp3', 'go2.mp3'},
    GRAPPLE_AWAY = {'grappleaway1.mp3', 'grappleaway2.mp3'},
    HURRY = {'hurry.mp3', 'hurry2.mp3'},
    MISSION_COMPLETE = {'missioncompleted1.mp3', 'missioncompleted2.mp3'},
    MISSION_FAILED = {'missionedfailed1.mp3', 'missionfailed2.mp3'},
    OW = {'ow1.mp3', 'ow2.mp3', 'ow3.mpw'},
    READY_SET_GO = {'rsg1.mp3', 'rsg2.mp3', 'rsg3.mp3'},
    SWING = {'swing1.mp3', 'swing2.mp3'},
    THINK_CAN_MAKE = {'thinkcanmake1.mp3', 'thinkcanmake2.mp3'},
    THUNK = {'thunk1.mp3', 'thunk2.mp3', 'thunk3.mp3'},
    VOOSH = {'voosh1.mp3', 'voosh2.mp3'}
};

math.randomseed(os.time())
--[[
    To Call a specific voice line use queueVoiceLines(VOICE_TYPES.OOF, "stream")
]]--
function queueVoiceLines(voice_line, audio_type)

    local line = voice_line[math.random(0, #voice_line)]
    line = "audio/grapplegirl_voicelines/" + line
    love.audio.play(line, audio_type, false)
    
end
