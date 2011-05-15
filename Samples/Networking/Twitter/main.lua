-- 
-- Abstract: SimpleTweet sample app, how to log into Twitter and post a tweet
-- (For example, a game could let users tweet their high scores, along with a download link)
-- 
-- Version: 1.1
-- 
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

-- Load the relevant LuaSocket modules (no additional files required for these)
local http = require("socket.http")
local ltn12 = require("ltn12")

-- Load external library (should be in the same folder as main.lua)
local ui = require("ui")

display.setStatusBar( display.HiddenStatusBar )

local username, password, usernameField, passwordField
local loginDialog, tweetDialog, tweetText, finalDialog, textBox, escape, sendTweet


local screen = display.newGroup()
local background = display.newImage( "tweetscreen.jpg" )
screen:insert( background )


-- Handlers for login dialog UI

local function onUsername( event )
	if ( "began" == event.phase ) then
		-- Note: this is the "keyboard appearing" event
		-- In some cases you may want to adjust the interface while the keyboard is open.
		
	elseif ( "submitted" == event.phase ) then
		-- Automatically tab to password field if user clicks "Return" on iPhone keyboard (convenient!)
		native.setKeyboardFocus( passwordField )
	end
end

local function onPassword( event )
	-- Hide keyboard when the user clicks "Return" in this field
	if ( "submitted" == event.phase ) then
		native.setKeyboardFocus( nil )
	end
end

local function onLogin( event )
	-- Note: you could write these variables to the application's directory, so the user could be
	-- automatically logged in the next time they run your app
	username = usernameField.text
	password = passwordField.text

	-- Remove login dialog, show tweet dialog
	loginDialog.isVisible = false
	usernameField.isVisible = false
	passwordField.isVisible = false	
	local tweetFade = transition.to( tweetDialog, { alpha=1.0, time=800 } )
	local textFade = transition.to( textBox, { alpha=1.0, time=800 } )
end


-- Create and send the tweet

tweetText = "Testing the latest Corona SDK for iPhone: http://bit.ly/CoronaSDK"

-- Function for URLencoding of message content
function escape (s)
	s = string.gsub(s, "([&=+%c])", function (c)
			return string.format("%%%02X", string.byte(c))
		end)
	s = string.gsub(s, " ", "+")
	return s
end

function sendTweet()
	local postBody = "status=" .. escape( tweetText )
	local headerTable = { ["Content-Type"] = "application/x-www-form-urlencoded", ["Content-Length"] = string.len( postBody ) }

	http.request {	
		url = "http://" .. username .. ":" .. password .. "@twitter.com/statuses/update.json",
		method = "POST",
		headers = headerTable,
		source = ltn12.source.string( postBody )
	}
	print( "tweet sent!" )
end

local function onTweet( event )
	-- Remove tweet dialog, show final confirmation message
	tweetDialog.alpha = 0
	textBox.alpha = 0
	local finalFade = transition.to( finalDialog, { alpha=1.0, time=800 } )
	timer.performWithDelay( 1200, sendTweet )
end


-- Build the login dialog

loginDialog = display.newGroup()
local dialog_bkg = display.newImage( "dialog_bkg.png" )
loginDialog:insert( dialog_bkg )
loginDialog.y = 110

usernameField = native.newTextField( 50, 150, 220, 36, onUsername )
usernameField.font = native.newFont( native.systemFontBold, 24 )
usernameField.text = ""
usernameField:setTextColor( 51, 51, 122, 255 )

passwordField = native.newTextField( 50, 210, 220, 36, onPassword )
passwordField.font = native.newFont( native.systemFontBold, 24 )
passwordField.text = ""
passwordField.isSecure = true
passwordField:setTextColor( 51, 51, 122, 255 )

local loginButton = ui.newButton{
	default = "smallButton.png",
	over = "smallButtonOver.png",
	onPress = onLogin,
	text = "SIGN IN",
	font = "Helvetica-Bold",
	size = 13,
	textColor = { 225, 225, 225, 255 },
	emboss = true,
}
loginDialog:insert( loginButton )
loginButton.x = 220
loginButton.y = 165


-- Build the tweet dialog

tweetDialog = display.newGroup()
local dialog_bkg2 = display.newImage( "dialog_bkg.png" )
tweetDialog:insert( dialog_bkg2 )
tweetDialog.y = 110

local caption = display.newText( "You are about to post:", 0, 0, "Helvetica", 13 )
caption:setTextColor( 170, 170, 255, 255 )
tweetDialog:insert( caption, true )
caption.x = 160; caption.y = 28

-- Multiline textfield, with transparent background
textBox = native.newTextBox( 30, 140, 260, 100 )
textBox.font = native.newFont( "Helvetica-Bold", 16 )
textBox:setTextColor( 200, 200, 200, 255 )
textBox.hasBackground = false
textBox.text = tweetText
tweetDialog:insert( textBox )
textBox.alpha = 0

local tweetButton = ui.newButton{
	default = "smallButton.png",
	over = "smallButtonOver.png",
	onPress = onTweet,
	text = "OK",
	font = "Helvetica-Bold",
	size = 13,
	textColor = { 225, 225, 225, 255 },
	emboss = true,
}
tweetDialog:insert( tweetButton )
tweetButton.x = 160
tweetButton.y = 165

tweetDialog.alpha = 0


-- Build the final dialog

finalDialog = display.newGroup()
local dialog_bkg3 = display.newImage( "dialog_bkg.png" )
finalDialog:insert( dialog_bkg3 )
finalDialog.y = 110

local confirm = display.newText( "Your tweet has been sent!", 0, 0, "Helvetica", 16 )
confirm:setTextColor( 170, 170, 255, 255 )
finalDialog:insert( confirm, true )
confirm.x = 160; confirm.y = 70

finalDialog.alpha = 0