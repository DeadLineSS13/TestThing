/mob/living/carbon/human/Login()
	..()
	update_hud()
	overlay_fullscreen("fov", /obj/screen/fullscreen/fov)
	if(isblowout)
		SetParalysis(5000)
		blowout_occupation()
	return
