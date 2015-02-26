GMatch.Config.RoundLength = 300
GMatch.Config.SpectateTeamOnly = false
GMatch.Config.Levels = {
	[1] = { "weapon_357" },
	[2] = { "weapon_pistol" },
	[5] = { "weapon_smg1" },
	[8] = { "weapon_shotgun" },
	[11] = { "weapon_ar2" },
	[13] = { "weapon_frag" },
	[15] = { "weapon_crowbar" }
}
GMatch.Config.WinningLevel = 15
GMatch.Config.NetworkVars = {
	["Level"] = "Int"
}

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
		text = "Level",
		offset = 0.45,
		valueFunc = function( ply )
			return ( ply:GetPlayerVar( "Level", 1 ) )
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
	local sortedPlayerList = { }
	for index, ply in ipairs ( player.GetAll( ) ) do
		table.insert( sortedPlayerList, { ply = ply, plyLevel = ply:GetPlayerVar( "Level", 0 ) } )
	end
	table.SortByMember( sortedPlayerList, "plyLevel" )
	return sortedPlayerList
end