PROCESSING_SUBSYSTEM_DEF(artefacts)
	name = "Artefacts"
	priority = FIRE_PRIORITY_OBJ
	flags = SS_NO_INIT
	wait = 600

	var/list/humans_affected = list()

/datum/controller/subsystem/processing/artefacts/stat_entry()
	..("H:[humans_affected.len]")

/datum/controller/subsystem/processing/artefacts/fire()
	..()

	if(humans_affected.len)
		for(var/mob/living/carbon/human/H in humans_affected)
			for(var/i in H.artefacts_effects)
				if(i == "regen")
					for(var/obj/item/organ/limb/O in H.organs)
						if(O.crush_dam)
							O.heal_damage(H.artefacts_effects["regen"], 0, 0)
						else if(O.cut_dam)
							O.heal_damage(0, H.artefacts_effects["regen"], 0)
						else if(O.burn_dam)
							O.heal_damage(0, 0, H.artefacts_effects["regen"])
				if(i == "hlt_dice")
					var/dice = dice6(3)
					if(dice == 17 || dice == 18)
						H.Paralyse(dice6(2) SECONDS)
						H.adjustToxLoss(dice6(2))
					if(!H.rolld(dice, H.hlt))
						H.adjustToxLoss(1)
				if(i == "kirpich")
					var/obj/item/organ/limb/L = pick(H.organs)
					L.take_damage(0, 0, H.artefacts_effects["kirpich"]/2)
					H << sanitize_russian("<span class='warning'>[H.client.select_lang(\
					pick("Проклятье... все тело зудит.", "Ни секунды покоя из-за этого зуда...", "Ар-ргх. Лишь бы этот чертов зуд прекратился!"),\
					pick("", "", ""))]</span>")
					playsound(H, pick('sound/stalker/artefacts/electra_hit.ogg','sound/stalker/artefacts/electra_hit1.ogg'), 100, extrarange = -5, time = 10)