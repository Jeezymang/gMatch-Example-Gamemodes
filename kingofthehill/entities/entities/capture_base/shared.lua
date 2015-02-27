ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Capture Base"
ENT.Author = "Jeezy"
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.Model = "models/props_lab/teleportring.mdl"

function ENT:SetupDataTables( )
	self:NetworkVar( "Entity", 0, "RingEntityOne" )
	self:NetworkVar( "Entity", 1, "RingEntityTwo" )
	self:NetworkVar( "Int", 0, "CaptureBaseTeam" )
	self:NetworkVar( "Int", 1, "CapturingTeam" )
end

function ENT:Initialize( )
	hook.Add( "PreDrawHalos", "KingOfTheHill_DrawRingHalo:" .. self:EntIndex( ), function( )
		--local teamColor = team.GetColor( self:GetFlagTeam( ) )
		if not ( IsValid( self:GetRingEntityOne( ) ) ) then return end
		if not ( IsValid( self:GetRingEntityTwo( ) ) ) then return end
		local teamColor = team.GetColor( self:GetCaptureBaseTeam( ) )
		local captureTeamColor = team.GetColor( self:GetCapturingTeam( ) )
		if ( self:GetCaptureBaseTeam( ) == self:GetCapturingTeam( ) ) then
			halo.Add( { self:GetRingEntityOne( ), self:GetRingEntityTwo( ), self }, teamColor, 5, 5, 2 )
		else
			halo.Add( { self:GetRingEntityOne( ), self:GetRingEntityTwo( ) }, captureTeamColor, 5, 5, 2 )
			halo.Add( { self }, teamColor, 5, 5, 2 )
		end
	end )
end

function ENT:OnRemove( )
	hook.Remove( "PreDrawHalos", "KingOfTheHill_DrawRingHalo:" .. self:EntIndex( ) )
end 