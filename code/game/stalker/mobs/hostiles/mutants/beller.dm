/mob/living/simple_animal/hostile/mutant/beller
	name = "Nastiness"
	name_ru = "Гадость"
	faction = list("necromutants")
	icon = 'icons/stalker/npc/beller.dmi'
	icon_state = "beller"
	icon_dead = "beller_dead"
	vision_range = 5
	aggro_vision_range = 5
	vision_cone = 90
	turns_per_move = 20
	maxHealth = 48
	fearless = 0
	fearborder = 47
	retreat_distance = 5
	var/screamed = 0


/mob/living/simple_animal/hostile/mutant/beller/Initialize()
	..()
	overlays += image(icon, "beller_tent", layer = layer-0.1)

/mob/living/simple_animal/hostile/mutant/beller/MoveToTarget()
	if(!screamed)
		return
	..()

/mob/living/simple_animal/hostile/mutant/beller/target_found()
	scream()

/mob/living/simple_animal/hostile/mutant/beller/proc/scream()
	if(screamed)
		return

	screamed = 1
	playsound(src, 'sound/stalker/mobs/mutants/attack/beller_scream.ogg', 100, 0, 13, 1)
	spawn(600)
		screamed = 0

	for(var/mob/living/simple_animal/hostile/H in range(20, src))
		H.Goto(src, H.move_to_delay, H.minimum_distance)

/mob/living/simple_animal/hostile/mutant/beller/bullet_act(obj/item/projectile/P)
	scream()
	..()

/mob/living/simple_animal/hostile/mutant/beller/attacked_by()
	scream()
	..()

/mob/living/simple_animal/hostile/mutant/beller/attack_hand()
	scream()
	..()

/mob/living/simple_animal/hostile/mutant/death()
	..()
	cut_overlays()