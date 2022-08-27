#define SINGLE "single"
#define VERTICAL "vertical"
#define HORIZONTAL "horizontal"

#define METAL 1
#define WOOD 2
#define SAND 3

//Barricades/cover

/obj/structure/barricade
	name = "chest high wall"
	desc = "Looks like this would make good cover."
	anchored = 1
	density = 1
	var/health = 100
	var/maxhealth = 100
	var/proj_pass_rate = 50 //How many projectiles will pass the cover. Lower means stronger cover
	var/ranged_damage_modifier = 1 //Multiply for ranged damage
	var/material = METAL
	var/debris_type


/obj/structure/barricade/proc/take_damage(damage, leave_debris=1, message)
	health -= damage
	if(health <= 0)
		if(message)
			visible_message(message)
		else
			visible_message("<span class='warning'>\The [src] is smashed apart!</span>")
		if(leave_debris && debris_type)
			new debris_type(get_turf(src), 3)
		qdel(src)


/obj/structure/barricade/attack_animal(mob/living/simple_animal/M)
	M.changeNext_move(CLICK_CD_MELEE)
	M.do_attack_animation(src)
	if(M.melee_damage_upper == 0 || (M.melee_damage_type != BRUTE && M.melee_damage_type != BURN))
		return
	visible_message("<span class='danger'>[M] [M.attacktext] [src]!</span>")
	add_logs(M, src, "attacked")
	take_damage(M.melee_damage_upper)

/obj/structure/barricade/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/weldingtool) && user.a_intent == "help" && material == METAL)
		var/obj/item/weapon/weldingtool/WT = I
		if(health < maxhealth)
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin repairing [src]...</span>"
				playsound(loc, 'sound/items/Welder.ogg', 40, 1, channel = "regular", time = 20)
				if(do_after(user, 40/I.toolspeed, target = src))
					health = Clamp(health + 20, 0, maxhealth)
					return

	else
		user.changeNext_move(CLICK_CD_MELEE)
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>", "<span class='warning'>You hit [src] with [I]!</span>")
		take_damage(I.force)
		user.do_attack_animation(src)

/obj/structure/barricade/bullet_act(var/obj/item/projectile/P)
	if(P)
		..()
		take_damage(P.damage_add*ranged_damage_modifier)
		visible_message("<span class='warning'>\The [src] is hit by [P]!</span>")

/obj/structure/barricade/ex_act(severity, target)
	switch(severity)
		if(1)
			visible_message("<span class='warning'>\The [src] is blown apart!</span>")
			qdel(src)
		if(2)
			take_damage(25, message = "<span class='warning'>\The [src] is blown apart!</span>")

/obj/structure/barricade/blob_act()
	take_damage(25, leave_debris = 0, message = "<span class='warning'>The blob eats through \the [src]!</span>")


/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0)//So bullets will fly over and stuff.
	if(height==0)
		return 1
	if(istype(mover, /obj/item/projectile))
		if(!anchored)
			return 1
		var/obj/item/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return 1
		if(prob(proj_pass_rate))
			return 1
		return 0
	else
		return 0





/////BARRICADE TYPES///////

/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "This space is blocked off by a wooden barricade."
	icon = 'icons/obj/structures.dmi'
	icon_state = "woodenbarricade"
	material = WOOD

#undef SINGLE
#undef VERTICAL
#undef HORIZONTAL

#undef METAL
#undef WOOD
#undef SAND
