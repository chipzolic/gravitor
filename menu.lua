-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	local morp_title1 = display.newText( "Gravity Infomorph Generator", 50, 50, "zcool.ttf", 28 )
	morp_title1:setFillColor( 250, 250, 250 )
	morp_title1.x = 235
	morp_title1.y = 135
	morp_title1.alpha = 1
	sceneGroup:insert( morp_title1 )

	-- local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	local background = display.newImage( "assets/bgpro.jpg" )
	background.x = 150
	background.y = 200
	background.alpha = 0.3
	background:scale(0.1, 0.1)

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label = "Play Now",
		labelColor = { default={ 1.0 }, over={ 0.5 } },
		defaultFile = "button.png",
		overFile = "button-over.png",
		width = 154, height = 40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 125
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( playBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then

	elseif phase == "did" then

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
