GMatch.Config.ScoreToWin = 20
GMatch.Config.SpectateTeamOnly = false

GMatch.Config.ScoreboardSort = function( )
	local sortedPlayerList = { }
	for index, ply in ipairs ( player.GetAll( ) ) do
		table.insert( sortedPlayerList, { ply = ply, plyScore = ply:Frags( ) } )
	end
	table.SortByMember( sortedPlayerList, "plyScore" )
	return sortedPlayerList
end

GMatch.Config.ScoreboardPlayerRowColor = function( ply )
	return ( ply:GetPlayerColor( ):ToColor( ) )
end

GMatch.Config.TargetIDInfo = {
	{ 
		textFunc = function( ply )
			return ( ply:Name( ) )
		end,
		color = function( ply ) 
			return ( ply:GetPlayerColor( ):ToColor( ) ) 
		end,
		font = "GMatch_Lobster_3D2DMediumBold",
	},
	{
		textFunc = function( ply ) 
			return "KILLING SPREE"
		end,
		color = function( ply )
			return ( util.RainbowStrobe( 2 ) )
		end,
		font = "GMatch_Lobster_3D2DMediumBold",
		shouldDisplay = function( ply )
			return ( ply:GetPlayerVar( "OnKillingSpree", false ) )
		end,
		yOffset = 5
	}
}