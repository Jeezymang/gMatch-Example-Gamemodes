local plyMeta = FindMetaTable( "Player" )

function plyMeta:GetLoadout( ignorePrevious )
	local level = self:GetPlayerVar( "Level", 1 )
	if not ( GMatch.Config.Levels[level] ) then
		if ( ignorePrevious ) then return { } end
		for i = 1, GMatch.Config.WinningLevel do
			local wepLoadout = GMatch.Config.Levels[level - i]
			if ( wepLoadout ) then
				return ( wepLoadout ) 
			end
		end
	else
		return ( GMatch.Config.Levels[ level ] )
	end
	return { }
end

function plyMeta:GiveLoadout( wepTable )
	for index, wep in ipairs ( wepTable ) do
		self:Give( wep )
	end
end