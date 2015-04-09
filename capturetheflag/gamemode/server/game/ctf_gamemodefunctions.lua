function GMatch:ClearFlagCarriers( )
	for index, ply in ipairs ( player.GetAll( ) ) do
		if ( ply.isCarryingFlag ) then
			SafeRemoveEntity( ply.isCarryingFlag )
			ply.isCarryingFalse = false
		end
	end
end

function GMatch:ToggleFlagBases( bool )
	for index, base in ipairs ( ents.FindByClass( "flag_base" ) ) do
		base:ToggleFlagStatus( bool )
	end
end

function GMatch:SpawnFlagBases( )
	for index, spawnPoint in ipairs ( self.Config.FlagBaseSpawns ) do
		if ( #ents.FindByClass( "flag_base" ) == self.Config.MaxTeamAmount ) then break end
		local flagBase = ents.Create( "flag_base" )
		flagBase:SetPos( spawnPoint )
		flagBase:Spawn( )
		flagBase:Activate( )
	end
end

function GMatch:AssignFlagBaseTeams( teamOne, teamTwo )
	local flagBases = ents.FindByClass( "flag_base" )
	for index, flagBase in ipairs ( flagBases ) do
		if ( team.NumPlayers( index ) == 0 ) then
			flagBase:ChangeFlagTeam( 1001 )
			flagBase:ToggleFlagStatus( false )
		else
			flagBase:ChangeFlagTeam( index )
		end
	end
end

function GMatch:ResetTeamScores( )
	local teamTable = { }
	for index, teamTbl in pairs ( team.GetAllTeams( ) ) do
		teamTable[index] = 0
	end
	self:SetGameVar( "CurrentScores", teamTable, true )
end