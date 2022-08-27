/mob/living/carbon/human/examine(mob/user)

	var/list/obscured = check_obscured_slots()
	var/skipface = 0
	var/skiphair = 0
	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE
		skiphair |= wear_mask.flags_inv & HIDEHAIR
	if(head_hard)
		skipface |= head_hard.flags_inv & HIDEFACE
		skiphair |= head_hard.flags_inv & HIDEHAIR
	if(head)
		skipface |= head.flags_inv & HIDEFACE
		skiphair |= head.flags_inv & HIDEHAIR

	// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
	var/t_He = "It" //capitalised for use at the start of each line.
	var/t_his = "its"
	var/t_him = "it"
	var/t_has = "has"
	var/t_is = "is"

	var/msg = user.client.select_lang("<span class='info'>*---------*\nЭто ","<span class='info'>*---------*\nThis is ")

	if( slot_w_uniform in obscured && skipface ) //big suits/masks/helmets make it hard to tell their gender
		t_He = user.client.select_lang("Он","They")
		t_his = user.client.select_lang("Его","their")
		t_him = user.client.select_lang("Его","them")
		t_has = "have"
		t_is = "are"
	else
		switch(gender)
			if(MALE)
				t_He = user.client.select_lang("Он","He")
				t_his = user.client.select_lang("eго","his")
				t_him = user.client.select_lang("ему","him")
			if(FEMALE)
				t_He = user.client.select_lang("Она","She")
				t_his = user.client.select_lang("её","her")
				t_him = user.client.select_lang("ей","her")

	var/mob_name = user.client.select_lang(get_uniq_name("RU"), get_uniq_name("EN"))
	if(user.clients_names[src] && !skipface)
		mob_name = user.clients_names[src]
		msg += "<EM>[mob_name]</EM>!\n"
		if(user != src)
			msg += user.client.select_lang("<span class='notice'>Изменить [t_his] <a href='?src=\ref[src];client=1;give_name=1'><b>имя</b></a></span>\n\n",
											"<span class='notice'>Change [t_his] <a href='?src=\ref[src];client=1;give_name=1'><b>name</b></a></span>\n\n")
	else if(!skipface)
		msg += "<EM>[mob_name]</EM>!\n"
		if(user != src && isliving(user))
			msg += user.client.select_lang("<span class='notice'>Дать [t_him] <a href='?src=\ref[src];client=1;give_name=1'><b>имя</b></a></span>\n\n",
											"<span class='notice'>Give [t_him] a <a href='?src=\ref[src];client=1;give_name=1'><b>name</b></a></span>\n\n")
	else
		if(user == src)
			mob_name = real_name
		msg += "<EM>[mob_name]</EM>!\n"


	var/age_word = ""
	var/age_word_en = ""
	switch(age)
		if(0 to 30)
			age_word = " [gender == MALE ? "молодой" : "молодая"]"
			age_word_en = " young"
		if(31 to 45)
			age_word = " [gender == MALE ? "зрелый" : "зрелая"]"
			age_word_en = " middle-aged"
		if(46 to 60)
			age_word = " [gender == MALE ? "немолодой" : "немолодая"]"
			age_word_en = "n aging"
		if(61 to INFINITY)
			age_word = " [gender == MALE ? "старый" : "старая"]"
			age_word_en = "n elderly"

	msg += user.client.select_lang("<span class='notice'>Это", "<span class='notice'>This is a")
	if(!skipface)
		msg += user.client.select_lang(age_word, age_word_en)

	var/str_word = ""
	var/str_word_en = ""
	switch(str_const)
		if(1 to 7)
			str_word = "хилого"
			str_word_en = "a frail"
		if(8 to 9)
			str_word = "слабого"
			str_word_en = "a weak"
		if(10)
			str_word = "среднего"
			str_word_en = "an average"
		if(11 to 12)
			str_word = "крепкого"
			str_word_en = "a fit"
		if(13 to 14)
			str_word = "атлетичного"
			str_word_en = "an athletic"
		if(15 to 16)
			str_word = "амбалистого"
			str_word_en = "a muscular"
		if(17 to INFINITY)
			str_word = "перекаченного"
			str_word_en = "an overly buff"
	msg += user.client.select_lang(" [gender == MALE ? "мужчина" : "женщина"] [str_word] телосложения.</span>\n", " [gender == MALE ? "man" : "woman"] of [str_word_en] physique.</span>\n")

	var/datum/sprite_accessory/HS = GLOB.hair_styles_list[hair_style]
	var/datum/sprite_accessory/FH = GLOB.facial_hair_styles_list[facial_hair_style]
	var/datum/hair_color/HC = GLOB.hair_colors_list[hair_color]
	var/datum/hair_color/FC = GLOB.hair_colors_list[facial_hair_color]

	var/HC_desc = ""
	var/HC_desc_ru = ""
	if(HC)
		HC_desc = HC.desc
		HC_desc_ru = HC.desc_ru
	var/FC_desc = ""
	var/FC_desc_ru = ""
	if(FC)
		FC_desc = FC.desc
		FC_desc_ru = FC.desc_ru

	if(!skiphair && !skipface)
		msg += user.client.select_lang("<span class='notice'>У [gender == MALE ? "него" : "неё"] [HC_desc_ru][HS.desc_ru] и [FC_desc_ru][FH.desc_ru].</span>\n",
										"<span class='notice'>[t_He] has a [HC_desc][HS.desc] and a [FC_desc][FH.desc].</span>\n")
	else if(!skiphair)
		msg += user.client.select_lang("<span class='notice'>У [gender == MALE ? "него" : "неё"] [HC_desc_ru][HS.desc_ru].</span>\n",
										"<span class='notice'>[t_He] has a [HC_desc][HS.desc].</span>\n")
	else if(!skipface)
		msg += user.client.select_lang("<span class='notice'>У [gender == MALE ? "него" : "неё"] [FC_desc_ru][FH.desc_ru].</span>\n",
										"<span class='notice'>[t_He] has a [FC_desc][FH.desc].</span>\n")
		if(radiation >= 1)
			switch(radiation)
				if(1 to 2)
					msg += user.client.select_lang("<span class='notice'>[gender == MALE ? "Его" : "Её"] лицо покрыто небольшим румянцем.</span>\n",
												"<span class='notice'>His face is covered with a small blush.</span>\n")
				if(2 to 4)
					msg += user.client.select_lang("<span class='notice'>[gender == MALE ? "Его" : "Её"] лицо красно, как будто он только что загорал.</span>\n",
												"<span class='notice'>His face is red, as if he had just sunbathed.</span>\n")
				if(4 to 6)
					msg += user.client.select_lang("<span class='notice'>[gender == MALE ? "Его" : "Её"] лицо нездорово красное.</span>\n",
												"<span class='notice'>His face is unhealthy red.</span>\n")
				if(6 to INFINITY)
					msg += user.client.select_lang("<span class='notice'>Что с [gender == MALE ? "его" : "её"] лицом? По цвету напоминает переспелый томат.</span>\n",
													"<span class='notice'>What with his face? The color resembles overripe tomato.</span>\n")

	//uniform
	if(w_uniform && !(slot_w_uniform in obscured))
		if(w_uniform.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[w_uniform] окровавленный [w_uniform.name_ru]!</span>\n",
										"<span class='warning'>[t_He] [t_is] wearing \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] blood-stained [w_uniform.name]!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[w_uniform] [w_uniform.name_ru].\n",
										"[t_He] [t_is] wearing \icon[w_uniform] \a [w_uniform].\n")

	//head
	if(head)
		if(head.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[head] окровавленный [head.name_ru] на голове!</span>\n",
										"<span class='warning'>[t_He] [t_is] wearing \icon[head] [head.gender==PLURAL?"some":"a"] blood-stained [head.name] on [t_his] head!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[head] [head.name_ru] на голове.\n",
										"[t_He] [t_is] wearing \icon[head] \a [head] on [t_his] head.\n")

	if(!head)
		if(head_hard)
			if(head_hard.blood_DNA)
				msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[head_hard] окровавленный [head_hard.name_ru] на [t_his] голове!</span>\n",
										"<span class='warning'>[t_He] [t_is] wearing \icon[head_hard] [head_hard.gender==PLURAL?"some":"a"] blood-stained [head_hard.name] on [t_his] head!</span>\n")
			else
				msg += user.client.select_lang("[t_He] носит \icon[head_hard] [head_hard.name_ru] на [t_his] голове.\n",
											"[t_He] [t_is] wearing \icon[head_hard] \a [head_hard] on [t_his] head.\n")

	//suit/armor
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[wear_suit] окровавленный [wear_suit.name_ru]!</span>\n",
										"<span class='warning'>[t_He] [t_is] wearing \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] blood-stained [wear_suit.name]!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[wear_suit] [wear_suit.name_ru].\n",
										"[t_He] [t_is] wearing \icon[wear_suit] \a [wear_suit].\n")

	if(!wear_suit)
		if(wear_suit_hard)
			if(wear_suit_hard.blood_DNA)
				msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[wear_suit_hard] окровавленный [wear_suit_hard.name_ru]!</span>\n",
											"<span class='warning'>[t_He] [t_is] wearing \icon[wear_suit_hard] [wear_suit.gender==PLURAL?"some":"a"] blood-stained [wear_suit_hard.name]!</span>\n")
			else
				msg += user.client.select_lang("[t_He] носит \icon[wear_suit_hard] [wear_suit_hard.name_ru].\n",
											"[t_He] [t_is] wearing \icon[wear_suit_hard] \a [wear_suit_hard].\n")

	//back
	if(back)
		if(back.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[back] окровавленный [back.name_ru] на [t_his] спине.</span>\n",
										"<span class='warning'>[t_He] [t_has] \icon[back] [back.gender==PLURAL?"some":"a"] blood-stained [back] on [t_his] back.</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[back] \a [back.name_ru] на [t_his] спине.\n",
										"[t_He] [t_has] \icon[back] \a [back] on [t_his] back.\n")

	if(back2)
		if(back2.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[back2] окровавленный [back2.name_ru] на [t_his] спине.</span>\n",
										"<span class='warning'>[t_He] [t_has] \icon[back2] [back2.gender==PLURAL?"some":"a"] blood-stained [back2] on [t_his] back.</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[back2] [back2.name_ru] на [t_his] спине.\n",
										"[t_He] [t_has] \icon[back2] \a [back2] on [t_his] back.\n")

	//hands
	for(var/obj/item/I in held_items)
		if(!(I.flags & ABSTRACT))
			if(I.blood_DNA)
				msg += user.client.select_lang("<span class='warning'>[t_He] держит \icon[I] окровавленный [I.name_ru] в [t_his] [get_held_index_name_ru(get_held_index_of_item(I))]!</span>\n",
											"<span class='warning'>[t_He] [t_is] holding \icon[I] [I.gender==PLURAL?"some":"a"] blood-stained [I.name] in [t_his] [get_held_index_name(get_held_index_of_item(I))]!</span>\n")
			else
				msg += user.client.select_lang("[t_He] держит \icon[I] [I.name_ru] в [t_his] [get_held_index_name_ru(get_held_index_of_item(I))].\n",
											"[t_He] [t_is] holding \icon[I] \a [I] in [t_his] [get_held_index_name(get_held_index_of_item(I))].\n")

	//gloves
	if(gloves && !(slot_gloves in obscured))
		if(gloves.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[gloves] окровавленные [gloves.name_ru] на [t_his] руках!</span>\n",
										"<span class='warning'>[t_He] [t_has] \icon[gloves] [gloves.gender==PLURAL?"some":"a"] blood-stained [gloves.name] on [t_his] hands!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[gloves] [gloves.name_ru] на [t_his] руках.\n",
										"[t_He] [t_has] \icon[gloves] \a [gloves] on [t_his] hands.\n")
	else if(blood_DNA)
		msg += user.client.select_lang("<span class='warning'>[t_his] руки в крови!</span>\n",
									"<span class='warning'>[t_He] [t_has] blood-stained hands!</span>\n")

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/restraints/handcuffs/cable))
			msg += user.client.select_lang("<span class='warning'>[t_He] [t_is] \icon[handcuffed] restrained with cable!</span>\n",
										"<span class='warning'>[t_He] [t_is] \icon[handcuffed] restrained with cable!</span>\n")
		else
			msg += user.client.select_lang("<span class='warning'>[t_He] [t_is] \icon[handcuffed] handcuffed!</span>\n",
											"<span class='warning'>[t_He] [t_is] \icon[handcuffed] handcuffed!</span>\n")

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[belt] окровавленный [belt.name_ru] на [t_his] поясе!</span>\n",
										"<span class='warning'>[t_He] [t_has] \icon[belt] [belt.gender==PLURAL?"some":"a"] blood-stained [belt.name] about [t_his] waist!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[belt] [belt.name_ru] на [t_his] поясе.\n",
										"[t_He] [t_has] \icon[belt] \a [belt] about [t_his] waist.\n")

	//shoes
	if(shoes && !(slot_shoes in obscured))
		if(shoes.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[shoes] окровавленные [shoes.name_ru] на [t_his] ногах!</span>\n",
										"<span class='warning'>[t_He] [t_is] wearing \icon[shoes] [shoes.gender==PLURAL?"some":"a"] blood-stained [shoes.name] on [t_his] feet!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[shoes] [shoes.name_ru] на [t_his] ногах.\n",
										"[t_He] [t_is] wearing \icon[shoes] \a [shoes] on [t_his] feet.\n")

	//mask
	if(wear_mask && !(slot_wear_mask in obscured))
		if(wear_mask.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[wear_mask] окровавленный [wear_mask.name_ru] на [t_his] лице!</span>\n",
										"<span class='warning'>[t_He] [t_has] \icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] blood-stained [wear_mask.name] on [t_his] face!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[wear_mask] [wear_mask.name_ru] на [t_his] лице.\n",
										"[t_He] [t_has] \icon[wear_mask] \a [wear_mask] on [t_his] face.\n")

	//eyes
	if(glasses && !(slot_glasses in obscured))
		if(glasses.blood_DNA)
			msg += user.client.select_lang("<span class='warning'>[t_He] носит \icon[glasses] окровавленные [glasses.name_ru] на [t_his] глазах!</span>\n",
										"<span class='warning'>[t_He] [t_has] \icon[glasses] [glasses.gender==PLURAL?"some":"a"] blood-stained [glasses] covering [t_his] eyes!</span>\n")
		else
			msg += user.client.select_lang("[t_He] носит \icon[glasses] [glasses.name_ru] на [t_his] глазах.\n",
										"[t_He] [t_has] \icon[glasses] \a [glasses] covering [t_his] eyes.\n")

	//ears
	if(ears && !(slot_ears in obscured))
		msg += user.client.select_lang("[t_He] носит \icon[ears] [ears.name_ru] на [t_his] ухе.\n",
										"[t_He] [t_has] \icon[ears] \a [ears] on [t_his] ears.\n")

	//ID
	if(wear_id)
		msg += user.client.select_lang("[t_He] носит \icon[wear_id] [wear_id].\n","[t_He] [t_is] wearing \icon[wear_id] \a [wear_id].\n")

	if(user == src)
		msg += user.client.select_lang("\n<span class='notice'>Другие знают тебя как <b>[get_uniq_name("RU")]</b></span>\n", "\n<span class='notice'>Everyone knows you as <b>[get_uniq_name("EN")]</b></span>\n")

	//Jitters
	switch(jitteriness)
		if(300 to INFINITY)
			msg += "<span class='warning'><B>[t_He] [t_is] convulsing violently!</B></span>\n"
		if(200 to 300)
			msg += "<span class='warning'>[t_He] [t_is] extremely jittery.</span>\n"
		if(100 to 200)
			msg += "<span class='warning'>[t_He] [t_is] twitching ever so slightly.</span>\n"

	var/appears_dead = 0
	if(stat == DEAD || (status_flags & FAKEDEATH))
		appears_dead = 1
/*		if(getorgan(/obj/item/organ/internal/brain))//Only perform these checks if there is no brain
			if(suiciding)
				msg += "<span class='warning'>[t_He] appears to have commited suicide... there is no hope of recovery.</span>\n"
			msg += "<span class='deadsay'>[t_He] [t_is] limp and unresponsive; there are no signs of life"
			if(!key)
				var/foundghost = 0
				if(mind)
					for(var/mob/dead/observer/G in player_list)
						if(G.mind == mind)
							foundghost = 1
							if (G.can_reenter_corpse == 0)
								foundghost = 0
							break
				if(!foundghost)
					msg += " and [t_his] soul has departed"
			msg += "...</span>\n"
		else//Brain is gone, doesn't matter if they are AFK or present
			msg += "<span class='deadsay'>It appears that [t_his] brain is missing...</span>\n"
*/
	if(zombiefied)
		msg += "<span class='warning'>[t_He] has no pupils of the eyes.</span>\n"

	var/temp = getBruteLoss() //no need to calculate each of these twice

	msg += "<span class='warning'>"

	if(temp)
		if(temp < 30)
			msg += "[t_He] [t_has] minor bruising.\n"
		else
			msg += "<B>[t_He] [t_has] severe bruising!</B>\n"

	temp = getFireLoss()
	if(temp)
		if(temp < 30)
			msg += "[t_He] [t_has] minor burns.\n"
		else
			msg += "<B>[t_He] [t_has] severe burns!</B>\n"

	for(var/obj/item/organ/limb/L in organs)
		for(var/obj/item/I in L.embedded_objects)
			msg += "<B>[t_He] [t_has] \a \icon[I] [I] embedded in [t_his] [L.getDisplayName()]!</B>\n"


	if(fire_stacks > 0)
		msg += "[t_He] [t_is] covered in something flammable.\n"
	if(fire_stacks < 0)
		msg += "[t_He] looks a little soaked.\n"


	if(nutrition < NUTRITION_LEVEL_STARVING - 50)
		msg += "[t_He] [t_is] severely malnourished.\n"
	else if(nutrition >= NUTRITION_LEVEL_FAT)
		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else
			msg += "[t_He] [t_is] quite chubby.\n"

	if(pale)
		msg += "[t_He] [t_has] pale skin.\n"

	if(bleedsuppress)
		msg += "[t_He] [t_is] bandaged with something.\n"
	if(bleed_rate)
		if(reagents.has_reagent("heparin"))
			msg += "<b>[t_He] [t_is] bleeding uncontrollably!</b>\n"
		else
			msg += "<B>[t_He] [t_is] bleeding!</B>\n"

	if(reagents.has_reagent("teslium"))
		msg += "[t_He] is emitting a gentle blue glow!\n"

	msg += "</span>"

	if(!appears_dead)
		if(stat == UNCONSCIOUS)
			msg += "[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.\n"
		if(digitalcamo)
			msg += "[t_He] [t_is] moving [t_his] body in an unnatural and blatantly inhuman manner.\n"

//	if(!skipface && in_range(user,src))
//		msg += "Their features seem unnaturally tight and drawn.\n"

	if(!head_hard && user.artefacts_effects["mind_reading"])
		var/say_log_start = say_log.len-30
		if(say_log_start < 0)
			say_log_start = 1
		var/list/thoughts = say_log.Copy(say_log_start, 0)
		if(thoughts.len)
			msg += "<br><i>He thinks: [pick(thoughts)]</i>\n"

	if(istype(user, /mob/living/carbon/human) && user != src)
		var/mob/living/carbon/human/H = user

/*		if(istype(H.wear_id, /obj/item/device/stalker_pda))
			if(istype(src.wear_id, /obj/item/device/stalker_pda))
				var/obj/item/device/stalker_pda/KPK = H.wear_id
				var/datum/data/record/R = find_record("sid", src.sid, GLOB.data_core.stalkers)
				var/datum/data/record/R_H = find_record("sid", H.sid, GLOB.data_core.stalkers)
				if(KPK.hacked == 1 || H == KPK.owner)
					if(R && R_H)

						var/rep = russian_html2text(get_rep_name(R.fields["reputation"]))
						var/font_color = get_rep_color(R.fields["reputation"])

						var/rank_name_s 	= russian_html2text(get_rank_name(R.fields["rating"]))

						var/faction_s		= get_faction(R.fields["faction_s"]) //russian_html2text

						msg += H.client.select_lang("\nГруппировка: [faction_s]\n\
													Репутация: <font color=\"[font_color]\">[rep]</font><a href='?src=\ref[src];KPK=1;addition_rep=1'><font color=\"green\">\[+\]</font></a><a href='?src=\ref[src];KPK=1;subtraction_rep=1'><font color=\"red\">\[-\]</font></a>\n\
													Рейтинг: [rank_name_s]\n\n\
													<a href='?src=\ref[src];KPK=1;money_transfer=1'>Совершить денежный перевод</a>\n",\
													\
													"\nFaction: [faction_s]\n\
													Reputation: <font color=\"[font_color]\">[rep]</font><a href='?src=\ref[src];KPK=1;addition_rep=1'><font color=\"green\">\[+\]</font></a><a href='?src=\ref[src];KPK=1;subtraction_rep=1'><font color=\"red\">\[-\]</font></a>\n\
													Rating: [rank_name_s]\n\n\
													<a href='?src=\ref[src];KPK=1;money_transfer=1'>Commit money transfer</a>\n")


				else
					msg += "\n<span class='warning'>NO ACCESS!</span>\n"
*/
		if(istype(H.wear_id, /obj/item/device/pager))
			if(istype(wear_id, /obj/item/device/pager))
				var/obj/item/device/pager/P = H.wear_id
				var/obj/item/device/pager/P_s = wear_id
				if(P && P_s)
					msg += H.client.select_lang("<a href='?src=\ref[src];KPK=1;money_transfer=1'>Совершить денежный перевод</a>\n",\
												"<a href='?src=\ref[src];KPK=1;money_transfer=1'>Commit money transfer</a>\n")


	msg += "*---------*</span>"

	user << sanitize_russian(msg)
