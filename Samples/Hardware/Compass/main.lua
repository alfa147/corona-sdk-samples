--
-- Project: Compass
--
-- Date: August 19, 2010
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: Compass sample app
--
-- Demonstrates: heading events, buttons, touch
--
-- File dependencies: ui.lua
--
-- Target devices: iPhone 3GS or newer for compass data.
--
-- Limitations: Heading events not supported on Simulator or iPhone 3G
--
-- Update History:
--	v1.3	Added Simulator warning message
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Load external library (should be in the same folder as main.lua)
local ui = require("ui")

-- Labels for digital display
local headingGeo = ui.newLabel{
	bounds = { 25, 47, 88, 46 },
	text = "0°",
	font = "Helvetica-Bold",
	textColor = { 35, 170, 255, 255 },
	size = 38,
	align = "right"
}

local directionGeo = ui.newLabel{
	bounds = { 111, 66, 31, 24 },
	text = "N",
	font = "Helvetica-Bold",
	textColor = { 35, 170, 255, 255 },
	size = 16,
	align = "left"
}

local headingMag = ui.newLabel{
	bounds = { 175, 47, 88, 46 },
	text = "0°",
	font = "Helvetica-Bold",
	textColor = { 153, 153, 153, 255 },
	size = 38,
	align = "right"
}

local directionMag = ui.newLabel{
	bounds = { 261, 66, 31, 24 },
	text = "N",
	font = "Helvetica-Bold",
	textColor = { 153, 153, 153, 255 },
	size = 16,
	align = "left"
}

local dial = display.newImage("compass_dial.png", 40, 150)
local background = display.newImage("compass_bkg.png")

local compassMode = "geo"

local showGeo = function( event )
print("geo")
	headingGeo:setTextColor( 35, 170, 255, 255 )
	directionGeo:setTextColor( 35, 170, 255, 255 )
	headingMag:setTextColor( 153, 153, 153, 255 )
	directionMag:setTextColor( 153, 153, 153, 255 )
	compassMode = "geo"
end

local showMag = function( event )
print("mag")
	headingGeo:setTextColor( 153, 153, 153, 255 )
	directionGeo:setTextColor( 153, 153, 153, 255 )
	headingMag:setTextColor( 35, 170, 255, 255 )
	directionMag:setTextColor( 35, 170, 255, 255 )
	compassMode = "mag"
end

-- Add touch events to textfields (for switching between geographic/magnetic display modes)
headingGeo:addEventListener( "touch", showGeo )
headingMag:addEventListener( "touch", showMag )

local directionForAngle = function( angle )
	local text

	if ( angle <= 22 or angle > 337 ) then
		text = "N"
	elseif ( angle > 22 and angle <= 67 ) then
		text = "NE"
	elseif ( angle > 67 and angle <= 112 ) then
		text = "E"
	elseif ( angle > 112 and angle <= 157 ) then
		text = "SE"
	elseif ( angle > 157 and angle <= 202 ) then
		text = "S"
	elseif ( angle > 202 and angle <= 247 ) then
		text = "SW"
	elseif ( angle > 247 and angle <= 292 ) then
		text = "W"
	elseif ( angle > 292 and angle <= 337 ) then
		text = "NW"
	end
	
	return text
end

local dstRotation = 0

local updateCompass = function( event )

	local angleMag, angleGeo
	
	-- Note: "magnetic" = magnetic north heading, and "geographic" = "true north" heading as seen on a map
	-- (The variance between these heading values depends on your position on the Earth)

	angleMag = event.magnetic

	-- Android does not support geographic headings, so we use magnetic headings for Android builds
	if system.getInfo( "platformName" ) ~= "Android" then
		angleGeo = event.geographic
	else
		angleGeo = angleMag
	end
	
	if ( "geo" == compassMode ) then
		dstRotation = -angleGeo
	else
		dstRotation = -angleMag
	end
	
	-- Format strings as whole numbers
	local valueGeo = string.format( '%.0f', angleGeo )
	local valueMag = string.format( '%.0f', angleMag )

	headingGeo:setText( valueGeo .. "°" )
	directionGeo:setText( directionForAngle( angleGeo ) )
	
	headingMag:setText( valueMag .. "°" )
	directionMag:setText( directionForAngle( angleMag ) )
end

local animateDial = function( event )
	local curRotation = dial.rotation
	local delta = dstRotation - curRotation
	
	if math.abs( delta ) >= 180 then
		if delta < -180 then
			delta = delta + 360
		elseif delta > 180 then
			delta = delta - 360
		end
	end

	dial.rotation = curRotation + delta*0.3
end

local didInitGPS = false
local initGPS = function( event )
	if ( not didInitGPS ) then
		didInitGPS = true

		-- We only need a single location event to calibrate "true north", then we can turn off GPS again
		local initDone = function( event )
			Runtime:removeEventListener( "location", initGPS )
		end

		-- Delay removal to let the hardware activate
		timer.performWithDelay( 1000, initDone )
	end
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Heading Events are not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Heading events not supported on Simulator!", 0, 20, "Verdana-Bold", 12 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

-- Location event listener
if system.getInfo( "platformName" ) ~= "Android" then
	Runtime:addEventListener( "location", initGPS )
end
-- This is not required if you only want the heading relative to magnetic north, but to calculate 
-- your "true north" offset, the iPhone needs at least one location reading. Location may already 
-- be cached by the OS, but if not, then geographic north heading defaults to "-1".
-- Again, this is not required for Android, since Android does not support true north headings.

-- Compass event listener
Runtime:addEventListener( "heading", updateCompass )

-- Adaptive tweening to smooth the dial animation
Runtime:addEventListener( "enterFrame", animateDial )