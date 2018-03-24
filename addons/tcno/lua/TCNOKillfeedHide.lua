------ TCNO Hide the Killfeed ------
--[[

Place this in garrysmod/addons/TCNO/lua/
When a player dies, the kill will NOT be shown in the topp right of their screens.
This is useful for gamemodes like TTT and DarkRP.

If the user changes it, every time they spawn it will change.

Created by Wesley Pyburn - TechNobo
https://tcno.co/
https://github.com/TcNobo/
https://youtube.com/TechNobo

--]]

AddCSLuaFile()
if SERVER then
	function newPlayer(ply)
		ply:SendLua("RunConsoleCommand('hud_deathnotice_time', '0')")
	end
	hook.Add("PlayerInitialSpawn", "Killfeed Hide", newPlayer)
	hook.Add("PlayerSpawn", "Killfeed Hide", newPlayer)
end

if CLIENT then
	RunConsoleCommand('hud_deathnotice_time', '0')
end