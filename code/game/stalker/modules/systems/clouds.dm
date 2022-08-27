SUBSYSTEM_DEF(clouds)
	name = "Clouds"
	wait = 100

	var/list/turfs_to_start = list()
	var/list/clouds = list()


/datum/controller/subsystem/clouds/Initialize()
	if(!initialized)
		turfs_to_start = block(locate(world.maxx, 1, world.maxz), locate(world.maxx, world.maxy, world.maxz))
		initialized = TRUE

/datum/controller/subsystem/clouds/fire()
	var/obj/effects/cloud_shadow/CD = new(pick(turfs_to_start))
	clouds.Add(CD)
	walk(CD, WEST, 40)
	for(var/obj/effects/cloud_shadow/CS in clouds)
		if(CS.x <= 5)
			clouds.Remove(CS)
			del CS


/obj/effects/cloud_shadow
	name = ""
	icon = 'icons/stalker/effects/cloudshadow.dmi'
	icon_state = "cloudshadow1"
	layer = 40
	appearance_flags = 0
	density = 0
	mouse_opacity = 0

/obj/effects/cloud_shadow/New()
	alpha = rand(10, 120)
	transform	= turn((matrix()*pick(2,4)), rand(-180,180))
	fade()

/obj/effects/cloud_shadow/proc/fade()
	animate(src, pixel_y = 0, alpha = 255, time = 3000)
	spawn(3000)
		animate(src, pixel_y = 200, alpha = 0, time = 3000)
		spawn(3000)
			fade()

/obj/effects/cloud_shadow/Move(NewLoc)
	glide_size = 32/(40/10*world.fps)
	loc = NewLoc