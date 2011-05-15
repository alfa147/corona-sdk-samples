-- 
-- Abstract: Camera sample app
-- 
-- Version: 1.1
-- 
-- Updated: August 9, 2010
--
-- Changes:
-- Fixed logic problem where it said "session was cancelled"
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
                  
-- Camera not supported on Android devices in this build.                    
local isAndroid = "Android" == system.getInfo("platformName")
                                 
if(isAndroid) then
	 local alert = native.showAlert( "Information", "Camera API not yet available on Android devices.", { "OK"})    
end     
--
local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 128, 0, 0 )

local text = display.newText( "Tap anywhere to launch Camera", 0, 0, nil, 16 )
text:setTextColor( 255, 255, 255 )
text.x = 0.5 * display.contentWidth
text.y = 0.5 * display.contentHeight

local sessionComplete = function(event)	
	local image = event.target

	print( "Camera ", ( image and "returned an image" ) or "session was cancelled" )
	print( "event name: " .. event.name )
	print( "target: " .. tostring( image ) )

	if image then
		-- center image on screen
		image.x = display.contentWidth/2
		image.y = display.contentHeight/2
		local w = image.width
		local h = image.height
		print( "w,h = ".. w .."," .. h )
	end
end

local listener = function( event )
	media.show( media.Camera, sessionComplete )
	return true
end
bkgd:addEventListener( "tap", listener )
