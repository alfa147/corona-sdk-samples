-- Project: ScreenCaptureToFile
--
-- Date: August 20, 2010
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: Screen Capture JPG saved to /Documents directory
--
-- Demonstrates: audio.play, display.save, tap, detecting device type
--
-- File dependencies: none
--
-- Target devices: Simulator and Device
--
-- Limitations:
--
-- Update History:
--	v1.1	Added app title and message saving JPG saved in /Documents directory
--			Supports Android with MP3 sound file.
-- 	v1.2 	Changed to use new audio API
-- 	v1.3 	Changed to only use .wav
--
-- Comments: Stores the capture screen image as a JPG in the /Documents directory
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------
-- Forward references

local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 128, 0, 0 )

local text = display.newText( "Tap anywhere to capture screen", 0, 0, nil, 16 )
text:setTextColor( 255, 255, 0 )
text.x = 0.5 * display.contentWidth
text.y = 0.5 * display.contentHeight

local soundID = audio.loadSound ("CameraShutter_wav.wav")

-- Create the Screen Capture
--
function bkgd:tap( event )
	audio.play( soundID )

	local baseDir = system.DocumentsDirectory
	display.save( display.currentStage, "entireScreen.jpg", baseDir )

	-- Create thumbnail
	local thumbnail = display.newGroup()

	local image = display.newImage( "entireScreen.jpg", baseDir )
	thumbnail:insert( image, true )
	image:scale( 0.5, 0.5 )

	local r = 10
	local border = display.newRoundedRect( 0, 0, image.contentWidth + 2*r, image.contentHeight + 2*r, r )
	border:setFillColor( 255,255,255,200 )
	thumbnail:insert( 1, border, true )
	thumbnail:translate( 0.5*display.contentWidth, 0.5*display.contentHeight )

	print( "File entireScreen.jpg was saved in the documents directory." )

	text:removeSelf()		-- remove the Tap message from the screen
	
	msg = display.newText( "Screen JPG saved to /Documents", 0, 400, "Verdana-Bold", 14 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,255 )
	
	-- Prevent future taps
	bkgd:removeEventListener( "tap", bkgd )

	return true
end

-- Displays App title
title = display.newText( "Capture Screen to File", 0, 30, "Verdana-Bold", 20 )
title.x = display.contentWidth/2		-- center title
title:setTextColor( 255,255,255 )

-- Create the Tap listener
--
bkgd:addEventListener( "tap", bkgd )
