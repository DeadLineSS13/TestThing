/obj/item/weapon/reagent_containers/food/snacks
	name = "snack"
	desc = "Yummy."
	icon = 'icons/obj/food/food.dmi'
	icon_state = null
	var/bitesize = 2
	var/bitecount = 0
	var/trash = null
	var/slice_path		// for sliceable food. path of the item resulting from the slicing
	var/slices_num
	var/eatverb
	var/eatverb_ru
	var/wrapped = 0
	var/dried_type = null
	var/potency = null
	var/dry = 0
	var/cooked_type = null  //for microwave cooking. path of the resulting item after microwaving
	var/filling_color = "#FFFFFF" //color to use when added to custom food.
	var/custom_food_type = null  //for food customizing. path of the custom food to create
	var/junkiness = 0  //for junk food. used to lower human satiety.
	var/list/bonus_reagents = list() //the amount of reagents (usually nutriment and vitamin) added to crafted/cooked snacks, on top of the ingredients reagents.
	var/customfoodfilling = 1 // whether it can be used as filling in custom food
	var/icon_state_opened
	var/desc_opened
	var/desc_ru_opened

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/weapon/reagent_containers/food/snacks/proc/On_Consume()
	if(!usr)	return
	if(!reagents.total_volume)
		usr.unEquip(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return


/obj/item/weapon/reagent_containers/food/snacks/attack_self(mob/user)
	return


/obj/item/weapon/reagent_containers/food/snacks/attack(mob/M, mob/user, def_zone)
	eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	eatverb_ru = pick("жуе", "уминае", "пережевывае")
	if(!reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
		user << user.client.select_lang("<span class='notice'>[src] совсем закончился!</span>", "<span class='notice'>None of [src] left, oh no!</span>")
		M.unEquip(src)	//so icons update :[
		qdel(src)
		return 0
	if(iscarbon(M))
		if(!canconsume(M, user))
			return 0

		var/fullness = M.nutrition + 10
		for(var/datum/reagent/consumable/C in M.reagents.reagent_list) //we add the nutrition value of what we're currently digesting
			fullness += C.nutriment_factor * C.volume / C.metabolization_rate

		if(M == user)								//If you're eating it yourself.
			if(junkiness && M.satiety < -150 && M.nutrition > NUTRITION_LEVEL_STARVING + 50 )
				M << M.client.select_lang("<span class='notice'>Че-то я пережрал... больше не хочется.</span>", "<span class='notice'>You don't feel like eating any more junk food at the moment.</span>")
				return 0

			if(wrapped)
				M << M.client.select_lang("<span class='warning'>Не-а. Сначала стоит вскрыть упаковку [src].</span>", "<span class='warning'>Nope. You should unwrap [src] first.</span>")
				return 0
			else if(fullness <= NUTRITION_LEVEL_STARVING)
				user.direct_visible_message("<span class='notice'>DOER hungrily takes a [eatverb] from \the [src], gobbling it down!</span>",
											"<span class='notice'>You hungrily take a [eatverb] from \the [src], gobbling it down!</span>",
											"<span class='notice'>DOER с остервенением [eatverb_ru]т [name_ru]!</span>",
											"<span class='notice'>Ты с остервенением [eatverb_ru]шь [name_ru]</span>",
											"notice", user)
			else if(fullness > NUTRITION_LEVEL_STARVING && fullness < NUTRITION_LEVEL_HUNGRY)
				user.direct_visible_message("<span class='notice'>DOER hungrily takes a [eatverb] from \the [src].</span>",
											"<span class='notice'>You hungrily take a [eatverb] from \the [src].</span>",
											"<span class='notice'>DOER оголодало [eatverb_ru]т [name_ru].</span>",
											"<span class='notice'>Ты оголодало [eatverb_ru]шь [name_ru].</span>",
											"notice", user)
			else if(fullness > NUTRITION_LEVEL_FED && fullness < NUTRITION_LEVEL_FULL)
				user.direct_visible_message("<span class='notice'>DOER takes a [eatverb] from \the [src].</span>",
											"<span class='notice'>You take a [eatverb] from \the [src].</span>",
											"<span class='notice'>DOER [eatverb_ru]т [name_ru].</span>",
											"<span class='notice'>Ты [eatverb_ru]шь [name_ru].</span>",
											"notice", user)
			else if(fullness > NUTRITION_LEVEL_FULL && fullness < NUTRITION_LEVEL_FAT)
				user.direct_visible_message("<span class='notice'>DOER unwillingly takes a [eatverb] of a bit of \the [src].</span>",
											"<span class='notice'>You unwillingly take a [eatverb] of a bit of \the [src].</span>",
											"<span class='notice'>DOER без энтузиазма [eatverb_ru]т [name_ru].</span>",
											"<span class='notice'>Ты без энтузиазма [eatverb_ru]шь [name_ru].</span>",
											"notice", user)
			else if(fullness > (NUTRITION_LEVEL_FAT * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				user.client.select_lang("<span class='warning'>You cannot force any more of \the [src] to go down your throat!</span>",
										"<span class='warning'>Ой, пиздец... ты не можешь заставить себя сожрать даже кусочек [name_ru]...</span>",
										"warning", user)
				return 0
		else
			if(wrapped)
				return 0
			if(fullness <= (600 * (1 + M.overeatduration / 1000)))
				M.direct_visible_message("<span class='danger'>DOER attempts to feed TARGET [src].</span>",
										"<span class='danger'>You attempts to feed TARGET [src].</span>",
										"<span class='danger'>DOER пытается скормить TARGET [name_ru].</span>",
										"<span class='danger'>You пытаешься скормить TARGET [name_ru].</span>",
										"danger", user, M)
			else
				M.direct_visible_message("<span class='warning'>DOER can't force TARGET to eat any more of the [src]!</span>",
											"<span class='warning'>You can't force TARGET to eat any more of the [src]!</span>",
											"<span class='warning'>DOER больше не может впихнуть ни кусочка [name_ru] в рот TARGET!</span>",
											"<span class='warning'>Ты больше не можешь впихнуть ни кусочка [name_ru] в рот TARGET!</span>",
											"warning", user, M)
				return 0

				if(!do_mob(user, M))
					return
				M.direct_visible_message("<span class='danger'>DOER forces TARGET to eat [src].</span>",
										"<span class='danger'>DOER forces TARGET to eat [src].</span>",
										"<span class='danger'>DOER заставляет TARGET сожрать кусочек [name_ru].</span>",
										"<span class='danger'>Ты заставляешь TARGET сожрать кусочек [name_ru].</span>",
										"danger", user, M)

		if(reagents)								//Handle ingestion of the reagent.
			if(M.satiety > -200)
				M.satiety -= junkiness
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1, channel = "regular", time = 10)
			if(reagents.total_volume)
				var/fraction = min(bitesize/reagents.total_volume, 1)
				reagents.reaction(M, INGEST, fraction)
				reagents.trans_to(M, bitesize)
				bitecount++
				On_Consume()
			return 1

	return 0


/obj/item/weapon/reagent_containers/food/snacks/afterattack(obj/target, mob/user , proximity)
	return


/obj/item/weapon/reagent_containers/food/snacks/examine(mob/user)
	..()
	if(bitecount == 0)
		return
	else if(bitecount == 1)
		user << user.client.select_lang("[src] был кем-то надкушен.","[src] was bitten by someone.")
	else if(bitecount <= 3)
		user << user.client.select_lang("[src] был кем-то надкушен несколько раз.","[src] was bitten [bitecount] times.")
	else
		user << user.client.select_lang("[src] весь надкусан с разных сторон.","[src] was bitten multiple times.")


/obj/item/weapon/reagent_containers/food/snacks/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/storage))
		..() // -> item/attackby()
		return 0
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/S = W
		if(custom_food_type && ispath(custom_food_type))
			if(S.w_class > 2)
				user << "<span class='warning'>[S] is too big for [src]!</span>"
				return 0
			if(!S.customfoodfilling)
				user << "<span class='warning'>[src] can't be filled with [S]!</span>"
				return 0
			if(contents.len >= 20)
				user << "<span class='warning'>You can't add more ingredients to [src]!</span>"
				return 0
//			var/obj/item/weapon/reagent_containers/food/snacks/customizable/C = new custom_food_type(get_turf(src))
//			C.initialize_custom_food(src, S, user)
			return 0
	var/sharp = W.is_sharp()
	if(sharp)
		if(slice(sharp, W, user))
			return 1

//Called when you finish tablecrafting a snack.
/obj/item/weapon/reagent_containers/food/snacks/CheckParts()
	if(bonus_reagents.len)
		for(var/r_id in bonus_reagents)
			var/amount = bonus_reagents[r_id]
			reagents.add_reagent(r_id, amount)

/obj/item/weapon/reagent_containers/food/snacks/proc/slice(accuracy, obj/item/weapon/W, mob/user)
	if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
		return 0

	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc)
		)
		user << "<span class='warning'>You cannot slice [src] here! You need a table or at least a tray.</span>"
		return 1

	var/slices_lost = 0
	if (accuracy >= IS_SHARP_ACCURATE)
		user.visible_message( \
			"[user] slices [src].", \
			"<span class='notice'>You slice [src].</span>" \
		)
	else
		user.visible_message( \
			"[user] inaccurately slices [src] with [W]!", \
			"<span class='notice'>You inaccurately slice [src] with your [W]!</span>" \
		)
		slices_lost = rand(1,min(1,round(slices_num/2)))

	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i=1 to (slices_num-slices_lost))
		var/obj/item/weapon/reagent_containers/food/snacks/slice = new slice_path (loc)
		initialize_slice(slice, reagents_per_slice)
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/proc/initialize_slice(obj/item/weapon/reagent_containers/food/snacks/slice, reagents_per_slice)
	slice.create_reagents(slice.volume)
	reagents.trans_to(slice,reagents_per_slice)
	return

/obj/item/weapon/reagent_containers/food/snacks/proc/update_overlays(obj/item/weapon/reagent_containers/food/snacks/S)
	overlays.Cut()
	var/image/I = new(src.icon, "[initial(icon_state)]_filling")
	if(S.filling_color == "#FFFFFF")
		I.color = pick("#FF0000","#0000FF","#008000","#FFFF00")
	else
		I.color = S.filling_color

	overlays += I

// initialize_cooked_food() is called when microwaving the food
/obj/item/weapon/reagent_containers/food/snacks/proc/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/S, cooking_efficiency = 1)
	S.create_reagents(S.volume)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)
	if(S.bonus_reagents.len)
		for(var/r_id in S.bonus_reagents)
			var/amount = S.bonus_reagents[r_id] * cooking_efficiency
			S.reagents.add_reagent(r_id, amount)

/obj/item/weapon/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.loc = get_turf(src)
	return ..()


//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use omnizine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.

//All foods are distributed among various categories. Use common sense.

/////////////////////////////////////////////////Store////////////////////////////////////////
// All the food items that can store an item inside itself, like bread or cake.


/obj/item/weapon/reagent_containers/food/snacks/store
	w_class = 3
	var/stored_item = 0

/obj/item/weapon/reagent_containers/food/snacks/store/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(W.w_class <= 2 & !istype(W, /obj/item/weapon/reagent_containers/food/snacks)) //can't slip snacks inside, they're used for custom foods.
		if(W.is_sharp())
			return 0
		if(stored_item)
			return 0
		if(!iscarbon(user))
			return 0
		if(contents.len >= 20)
			user << "<span class='warning'>[src] is full.</span>"
			return 0
		user << "<span class='notice'>You slip [W] inside [src].</span>"
		user.unEquip(W)
		add_fingerprint(user)
		contents += W
		stored_item = 1
		return 1 // no afterattack here

/obj/item/weapon/reagent_containers/food/snacks/MouseDrop(atom/over)
	var/turf/T = get_turf(src)
	var/obj/structure/table/TB = locate(/obj/structure/table) in T
	if(TB)
		TB.MouseDrop(over)
	else
		..()
