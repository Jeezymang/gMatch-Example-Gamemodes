AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize( )
	self:SetModel( "models/items/jeezy/flag.mdl" ) 
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.homeBase = nil
	self.flagTeam = 1001
end

function ENT:SetHomeBase( base )
	self.homeBase = base
	self.flagTeam = base.flagTeam
	self:SetFlagTeam( base.flagTeam )
end