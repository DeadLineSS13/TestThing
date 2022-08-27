/obj/item/projectile/bullet/weakbullet //beanbag, heavy stamina damage
	damage_add = 5
	stamina = 80

/obj/item/projectile/bullet/weakbullet2 //detective revolver instastuns, but multiple shots are better for keeping punks down
	damage_add = 15
	weaken = 3
	stamina = 50

/obj/item/projectile/bullet/weakbullet3
	damage_add = 20

/obj/item/projectile/bullet/toxinbullet
	damage_add = 15
	damage_type = TOX

/obj/item/projectile/bullet/incendiary/firebullet
	damage_add = 10

/obj/item/projectile/bullet/armourpiercing
	damage_add = 17
	armour_penetration = 10

/obj/item/projectile/bullet/pellet
	name = "pellet"
	damage_add = 20

/obj/item/projectile/bullet/pellet/weak
	damage_add = 3

/obj/item/projectile/bullet/pellet/random/New()
	damage_add = rand(10)

/obj/item/projectile/bullet/midbullet
	damage_add = 20
	stamina = 65 //two round bursts from the c20r knocks people down


/obj/item/projectile/bullet/midbullet2
	damage_add = 25

/obj/item/projectile/bullet/midbullet3
	damage_add = 30

/obj/item/projectile/bullet/heavybullet
	damage_add = 35

/obj/item/projectile/bullet/rpellet
	damage_add = 3
	stamina = 25

/obj/item/projectile/bullet/stunshot //taser slugs for shotguns, nothing special
	name = "stunshot"
	damage_add = 5
	stun = 5
	weaken = 5
	stutter = 5
	jitter = 20
	range = 7
	icon_state = "spark"
	color = "#FFFF00"

/obj/item/projectile/bullet/incendiary/on_hit(atom/target, blocked = 0)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.IgniteMob()


/obj/item/projectile/bullet/incendiary/shell
	name = "incendiary slug"
	damage_add = 20

/obj/item/projectile/bullet/incendiary/shell/Move()
	..()
	var/turf/location = get_turf(src)
	if(location)
		new/obj/effect/hotspot(location)
		location.hotspot_expose(700, 50, 1)

/obj/item/projectile/bullet/incendiary/shell/dragonsbreath
	name = "dragonsbreath round"
	damage_add = 5


/obj/item/projectile/bullet/meteorshot
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "dust"
	damage_add = 30
	weaken = 8
	stun = 8
	hitsound = 'sound/effects/meteorimpact.ogg'

/obj/item/projectile/bullet/meteorshot/on_hit(atom/target, blocked = 0)
	. = ..()
	if(istype(target, /atom/movable))
		var/atom/movable/M = target
		var/atom/throw_target = get_edge_target_turf(M, get_dir(src, get_step_away(M, src)))
		M.throw_at(throw_target, 3, 2)

/obj/item/projectile/bullet/meteorshot/New()
	..()
	SpinAnimation()


/obj/item/projectile/bullet/mime
	damage_add = 20

/obj/item/projectile/bullet/mime/on_hit(atom/target, blocked = 0)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.silent = max(M.silent, 10)


/obj/item/projectile/bullet/dart
	name = "dart"
	icon_state = "cbbolt"
	damage_add = 6

/obj/item/projectile/bullet/dart/New()
	..()
	flags |= NOREACT
	create_reagents(50)

/obj/item/projectile/bullet/dart/on_hit(atom/target, blocked = 0, hit_zone)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(blocked != 100) // not completely blocked
			if(M.can_inject(null,0,hit_zone)) // Pass the hit zone to see if it can inject by whether it hit the head or the body.
				..()
				reagents.trans_to(M, reagents.total_volume)
				return 1
			else
				blocked = 100
				target.visible_message("<span class='danger'>The [name] was deflected!</span>", \
									   "<span class='userdanger'>You were protected against the [name]!</span>")

	..(target, blocked, hit_zone)
	flags &= ~NOREACT
	reagents.handle_reactions()
	return 1

/obj/item/projectile/bullet/dart/metalfoam
	New()
		..()
		reagents.add_reagent("aluminium", 15)
		reagents.add_reagent("foaming_agent", 5)
		reagents.add_reagent("facid", 5)

//This one is for future syringe guns update
/obj/item/projectile/bullet/dart/syringe
	name = "syringe"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "syringeproj"

/obj/item/projectile/bullet/neurotoxin
	name = "neurotoxin spit"
	icon_state = "neurotoxin"
	damage_add = 5
	damage_type = TOX
	weaken = 5
