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