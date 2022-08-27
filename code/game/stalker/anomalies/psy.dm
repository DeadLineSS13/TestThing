/obj/anomaly/psy/tangle
	name = "tangle"
	range = 1
	cooldown = 900
	can_be_spotted = 0

/obj/anomaly/psy/tangle/Activate(atom/A)
	if(!incooldown)
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(!H.tangled)
				H.tangled = 1
				spawn(dice6(3)*300)
					H.tangled = 0
				incooldown = 1
				spawn(cooldown*10)
					incooldown = 0



/obj/anomaly/psy/dyatel
	name = "Dyatel"

/obj/anomaly/psy/dyatel/LateInitialize()
	SSdyatel.processing.Add(src)
	var/turf/stalker/T = get_turf(src)
	if(!T.triggers)
		T.triggers = list()
	T.triggers.Add(src)

/obj/anomaly/psy/dyatel/Destroy()
	SSdyatel.processing.Remove(src)
	var/turf/stalker/T = get_turf(src)
	if(T.triggers)
		T.triggers.Remove(src)
	return ..()

/obj/anomaly/psy/dyatel/Activate(atom/A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		SSdyatel.mobs_affected[H] = 0

/obj/anomaly/psy/dyatel/Deactivate(atom/A)
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		SSdyatel.mobs_affected.Remove(H)

/obj/anomaly/psy/dyatel/danger
	name = "Danger Dyatel"

/obj/anomaly/psy/dyatel/danger/process()
	if(SSdyatel.mobs_affected.len)
		for(var/mob/living/carbon/human/H in SSdyatel.mobs_affected)
			H.adjustPsyLoss(-1)