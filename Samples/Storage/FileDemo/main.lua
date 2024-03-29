--
-- Project: FileDemo
--
-- Date: September 10, 2010
--
-- Version: 1.2
--
-- File name: main.lua
--
-- Author: Ansca Mobile
--
-- Abstract: Shows how to create and read a file in /Documents directory
--
-- Demonstrates: file create and file read APIs
--
-- File dependencies: none
--
-- Target devices: Simulator (results in Console) and on Device
--
-- Limitations: none
--
-- Update History:
--  v1.2            Added display of file contents on screen
--	v1.1			Fixed file path display on device
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

-- Displays App title
title = display.newText( "File Demo", 0, 30, "Verdana-Bold", 20 )
title.x = display.contentWidth/2		-- center title
title:setTextColor( 255,255,0 )

-- system.pathForFile( filename [, baseDirectory] )
-- baseDirectory is one of:
-- system.DocumentsDirectory This is the default. Files persist between app launches. Under the simulator, this is located at "~/Documents"
-- system.TemporaryDirectory This is a tmp directory. Files do not persist between app launches
-- system.ResourceDirectory  This is where all app assets go, e.g. where display.newImage() looks for image files
--
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- io.open opens a file at filePath. returns nil if no file found
--
local file = io.open( filePath, "r" )
if file then
	-- read all contents of file into a string
	local contents = file:read( "*a" )

	print( "Contents of " .. filePath )
	print( contents )

	io.close( file )

	local t = display.newText( "Contents of ", 5, 80, nil, 16 );
	t:setTextColor( 255, 255, 136, 255 );
	local t = display.newText( filePath, 5, 100, nil, 10 );
	t:setTextColor( 255, 255, 136, 255 );

	local ylast = 130
	for line in io.lines(filePath) do  
		local t = display.newText( line, 15, ylast, nil, 14 );
		t:setTextColor( 255, 255, 255 );	
		ylast = ylast + 20
	end

else
	print( "Creating file..." )

	-- create file b/c it doesn't exist yet
	file = io.open( filePath, "w" )
	file:write( "Feed me data!\n" )
	local numbers = {1,2,3,4,5,6,7,8,9}
	file:write( numbers[1], numbers[2], numbers[3], "\n" )
	for _,v in ipairs( numbers ) do
		file:write( v, " " )
	end
	file:write( "\nNo more data\n" )
	io.close( file )

	local t = display.newText( "Created file at:", 5, 80, nil, 16 );
	t:setTextColor( 255, 255, 136, 255 );
	local t = display.newText( filePath, 5, 100, nil, 10 );
	t:setTextColor( 255, 255, 136, 255 );
	local t = display.newText( "Run app again to test file read.", 5, 130, nil, 12 );
	t:setTextColor( 255, 255, 136, 255 );

	-- This removes the file just created
	-- os.remove( filePath )
end
