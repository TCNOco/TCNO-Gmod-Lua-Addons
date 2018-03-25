------ TCNO Hide the Killfeed ------
--[[

Place this in garrysmod/addons/TCNO/lua/
When a player dies, the kill will NOT be shown in the topp right of their screens.
This is useful for gamemodes like TTT and DarkRP.

If the user changes it, every time they respawn it will change.
Remember to set the job/team names that are allowed to see the killfeed, or allow the admin Killfeed Bypass for admins to see the Killfeed regardless.

Created by Wesley Pyburn - TechNobo
https://tcno.co/
https://github.com/TcNobo/
https://youtube.com/TechNobo

--]]

--List of job names that are allowed to see the killfeed:
--Make sure that they match the names EXACTLY
local tcnoAllowedTeams = {"Superadmin on duty", "Admin On Duty"}

--CONVAR DEFINITION--
--Will ignore the list above, and just give the ability to see if the player is an admin (when they resapwn, and on first join)
if !ConVarExists( "tcno_AllowAdminKillfeed" ) then CreateConVar( "tcno_AllowAdminKillfeed", 1, FCVAR_NONE, "Allows admins to see killfeed regardless of whitelist. (set to 1 or 0)" ) end
--END CONVAR DEFINITION--

AddCSLuaFile()
--RUN ON SERVER SIDE
if SERVER then
	function plySpawnCheck(ply)
		newTeamChange(ply, ply:Team(), ply:Team())
	end
	function newTeamChange(ply, oldt, newt)
		if not IsValid(ply) or not ply:IsPlayer() then return end --Checks if is a valid player, before continuing.
		if (ply:IsAdmin() and GetConVar( "tcno_AllowAdminKillfeed" ):GetInt() == 1) then
			ply:SendLua("RunConsoleCommand('hud_deathnotice_time', '6')")
		else
			for _, v in ipairs(tcnoAllowedTeams) do
				if v == team.GetName(newt) then
						ply:SendLua("RunConsoleCommand('hud_deathnotice_time', '6')") --Re-enables for admin on death
						break
				else
						ply:SendLua("RunConsoleCommand('hud_deathnotice_time', '0')") --Disables for normal users on death, incase they change it manually.
				end
			end
		end	
	end
	hook.Add("OnPlayerChangedTeam", "PlayerSwitchedTeam", newTeamChange(ply, oldt, newt))
	hook.Add("PlayerInitialSpawn", "Killfeed Hide", plySpawnCheck)
	hook.Add("PlayerSpawn", "Killfeed Hide", plySpawnCheck)
	print( "TCNO: Successfully loaded Killfeed Hide. All players killfeeds should now be hidden." )
end

--RUN ON CLIENT SIDE
if CLIENT then
	RunConsoleCommand('hud_deathnotice_time', '0') --Defaults to 0, and then will check whether has admin or not -- just incase.
end


--Adds a check for EVERY PLAYER when the CONVAR is changed
function AdminKillfeedChanged(convar_name, value_old, value_new)
print("The value for tcno_AllowAdminKillfeed has been changed!")
	for _, pp in ipairs(player.GetAll()) do
		if not IsValid(pp) or not pp:IsPlayer() then return 
		else
			newTeamChange(pp, pp:Team(), pp:Team())
		end --Checks if is a valid player, before continuing.
	end
end
cvars.AddChangeCallback( "tcno_AllowAdminKillfeed", AdminKillfeedChanged )


print("===============")
print("Succesfully loaded TCNO Killfeed Hide")
print("===============")