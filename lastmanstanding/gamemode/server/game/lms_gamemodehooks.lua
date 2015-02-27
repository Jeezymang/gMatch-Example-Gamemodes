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
	timer.Create( "GMatch_LMS_ZombieSounds", 5, 0, function( )
		local allZombies = team.GetPlayers( 1 )
		if ( #allZombies <= 0 ) then return end
		local rndZombieOne = team.GetPlayers( 1 )[ math.random( #team.GetPlayers( 1 ) )]
		local rndZombieTwo = team.GetPlayers( 1 )[ math.random( #team.GetPlayers( 1 ) )]
		local rndZombieThree = team.GetPlayers( 1 )[ math.random( #team.GetPlayers( 1 ) )]
		local randomRollOne = math.random( 1, 100 )
		local randomRollTwo = math.random( 1, 100 )
		local randomRollThree = math.random( 1, 100 )
		local noiseChance = GMatch.Config.ZombieNoiseChance
		if ( rndZombieOne:Alive( ) and noiseChance <= randomRollOne ) then
			rndZombieOne:EmitSound( "npc/zombie/zombie_voice_idle" .. math.random( 1, 14 ) .. ".wav", 75, math.random( 100, 110 ) )
		end
		if ( rndZombieTwo:Alive( ) and noiseChance <= randomRollTwo and rndZombieTwo ~= rndZombieOne ) then
			rndZombieOne:EmitSound( "npc/zombie/zombie_voice_idle" .. math.random( 1, 14 ) .. ".wav", 75, math.random( 100, 110 ) )
		end
		if ( rndZombieThree:Alive( ) and noiseChance <= randomRollThree and rndZombieThree ~= rndZombieTwo and rndZombieThree ~= rndZombieOne ) then
			rndZombieOne:EmitSound( "npc/zombie/zombie_voice_idle" .. math.random( 1, 14 ) .. ".wav", 75, math.random( 100, 110 ) )
		end
	end )
end

function GM:OnEndRound( )
	timer.Destroy( "GMatch_LMS_ZombieSounds" )
end

function GM:OnFinishRound( )
	timer.Destroy( "GMatch_LMS_ZombieSounds" )
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
			local randomRoll = math.random( 1, 100 )
			local makeNoise = ( GMatch.Config.ZombieNoiseChance <= randomRoll )
			if ( makeNoise ) then
				attacker:EmitSound( "npc/zombie/zombie_die" .. math.random( 1, 3 ) .. ".wav", 75, math.random( 100, 110 ) )
			end
			victim:SetTeam( 1 )
			attacker:DisplayNotify( "You have infected " .. victim:Name( ) .. "!", 5, "icon16/error.png", nil, nil, true )
			if ( #team.GetPlayers( 2 ) == 0 ) then
				GMatch:FinishRound( 1 )
			end
		end
	end
end )