/datum/reagent/medicine/energetic
	name = "Energetic"
	id = "energetic"
	description = "Amps you up and gets you going, fixes all stamina damage you might have."
	reagent_state = LIQUID  //SNAKE!
	color = "#60A584"
	metabolization_rate = 0.5

/datum/reagent/medicine/energetic/on_mob_life(mob/living/carbon/human/H)
	var/high_message = pick("You feel amped up.", "You feel ready.")
	if(prob(5))
		H << "<span class='notice'>[high_message]</span>"
	H.adjustEnduranceLoss(23)
	. = 1
	..()

/datum/reagent/consumable/ethanol/beer/pivas
	name = "pivo"
	id = "pivo"
	description = "HNNNGH BEEER."
	reagent_state = LIQUID
	color = "#60A584"
	metabolization_rate = 0.5

/datum/reagent/consumable/ethanol/beer/pivas/ohota
	boozepwr = 50
	id = "ohota"

/datum/reagent/consumable/ethanol/beer/pivas/obolon
	boozepwr = 50
	id = "obolon"

/datum/reagent/consumable/ethanol/beer/pivas/razin
	boozepwr = 50
	id = "razin"

/datum/reagent/consumable/ethanol/beer/pivas/gus
	boozepwr = 50
	id = "gus"