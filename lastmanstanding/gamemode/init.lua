AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

-------------------------------------------------
--This should probably be disabled.
RunConsoleCommand( "sv_allowcslua", "0" )