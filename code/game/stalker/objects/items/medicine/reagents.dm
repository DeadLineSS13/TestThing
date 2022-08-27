/datum/reagent/medicine/hyperstim
	name = "hyperstim"
	id = "hyperstim"
	metabolization_rate = 0.1

/datum/reagent/medicine/hyperstim/on_mob_life(mob/living/M)
	M.boosted = 1
	. = 1
	..()

/datum/reagent/medicine/morphite
	name = "morphite"
	id = "morphite"
	metabolization_rate = 0.1

/datum/reagent/medicine/morphite/on_mob_life(mob/living/M)
	M.morphied = 1
	. = 1
	..()

/datum/reagent/medicine/adrenaline
	name = "adrenaline"
	id = "adrenaline"

/datum/reagent/medicine/heal_stimulant
	name = "Heal stimulant"
	id = "hl_stim"
	var/healing = 0

/datum/reagent/medicine/heal_stimulant/on_mob_life(mob/living/M)
	current_cycle++
	if(current_cycle > 20)
		M.adjustBruteLoss(-healing)
		holder.remove_reagent(src.id, 1) //By default it slowly disappears.
		current_cycle = 0
	return

/datum/reagent/medicine/heal_stimulant/low
	name = "Heal stimulant low"
	id = "hl_stim_low"
	healing = 1

/datum/reagent/medicine/heal_stimulant/medium
	name = "Heal stimulant medium"
	id = "hl_stim_medium"
	healing = 3

/datum/reagent/medicine/heal_stimulant/hard
	name = "Heal stimulant advanced"
	id = "hl_stim_hard"
	healing = 5