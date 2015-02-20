local plyMeta = FindMetaTable( "Player" )

function plyMeta:GiveFlag( homeBase )
	local carryFlag = ents.Create( "flag_carry" )
	local pos, ang = self:GetPos( ), self:GetAngles( )
	carryFlag:SetPos( pos )
	carryFlag:SetAngles( ang )
	carryFlag:SetOwner( self )
	carryFlag:SetParent( self )
	carryFlag:Spawn( )
	carryFlag:Activate( )
	carryFlag:SetPlayerParent( self )
	carryFlag:SetHomeBase( homeBase )
	self.isCarryingFlag = carryFlag
end

function plyMeta:DropFlag( killer )
	local enemyFlag = self.isCarryingFlag
	if not ( IsValid( enemyFlag ) ) then return end
	local enemyFlagBase = enemyFlag.homeBase
	hook.Call( "PlayerDroppedFlag", GAMEMODE, self, self:Team( ), killer, enemyFlag.flagTeam, enemyFlag )
	SafeRemoveEntity( enemyFlag )
	local midPlayerHeight = self:OBBMaxs( )
	midPlayerHeight:Mul( 0.6 )
	local traceData = { }
	traceData.start = self:GetPos( )
	traceData.endpos = self:GetPos( ) - Vector( 0, 0, 16000 ) -- Drops as low as possible.
	traceData.filter = self
	local traceRes = util.TraceLine( traceData )
	local droppedFlag = ents.Create( "flag_drop" )
	droppedFlag:SetPos( traceRes.HitPos + midPlayerHeight )
	droppedFlag:Spawn( )
	droppedFlag:Activate( )
	droppedFlag:SetHomeBase( enemyFlagBase )
end