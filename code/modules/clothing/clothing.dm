/obj/item/clothing
	name = "clothing"
	burn_state = FLAMMABLE
	var/flash_protect = 0		//Malk: What level of bright light protection item has. 1 = Flashers, Flashes, & Flashbangs | 2 = Welding | -1 = OH GOD WELDING BURNT OUT MY RETINAS
	var/tint = 0				//Malk: Sets the item's level of visual impairment tint, normally set to the same as flash_protect
	var/up = 0					//	   but seperated to allow items to protect but not impair vision, like space helmets
	var/visor_flags = 0			// flags that are added/removed when an item is adjusted up/down
	var/visor_flags_inv = 0		// same as visor_flags, but for flags_inv
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	var/alt_desc = null
	var/toggle_message = null
	var/alt_toggle_message = null
	var/active_sound = null
	var/toggle_cooldown = null
	var/cooldown = 0
	var/obj/item/device/flashlight/F = null
	var/can_flashlight = 0
	var/gang //Is this a gang outfit?
	var/scan_reagents = 0 //Can the wearer see reagents while it's equipped?
	var/weight_alpha = 1
	var/obj/item/weapon/storage/internal/pocket/pockets = null

/obj/item/clothing/New()
	..()
	if(ispath(pockets))
		pockets = new pockets(src)

/obj/item/clothing/MouseDrop(atom/over_object)
	var/mob/M = usr

	if(pockets && over_object == M)
		playsound(loc, "rustle", 50, 1, -5, channel = "regular", time = 5)
		return pockets.MouseDrop(over_object)

	if(!M.restrained() && !M.stat && loc == M && istype(over_object, /obj/screen/inventory/hand))
		var/obj/screen/inventory/hand/H = over_object
		if(!M.unEquip(src))
			return
		M.put_in_hand(src, H.held_index)
		add_fingerprint(usr)

/obj/item/clothing/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, speed_sleep = 1)
	if(pockets)
		pockets.close_all()
	return ..()

/obj/item/clothing/attack_hand(mob/user)
	if(pockets && pockets.priority && ismob(loc))
		playsound(loc, "rustle", 50, 1, -5, channel = "regular", time = 5)
		pockets.show_to(user)
	else
		return ..()

/obj/item/clothing/attackby(obj/item/W, mob/user, params)
	if(pockets && pockets.priority && ismob(loc))
		pockets.attackby(W, user, params)
	else
		return ..()

/obj/item/clothing/AltClick(mob/user)
	if(pockets && pockets.quickdraw && pockets.contents.len && !user.incapacitated())
		var/obj/item/I = pockets.contents[1]
		if(!I)
			return
		pockets.remove_from_storage(I, get_turf(src))

		if(!user.put_in_hands(I))
			user << "<span class='notice'>You fumble for [I] and it falls on the floor.</span>"
			return 1
		user.visible_message("<span class='warning'>[user] draws [I] from [src]!</span>", "<span class='notice'>You draw [I] from [src].</span>")
		return 1
	else
		return ..()

/obj/item/clothing/Destroy()
	if(isliving(loc))
		dropped(loc)
	if(pockets)
		qdel(pockets)
		pockets = null
	return ..()

//Ears: currently only used for headsets and earmuffs
/obj/item/clothing/ears
	name = "ears"
	w_class = 1
	throwforce = 0
	slot_flags = SLOT_EARS
	burn_state = FIRE_PROOF

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	flags = EARBANGPROTECT
	strip_delay = 15
	put_on_delay = 25
	burn_state = FLAMMABLE

//Glasses
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = 2
	flags_cover = GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 2//Base human is 2
	var/invis_view = SEE_INVISIBLE_LIVING
	var/invis_override = 0 //Override to allow glasses to set higher than normal see_invis
	var/emagged = 0
	var/list/icon/current = list() //the current hud icons
	strip_delay = 20
	put_on_delay = 25
	burn_state = FIRE_PROOF
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/


//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 0.50
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	var/transfer_prints = FALSE
	strip_delay = 20
	put_on_delay = 40


/obj/item/clothing/gloves/worn_overlays(var/isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(blood_DNA)
			. += image("icon"='icons/effects/blood.dmi', "icon_state"="bloodyhands")


// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(atom/A, proximity)
	return 0 // return 1 to cancel attack_hand()

//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/hats.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	var/blockTracking = 0 //For AI tracking
	var/can_toggle = null


/obj/item/clothing/head/worn_overlays(var/isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(blood_DNA)
			. += image("icon"='icons/effects/blood.dmi', "icon_state"="helmetblood")

//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/masks.dmi'
	body_parts_covered = HEAD
	slot_flags = SLOT_MASK
	strip_delay = 40
	put_on_delay = 40
	var/mask_adjusted = 0
	var/ignore_maskadjust = 1
	var/adjusted_flags = null


/obj/item/clothing/mask/worn_overlays(var/isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(blood_DNA && (body_parts_covered & HEAD))
			. += image("icon"='icons/effects/blood.dmi', "icon_state"="maskblood")

//Override this to modify speech like luchador masks.
/obj/item/clothing/mask/proc/speechModification(message)
	return message

//Proc that moves gas/breath masks out of the way, disabling them and allowing pill/food consumption
/obj/item/clothing/mask/proc/adjustmask(mob/user)
	if(!ignore_maskadjust)
		if(user.incapacitated())
			return
		if(src.mask_adjusted == 1)
			src.icon_state = initial(icon_state)
			gas_transfer_coefficient = initial(gas_transfer_coefficient)
			permeability_coefficient = initial(permeability_coefficient)
			flags |= visor_flags
			flags_inv |= visor_flags_inv
			flags_cover = initial(flags_cover)
			user << "<span class='notice'>You push \the [src] back into place.</span>"
			src.mask_adjusted = 0
			slot_flags = initial(slot_flags)
		else
			src.icon_state += "_up"
			user << "<span class='notice'>You push \the [src] out of the way.</span>"
			gas_transfer_coefficient = null
			permeability_coefficient = null
			flags &= ~visor_flags
			flags_inv &= ~visor_flags_inv
			flags_cover &= 0
			src.mask_adjusted = 1
			if(adjusted_flags)
				slot_flags = adjusted_flags
		usr.update_inv_wear_mask()




//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing
	var/chained = 0

	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	var/blood_state = BLOOD_STATE_NOT_BLOODY
	var/list/bloody_shoes = list(BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)


/obj/item/clothing/shoes/worn_overlays(var/isinhands = FALSE)
	. = list()
	if(!isinhands)
		var/bloody = 0
		if(blood_DNA)
			bloody = 1
		else
			bloody = bloody_shoes[BLOOD_STATE_HUMAN]

		if(bloody)
			. += image("icon"='icons/effects/blood.dmi', "icon_state"="shoeblood")


/obj/item/clothing/shoes/clean_blood()
	..()
	bloody_shoes = list(BLOOD_STATE_HUMAN = 0,BLOOD_STATE_XENO = 0, BLOOD_STATE_OIL = 0, BLOOD_STATE_NOT_BLOODY = 0)
	blood_state = BLOOD_STATE_NOT_BLOODY
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_shoes()


/obj/item/proc/negates_gravity()
	return 0

//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	var/togglename = null


/obj/item/clothing/suit/worn_overlays(var/isinhands = FALSE)
	. = list()
	if(!isinhands)
		if(blood_DNA)
			. += image("icon"='icons/effects/blood.dmi', "icon_state"="[blood_overlay_type]blood")

//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!
/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "spaceold"
	desc = "A special helmet with solar UV shielding to protect your eyes from harmful rays."
	flags = BLOCKHAIR | STOPSPRESSUREDMAGE | THICKMATERIAL
	item_state = "spaceold"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = 2
	strip_delay = 50
	put_on_delay = 50
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	burn_state = FIRE_PROOF

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments. Has a big 13 on the back."
	icon_state = "spaceold"
	item_state = "s_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = STOPSPRESSUREDMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/internals)
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	strip_delay = 80
	put_on_delay = 80
	burn_state = FIRE_PROOF

//Under clothing

/obj/item/clothing/under
	icon = 'icons/obj/clothing/uniforms.dmi'
	name = "under"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/fitted = FEMALE_UNIFORM_FULL // For use in alternate clothing styles for women
	var/has_sensor = 1//For the crew computer 2 = unable to change mode
	var/random_sensor = 1
	var/sensor_mode = 0	/* 1 = Report living/dead, 2 = Report detailed damages, 3 = Report location */
	var/can_adjust = 1
	var/adjusted = 0
	var/alt_covers_chest = 0 // for adjusted/rolled-down jumpsuits, 0 = exposes chest and arms, 1 = exposes arms only
	var/suit_color = null
	var/obj/item/clothing/tie/hastie = null


/obj/item/clothing/under/worn_overlays(var/isinhands = FALSE)
	. = list()

	if(!isinhands)
		if(blood_DNA)
			. += image("icon"='icons/effects/blood.dmi', "icon_state"="uniformblood")


/obj/item/clothing/under/New()
	if(random_sensor)
		sensor_mode = pick(0,1,2,3)
	adjusted = 0
	suit_color = item_color
	..()

/obj/item/clothing/under/attackby(obj/item/I, mob/user, params)
	..()
/*
/obj/item/clothing/under/examine(mob/user)
	..()
	switch(src.sensor_mode)
		if(0)
			user << "Its sensors appear to be disabled."
		if(1)
			user << "Its binary life sensors appear to be enabled."
		if(2)
			user << "Its vital tracker appears to be enabled."
		if(3)
			user << "Its vital tracker and tracking beacon appear to be enabled."
	if(hastie)
		user << "\A [hastie] is attached to it."
*/

/proc/generate_female_clothing(index,t_color,icon,type)
	var/icon/female_clothing_icon	= icon("icon"=icon, "icon_state"=t_color)
	var/icon/female_s				= icon("icon"='icons/mob/uniform.dmi', "icon_state"="[(type == FEMALE_UNIFORM_FULL) ? "female_full" : "female_top"]")
	female_clothing_icon.Blend(female_s, ICON_MULTIPLY)
	female_clothing_icon 			= fcopy_rsc(female_clothing_icon)
	GLOB.female_clothing_icons[index] = female_clothing_icon

/*
/obj/item/clothing/under/verb/toggle()
	set name = "Adjust Suit Sensors"
	set category = "Object"
	set src in usr
	var/mob/M = usr
	if (istype(M, /mob/dead/))
		return
	if (!can_use(M))
		return
	if(src.has_sensor >= 2)
		usr << "The controls are locked."
		return 0
	if(src.has_sensor <= 0)
		usr << "This suit does not have any sensors."
		return 0


	var/list/modes = list("Off", "Binary vitals", "Exact vitals", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		usr << "<span class='warning'>You have moved too far away!</span>"
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				usr << "<span class='notice'>You disable your suit's remote sensing equipment.</span>"
			if(1)
				usr << "<span class='notice'>Your suit will now only report whether you are alive or dead.</span>"
			if(2)
				usr << "<span class='notice'>Your suit will now only report your exact vital lifesigns.</span>"
			if(3)
				usr << "<span class='notice'>Your suit will now report your exact vital lifesigns as well as your coordinate position.</span>"

	if(istype(loc,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = loc
		if(H.w_uniform == src)
			H.update_suit_sensors()

	..()
*/
/obj/item/clothing/under/AltClick(mob/user)
	..()
	if(!user.canUseTopic(user))
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(!in_range(src, user))
		return
	else
		rolldown()

/obj/item/clothing/under/verb/jumpsuit_adjust()
	set name = "Adjust Jumpsuit Style"
	set category = null
	set src in usr
	rolldown()

/obj/item/clothing/under/proc/rolldown()
	if(!can_use(usr))
		return
	if(!can_adjust)
		usr << "<span class='warning'>You cannot wear this suit any differently!</span>"
		return
	if(src.adjusted == 1)
		src.fitted = initial(fitted)
		src.item_color = initial(item_color)
		src.item_color = src.suit_color //colored jumpsuits are shit and break without this
		src.body_parts_covered = CHEST|LEGS|ARMS//|GROIN
		usr << "<span class='notice'>You adjust the suit back to normal.</span>"
		src.adjusted = 0
	else
		if(src.fitted != FEMALE_UNIFORM_TOP)
			src.fitted = NO_FEMALE_UNIFORM
		src.item_color += "_d"
		if (alt_covers_chest) // for the special snowflake suits that don't expose the chest when adjusted
			src.body_parts_covered = CHEST|LEGS//|GROIN
		else
			src.body_parts_covered = LEGS//|GROIN
		usr << "<span class='notice'>You adjust the suit to wear it more casually.</span>"
		src.adjusted = 1
	usr.update_inv_w_uniform()
	..()

/*
/obj/item/clothing/under/examine(mob/user)
	..()
	if(src.adjusted)
		user << "Alt-click on [src] to wear it normally."
	else
		user << "Alt-click on [src] to wear it casually."
*/


/obj/item/clothing/proc/weldingvisortoggle()			//Malk: proc to toggle welding visors on helmets, masks, goggles, etc.
	if(!can_use(usr))
		return

	up ^= 1
	flags ^= visor_flags
	flags_inv ^= visor_flags_inv
	flags_cover ^= initial(flags_cover)
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	//usr << "<span class='notice'>You adjust \the [src] [up ? "up" : "down"].</span>"
	flash_protect ^= initial(flash_protect)
	tint ^= initial(tint)

	if(istype(src, /obj/item/clothing/head))			//makes the mob-overlays update //this is awful
		usr.update_inv_head()
	if(istype(src, /obj/item/clothing/glasses))
		usr.update_inv_glasses()
	if(istype(src, /obj/item/clothing/mask))
		usr.update_inv_wear_mask()
	if(istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.head_update(src, forced = 1)

/obj/item/clothing/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0