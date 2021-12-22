local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local clickjournal = GGData:new("clickjournal.txt")
clickjournal.status = 'yes'
clickjournal:save()

function home(event)
	composer.gotoScene( "menu", {effect = "slideLeft", time = "1500"});
end

--------------------------------------------
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )

	local sceneGroup = self.view

	physics.start()
	physics.setGravity( 0.1, 0.1 )

	-- local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	local background = display.newImage( "assets/bgpro.jpg" )
	background.x = 150
	background.y = 200
	background.alpha = 0.3
	background:scale(0.1, 0.1)
	sceneGroup:insert( background )
	--background:setFillColor( .5 )

		----------- Title of your Infomorph ----------
		local morp_title = display.newText( "Infomorph Uploaded Successfully.", 50, 50, "zcool.ttf", 24 )
		morp_title:setFillColor( 250, 250, 250 )
		morp_title.x = 235
		morp_title.y = 145
		morp_title.alpha = 1
		sceneGroup:insert( morp_title )

		local subtext = display.newText( "Refresh browser to generate a fresh Infomorph.", 50, 50, "zcool.ttf", 14 )
		subtext:setFillColor( 250, 250, 250 )
		subtext.x = 235
		subtext.y = 215
		subtext.alpha = 1
		sceneGroup:insert( subtext )

		--[[
			---------------------------- Confirmation button ------------------------------------
			local confirm = display.newImage("assets/confirm.png")
			confirm.x = 235
			confirm.y = 285
			confirm.alpha = 1;
			confirm:scale(0.012, 0.012)
			confirm:addEventListener("tap", home);
			sceneGroup:insert( confirm )
			-------------------------------------------------------------------------------------
			--]]

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then


	local letterboxWidth = math.abs(display.screenOriginX)
	local letterboxHeight = math.abs(display.screenOriginY)

	local mainGroup = display.newGroup()
	math.randomseed( os.time() )


	-- Create "walls" around screen
	local wallL = display.newRect( mainGroup, 0-letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
	wallL.myName = "Left Wall"
	wallL.anchorX = 1
	physics.addBody( wallL, "static", { bounce=0.1, friction=0.1 } ) --- Bounce was originally 1, for all four walls.

	local wallR = display.newRect( mainGroup, 485+letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
	wallR.myName = "Right Wall"
	wallR.anchorX = 0
	physics.addBody( wallR, "static", { bounce=0.1, friction=0.1 } )

	--- Gotta test this top wall, is it in the right place? other walls are OK.
	local wallT = display.newRect( mainGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
	wallT.myName = "Top Wall"
	wallT.anchorY = 1
	physics.addBody( wallT, "static", { bounce=0.1, friction=0.1 } )

	local wallB = display.newRect( mainGroup, display.contentCenterX, 340+letterboxHeight, display.actualContentWidth, 20 )
	wallB.myName = "Bottom Wall"
	wallB.anchorY = 0
	physics.addBody( wallB, "static", { bounce=0.1, friction=0.1 } )



		------------------------------------------- MOUSE FUNCTION PURE ---------------------------------------------
			-- Called when a mouse event has been received.
			local function onMouseEvent( event )

				local clickjournal = GGData:new("clickjournal.txt")

				if event.type == "down" --[[and clickjournal.status == 'yes'--]] then
					if event.isPrimaryButtonDown then
	
					elseif event.isSecondaryButtonDown then
						print( "Right mouse button clicked." )        
					end

				end
			end

			-- Add the mouse event listener.
			Runtime:addEventListener( "mouse", onMouseEvent )
		------------------------------------------- MOUSE FUNCTION PURE ---------------------------------------------

		end

end



function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		physics.stop()
	elseif phase == "did" then
	end	
	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene