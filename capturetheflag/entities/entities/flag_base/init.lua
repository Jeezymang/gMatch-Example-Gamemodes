AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize( )
	self:SetModel("models/props_trainstation/trainstation_clock001.mdl" ) 
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetAngles( Angle( -90, 0, 0 ) )
	self:SetMaterial( "models/player/shared/ice_player" )
	local physObj = self:GetPhysicsObject( )
	if ( physObj and physObj:IsValid( ) ) then
		physObj:Wake( )
		physObj:EnableMotion( false )
	end
	self:SetFlagTeam( 1001 )
	self.flagTeam = 1001
	self.flagAtBase = true
	self:CreateFlagEntity( )
end

function ENT:CreateFlagEntity( )
	self.flagEntity = ents.Create( "prop_physics" )
	self.flagEntity:SetModel( "models/items/jeezy/flag.mdl" )
	self.flagEntity:SetPos( self:GetPos( ) + ( self:GetAngles( ):Forward( ) * 48 ) )
	local newAngles = self:GetAngles( )
	newAngles:RotateAroundAxis( newAngles:Right( ), 270 )
	self.flagEntity:SetAngles( newAngles )
	self.flagEntity:Spawn( )
	self.flagEntity:Activate( )
	local flagPhys = self.flagEntity:GetPhysicsObject( )
	if ( flagPhys and flagPhys:IsValid( ) ) then
		flagPhys:Wake( )
		flagPhys:EnableMotion( false )
	end
	self.flagEntity:SetParent( self )
	self.flagEntity:SetNotSolid( true )
	self.flagEntity:SetColor( team.GetColor( self.flagTeam ) )
end

function ENT:ToggleFlagStatus( status )
	if not ( status ) then
		self.flagEntity:SetNoDraw( true )
		self.flagEntity:DrawShadow( false )
		self.flagAtBase = false
	else
		self.flagEntity:SetNoDraw( false )
		self.flagEntity:DrawShadow( true )
		self.flagAtBase = true
	end
end

function ENT:ChangeFlagTeam( enum )
	self.flagTeam = enum
	self.flagEntity:SetColor( team.GetColor( enum ) )
	self:SetFlagTeam( enum )
end

function ENT:Touch( ent )
	if not ( ent:IsPlayer( ) ) then return end
	self.nextTouch = self.nextTouch or 0 // Added this part so the code below doesn't get called multiple times.
	if ( self.nextTouch > CurTime( ) ) then return end
	self.nextTouch = CurTime( ) + 1
	if ( ent:Team( ) == self.flagTeam ) then
		if ( self.flagAtBase and IsValid( ent.isCarryingFlag ) ) then
			local enemyFlag = ent.isCarryingFlag
			local flagBase = enemyFlag.homeBase
			flagBase:ToggleFlagStatus( true )
			hook.Call( "PlayerCapturedFlag", GAMEMODE, ent, ent:Team( ), enemyFlag.flagTeam, self, flagBase )
			ent.isCarryingFlag = nil
			SafeRemoveEntity( enemyFlag )
		end
	else
		if ( self.flagAtBase and !IsValid( ent.isCarryingFlag ) ) then
			hook.Call( "PlayerPickedUpFlag", GAMEMODE, ent, ent:Team( ), self.flagTeam, self )
			self:ToggleFlagStatus( false )
			ent:GiveFlag( self )
		end
	end
end

// Hacky and potentially expensive way to make the flag appear it's moving with the wind.
// Basically it's just supposed to shake the jigglebones a little bit.
function ENT:Think( )
	if ( self.flagEntity:GetAngles( ) ~= self.flagEntity.oldAngles ) then
		self.flagEntity:SetAngles( self.flagEntity.oldAngles or self.flagEntity:GetAngles( ) )
		self.flagEntity.oldAngles = self.flagEntity:GetAngles( )
	else
		self.flagEntity.oldAngles = self.flagEntity:GetAngles( )
		local newAngles = self.flagEntity:GetAngles( )
		newAngles:RotateAroundAxis( newAngles:Up( ), math.random( 5, 15 ) )
		self.flagEntity:SetAngles( newAngles )
	end
	self:NextThink( CurTime( ) + 1 )
end

function ENT:OnRemove( )
	if not ( IsValid( self.flagEntity ) ) then return end
	SafeRemoveEntity( self.flagEntity )
end