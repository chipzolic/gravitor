local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local clickjournal = GGData:new("clickjournal.txt")
clickjournal.status = 'yes'
clickjournal:save()

function to_upload(event)
	composer.gotoScene( "upload_screen", {effect = "slideLeft", time = "1200"});
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
	background.alpha = 0.05
	background:scale(0.1, 0.1)
	--background:setFillColor( .5 )

		----------- Title of your Infomorph ----------
		local morp_title = display.newText( "Your Generated Infomorph", 50, 50, "zcool.ttf", 18 )
		morp_title:setFillColor( 250, 250, 250 )
		morp_title.x = 235
		morp_title.y = 55
		morp_title.alpha = 1
		sceneGroup:insert( morp_title )

		--- Your generated infomorph
		local infomorph1 = display.newImage("entireGroup.png", system.DocumentsDirectory)
		infomorph1.x = 225
		infomorph1.y = 175
		infomorph1.alpha = 1
		infomorph1:scale(0.17, 0.17)
		sceneGroup:insert( infomorph1 )


	sceneGroup:insert( background )


		-------------------------------------------------------------------------------------
		local confirm = display.newImage("assets/confirm.png")

		function confirmation(event)

			audio.play(click)

			to_upload()

		end

			---------------------------- Confirmation button ------------------------------------
			--local confirm = display.newImage("assets/confirm.png")
			confirm.x = 485
			confirm.y = 285
			confirm.alpha = 1;
			confirm:scale(0.012, 0.012)
			confirm:addEventListener("tap", confirmation);
			sceneGroup:insert( confirm )
			-------------------------------------------------------------------------------------

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

	local wallT = display.newRect( mainGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
	wallT.myName = "Top Wall"
	wallT.anchorY = 1
	physics.addBody( wallT, "static", { bounce=0.1, friction=0.1 } )

	local wallB = display.newRect( mainGroup, display.contentCenterX, 340+letterboxHeight, display.actualContentWidth, 20 )
	wallB.myName = "Bottom Wall"
	wallB.anchorY = 0
	physics.addBody( wallB, "static", { bounce=0.1, friction=0.1 } )

	----------------------------------------------------------------

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
		-- Called when the scene is now off screen
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
---------------------------------------------------------------------------------

return scene