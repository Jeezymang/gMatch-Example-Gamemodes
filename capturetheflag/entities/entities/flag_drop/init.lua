AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize( )
	self:SetModel( "models/items/jeezy/flag.mdl" ) 
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local physObj = self:GetPhysicsObject( )
	if ( physObj and physObj:IsValid( ) ) then
		physObj:Wake( )
		physObj:EnableMotion( false )
	end
	self.homeBase = nil
	self.flagTeam = 1001
	timer.Simple( GMatch.Config.FlagAutoReturnTime or 15, function( )
		if not ( IsValid( self ) ) then return end
		hook.Call( "FlagAutoReturned", GAMEMODE, self.flagTeam, self.homeBase, self )
		self.homeBase:ToggleFlagStatus( true )
		SafeRemoveEntity( self )
	end )
end

function ENT:SetHomeBase( base )
	self.homeBase = base
	self.flagTeam = base.flagTeam
	self:SetColor( team.GetColor( base.flagTeam ) )
end

function ENT:Touch( ent )
	if not ( ent:IsPlayer( ) ) then return end
	if ( ent:Team( ) == self.flagTeam ) then
		hook.Call( "PlayerReturnedFlag", GAMEMODE, ent, self.flagTeam, self.homeBase, self )
		self.homeBase:ToggleFlagStatus( true )
		SafeRemoveEntity( self )
	elseif ( !IsValid( ent.isCarryingFlag ) ) then
		hook.Call( "PlayerPickedUpDroppedFlag", GAMEMODE, ent, ent:Team( ), self.flagTeam, self.homeBase, self )
		print( team.GetName( self.homeBase.flagTeam ) )
		ent:GiveFlag( self.homeBase )
		SafeRemoveEntity( self )
	end
end

// Hacky and potentially expensive way to make the flag appear it's moving with the wind.
// Basically it's just supposed to shake the jigglebones a little bit.
function ENT:Think( )
	if ( self:GetAngles( ) ~= self.oldAngles ) then
		self:SetAngles( self.oldAngles or self:GetAngles( ) )
		self.oldAngles = self:GetAngles( )
	else
		self.oldAngles = self:GetAngles( )
		local newAngles = self:GetAngles( )
		newAngles:RotateAroundAxis( newAngles:Up( ), math.random( 5, 15 ) )
		self:SetAngles( newAngles )
	end
	self:NextThink( CurTime( ) + 1 )
end
