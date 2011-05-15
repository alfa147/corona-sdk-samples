-- Project: Analytics
--
-- Date: November 16, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Code type: SDK Test code
--
-- Author: Ansca Mobile
--
-- Demonstrates: analytics API
--
-- File dependencies: none
--
-- Target devices: iOS, Android
--
-- Limitations:
--
-- Update History:
--
-- Comments: 
--
--		This sample demonstrates the use of analytics in Corona.
--		To use it, you must first create an account on Flurry.
--		Go to www.flurry.com and sign up for an account. Once you have
--		logged in to flurry, go to Manage Applications. Click "Create a new app".
--		Choose iPhone, iPad, or Android as appropriate. This will create
--		an "Application key" which you must enter in the code below (we
--		recommend making a copy of this sample, rather than editing it directly).
--
--		Build your app for device and install it. When you run it, you can
--		optionally click on the buttons to create additional event types.
--		The analytics data is uploaded when you quit the app, or possibly
--		on next launch if there was a problem (such as no network).
--
--		Finally, in your Flurry account, choose "View analytics" to 
--		see the data created by your app.
--		Note that it takes some time for the analytics data to appear
--		in the Flurry statistics, it does not appear immediately.
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

require "ui"
require "analytics"

-- Replace this string with your unique application key, obtained from www.flurry.com.
local application_key = "1234567890ABCDEFG"

analytics.init( application_key )

local buttonRelease1 = function( event )
	-- When button 1 is pressed, it logs an event called "event1"
	analytics.logEvent("event1")
end

local buttonRelease2 = function( event )
	-- When button 2 is pressed, it logs an event called "event2"
	analytics.logEvent("event2")
end

local buttonRelease3 = function( event )
	-- When button 3 is pressed, it logs an event called "event3"
	analytics.logEvent("event3")
end

-- Create buttons for each event
local button1 = ui.newButton{
	default = "buttonBlue.png",
	over = "buttonBlueOver.png",
	onRelease = buttonRelease1,
	text = "Log Event 1"
}

local button2 = ui.newButton{
	default = "buttonBlue.png",
	over = "buttonBlueOver.png",
	onRelease = buttonRelease2,
	text = "Log Event 2"
}

local button3 = ui.newButton{
	default = "buttonBlue.png",
	over = "buttonBlueOver.png",
	onRelease = buttonRelease3,
	text = "Log Event 3"
}

-- Place buttons on the screen
button1.x = 160
button1.y = 50
button2.x = 160
button2.y = 125
button3.x = 160
button3.y = 200
