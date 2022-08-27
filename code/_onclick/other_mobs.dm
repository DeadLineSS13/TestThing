/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(atom/A, proximity)
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	if(proximity && istype(G) && G.Touch(A,1))
		return

//	var/override = 0

//	for(var/datum/mutation/human/HM in dna.mutations)
//		override += HM.on_attack_hand(src, A)

//	if(override)	return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user)
	return

/*
/mob/living/carbon/human/RestrainedClickOn(var/atom/A) ---carbons will handle this
	return
*/

/mob/living/carbon/RestrainedClickOn(atom/A)
	return 0

/mob/living/carbon/human/RangedAttack(atom/A)
	if(gloves)
		var/obj/item/clothing/gloves/G = gloves
		if(istype(G) && G.Touch(A,0)) // for magic gloves
			return

//	for(var/datum/mutation/human/HM in dna.mutations)
//		HM.on_ranged_attack(src, A)

	var/turf/T = A
	if(istype(T) && get_dist(src,T) <= 1)
		src.Move_Pulled(T)

/*
	Animals & All Unspecified
*/
/mob/living/UnarmedAttack(atom/A)
	A.attack_animal(src)

/mob/living/simple_animal/hostile/UnarmedAttack(atom/A)
	target = A
	AttackingTarget()

/atom/proc/attack_animal(mob/user)
	return
/mob/living/RestrainedClickOn(atom/A)
	return

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return
