/turf/simulated/wall/r_wall
	name = "reinforced wall"
	desc = "A huge chunk of reinforced metal used to separate rooms."
	icon = 'icons/turf/walls/reinforced_wall.dmi'
	icon_state = "r_wall"
	opacity = 1
	density = 1

	walltype = "rwall"

	var/d_state = 0
	hardness = 10
//	sheet_type = /obj/item/stack/sheet/plasteel
	explosion_block = 2

/turf/simulated/wall/r_wall/break_wall()
//	builtin_sheet.loc = src
//	return (new /obj/structure/girder/reinforced(src))

/turf/simulated/wall/r_wall/devastate_wall()
//	builtin_sheet.loc = src
//	new /obj/item/stack/sheet/metal(src, 2)

/turf/simulated/wall/r_wall/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	if(M.environment_smash == 3)
		dismantle_wall(1)
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1, channel = "regular", time = 10)
		M << "<span class='notice'>You smash through the wall.</span>"
	else
		M << "<span class='warning'>This wall is far too strong for you to destroy.</span>"

/turf/simulated/wall/r_wall/try_destroy(obj/item/weapon/W, mob/user, turf/T)
	return 0

/turf/simulated/wall/r_wall/try_decon(obj/item/weapon/W, mob/user, turf/T)
	//DECONSTRUCTION
	switch(d_state)
		if(0)
			if (istype(W, /obj/item/weapon/wirecutters))
				playsound(src, 'sound/items/Wirecutter.ogg', 100, 1, channel = "regular", time = 10)
				src.d_state = 1
				update_icon()
				user << "<span class='notice'>You cut the outer grille.</span>"
				return 1

		if(1)
			if (istype(W, /obj/item/weapon/screwdriver))
				user << "<span class='notice'>You begin removing the support lines...</span>"
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1, channel = "regular", time = 10)

				if(do_after(user, 40, target = src))
					if( !istype(src, /turf/simulated/wall/r_wall) || !user || !W || !T )
						return 1

					if( d_state == 1 && user.loc == T && user.get_active_held_item() == W )
						src.d_state = 2
						update_icon()
						user << "<span class='notice'>You remove the support lines.</span>"
				return 1

		if(2)
			if( istype(W, /obj/item/weapon/weldingtool) )
				var/obj/item/weapon/weldingtool/WT = W
				if( WT.remove_fuel(0,user) )

					user << "<span class='notice'>You begin slicing through the metal cover...</span>"
					playsound(src, 'sound/items/Welder.ogg', 100, 1, channel = "regular", time = 10)

					if(do_after(user, 60, target = src))
						if( !istype(src, /turf/simulated/wall/r_wall) || !user || !WT || !WT.isOn() || !T )
							return 0

						if( d_state == 2 && user.loc == T && user.get_active_held_item() == WT )
							src.d_state = 3
							update_icon()
							user << "<span class='notice'>You press firmly on the cover, dislodging it.</span>"
				return 1

		if(3)
			if (istype(W, /obj/item/weapon/crowbar))

				user << "<span class='notice'>You struggle to pry off the cover...</span>"
				playsound(src, 'sound/items/Crowbar.ogg', 100, 1, channel = "regular", time = 10)

				if(do_after(user, 100, target = src))
					if( !istype(src, /turf/simulated/wall/r_wall) || !user || !W || !T )
						return 1

					if( d_state == 3 && user.loc == T && user.get_active_held_item() == W )
						src.d_state = 4
						update_icon()
						user << "<span class='notice'>You pry off the cover.</span>"
				return 1

		if(4)
			if (istype(W, /obj/item/weapon/wrench))

				user << "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame...</span>"
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1, channel = "regular", time = 10)

				if(do_after(user, 40, target = src))
					if( !istype(src, /turf/simulated/wall/r_wall) || !user || !W || !T )
						return 1

					if( d_state == 4 && user.loc == T && user.get_active_held_item() == W )
						src.d_state = 5
						update_icon()
						user << "<span class='notice'>You remove the bolts anchoring the support rods.</span>"
				return 1

		if(5)
			if( istype(W, /obj/item/weapon/weldingtool) )
				var/obj/item/weapon/weldingtool/WT = W
				if( WT.remove_fuel(0,user) )

					user << "<span class='notice'>You begin slicing through the support rods...</span>"
					playsound(src, 'sound/items/Welder.ogg', 100, 1, channel = "regular", time = 10)

					if(do_after(user, 100, target = src))
						if( !istype(src, /turf/simulated/wall/r_wall) || !user || !WT || !WT.isOn() || !T )
							return 1

						if( d_state == 5 && user.loc == T && user.get_active_held_item() == WT )
							src.d_state = 6
							update_icon()
							user << "<span class='notice'>You slice through the support rods.</span>"
				return 1

		if(6)
			if( istype(W, /obj/item/weapon/crowbar) )

				user << "<span class='notice'>You struggle to pry off the outer sheath...</span>"
				playsound(src, 'sound/items/Crowbar.ogg', 100, 1, channel = "regular", time = 10)

				if(do_after(user, 100, target = src))
					if( !istype(src, /turf/simulated/wall/r_wall) || !user || !W || !T )
						return 1

					if( user.loc == T && user.get_active_held_item() == W )
						user << "<span class='notice'>You pry off the outer sheath.</span>"
						dismantle_wall()
				return 1
	return 0

/turf/simulated/wall/r_wall/update_icon()
	if(d_state)
		icon_state = "r_wall-[d_state]"
		smooth = SMOOTH_FALSE
		clear_smooth_overlays()
	else
		smooth = SMOOTH_TRUE
		icon_state = ""

/turf/simulated/wall/r_wall/singularity_pull(S, current_size)
	if(current_size >= STAGE_FIVE)
		if(prob(30))
			dismantle_wall()