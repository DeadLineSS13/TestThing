/atom/proc/hideForClientsInView()
	if(!fovCanBeHide)
		return
	for(var/mob/living/carbon/C in oview())
		if(C.client)
//			if(C.pulling == src)
//				return
			C.client.hideIfNeed(target = src, smoothly = FALSE)

/atom/movable/Move()
	. = ..()
	hideForClientsInView()
