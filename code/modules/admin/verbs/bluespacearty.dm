/client/proc/bluespace_artillery(mob/M in GLOB.mob_list)
	set name = "Bluespace Artillery"
	set category = "Fun"

	if(!holder || !check_rights(R_FUN))
		return

	var/mob/living/target = M

	if(!isliving(target))
		usr << "This can only be used on instances of type /mob/living"
		return

	if(alert(usr, "Are you sure you wish to hit [key_name(target)] with Blue Space Artillery?",  "Confirm Firing?" , "Yes" , "No") != "Yes")
		return

	explosion(target.loc, 0, 0, 0, 0)

	var/turf/simulated/floor/T = get_turf(target)
	if(istype(T))
		if(prob(80))	T.break_tile_to_plating()
		else			T.break_tile()

	target << "<span class='userdanger'>You're hit by bluespace artillery!</span>"
	log_admin("[target.name] has been hit by Bluespace Artillery fired by [usr]")
	message_admins("[target.name] has been hit by Bluespace Artillery fired by [usr]")

	if(target.health <= 1)
		target.gib()
	else
		target.adjustBruteLoss(min(99,(target.health - 1)))
		target.Stun(20)
		target.Weaken(20)
		target.stuttering = 20

