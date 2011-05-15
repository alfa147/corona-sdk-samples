--
-- Project: GPS
--
-- Date: August 19, 2010
--
-- Version: 1.2
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: GPS sample app, showing available location event properties
--
-- Demonstrates: locations events, buttons, touch
--
-- File dependencies: ui.lua
--
-- Target devices: iPhone 3GS or newer for GPS data.
--
-- Limitations: Location events not supported on Simulator
--
-- Update History:
--	v1.2	Added Simulator warning message
--
-- Comments: 
-- This example shows you how to access the various properties of the "location" events, which
-- are returned by the GPS listener. Devices without GPS will have less accurate location data,
-- and the Corona Simulator returns a set of artificial coordinates for testing.
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Load external button/label library (ui.lua should be in the same folder as main.lua)
local ui = require("ui")

local currentLatitude = 0
local currentLongitude = 0

display.setStatusBar( display.HiddenStatusBar )

local background = display.newImage("gps_background.png")


local latitude = ui.newLabel{
	bounds = { 136, 51, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
}

local longitude = ui.newLabel{
	bounds = { 136, 101, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
}

local altitude = ui.newLabel{
	bounds = { 136, 151, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
}

local accuracy = ui.newLabel{
	bounds = { 136, 201, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
}

local speed = ui.newLabel{
	bounds = { 136, 251, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
	}

local direction = ui.newLabel{
	bounds = { 136, 301, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
}

local time = ui.newLabel{
	bounds = { 136, 351, 180, 40 },
	text = "--",
	font = "DBLCDTempBlack",
	textColor = { 255, 85, 85, 255 },
	size = 26,
	align = "left"
}


local buttonPress = function( event )
	-- Show location on map
	mapURL = "http://maps.google.com/maps?q=Hello,+Corona!@" .. currentLatitude .. "," .. currentLongitude
	system.openURL( mapURL )
end


local button1 = ui.newButton{
	default = "buttonRust.png",
	over = "buttonRustOver.png",
	onPress = buttonPress,
	text = "Show on Map",
	font = "TrebuchetMS-Bold",
	size = 22,
	textColor = { 200, 200, 200, 255 },
	emboss = true,
	x = 160,
	y = 422
}

local locationHandler = function( event )
	local latitudeText = string.format( '%.4f', event.latitude )
	currentLatitude = latitudeText
	latitude:setText( latitudeText )
	
	local longitudeText = string.format( '%.4f', event.longitude )
	currentLongitude = longitudeText
	longitude:setText( longitudeText )
	
	local altitudeText = string.format( '%.3f', event.altitude )
	altitude:setText( altitudeText )

	local accuracyText = string.format( '%.3f', event.accuracy )
	accuracy:setText( accuracyText )
	
	local speedText = string.format( '%.3f', event.speed )
	speed:setText( speedText )

	local directionText = string.format( '%.3f', event.direction )
	direction:setText( directionText )

	-- Note: event.time is a Unix-style timestamp, expressed in seconds since Jan. 1, 1970
	local timeText = string.format( '%.0f', event.time )
	time:setText( timeText )
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Location Events is not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Location events not supported on Simulator!", 0, 230, "Verdana-Bold", 13 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,255 )
end

-- Activate location listener
Runtime:addEventListener( "location", locationHandler )