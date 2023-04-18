timer.Simple(1, function()
	hook.Remove("PlayerLeaveVehicle", "FixWeaponsInRides")
end)

local Meta = FindMetaTable("Entity")

function Meta:TankExitVehicle()
	if not IsValid(self) then return end
	if not IsValid(self.Pilot) then return end

	if self.HoverRotorWashPoints then
		for i = 1, #self.RotorWashPoints do
			if IsValid(self.RotorWashPoints[i]) then
				TankRemoveHoverDust(self.RotorWashPoints[i])
			end
		end
	end

	CorrectPlayerObject(self.Pilot)
	-- self.Pilot:ConCommand( "jet_cockpitview 0" )
	-- self.Pilot.ClientVector = nil
	-- self.Pilot:SetColor(Color( 255, 255, 255, 255 ) )
	self:SetNetworkedEntity("Pilot", NULL)

	if self.TowerSound then
		self.TowerSound:Stop()
	end

	if self.Flamethrower then
		self.Flamethrower:StopParticles()
		self.IsBurning = false
		self.FlameTime = 0
	end

	self:SetNetworkedBool("IsStarted", false)

	for i = 1, #self.EngineMux do
		self.EngineMux[i]:Stop()
	end

	if self.HasCVol then
		self.CEngSound:Stop()
	end

	--[[ uncomment this if you want headlights to turn off when you exit the tank.
	if(type(self.HeadLights) == "table"	&& GetConVarNumber( "tank_allowheadlights", 0) > 0) then

		for i=1,#self.HeadLights.Lamps do

			if(IsValid(self.HeadLights.Lamps[i]) ) then

				self.HeadLights.Lamps[i]:Fire( "TurnOff","",0)

			end

		end

		self:RemoveHeadlightSprites()

	end
	]]
	--
	self.Pilot:SetViewEntity(self.Pilot)
	self.Pilot:ExitVehicle()
	self.Pilot:Spawn()
	self.Pilot:SetHealth(100)
	self.Pilot:UnSpectate()
	-- self.Pilot:Spawn()
	self.Pilot:DrawViewModel(true)
	self.Pilot:DrawWorldModel(true)
	-- */
	-- self.Pilot:SetNetworkedBool( "InFlight", false)
	-- self.Pilot:SetNetworkedEntity( "Tank", NULL)
	-- self.Pilot:SetNetworkedEntity( "Barrel", NULL)
	-- self.Pilot:SetNetworkedEntity( "Weapon", NULL)
	-- self:SetNetworkedEntity( "Pilot", NULL)
	local tr, trace = {}, {}
	tr.start = self:GetPos() + Vector(0, 0, 250)
	tr.endpos = self:GetPos()
	tr.mask = MASK_SOLID
	trace = util.TraceLine(tr)
	local p = trace.HitPos + trace.HitNormal * 50

	if self.ExitPos then
		p = self:LocalToWorld(self.ExitPos)
	end

	-- self.Pilot:SetColor(self.Pilot.Col)
	-- if(self.Pilot:Alive() ) then
	-- for i=1,#self.Pilot.Weapons do
	-- self.Pilot:Give(self.Pilot.Weapons[i])
	-- end
	-- end
	-- self.Pilot:GodEnable(false)
	-- self.Pilot:GodDisable()
	if not self.AdvancedCommando then
		self.Pilot:SetPos(p)
		self.Pilot:SetAngles(Angle(0, self:GetAngles().y, 0))
		self.yrpowner = NULL
	end

	local ma = self:GetAngles()
	self.Pilot:SetEyeAngles(Angle(0, ma.y, 0))
	self.Pilot:SetScriptedVehicle(NULL)

	if TankNeuroWar == 1 then
		self.Pilot:Kill()
	end

	self.Speed = 0
	self.IsDriving = false
	self:SetLocalVelocity(Vector(0, 0, 0))
	self.Yaw = 0
	self.Pilot = NULL
	local shtdwn = self.ShutDownSound or "vehicles/Jetski/jetski_off.wav"

	if self.Fuel > 0 then
		self:EmitSound(shtdwn, 511, math.random(95, 100))
	end

	if IsValid(self.PilotModel) then
		self.PilotModel:Remove()
	end

	self.PilotModel = NULL
end