/* Toys!
 * Contains
 *		Balloons
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Mech prizes
 *		AI core prizes
 *		Cards
 *		Toy nuke
 *		Fake meteor
 *		Carp plushie
 *		Foam armblade
 *		Toy big red button
 *		Beach ball
 *		Toy xeno
 *      Kitty toys!
 *		Snowballs
 */


/obj/item/toy
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0


/*
 * Crayons
 */

/obj/item/toy/crayon
	name = "crayon"
	desc = "A colourful crayon. Looks tasty. Mmmm..."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = 1
	attack_verb = list("attacked", "coloured")
	var/paint_color = "#FF0000" //RGB
	var/drawtype = "rune"
	var/text_buffer = ""
	var/list/graffiti = list("amyjon","face","matt","revolution","engie","guy","end","dwarf","uboa","body","cyka","arrow","star","poseur tag")
	var/list/letters = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
	var/list/numerals = list("0","1","2","3","4","5","6","7","8","9")
	var/list/oriented = list("arrow","body") // These turn to face the same way as the drawer
	var/uses = 30 //-1 or less for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/dat
	var/list/validSurfaces = list(/turf/simulated/floor)
	var/gang = 0 //For marking territory
	var/edible = 1

/obj/item/toy/crayon/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is jamming the [src.name] up \his nose and into \his brain. It looks like \he's trying to commit suicide.</span>")
	return (BRUTELOSS|OXYLOSS)

/obj/item/toy/crayon/New()
	..()
	name = "[colourName] crayon" //Makes crayons identifiable in things like grinders
	drawtype = pick(pick(graffiti), pick(letters), "rune[rand(1,6)]")
/*
	if(config)
		if(config.mutant_races == 1)
			graffiti |= "antilizard"
			graffiti |= "prolizard"

/obj/item/toy/crayon/initialize()
	if(config.mutant_races == 1)
		graffiti |= "antilizard"
		graffiti |= "prolizard"
*/
/obj/item/toy/crayon/attack_self(mob/living/user)
	update_window(user)

/obj/item/toy/crayon/proc/update_window(mob/living/user)
	dat += "<center><h2>Currently selected: [drawtype]</h2><br>"
	dat += "<a href='?src=\ref[src];type=random_letter'>Random letter</a><a href='?src=\ref[src];type=letter'>Pick letter/number</a>"
	dat += "<a href='?src=\ref[src];buffer=1'>Write</a>"
	dat += "<hr>"
	dat += "<h3>Runes:</h3><br>"
	dat += "<a href='?src=\ref[src];type=random_rune'>Random rune</a>"
	for(var/i = 1; i <= 6; i++)
		dat += "<a href='?src=\ref[src];type=rune[i]'>Rune[i]</a>"
		if(!((i + 1) % 3)) //3 buttons in a row
			dat += "<br>"
	dat += "<hr>"
	graffiti.Find()
	dat += "<h3>Graffiti:</h3><br>"
	dat += "<a href='?src=\ref[src];type=random_graffiti'>Random graffiti</a>"
	var/c = 1
	for(var/T in graffiti)
		dat += "<a href='?src=\ref[src];type=[T]'>[T]</a>"
		if(!((c + 1) % 3)) //3 buttons in a row
			dat += "<br>"
		c++
	dat += "<hr>"
	var/datum/browser/popup = new(user, "crayon", name, 300, 500)
	popup.set_content(dat)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	dat = ""

/obj/item/toy/crayon/proc/crayon_text_strip(text)
	var/list/base = text2list(lowertext(text),"")
	var/list/out = list()
	for(var/a in base)
		if(a in (letters|numerals))
			out += a
	return list2text(out)

/obj/item/toy/crayon/Topic(href, href_list, hsrc)
	var/temp = "a"
	if(href_list["buffer"])
		text_buffer = crayon_text_strip(stripped_input(usr,"Choose what to write.", "Scribbles",default = text_buffer))
	if(href_list["type"])
		switch(href_list["type"])
			if("random_letter")
				temp = pick(letters)
			if("letter")
				temp = input("Choose what to write.", "Scribbles") in (letters|numerals)
			if("random_rune")
				temp = "rune[rand(1,6)]"
			if("random_graffiti")
				temp = pick(graffiti)
			else
				temp = href_list["type"]
	if ((usr.restrained() || usr.stat || usr.get_active_held_item() != src))
		return
	drawtype = temp
	update_window(usr)

/obj/item/toy/crayon/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !check_allowed_items(target)) return
	if(!uses)
		user << "<span class='warning'>There is no more of [src.name] left!</span>"
		if(!instant)
			qdel(src)
		return
	if(istype(target, /obj/effect/decal/cleanable))
		target = target.loc
	if(is_type_in_list(target,validSurfaces))

		var/temp = "rune"
		if(letters.Find(drawtype))
			temp = "letter"
		else if(graffiti.Find(drawtype))
			temp = "graffiti"
		else if(numerals.Find(drawtype))
			temp = "number"
/*
		////////////////////////// GANG FUNCTIONS
		var/area/territory
		var/gangID
		if(gang)
			//Determine gang affiliation
			gangID = user.mind.gang_datum

			//Check area validity. Reject space, player-created areas, and non-station z-levels.
			if(gangID)
				territory = get_area(target)
				if(territory && (territory.z == ZLEVEL_STATION) && territory.valid_territory)
					//Check if this area is already tagged by a gang
					if(!(locate(/obj/effect/decal/cleanable/crayon/gang) in target)) //Ignore the check if the tile being sprayed has a gang tag
						if(territory_claimed(territory, user))
							return
					if(locate(/obj/machinery/power/apc) in (user.loc.contents | target.contents))
						user << "<span class='warning'>You cannot tag here.</span>"
						return
				else
					user << "<span class='warning'>[territory] is unsuitable for tagging.</span>"
					return
		/////////////////////////////////////////
*/
		var/graf_rot
		if(oriented.Find(drawtype))
			switch(user.dir)
				if(EAST)
					graf_rot = 90
				if(SOUTH)
					graf_rot = 180
				if(WEST)
					graf_rot = 270
				else
					graf_rot = 0

		user << "<span class='notice'>You start [instant ? "spraying" : "drawing"] a [temp] on the [target.name]...</span>"
		if(instant)
			playsound(user.loc, 'sound/effects/spray.ogg', 5, 1, 5, channel = "regular", time = 10)
		if((instant>0) || do_after(user, 50, target = target))

			if(length(text_buffer))
				drawtype = copytext(text_buffer,1,2)
				text_buffer = copytext(text_buffer,2)
/*
			//Gang functions
			if(gangID)
				//Delete any old markings on this tile, including other gang tags
				if(!(locate(/obj/effect/decal/cleanable/crayon/gang) in target)) //Ignore the check if the tile being sprayed has a gang tag
					if(territory_claimed(territory, user))
						return
				for(var/obj/effect/decal/cleanable/crayon/old_marking in target)
					qdel(old_marking)
				new /obj/effect/decal/cleanable/crayon/gang(target,gangID,"graffiti",graf_rot)
				user << "<span class='notice'>You tagged [territory] for your gang!</span>"
*/
			new /obj/effect/decal/cleanable/crayon(target,paint_color,drawtype,temp,graf_rot)

			user << "<span class='notice'>You finish [instant ? "spraying" : "drawing"] \the [temp].</span>"
			if(instant<0)
				playsound(user.loc, 'sound/effects/spray.ogg', 5, 1, 5, channel = "regular", time = 10)
			if(uses < 0)
				return
			uses = max(0,uses-1)
			if(!uses)
				user << "<span class='warning'>There is no more of [src.name] left!</span>"
				if(!instant)
					qdel(src)
	return

/obj/item/toy/crayon/attack(mob/M, mob/user)
	if(edible && (M == user))
		user << "You take a bite of the [src.name]. Delicious!"
		user.nutrition += 5
		if(uses < 0)
			return
		uses = max(0,uses-5)
		if(!uses)
			user << "<span class='warning'>There is no more of [src.name] left!</span>"
			qdel(src)
	else
		..()

/obj/item/toy/crayon/proc/territory_claimed(area/territory,mob/user)
	return


/obj/item/toy/cards
	burn_state = FLAMMABLE
	burntime = 5
	var/parentdeck = null
	var/deckstyle = "nanotrasen"
	var/card_hitsound = null
	var/card_force = 0
	var/card_throwforce = 0
	var/card_throw_speed = 3
	var/card_throw_range = 7
	var/list/card_attack_verb = list("attacked")

/obj/item/toy/cards/New()
	..()

/obj/item/toy/cards/proc/apply_card_vars(obj/item/toy/cards/newobj, obj/item/toy/cards/sourceobj) // Applies variables for supporting multiple types of card deck
	if(!istype(sourceobj))
		return

/obj/item/toy/cards/deck
	name = "deck of cards"
	desc = "A deck of space-grade playing cards."
	icon = 'icons/obj/toy.dmi'
	deckstyle = "nanotrasen"
	icon_state = "deck_nanotrasen_full"
	w_class = 2
	var/cooldown = 0
	var/obj/machinery/computer/holodeck/holo = null // Holodeck cards should not be infinite
	var/list/cards = list()

/obj/item/toy/cards/deck/New()
	..()
	icon_state = "deck_[deckstyle]_full"
	for(var/i = 2; i <= 10; i++)
		cards += "[i] of Hearts"
		cards += "[i] of Spades"
		cards += "[i] of Clubs"
		cards += "[i] of Diamonds"
	cards += "King of Hearts"
	cards += "King of Spades"
	cards += "King of Clubs"
	cards += "King of Diamonds"
	cards += "Queen of Hearts"
	cards += "Queen of Spades"
	cards += "Queen of Clubs"
	cards += "Queen of Diamonds"
	cards += "Jack of Hearts"
	cards += "Jack of Spades"
	cards += "Jack of Clubs"
	cards += "Jack of Diamonds"
	cards += "Ace of Hearts"
	cards += "Ace of Spades"
	cards += "Ace of Clubs"
	cards += "Ace of Diamonds"


/obj/item/toy/cards/deck/attack_hand(mob/user)
	if(user.lying)
		return
	var/choice = null
	if(cards.len == 0)
		src.icon_state = "deck_[deckstyle]_empty"
		user << "<span class='warning'>There are no more cards to draw!</span>"
		return
	var/obj/item/toy/cards/singlecard/H = new/obj/item/toy/cards/singlecard(user.loc)
//	if(holo)
//		holo.spawned += H // track them leaving the holodeck
	choice = cards[1]
	H.cardname = choice
	H.parentdeck = src
	var/O = src
	H.apply_card_vars(H,O)
	src.cards -= choice
	H.pickup(user)
	user.put_in_active_hand(H)
	user.visible_message("[user] draws a card from the deck.", "<span class='notice'>You draw a card from the deck.</span>")
	if(cards.len > 26)
		src.icon_state = "deck_[deckstyle]_full"
	else if(cards.len > 10)
		src.icon_state = "deck_[deckstyle]_half"
	else if(cards.len > 1)
		src.icon_state = "deck_[deckstyle]_low"

/obj/item/toy/cards/deck/attack_self(mob/user)
	if(cooldown < world.time - 50)
		cards = shuffle(cards)
		playsound(user, 'sound/items/cardshuffle.ogg', 50, 1, channel = "regular", time = 20)
		user.visible_message("[user] shuffles the deck.", "<span class='notice'>You shuffle the deck.</span>")
		cooldown = world.time

/obj/item/toy/cards/deck/attackby(obj/item/toy/cards/singlecard/C, mob/living/user, params)
	..()
	if(istype(C))
		if(C.parentdeck == src)
			if(!user.unEquip(C))
				user << "<span class='warning'>The card is stuck to your hand, you can't add it to the deck!</span>"
				return
			src.cards += C.cardname
			user.visible_message("[user] adds a card to the bottom of the deck.","<span class='notice'>You add the card to the bottom of the deck.</span>")
			qdel(C)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"
		if(cards.len > 26)
			src.icon_state = "deck_[deckstyle]_full"
		else if(cards.len > 10)
			src.icon_state = "deck_[deckstyle]_half"
		else if(cards.len > 1)
			src.icon_state = "deck_[deckstyle]_low"


/obj/item/toy/cards/deck/attackby(obj/item/toy/cards/cardhand/C, mob/living/user, params)
	..()
	if(istype(C))
		if(C.parentdeck == src)
			if(!user.unEquip(C))
				user << "<span class='warning'>The hand of cards is stuck to your hand, you can't add it to the deck!</span>"
				return
			src.cards += C.currenthand
			user.visible_message("[user] puts their hand of cards in the deck.", "<span class='notice'>You put the hand of cards in the deck.</span>")
			qdel(C)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"
		if(cards.len > 26)
			src.icon_state = "deck_[deckstyle]_full"
		else if(cards.len > 10)
			src.icon_state = "deck_[deckstyle]_half"
		else if(cards.len > 1)
			src.icon_state = "deck_[deckstyle]_low"

/obj/item/toy/cards/deck/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(!ishuman(usr) || usr.incapacitated() || usr.lying)
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			usr << "<span class='notice'>You pick up the deck.</span>"

		else if(istype(over_object, /obj/screen))
			switch(over_object.name)
				if("l_hand")
					if(!remove_item_from_storage(M))
						M.unEquip(src)
					M.put_in_l_hand(src)
				else if("r_hand")
					if(!remove_item_from_storage(M))
						M.unEquip(src)
					M.put_in_r_hand(src)
				usr << "<span class='notice'>You pick up the deck.</span>"
	else
		usr << "<span class='warning'>You can't reach it from here!</span>"



/obj/item/toy/cards/cardhand
	name = "hand of cards"
	desc = "A number of cards not in a deck, customarily held in ones hand."
	icon = 'icons/obj/toy.dmi'
	icon_state = "nanotrasen_hand2"
	w_class = 1
	var/list/currenthand = list()
	var/choice = null


/obj/item/toy/cards/cardhand/attack_self(mob/user)
	user.set_machine(src)
	interact(user)

/obj/item/toy/cards/cardhand/interact(mob/user)
	var/dat = "You have:<BR>"
	for(var/t in currenthand)
		dat += "<A href='?src=\ref[src];pick=[t]'>A [t].</A><BR>"
	dat += "Which card will you remove next?"
	var/datum/browser/popup = new(user, "cardhand", "Hand of Cards", 400, 240)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.set_content(dat)
	popup.open()


/obj/item/toy/cards/cardhand/Topic(href, href_list)
	if(..())
		return
	if(usr.stat || !ishuman(usr) || !usr.canmove)
		return
	var/mob/living/carbon/human/cardUser = usr
	var/O = src
	if(href_list["pick"])
		if (cardUser.is_holding(src))
			var/choice = href_list["pick"]
			var/obj/item/toy/cards/singlecard/C = new/obj/item/toy/cards/singlecard(cardUser.loc)
			src.currenthand -= choice
			C.parentdeck = src.parentdeck
			C.cardname = choice
			C.apply_card_vars(C,O)
			C.pickup(cardUser)
			cardUser.put_in_hands(C)
			cardUser.visible_message("<span class='notice'>[cardUser] draws a card from \his hand.</span>", "<span class='notice'>You take the [C.cardname] from your hand.</span>")

			interact(cardUser)
			if(src.currenthand.len < 3)
				src.icon_state = "[deckstyle]_hand2"
			else if(src.currenthand.len < 4)
				src.icon_state = "[deckstyle]_hand3"
			else if(src.currenthand.len < 5)
				src.icon_state = "[deckstyle]_hand4"
			if(src.currenthand.len == 1)
				var/obj/item/toy/cards/singlecard/N = new/obj/item/toy/cards/singlecard(src.loc)
				N.parentdeck = src.parentdeck
				N.cardname = src.currenthand[1]
				N.apply_card_vars(N,O)
				cardUser.unEquip(src)
				N.pickup(cardUser)
				cardUser.put_in_hands(N)
				cardUser << "<span class='notice'>You also take [currenthand[1]] and hold it.</span>"
				cardUser << browse(null, "window=cardhand")
				qdel(src)
		return

/obj/item/toy/cards/cardhand/attackby(obj/item/toy/cards/singlecard/C, mob/living/user, params)
	if(istype(C))
		if(C.parentdeck == src.parentdeck)
			src.currenthand += C.cardname
			user.unEquip(C)
			user.visible_message("[user] adds a card to their hand.", "<span class='notice'>You add the [C.cardname] to your hand.</span>")
			interact(user)
			if(currenthand.len > 4)
				src.icon_state = "[deckstyle]_hand5"
			else if(currenthand.len > 3)
				src.icon_state = "[deckstyle]_hand4"
			else if(currenthand.len > 2)
				src.icon_state = "[deckstyle]_hand3"
			qdel(C)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"

/obj/item/toy/cards/cardhand/apply_card_vars(obj/item/toy/cards/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "[deckstyle]_hand2" // Another dumb hack, without this the hand is invisible (or has the default deckstyle) until another card is added.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	if(sourceobj.burn_state == FIRE_PROOF)
		newobj.burn_state = FIRE_PROOF

/obj/item/toy/cards/singlecard
	name = "card"
	desc = "a card"
	icon = 'icons/obj/toy.dmi'
	icon_state = "singlecard_nanotrasen_down"
	w_class = 1
	var/cardname = null
	var/flipped = 0
	pixel_x = -5


/obj/item/toy/cards/singlecard/examine(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/cardUser = user
		if(cardUser.is_holding(src))
			cardUser.visible_message("[cardUser] checks \his card.", "<span class='notice'>The card reads: [src.cardname]</span>")
		else
			cardUser << "<span class='warning'>You need to have the card in your hand to check it!</span>"


/obj/item/toy/cards/singlecard/verb/Flip()
	set name = "Flip Card"
	set category = "Object"
	set src in range(1)
	if(usr.stat || !ishuman(usr) || !usr.canmove || usr.restrained())
		return
	if(!flipped)
		src.flipped = 1
		if (cardname)
			src.icon_state = "sc_[cardname]_[deckstyle]"
			src.name = src.cardname
		else
			src.icon_state = "sc_Ace of Spades_[deckstyle]"
			src.name = "What Card"
		src.pixel_x = 5
	else if(flipped)
		src.flipped = 0
		src.icon_state = "singlecard_down_[deckstyle]"
		src.name = "card"
		src.pixel_x = -5

/obj/item/toy/cards/singlecard/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard/))
		var/obj/item/toy/cards/singlecard/C = I
		if(C.parentdeck == src.parentdeck)
			var/obj/item/toy/cards/cardhand/H = new/obj/item/toy/cards/cardhand(user.loc)
			H.currenthand += C.cardname
			H.currenthand += src.cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			user.unEquip(C)
			H.pickup(user)
			user.put_in_active_hand(H)
			user << "<span class='notice'>You combine the [C.cardname] and the [src.cardname] into a hand.</span>"
			qdel(C)
			qdel(src)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"

	if(istype(I, /obj/item/toy/cards/cardhand/))
		var/obj/item/toy/cards/cardhand/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.unEquip(src)
			user.visible_message("[user] adds a card to \his hand.", "<span class='notice'>You add the [cardname] to your hand.</span>")
			H.interact(user)
			if(H.currenthand.len > 4)
				H.icon_state = "[deckstyle]_hand5"
			else if(H.currenthand.len > 3)
				H.icon_state = "[deckstyle]_hand4"
			else if(H.currenthand.len > 2)
				H.icon_state = "[deckstyle]_hand3"
			qdel(src)
		else
			user << "<span class='warning'>You can't mix cards from other decks!</span>"


/obj/item/toy/cards/singlecard/attack_self(mob/user)
	if(usr.stat || !ishuman(usr) || !usr.canmove || usr.restrained())
		return
	Flip()

/obj/item/toy/cards/singlecard/apply_card_vars(obj/item/toy/cards/singlecard/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "singlecard_down_[deckstyle]" // Without this the card is invisible until flipped. It's an ugly hack, but it works.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.hitsound = newobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.force = newobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.throwforce = newobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.throw_speed = newobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.throw_range = newobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.attack_verb = newobj.card_attack_verb
