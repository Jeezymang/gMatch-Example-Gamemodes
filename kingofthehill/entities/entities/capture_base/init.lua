AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize( )
	self:SetModel("models/hunter/tubes/circle4x4.mdl" ) 
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetAngles( Angle( 0, 0, 0 ) )
	self:SetMaterial( "models/player/shared/ice_player" )
	local physObj = self:GetPhysicsObject( )
	if ( physObj and physObj:IsValid( ) ) then
		physObj:Wake( )
		physObj:EnableMotion( false )
	end
	self:CreateRingEntities( )
	self:SetCaptureBaseTeam( 1001 )
	self:SetCapturingTeam( 1001 )
	timer.Create( "CheckBaseCapturer_" .. self:EntIndex( ), 5, 0, function( )
		if ( self:GetCaptureBaseTeam( ) ~= self:GetCapturingTeam( ) and !IsValid( self.playerCapturing ) ) then
			self.playerCapturing = nil
			self.beginCaptureTime = nil
			self:SetCapturingTeam( self:GetCaptureBaseTeam( ) )
		end
	end )
end

function ENT:CreateRingEntities( )
	self.ringEntityOne = ents.Create( "prop_physics" )
	self.ringEntityOne:SetModel( "models/props_lab/teleportring.mdl" )
	self.ringEntityOne:SetPos( self:GetPos( ) + ( self:GetAngles( ):Up( ) * 15 ) )
	local newAngles = self:GetAngles( )
	newAngles:RotateAroundAxis( newAngles:Right( ), 0 )
	self.ringEntityOne:SetAngles( newAngles )
	self.ringEntityOne:Spawn( )
	self.ringEntityOne:Activate( )
	local ringPhysOne = self.ringEntityOne:GetPhysicsObject( )
	if ( ringPhysOne and ringPhysOne:IsValid( ) ) then
		ringPhysOne:Wake( )
		ringPhysOne:EnableMotion( false )
	end
	self.ringEntityOne:SetParent( self )
	self.ringEntityOne:SetNotSolid( true )
	--self.ringEntityOne:SetMaterial( "models/props_combine/portalball001_sheet" )
	self.ringEntityOne:SetModelScale( 3, 0 )
	self:SetRingEntityOne( self.ringEntityOne )
	self.ringEntityTwo = ents.Create( "prop_physics" )
	self.ringEntityTwo:SetModel( "models/props_lab/teleportring.mdl" )
	self.ringEntityTwo:SetPos( self:GetPos( ) + ( self:GetAngles( ):Up( ) * 15.5 ) )
	local newAngles = self:GetAngles( )
	newAngles:RotateAroundAxis( newAngles:Right( ), 180 )
	self.ringEntityTwo:SetAngles( newAngles )
	self.ringEntityTwo:Spawn( )
	self.ringEntityTwo:Activate( )
	local ringPhysTwo = self.ringEntityTwo:GetPhysicsObject( )
	if ( ringPhysTwo and ringPhysTwo:IsValid( ) ) then
		ringPhysTwo:Wake( )
		ringPhysTwo:EnableMotion( false )
	end
	self.ringEntityTwo:SetParent( self )
	self.ringEntityTwo:SetNotSolid( true )
	--self.ringEntityTwo:SetMaterial( "models/props_combine/portalball001_sheet" )
	self.ringEntityTwo:SetModelScale( 3, 0 )
	self:SetRingEntityTwo( self.ringEntityTwo )
end

function ENT:StartTouch( ent )
	if not ( ent:IsPlayer( ) ) then return end
	if ( self:GetCaptureBaseTeam( ) == 1001 ) then return end
	if not ( GMatch:IsRoundActive( ) ) then
		timer.Destroy( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ) )
		self.playerCapturing = nil
		self:SetCapturingTeam( self:GetCaptureBaseTeam( ) )
	end
	if ( timer.Exists( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ) ) ) then
		timer.Destroy( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ) )
		return
	end
	if ( IsValid( self.playerCapturing ) ) then return end
	if ( self:GetCaptureBaseTeam( ) == ent:Team( ) ) then return end
	self.playerCapturing = ent
	self.beginCaptureTime = CurTime( )
	self:SetCapturingTeam( ent:Team( ) )
end

function ENT:EndTouch( ent )
	if not ( ent:IsPlayer( ) ) then return end
	if ( self:GetCaptureBaseTeam( ) == 1001 ) then return end
	if not ( GMatch:IsRoundActive( ) ) then
		timer.Destroy( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ) )
		self.playerCapturing = nil
		self:SetCapturingTeam( self:GetCaptureBaseTeam( ) )
	end
	if ( self:GetCaptureBaseTeam( ) == ent:Team( ) ) then return end
	if ( self.playerCapturing == ent ) then
		if not ( timer.Exists( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ) ) ) then
			timer.Create( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ), GMatch.Config.BaseRevertTime, 1, function( )
				self.playerCapturing = nil
				self.beginCaptureTime = nil
				self:SetCapturingTeam( self:GetCaptureBaseTeam( ) )
			end )
		end
	end
end

function ENT:Touch( ent )
	if not ( ent:IsPlayer( ) ) then return end
	if ( self:GetCaptureBaseTeam( ) == 1001 ) then return end
	if not ( GMatch:IsRoundActive( ) ) then
		timer.Destroy( "BaseTeamRevert_" .. ent:EntIndex( ) .. "_" .. self:EntIndex( ) )
		self.playerCapturing = nil
		self:SetCapturingTeam( self:GetCaptureBaseTeam( ) )
	end
	if not ( IsValid( self.playerCapturing ) ) then
		if not ( self:GetCaptureBaseTeam( ) == ent:Team( ) ) then
			self.playerCapturing = ent
			self.beginCaptureTime = CurTime( )
			self:SetCapturingTeam( ent:Team( ) )
		end
	elseif ( self.playerCapturing == ent ) then
		if not ( self.beginCaptureTime ) then return end
		local currentCapTime = CurTime( ) - self.beginCaptureTime
		local pointInterval = GMatch.Config.PointRewardInterval
		if ( math.Round( currentCapTime ) % pointInterval == 0 and currentCapTime > pointInterval - 1 ) then
			self.nextScoreTime = self.nextScoreTime or 0
			if ( self.nextScoreTime < CurTime( ) ) then
				local plyTeam = self.playerCapturing:Team( )
				local currentScores = GMatch:GetGameVar( "CurrentScores", { } )
				local pointRewardAmount = GMatch.Config.PointRewardAmount
				currentScores[ plyTeam ] = currentScores[ plyTeam ] or 0
				local oldScore = currentScores[ plyTeam ]
				currentScores[ plyTeam ] = currentScores[ plyTeam ] + pointRewardAmount
				GMatch:SetGameVar( "CurrentScores", currentScores, true )
				self.playerCapturing:SetPlayerVar( "PointsScored", self.playerCapturing:GetPlayerVar( "PointsScored", 0 ) + pointRewardAmount, true )
				hook.Call( "OnTeamScoredPoints", GAMEMODE, plyTeam, oldScore, currentScores[ plyTeam ], self.playerCapturing )
				self.nextScoreTime = CurTime( ) + 1
			end
		end
	end
end

function ENT:ChangeBaseTeam( enum )
	self.baseTeam = enum
	self:SetCaptureBaseTeam( enum )
	self:SetCapturingTeam( enum )
end

function ENT:OnRemove( )
	if not ( IsValid( self.ringEntity ) ) then return end
	timer.Destroy( "CheckBaseCapturer_" .. self:EntIndex( ) )
	SafeRemoveEntity( self.ringEntity )
end