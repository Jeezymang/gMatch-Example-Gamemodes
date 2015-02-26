function GM:OnWeaponLoadout( ply, wepTbl ) 
	return ( ply:GetLoadout( ) )
end 

function GM:OnBeginRound( )
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetFrags( 0 )
		ply:SetDeaths( 0 )
		--ply:SetLevel( 1 )
		ply:SetPlayerVar( "Level", 1, true )
	end
	GMatch:RespawnPlayers( )
end

function GM:OnRoundCheckWinner( )
	local scoresTable = { }
	for index, ply in ipairs ( player.GetAll( ) ) do
		scoresTable[ply:EntIndex( )] = ply:GetPlayerVar( "Level", 1 )
	end
	local winningPlayer = table.GetWinningKey( scoresTable )
	if ( winningPlayer ) then
		return ( Entity( tonumber( winningPlayer ) ) )
	end
end

hook.Add( "PlayerDeath", "GMatch:GunGame_PlayerDeath", function( victim, inflictor, attacker )
	local winningScore = GMatch.Config.WinningLevel
	if ( IsValid( attacker ) and attacker:IsPlayer( ) and attacker:GetPlayerVar( "Level", 1 ) >= winningScore ) then
		GMatch:FinishRound( attacker )
	elseif ( IsValid( attacker ) and attacker:IsPlayer( ) ) then
		--attacker:SetLevel( attacker:GetLevel( ) + 1 )
		attacker:SetPlayerVar( "Level", attacker:GetPlayerVar( "Level", 1 ) + 1, true )
		attacker:DisplayNotify( "You have reached Level " .. attacker:GetPlayerVar( "Level", 1 ) .. "!", 5, "icon16/lightning.png", nil, nil, true )
		attacker:GiveCurrentPrimaryAmmo( math.random( 25 ) )
		attacker:GiveLoadout( attacker:GetLoadout( true ) )
	end
end )