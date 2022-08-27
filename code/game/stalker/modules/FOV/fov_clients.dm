/client/var/list/hidingAtoms = list()

/client/proc/hideIfNeed(atom/target, smoothly = FALSE)
	ASSERT(istype(target))

	if(is_fovCanSee(target))
		if(target in hidingAtoms)
			images      -= hidingAtoms[target]
			hidingAtoms -= target
	else
		if(!(target in hidingAtoms))
			var/image/image = image("split",target)

			image.override = TRUE
			image.pixel_x = -target.pixel_x //Ќе ебу зачем минус, но без него все плохо
			image.pixel_y = -target.pixel_y

			hidingAtoms |= target
			hidingAtoms[target] = image
			images += image

/client/proc/fovProcess()
	if(!useFov)
		return
	for(var/atom/movable/A in oview(mob.zoomed ? view*2 : view))
		if(A.fovCanBeHide)
			hideIfNeed(target = A)

/client/proc/is_fovCanSee(atom/target)
	. = TRUE
	ASSERT(mob)

	var/vector/deltaVector = new(target.x - mob.x, target.y - mob.y)

	if(deltaVector.isNull())
		return TRUE	 //¬идно ли предмет пр€мо под ногами
	if(src.mob.pulling == target)
		return TRUE	 //¬идно ли то что мы тащим за собой
	if(isliving(target))
		var/mob/living/L = target
		if(L.footstep_sound > 1)
			L.in_vision_cones[src] = 1

	deltaVector = deltaVector.get_normalized()
	var/vector/viewVector = new()
	switch(mob.dir)
		if(NORTH)
			viewVector.y = 1
		if(SOUTH)
			viewVector.y = -1
		if(EAST)
			viewVector.x = 1
		if(WEST)
			viewVector.x = -1
	var/theta = deltaVector.get_theta(viewVector)
	if(mob && ishuman(mob) && mob.screens["fov"])
		if(mob.screens["fov"].icon_state == "combat")
			if(theta > 135) //»змен€€ это значение можно регулировать угол обзора без шлема
				return FALSE
		else
			if(theta > 60) //»змен€€ это значение можно регулировать угол обзора в шлеме
				return FALSE
	else
		if(theta > 135)
			return FALSE