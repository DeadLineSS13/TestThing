/obj/structure
	icon = 'icons/obj/structures.dmi'
	pressure_resistance = 8

/obj/structure/New()
	..()
	if(smooth)
		smooth_icon(src)
		smooth_icon_neighbors(src)
		icon_state = ""
//	if(ticker)
//		cameranet.updateVisibility(src)

/obj/structure/blob_act()
	if(!density)
		qdel(src)
	if(prob(50))
		qdel(src)

/obj/structure/Destroy()
//	if(ticker)
//		cameranet.updateVisibility(src)
	//if(opacity)
		//UpdateAffectingLights()
	if(smooth)
		smooth_icon_neighbors(src)
	return ..()