local entityMeta = FindMetaTable("Entity")

function entityMeta:IsDoor()
	return self:GetClass():find("door")
end

function entityMeta:IsButton()
	return (self:GetClass():find("button") or self:GetClass() == ("class C_BaseEntity"))
end

function entityMeta:IsDoorLocked()
	return self:GetSaveTable().m_bLocked
end

local chairs = {}

for k, v in pairs(list.Get("Vehicles")) do
	if v.Category == "Chairs" then
		chairs[v.Model] = true
	end
end

function entityMeta:IsChair()
	return chairs[self.GetModel(self)]
end

function entityMeta:CanBeCarried()
	local phys = self:GetPhysicsObject()

	if not IsValid(phys) then
		return false
	end

	if phys:GetMass() > 100 or not phys:IsMoveable() then
		return false
	end

	return true
end

local ADJUST_SOUND = SoundDuration("npc/metropolice/pain1.wav") > 0 and "" or "../../hl2/sound/"

function entityMeta:EmitQueuedSounds(sounds, delay, spacing, volume, pitch)
	delay = delay or 0
	spacing = spacing or 0.1

	for k, v in ipairs(sounds) do
		local postSet, preSet = 0, 0

		if (type(v) == "table") then
			postSet, preSet = v[2] or 0, v[3] or 0
			v = v[1]
		end

		local length = SoundDuration(ADJUST_SOUND..v)
		delay = delay + preSet

		timer.Simple(delay, function()
			if (IsValid(self)) then
				self:EmitSound(v, volume, pitch)
			end
		end)

		delay = delay + length + postSet + spacing
	end

	return delay
end