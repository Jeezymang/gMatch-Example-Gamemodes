include( "shared.lua" )

function ENT:Draw( )
	self:SetColor( team.GetColor( self:GetCaptureBaseTeam( ) ) )
	self:DrawModel( )
	local angSinWave = math.sin( CurTime( ) * 0.5 ) * 360
	local scaleSinWave = math.sin( CurTime( ) * 2 ) * 0.25
	local alphaSinWav = math.abs( math.sin( CurTime( ) * 4 ) * 0.25 )
	local capTeamColor = team.GetColor( self:GetCapturingTeam( ) )
	if ( IsValid( self:GetRingEntityOne( ) ) ) then
		render.SetBlend( 0.75 - alphaSinWav )
		local ringEntityOne = self:GetRingEntityOne( )
		local curAngles = ringEntityOne:GetAngles( )
		ringEntityOne:SetAngles( Angle( 0, angSinWave, 0 ) )
		ringEntityOne:SetRenderMode( RENDERMODE_TRANSALPHA )
		render.SetColorModulation( capTeamColor.r/255, capTeamColor.g/255, capTeamColor.b/255 )
		ringEntityOne:SetColor( Color( capTeamColor.r, capTeamColor.g, capTeamColor.b, 45 ) )
		local ringOneMatrix = Matrix( )
		ringOneMatrix:Scale( Vector( 1, 1, 0.5 + scaleSinWave ) )
		ringEntityOne:EnableMatrix( "RenderMultiply", ringOneMatrix )
		ringEntityOne:DrawModel( )
		render.SetBlend( 1 )
	end
	if ( IsValid( self:GetRingEntityTwo( ) ) ) then
		render.SetBlend( 0.75 - alphaSinWav )
		local ringEntityTwo = self:GetRingEntityTwo( )
		local angSinWave = math.sin( CurTime( ) * 0.5 ) * 360
		local curAngles = ringEntityTwo:GetAngles( )
		ringEntityTwo:SetAngles( Angle( 0, 180 + angSinWave, 0 ) )
		ringEntityTwo:SetRenderMode( RENDERMODE_TRANSALPHA )
		render.SetColorModulation( capTeamColor.r/255, capTeamColor.g/255, capTeamColor.b/255 )
		ringEntityTwo:SetColor( Color( capTeamColor.r, capTeamColor.g, capTeamColor.b, 45 ) )
		local ringTwoMatrix = Matrix()
		ringTwoMatrix:Scale( Vector( 1, 1, 0.5 + scaleSinWave ) )
		ringEntityTwo:EnableMatrix( "RenderMultiply", ringTwoMatrix )
		ringEntityTwo:DrawModel( )
		render.SetBlend( 1 )
	end
end