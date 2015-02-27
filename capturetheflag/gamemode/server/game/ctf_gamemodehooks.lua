function GM:PlayerCapturedFlag( ply, plyTeam, flagTeam, plyTeamBase, flagTeamBase )
	local teamName = team.GetName( flagTeam )
	GMatch:BroadcastCenterMessage( ply:Name( ) .. " has captured the " .. teamName .. " Team's flag!", 4, nil, true, nil )
	local currentScores = GMatch:GetGameVar( "CurrentScores", { } )
	local currentScore = currentScores[ plyTeam ] or 0
	local oldScore, newScore = currentScore, nil
	currentScore = currentScore + 1
	newScore = currentScore
	currentScores[ plyTeam ] = currentScore
	GMatch:DidTeamGainLead( plyTeam, oldScore, newScore, function( teamIndex ) return ( currentScores[ teamIndex ] or 0 ) end )
	GMatch:SetGameVar( "CurrentScores", currentScores, true )
	ply:SetPlayerVar( "FlagCaptures", ply:GetPlayerVar( "FlagCaptures", 0 ) + 1, true )
	local scoreToWin = GMatch.Config.ScoreToWin
	if ( currentScore >= scoreToWin ) then
		hook.Call( "TeamWonMatch", ply, plyTeam )
	end
end

function GM:PlayerPickedUpFlag( ply, plyTeam, flagTeam, flagTeamBase )
	local teamName = team.GetName( flagTeam )
	GMatch:BroadcastCenterMessage( ply:Name( ) .. " has picked up the ".. teamName .. " Team's flag!", 4, nil, true, nil )
end

function GM:PlayerDroppedFlag( ply, plyTeam, killer, flagTeam, flag )
	local teamName = team.GetName( flagTeam )
	GMatch:BroadcastCenterMessage( ply:Name( ) .. " has dropped the " .. teamName .. " Team's flag!", 4, nil, true, nil )
end

function GM:PlayerPickedUpDroppedFlag( ply, plyTeam, flagTeam, flagTeamBase, flag )
	local teamName = team.GetName( flagTeam )
	GMatch:BroadcastCenterMessage( ply:Name( ) .. " has picked up the " .. teamName ..  " Team's flag!", 4, nil, true, nil )
end

function GM:PlayerReturnedFlag( ply, plyTeam, flagTeamBase, flag )
	local teamName = team.GetName( plyTeam )
	GMatch:BroadcastCenterMessage( ply:Name( ) .. " has returned the " .. teamName .. " Team's flag!", 4, nil, true, nil )
	ply:SetPlayerVar( "FlagReturns", ply:GetPlayerVar( "FlagReturns", 0 ) + 1, true )
end

function GM:TeamWonMatch( winningCapture, winningTeam )
	GMatch:BroadcastCenterMessage( "The " .. team.GetName( winningTeam ) .. " Team has won the match!", 4, nil, true, nil )
	GMatch:FinishRound( winningTeam )
end

function GM:FlagAutoReturned( flagTeam, flagTeamBase, flag )
	local teamName = team.GetName( flagTeam )
	GMatch:BroadcastCenterMessage( "The " .. teamName .. " Team's flag was automatically returned to their base.", 4, nil, true, nil )
end

function GM:OnBeginRound( )
	if ( #ents.FindByClass( "flag_base" ) == 0 ) then
		GMatch:SpawnFlagBases( )
	end
	local teamAmount = #ents.FindByClass( "flag_base" )
	if ( teamAmount >= #GMatch.Config.DefaultTeams ) then 
		teamAmount = GMatch.Config.DefaultTeams 
	end
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetPlayerVar( "FlagCaptures", 0, true )
		ply:SetPlayerVar( "FlagReturns", 0, true )
	end
	GMatch:GenerateTeams( teamAmount )
	GMatch:AssignTeams( )
	GMatch:RespawnPlayers( )
	GMatch:ToggleFlagBases( true )
	GMatch:AssignFlagBaseTeams( )
	GMatch:ResetTeamScores( )
end

function GM:OnEndRound( )
	GMatch:ToggleFlagBases( false )	
	GMatch:ClearFlagCarriers( )
	GMatch:ResetTeamScores( )
end

function GM:OnFinishRound( )
	GMatch:ToggleFlagBases( false )
	GMatch:ClearFlagCarriers( )
	GMatch:ResetTeamScores( )
end

function GM:OnPlayerAssignTeam( )
	local desiredTeam = GMatch:GetSmallestTeam( )
	return ( desiredTeam )
end

function GM:OnRoundCheckWinner( )
	local scoresTable = { }
	for teamIndex, score in pairs ( GMatch:GetGameVar( "CurrentScores", { } ) ) do
		table.insert( scoresTable, { teamIndex = teamIndex, score = score } )
	end
	table.SortByMember( scoresTable, "score", false )
	if ( scoresTable[1].score == 0 ) then return end
	return( scoresTable[1].teamIndex )	
end

hook.Add( "PlayerDeath", "GMatch:CTF_PlayerDeath", function( victim, inflictor, attacker )
	if ( victim.isCarryingFlag ) then
		victim:DropFlag( attacker )
	end
end )