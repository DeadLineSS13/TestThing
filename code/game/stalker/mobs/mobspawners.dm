/obj/effect/spawner/lootdrop/stalker/mobspawner
	name = "mob spawner"
	cooldown = 1000
	var/sticky_mob = 0

/obj/effect/spawner/lootdrop/stalker/mobspawner/SpawnLoot(enable_cooldown = 1)
	sleep(rand(10, 100))
	if(!loot || !loot.len)
		return

	for(var/k = 0, k < CanSpawn(), k++)
		if(!loot.len)
			return

		var/lootspawn = pickweight(loot)

		if(!lootspawn || lootspawn == /obj/nothing)
			return

		if(locate(/mob/living/carbon) in view(7, src))
			SpawnLoot()
			return

		var/mob/living/M = new lootspawn(get_turf(src))

		if(sticky_mob && istype(M, /mob/living/simple_animal))
			var/mob/living/simple_animal/SM = M
			SM.return_to_spawnpoint = 1

		spawned_loot.Add(M)
		sleep(rand(10, 50))

	if(!enable_cooldown)
		SpawnLoot()
		return

	sleep(rand(cooldown, cooldown + 3000))
	SpawnLoot()
	return

/obj/effect/spawner/lootdrop/stalker/mobspawner/CanSpawn()
	var/count = 0
	if(!isnull(spawned_loot))
		for(var/mob/living/M in spawned_loot)
			if(M && M.stat != 2)
				count++
			else
				spawned_loot.Remove(M)

	return Clamp(lootcount - count, 0, lootcount)
