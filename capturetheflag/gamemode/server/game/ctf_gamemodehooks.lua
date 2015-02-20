GM = GM or GAMEMODE
function GM:PlayerCapturedFlag( ply, plyTeam, flagTeam, plyTeamBase, flagTeamBase )
	local teamName = team.GetName( flagTeam )
	PrintMessage( HUD_PRINTCENTER, ply:Name( ) .. " has captured the " .. teamName .. " Team's flag!" )
	local currentScores = GMatch:GetGameVar( "CurrentScores", { } )
	local currentScore = currentScores[ plyTeam ] or 0
	currentScore = currentScore + 1
	currentScores[ plyTeam ] = currentScore
	GMatch:SetGameVar( "CurrentScores", currentScores, true )
	local scoreToWin = GMatch.Config.ScoreToWin
	if ( currentScore >= scoreToWin ) then
		local toDo = hook.Run( "TeamWonMatch", ply, plyTeam ) // Gonna make the return value do something later.
	end
end

function GM:PlayerPickedUpFlag( ply, plyTeam, flagTeam, flagTeamBase )
	local teamName = team.GetName( flagTeam )
	PrintMessage( HUD_PRINTCENTER, ply:Name( ) .. " has picked up the ".. teamName .. " Team's flag!" )
end

function GM:PlayerDroppedFlag( ply, plyTeam, killer, flagTeam, flag )
	local teamName = team.GetName( flagTeam )
	PrintMessage( HUD_PRINTCENTER, ply:Name( ) .. " has dropped the " .. teamName .. " Team's flag!" )
end

function GM:PlayerPickedUpDroppedFlag( ply, plyTeam, flagTeam, flagTeamBase, flag )
	local teamName = team.GetName( flagTeam )
	PrintMessage( HUD_PRINTCENTER, ply:Name( ) .. " has picked up the " .. teamName ..  " Team's flag!" )
end

function GM:PlayerReturnedFlag( ply, plyTeam, flagTeamBase, flag )
	local teamName = team.GetName( plyTeam )
	PrintMessage( HUD_PRINTCENTER, ply:Name( ) .. " has returned the " .. teamName .. " Team's flag!" )
end

function GM:TeamWonMatch( winningCapture, winningTeam )
	PrintMessage( HUD_PRINTCENTER, team.GetName( winningTeam ) .. " has won the match!" )
	GMatch:FinishRound( winningTeam )
end

function GM:FlagAutoReturned( flagTeam, flagTeamBase, flag )
	local teamName = team.GetName( flagTeam )
	PrintMessage( HUD_PRINTCENTER, "The " .. teamName .. " Team's flag was automatically returned to their base." )
end

hook.Add( "OnBeginRound", "GMatch:CTF_OnBeginRound", function( )
	if ( #ents.FindByClass( "flag_base" ) == 0 ) then
		GMatch:SpawnFlagBases( )
	end
	local teamAmount = #ents.FindByClass( "flag_base" )
	if ( teamAmount >= #GMatch.Config.DefaultTeams ) then 
		teamAmount = GMatch.Config.DefaultTeams 
	end
	GMatch:GenerateTeams( teamAmount )
	GMatch:AssignTeams( )
	GMatch:AssignFlagBaseTeams( )
	GMatch:RespawnPlayers( )
	GMatch:ToggleFlagBases( true )
end )

hook.Add( "OnEndRound", "GMatch:CTF_OnEndRound", function( )
	GMatch:ToggleFlagBases( false )
	GMatch:ClearFlagCarriers( )
end )

hook.Add( "OnFinishRound", "GMatch:CTF_OnEndRound", function( )
	GMatch:ToggleFlagBases( false )
	GMatch:ClearFlagCarriers( )
end )

hook.Add( "PlayerDeath", "GMatch:CTF_PlayerDeath", function( victim, inflictor, attacker )
	if ( victim.isCarryingFlag ) then
		victim:DropFlag( attacker )
	end
end )