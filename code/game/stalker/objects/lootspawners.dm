/obj/effect/spawner/lootdrop/stalker
	name = "stalker lootspawner"
	invisibility = 101
	lootcount = 2
	var/artefact = 0
	var/max_spawned = 3
	var/radius = 10 //Радиус разброса лута
	var/cooldown = 10000 //Кол-во минут * 1000 кд шитспавна
	var/list/spawned_loot = new()
	loot = list(/obj/item/stack/medical/bruise_pack/bint = 75,
				/obj/item/trash/can = 25)

/obj/effect/spawner/lootdrop/stalker/weapon
	lootcount = 1
	loot = list(/obj/item/weapon/gun/projectile/automatic/pistol/pm = 85,
				/obj/item/trash/can = 15)

/obj/effect/spawner/lootdrop/stalker/New()
	SpawnLoot(0)
	SpawnLoot()

/obj/effect/spawner/lootdrop/stalker/proc/SpawnLoot(enable_cooldown = 1)
	if(loot && loot.len)
		if(!enable_cooldown)
			for(var/k = 0, k < lootcount, k++)
				if(!loot.len) return
				var/lootspawn = pickweight(loot)
				if(lootspawn)
					var/turf/T = get_turf(src)
					var/obj/O = new lootspawn(T)
					spawned_loot.Add(O)
					if(artefact)
						O.invisibility = 100
					RandomMove(O)
		else
			spawn(cooldown)
				for(var/k = 0, k < lootcount, k++)
					if(!loot.len) return
					var/lootspawn = pickweight(loot)
					if(lootspawn)
						var/turf/T = get_turf(src)
						var/obj/O = new lootspawn(T)
						spawned_loot.Add(O)
						if(artefact)
							O.invisibility = 100
						RandomMove(O)
				SpawnLoot()

/obj/effect/spawner/lootdrop/stalker/proc/CanSpawn()
	var/count = 0
	var/i = 0
	var/list/ids = new()
	for(var/I in spawned_loot)
		var/obj/O = I
		if(O.loc == src.loc)
			count++
		else
			ids.Add(i)
		i++
	for(var/id in ids)
		spawned_loot.Cut(id, id)
	return max_spawned - count


/obj/effect/spawner/lootdrop/stalker/proc/RandomMove(spawned)
	if(spawned)
		var/turf/T = get_turf(src)
		if(istype(spawned, /obj))
			var/obj/O = spawned
			var/new_x = T.x + rand(-radius, radius)
			var/new_y = T.y + rand(-radius, radius)
			O.Move(locate(new_x, new_y, T.z))
		else
			if(istype(spawned, /mob))
				var/mob/M = spawned
				var/new_x = T.x + rand(-radius, radius)
				var/new_y = T.y + rand(-radius, radius)
				M.Move(locate(new_x, new_y, T.z))
	return spawned

/obj/effect/spawner/lootdrop/stalker/regular
	name = "items spawner"
	lootcount = 1
	radius = 0
	cooldown = 20000

/obj/effect/spawner/lootdrop/stalker/regular/low_grade
	name = "low grade"
	loot = list(/obj/nothing = 20,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva = 7,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/olives = 7,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/kolbasa = 7,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/baton = 7,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/lard = 7,
				/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka/kazaki = 7,
				/obj/item/weapon/reagent_containers/food/drinks/soda_cans/energetic = 7,
				/obj/item/weapon/reagent_containers/food/cauldron = 4,
				/obj/item/weapon/reagent_containers/food/drinks/cup = 4,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/sirok = 3,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/snikers = 4,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/mars = 4,
				/obj/item/device/flashlight/seclite = 2,
				/obj/item/weapon/storage/firstaid/stalker = 2,
				/obj/item/stack/medical/bruise_pack/bint = 4,
				/obj/item/stack/medical/ointment = 3,
				/obj/item/weapon/reagent_containers/hypospray/medipen/stalker/antirad = 1)

/obj/effect/spawner/lootdrop/stalker/regular/medium_grade
	name = "medium grade"
	loot = list(/obj/nothing = 20,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/fish = 8,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/shproti = 8,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/salmon = 8,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/soup = 8,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/bobi = 8,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/govyadina2 = 8,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/buckwheat = 5,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/pineapple = 5,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/cmilk = 4,
				/obj/item/weapon/reagent_containers/food/snacks/stalker/konserva/snack/honey = 4,
				/obj/item/weapon/storage/firstaid/army = 2,
				/obj/item/ammo_box/stalker/b9x18 = 4,
				/obj/item/ammo_box/stalker/b12x70 = 3,
				/obj/item/ammo_box/stalker/b9x19 =4,
				/obj/item/weapon/reagent_containers/pill/antirad = 1)

/obj/effect/spawner/lootdrop/stalker/regular/high_grade
	name = "high grade"
	loot = list(/obj/nothing = 20,
				/obj/item/weapon/storage/firstaid/science = 15,
				/obj/item/ammo_box/stalker/b55645 = 19,
				/obj/item/ammo_box/stalker/b545 = 19,
				/obj/item/clothing/mask/gas/stalker = 15,
				/obj/item/weapon/gun/projectile/automatic/pistol/pm = 5,
				/obj/item/weapon/gun/projectile/automatic/mp5 = 2)


/obj/effect/spawner/lootdrop/stalker/medicine
	name = "stalker medicine"
	lootcount = 1
	loot = list(/obj/item/weapon/storage/firstaid/stalker = 30,
				/obj/item/weapon/storage/firstaid/army = 15,
				/obj/item/weapon/storage/firstaid/science = 5,
				/obj/nothing = 60)

//Лутспавнер не принимает нулы, вместо этого используем объект, который удаляется после спауна
/obj/nothing
	name = "nothing"
	desc = "deletes after spawn"

obj/nothing/New()
	qdel(src)