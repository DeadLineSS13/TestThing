/obj/effect/landmark
	name = "landmark"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	anchored = 1
	unacidable = 1

/obj/effect/landmark/New()
	..()
	tag = text("landmark*[]", name)
	invisibility = 101
	GLOB.landmarks_list += src

	switch(name)			//some of these are probably obsolete
		if("start")
			GLOB.newplayer_start += loc
			qdel(src)
			return
		if("JoinLate")
			GLOB.latejoin += loc
			qdel(src)
			return

	if(!istype(GLOB.jobnamelatejoin[name], /list))
		GLOB.jobnamelatejoin[name] = new /list()
	else
		GLOB.jobnamelatejoin[name] += loc
		qdel(src)
		return

	return 1

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x"
	anchored = 1

/obj/effect/landmark/start/New()
	..()
	tag = "start*[name]"
	invisibility = 101
	GLOB.start_landmarks_list += src
	return 1

/obj/effect/landmark/start/Destroy()
	GLOB.start_landmarks_list -= src
	return ..()

//Department Security spawns

/obj/effect/landmark/start/depsec
	name = "department_sec"

/obj/effect/landmark/start/depsec/New()
	..()
	GLOB.department_security_spawns += src

/obj/effect/landmark/start/depsec/Destroy()
	GLOB.department_security_spawns -= src
	return ..()

/obj/effect/landmark/start/depsec/supply
	name = "supply_sec"

/obj/effect/landmark/start/depsec/medical
	name = "medical_sec"

/obj/effect/landmark/start/depsec/engineering
	name = "engineering_sec"

/obj/effect/landmark/start/depsec/science
	name = "science_sec"




/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/everyone
	name = "JoinLateEveryone"

/obj/effect/landmark/latejoin/ua_soldier
	name = "JoinLateUA Storm Trooper"

/obj/effect/landmark/latejoin/ru_soldier
	name = "JoinLateRU Storm Trooper"

/obj/effect/landmark/latejoin/ua_hunter
	name = "JoinLateUA Hunter"

/obj/effect/landmark/latejoin/ru_hunter
	name = "JoinLateRU Hunter"

/obj/effect/landmark/latejoin/ua_trooper
	name = "JoinLateUA Trooper"

/obj/effect/landmark/latejoin/ru_trooper
	name = "JoinLateRU Trooper"

/obj/effect/landmark/latejoin/ua_bandit
	name = "JoinLateUA Bandit"

/obj/effect/landmark/latejoin/ru_bandit
	name = "JoinLateRU Bandit"

/obj/effect/landmark/latejoin/ua_supersoldier
	name = "JoinLateUA Supersoldier"

/obj/effect/landmark/latejoin/ru_supersoldier
	name = "JoinLateRU Supersoldier"
