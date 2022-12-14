
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = 0, atom/damager)
	if(istype(get_area(src), /area/stalker/kyrilka))
		return
	blocked = (100-blocked)/100
	if(!damage || (blocked <= 0))	return 0
	var/total = damage * blocked
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(total)
//			shake_camera(src, Clamp(total, 0, 30), Clamp(total/100, 0.1, 1))
		if(CRUSH)
			adjustBruteLoss(total)
//			shake_camera(src, Clamp(total, 0, 30), Clamp(total/100, 0.1, 1))
		if(CUT)
			adjustBruteLoss(total)
//			shake_camera(src, Clamp(total, 0, 30), Clamp(total/100, 0.1, 1))
		if(BURN)
			adjustFireLoss(total)
//			shake_camera(src, Clamp(total*2, 0, 30), Clamp((total/100)*2, 0.1, 1))
		if(TOX)
			adjustToxLoss(total)
		if(OXY)
			adjustOxyLoss(total)
		if(STAMINA)
			adjustStaminaLoss(total)
			shake_camera(src, Clamp(total, 0, 30), Clamp(total/100, 0.1, 1))
		if(PSY)
			adjustPsyLoss(total)
		if(ENDURANCE)
			adjustEnduranceLoss(total)
	updatehealth()
	if(damage > str_const/2)
		overlay_fullscreen("brute", /obj/screen/fullscreen/brute, 6)
	return 1


/mob/living/proc/apply_damages(brute = 0, burn = 0, tox = 0, oxy = 0, clone = 0, psy = 0, endurance = 0, def_zone = null, blocked = 0, stamina = 0, crush = 0, cut = 0)
	if(blocked >= 100)	return 0
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(crush)	apply_damage(crush, CRUSH, def_zone, blocked)
	if(cut)		apply_damage(cut, CUT, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(stamina) apply_damage(stamina, STAMINA, def_zone, blocked)
	if(psy)		apply_damage(psy, PSY, def_zone, blocked)
	if(endurance)	apply_damage(endurance, ENDURANCE, def_zone, blocked)
	return 1



/mob/living/proc/apply_effect(effect = 0,effecttype = STUN, blocked = 0)
	blocked = (100-blocked)/100
	if(!effect || (blocked <= 0))	return 0
	switch(effecttype)
		if(STUN)
			Stun(effect * blocked)
//			shake_camera(src, 30, 1)
		if(WEAKEN)
			Weaken(effect * blocked)
//			shake_camera(src, 30, 1)
		if(PARALYZE)
			Paralyse(effect * blocked)
//			shake_camera(src, 30, 1)
		if(IRRADIATE)
			radiation += max(effect * blocked, 0)
		if(SLUR)
			slurring = max(slurring,(effect * blocked))
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect * blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect * blocked))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect * blocked))
		if(JITTER)
			if(status_flags & CANSTUN)
				jitteriness = max(jitteriness,(effect * blocked))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(stun = 0, weaken = 0, paralyze = 0, irradiate = 0, slur = 0, stutter = 0, eyeblur = 0, drowsy = 0, blocked = 0, stamina = 0, jitter = 0)
	if(blocked >= 100)	return 0
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(slur)		apply_effect(slur, SLUR, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(stamina)		apply_damage(stamina, STAMINA, null, blocked)
	if(jitter)		apply_effect(jitter, JITTER, blocked)
	return 1