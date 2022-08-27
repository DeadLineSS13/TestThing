SUBSYSTEM_DEF(br_zone)
	name = "Battle Royale"
	wait = 20
	var/cooldown = 1200	//Kak chasto ochko zhim zhim
	var/cooldown_ticks = 0
	var/last_ochko = 0
	var/current_r = 0
	var/step = 0.1		//Kak silno ochko zhim zhim v procentah
	var/z = 1
	var/list/w_balls = list() //Salty hairy balls of pekan
	var/list/e_balls = list() //Salty little balls of vallat
	var/list/s_balls = list() //Salty gay furry balls of jacknoir
	var/list/n_balls = list() //Salty rotten dead balls of qwertyo55

	var/vector/c0 = null
	var/vector/c1 = null

	var/vector/centre = null

	wait = 1
	var/speed = 5
	var/licking_balls = 0
	var/obj/structure/closet/crate/stalker/blue/airdrop = null

	var/ON = 0
	var/winner = 0

/datum/controller/subsystem/br_zone/Initialize()
	if(!ON)
		initialized = TRUE
		return
	c0 = new /vector(1, 1)
	c1 = new /vector(world.maxx, world.maxy)

	centre = new /vector(round(world.maxx/2), round(world.maxy/2))


	if(!initialized)
		current_r = round(min((world.maxx/2)-3, (world.maxy/2)-3))
		last_ochko = world.time
		cooldown_ticks = cooldown / world.tick_lag
		SpawnAnomalyCircle()
		initialized = TRUE

/datum/controller/subsystem/br_zone/fire()
	if(!ON)
		return
	if ((world.time - last_ochko) > cooldown)
		var/vector/dist = c1.sub_vector_result(c0)
		zhim_zhim(round(min(dist.x, dist.y) / (2 / (initial(cooldown)/cooldown))))
		cooldown = round(cooldown - cooldown/10)
		cooldown_ticks = round(cooldown / world.tick_lag)

	if(!winner)
		if(world.time > SSticker.round_start_time + cooldown)
			if(GLOB.living_mob_list.len == 1)
				for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
					world << "<span class='userdanger'>And the winner is [H.client]! Congrats!</span>"
					SSticker.force_ending = 1
					winner = 1
					world << "<span class='danger'>The server will be restarted in 60 seconds</span>"
					spawn(600)
						world.Reboot()

/datum/controller/subsystem/br_zone/proc/zhim_zhim(anal_gay)
	var/w_step=0
	var/n_step=0
	var/e_step=0
	var/s_step=0
	for(var/i in 1 to anal_gay)
		switch(rand(1,4))
			if(1)
				w_step++
			if(2)
				n_step++
			if(3)
				e_step++
			if(4)
				s_step++

	c0.add(w_step, s_step)
	c1.sub(e_step, n_step)


	var/vector/dist = c1.sub_vector_result(c0)
	centre = new /vector(c0.x + round(dist.x / 2), c0.y + round(dist.y / 2))

	if(w_step > 0)
		var/move_delay = (cooldown_ticks / 2) / w_step / speed
		for(var/obj/anomaly/natural/tesla_ball_royale/eball in w_balls)
			eball.move_dir = EAST
			eball.steps = w_step
			eball.walk_delay = move_delay
			eball.pizduy()
			CHECK_TICK

	if(n_step > 0)
		var/move_delay = (cooldown_ticks / 2) / n_step / speed
		for(var/obj/anomaly/natural/tesla_ball_royale/eball in n_balls)
			eball.move_dir = SOUTH
			eball.steps = n_step
			eball.walk_delay = move_delay
			eball.pizduy()
			CHECK_TICK

	if(s_step > 0)
		var/move_delay = (cooldown_ticks / 2) / s_step / speed
		for(var/obj/anomaly/natural/tesla_ball_royale/eball in s_balls)
			eball.move_dir = NORTH
			eball.steps = s_step
			eball.walk_delay = move_delay
			eball.pizduy()
			CHECK_TICK

	if(e_step > 0)
		var/move_delay = (cooldown_ticks / 2) / e_step / speed
		for(var/obj/anomaly/natural/tesla_ball_royale/eball in e_balls)
			eball.move_dir = WEST
			eball.steps = e_step
			eball.walk_delay = move_delay
			eball.pizduy()
			CHECK_TICK

	last_ochko = world.time

////	AIR DROP CODE	////

	if(prob(50))
		var/turf/T = get_random_spawn()
		airdrop = new(T)
		airdrop.layer = 2.9
		if(prob(35))
			airdrop.content = list(/obj/item/clothing/suit/karatel,
								/obj/item/clothing/head/karatel)
		else
			airdrop.content = list(/obj/item/clothing/suit/hawk,
											/obj/item/clothing/head/hawk)
		if(airdrop.content.len)
			for(var/I in airdrop.content)
				var/obj/O = I
				new O(airdrop)
		var/obj/O = pickweight(list(/obj/item/weapon/gun/projectile/automatic/pistol/desert = 25,
											/obj/item/weapon/gun/projectile/automatic/p90 = 25,
											/obj/item/weapon/gun/projectile/automatic/saiga = 25,
											/obj/item/weapon/gun/projectile/automatic/m16 = 25))
		if(!istype(O, /obj/item/weapon/gun/projectile/automatic/saiga))
			var/obj/item/weapon/gun/projectile/P = new O(airdrop)
			for(var/i in 1 to 3)
				new P.mag_type(airdrop)
		else if(istype(O, /obj/item/weapon/gun/projectile))
			new /obj/item/ammo_box/stalker/b12x70(airdrop)
		spawn(900)
			qdel(airdrop)
			airdrop = null


/datum/controller/subsystem/br_zone/proc/SpawnAnomalyCircle()
	//GAY NORTH
	for (var/xp in 1 to world.maxx)
		var/turf/T = locate(xp, world.maxy, z)
		n_balls += new /obj/anomaly/natural/tesla_ball_royale(T)

	//GAY SOUTH
	for (var/xp in 1 to world.maxx)
		var/turf/T = locate(xp, 1, z)
		s_balls += new /obj/anomaly/natural/tesla_ball_royale(T)

	//GAY WEST
	for (var/yp in 2 to (world.maxy-1))
		var/turf/T = locate(1, yp, z)
		w_balls += new /obj/anomaly/natural/tesla_ball_royale(T)

	//GAY EAST
	for (var/yp in 2 to (world.maxy-1))
		var/turf/T = locate(world.maxx, yp, z)
		e_balls += new /obj/anomaly/natural/tesla_ball_royale(T)


/datum/controller/subsystem/br_zone/proc/get_random_spawn()
	var/rand_x = rand(c0.x+15, c1.x-15)
	var/rand_y = rand(c0.y+15, c1.y-15)
	var/turf/T = locate(rand_x, rand_y, z)

	return T

/obj/effect/battle_royale_lootspawn
	name = "Loot spawn"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	anchored = 1
	invisibility = 101

/obj/effect/battle_royale_lootspawn/Initialize()
	..()
	if(prob(50))
		var/obj/item/I
		switch(pickweight(list("ammo" = 30, "meds" = 30, "guns" = 20, "armor" = 20)))
			if("ammo")
				I = pickweight(list(/obj/item/ammo_box/stalker/b9x18 = 25,\
										/obj/item/ammo_box/stalker/b9x19 = 20,\
										/obj/item/ammo_box/stalker/bmag44 = 5,\
										/obj/item/ammo_box/stalker/b545 = 15,\
										/obj/item/ammo_box/stalker/b55645 = 10,\
										/obj/item/ammo_box/stalker/b762x39 = 15,\
										/obj/item/ammo_box/stalker/b12x70 = 10
										))
				new I(loc)
			if("meds")
				I = pickweight(list(/obj/item/weapon/reagent_containers/hypospray/medipen/heal_stimulator/medium = 30,\
									/obj/item/weapon/reagent_containers/hypospray/medipen/low_stimulator = 15,\
//									/obj/item/weapon/reagent_containers/hypospray/medipen/morphite = 20,
									/obj/item/stack/medical/bruise_pack/bint = 40,\
									/obj/item/stack/medical/bruise_pack/synth_bint = 15))
				new I(loc)
			if("guns")
				I = pickweight(list(/obj/item/weapon/gun/projectile/automatic/pistol/pm = 20,
										/obj/item/weapon/gun/projectile/automatic/pistol/fort12 = 15,
										/obj/item/weapon/gun/projectile/automatic/pistol/yarigin = 5,
										/obj/item/weapon/gun/projectile/automatic/pistol/fn = 3,
										/obj/item/weapon/gun/projectile/automatic/pistol/desert = 3,
										/obj/item/weapon/gun/projectile/automatic/mp5 = 10,
										/obj/item/weapon/gun/projectile/automatic/aksu74 = 5,
										/obj/item/weapon/gun/projectile/automatic/p90 = 3,
										/obj/item/weapon/gun/projectile/revolver/bm16 = 15,
										/obj/item/weapon/gun/projectile/shotgun/chaser = 10,
										/obj/item/weapon/gun/projectile/automatic/saiga = 3,
										/obj/item/weapon/gun/projectile/automatic/ak74 = 5,
										/obj/item/weapon/gun/projectile/automatic/ak74/akm = 3))
				var/obj/item/weapon/gun/projectile/P = new I(loc)
				if(!istype(P, /obj/item/weapon/gun/projectile/revolver) && !istype(P, /obj/item/weapon/gun/projectile/shotgun))
					for(var/i in 1 to 2)
						new P.mag_type(loc)
				else
					new /obj/item/ammo_box/stalker/b12x70(loc)
			if("armor")
				I = pickweight(list(/obj/item/clothing/head/steel = 20,\
									/obj/item/clothing/head/kazak = 10,\
									/obj/item/clothing/head/hawk = 3,\
									/obj/item/clothing/head/karatel = 2,\
									/obj/item/clothing/suit/obolochka = 30,\
									/obj/item/clothing/suit/kazak = 20,\
									/obj/item/clothing/suit/hawk = 10,\
									/obj/item/clothing/suit/karatel = 5))
				new I(loc)

	qdel(src)