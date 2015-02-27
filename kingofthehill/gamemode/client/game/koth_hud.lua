local crownMaterial = Material( "gui/crown96x96.png" )
hook.Add( "HUDPaint", "GMatch:KOTH_HUDPaint", function( )
	local currentScores = GMatch:GetGameVar( "CurrentScores", { } )
	local currentIncrement = 0
	for teamIndex, score in pairs ( currentScores ) do
		if ( team.NumPlayers( teamIndex ) == 0 ) then continue end
		local scoreToWin = GMatch.Config.ScoreToWin
		local barHeight = ( score / scoreToWin ) * 128
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		local x, y = 400 + ( currentIncrement * 56.5 ), ScrH( ) - 70
		local rad = -math.rad( 180 )
		local halvedPi = math.pi / 2
		x = x - ( math.sin( rad + halvedPi) * 50 / 2 + math.sin( rad ) * 128 / 2 )
		y = y - ( math.cos( rad + halvedPi ) * 50 / 2 + math.cos( rad ) * 128 / 2 )
		local fillBarColor = team.GetColor( teamIndex )
		fillBarColor = Color( fillBarColor.r, fillBarColor.g, fillBarColor.b, 150 )
		local cornerRound = 12
		if ( score == 0 ) then cornerRound = 0 end
		local heightSin = math.sin( CurTime( ) * 2 ) * 6
		local barMatrix = Matrix( )
		barMatrix:SetAngles(Angle(0, 180, 0))
		barMatrix:SetTranslation(Vector(x, y, 0))
		cam.PushModelMatrix( barMatrix )
			draw.RoundedBox( 12, 0, 0, 50, 128, Color( 45, 45, 45, 125 ) )
			draw.RoundedBox( cornerRound, 0, 0, 50, barHeight + heightSin, fillBarColor )
		cam.PopModelMatrix( )
		render.PopFilterMag( )
		render.PopFilterMin( )
		draw.TexturedRect( 380 + ( currentIncrement * 55 ) + ( currentIncrement * 1.5 ), ScrH( ) - 50, 40, 40, crownMaterial, team.GetColor( teamIndex ):Lighten( 50 )
		 )
		currentIncrement = currentIncrement + 1
	end
end )	