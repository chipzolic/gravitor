-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- this is the database module
GGData = require("GGData")

-- include the Corona "composer" module
local composer = require "composer"
_G.click = audio.loadSound("assets/ui.mp3")
_G.pop = audio.loadSound("assets/poppro1.mp3")

-- load menu screen
composer.gotoScene( "menu" )
--composer.gotoScene( "level1" )
--composer.gotoScene( "art_screen" )
--composer.gotoScene( "upload_screen" )
--composer.gotoScene( "thanks" )