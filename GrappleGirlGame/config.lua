SHORTEN_COIL_KEY = "w"
LENGTHEN_COIL_KEY = "s"
PLAY_MUSIC_KEY = "="
PAUSE_MUSIC_KEY = "+"

CHARACTER_LEFT_KEY = "a"
CHARACTER_RIGHT_KEY = "d"
CHARACTER_JUMP_KEY="space"

ENABLE_MUSIC = true
MUSIC_VOLUME = 0.75


local cfile,err =  loadfile("~/.config/grapplegirl.conf", "txt")

if cfile then
   cfile()
end


CHARACTER_CATEGORY = 2
GRAPPLEPOD_CATEGORY = 3
FLOOR_CATEGORY = 4
BLOCK_CATEGORY = 4

GRAPPLE_COIL_SPEED = 500
BLOCK_WIDTH = 50
BLOCK_HEIGHT = 50
