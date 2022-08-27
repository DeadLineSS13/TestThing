/mob/living/carbon/human
	name = "Unknown"
	name_ru = "�����������"
	real_name = "Unknown"
	voice_name = "Unknown"
	icon = 'icons/mob/human.dmi'
	icon_state = "blank"
	var/last_vote = null

/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	var/in_use = FALSE

#define DUMMY_HUMAN_SLOT_PREFERENCES "dummy_preference_preview"
//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	D.in_use = TRUE
	return D

/proc/unset_busy_human_dummy(slotnumber)
	if(!slotnumber)
		return
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotnumber]
	if(istype(D))
		D.wipe_state()
		D.in_use = FALSE

/mob/living/carbon/human/dummy/proc/wipe_state()
	cut_overlays(TRUE)

/mob/living/carbon/human/New()
	verbs += /mob/living/proc/mob_sleep
	verbs += /mob/living/proc/lay_down

	//initialize dna. for spawned humans; overwritten by other code
	create_dna(src)
	randomize_human(src)
	dna.initialize_dna()

	//initialise organs
	organs = newlist(/obj/item/organ/limb/chest, /*/obj/item/organ/limb/groin,*/ /obj/item/organ/limb/head, /obj/item/organ/limb/l_arm,
					 /obj/item/organ/limb/r_arm, /obj/item/organ/limb/r_leg, /obj/item/organ/limb/l_leg)
	for(var/obj/item/organ/limb/O in organs)
		O.owner = src
	internal_organs += new /obj/item/organ/internal/appendix
	internal_organs += new /obj/item/organ/internal/heart
//	internal_organs += new /obj/item/organ/internal/brain

	for(var/obj/item/organ/internal/I in internal_organs)
		I.Insert(src)

	make_blood()
	if(client)
		get_asset_datum(/datum/asset/simple/kpk).send(src)

	//

	..()
	var/mob/M = src
	faction |= "\ref[M]"
	if(client)
		client.show_popup_menus = 0

/mob/living/carbon/human/prepare_data_huds()
	//Update med hud images...
	..()
	//...sec hud images...
//	sec_hud_set_ID()
//	sec_hud_set_implants()
//	sec_hud_set_security_status()
	//...and display them.
//	add_to_all_human_data_huds()

/mob/living/carbon/human/Destroy()
	if(organs.len)
		for(var/atom/movable/organelle in organs)
			qdel(organelle)
		organs.Cut()

	if(vessel)
		qdel(vessel)
	vessel = null

	wear_suit = null
	wear_suit_hard = null
	head_hard = null
	w_uniform = null
	shoes = null
	belt = null
	gloves = null
	glasses = null
	ears = null
	wear_id = null
	r_store = null
	l_store = null
	s_store = null

	return ..()

/mob/living/carbon/human/Stat()
	..()

	if(statpanel("Status"))
		stat(null, "Intent: [a_intent]")
		stat(null, "Move Mode: [m_intent]")
//		stat(null, "Weight: [get_weight()]kg of [get_max_weight(5)]kg")
//		stat(null, "Endurance: [enduranceloss]")
		if (internal)
			if (!internal.air_contents)
				qdel(internal)
			else
				stat("Internal Atmosphere Info", internal.name)
				stat("Tank Pressure", internal.air_contents.return_pressure())
				stat("Distribution Pressure", internal.distribute_pressure)

/*
	//NINJACODE
	if(istype(wear_suit, /obj/item/clothing/suit/space/space_ninja)) //Only display if actually a ninja.
		var/obj/item/clothing/suit/space/space_ninja/SN = wear_suit
		if(statpanel("SpiderOS"))
			stat("SpiderOS Status:","[SN.s_initialized ? "Initialized" : "Disabled"]")
			stat("Current Time:", "[worldtime2text()]")
			if(SN.s_initialized)
				//Suit gear
				stat("Energy Charge:", "[round(SN.cell.charge/100)]%")
				stat("Smoke Bombs:", "\Roman [SN.s_bombs]")
				//Ninja status
				stat("Fingerprints:", "[md5(dna.uni_identity)]")
				stat("Unique Identity:", "[dna.unique_enzymes]")
				stat("Overall Status:", "[stat > 1 ? "dead" : "[health]% healthy"]")
				stat("Nutrition Status:", "[nutrition]")
				stat("Oxygen Loss:", "[getOxyLoss()]")
				stat("Toxin Levels:", "[getToxLoss()]")
				stat("Burn Severity:", "[getFireLoss()]")
				stat("Brute Trauma:", "[getBruteLoss()]")
				stat("Radiation Levels:","[radiation] rad")
				stat("Body Temperature:","[bodytemperature-T0C] degrees C ([bodytemperature*1.8-459.67] degrees F)")

				//Virsuses
				if(viruses.len)
					stat("Viruses:", null)
					for(var/datum/disease/D in viruses)
						stat("*", "[D.name], Type: [D.spread_text], Stage: [D.stage]/[D.max_stages], Possible Cure: [D.cure_text]")
*/

/mob/living/carbon/human/ex_act(severity, ex_target)
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1)
			b_loss += 500
			if (prob(getarmor(null, "bomb")))
//				shred_clothing(1,150)
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(target, 200, 4)
			else
				gib()
				return

		if (2)
			b_loss += 60

			f_loss += 60
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/1.5
				f_loss = f_loss/1.5
//				shred_clothing(1,25)
//			else
//				shred_clothing(1,50)

			if (!istype(ears, /obj/item/clothing/ears/earmuffs))
				adjustEarDamage(30, 120)
			if (prob(70))
				Paralyse(10)

		if(3)
			b_loss += 30
			if (prob(getarmor(null, "bomb")))
				b_loss = b_loss/2
			if (!istype(ears, /obj/item/clothing/ears/earmuffs))
				adjustEarDamage(15,60)
			if (prob(50))
				Paralyse(10)

	var/update = 0
	for(var/obj/item/organ/limb/temp in organs)
		switch(temp.name)
			if("head")
				update |= temp.take_damage(b_loss * 0.2, f_loss * 0.2)
			if("chest")
				update |= temp.take_damage(b_loss * 0.4, f_loss * 0.4)
			if("l_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05)
			if("r_arm")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05)
			if("l_leg")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05)
			if("r_leg")
				update |= temp.take_damage(b_loss * 0.05, f_loss * 0.05)
	if(update)	update_damage_overlays(0)

	..()

/mob/living/carbon/human/show_inv(mob/user)
	if(istype(get_area(src), /area/stalker/kyrilka))
		return
	user.set_machine(src)
	var/has_breathable_mask = istype(wear_mask, /obj/item/clothing/mask)
	var/list/obscured = check_obscured_slots()

	var/dat = "<table>"
	for(var/i in 1 to held_items.len)
		var/obj/item/I = get_item_for_held_index(i)
		dat += "<tr><td><B>[get_held_index_name(i)]:</B></td><td><A href='?src=\ref[src];item=[slot_hands];hand_index=[i]'>[(I && !(I.flags & ABSTRACT)) ? I : "<font color=grey>Empty</font>"]</a></td></tr>"
	dat += "<tr><td>&nbsp;</td></tr>"

	dat += "<tr><td><B>Back:</B></td><td><A href='?src=\ref[src];item=[slot_back]'>[(back && !(back.flags&ABSTRACT)) ? back : "<font color=grey>Empty</font>"]</A>"
	dat += "<tr><td><B>Back2:</B></td><td><A href='?src=\ref[src];item=[slot_back2]'>[(back2 && !(back2.flags&ABSTRACT)) ? back2 : "<font color=grey>Empty</font>"]</A>"
	if(has_breathable_mask && istype(back, /obj/item/weapon/tank))
		dat += "&nbsp;<A href='?src=\ref[src];internal=[slot_back]'>[internal ? "Disable Internals" : "Set Internals"]</A>"

	dat += "</td></tr><tr><td>&nbsp;</td></tr>"

	dat += "<tr><td><B>Upper Head:</B></td><td><A href='?src=\ref[src];item=[slot_head]'>[(head && !(head.flags&ABSTRACT)) ? head : "<font color=grey>Empty</font>"]</A></td></tr>"
	dat += "<tr><td><B>Lower Head:</B></td><td><A href='?src=\ref[src];item=[slot_head_hard]'>[(head_hard && !(head_hard.flags&ABSTRACT)) ? head_hard : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_wear_mask in obscured)
		dat += "<tr><td><font color=grey><B>Mask:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Mask:</B></td><td><A href='?src=\ref[src];item=[slot_wear_mask]'>[(wear_mask && !(wear_mask.flags&ABSTRACT)) ? wear_mask : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_glasses in obscured)
		dat += "<tr><td><font color=grey><B>Eyes:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Eyes:</B></td><td><A href='?src=\ref[src];item=[slot_glasses]'>[(glasses && !(glasses.flags&ABSTRACT))	? glasses : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_ears in obscured)
		dat += "<tr><td><font color=grey><B>Ears:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Ears:</B></td><td><A href='?src=\ref[src];item=[slot_ears]'>[(ears && !(ears.flags&ABSTRACT))		? ears		: "<font color=grey>Empty</font>"]</A></td></tr>"

	dat += "<tr><td>&nbsp;</td></tr>"

	dat += "<tr><td><B>Upper Suit:</B></td><td><A href='?src=\ref[src];item=[slot_wear_suit]'>[(wear_suit && !(wear_suit.flags&ABSTRACT)) ? wear_suit : "<font color=grey>Empty</font>"]</A></td></tr>"
	dat += "<tr><td><B>Lower Suit:</B></td><td><A href='?src=\ref[src];item=[slot_wear_suit_hard]'>[(wear_suit_hard && !(wear_suit_hard.flags&ABSTRACT)) ? wear_suit_hard : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_shoes in obscured)
		dat += "<tr><td><font color=grey><B>Shoes:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Shoes:</B></td><td><A href='?src=\ref[src];item=[slot_shoes]'>[(shoes && !(shoes.flags&ABSTRACT))		? shoes		: "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_gloves in obscured)
		dat += "<tr><td><font color=grey><B>Gloves:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Gloves:</B></td><td><A href='?src=\ref[src];item=[slot_gloves]'>[(gloves && !(gloves.flags&ABSTRACT))		? gloves	: "<font color=grey>Empty</font>"]</A></td></tr>"

	if(slot_w_uniform in obscured)
		dat += "<tr><td><font color=grey><B>Uniform:</B></font></td><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><B>Uniform:</B></td><td><A href='?src=\ref[src];item=[slot_w_uniform]'>[(w_uniform && !(w_uniform.flags&ABSTRACT)) ? w_uniform : "<font color=grey>Empty</font>"]</A></td></tr>"

	if((w_uniform == null && !(dna && dna.species.nojumpsuit)) || (slot_w_uniform in obscured))
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>Pockets:</B></font></td></tr>"
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>ID:</B></font></td></tr>"
		dat += "<tr><td><font color=grey>&nbsp;&#8627;<B>Belt:</B></font></td></tr>"
	else
		dat += "<tr><td>&nbsp;&#8627;<B>Belt:</B></td><td><A href='?src=\ref[src];item=[slot_belt]'>[(belt && !(belt.flags&ABSTRACT)) ? belt : "<font color=grey>Empty</font>"]</A>"
		if(has_breathable_mask && istype(belt, /obj/item/weapon/tank))
			dat += "&nbsp;<A href='?src=\ref[src];internal=[slot_belt]'>[internal ? "Disable Internals" : "Set Internals"]</A>"
		dat += "</td></tr>"
		dat += "<tr><td>&nbsp;&#8627;<B>Pockets:</B></td><td><A href='?src=\ref[src];pockets=left'>[(l_store && !(l_store.flags&ABSTRACT)) ? "Left (Full)" : "<font color=grey>Left (Empty)</font>"]</A>"
		dat += "&nbsp;<A href='?src=\ref[src];pockets=right'>[(r_store && !(r_store.flags&ABSTRACT)) ? "Right (Full)" : "<font color=grey>Right (Empty)</font>"]</A></td></tr>"
		dat += "<tr><td>&nbsp;&#8627;<B>ID:</B></td><td><A href='?src=\ref[src];item=[slot_wear_id]'>[(wear_id && !(wear_id.flags&ABSTRACT)) ? wear_id : "<font color=grey>Empty</font>"]</A></td></tr>"

	if(handcuffed)
		dat += "<tr><td><B>Handcuffed:</B> <A href='?src=\ref[src];item=[slot_handcuffed]'>Remove</A></td></tr>"
	if(legcuffed)
		dat += "<tr><td><A href='?src=\ref[src];item=[slot_legcuffed]'>Legcuffed</A></td></tr>"

	dat += {"</table>
	<A href='?src=\ref[user];mach_close=mob\ref[src]'>Close</A>
	"}

	var/datum/browser/popup = new(user, "mob\ref[src]", "[src]", 440, 510)
	popup.set_content(dat)
	popup.open()

// called when something steps onto a human
// this could be made more general, but for now just handle mulebot
/mob/living/carbon/human/Crossed(atom/movable/AM)
//	var/mob/living/simple_animal/bot/mulebot/MB = AM
//	if(istype(MB))
//		MB.RunOver(src)
	if(istype(AM, /obj/anomaly/natural/tesla_ball) || istype(AM, /obj/anomaly/natural/tesla_ball_royale))
		dust()

	//spreadFire(AM)

//Added a safety check in case you want to shock a human mob directly through electrocute_act.
/mob/living/carbon/human/electrocute_act(shock_damage, obj/source, siemens_coeff = 1, safety = 0, override = 0, tesla_shock = 0)
	if(tesla_shock)
		var/total_coeff = 1
		if(gloves)
			var/obj/item/clothing/gloves/G = gloves
			if(G.siemens_coefficient <= 0)
				total_coeff -= 0.5
		if(wear_suit)
			var/obj/item/clothing/suit/S = wear_suit
			if(S.siemens_coefficient <= 0)
				total_coeff -= 0.95
		siemens_coeff = total_coeff
	else if(!safety)
		var/gloves_siemens_coeff = 1
		var/species_siemens_coeff = 1
		if(gloves)
			var/obj/item/clothing/gloves/G = gloves
			gloves_siemens_coeff = G.siemens_coefficient
		if(dna && dna.species)
			species_siemens_coeff = dna.species.siemens_coeff
		siemens_coeff = gloves_siemens_coeff * species_siemens_coeff
	if(heart_attack)
		if(shock_damage * siemens_coeff >= 1 && prob(25))
			heart_attack = 0
			if(stat == CONSCIOUS)
				src << "<span class='notice'>You feel your heart beating again!</span>"
	. = ..(shock_damage,source,siemens_coeff,safety,override,tesla_shock)
	if(.)
		electrocution_animation(40)



/mob/living/carbon/human/Topic(href, href_list)
	if(usr.canUseTopic(src, BE_CLOSE, NO_DEXTERY))

		if(href_list["embedded_object"])
			var/obj/item/I = locate(href_list["embedded_object"])
			var/obj/item/organ/limb/L = locate(href_list["embedded_limb"])
			if(!I || !L || I.loc != src || !(I in L.embedded_objects)) //no item, no limb, or item is not in limb or in the person anymore
				return
			var/time_taken = I.embedded_unsafe_removal_time*I.w_class
			usr.visible_message("<span class='warning'>[usr] attempts to remove [I] from their [L.getDisplayName()].</span>","<span class='notice'>You attempt to remove [I] from your [L.getDisplayName()]... (It will take [time_taken/10] seconds.)</span>")
			if(do_after(usr, time_taken, needhand = 1, target = src))
				if(!I || !L || I.loc != src || !(I in L.embedded_objects))
					return
				L.embedded_objects -= I
				L.take_damage(I.embedded_unsafe_removal_pain_multiplier*I.w_class)//It hurts to rip it out, get surgery you dingus.
				I.loc = get_turf(src)
				usr.put_in_hands(I)
				usr.emote("scream")
				usr.visible_message("[usr] successfully rips [I] out of their [L.getDisplayName()]!","<span class='notice'>You successfully remove [I] from your [L.getDisplayName()].</span>")
				if(!has_embedded_objects())
					clear_alert("embeddedobject")
			return

		if(href_list["item"])
			var/slot = text2num(href_list["item"])
			if(slot in check_obscured_slots())
				usr << "<span class='warning'>You can't reach that! Something is covering it.</span>"
				return

		if(href_list["pockets"])
			var/pocket_side = href_list["pockets"]
			var/pocket_id = (pocket_side == "right" ? slot_r_store : slot_l_store)
			var/obj/item/pocket_item = (pocket_id == slot_r_store ? r_store : l_store)
			var/obj/item/place_item = usr.get_active_held_item() // Item to place in the pocket, if it's empty

			var/delay_denominator = 1
			if(pocket_item && !(pocket_item.flags&ABSTRACT))
				if(pocket_item.flags & NODROP)
					usr << "<span class='warning'>You try to empty [src]'s [pocket_side] pocket, it seems to be stuck!</span>"
				usr << "<span class='notice'>You try to empty [src]'s [pocket_side] pocket.</span>"
			else if(place_item && place_item.mob_can_equip(src, pocket_id, 1) && !(place_item.flags&ABSTRACT))
				usr << "<span class='notice'>You try to place [place_item] into [src]'s [pocket_side] pocket.</span>"
				delay_denominator = 4
			else
				return

			if(do_mob(usr, src, POCKET_STRIP_DELAY/delay_denominator)) //placing an item into the pocket is 4 times faster
				if(pocket_item)
					if(pocket_item == (pocket_id == slot_r_store ? r_store : l_store)) //item still in the pocket we search
						unEquip(pocket_item)
				else
					if(place_item)
						usr.unEquip(place_item)
						equip_to_slot_if_possible(place_item, pocket_id, 0, 1)

				// Update strip window
				if(usr.machine == src && in_range(src, usr))
					show_inv(usr)
			else
				// Display a warning if the user mocks up
				src << "<span class='warning'>You feel your [pocket_side] pocket being fumbled with!</span>"

		..()

/*	if(href_list["KPK"])
		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(istype(H.wear_id, /obj/item/device/stalker_pda))
				if(istype(src.wear_id, /obj/item/device/stalker_pda))
					var/obj/item/device/stalker_pda/KPK_src = src.wear_id
					var/obj/item/device/stalker_pda/KPK = H.wear_id
					if(KPK.hacked == 1 || H.sid == KPK.sid)
						var/datum/data/record/R = find_record("sid", src.sid, GLOB.data_core.stalkers)
						var/datum/data/record/R_H = find_record("sid", H.sid, GLOB.data_core.stalkers)


						if(KPK_src.owner && KPK.owner && R && R_H)
							if(href_list["money_transfer"])
								var/sum = input(H, "Input money amount for transfer.", "KPK", null) as num
								if(isnum(sum) && sum > 0)
									if(R_H.fields["money"] - sum >= 0)
										R.fields["money"] += sum
										R_H.fields["money"] -= sum
										var/n_src	= R.fields["name"]
										var/n		= R_H.fields["name"]

										src << russian_html2text("<p>\icon[KPK_src]<b><font color=\"#006699\">PDA</font>\[OS\]</b><br><font color=\"#006699\">[n] transfered [sum] RU to your account.</font></p>")
										if(KPK_src.switches & FEED_SOUND)
											src << sound('sound/stalker/pda/sms.ogg', volume = 30)

										H << russian_html2text("<p>\icon[KPK]<b><font color=\"#006699\">KPK</font>\[OS\]</b><br><font color=\"#006699\">You transfered [sum] RU to [n_src] account.</font></p>")
										if(KPK.switches & FEED_SOUND)
											H << sound('sound/stalker/pda/sms.ogg', volume = 30)

									else
										usr << "<span class='warning'>You don't have enough RU to commit money transfer.</span>"
								else
									usr << "<span class='warning'>Input real amount of RU for money transfer.</span>"

						var/lefttime
						var/ending

						if(href_list["subtraction_rep"])
							if(R)
								if(src.stat == "dead")
									H << "<span class='warning'>[src] is dead.</span>"
								else
									if(!(last_vote && world.time < last_vote + 3000))
										last_vote = world.time
										R.fields["reputation"] = max(0, R.fields["reputation"] - 20)
										usr << "<span class='notice'>Reputation updated.</span>"
									else
										lefttime = round((3000 + last_vote - world.time)/10)
										ending = ""
										switch (lefttime % 10)
											if(1)
												ending = "�"
											if(2)
												ending = "�"
											if(3)
												ending = "�"
											if(4)
												ending = "�"
										H << "<span class='warning'>�� ������� �������� ��������� ����� [round((3000 + last_vote - world.time)/10)] ������[ending].</span>"


						if(href_list["addition_rep"])
							if(R)
								if(src.stat == "dead")
									H << "<span class='warning'>[src] ����.</span>"
								else
									if(!(last_vote && world.time < last_vote + 3000))
										last_vote = world.time
										R.fields["reputation"] += 20
										usr << "<span class='notice'>Reputation updated.</span>"
									else
										lefttime = round((3000 + last_vote - world.time)/10)
										ending = ""
										switch (lefttime % 10)
											if(1)
												ending = "�"
											if(2)
												ending = "�"
											if(3)
												ending = "�"
											if(4)
												ending = "�"
										H << "<span class='warning'>�� ������� �������� ��������� ����� [round((3000 + last_vote - world.time)/10)] ������[ending].</span>"

					else
						H << "<span class='warning'>� ������� � ������� S.T.A.L.K.E.R. ��������!</span>"
*/
	if(href_list["KPK"])
		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(istype(H.wear_id, /obj/item/device/pager))
				if(istype(wear_id, /obj/item/device/pager))
					var/obj/item/device/pager/P = H.wear_id
					var/obj/item/device/pager/P_s = wear_id
					if(href_list["money_transfer"])
						var/sum = input(H, "Input money amount for transfer.", "KPK", null) as num
						if(isnum(sum) && sum > 0)
							if(P.money - sum >= 0)
								P_s.money += sum
								P.money -= sum
								var/n_src	= src.name
								var/n		= H.name

								src << russian_html2text("<p>\icon[P_s]<b><font color=\"#006699\">PDA</font>\[OS\]</b><br><font color=\"#006699\">[n] transfered [sum] RU to your account.</font></p>")
								src << sound('sound/stalker/pda/sms.ogg', volume = 30, channel = SSchannels.get_channel(5))

								H << russian_html2text("<p>\icon[P]<b><font color=\"#006699\">KPK</font>\[OS\]</b><br><font color=\"#006699\">You transfered [sum] RU to [n_src] account.</font></p>")
								H << sound('sound/stalker/pda/sms.ogg', volume = 30, channel = SSchannels.get_channel(5))

							else
								usr << "<span class='warning'>You don't have enough RU to commit money transfer.</span>"
						else
							usr << "<span class='warning'>Input real amount of RU for money transfer.</span>"

	if(href_list["client"])
		if(istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(href_list["give_name"])
				var/new_name = input(H, "Choose new name", "Name") as text|null
				H.clients_names[src] = sanitize(new_name)

			if(href_list["order"])
				switch(alert(H, "Do what?",,"Order to kill", "Order not to kill"))
					if("Order to kill")
						GLOB.guards_targets |= src
					if("Order not to kill")
						GLOB.guards_targets -= src


/mob/living/carbon/human/proc/canUseHUD()
	return !(src.stat || src.weakened || src.stunned || src.restrained())

/mob/living/carbon/human/can_inject(mob/user, error_msg, target_zone, var/penetrate_thick = 0)
	. = 1 // Default to returning true.
	if(user && !target_zone)
		target_zone = user.zone_selected
	if(dna && PIERCEIMMUNE in dna.species.specflags)
		. = 0
	// If targeting the head, see if the head item is thin enough.
	// If targeting anything else, see if the wear suit is thin enough.
	if(above_neck(target_zone))
		if(head && head.flags & THICKMATERIAL && !penetrate_thick)
			. = 0
	else
		if(wear_suit && wear_suit.flags & THICKMATERIAL && !penetrate_thick)
			. = 0
	if(!. && error_msg && user)
		// Might need re-wording.
		user << "<span class='alert'>There is no exposed flesh or thin material [above_neck(target_zone) ? "on their head" : "on their body"].</span>"

/mob/living/carbon/human/proc/check_obscured_slots()
	var/list/obscured = list()

	if(wear_suit)
		if(wear_suit.flags_inv & HIDEGLOVES)
			obscured |= slot_gloves
		if(wear_suit.flags_inv & HIDEJUMPSUIT)
			obscured |= slot_w_uniform
		if(wear_suit.flags_inv & HIDESHOES)
			obscured |= slot_shoes

	if(head)
		if(head.flags_inv & HIDEMASK)
			obscured |= slot_wear_mask
		if(head.flags_inv & HIDEEYES)
			obscured |= slot_glasses
		if(head.flags_inv & HIDEEARS)
			obscured |= slot_ears

	if(obscured.len > 0)
		return obscured
	else
		return null

/mob/living/carbon/human/assess_threat(mob/living/simple_animal/bot/secbot/judgebot, lasercolor)
	return
/*
	if(judgebot.emagged == 2)
		return 10 //Everyone is a criminal!

	var/threatcount = 0

	//Lasertag bullshit
	if(lasercolor)
		if(lasercolor == "b")//Lasertag turrets target the opposing team, how great is that? -Sieve
			if(istype(wear_suit, /obj/item/clothing/suit/redtag))
				threatcount += 4
			if((istype(r_hand,/obj/item/weapon/gun/energy/laser/redtag)) || (istype(l_hand,/obj/item/weapon/gun/energy/laser/redtag)))
				threatcount += 4
			if(istype(belt, /obj/item/weapon/gun/energy/laser/redtag))
				threatcount += 2

		if(lasercolor == "r")
			if(istype(wear_suit, /obj/item/clothing/suit/bluetag))
				threatcount += 4
			if((istype(r_hand,/obj/item/weapon/gun/energy/laser/bluetag)) || (istype(l_hand,/obj/item/weapon/gun/energy/laser/bluetag)))
				threatcount += 4
			if(istype(belt, /obj/item/weapon/gun/energy/laser/bluetag))
				threatcount += 2

		return threatcount

	//Check for ID
	var/obj/item/weapon/card/id/idcard = get_idcard()
	if(judgebot.idcheck && !idcard && name=="Unknown")
		threatcount += 4

	//Check for weapons
	if(judgebot.weaponscheck)
		if(!idcard || !(access_weapons in idcard.access))
			if(judgebot.check_for_weapons(l_hand))
				threatcount += 4
			if(judgebot.check_for_weapons(r_hand))
				threatcount += 4
			if(judgebot.check_for_weapons(belt))
				threatcount += 2

	//Check for arrest warrant
	if(judgebot.check_records)
		var/perpname = get_face_name(get_id_name())
		var/datum/data/record/R = find_record("name", perpname, GLOB.data_core.security)
		if(R && R.fields["criminal"])
			switch(R.fields["criminal"])
				if("*Arrest*")
					threatcount += 5
				if("Incarcerated")
					threatcount += 2
				if("Parolled")
					threatcount += 2

	//Check for dresscode violations
	if(istype(head, /obj/item/clothing/head/wizard) || istype(head, /obj/item/clothing/head/helmet/space/hardsuit/wizard))
		threatcount += 2

	//Check for nonhuman scum
	if(dna && dna.species.id && dna.species.id != "human")
		threatcount += 1

	//Loyalty implants imply trustworthyness
	if(isloyal(src))
		threatcount -= 1

	//Agent cards lower threatlevel.
	if(istype(idcard, /obj/item/weapon/card/id/syndicate))
		threatcount -= 5

	return threatcount
*/

//Used for new human mobs created by cloning/goleming/podding
/mob/living/carbon/human/proc/set_cloned_appearance()
	if(gender == MALE)
		facial_hair_style = "Full Beard"
	else
		facial_hair_style = "Shaved"
	hair_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")
	underwear = "Nude"
	update_body()
	update_hair()

/mob/living/carbon/human/singularity_act()
	var/gain = 20
	if(mind)
		if((mind.assigned_role == "Station Engineer") || (mind.assigned_role == "Chief Engineer") )
			gain = 100
		if(mind.assigned_role == "Clown")
			gain = rand(-300, 300)
	investigate_log("([key_name(src)]) has been consumed by the singularity.","singulo") //Oh that's where the clown ended up!
	gib()
	return(gain)

/mob/living/carbon/human/singularity_pull(S, current_size)
	if(current_size >= STAGE_THREE)
		var/list/handlist = list(l_hand, r_hand)
		for(var/obj/item/hand in handlist)
			if(prob(current_size * 5) && hand.w_class >= ((11-current_size)/2)  && unEquip(hand))
				step_towards(hand, src)
				src << "<span class='warning'>\The [S] pulls \the [hand] from your grip!</span>"
	rad_act(current_size * 3)
	if(mob_negates_gravity())
		return
	..()


/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	if(!istype(M))
		return

	if(!stat)
		if(M == src)
			if(hud_used)
				hud_used.healthdoll.Click()
			return
		if(wear_suit)
			wear_suit.add_fingerprint(M)
		else if(w_uniform)
			w_uniform.add_fingerprint(M)

		..()


/mob/living/carbon/human/proc/do_cpr(mob/living/carbon/C)
	if(C.stat == DEAD)
		src << "<span class='warning'>[C.name] is dead!</span>"
		return
	if(is_mouth_covered())
		src << "<span class='warning'>Remove your mask first!</span>"
		return 0
	if(C.is_mouth_covered())
		src << "<span class='warning'>Remove their mask first!</span>"
		return 0

	if(C.cpr_time < world.time + 30)
		visible_message("<span class='notice'>[src] is trying to perform CPR on [C.name]!</span>", \
						"<span class='notice'>You try to perform CPR on [C.name]... Hold still!</span>")
		if(!do_mob(src, C))
			src << "<span class='warning'>You fail to perform CPR on [C]!</span>"
			return 0

		if(C.health <= HEALTH_THRESHOLD_CRIT)
			C.cpr_time = world.time
			var/suff = min(C.getOxyLoss(), 7)
			C.adjustOxyLoss(-suff)
			C.updatehealth()
			src.visible_message("[src] performs CPR on [C.name]!", "<span class='notice'>You perform CPR on [C.name].</span>")
			C << "<span class='unconscious'>You feel a breath of fresh air enter your lungs... It feels good...</span>"
		add_logs(src, C, "CPRed")

/mob/living/carbon/human/generateStaticOverlay()
	var/image/staticOverlay = image(icon('icons/effects/effects.dmi', "static"), loc = src)
	staticOverlay.override = 1
	staticOverlays["static"] = staticOverlay

	staticOverlay = image(icon('icons/effects/effects.dmi', "blank"), loc = src)
	staticOverlay.override = 1
	staticOverlays["blank"] = staticOverlay

	staticOverlay = getLetterImage(src, "H", 1)
	staticOverlay.override = 1
	staticOverlays["letter"] = staticOverlay

/mob/living/carbon/human/cuff_resist(obj/item/I)
	if(dna && dna.check_mutation(HULK))
		say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
		..(I, cuff_break = 1)
	else
		..()

/mob/living/carbon/human/clean_blood()
	var/mob/living/carbon/human/H = src
	if(H.gloves)
		if(H.gloves.clean_blood())
			H.update_inv_gloves()
	else
		..() // Clear the Blood_DNA list
		if(H.bloody_hands)
			H.bloody_hands = 0
			H.bloody_hands_mob = null
			H.update_inv_gloves()
	update_icons()	//apply the now updated overlays to the mob



//Turns a mob black, flashes a skeleton overlay
//Just like a cartoon!
/mob/living/carbon/human/proc/electrocution_animation(anim_duration)
	//Handle mutant parts if possible
	if(dna && dna.species)
		dna.species.handle_mutant_bodyparts(src,"black")
		dna.species.handle_hair(src,"black")
		dna.species.update_color(src,"black")
		overlays += "electrocuted_base"
		spawn(anim_duration)
			if(src)
				if(dna && dna.species)
					dna.species.handle_mutant_bodyparts(src)
					dna.species.handle_hair(src)
					dna.species.update_color(src)
				overlays -= "electrocuted_base"

	else //or just do a generic animation
		var/list/viewing = list()
		for(var/mob/M in viewers(src))
			if(M.client)
				viewing += M.client
		flick_overlay(image(icon,src,"electrocuted_generic",MOB_LAYER+1), viewing, anim_duration)

/mob/living/carbon/human/canUseTopic(atom/movable/M, be_close = 0)
	if(incapacitated()) //|| lying )
		return
	if(!Adjacent(M) && (M.loc != src))
//		if((be_close == 0) && (dna.check_mutation(TK)))
//			if(tkMaxRangeCheck(src, M))
//				return 1
		return
	return 1
