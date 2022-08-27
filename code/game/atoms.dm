/atom
	layer = 3
	plane = GAME_PLANE
	appearance_flags = TILE_BOUND
	var/level = 2
	var/flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/desc_ru
	var/name_ru

	var/ismetal = 0

	///Chemistry.
	var/datum/reagents/reagents = null

	//This atom's HUD (med/sec, etc) images. Associative list.
	var/list/image/hud_list = list()
	//HUD images that this atom can provide.
	var/list/hud_possible

	//Value used to increment ex_act() if reactionary_explosions is on
	var/explosion_block = 0

	var/flags_1 = NONE
	var/list/priority_overlays	//overlays that should remain on top and not normally removed when using cut_overlay functions, like c4.
	var/list/remove_overlays // a very temporary list of overlays to remove
	var/list/add_overlays // a very temporary list of overlays to add


/atom/New(loc, ...)
	if(!name_ru)
		name_ru = name

	var/do_initialize = SSatoms.initialized
	if(do_initialize != INITIALIZATION_INSSATOMS)
		args[1] = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		if(SSatoms.InitAtom(src, args))
			//we were deleted
			return

//Called after New if the map is being loaded. mapload = TRUE
//Called from base of New if the map is not being loaded. mapload = FALSE
//This base must be called or derivatives must set initialized to TRUE
//must not sleep
//Other parameters are passed from New (excluding loc), this does not happen if mapload is TRUE
//Must return an Initialize hint. Defined in __DEFINES/subsystems.dm

//Note: the following functions don't call the base for optimization and must copypasta:
// /turf/Initialize
// /turf/open/space/Initialize

/atom/proc/Initialize(mapload, ...)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	//atom color stuff
//	if(color)
//		add_atom_colour(color, FIXED_COLOUR_PRIORITY)

	if(light_power && light_range)
		update_light()
/*											Эта вот хуерга очень много ресурсов жрет при старте сервера, увеличивая его аптайм в два раза
	if(opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guaranteed to be on afterwards anyways.
*/
//	if(canSmoothWith)
//		canSmoothWith = typelist("canSmoothWith", canSmoothWith)

//	if(datum_outputs)
//		for(var/i in 1 to length(datum_outputs))
//			datum_outputs[i] = SSoutputs.outputs[datum_outputs[i]]
	ComponentInitialize()

	return INITIALIZE_HINT_NORMAL

//called if Initialize returns INITIALIZE_HINT_LATELOAD
/atom/proc/LateInitialize()
	return

// Put your AddComponent() calls here
/atom/proc/ComponentInitialize()
	return

/atom/proc/attack_hulk(mob/living/carbon/human/hulk, do_attack_animation = 0)
	if(do_attack_animation)
		hulk.changeNext_move(CLICK_CD_MELEE)
		add_logs(hulk, src, "punched", "hulk powers")
		hulk.do_attack_animation(src)
	return

/atom/proc/CheckParts()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	qdel(giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/atom/proc/check_eye(mob/user)
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/


/atom/proc/allow_drop()
	return 1

/atom/proc/CheckExit()
	return 1

/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(severity)
	return

/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	. = P.on_hit(src, 0, def_zone)

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *       list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found


/atom/proc/examine(mob/user)
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src]."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "<span class='danger'>blood-stained</span> [name]!"

	var/word = pick("Это", "А это", "Перед тобой")

	if(name_ru)
		if(desc_ru)
			user << user.client.select_lang("\icon[src] [word] [name_ru]. [desc_ru]","\icon[src] That's [f_name] [desc]")
		else
			user << user.client.select_lang("\icon[src] [word] [name_ru]. [desc]","\icon[src] That's [f_name] [desc]")
	else if(desc_ru)
		user << user.client.select_lang("\icon[src]  [word] [name]. [desc_ru]","\icon[src] That's [f_name] [desc]")
	else
		user << "\icon[src]  That's [f_name] [desc]"

	// *****RM
	//user << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"

	if(reagents && is_open_container()) //is_open_container() isn't really the right proc for this, but w/e
		user << "It contains:"
		if(reagents.reagent_list.len)
			if(user.can_see_reagents()) //Show each individual reagent
				for(var/datum/reagent/R in reagents.reagent_list)
					user << "[R.volume] units of [R.name]"
			else //Otherwise, just show the total volume
				var/total_volume = 0
				for(var/datum/reagent/R in reagents.reagent_list)
					total_volume += R.volume
				user << "[total_volume] units of various reagents"
		else
			user << "Nothing."

/atom/proc/relaymove()
	return

/atom/proc/contents_explosion(severity, target)
	for(var/atom/A in contents)
		A.ex_act(severity, target)

/atom/proc/ex_act(severity, target)
	contents_explosion(severity, target)

/atom/proc/blob_act()
	return

/atom/proc/fire_act()
	return

/atom/proc/hitby(atom/movable/AM, skipcatch, hitpush, blocked)
	if(density && !has_gravity(AM)) //thrown stuff bounces off dense stuff in no grav.
		spawn(2)
			step(AM,  turn(AM.dir, 180))

var/list/blood_splatter_icons = list()

/atom/proc/blood_splatter_index()
	return "\ref[initial(icon)]-[initial(icon_state)]"

/atom/proc/add_blood_list(mob/living/carbon/M)
	// Returns 0 if we have that blood already
	if(!istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()
	//if this blood isn't already in the list, add it
	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type
	return 1

//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/M)
	if(!M || !M.has_dna() || rejects_blood())
		return 0
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(NOBLOOD in H.dna.species.specflags)
			return 0
	return 1

/obj/add_blood(mob/living/carbon/M)
	if(!..())
		return 0
	return add_blood_list(M)

/obj/item/add_blood(mob/living/carbon/M)
	var/blood_count = !blood_DNA ? 0 : blood_DNA.len
	if(!..())
		return 0
	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_count && initial(icon) && initial(icon_state))
		//try to find a pre-processed blood-splatter. otherwise, make a new one
		var/index = blood_splatter_index()
		var/icon/blood_splatter_icon = blood_splatter_icons[index]
		if(!blood_splatter_icon)
			blood_splatter_icon = icon(initial(icon), initial(icon_state), , 1)		//we only want to apply blood-splatters to the initial icon_state for each object
			blood_splatter_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
			blood_splatter_icon.Blend(icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
			blood_splatter_icon = fcopy_rsc(blood_splatter_icon)
			blood_splatter_icons[index] = blood_splatter_icon
		overlays += blood_splatter_icon
	return 1 //we applied blood to the item

/obj/item/clothing/gloves/add_blood(mob/living/carbon/M)
	if(!..())
		return 0
	transfer_blood = rand(2, 4)
	bloody_hands_mob = M
	return 1

/turf/simulated/add_blood(mob/living/carbon/human/M)
	if(!..())
		return 0

	var/obj/effect/decal/cleanable/blood/B = locate() in contents	//check for existing blood splatter
	if(!B)
		blood_splatter(src,M.get_blood(M.vessel),1)
		B = locate(/obj/effect/decal/cleanable/blood) in contents
	B.add_blood_list(M)
	return 1 //we bloodied the floor

/mob/living/carbon/human/add_blood(mob/living/carbon/M)
	if(!..())
		return 0
	add_blood_list(M)
	bloody_hands = rand(2, 4)
	bloody_hands_mob = M
	update_inv_gloves()	//handles bloody hands overlays and updating
	return 1 //we applied blood to the item

/atom/proc/rejects_blood()
	return 0

/atom/proc/add_vomit_floor(mob/living/carbon/M, toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)
		if(M.reagents)
			M.reagents.trans_to(this, M.reagents.total_volume / 10)
		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

		/*for(var/datum/disease/D in M.viruses)
			var/datum/disease/newDisease = D.Copy(1)
			this.viruses += newDisease
			newDisease.holder = this*/

// Only adds blood on the floor -- Skie
/atom/proc/add_blood_floor(mob/living/carbon/M)
	if(istype(src, /turf/simulated))
		if(M.has_dna())	//mobs with dna = (monkeys + humans at time of writing)
			var/obj/effect/decal/cleanable/blood/B = locate() in contents
			if(!B)
				blood_splatter(src,M,1)
				B = locate(/obj/effect/decal/cleanable/blood) in contents
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.blood_type

/atom/proc/clean_blood()
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1


/atom/proc/get_global_map_pos()
	if(!islist(GLOB.global_map) || isemptylist(GLOB.global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=GLOB.global_map.len,cur_x++)
		y_arr = GLOB.global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	world << "X = [cur_x]; Y = [cur_y]"
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0

/atom/proc/handle_fall()
	return

/atom/proc/handle_slip()
	return
/atom/proc/singularity_act()
	return

/atom/proc/singularity_pull()
	return

/atom/proc/acid_act(acidpwr, toxpwr, acid_volume)
	return

/atom/proc/emag_act()
	return

/atom/proc/narsie_act()
	return

/atom/proc/storage_contents_dump_act(obj/item/weapon/storage/src_object, mob/user)
    return 0

//This proc is called on the location of an atom when the atom is Destroy()'d
/atom/proc/handle_atom_del(atom/A)

// Byond seemingly calls stat, each tick.
// Calling things each tick can get expensive real quick.
// So we slow this down a little.
// See: http://www.byond.com/docs/ref/info.html#/client/proc/Stat
/atom/Stat()
	. = ..()
	sleep(1)

/atom/proc/setDir(newdir)
	dir = newdir

//default shuttleRotate
/atom/proc/shuttleRotate(rotation)
	//rotate our direction
	dir = angle2dir(rotation+dir2angle(dir))

	//resmooth if need be.
	if(smooth)
		smooth_icon(src)

	//rotate the pixel offsets too.
	if (pixel_x || pixel_y)
		if (rotation < 0)
			rotation += 360
		for (var/turntimes=rotation/90;turntimes>0;turntimes--)
			var/oldPX = pixel_x
			var/oldPY = pixel_y
			pixel_x = oldPY
			pixel_y = (oldPX*(-1))

/atom/proc/attack_paw(mob/user)
	return