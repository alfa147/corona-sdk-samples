--
-- Abstract: Animated sprite, or "movieclip", sample app
--
-- Date: September 10, 2010
--
-- Version: 2.2
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Demonstrates: graphics, object touch, moviewclip
-- (Also demonstrates the use of external libraries.)
-- For more advanced texture memory handling, see the "sprite sheet" feature in Corona Game Edition.
-- 
-- File dependencies: movieclip.lua
--
-- Target devices: Simulator and devices
--
-- Limitations: none
--
-- Update History:
--	v2.2	Changed to use new audio API (Android currently supports .wav only)
--	v2.1	Added sound support for Android (mp3 file)
--
-- Comments: 
-- Demonstrates how to use the external "movieclip.lua" library to add animated
-- sprites to your application. Also uses an external button library from
-- "ui.lua". These library files are included with this sample application
-- directory and should be placed in your project directory with "main.lua".
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- load external libraries (should be in the same folder as main.lua)
local ui = require("ui")
local movieclip = require("movieclip")

-- Preload the sound file 
local bombSound = audio.loadSound ("bomb_wav.wav")

function main()

	display.setStatusBar( display.HiddenStatusBar )

	-- Create groups to hold assets
	background = display.newGroup()
	foreground = display.newGroup()

	-- Load background image
	local stars = display.newImage("space.jpg")
	background:insert( stars, true ); stars.x = 160; stars.y = 240
	

	---------------------------------------------
	-- Create animated sprites (aka "movieclips")

	-- Initialize first cube anim	
	myAnim = movieclip.newAnim{"cube1.png", "cube2.png", "cube3.png", "cube4.png", "cube5.png", "cube6.png"}
	foreground:insert( myAnim )

	-- Add some frame labels (optional)
	myAnim:setLabels{foo=1, bar=3}

	myAnim.x = 150
	myAnim.y = 250


	-- Initialize a second cube anim (this time by creating the image table dynamically)	
	imageTable = {}
	for i = 1,6 do
		table.insert( imageTable, "cube" .. i .. ".png" )
	end
	for i = 1,9 do
		table.insert( imageTable, "explode" .. i .. ".png" )
	end
	
	myAnim2 = movieclip.newAnim( imageTable )
	foreground:insert( myAnim2 )

	myAnim2.x = 160
	myAnim2.y = 345
	
	
	-- Start the animations
	myAnim:play() -- play all frames
	myAnim2:reverse{ startFrame=6, endFrame=1, loop=0 } -- play specified sequence only
	
	
	local function pressFunction()
		myAnim2.alpha = 0.7
	end
	
	local function releaseFunction()
		myAnim2.alpha = 1.0
	end
	
	-- Make 2nd sprite draggable
	myAnim2:setDrag{ 
		drag=true,
		onPress=pressFunction, 
		onRelease=releaseFunction,
		bounds = { 50, 200, 220, 200 }
	}

	-------------------------------------------------------------------------
	-- FOR DEMO: 
	
	-- Function to bounce first cube around screen with simple Newtonian motion
	local dx = 4
	local dy = -8
	local grav = 0.2
	
	local function moveSprite()
		myAnim.x = myAnim.x + dx
		myAnim.y = myAnim.y + dy
		
		if ((myAnim.x < 20) or (myAnim.x > 300)) then
			dx = -dx
		end
		
		if ((myAnim.y < 20) or (myAnim.y > 460)) then
			dy = - dy - grav
		end
		
		dy = dy + grav
		
	end

	-- Start first cube bouncing
	Runtime:addEventListener( "enterFrame", moveSprite )


	-- Store button actions in lookup table, for convenience
	local actions = 
	{
		["button1"] = function() myAnim:play() end,
		["button2"] = function() myAnim:reverse() end,
		["button3"] = function() myAnim:stopAtFrame(4) end,
		["button4"] = function() myAnim:stopAtFrame("foo") end,
		
	}
	
	-- Store additional action for explosion
	actions["button5"] = function() 
		myAnim2:play{ startFrame=7, endFrame=15, loop=1, remove=true } 
		if ( myAnim2 and bombSound ) then
			audio.play( bombSound )
			bombSound = nil
		end
	end
		
	-- General function for all buttons (uses "actions" table above)
	local buttonHandler = function( event )
		if ( "press" == event.phase ) then
			actions[ event.id ]()
		end
	end
	
	
	-- Create buttons
	local button1 = ui.newButton{
		default = "shortButton.png",
		over = "shortButtonOver.png",
		onEvent = buttonHandler,
		id = "button1",
		text = "play()",
		size = 18,
		emboss = true,
		x = 80, 
		y = 80
	}
	background:insert( button1 )
	
	local button2 = ui.newButton{
		default = "shortButton.png",
		over = "shortButtonOver.png",
		onEvent = buttonHandler,
		id = "button2",
		text = "reverse()",
		size = 18,
		emboss = true,
		x = 240, 
		y = 80
	}
	background:insert( button2 )
	
	local button3 = ui.newButton{
		default = "shortButton.png",
		over = "shortButtonOver.png",
		onEvent = buttonHandler,
		id = "button3",
		text = "stopAtFrame(4)",
		size = 14,
		emboss = true,
		x = 80, 
		y = 130
	}
	background:insert( button3 )
	
	local button4 = ui.newButton{
		default = "shortButton.png",
		over = "shortButtonOver.png",
		onEvent = buttonHandler,
		id = "button4",
		text = "stopAtFrame(\"foo\")",
		size = 14,
		emboss = true,
		x = 240, 
		y = 130
	}
	background:insert( button4 )
	
	local button5 = ui.newButton{
		default = "shortButton.png",
		over = "shortButtonOver.png",
		onEvent = buttonHandler,
		id = "button5",
		text = "Explode!",
		size = 18,
		emboss = true,
		x = 160, 
		y = 440
	}
	background:insert( button5 )
	
	local t = ui.newLabel{
		bounds = { 120, 380, 120, 40 },
		text = "(Drag me)",
		font = system.defaultFontBold,
		textColor = { 255, 255, 255, 165 },
		size = 17,
		align = "left"
	}
	background:insert( t )

end

-- Start program!
main()
