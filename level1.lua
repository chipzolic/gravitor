-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local clickjournal = GGData:new("clickjournal.txt")
clickjournal.status = 'yes'
clickjournal:save()

--------------------------------------------
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


function scene:create( event )

	local sceneGroup = self.view

	physics.start()
	physics.setGravity( 0.1, 0.1 )


	function gravity_changer(event)
		--- First gravity 
		physics.start()
		physics.setGravity( 2.5, -0.5 )

			--- Fifth gravity
			function gravity_five(event)
				physics.start()
				physics.setGravity( 6.0, 0.5)
				timer.performWithDelay( 1000, gravity_changer, 1)
			end

			--- Fourth gravity
			function gravity_four(event)
				physics.start()
				physics.setGravity( -5.5, 1.5 )
				timer.performWithDelay( 2000, gravity_five, 1)
			end

			--- Third gravity
			function gravity_three(event)
				physics.start()
				physics.setGravity( 3.5, -1 )
				timer.performWithDelay( 2000, gravity_four, 1)
			end

			--- Second gravity
			function gravity_two(event)
				physics.start()
				physics.setGravity( 2, 0 )
				timer.performWithDelay( 2000, gravity_three, 1)
			end
	
		timer.performWithDelay( 2000, gravity_two, 1)
	
	end

	gravity_changer()


end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then

	-- local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	local background = display.newImage( "assets/bgpro.jpg" )
	background.x = 150
	background.y = 200
	background.alpha = 0.5
	background:scale(0.1, 0.1)
	--background:setFillColor( .5 )


		local planet1 = display.newImage( "assets/planet1.png" )
		planet1.x = 465
		planet1.y = 165
		planet1.alpha = 1
		planet1:scale(0.3, 0.3)

		local planet2 = display.newImage( "assets/planet2.png" )
		planet2.x = 25
		planet2.y = 100
		--planet2.alpha = 1
		planet2:scale(0.3, 0.3)

		local planet3 = display.newImage( "assets/planet3.png" )
		planet3.x = 245
		planet3.y = 245
		--planet3.alpha = 1
		planet3:scale(0.3, 0.3)


	sceneGroup:insert( background )
	sceneGroup:insert( planet1 )
	sceneGroup:insert( planet2 )
	sceneGroup:insert( planet3 )


		function planet_mover(event)

			function planet_reset(event)
				transition.to( planet1, { time=1800, x=planet1.x, y=planet1.y - 10, onComplete=planet_mover } )
				transition.to( planet2, { time=1800, x=planet2.x, y=planet2.y - 10, } )
				transition.to( planet3, { time=1800, x=planet3.x, y=planet3.y - 10, } )
			end

			transition.to( planet1, { time=1800, x=planet1.x, y=planet1.y + 10, onComplete=planet_reset } )
			transition.to( planet2, { time=1800, x=planet2.x, y=planet2.y + 10 } )
			transition.to( planet3, { time=1800, x=planet3.x, y=planet3.y + 10 } )
		end

		planet_mover()

		--local saadGroup = display.newGroup()

		-------------------------------------------------------------------------------------
		local confirm = display.newImage("assets/confirm.png")

		--- The confirmation button (tick mark) and its attached function, that grabs the generated infomorph art, as a single asset, and saves it in the doc directory.
		function confirmation(event)
			print("Capturing Screen Object!")
			audio.play(click)

			local clickjournal = GGData:new("clickjournal.txt")
			clickjournal.status = 'no'
			clickjournal:save()

			confirm.alpha = 0;
			background.alpha = 0;
			planet1.alpha = 0;
			planet2.alpha = 0;
			planet3.alpha = 0;

				function saver(event)
					display.save( sceneGroup, { filename="entireGroup.png", baseDir=system.DocumentsDirectory, captureOffscreenArea=false, backgroundColor={0,0,0,0} } )
					display.remove( saadGroup )
					confirm.alpha = 1;
					background.alpha = 1;
					planet1.alpha = 1;
					planet2.alpha = 1;
					planet3.alpha = 1;
					composer.gotoScene( "art_screen", {effect = "slideLeft", time = "500"});
				end
	
			timer.performWithDelay( 500, saver )

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



		------------------------------------------- MOUSE FUNCTION PURE ---------------------------------------------
			-- Called when a mouse event has been received.
			local function onMouseEvent( event )

				local clickjournal = GGData:new("clickjournal.txt")

				if event.type == "down" and clickjournal.status == 'yes' then
					if event.isPrimaryButtonDown then
						
						print( "Left mouse button clicked." )
						print(event.x)
						print(event.y)

						audio.play(pop)

						local decider = math.random( 1, 2 )

					--- Generating RECTANGLE ORIENTED shapes on click
					function rect_gen()
						--- Random number generators
						local random1 = math.random( 1, 200 )
						local random2 = math.random( 1, 200 )
						local random3 = math.random( 1, 200 )
						local random4 = math.random( 1, 200 )
						local random5 = math.random( 0.1, 1 )
						local random6 = math.random( 0.1, 1 )
						local random7 = math.random( 0.1, 1 )

						---------------- GENERATING COLORS FOR THE SHAPES ----------------
						paint1 = { (random5), (random6), (random7) }

						local paint2 = {
							type = "gradient",
							color1 = { random5, random6, random7 },
							color2 = { random6, random5, random7, 0.2 },
							direction = "down"
						}

						local paint3 = {
							type = "gradient",
							color1 = { random7, random5, random6 },
							color2 = { random5, random7, random6, 0.2 },
							direction = "up"
						}
						---------------- / END / GENERATING COLORS FOR THE SHAPES ----------------
	
						-- Generating a shape with color from pure code, via mouse click.
						rect1 = display.newRect( event.x, event.y-10, (random3), (random4) ) ---- The four coordinates are: x, y, width & height :)
						rect1.path.x1 = random1
						rect1.path.x2 = random2
						rect1.path.x3 = (('+') .. (random3))
						rect1.path.x4 = random4
						rect1.path.y1 = (('-') .. (random4))
						rect1.path.y2 = random3
						rect1.path.y3 = (('-') .. (random2))
						rect1.path.y4 = random1
						rect1.fill = paint2
						rect1:rotate(random4)
						rect1.isFixedRotation = true
						sceneGroup:insert( rect1 )
						rect1:scale(0.15, 0.15)
						physics.addBody( rect1, "dynamic", { bounce=1, friction=0, radius=20 } )
						rect1:applyLinearImpulse( math.random(1,1.5)/50, 0, rect1.x, rect1.y )
						
						-- Generating a shape with color from pure code, via mouse click.
						local rect2 = display.newRect( event.x, event.y-10, (random3), (random4) ) ---- The four coordinates are: x, y, width & height :)
						local paint1 = { -(random5), -(random6), (random7) }
						rect2.path.x1 = random4
						rect2.path.x2 = random3
						rect2.path.x3 = (('-') .. (random2))
						rect2.path.x4 = random1
						rect2.path.y1 = (('-') .. (random2))
						rect2.path.y2 = random4
						rect2.path.y3 = (('-') .. (random1))
						rect2.path.y4 = -random2
						rect2.fill = paint3
						rect2:rotate(random3)
						rect2:scale(0.08, 0.09)
						sceneGroup:insert( rect2 )
						physics.addBody( rect2, "dynamic", { bounce=1, friction=0, radius=20 } )
						rect2.isFixedRotation = true
						rect2:applyLinearImpulse( math.random(1,1.5)/50, 0, rect1.x, rect1.y )
											
					end

					--- Generating a rounded rectangle shape, this function is also fired every now and then, for variety, the decider control below fires either of the two shape generator functions.
					function roundrect_gen()
						--- Random number generators
						local random1 = math.random( 1, 200 )
						local random2 = math.random( 1, 200 )
						local random3 = math.random( 1, 200 )
						local random4 = math.random( 1, 200 )
						local random5 = math.random( 0.1, 1 )
						local random6 = math.random( 0.1, 1 )
						local random7 = math.random( 0.1, 1 )
	
						-- Generating a shape with color from pure code, via mouse click.
						local myRoundedRect = display.newRoundedRect( event.x, event.y, (random1), (random2), (random3) )
						local paint3 = { (random7), (random5), (random6), 0.7 }
						myRoundedRect.fill = paint3
						myRoundedRect:scale(0.15, 0.15)
						sceneGroup:insert( myRoundedRect )
						physics.addBody( myRoundedRect, "dynamic", { bounce=1, friction=0, radius=20 } )
						myRoundedRect.isFixedRotation = true
						myRoundedRect:applyLinearImpulse( math.random(1,1.5)/50, 0, myRoundedRect.x, myRoundedRect.y )

					end


					if decider == 1 then
						roundrect_gen()
					elseif decider == 2 then
						rect_gen()
					elseif decider == 3 then
						rect_gen()
					else
					end
	
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
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
		--display.remove( sceneGroup )
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view

	display.remove( sceneGroup )
	
	package.loaded[physics] = nil
	physics = nil

	display.remove( sceneGroup )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene