hook.Add( "Initialize", "GMatch:LMS_Initialize", function( )
	local teamTable = {
		{ name = "Zombie", col = Color( 125, 45, 45 ) },
		{ name = "Survivor", col = Color( 45, 45, 125 ) }
	}
	GMatch:CreateTeams( teamTable )
end )

function GM:OnWeaponLoadout( ply, wepTbl ) 
	local teamName = team.GetName( ply:Team( ) )
	if ( teamName == "Zombie" ) then
		return { "weapon_crowbar" }
	elseif ( teamName == "Survivor" ) then
		return { "weapon_shotgun", "weapon_pistol" }
	end
end

function GM:OnBeginRound( )
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetFrags( 0 )
		ply:SetDeaths( 0 )
	end
	local onePercent = math.ceil( #player.GetAll( ) * 0.1 )
	for index, ply in ipairs ( player.GetAll( ) ) do
		ply:SetTeam( 2 )
	end
	for i = 1, onePercent do
		local shuffledPlayers = table.Shuffle( player.GetAll( ) )
		shuffledPlayers[i]:SetTeam( 1 )
	end
	GMatch:RespawnPlayers( )
end

function GM:OnRoundCheckWinner( )
	if ( #team.GetPlayers( 1 ) == 0 ) then
		return 2
	elseif ( #team.GetPlayers( 2 ) == 0 ) then
		return 1
	elseif ( #team.GetPlayers( 1 ) > #team.GetPlayers( 2 ) ) then
		return 1
	elseif ( #team.GetPlayers( 2 ) > #team.GetPlayers( 1 ) ) then
		return 2
	end
end

function GM:OnPlayerSetModel( ply, model )
	local zombiePlayerModels = { "zombiefast", "zombie", "zombine" }
	if ( team.GetName( ply:Team( ) ) == "Zombie" ) then
		return ( player_manager.TranslatePlayerModel( zombiePlayerModels[ math.random( #zombiePlayerModels ) ] ) )
	end
end

function GM:OnPlayerAssignTeam( )
	local desiredTeam = GMatch:GetSmallestTeam( )
	return ( desiredTeam )
end

hook.Add( "PlayerDeath", "GMatch:LMS_PlayerDeath", function( victim, inflictor, attacker )
	if ( IsValid( attacker ) and attacker:IsPlayer( ) ) then
		local teamName = team.GetName( attacker:Team( ) )
		local victimTeamName = team.GetName( victim:Team( ) )
		if ( teamName == "Zombie" and victimTeamName ~= "Zombie" ) then
			victim:SetTeam( 1 )
			attacker:DisplayNotify( "You have infected " .. victim:Name( ) .. "!", 5, "icon16/error.png", nil, nil, true )
			if ( #team.GetPlayers( 2 ) == 0 ) then
				GMatch:FinishRound( 1 )
			end
		end
	end
end )