-- rigid object sync test: spawns the barrel a client's /barrel asks for, dynamic so it can be pushed, shot and
-- tethered around. reloading freeroam removes them

Net.AddEvent("SpawnTestBarrel", function(position, base)
	World.SpawnRigidObject(position, base .. ".modelc", base .. "_col.pfxc", RigidObjectMotionType.Dynamic)
end)