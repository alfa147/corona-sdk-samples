-- Abstract: Streaming Video sample app
-- 
-- Project: StreamingVideo
--
-- Date: August 19, 2010
--
-- Version: 1.2
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: Displays video from AnscaMobile.com
--
-- Demonstrates: media.playVideo, detection of Corona Simulator
--
-- File dependencies: none
--
-- Target devices: Simulator (results in Console)
--
-- Limitations: Requires internet access
--
-- Update History:
--	v1.2	Detect running in simulator.
--			Added "Tap to start video" message
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


display.setStatusBar( display.HiddenStatusBar )

local posterFrame = display.newImage( "Default.png" )

function posterFrame:tap( event )
	msg.text = "Video Done"		-- message will appear after the video finishes
	media.playVideo( "http://www.anscamobile.com/video/Corona-iPhone.m4v", media.RemoteSource, true )
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Video is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "No Video on Simulator!", 0, 60, "Verdana-Bold", 22 )
else
	msg = display.newText( "Tap to start video", 0, 60, "Verdana-Bold", 22 )
	posterFrame:addEventListener( "tap", posterFrame )		-- add Tap listener
end

msg.x = display.contentWidth/2		-- center title
msg:setTextColor( 0,0,255 )
