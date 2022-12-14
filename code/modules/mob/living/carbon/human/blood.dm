/****************************************************
				BLOOD SYSTEM
****************************************************/
//Blood levels

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()

	if(vessel)
		return

	vessel = new/datum/reagents(100)
	vessel.my_atom = src

	if(NOBLOOD in dna.species.specflags)
		return

	vessel.add_reagent("blood",100)
	spawn(1)
		fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	return

//	for(var/datum/reagent/blood/B in vessel.reagent_list)
//		if(B.id == "blood")
//			B.data = list("donor"=src,"viruses"=null,"blood_DNA"=dna.unique_enzymes,"blood_type"=dna.blood_type,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"features"=null, "factions"=null)

/mob/living/carbon/human/proc/suppress_bloodloss(amount)
	if(bleedsuppress)
		return
	else
		bleedsuppress = 1
		spawn(amount)
			bleedsuppress = 0
			if(stat != DEAD && blood_max)
				src << "<span class='warning'>The blood soaks through your bandage.</span>"

// Takes care blood loss and regeneration
/mob/living/carbon/human/handle_blood()
	if(NOBLOOD in dna.species.specflags)
		return

	if(stat != DEAD && bodytemperature >= 170)	//Dead or cryosleep people do not pump the blood.

		var/blood_volume = round(vessel.get_reagent_amount("blood"))

		//Blood regeneration if there is some space
		if(blood_volume < 100 && blood_volume)
			var/datum/reagent/blood/B = locate() in vessel.reagent_list //Grab some blood
			if(B) // Make sure there's some blood at all
				if(B.data["donor"] != src) //If it's not theirs, then we look for theirs
					for(var/datum/reagent/blood/D in vessel.reagent_list)
						if(D.data["donor"] == src)
							B = D
							break
				if(blood_regen_wait > 0)
					blood_regen_wait -= 1
				else
					var/regen = 1
					if(nutrition > NUTRITION_LEVEL_FED)	//Getting food speeds it up
						regen = regen*2
						nutrition -= 30
					if(sleeping)
						regen = regen*2
					B.volume += regen
					blood_regen_wait = 40

		var/start_bleeding = 0
		var/num = 0
		for(var/obj/item/organ/limb/O in organs)
			if(O.bleeding)
				num += 1
				start_bleeding = 1
			else if(!num)
				start_bleeding = 0
		if(!num && !start_bleeding)
			bleed_rate = 0
			blood_loss_wait = 0
		if(start_bleeding)
			if(blood_loss_wait > 0)
				blood_loss_wait -= 1
				if(blood_loss_wait % 2 == 0)
					if(isturf(src.loc)) //Blood loss still happens in locker, floor stays clean
						blood_splatter(src,src)
			else
				var/bleedrate = 0
				for(var/obj/item/organ/limb/O in organs)
					if(O.bleeding)
						var/dice = dice6(3)
						if(rolld(dice, hlt-round(O.cut_dam/2)))
							O.bleeding = 1
						else
							O.bleeding = dice-round(hlt-O.cut_dam/2)
						bleedrate += O.bleeding
				drip(bleedrate)
				if(blood_volume <= BLOOD_VOLUME_BAD)
					dna.species.consious_dice(0, src)
				bleed_rate = bleedrate
				blood_loss_wait = 40
/*
		switch(bleed_rate)
			if(0)
				clear_alert("bleeding")
			if(1 to 3)
				throw_alert("bleeding", /obj/screen/alert/bleeding, 1)
			if(4 to 7)
				throw_alert("bleeding", /obj/screen/alert/bleeding, 2)
			if(8 to INFINITY)
				throw_alert("bleeding", /obj/screen/alert/bleeding, 3)
*/
		//Effects of bloodloss
		switch(blood_volume)
			if(BLOOD_VOLUME_SAFE to 10000)
				if(pale)
					pale = 0
					update_body()
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(!pale)
					pale = 1
					update_body()
					if(prob(10))
						var/word = pick("dizzy","woozy","faint")
						src << "<span class='warning'>You feel [word].</span>"
//				if(oxyloss < 20)
//					oxyloss += 3
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				if(!pale)
					pale = 1
					update_body()
//				if(oxyloss < 50)
//					oxyloss += 10
//				oxyloss += 1
				if(prob(10))
//					eye_blurry += 6
					var/word = pick("dizzy","woozy","faint")
					src << "<span class='warning'>You feel very [word].</span>"
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
//				oxyloss += 5
				if(prob(15))
//					Paralyse(rand(1,3))
					var/word = pick("dizzy","woozy","faint")
					src << "<span class='warning'>You feel extremely [word].</span>"
			if(0 to BLOOD_VOLUME_SURVIVE)
				death(0, 1)
/*
		//Bleeding out
		blood_max = 0
		for(var/obj/item/organ/limb/org in organs)
			var/brutedamage = org.brute_dam

			//We want an accurate reading of .len
			listclearnulls(org.embedded_objects)
			blood_max += 0.5*org.embedded_objects.len

			if(brutedamage > 30)
				blood_max += 0.5
				throw_alert("bleeding", /obj/screen/alert/bleeding, 1)
			if(brutedamage > 50)
				blood_max += 1
				throw_alert("bleeding", /obj/screen/alert/bleeding, 2)
			if(brutedamage > 70)
				blood_max += 2
				throw_alert("bleeding", /obj/screen/alert/bleeding, 3)
		if(bleedsuppress)
			blood_max = 0
		if(reagents.has_reagent("heparin") && getBruteLoss()) //Heparin is a powerful toxin that causes bleeding
			blood_max += 3
		if(blood_max)
			drip(blood_max)
		else
			clear_alert("bleeding")
*/
//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(amt as num)

	if(!amt)
		return

	vessel.remove_reagent("blood",amt)
	if (isturf(src.loc)) //Blood loss still happens in locker, floor stays clean
		blood_splatter(src,src)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/weapon/reagent_containers/container, amount)

	var/datum/reagent/B = get_blood(container.reagents)
	if(!B) B = new /datum/reagent/blood
	B.holder = container
	B.volume += amount

	//set reagent data
	B.data["donor"] = src
	B.data["viruses"] = list()
	/*
	if(T.virus && T.virus.spread_type != SPECIAL)
		B.data["virus"] = new T.virus.type(0)
	*/

//	for(var/datum/disease/D in src.viruses)
//		B.data["viruses"] += D.Copy()

	B.data["blood_DNA"] = copytext(src.dna.unique_enzymes,1,0)
	if(src.resistances&&src.resistances.len)
		B.data["resistances"] = src.resistances.Copy()
	var/list/temp_chem = list()
	for(var/datum/reagent/R in src.reagents.reagent_list)
		temp_chem[R.id] = R.volume
	B.data["trace_chem"] = list2params(temp_chem)
	if(mind)
		B.data["mind"] = src.mind
	if(ckey)
		B.data["ckey"] = src.ckey
	if(!suiciding)
		B.data["cloneable"] = 1
	B.data["blood_type"] = copytext(src.dna.blood_type,1,0)
	B.data["gender"] = src.gender
	B.data["real_name"] = src.real_name
	B.data["features"] = src.dna.features
	B.data["factions"] = src.faction
	return B

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/weapon/reagent_containers/container, amount)

	if(NOBLOOD in dna.species.specflags)
		return null

	if(vessel.get_reagent_amount("blood") < amount)
		return null

	. = ..()
	vessel.remove_reagent("blood",amount) // Removes blood if human

//Transfers blood from container to vessels
/mob/living/carbon/proc/inject_blood(obj/item/weapon/reagent_containers/container, amount)

	var/datum/reagent/blood/injected = get_blood(container.reagents)

	if(!injected)
		return

	var/list/chems = list()
	chems = params2list(injected.data["trace_chem"])
	for(var/C in chems)
		src.reagents.add_reagent(C, (text2num(chems[C]) / 560) * amount)//adds trace chemicals to owner's blood
	reagents.update_total()

	container.reagents.remove_reagent("blood", amount)

//Transfers blood from container to vessels, respecting blood types compatibility.
/mob/living/carbon/human/inject_blood(obj/item/weapon/reagent_containers/container, amount)

	var/datum/reagent/blood/injected = get_blood(container.reagents)

	if(NOBLOOD in dna.species.specflags)
		reagents.add_reagent("blood", amount, injected.data)
		reagents.update_total()
		return

	var/datum/reagent/blood/our = get_blood(vessel)

	if (!injected || !our)
		return

	if(blood_incompatible(injected.data["blood_type"],our.data["blood_type"],injected.data["species"],our.data["species"]) )
		reagents.add_reagent("toxin",amount * 0.5)
		our.on_merge(injected.data) //still transfer viruses and such, even if incompatibles bloods
		reagents.update_total()
	else
		vessel.add_reagent("blood", amount, injected.data)
		vessel.update_total()
	..()

//Gets human's own blood.
/mob/living/carbon/proc/get_blood(datum/reagents/container)
	var/datum/reagent/blood/res = locate() in container.reagent_list //Grab some blood
	if(res) // Make sure there's some blood at all
		if(res.data["donor"] != src) //If it's not theirs, then we look for theirs
			for(var/datum/reagent/blood/D in container.reagent_list)
				if(D.data["donor"] == src)
					return D
	return res

/proc/blood_incompatible(donor,receiver,donor_species,receiver_species)
	if(!donor || !receiver) return 0

	if(donor_species && receiver_species)
		if(donor_species != receiver_species)
			return 1

	var/donor_antigen = copytext(donor,1,length(donor))
	var/receiver_antigen = copytext(receiver,1,length(receiver))
	var/donor_rh = (findtext(donor,"+")>0)
	var/receiver_rh = (findtext(receiver,"+")>0)

	if(donor_rh && !receiver_rh) return 1
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return 1
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return 1
		if("O")
			if(donor_antigen != "O") return 1
		//AB is a universal receiver.
	return 0

/proc/blood_splatter(target,datum/reagent/blood/source,large)

	var/obj/effect/decal/cleanable/blood/B
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	var/turf/T = get_turf(target)

	if(istype(source,/mob/living/carbon/human))
		var/mob/living/carbon/human/M = source
		source = M.get_blood(M.vessel)
	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && drips.len < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip

	// Find a blood decal or create a new one.
	B = locate(decal_type) in T
	if(!B)
		//B = PoolOrNew(decal_type, T)
		B = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = B
	if(istype(drop) && drips && drips.len && !large)
		drop.overlays |= drips
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	if(!source)
		return B

	// Update blood information.
	if(source.data["blood_DNA"])
		B.blood_DNA = list()
		if(source.data["blood_type"])
			B.blood_DNA[source.data["blood_DNA"]] = source.data["blood_type"]
		else
			B.blood_DNA[source.data["blood_DNA"]] = "O+"

	return B