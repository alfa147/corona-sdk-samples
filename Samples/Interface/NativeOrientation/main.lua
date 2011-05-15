-- 
-- Abstract: Native Orientation sample app, demonstrating orientation using build settings.
-- This example launches in landscape mode, but will auto-rotate both Corona and native UI elements.
-- To lock orientation, reduce the number of "supported" orientations in the build.settings file.
-- (Also see the build.settings file in this project.)
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.


-- Load external button/label library (ui.lua should be in the same folder as main.lua)

local ui = require("ui");

local function buttonHandler(event)
	myAlert = native.showAlert(
		"Alert!", 
		"This is either a desktop or device native alert dialog.",
		{ "Cancel", "OK" } 
	);
end
 
local blueButton = ui.newButton {
    default = "buttonBlue.png",
    over = "buttonBlueOver.png",
    onRelease = buttonHandler,
    text = "Press for Alert",
    font = native.systemFontBold,
    emboss = true
}

blueButton.x = 160
blueButton.y = 50

local myLabel = ui.newLabel{
	bounds = { 12, 90, 300, 40 },
	text = "Position (0,0) is the top left in all orientations.",
	font = native.systemFont,
	textColor = { 102, 255, 102, 255 },
	size = 13,
	align = "center"
}

-- Display current orientation using "system.orientation"
-- (default orientation is determined in build.settings file)

local orientationLabel = ui.newLabel{
	bounds = { 12, 115, 300, 40 },
	text = "Orientation: (default)",
	font = native.systemFontBold,
	textColor = { 240, 240, 90, 255 },
	size = 15,
	align = "center"
}

local function onOrientationChange( event )
	orientationLabel:setText("Orientation: " .. system.orientation )
end

Runtime:addEventListener( "orientation", onOrientationChange )