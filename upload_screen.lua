local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local clickjournal = GGData:new("clickjournal.txt")
clickjournal.status = 'yes'
clickjournal:save()

function to_thanks(event)
	composer.gotoScene( "thanks", {effect = "slideLeft", time = "1200"});
end

--------------------------------------------
local s3 = require("plugin.s3-lite")
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

		----------- Title of your Infomorph ----------
		local morp_title = display.newText( "Confirm Infomorph Upload", 50, 50, "zcool.ttf", 24 )
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
		infomorph1:scale(0.12, 0.12)
		sceneGroup:insert( infomorph1 )

		-------------------------------------------------------------------------------------
		s3:new({
			key = "AKIAQECFYDNIQSQ7EAIF",
			secret = "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",
			region = s3.US_EAST_2
		})
		
		
		local confirm = display.newImage("assets/confirm.png")

		function upload_go(event)
			audio.play(click)

			---------------------- S3 WORK -------------------------
				local function onListObjects( evt )
					if evt.error then
					print(evt.error, evt.message, evt.status)
					else
					local objects = evt.objects
				
					for i=1, #objects do
						print(objects[i].key, objects[i].size)
					end
					end
				end
				
				s3:listObjects("infomorphbucket", onListObjects)

				-------- UPLOAD OBJECTS --------
				local function onPutObject( evt )
					if evt.error then
					print(evt.error, evt.message, evt.status)
					else
					if evt.progress then
						print(evt.progress)
					else
						print("object upload complete")
					end
					end
				end
				
				s3:putObject(
					system.DocumentsDirectory,
					"entireGroup.png",
					"infomorphbucket",
					"entireGroup.png",
					onPutObject
				)

		timer.performWithDelay( 2500, to_thanks )

	end

			---------------------------- Confirmation button ------------------------------------
			--local confirm = display.newImage("assets/confirm.png")
			confirm.x = 235
			confirm.y = 285
			confirm.alpha = 1;
			confirm:scale(0.012, 0.012)
			confirm:addEventListener("tap", upload_go);
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


	  -------- DOWNLOAD OBJECTS FROM S3 BUCKET, THIS IS THE FUNCTION, IT WORKS, TESTED, COMMENTED OUT FOR NOW. ---------
	  --[[
	  local function onGetObject( evt )
		if evt.error then
		  print(evt.error, evt.message, evt.status)
		else
		  if evt.progress then
			print(evt.progress)
		  else
			print("object download complete")
		  end
		end
	  end
	  
	  s3:getObject(
		"infomorphbucket", 
		"downloaded_file.png", 
		system.DocumentsDirectory,
		onGetObject
	  )
	  --]]
	--------------------------------------------------------

	------------------------------------------- MOUSE FUNCTION PURE ---------------------------------------------
			-- Called when a mouse event has been received.
			local function onMouseEvent( event )

				local clickjournal = GGData:new("clickjournal.txt")

				if event.type == "down" --[[and clickjournal.status == 'yes'--]] then
					if event.isPrimaryButtonDown then
						print( "Left mouse button clicked." )

						print(event.x)
						print(event.y)
	
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
----------------------------------------------------------------------------------

return scene