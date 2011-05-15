--
-- Project: NativeKeyboard2
--
-- Date: November 30, 2010
--
-- Version: 1.3
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: Shows different native text entry options (keypad, normal, phone, etc.)
--
-- Demonstrates: 	Adding and removing native text fields objects
--					Changing button labels on the flyable
--					Tapping the background to dismiss the native keyboard.
--
-- File dependencies: ui.lua (v1.5 or higher)
--
-- Target devices: Devices only
--
-- Limitations: Native Text Fields not supported on Simulator
--
-- Update History:
--	v1.2	Added Simulator warning message
--			Buttons now remove and add text fields
--
--  v1.3	Increased native.textField height when running on Android device
--
-- Comments: Slight tweak added for Android textfields, which have more chrome
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

local ui = require("ui")

local tHeight		-- forward reference

-------------------------------------------
-- General event handler for fields
-------------------------------------------

-- You could also assign different handlers for each textfield

local function fieldHandler( event )

	if ( "began" == event.phase ) then
		-- This is the "keyboard has appeared" event
		-- In some cases you may want to adjust the interface when the keyboard appears.
	
	elseif ( "ended" == event.phase ) then
		-- This event is called when the user stops editing a field: for example, when they touch a different field
	
	elseif ( "submitted" == event.phase ) then
		-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
		
		-- Hide keyboard
		native.setKeyboardFocus( nil )
	end

end

-- Predefine local objects for use later
local defaultField, numberField, phoneField, urlField, emailField, passwordField
local fields = display.newGroup()

-------------------------------------------
-- *** Buttons Presses ***
-------------------------------------------

-- Default Button Pressed
local defaultButtonPress = function( event )
	
	-- Make sure display object still exists before removing it
	if defaultField then
		print("Default button pressed ... removing textField")
--		defaultField:removeSelf()
		fields:remove( defaultField )
		defaultButton:setText( "Add Default textField" )
		
		defaultField = nil				-- do this so we don't remove it a second time
	else
		-- Add the text field back again
		defaultField = native.newTextField( 10, 30, 180, tHeight, fieldHandler )
		defaultField.font = native.newFont( native.systemFontBold, 18 )
		fields:insert(defaultField)
		defaultButton:setText( "Remove Default textField" )
	end
end

-- Number Button Pressed
local numberButtonPress = function( event )
	print("Number button pressed ... removing textField")
	
	-- Make sure display object still exists before removing it
	if numberField then
		numberField:removeSelf()
		numberButton:setText( "Add Number textField" )
		numberField = nil				-- do this so we don't remove it a second time
	else
		-- Add the text field back again
		numberField = native.newTextField( 10, 70, 180, tHeight, fieldHandler )
		numberField.font = native.newFont( native.systemFontBold, 18 )
		numberField.inputType = "number"
		fields:insert(numberField)
		numberButton:setText( "Remove Number textField" )
	end
end

-------------------------------------------
-- *** Create native input textfields ***
-------------------------------------------

-- Note: currently this feature works in device builds or Xcode simulator builds only

-- Note: currently this feature works in device builds only
local isAndroid = "Android" == system.getInfo("platformName")
local inputFontSize = 18
local inputFontHeight = 30
tHeight = 30

if isAndroid then
	-- Android text fields have more chrome. It's either make them bigger, or make the font smaller.
	-- We'll do both
	inputFontSize = 14
	inputFontHeight = 42
	tHeight = 40
end

defaultField = native.newTextField( 10, 30, 180, tHeight, fieldHandler )
defaultField.font = native.newFont( native.systemFontBold, inputFontSize )

numberField = native.newTextField( 10, 70, 180, tHeight, fieldHandler )
numberField.font = native.newFont( native.systemFontBold, inputFontSize )
numberField.inputType = "number"

phoneField = native.newTextField( 10, 110, 180, tHeight, fieldHandler )
phoneField.font = native.newFont( native.systemFontBold, inputFontSize )
phoneField.inputType = "phone"

urlField = native.newTextField( 10, 150, 180, tHeight, fieldHandler )
urlField.font = native.newFont( native.systemFontBold, inputFontSize )
urlField.inputType = "url"

emailField = native.newTextField( 10, 190, 180, tHeight, fieldHandler )
emailField.font = native.newFont( native.systemFontBold, inputFontSize )
emailField.inputType = "email"

passwordField = native.newTextField( 10, 230, 180, tHeight, fieldHandler )
passwordField.font = native.newFont( native.systemFontBold, inputFontSize )
passwordField.isSecure = true

-- Add fields to our new group
fields:insert(defaultField)
fields:insert(numberField)

-------------------------------------------
-- *** Add field labels ***
-------------------------------------------

local defaultLabel = display.newText( "Default", 200, 35, native.systemFont, 18 )
defaultLabel:setTextColor( 170, 170, 255, 255 )

local defaultLabel = display.newText( "Number", 200, 75, native.systemFont, 18 )
defaultLabel:setTextColor( 255, 150, 180, 255 )

local defaultLabel = display.newText( "Phone", 200, 115, native.systemFont, 18 )
defaultLabel:setTextColor( 255, 220, 120, 255 )

local defaultLabel = display.newText( "URL", 200, 155, native.systemFont, 18 )
defaultLabel:setTextColor( 170, 255, 170, 255 )

local defaultLabel = display.newText( "Email", 200, 195, native.systemFont, 18 )
defaultLabel:setTextColor( 120, 255, 245, 255 )

local defaultLabel = display.newText( "Password", 200, 235, native.systemFont, 18 )
defaultLabel:setTextColor( 255, 235, 170, 255 )

-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- "Remove Default" Button
defaultButton = ui.newButton{
	default = "buttonBlue.png",
	over = "buttonBlueOver.png",
	onPress = defaultButtonPress,
	text = "Remove Default textField",
	emboss = true
}

-- "Remove Number" Button
numberButton = ui.newButton{
	default = "buttonBlue.png",
	over = "buttonBlueOver.png",
	onPress = numberButtonPress,
	text = "Remove Number textField",
	emboss = true
}

-- Position the buttons on screen
local s = display.getCurrentStage()

defaultButton.x = s.contentWidth/2;	defaultButton.y = 365
numberButton.x = s.contentWidth/2;	numberButton.y = 430

-------------------------------------------
-- Create a Background touch event
-------------------------------------------

local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 0, 0, 0, 0 )		-- set Alpha = 0 so it doesn't cover up our buttons/fields

-- Tapping screen dismisses the keyboard
--
-- Needed for the Number and Phone textFields since there is
-- no return key to clear focus.

local listener = function( event )
	-- Hide keyboard
	print("tap pressed")
	native.setKeyboardFocus( nil )
end

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")

-- Native Text Fields not supported on Simulator
--
if isSimulator then
	msg = display.newText( "Native Text Fields not supported on Simulator!", 0, 280, "Verdana-Bold", 12 )
	msg.x = display.contentWidth/2		-- center title
	msg:setTextColor( 255,255,0 )
end

-- Add listener to background for user "tap"
bkgd:addEventListener( "tap", listener )