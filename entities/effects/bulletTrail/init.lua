EFFECT.material = Material ("cable/rope")
EFFECT.lifeTime = 0.15

function EFFECT:Init (data)
	self.startPos = data:GetStart ()
	self.endPos = data:GetOrigin ()
	self.creationTime = CurTime ()
end

function EFFECT:Think ()
	if self.creationTime + self.lifeTime < CurTime() then
		return false
	end
	return true
end

function EFFECT:Render ()
	Msg ("WE R RENDERING! ("..tostring(self.startPos)..", "..tostring(self.EndPos)..")\n")
	render.SetMaterial (self.material)
	render.DrawBeam (self.startPos, self.endPos, 1, 0, 0, Color (255, 255, 255, 255))
end
