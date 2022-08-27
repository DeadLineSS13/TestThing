GLOBAL_LIST_EMPTY(mob_spawners)

/obj/effect/mob_spawner
	name = "mob spawner"
	invisibility = 101
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	var/mob/living/simple_animal/spawner = null
	var/amount = 1
	var/in_group = 0
	var/range = 3


/obj/effect/mob_spawner/Initialize()
	..()
	GLOB.mob_spawners.Add(src)
	mob_spawn()

/obj/effect/mob_spawner/proc/mob_spawn()
	var/list/turfs = list()
	for(var/turf/T in range(range, src))
		if(!T.density)
			turfs.Add(T)

	var/mob/living/simple_animal/last_spawned = null
	var/list/spawned_mobs = list()
	for(var/i = 1 to amount)
		var/mob/living/simple_animal/S = new spawner(pick(turfs))
		if(in_group)
			spawned_mobs.Add(S)
			last_spawned = S

	if(in_group)
		for(var/mob/living/simple_animal/hostile/S in spawned_mobs)
			S.flock = spawned_mobs.Copy() - S
			if(S != last_spawned)
				S.leader = last_spawned



/obj/effect/mob_spawner/wolfs
	spawner = /mob/living/simple_animal/hostile/mutant/wolf
	amount = 3
	in_group = 1
	range = 3

/obj/effect/mob_spawner/wolfs/Initialize()
	in_group = rand(2, 5)
	..()


/obj/effect/mob_spawner/beller
	spawner = /mob/living/simple_animal/hostile/mutant/beller
	amount = 1
	range = 2


/obj/effect/mob_spawner/spider
	spawner = /mob/living/simple_animal/hostile/mutant/spider
	amount = 1
	range = 2

/obj/effect/mob_spawner/spider/Initialize()
	amount = rand(1, 3)
	..()