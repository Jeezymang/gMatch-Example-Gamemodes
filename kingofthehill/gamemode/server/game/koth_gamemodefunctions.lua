function GMatch:AssignCaptureBaseTeams( )
	local capBases = ents.FindByClass( "capture_base" )
	for index, capBase in ipairs ( capBases ) do
		capBase.playerCapturing = nil
		if ( team.NumPlayers( index ) == 0 ) then
			capBase:ChangeBaseTeam( 1001 )
		else
			capBase:ChangeBaseTeam( index )
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