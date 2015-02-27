GMatch.Config.RoundLength = 300
GMatch.Config.ScoreToWin = 10
GMatch.Config.FlagBaseSpawns = { Vector( 753, -937, -141 ), Vector( 714, 542, -141 ), Vector( 19, -919, -141 ), Vector( -851, -1548, -141 ) }

GMatch.Config.ScoreboardLabels = {
	{
		text = "Name",
		offset = 0.05,
		valueFunc = function( ply )
			return ( ply:Nick( ) )
		end,
		isCentered = false
	},
	{
		text = "Captures",
		offset = 0.35,
		valueFunc = function( ply )
			return ( ply:GetPlayerVar( "FlagCaptures", 0 ) )
		end,
		isCentered = true
	},
	{
		text = "Returns",
		offset = 0.45,
		valueFunc = function( ply )
			return ( ply:GetPlayerVar( "FlagReturns", 0 ) )
		end,
		isCentered = true
	},
	{
		text = "Kills",
		offset = 0.55,
		valueFunc = function( ply )
			return ( ply:Frags( ) )
		end,
		isCentered = true
	},
	{
		text = "Deaths",
		offset = 0.65,
		valueFunc = function( ply )
			return ( ply:Deaths( ) )
		end,
		isCentered = true
	},
	{
		text = "Ping",
		offset = 0.75,
		valueFunc = function( ply )
			return ( ply:Ping( ) )
		end,
		isCentered = true
	}
}

GMatch.Config.ScoreboardSort = function( )
	local sortedTeamList = { }
	local currentScores = GMatch:GetGameVar( "CurrentScores", { } )
	for index, teamTable in ipairs ( team.GetAllTeams( ) ) do
		table.insert( sortedTeamList, { teamIndex = index, teamScore = currentScores[index] or 0 } )
	end
	table.SortByMember( sortedTeamList, "teamScore", false )
	local sortedPlayerList = { }
	for index, teamTable in ipairs ( sortedTeamList ) do
		for index, ply in ipairs ( team.GetPlayers( teamTable.teamIndex ) ) do
			table.insert( sortedPlayerList, { ply = ply } )
		end
	end
	for index, ply in ipairs ( team.GetPlayers( 1001 ) ) do
		table.insert( sortedPlayerList, { ply = ply } )
	end
	return sortedPlayerList
end