function GM:OnBeginRound( )
	local teamAmount = #ents.FindByClass( "capture_base" )
	if ( teamAmount >= #GMatch.Config.DefaultTeams ) then 
		teamAmount = GMatch.Config.DefaultTeams 
	end
	GMatch:GenerateTeams( teamAmount )
	GMatch:AssignTeams( )
	GMatch:AssignCaptureBaseTeams( )
	GMatch:ResetTeamScores( )
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetPlayerVar( "PointsScored", 0, true )
	end
	GMatch:RespawnPlayers( )
end

function GM:OnTeamScoredPoints( plyTeam, oldScore, currentPoints, plyCapturer )
	if ( currentPoints >= GMatch.Config.ScoreToWin ) then
		GMatch:FinishRound( plyTeam )
	else
		local currentScores = GMatch:GetGameVar( "CurrentScores", { } )
		GMatch:DidTeamGainLead( plyTeam, oldScore, currentPoints, function( teamIndex ) return ( currentScores[ teamIndex ] or 0 ) end )
		GMatch:BroadcastCenterMessage( plyCapturer:Name( ) .. " has scored " .. GMatch.Config.PointRewardAmount .. " points for the " .. team.GetName( plyTeam ) .. " Team!", 4, team.GetColor( plyTeam ) )
	end
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

function GM:OnPlayerAssignTeam( )
	local desiredTeam = GMatch:GetSmallestTeam( )
	return ( desiredTeam )
end

/*hook.Add( "PlayerDeath", "GMatch:DM_PlayerDeath", function( victim, inflictor, attacker )
end )*/