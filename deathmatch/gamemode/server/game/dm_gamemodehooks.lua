function GM:OnBeginRound( )
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetFrags( 0 )
		ply:SetDeaths( 0 )
	end
	GMatch:RespawnPlayers( )
end

function GM:OnRoundCheckWinner( )
	local scoresTable = { }
	for index, ply in ipairs ( player.GetAll( ) ) do
		scoresTable[ply:EntIndex( )] = ply:Frags( )
	end
	local winningPlayer = table.GetWinningKey( scoresTable )
	if ( winningPlayer ) then
		return ( Entity( tonumber( winningPlayer ) ) )
	end
end

function GM:OnPlayerSetColor( ply )
	return ( Color( math.random( 255 ), math.random( 255 ), math.random( 255 ) ) )
end

hook.Add( "PlayerDeath", "GMatch:DM_PlayerDeath", function( victim, inflictor, attacker )
	local winningScore = GMatch.Config.ScoreToWin
	if ( IsValid( attacker ) and attacker:IsPlayer( ) and attacker:Frags( ) >= winningScore ) then
		GMatch:FinishRound( attacker )
	end
end )