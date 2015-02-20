ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Holdable Flag"
ENT.Author = "Jeezy"
ENT.Spawnable = false
ENT.AdminSpawnable = true

function ENT:SetupDataTables( )
	self:NetworkVar( "Entity", 0, "PlayerParent")
	self:NetworkVar( "Int", 0, "FlagTeam" )
end
