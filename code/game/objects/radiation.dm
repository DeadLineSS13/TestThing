/proc/radiation_pulse(turf/epicenter, heavy_range, .light_range, severity, log=0)
	if(!epicenter || !severity) return

	if(!istype(epicenter, /turf))
		epicenter = get_turf(epicenter.loc)

	if(heavy_range > light_range)
		light_range = heavy_range

	var/light_severity = severity * 0.5
	for(var/atom/T in range(light_range, epicenter))
		var/distance = get_dist(epicenter, T)
		if(distance < 0)
			distance = 0
		if(distance < heavy_range)
			T.rad_act(severity)
		else if(distance == heavy_range)
			if(prob(50))
				T.rad_act(severity)
			else
				T.rad_act(light_severity)
		else if(distance <= light_range)
			T.rad_act(light_severity)

	if(log)
		log_game("Radiation pulse with size ([heavy_range], [light_range]) and severity [severity] in area [epicenter.loc.name] ")
	return 1

/atom/proc/rad_act(var/severity)
	return 1

/mob/living/rad_act(amount, silent = 0)
	if(amount)
//		var/blocked = getarmor(null, "rad")

//		if(!silent)
//			src << "Your skin feels warm."
		for(var/obj/I in src) //Radiation is also applied to items held by the mob
			if(istype(I, /obj/item/device/geiger_counter))
				I.rad_act(amount)

		for(var/mob/living/carbon/human/H)
			if(H.wear_mask)
				if(H.wear_mask.rad_protect && amount <= 1.5)
					return

		apply_damage(amount, TOX, null, getarmor(null, "rad"))

/mob/living/carbon/human/proc/getarmor_rad()
	return