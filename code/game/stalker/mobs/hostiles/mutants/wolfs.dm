/mob/living/simple_animal/hostile/mutant/wolf
	name = "Wolf"
	name_ru = "Волк"
	desc_ru = "Его глаза белесы и жутки."
	turns_per_move = 5
	speed = 1
	a_intent = "harm"
	icon = 'icons/stalker/npc/wolf.dmi'
	icon_state = "wolf"
	icon_living = "wolf"
	icon_dead = "wolf_dead"
	attacktext = "bites violently"
	attacktext_ru = "яростно грызет"
	search_objects = 0
	//speak_emote = list("whines", "roars")
	emote_see = list("howls.")
	emote_see_ru = list("воет.",
						"рычит.")
	faction = list("wildlife")
	attack_sound = 'sound/stalker/mobs/mutants/attack/pdog_attack.ogg'
	idle_sounds =	list('sound/stalker/mobs/mutants/idle/pdog_idle_1.ogg',
						'sound/stalker/mobs/mutants/idle/pdog_idle_2.ogg',
						'sound/stalker/mobs/mutants/idle/pdog_idle_3.ogg',
						'sound/stalker/mobs/mutants/idle/pdog_idle_4.ogg'
						)
	death_sound = 'sound/stalker/mobs/mutants/death/pdog_death.ogg'
	damtype = "cut"
	dmgvalue = "straight"
	dice_number = 1
	add_damage = 0
	str = 11
	maxHealth = 44
	fearborder = 11
	healable = 1
	robust_searching = 1
	see_invisible = SEE_INVISIBLE_MINIMUM
	see_in_dark = 4
	deathmessage = "With a painful howl, wolf collapses and stops moving."
	deathmessage_ru = "Болезненно взвыв, волк падает и замирает."
	del_on_death = 0
	minbodytemp = 0
	maxbodytemp = 1500
	environment_smash = 0
	layer = MOB_LAYER - 0.1
//	loot = list(/obj/item/weapon/stalker/loot/dog_tail, /obj/nothing, /obj/nothing)
	random_loot = 1
	attack_type = "bite"
	move_to_delay = 3 //Real speed of a mob
	vision_range = 9
	aggro_vision_range = 9

	grouped = 1


/mob/living/simple_animal/hostile/mutant/wolf/AttackingTarget()
	..()
	if(istype(target, /mob/living))
		var/mob/living/L = target
		if(!L.resting)
			var/anydir = pick(GLOB.alldirs)
			target_last_loc = target.loc
			walk_away(src, get_step(src, anydir), 3, move_to_delay)

/mob/living/simple_animal/hostile/mutant/wolf/target_found()
	if(flock.len)
		for(var/mob/living/simple_animal/hostile/H in flock)
			H.target = target

/mob/living/simple_animal/hostile/handle_automated_movement()
	if(!stop_automated_movement && wander)
		if(isturf(src.loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(!return_to_spawnpoint || (loc == initial(loc)))
				if(turns_since_move >= turns_per_move)
					if(!(stop_automated_movement_when_pulled && pulledby)) //Some animals don't move when pulled
						var/anydir = pick(GLOB.cardinal)
						if(Process_Spacemove(anydir))
							if(grouped && leader)
								if(get_dist(src, leader) < round(vision_range/2))
									var/leader_dir = get_dir(src, leader)
									Move(get_step(src, leader_dir), leader_dir)
									turns_since_move = 0
									return 1
							Move(get_step(src, anydir), anydir)
							turns_since_move = 0
			else
				if(src.z == initial(z))
					walk_to(src, initial(loc), 1, 3)
				else
					src.forceMove(initial(loc))
			return 1


/mob/living/simple_animal/hostile/mutant/wolf/death()
	if(flock.len)
		for(var/mob/living/simple_animal/hostile/H in flock)
			H.flock -= src
	..()
