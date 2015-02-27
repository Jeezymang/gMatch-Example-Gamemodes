ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Flag Base"
ENT.Author = "Jeezy"
ENT.Spawnable = false
ENT.AdminSpawnable = true
ENT.Model = "models/items/jeezy/flag.mdl"

function ENT:SetupDataTables( )
	self:NetworkVar( "Int", 0, "FlagTeam")
end

function ENT:Initialize( )
	hook.Add( "PreDrawHalos", "CaptureTheFlag_DrawFlagBaseHalo:" .. self:EntIndex( ), function( )
		local teamColor = team.GetColor( self:GetFlagTeam( ) )
		halo.Add( { self }, teamColor, 5, 5, 2 )
	end )
end

function ENT:OnRemove( )
	hook.Remove( "PreDrawHalos", "CaptureTheFlag_DrawFlagBaseHalo:" .. self:EntIndex( ) )
end 