------ Online Player Count ------
--[[

Place this in garrysmod/addons/TCNO/lua/
Each time interval, you will see the following ONLY in the server console:
[0/64] Players online
This is just for easy checking when you're not actively on the server or available to check on the Garry's Mod client.

Use "count" in console (or !count or /count in chat) to immediately check the number of players online, instead of waiting for the timer.
Use "list" in console (or !list or /list in chat) to immediately list all the players on the server.

Created by Wesley Pyburn - TechNobo
https://tcno.co/
https://github.com/TcNobo/
https://youtube.com/TechNobo

--]]


--------- CONVAR DEFINITION ---------
if !ConVarExists( "tcno_IntervalTime" ) then CreateConVar( "tcno_IntervalTime", 240, FCVAR_NONE, "Set the interval for the online player count." ) end
 --Time in seconds between Player Count checks (240 is default)
-------- END CONVAR DEFINITION --------


--------- FUNCTION DEFINITION ---------
-- Function to count the online players
function tcnoPlayerCount(ply)
	PCPrint( ply, "[" .. #player.GetAll() .. "/" .. game.MaxPlayers() .. "] Players online")
end
-- Function to create the timer
function tcnoTimerCreate()
	timer.Create("tcnoOnlinePlayerCount", GetConVar( "tcno_IntervalTime" ):GetInt(), 0, function()
		tcnoPlayerCount()
	end)
end
function tcnoReload()
	timer.Remove( "tcnoOnlinePlayerCount" )
	tcnoTimerCreate()
end
function tcnoListPlayers(ply)
	if (#player.GetAll() > 0) then 
		PCPrint( ply, "----- List of online players -----" )
		for _, ppp in ipairs( player.GetAll() ) do
			PCPrint( ply, ppp:Nick() .. "(" .. ppp:SteamID() .. ")" )
		end
		PCPrint( ply, "------ End of online players------" )
	else
		PCPrint( ply, "There are currently no players online." )
	end
end
------- END FUNCTION DEFINITION -------


-------- CONCOMMAND DEFINITION --------
-- Adds command to count online players
concommand.Add( "count", function( ply, cmd, args, str )
	tcnoPlayerCount(ply)
end )
-- Adds command to reload the plugin
concommand.Add( "tcno_reload" , function() 
	tcnoReload()
end )
-- Add the list command to console
-- Adds checker for CONVAR change, and will reload the plugin when nessecary
cvars.AddChangeCallback( "tcno_IntervalTime", tcnoReload() )
-- This takes inspiration form Example 2 (https://wiki.garrysmod.com/page/concommand/Add)
concommand.Add( "list", function( ply, cmd, args, str )
	tcnoListPlayers(ply)
end )

--Checks if player, or console and prints respectively.
function PCPrint(ply, str)
		if ply:IsValid() then
			ply:ChatPrint( str )
			else
			print( str )
		end	
end
------- END CONCOMMAND DEFINITION -------


-- Create the timer.
tcnoTimerCreate()
---------------------------------


----- Look for commands in chat.
----- Commands: /list or !list and /count or !count
function tcnoChatCommand( ply, text, public )
	if (string.sub(text, 1, 5) == "/list" || string.sub(text, 1, 5) == "!list") then
		 tcnoListPlayers(ply)
		return ""
	elseif (string.sub(text, 1, 6) == "/count" || string.sub(text, 1, 6) == "!count") then
		 tcnoPlayerCount(ply)
		return ""
	end
end
	
hook.Add( "PlayerSay", "tcnoChatCommand", tcnoChatCommand );
