-- 
-- Abstract: Button Events sample app, showing different button properties and handlers.
-- (Also demonstrates the use of external libraries.)
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

-- This example shows you how to create buttons in various ways by using the "ui" library.
-- The project folder contains additional button graphics in various colors.


-- Load external button/label library (ui.lua should be in the same folder as main.lua)
local ui = require("ui")

local background = display.newImage("carbonfiber.jpg", true) -- flag overrides large image downscaling
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2

local roundedRect = display.newRoundedRect( 10, 50, 300, 40, 8 )
roundedRect:setFillColor( 0, 0, 0, 170 )

local t = ui.newLabel{
	bounds = { 10, 55, 300, 40 },
	text = "Waiting for button event...",
	font = "AmericanTypewriter-Bold",
	textColor = { 255, 204, 102, 255 },
	size = 18,
	align = "center"
}

-------------------------------------------------------------------------------
-- Create 5 buttons, using different optional attributes
-------------------------------------------------------------------------------


-- These are the functions triggered by the buttons

local button1Press = function( event )
	t:setText( "Button 1 pressed" )
end

local button1Release = function( event )
	t:setText( "Button 1 released" )
end


local buttonHandler = function( event )
	t:setText( "id = " .. event.id .. ", phase = " .. event.phase )
end


-- This button has individual press and release functions
-- (The label font defaults to native.systemFontBold if no font is specified)

local button1 = ui.newButton{
	default = "buttonRed.png",
	over = "buttonRedOver.png",
	onPress = button1Press,
	onRelease = button1Release,
	text = "Button 1 Label",
	emboss = true
}


-- These other four buttons share a single event handler function, identifying themselves by "id"
-- Note that if a general "onEvent" handler is assigned, it overrides the "onPress" and "onRelease" handling

-- Also, some label fonts may appear vertically offset in the Simulator, but not on device, due to
-- different device font rendering. The button object has an optional "offset" property for minor
-- vertical adjustment to the label position, if necessary (example: offset = -2)

local button2 = ui.newButton{
	default = "buttonYellow.png",
	over = "buttonYellowOver.png",
	onEvent = buttonHandler,
	id = "button2",
	text = "Button 2 Label",
	font = "Trebuchet-BoldItalic",
	textColor = { 51, 51, 51, 255 },
	size = 22,
	emboss = true
}

local button3 = ui.newButton{
	default = "buttonGray.png",
	over = "buttonBlue.png",
	onEvent = buttonHandler,
	id = "button3",
	text = "Button 3 Label",
	font = "MarkerFelt-Thin",
	size = 28,
	emboss = true
}

local buttonSmall = ui.newButton{
	default = "buttonBlueSmall.png",
	over = "buttonBlueSmallOver.png",
	onEvent = buttonHandler,
	id = "smallBtn",
	text = " I'm Small",
	size = 12,
	emboss=true
}

-- Of course, buttons don't always have labels
local buttonArrow = ui.newButton{
	default = "buttonArrow.png",
	over = "buttonArrowOver.png",
	onEvent = buttonHandler,
	id = "arrow"
}

button1.x = 160; button1.y = 160
button2.x = 160; button2.y = 240
button3.x = 160; button3.y = 320
buttonSmall.x = 85; buttonSmall.y = 400
buttonArrow.x = 250; buttonArrow.y = 400
