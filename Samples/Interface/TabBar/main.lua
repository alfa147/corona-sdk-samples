-- 
-- Abstract: Tab Bar sample app
--  
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Demonstrates how to create a tab bar that allows the user to navigate between screens,
-- using the View Controller Library, viewController.lua.

--import external classes
local ui = require("ui")
local viewController = require("viewController")

local mainView, tabView, currentScreen, tabBar
	
local function loadScreen(newScreen)
	if currentScreen then
		currentScreen:cleanUp()
	end
	currentScreen = require(newScreen).new()
	tabView:insert(currentScreen)
	
	return true
end

local function showScreen(event)
	local t = event.target
	local phase = event.phase
	 
	if phase == "ended" then 
		if t.id == 1 then
			loadScreen("screen1")
		elseif t.id == 2 then
			loadScreen("screen2")
		elseif t.id == 3 then
			loadScreen("screen3")
		end
		tabBar.selected(t)
	end

	return true
end

local function init()
	--Create a group that contains the entire screen and tab bar
	mainView = display.newGroup()	

	--Create a group that contains the screens beneath the tab bar
	tabView = display.newGroup()	
	mainView:insert(tabView)

	loadScreen("screen1")
	
	tabBar = viewController.newTabBar{
			background = "tabBar.png",	--tab bar background
			tabs = {"Play", "News", "About"}, --names to appear under each tab icon
			onRelease = showScreen  --function to execute when pressed
		}
	mainView:insert(tabBar)
		
	tabBar.selected()
	
	return true
end

--Start the program!
init()