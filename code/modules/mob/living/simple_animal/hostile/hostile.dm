/mob/living/simple_animal/hostile
	faction = list("hostile")
	stop_automated_movement_when_pulled = 0
	environment_smash = 1 //Set to 1 to break closets,tables,racks, etc; 2 for walls; 3 for rwalls
	var/atom/target
	var/ranged = 0
	var/rapid = 0
	var/projectiletype	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectilesound
	var/casingtype		//set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	var/move_to_delay = 3 //delay for the automated movement.
	var/list/friends = list()
	var/list/emote_taunt = list()
	var/taunt_chance = 0
	var/fearless = 1
	var/fearborder = 20
	var/ranged_message = "fires" //Fluff text for ranged mobs
	var/ranged_cooldown = 0 //What the starting cooldown is on ranged attacks
	var/ranged_cooldown_cap = 3 //What ranged attackLoseTargets, after being used are set to, to go back on cooldown, defaults to 3 life() ticks
	var/retreat_distance = null //If our mob runs from players when they're too close, set in tile distance. By default, mobs do not retreat.
	var/minimum_distance = 1 //Minimum approach distance, so ranged mobs chase targets down, but still keep their distance set in tiles to the target, set higher to make mobs keep distance
	var/target_distance
	var/target_last_loc = null
	var/min_range_distance = 4

//These vars are related to how mobs locate and target
	var/robust_searching = 0 //By default, mobs have a simple searching method, set this to 1 for the more scrutinous searching (stat_attack, stat_exclusive, etc), should be disabled on most mobs
	var/vision_range = 9 //How big of an area to search for targets in, a vision of 9 attempts to find targets as soon as they walk into screen view
	var/aggro_vision_range = 9 //If a mob is aggro, we search in this radius. Defaults to 9 to keep in line with original simple mob aggro radius
	var/idle_vision_range = 9 //If a mob is just idling around, it's vision range is limited to this. Defaults to 9 to keep in line with original simple mob aggro radius
	var/search_objects = 0 //If we want to consider objects when searching around, set this to 1. If you want to search for objects while also ignoring mobs until hurt, set it to 2. To completely ignore mobs, even when attacked, set it to 3
	var/list/wanted_objects = list() //A list of objects that will be checked against to attack, should we have search_objects enabled
	var/stat_attack = 0 //Mobs with stat_attack to 1 will attempt to attack things that are unconscious, Mobs with stat_attack set to 2 will attempt to attack the dead.
	var/stat_exclusive = 0 //Mobs with this set to 1 will exclusively attack things defined by stat_attack, stat_attack 2 means they will only attack corpses
	var/attack_same = 0 //Set us to 1 to allow us to attack our own faction, or 2, to only ever attack our own faction
	var/see_through_walls = 0
	var/long_attack = 0
//	var/deletable = 0 //Self-deletable dead bodies
	var/target_dist
	var/AIStatus = AI_ON //The Status of our AI, can be set to AI_ON (On, usual processing), AI_IDLE (Will not process, but will return to AI_ON if an enemy comes near), AI_OFF (Off, Not processing ever)

	var/vision_cone = 0		//Vision cone in degrees
	var/list/armor_new = list("crush" = 0, "cut" = 0, "imp" = 0, "bullet" = 0, "burn" = 0, "bio" = 0, "rad" = 0, "psy" = 0)		//?? ?????? ????????? body_armor ????? ??? ?????? ????????, ??? ?????????? ????? ???

	var/grouped = 0 					//??????? ?? ??????
	var/mob/living/leader = null		//???? ???????, ?? ??? ??????
	var/list/flock = list()				//???? ? ????

/mob/living/simple_animal/hostile/Life()
	. = ..()
	if(ranged)
		ranged_cooldown--
	if(!.) //dead
		walk(src, 0) //stops walking
		return 0
	if(target)
		spawn(10)
			handle_automated_action()

/mob/living/simple_animal/hostile/Destroy()
	if(leader)
		leader = null

	if(!leader && flock.len)
		for(var/mob/living/simple_animal/hostile/H in flock)
			H.leader = null

	if(flock.len)
		for(var/mob/living/simple_animal/hostile/H in flock)
			H.flock.Remove(src)

	wanted_objects.Cut()
	target = null

	return ..()


/mob/living/simple_animal/hostile/handle_automated_action()
	if(AIStatus == AI_OFF)
		return 0
	var/list/possible_targets = ListTargets() //we look around for potential targets and make it a list for later use.

	if(environment_smash)
		EscapeConfinement()

	if(AICanContinue(possible_targets))
		DestroySurroundings()
		if(!MoveToTarget(possible_targets))     //if we lose our target
			if(AIShouldSleep(possible_targets))	// we try to acquire a new one
				AIStatus = AI_IDLE				// otherwise we go idle

	return 1


/mob/living/simple_animal/hostile/get_newarmor(obj/item/organ/limb/def_zone, type, without = null)
	return armor_new[type]

/mob/living/simple_animal/hostile/proc/in_vision_cone(atom/A)
	if(!vision_cone)
		return 1

	var/vector/deltaVector = new(A.x - x, A.y - y)
	deltaVector = deltaVector.get_normalized()
	var/vector/viewVector = new()
	switch(dir)
		if(NORTH)
			viewVector.y = 1
		if(SOUTH)
			viewVector.y = -1
		if(EAST)
			viewVector.x = 1
		if(WEST)
			viewVector.x = -1
	var/theta = deltaVector.get_theta(viewVector)
	if(theta < vision_cone)
		return 1
	return 0


//////////////HOSTILE MOB TARGETTING AND AGGRESSION////////////


/mob/living/simple_animal/hostile/proc/ListTargets()//Step 1, find out what we can see
	var/list/L = list()
	if(!search_objects)
		var/list/Mobs = list()
		var/list/dead_mobs = list()
		if(see_through_walls)
			for(var/mob/M in orange(vision_range, src))
				if(M.stat != DEAD)
					Mobs += M
				else if(M.timeofdeath + 600 < world.time)
					dead_mobs += M
		else
			Mobs = hearers(vision_range, src) - src //Remove self, so we don't suicide
			for(var/mob/M in Mobs)
				if(M.stat == DEAD)
					Mobs -= M
					if(M.timeofdeath + 600 < world.time)
						dead_mobs += M
//			for(var/mob/M in Mobs)
//				Mobs.Remove(M)

		if(!Mobs.len)
			L += dead_mobs
		else
			L += Mobs
//		for(var/obj/mecha/M in mechas_list)
//			if(get_dist(M, src) <= vision_range && can_see(src, M, vision_range))
//				L += M
	else
		var/list/Objects = oview(vision_range, src)
		L += Objects

	if(flock.len)
		for(var/mob/living/simple_animal/hostile/H in flock)
			if(H.target)
				L |= H.target
				break

	return L

/mob/living/simple_animal/hostile/proc/FindTarget(var/list/possible_targets, var/HasTargetsList = 0)//Step 2, filter down possible targets to things we actually care about
	var/list/Targets = list()

	if(!target && flock.len)
		for(var/mob/living/simple_animal/hostile/H in flock)
			if(H.target)
				GiveTarget(H.target)
				return H.target

	if(!HasTargetsList)
		possible_targets = ListTargets()
	for(var/atom/A in possible_targets)
		if(Found(A))//Just in case people want to override targetting
			Targets = list(A)
			break
		if(CanAttack(A))//Can we attack it?
			Targets += A
			continue
	var/Target = PickTarget(Targets)
	GiveTarget(Target)
	return Target //We now have a target

/mob/living/simple_animal/hostile/proc/Found(atom/A)//This is here as a potential override to pick a specific target if available
	return

/mob/living/simple_animal/hostile/proc/PickTarget(list/Targets)//Step 3, pick amongst the possible, attackable targets
	if(target != null)//If we already have a target, but are told to pick again, calculate the lowest distance between all possible, and pick from the lowest distance targets
		for(var/atom/A in Targets)
			target_dist = get_dist(src, target)
			var/possible_target_distance = get_dist(src, A)
			if(target_dist < possible_target_distance)
				Targets -= A
	if(!Targets.len)//We didnt find nothin!
		return
	var/chosen_target = pick(Targets)//Pick the remaining targets (if any) at random
	return chosen_target

/mob/living/simple_animal/hostile/proc/target_found(atom/target)
	return

/mob/living/simple_animal/hostile/CanAttack(atom/the_target)//Can we actually attack a possible target?
	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return 0
	if(search_objects < 2)
//		if(istype(the_target, /obj/mecha))
//			var/obj/mecha/M = the_target
//			if(M.occupant)//Just so we don't attack empty mechs
//				if(CanAttack(M.occupant))
//					return 1
		if(isliving(the_target))
			var/mob/living/L = the_target
			var/faction_check = 0
			for(var/F in faction)
				if(F in L.faction)
					faction_check = 1
					break
			if(robust_searching)
				if(L.stat > stat_attack || L.stat != stat_attack && stat_exclusive == 1)
					return 0
				if(faction_check && !attack_same || !faction_check && attack_same == 2)
					return 0
				if(L in friends)
					return 0
			else
				if(L.stat)
					return 0
				if(faction_check && !attack_same)
					return 0
			return 1
	if(isobj(the_target))
		if(the_target.type in wanted_objects)
			return 1
	return 0

/mob/living/simple_animal/hostile/proc/GiveTarget(new_target)//Step 4, give us our selected target
	target = new_target
	if(target != null)
		if(in_vision_cone(target))
			target_found(target)
			Aggro()
		return 1

/mob/living/simple_animal/hostile/proc/MoveToTarget(var/list/possible_targets)//Step 5, handle movement between us and our target
	stop_automated_movement = 1
	if(!target || !CanAttack(target))
		LoseTarget()
		return 0
	if(target in possible_targets)
		var/target_distance = get_dist(src,target)
		if(ranged)//We ranged? Shoot at em
			if((target_distance >= min_range_distance && ranged_cooldown <= 0) || long_attack)//But make sure they're a tile away at least, and our range attack is off cooldown
				OpenFire(target)
				if(!long_attack)
					sleep(50)
		if(!Process_Spacemove()) // Drifting
			walk(src,0)
			return 1
		if(retreat_distance != null)//If we have a retreat distance, check if we need to run from our target
			if(target_distance <= retreat_distance)//If target's closer than our retreat distance, run
				walk_away(src,target,retreat_distance,move_to_delay)
			else if(in_vision_cone(target))
				Goto(target,move_to_delay,minimum_distance)//Otherwise, get to our minimum distance so we chase them
		else
			if(src.health <= fearborder && !fearless)
				walk_away(src,target,retreat_distance,move_to_delay)
			else if(in_vision_cone(target))
				Goto(target,move_to_delay,minimum_distance)
		if(target)
			if(isturf(loc) && target.Adjacent(src) && in_vision_cone(target))	//If they're next to us, attack
				AttackingTarget()
		return 1
	if(environment_smash)
		if(target.loc != null && get_dist(src, target.loc) <= vision_range)//We can't see our target, but he's in our vision range still
			if(environment_smash >= 2)//If we're capable of smashing through walls, forget about vision completely after finding our target
				Goto(target,move_to_delay,minimum_distance)
				FindHidden()
				return 1
			else
				if(FindHidden())
					return 1
	LoseTarget()
	return 0

/mob/living/simple_animal/hostile/proc/Goto(target, delay, minimum_distance)
	walk_to(src, target, minimum_distance, delay)

/mob/living/simple_animal/Move(newloc)							//??? ?????????? ?????? ????? ????? ???????? ???????????? ???????????? ?????
	var/dirr = get_dir(loc, newloc)
	if(dirr & (dirr-1))
		var/new_dir = get_cardinal_dir(loc, newloc)
		Move(get_step(src, new_dir))
		dir = new_dir
		return 0
	..()

/mob/living/simple_animal/hostile/adjustBruteLoss(damage)
	..(damage)
	if(!ckey && !stat && search_objects < 3 && damage > 0)//Not unconscious, and we don't ignore mobs
		if(search_objects)//Turn off item searching and ignore whatever item we were looking at, we're more concerned with fight or flight
			search_objects = 0
			target = null
		if(AIStatus == AI_IDLE)
			AIStatus = AI_ON
			FindTarget()
		else if(target != null && prob(40))//No more pulling a mob forever and having a second player attack it, it can switch targets now if it finds a more suitable one
			FindTarget()

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	target.attack_animal(src)

/mob/living/simple_animal/hostile/proc/Aggro()
	vision_range = aggro_vision_range
	if(target && emote_taunt.len && prob(taunt_chance))
		emote("me", 1, "[pick(emote_taunt)] at [target].")
		taunt_chance = max(taunt_chance-7,2)


/mob/living/simple_animal/hostile/proc/LoseAggro()
	stop_automated_movement = 0
	vision_range = idle_vision_range
	taunt_chance = initial(taunt_chance)

/mob/living/simple_animal/hostile/proc/LoseTarget()
	target = null
	if(target_last_loc)
		Goto(target_last_loc, move_to_delay, 1)
		target_last_loc = null
	else
		walk(src, 0)
	LoseAggro()

//////////////END HOSTILE MOB TARGETTING AND AGGRESSION////////////

/mob/living/simple_animal/hostile/death(gibbed)
	LoseTarget()
	..(gibbed)

/mob/living/simple_animal/hostile/proc/summon_backup(distance)
//	do_alert_animation(src)
	playsound(loc, 'sound/machines/chime.ogg', 50, 1, -1, channel = "regular", time = 10)
	for(var/mob/living/simple_animal/hostile/M in oview(distance, src))
		var/list/L = M.faction&faction
		if(L.len)
			if(M.AIStatus == AI_OFF)
				return
			else
				M.Goto(src,M.move_to_delay,M.minimum_distance)

/mob/living/simple_animal/hostile/proc/OpenFire(atom/A)

	visible_message("<span class='danger'><b>[src]</b> [ranged_message] at [A]!</span>")

	if(rapid)
		spawn(1)
			Shoot(A)
		spawn(4)
			Shoot(A)
		spawn(6)
			Shoot(A)
	else
		Shoot(A)
	ranged_cooldown = ranged_cooldown_cap
	return

/mob/living/simple_animal/hostile/proc/Shoot(atom/targeted_atom)
	if(targeted_atom == src.loc)
		return
	var/turf/startloc = get_turf(src)
	if(casingtype)
		var/obj/item/ammo_casing/casing = new casingtype
		playsound(src, projectilesound, 100, 1, channel = "regular", time = 10)
		casing.fire(targeted_atom, src, zone_override = ran_zone())
		casing.loc = startloc
	else if(projectiletype)
		var/obj/item/projectile/P = new projectiletype(src.loc)
		playsound(src, projectilesound, 100, 1, channel = "regular", time = 10)
		P.current = startloc
		P.starting = startloc
		P.firer = src
		P.yo = targeted_atom.y - startloc.y
		P.xo = targeted_atom.x - startloc.x
		if(AIStatus == AI_OFF)//Don't want mindless mobs to have their movement screwed up firing in space
			newtonian_move(get_dir(targeted_atom, src))
		P.original = targeted_atom
		P.fire()
	return


/mob/living/simple_animal/hostile/proc/DestroySurroundings()
	if(environment_smash)
		EscapeConfinement()
		for(var/dir in GLOB.cardinal)
			var/turf/T = get_step(src, dir)
			if(istype(T, /turf/simulated/wall))
				if(T.Adjacent(src))
					T.attack_animal(src)
			for(var/atom/A in T)
				if(!A.Adjacent(src))
					continue
				if(istype(A, /obj/structure/window) || istype(A, /obj/structure/closet) || istype(A, /obj/structure/table) || istype(A, /obj/structure/grille))
					A.attack_animal(src)
	return

/mob/living/simple_animal/hostile/proc/EscapeConfinement()
	if(buckled)
		buckled.attack_animal(src)
	if(!isturf(src.loc) && src.loc != null)//Did someone put us in something?
		var/atom/A = src.loc
		A.attack_animal(src)//Bang on it till we get out
	return

/mob/living/simple_animal/hostile/proc/FindHidden()
	if(istype(target.loc, /obj/structure/closet))
		var/atom/A = target.loc
		Goto(A,move_to_delay,minimum_distance)
		if(A.Adjacent(src))
			A.attack_animal(src)
		return 1

/mob/living/simple_animal/hostile/RangedAttack(atom/A, params) //Player firing
	if(ranged && ranged_cooldown <= 0)
		target = A
		OpenFire(A)
	..()


/mob/living/simple_animal/hostile/bullet_act(obj/item/projectile/P)
	..()
	if(!target && P.firer)
		target = P.firer
		Goto(P.firer,move_to_delay,minimum_distance)


////// AI Status ///////
/mob/living/simple_animal/hostile/proc/AICanContinue(var/list/possible_targets)
	switch(AIStatus)
		if(AI_ON)
			. = 1
		if(AI_IDLE)
			if(FindTarget(possible_targets, 1))
				. = 1
				AIStatus = AI_ON //Wake up for more than one Life() cycle.
			else
				. = 0

/mob/living/simple_animal/hostile/proc/AIShouldSleep(var/list/possible_targets)
	return !FindTarget(possible_targets, 1)