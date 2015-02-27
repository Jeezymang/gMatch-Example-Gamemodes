GMatch.Config.PointRewardAmount = 15
GMatch.Config.PointRewardInterval = 5
GMatch.Config.ScoreToWin = 100
GMatch.Config.BaseRevertTime = 2
GMatch.Config.SpectateTeamOnly = true
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
		text = "Points Scored",
		offset = 0.4,
		valueFunc = function( ply )
			return ( ply:GetPlayerVar( "PointsScored", 0 ) )
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