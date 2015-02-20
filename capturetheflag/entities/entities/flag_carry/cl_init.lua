include("shared.lua")

function ENT:Draw( )
	if not ( self.flagModel ) then
		self.flagModel = ClientsideModel( "models/items/jeezy/flag.mdl", RENDERMODE_TRANSCOLOR )
	else
		local ply = self:GetPlayerParent( )
	    local spineBone = ply:LookupBone("ValveBiped.Bip01_Spine2")
	    local pos, ang = ply:GetPos( ), ply:GetAngles( )
		if spineBone then
			pos, ang = ply:GetBonePosition( spineBone ) 
		end
		self.flagModel:SetColor( team.GetColor( self:GetFlagTeam( ) ) )
		ang:RotateAroundAxis( ang:Right( ), 270 )
		ang:RotateAroundAxis( ang:Up( ), 180 )
		self.flagModel:SetPos( pos + ( ang:Up( ) * 30 ) + ( ang:Right( ) * -5 ) + ( ang:Forward( ) * 0 ) )
		self.flagModel:SetAngles( ang )
		if ( ply == LocalPlayer( ) and !ply:ShouldDrawLocalPlayer( ) ) then
			self.flagModel:SetNoDraw( true )
		else
			self.flagModel:SetNoDraw( false )
		end
	end
end

function ENT:OnRemove( )
	if ( IsValid( self.flagModel ) ) then
		SafeRemoveEntity( self.flagModel )
	end
end