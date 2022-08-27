var/list/world_trees = list()

/obj/structure/stalker/flora/trees
	name = "tree"
	name_ru = "дерево"
	icon = 'icons/stalker/structure/flora/derevya.dmi'
	layer = 3.2
	density = 0
	opacity = 0
	cast_shadow = TRUE

	alive
		icon_state = "topol1"
		icon_height = 54
		topol
			icon_state = "topol1"
			icon_height = 54

		bereza1
			icon_state = "bereza1"
			icon_height = 51

		bereza2
			icon_state = "bereza2"
			icon_height = 50

		bereza3
			icon_state = "bereza3"
			icon_height = 58

		bereza4
			icon_state = "bereza4"
			icon_height = 58

		el1
			icon_state = "el1"
			icon_height = 57

		el2
			icon_state = "el2"
			icon_height = 59

	leafless
		derevo1
			icon_state = "derevo1ll"

		derevo2
			icon_state = "derevo2ll"

		derevo3
			icon_state = "derevo3ll"

		bereza1
			icon_state = "bereza1ll"

		bereza2
			icon_state = "bereza2ll"

/obj/structure/stalker/flora/trees/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-4,0)
	overlays += image('icons/stalker/structure/flora/krona.dmi', icon_state = icon_state, layer = 6.1)
	overlays += image('icons/stalker/structure/flora/krona2.dmi', icon_state = icon_state, layer = 4.9)
	world_trees += src

/obj/structure/stalker/flora/trees/attackby(obj/item/I, mob/user, params)
	if(flags & IN_PROGRESS)
		return

	if(istype(I,/obj/item/weapon/kitchen/knife))
		flags += IN_PROGRESS
		user << user.client.select_lang("<span class='notice'>Вы начали срезать сухие ветки с дерева.</span>","<span class='notice'>You started cutting dead branches from a tree.</span>")
		if(!do_after(user, 100, target = src))
			flags &= ~IN_PROGRESS
			return
		flags &= ~IN_PROGRESS
		var/B = new /obj/item/stalker/brushwood
		user.put_in_hands(B)
		user << user.client.select_lang("<span class='notice'>Вы собрали немного хвороста!</span>","<span class='notice'>You've gathered some brushwood!</span>")

/obj/structure/stalker/flora/grass
	name = "grass"
	name_ru = "трава"
	icon = 'icons/obj/flora/ausflora.dmi'
	layer = 2.75
	mouse_opacity = 0

/obj/structure/stalker/flora/grass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item))
		return

/obj/structure/stalker/flora/grass/forest
	icon_state = "greengrass_1"

/obj/structure/stalker/flora/grass/forest/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/stalker/flora/grass/forest/LateInitialize()
	var/pixeling = 1
//	var/area/A = get_area(src)
//	if(istype(A, /area/stalker/blowout/outdoor/anomaly))
	var/state = pickweight(list("greengrass" = 48,"trees" = 10, "greenbush" = 15, "rocks" = 3, "darkbush" = 6, "treebush" = 10,"bush" = 1, "branch" = 4, "tall_grass" = 2, "stump" = 1))
	switch(state)
		if("greengrass")
			icon_state = "greengrass_[rand(1, 6)]"
		if("greenbush")
			icon_state = "greengrass_[rand(1, 6)]"
			var/obj/structure/stalker/flora/grass/bush/B = new(loc)
			B.icon_state = "greenbush_[rand(1, 4)]"
			if(prob(5))
				B.berry_type = pick("red", "orange", "blue", "green", "white", "black")
				B.grow_berries()
				if(!B.berry_type == "green")
					B.pixel_x = rand(-16,16)
					B.pixel_y = rand(-16,16)
		if("rocks")
			name = "rocks"
			icon = 'icons/obj/flora/rocks.dmi'
			icon_state = "rocks_[rand(1, 5)]"
			layer = 2.74
		if("darkbush")
			name = "bush"
			icon_state = "firstbush_[rand(1, 4)]"
		if("treebush")
			name = "bush"
			opacity = 0
			layer = 2.76
			if(prob(50))
				icon_state = "treebush_[rand(1, 4)]"
			else
				icon_state = "palebush_[rand(1, 4)]"
		if("bush")
			var/canspawn = 1
			var/near_t = range(1, src)
			if((locate(/turf/simulated/wall) in near_t) || (locate(/turf/stalker/floor/asphalt) in near_t) || (locate(/turf/stalker/floor/road) in near_t))
				canspawn = 0
			if(canspawn)
				var/num = rand(1,3)
				var/obj/structure/stalker/flora/grass/big_bush/ld = new(loc)
				ld.icon_state = "bush[num]_1"
				ld.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[ld.icon_state]_overlay", layer = 5.6)
				var/obj/structure/stalker/flora/grass/big_bush/rd = new(locate(x+1,y,z))
				rd.icon_state = "bush[num]_2"
				rd.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[rd.icon_state]_overlay", layer = 5.6)
				var/obj/structure/stalker/flora/grass/big_bush/lu = new(locate(x,y+1,z))
				lu.icon_state = "bush[num]_3"
				lu.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[lu.icon_state]_overlay", layer = 5.6)
				var/obj/structure/stalker/flora/grass/big_bush/ru = new(locate(x+1,y+1,z))
				ru.icon_state = "bush[num]_4"
				ru.overlays += image(icon = 'icons/stalker/structure/flora/bushes.dmi', icon_state = "[ru.icon_state]_overlay", layer = 5.6)
			qdel(src)
		if("branch")
			name = "branch"
			icon = 'icons/obj/flora/wasteland.dmi'
			icon_state = "branch_[rand(1, 4)]"
			layer = 2.73
		if("tall_grass")
			icon_state = "tall_grass_[rand(1, 4)]"
//		if("flowers")
//			icon_state = "flowers_[rand(1, 14)]"
		if("stump")
			var/S = /obj/structure/stalker/pen
			new S(loc)
		if("trees")
			var/canspawn = 1
			var/near_t = range(1, src)
			if((locate(/turf/simulated/wall) in near_t) || (locate(/turf/stalker/floor/asphalt) in near_t) || (locate(/turf/stalker/floor/road) in near_t))
				canspawn = 0													//Проверяем есть ли рядом стены или дороги
			if(canspawn)
				var/obj/structure/stalker/flora/trees/tree = pick(typesof(/obj/structure/stalker/flora/trees/alive))
				new tree(loc)

	if(pixeling)
		pixel_x = rand(-16,16)
		pixel_y = rand(-16,16)

	CHECK_TICK

/obj/structure/stalker/flora/grass/big_bush
	name = "bush"
	icon = 'icons/stalker/structure/flora/bushes.dmi'
	icon_state = "bush 0,0"
	opacity = 1
	layer = 3.5

/obj/structure/stalker/flora/grass/bush
	name = "bush"
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "greenbush_1"
	layer = 3.5
	mouse_opacity = 1
	var/berry_type = null
	var/berries = 0

/obj/structure/stalker/flora/grass/bush/proc/grow_berries()
	if(!berry_type || berries)
		return
	overlays += "[berry_type]_berries"
	if(berry_type == "green")
		set_light(1, 1, rgb(30,160,0))
	berries = 1

/obj/structure/stalker/flora/grass/bush/attack_hand(mob/user)
	if(berries)
		user << user.client.select_lang("<span class='notice'>Вы начали собирать ягоды.</span>","<span class='notice'>You started to gather berries.</span>")
		if(do_after(user, 100, target = src))
			user << user.client.select_lang("<span class='notice'>Вы собрали немного ягод!</span>","<span class='notice'>You've gathered some berries!</span>")
			var/berr
			switch(berry_type)
				if("red")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/red
				if("orange")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/orange
				if("blue")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/blue
				if("green")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/green
				if("white")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/white
				if("black")
					berr = new /obj/item/weapon/reagent_containers/food/snacks/wild/berries/black
			user.put_in_hands(berr)
			overlays -= "[berry_type]_berries"
			berries = 0
			set_light(0)
			spawn(6000)
				grow_berries()


/obj/structure/stalker/flora/grass/dry
	icon = 'icons/obj/flora/wasteland.dmi'
	icon_state = "tall_grass_4"

/obj/structure/stalker/flora/grass/dry/New()
	var/state = pickweight(list("grass" = 30, "grass_2" = 15, "branch" = 5, "trees" = 10, "null" = 40))
	switch(state)
		if("grass")
			icon_state = "tall_grass_[rand(1, 4)]"
		if("grass_2")
			icon_state = "tall_grass_[rand(5, 8)]"
		if("branch")
			name = "branch"
			icon_state = "branch_[rand(1, 4)]"
			layer = 2.73
		if("null")
			qdel(src)
		if("trees")
			var/canspawn = 1
			var/d_canspawn = 1
			var/b_canspawn = 1
			var/D1 = /obj/structure/stalker/flora/trees/leafless/derevo1
			var/D2 = /obj/structure/stalker/flora/trees/leafless/derevo2
			var/D3 = /obj/structure/stalker/flora/trees/leafless/derevo3
			var/B1 = /obj/structure/stalker/flora/trees/leafless/bereza1
			var/B2 = /obj/structure/stalker/flora/trees/leafless/bereza2
			var/near = range(3, src)											//Проверяем есть ли рядом другие похожие деревья
			if((locate(D1) in near) || (locate(D2) in near) || (locate(D3) in near))
				d_canspawn = 0
				if((locate(B1) in near) || (locate(B2) in near))
					b_canspawn = 0

			var/near_t = range(1, src)
			if((locate(/turf/simulated/wall) in near_t) || (locate(/turf/stalker/floor/asphalt) in near_t) || (locate(/turf/stalker/floor/road) in near_t) || (locate(/turf/stalker/floor/tropa) in near_t))
				canspawn = 0													//Проверяем есть ли рядом стены или дороги

			if(canspawn)														//Создаем деревья
				if(d_canspawn)
					var/d_state = pickweight(list("1" = 33, "2" = 33, "3" = 33))
					switch(d_state)
						if("1")
							new D1(loc)
						if("2")
							new D2(loc)
						if("3")
							new D3(loc)
				else if(b_canspawn)
					if(prob(50))
						new B1(loc)
					else
						new B2(loc)


	pixel_x = rand(-16,16)
	pixel_y = rand(-16,16)

/obj/structure/stalker/flora/grass/swamp/reed
	icon_state = "reedbush_1"

/obj/structure/stalker/flora/grass/swamp/reed/New()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/stalker/flora/grass/swamp/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/stalker/flora/grass/swamp/stalkybush/New()
	icon_state = "stalkybush_[rand(1, 3)]"


/obj/structure/stalker/flora/grass/short_grass
	name = "grass"
	icon = 'icons/stalker/structure/flora/grass.dmi'
	icon_state = "grass_short1"
	layer = 3.3
	var/list/TallGrassEdgeCache

/obj/structure/stalker/flora/grass/short_grass/New()
	..()
	overlays += image('icons/stalker/structure/flora/grass.dmi', "grass_short_overlay", layer = 5.1)

	if(!TallGrassEdgeCache || !TallGrassEdgeCache.len)
		TallGrassEdgeCache = list()
		TallGrassEdgeCache.len = 10
		TallGrassEdgeCache[SOUTH] = image('icons/stalker/structure/flora/grass.dmi', "grass_edge_s", layer = 3.3)
		TallGrassEdgeCache[EAST] = image('icons/stalker/structure/flora/grass.dmi', "grass_edge_e", layer = 3.3)
		TallGrassEdgeCache[WEST] = image('icons/stalker/structure/flora/grass.dmi', "grass_edge_w", layer = 3.3)
		TallGrassEdgeCache[NORTHEAST] = image('icons/stalker/structure/flora/grass.dmi', "grass_edges_n-w", layer = 3.3)
		TallGrassEdgeCache[SOUTHEAST] = image('icons/stalker/structure/flora/grass.dmi', "grass_edges_s-w", layer = 3.3)
		TallGrassEdgeCache[SOUTHWEST] = image('icons/stalker/structure/flora/grass.dmi', "grass_edges_s-e", layer = 3.3)

	spawn(1)
		var/turf/stalker/T = get_turf(src)
		for(var/i = 0, i <= 3, i++)
			if(!get_step(src, 2**i))
				continue
			if(T.overlay_priority+1 > get_step(src, 2**i).overlay_priority)
				T = get_step(src, 2**i)
				if(T && !T.contents.Find(/obj/structure/stalker/flora/grass/tall_grass))
					T.overlays += TallGrassEdgeCache[2**i]
		if(T.overlay_priority+1 > get_step(src, NORTHWEST).overlay_priority)
			T = get_step(src, NORTHWEST)
			if(!T.contents.Find(/obj/structure/stalker/flora/grass/tall_grass))
				T.add_overlay(TallGrassEdgeCache[NORTHWEST])
		if(T.overlay_priority+1 > get_step(src, SOUTHEAST).overlay_priority)
			T = get_step(src, SOUTHEAST)
			if(!T.contents.Find(/obj/structure/stalker/flora/grass/tall_grass))
				T.add_overlay(TallGrassEdgeCache[SOUTHEAST])
		if(T.overlay_priority+1 > get_step(src, SOUTHWEST).overlay_priority)
			T = get_step(src, SOUTHWEST)
			if(!T.contents.Find(/obj/structure/stalker/flora/grass/tall_grass))
				T.add_overlay(TallGrassEdgeCache[SOUTHWEST])

	return

/obj/structure/stalker/flora/grass/tall_grass
	name = "tall grass"
	desc = "Even sprats are invisible in it."
	icon = 'icons/stalker/structure/flora/grass.dmi'
	icon_state = "grass_tall1"
	anchored = 1
	layer = 3.3
	var/image/overlay = null
	var/list/obj/anomaly/triggers = list()
	var/s = FALSE
	var/n = FALSE
	var/w = FALSE
	var/e = FALSE

/obj/structure/stalker/flora/grass/tall_grass/New()
	..()
	icon_state = "grass_tall[rand(1, 3)]"


/obj/structure/stalker/flora/grass/tall_grass/Crossed(atom/A)
	if(istype(A, /obj/anomaly/natural/pugalo))
		switch(icon_state)
			if("grass_tall1")
				flick("grass_tall1_anim", src)
			if("grass_tall2")
				flick("grass_tall2_anim", src)
			if("grass_tall3")
				flick("grass_tall3_anim", src)
	if(isliving(A))
		var/mob/living/L = A
//		if(L.client)
//			L.client.view = 5
		L.overlay_fullscreen("grass", /obj/screen/fullscreen/nvg, 2)
		if(triggers.len)
			for(var/obj/anomaly/natural/pugalo/N in triggers)
				if(!(L in N.trapped) && !(L in N.feared))
					N.trapped.Add(L)
		if(L.dir == SOUTH)
			n = TRUE
			spawn(300)
				n = FALSE
				Update_overlay()
		if(L.dir == NORTH)
			s = TRUE
			spawn(300)
				s = FALSE
				Update_overlay()
		if(L.dir == WEST)
			e = TRUE
			spawn(300)
				e = FALSE
				Update_overlay()
		if(L.dir == EAST)
			w = TRUE
			spawn(300)
				w = FALSE
				Update_overlay()
		Update_overlay()
	..()

/obj/structure/stalker/flora/grass/tall_grass/Uncrossed(atom/A)
	if(isliving(A))
		var/mob/living/L = A
//		if(L.client)
//			L.client.view = 7
		L.clear_fullscreen("grass", 0)
		L.overlays -= overlay
		if(triggers.len)
			for(var/obj/anomaly/natural/pugalo/N in triggers)
				if(L in N.trapped)
					N.trapped.Remove(L)
		if(L.dir == SOUTH)
			s = TRUE
			spawn(300)
				s = FALSE
				Update_overlay()
		if(L.dir == NORTH)
			n = TRUE
			spawn(300)
				n = FALSE
				Update_overlay()
		if(L.dir == WEST)
			w = TRUE
			spawn(300)
				w = FALSE
				Update_overlay()
		if(L.dir == EAST)
			e = TRUE
			spawn(300)
				e = FALSE
				Update_overlay()
		Update_overlay()
	..()

/obj/structure/stalker/flora/grass/tall_grass/proc/Update_overlay()
	var/new_overlay = ""
	overlays = null
	if(s == TRUE) new_overlay += "s"
	if(n == TRUE) new_overlay += "n"
	if(w == TRUE) new_overlay += "w"
	if(e == TRUE) new_overlay += "e"
	overlays += "[new_overlay]"
	switch(icon_state)
		if("grass_tall1")
			overlays += image('icons/stalker/structure/flora/grass.dmi', icon_state = "grass_overlay1", layer = 5.1)
		if("grass_tall2")
			overlays += image('icons/stalker/structure/flora/grass.dmi', icon_state = "grass_overlay2", layer = 5.1)
		if("grass_tall3")
			overlays += image('icons/stalker/structure/flora/grass.dmi', icon_state = "grass_overlay3", layer = 5.1)