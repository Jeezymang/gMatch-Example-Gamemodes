
hook.Add( "OnWeaponLoadout", "GMatch:GunGame_OnWeaponLoadout", function( ply, wepTbl ) 
	return ( ply:GetLoadout( ) )
end )

hook.Add( "OnBeginRound", "GMatch:GunGame_OnBeginRound", function( )
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetFrags( 0 )
		ply:SetDeaths( 0 )
		ply:SetLevel( 1 )
	end
	GMatch:RespawnPlayers( )
end )

hook.Add( "OnRoundCheckWinner", "GMatch:GunGame_OnRoundCheckWinner", function( )
	local scoresTable = { }
	for index, ply in ipairs ( player.GetAll( ) ) do
		scoresTable[ply:EntIndex( )] = ply:Frags( )
	end
	local winningPlayer = table.GetWinningKey( scoresTable )
	if ( winningPlayer ) then
		return ( Entity( tonumber( winningPlayer ) ) )
	end
end )

hook.Add( "PlayerDeath", "GMatch:GunGame_PlayerDeath", function( victim, inflictor, attacker )
	local winningScore = GMatch.Config.WinningLevel
	if ( IsValid( attacker ) and attacker:IsPlayer( ) and attacker:GetLevel( ) >= winningScore ) then
		GMatch:FinishRound( attacker )
	elseif ( IsValid( attacker ) and attacker:IsPlayer( ) ) then
		attacker:SetLevel( attacker:GetLevel( ) + 1 )
		attacker:DisplayNotify( "You have reached Level " .. attacker:GetLevel( ) .. "!", 5, "icon16/lightning.png", nil, nil, true )
		attacker:GiveCurrentPrimaryAmmo( math.random( 25 ) )
		attacker:GiveLoadout( attacker:GetLoadout( true ) )
	end
end )