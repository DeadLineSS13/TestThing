/mob/var/suiciding = 0

/mob/living/carbon/human/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		var/obj/item/held_item = get_active_held_item()
		if(held_item)
			var/damagetype = held_item.suicide_act(src)
			if(damagetype)
				var/damage_mod = 1
				switch(damagetype) //Sorry about the magic numbers.
								   //brute = 1, burn = 2, tox = 4, oxy = 8
					if(15) //4 damage types
						damage_mod = 4

					if(6, 11, 13, 14) //3 damage types
						damage_mod = 3

					if(3, 5, 7, 9, 10, 12) //2 damage types
						damage_mod = 2

					if(1, 2, 4, 8) //1 damage type
						damage_mod = 1

					else //This should not happen, but if it does, everything should still work
						damage_mod = 1

				//Do 175 damage divided by the number of damage types applied.
				if(damagetype & BRUTELOSS)
					adjustBruteLoss(200/damage_mod)

				if(damagetype & FIRELOSS)
					adjustFireLoss(200/damage_mod)

				if(damagetype & TOXLOSS)
					adjustToxLoss(200/damage_mod)

				if(damagetype & OXYLOSS)
					adjustOxyLoss(200/damage_mod)

				//If something went wrong, just do normal oxyloss
				if(!(damagetype | BRUTELOSS) && !(damagetype | FIRELOSS) && !(damagetype | TOXLOSS) && !(damagetype | OXYLOSS))
					adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))

				updatehealth()
				death(0)
				return

		var/suicide_message = pick("[src] is attempting to bite \his tongue off! It looks like \he's trying to commit suicide.", \
							"[src] is jamming \his thumbs into \his eye sockets! It looks like \he's trying to commit suicide.", \
							"[src] is twisting \his own neck! It looks like \he's trying to commit suicide.", \
							"[src] is holding \his breath! It looks like \he's trying to commit suicide.")

		visible_message("<span class='danger'>[suicide_message]</span>", "<span class='userdanger'>[suicide_message]</span>")

		adjustOxyLoss(max(200 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		updatehealth()
		death(0)

/mob/living/simple_animal/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		suiciding = 1
		visible_message("<span class='danger'>[src] begins to fall down. It looks like \he's lost the will to live.</span>", \
						"<span class='userdanger'>[src] begins to fall down. It looks like \he's lost the will to live.</span>")
		death(0)


/mob/living/proc/canSuicide()
	if(stat == CONSCIOUS)
		return 1
	else if(stat == DEAD)
		src << "You're already dead!"
	else if(stat == UNCONSCIOUS)
		src << "You need to be conscious to suicide!"
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!canmove || restrained())	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		src << "You can't commit suicide whilst restrained! ((You can type Ghost instead however.))"
		return
	return 1