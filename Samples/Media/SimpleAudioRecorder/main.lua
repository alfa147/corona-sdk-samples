-- Abstract: Echo - Simple Audio Recorder
--
-- Date: September 15, 2010
-- 
-- Version: 1.1
--
-- Changes:
--  1.1 - larger background image
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: Records audio and plays it back
--
-- Demonstrates:
--		recording = media.newRecording( file )
--		recording:startRecording()
--		recording:stopRecording()
--		result = recording:isRecording()
--		rate = recording:getSampleRate()
--
--
-- File dependencies: none
--
-- Limitations: 
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------


-- Load external button/label library (ui.lua should be in the same folder as main.lua)
local ui = require("ui")
local background = display.newImage("carbonfiber.jpg", true)
background.x = display.contentWidth/2
background.y = display.contentHeight/2

local dataFileName = "testfile"
if "simulator" == system.getInfo("environment") then
    dataFileName = dataFileName .. ".aif"
else
	local platformName = system.getInfo( "platformName" )
    if "iPhone OS" == platformName then
        dataFileName = dataFileName .. ".aif"
    elseif "Android" == platformName then
        dataFileName = dataFileName .. ".pcm"
    else
    	print("Unknown OS " .. platformName )
    end
end
print (dataFileName)



-- title
local t1 = ui.newLabel{
	bounds = { 10, 25, 300, 40 },
	text = "Echo",
	font = "AmericanTypewriter-Bold",
	textColor = { 255, 204, 102, 255 },
	size = 40,
	align = "center"
}
local t2 = ui.newLabel{
	bounds = { 10, 75, 300, 40 },
	text = "Simple Audio Recorder",
	font = "AmericanTypewriter-Bold",
	textColor = { 255, 204, 102, 255 },
	size = 22,
	align = "center"
}

--  recording status area
local roundedRect = display.newRoundedRect( 10, 160, 300, 80, 8 )
roundedRect:setFillColor( 0, 0, 0, 170 )
local s = ui.newLabel{
	bounds = { 10, 180, 300, 40 },
	text = " ",
	textColor = { 10, 240, 102, 255 },
	size = 32,
	align = "center"
}


-- sampling rate display
local s2 = ui.newLabel{
	bounds = { 10, 380, 300, 40 },
	text = " ",
	textColor = { 130, 200, 255, 255 },
	size = 14,
	align = "center"
}



local r                 -- media object for audio recording
local recButton         -- gui buttons
local fSoundPlaying = false   -- sound playback state
local fSoundPaused = false    -- sound pause state

-- Sets the text of a button
local function setButtonText( button, text )
	button[3].text  = text	-- Highlight
	button[4].text  = text	-- Shadow
	button[5].text  = text
end

-- Update the state dependent texts
local function updateStatus ()
    local statusText = " "
    local statusText2 = " "
    if r then
        local recString = ""
        local fRecording = r:isRecording ()
        if fRecording then 
            recString = "RECORDING" 
            setButtonText (recButton, "Stop recording")
        elseif fSoundPlaying then
            recString = "Playing"
            setButtonText (recButton, "Pause playback") 
        elseif fSoundPaused then
            recString = "Paused"
            setButtonText (recButton, "Resume playback") 
        else
            recString = "Idle"
            setButtonText (recButton, "Record")
        end

        statusText =  recString 
        statusText2 = "Sampling rate: " .. tostring (r:getSampleRate() .. "Hz")
    end
    s:setText (statusText)
    s2:setText (statusText2)
end

-------------------------------------------------------------------------------
--  *** Event Handlers ***
-------------------------------------------------------------------------------

local function onCompleteSound (event)
    fSoundPlaying = false
    fSoundPaused = false
	-- Free the audio memory and close the file now that we are done playing it.
	audio.dispose(event.handle)
    updateStatus ()	
end
 
local function recButtonPress ( event )
    if fSoundPlaying then
        fSoundPlaying = false
        fSoundPaused = true
		audio.pause() -- pause all channels
    elseif fSoundPaused then
        fSoundPlaying = true   
        fSoundPaused = false
		audio.resume() -- resume all channels
    else
        if r then
            if r:isRecording () then
                r:stopRecording()
                local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
                -- Play back the recording
                local file = io.open( filePath, "r" )
                if file then
                    io.close( file )
                    fSoundPlaying = true
                    fSoundPaused = false
                    --media.playSound( dataFileName, system.DocumentsDirectory, onCompleteSound )
                    playbackSoundHandle = audio.loadStream( dataFileName, system.DocumentsDirectory )
					audio.play( playbackSoundHandle, { onComplete=onCompleteSound } )
                end                
            else
                fSoundPlaying = false
                fSoundPaused = false
                r:startRecording()
            end
        end
    end
    updateStatus ()
end

-- Increase the sample rate if possible
-- Valid rates are 8000, 11025, 16000, 22050, 44100 but many devices do not
-- support all rates 
local rateUpButtonPress = function( event )
    local theRates = {8000, 11025, 16000, 22050, 44100}
    if not r:isRecording () and not fSoundPlaying and not fSoundPaused then
--        r:stopTuner()
        local f = r:getSampleRate()
        --  get next higher legal sampling rate
        local i, v = next (theRates, nil)                 
        while i do
                if v <= f then 
                    i, v = next (theRates, i) 
                else
                    i = nil
                end
        end    
        if v then 
            r:setSampleRate(v) 
        else
            r:setSampleRate(theRates[1])
        end   
--        r:startTuner()
    end
    updateStatus()
end

-- Decrease the sample rate if possible
-- Valid rates are 8000, 11025, 16000, 22050, 44100 but many devices do not
-- support all rates.
local rateDownButtonPress = function( event )
    local theRates = {44100, 22050, 16000, 11025, 8000}
    if not r:isRecording () and not fSoundPlaying and not fSoundPaused then
--        r:stopTuner()
        local f = r:getSampleRate()
        --  get next lower legal sampling rate
        local i, v = next (theRates, nil)                 
        while i do
                if v >= f then 
                    i, v = next (theRates, i) 
                else
                    i = nil
                end
        end    
        if v then 
            r:setSampleRate(v) 
        else
            r:setSampleRate(theRates[1])
        end            
--        r:startTuner()
    end
    updateStatus()
end


-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- Record Button
recButton = ui.newButton{
	default = "buttonRed.png",
	over = "buttonRedOver.png",
	onPress = recButtonPress,
	text = "Record",
	emboss = true
}

--  increase sampling rate
local rateUpButton = ui.newButton{
	default = "buttonArrowUp.png",		-- small arrow image
	over = "buttonArrowUpOver.png",
	onPress = rateUpButtonPress,
	id = "arrowUp"
}

-- decrease sampling rate
local rateDownButton = ui.newButton{
	default = "buttonArrowDwn.png",		-- small arrow image
	over = "buttonArrowDwnOver.png",
	onPress = rateDownButtonPress,
		id = "arrowDwn"
}

-----------------------------------------------
-- *** Locate the buttons on the screen ***
-----------------------------------------------
recButton.x = 160; 		   recButton.y = 290
rateUpButton.x =   190;    rateUpButton.y =   420
rateDownButton.x = 140;     rateDownButton.y = 420


local filePath = system.pathForFile( dataFileName, system.DocumentsDirectory )
r = media.newRecording(filePath)
updateStatus ()                                                
                                
