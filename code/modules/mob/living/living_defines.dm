/mob/living
	see_invisible = SEE_INVISIBLE_LIVING
	languages = HUMAN

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0		//Oxygen depravation damage (no air in lungs)
	var/toxloss = 0		//Toxic damage caused by being poisoned or radiated
	var/fireloss = 0	//Burn damage caused by being way too hot, too cold or burnt.
	var/staminaloss = 0		//Stamina damage, or exhaustion. You recover it slowly naturally, and are stunned if it gets too high. Holodeck and hallucinations deal this.
	var/psyloss = 0 //Psy damage.
	var/enduranceloss = 1000	//?????????? ???????
	var/radiation = 0.001		//1 ???(???), ????? ????????? ? ???

	var/hallucination = 0 //Directly affects how long a mob will hallucinate for

	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	//Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
	var/incorporeal_move = 0 //0 is off, 1 is normal, 2 is for ninjas.

	var/now_pushing = null //used by living/Bump() and living/PushAM() to prevent potential infinite loop.

	var/cameraFollow = null

	var/tod = null // Time of death

	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks = 0 //Tracks how many stacks of fire we have on, max is usually 20

	var/holder = null //The holder for blood crawling
	var/floating = 0
	var/mob_size = MOB_SIZE_HUMAN
	var/metabolism_efficiency = 1 //more or less efficiency to metabolize helpful/harmful reagents and regulate body temperature..
	var/list/image/staticOverlays = list()
	var/has_limbs = 0 //does the mob have distinct limbs?(arms,legs, chest,head)

	var/list/pipes_shown = list()
	var/last_played_vent
	var/list/global_armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0, psy = 0)
	var/smoke_delay = 0 //used to prevent spam with smoke reagent reaction on mob.

	var/list/say_log = list() //a log of what we've said, plain text, no spans or junk, essentially just each individual "message"

	var/last_bumped = 0
	var/unique_name = 0 //if a mob's name should be appended with an id when created e.g. Mob (666)

	var/list/butcher_results = null
	var/bubble_icon = "default"

	var/wet = 0
	var/list/in_vision_cones = list()
	var/stamina_coef = 0
	var/favourite_beer = "ohota"

	var/targeting = 0
	var/last_targeting_time = 0

	var/last_passive_heal = 0