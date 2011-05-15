-- 
-- Abstract: DebugDraw sample project
-- Demonstrates physics.setDrawMode() and draggable objects using "touch joints"
-- 
-- Version: 1.3 (September 27, 2010) -- includes new "gameUI" library for dragging objects
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

local physics = require("physics")
local ui = require("ui")
local gameUI = require("gameUI")
physics.start()

system.activate( "multitouch" )
display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImage( "night_sky.png" )
bkg.x = 160; bkg.y = 240

local instructionLabel = display.newText( "drag any object", 80, 16, native.systemFontBold, 20 )
instructionLabel:setTextColor( 255, 255, 255, 40 )

local ground = display.newImage("ground.png") -- physical ground object
ground.x = 160; ground.y = 415
physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )

local grass2 = display.newImage("grass2.png") -- non-physical decorative overlay
grass2.x = 160; grass2.y = 464

local dragBody = gameUI.dragBody -- for use in touch event listener below

local function newCrate()	
	rand = math.random( 100 )
	local j

	if (rand < 45) then
		j = display.newImage("crate.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=0.9, friction=0.3, bounce=0.3 } )
		
	elseif (rand < 60) then
		j = display.newImage("crateB.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=1.4, friction=0.3, bounce=0.2 } )
		
	elseif (rand < 80) then
		j = display.newImage("rock.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=3.0, friction=0.3, bounce=0.1, radius=33 } )
		
	else
		j = display.newImage("crateC.png");
		j.x = 60 + math.random( 160 )
		j.y = -100
		physics.addBody( j, { density=0.3, friction=0.2, bounce=0.5 } )
		
	end

	j:addEventListener( "touch", dragBody )
end

local function drawNormal()
	physics.setDrawMode( "normal" )
end

local function drawDebug()
	physics.setDrawMode( "debug" )
end

local function drawHybrid()
	physics.setDrawMode( "hybrid" )
end

local button1 = ui.newButton{
	default = "smallButton.png",
	over = "smallButtonOver.png",
	onPress = drawNormal,
	text = "Normal",
	size = 16,
	emboss = true,
	x = 55,
	y = 450
}

local button2 = ui.newButton{
	default = "smallButton.png",
	over = "smallButtonOver.png",
	onPress = drawDebug,
	text = "Debug",
	size = 16,
	emboss = true,
	x = 160,
	y = 450
}

local button3 = ui.newButton{
	default = "smallButton.png",
	over = "smallButtonOver.png",
	onPress = drawHybrid,
	text = "Hybrid",
	size = 16,
	emboss = true,
	x = 265,
	y = 450
}

-- Make buttons into physics objects so they remain visible in "debug" draw mode
physics.addBody( button1, "static", { density=1.0 } )
physics.addBody( button2, "static", { density=1.0 } )
physics.addBody( button3, "static", { density=1.0 } )

local dropCrates = timer.performWithDelay( 500, newCrate, 120 )