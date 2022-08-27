#define SHADOW_REFLECT_UNDERLAYS
var/list/world_shadows = list()

/obj/shadow
	appearance_flags = KEEP_TOGETHER
	name = ""
	var/casting = FALSE
	var/_alpha = 40 // 255 = opaque, 0 = transparent

	var/SHADOW_HEIGHT 	= -1 // scales it downwards, as a reflection
	var/SHADOW_WIDTH 	= 1 // no scale in x dimention
	var/additional_pixel_y = 0
	var/atom/parent = null
	var/anomaly = 0


/obj/shadow/New(atom/a)
	if(a)
		parent = a
		appearance = a
		if(!parent.icon_height)
			var/icon/i = new/icon(a.icon, a.icon_state)
			parent.icon_height = i.Height()
		pixel_y = (parent.icon_height*-1) + shadow_offset + additional_pixel_y
		if(istype(parent, /obj/structure/stalker/flora/trees))
			additional_pixel_y = 5

		overlays += a.overlays

		//transform
		var/matrix/m = matrix()
		transform = m.Scale(SHADOW_WIDTH,SHADOW_HEIGHT)

		if(_alpha)
			color = rgb(0,0,0,_alpha)
		else
			color = rgb(0,0,0,0)
		world_shadows += src

/obj/shadow/proc/update(atom/a)
	src.overlays = null
	pixel_y = (parent.icon_height*-1) + shadow_offset + additional_pixel_y
	src.overlays += a.overlays

	//transform
	var/matrix/m = matrix()
	transform = m.Scale(SHADOW_WIDTH,SHADOW_HEIGHT)

	if(_alpha)
		color = rgb(0,0,0,_alpha)
	else
		color = rgb(0,0,0,0)

var/list/shadow_types = list()

/atom
	var/shadow_offset = 0			//if atom needs a shadow y-axis offset, use this variable
	var/cast_shadow = FALSE		//bool for if cast shadow or not
	var/icon_height = 0

		//tmp var for storing current shadow.
		//!important always rewritten @ atom.New()

/obj/Initialize()
	..()
	//if atom is supposed to cast shadow, continue
	if(cast_shadow)
		var/anomaly = 0
		var/obj/shadow/shadow
		if(prob(0.01))
			if(istype(get_area(loc), /area/stalker/blowout/outdoor/anomaly))
				anomaly = 1
		//shadow is tmp, always create new shadow.
		if(shadow_types.Find(type) && !anomaly)
			vis_contents += shadow_types[type]
		else if(!anomaly)
			shadow = new/obj/shadow(src)
			shadow.mouse_opacity = 0
			shadow_types[src.type] = shadow
			vis_contents += shadow_types[type]
		else
			shadow = new/obj/shadow(src)
			shadow.mouse_opacity = 0
			vis_contents += shadow
			shadow.anomaly = 1
		CHECK_TICK

//client/Move()
//	..() // Everytime you move, update your shadow.
//	if(isliving(mob))
//		var/mob/living/L = mob
//		L.UpdateShadow()

/mob/living
	var/tmp/obj/mob_shadow

/mob/living/New()
	..()
//	mob_shadow = new(src)
//	mob_shadow.layer = 2.2
//	mob_shadow.mouse_opacity = 0
//	vis_contents += mob_shadow
/*
/mob/living/proc/UpdateShadow()
	mob_shadow.underlays.Cut() 					//Сначала избавляемся от всех уже имеющихся теней, мы же хотим их изменить, верно?
	if(resting)									//От лежачего тени нет
		return
	for(var/atom/A in view(src))
		if(A == src)							//Отбрасывать тень от самого себя - плохая идея
			continue
		if(A.light)
			var/datum/light_source/L = A.light
			if(A in range(round(L.light_range-1)))
				if(L.light_angle)
					var/vector/deltaVector = new(x - A.x, y - A.y)
					if(deltaVector.isNull())
						continue
					deltaVector = deltaVector.get_normalized()
					var/vector/viewVector = new()
					switch(A.dir)
						if(NORTH)
							viewVector.y = -1
						if(SOUTH)
							viewVector.y = 1
						if(EAST)
							viewVector.x = -1
						if(WEST)
							viewVector.x = 1
					var/theta = deltaVector.get_theta(viewVector)
					if(theta < L.light_angle)
						continue
				var/obj/NewObj=new()
				var/BrightSubtract=L.light_range*L.light_power*15-get_dist(src, A)*10
				var/SHADOW_HEIGHT = 1*(get_dist(src, A)/(L.light_range/2))
				var/angle = GetAngle(A,src) 			// Высчитываем угол между источником света и нами
				NewObj.icon = icon(src.icon,src.icon_state) // Duplicate src's icon, and darken it the right amount
				NewObj.color = rgb(0,0,0,BrightSubtract)

				var/matrix/m = matrix()
				m.Scale(1,SHADOW_HEIGHT)
				NewObj.transform = m.Turn(angle)
				NewObj.pixel_x += cos(90-angle) * 16 * SHADOW_HEIGHT // Displace the shadow correctly.
				NewObj.pixel_y += sin(90-angle) * 16 * SHADOW_HEIGHT - 16
				mob_shadow.underlays+=NewObj
//	var/MD = movement_delay()
//	mob_shadow.glide_size = 32/(MD/10*min(32, world.fps))
//	mob_shadow.loc = loc

proc/GetAngle(atom/Ref,atom/Target) // This is just a procedure to get the angle between two atoms.
	var/dx = ((Target.x * 32) + Target.pixel_x - 16) - ((Ref.x*32) + Ref.pixel_x - 16)
	var/dy = ((Target.y * 32) + Target.pixel_y - 16) - ((Ref.y*32) + Ref.pixel_y - 16)
	var/dev = sqrt(dx * dx + dy * dy)
	var/angle=0
	if(dev > 0)
		angle=arccos(dy / sqrt(dx * dx + dy * dy))
	var/ang = (dx>=0) ? (angle) : (360-angle)
	return ang
*/