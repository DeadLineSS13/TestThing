/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen_gen.dmi'
	layer = 20
	plane = HUD_PLANE
	unacidable = 1
	appearance_flags = NO_CLIENT_COLOR
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/datum/hud/hud = null // A reference to the owner HUD, if any.

/obj/screen/Destroy()
	master = null
	hud = null
	return ..()

/obj/screen/inventory
	var/slot_id	// The indentifier for the slot. It has nothing to do with ID cards.
	var/icon_empty // Icon when empty. For now used only by humans.
	var/icon_full  // Icon when contains an item. For now used only by humans.
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1

	if(usr.incapacitated())
		return 1
	if(usr.attack_ui(slot_id))
		usr.update_inv_hands()
	return 1

/obj/screen/inventory/update_icon()
	if(!icon_empty)
		icon_empty = icon_state

	if(hud && hud.mymob && slot_id && icon_full)
		if(hud.mymob.get_item_by_slot(slot_id))
			icon_state = icon_full
		else
			icon_state = icon_empty

/obj/screen/inventory/hand
	var/image/active_overlay
	var/image/handcuff_overlay
	var/image/blocked_overlay
	var/held_index = 0

/obj/screen/inventory/hand/update_icon()
	..()

	if(!active_overlay)
		active_overlay = image("icon"=icon, "icon_state"="hand_active")
	if(!handcuff_overlay)
		var/state = (!(held_index % 2)) ? "markus" : "gabrielle"
		handcuff_overlay = image("icon"='icons/mob/screen_gen.dmi', "icon_state"=state)
	if(!blocked_overlay)
		blocked_overlay = image("icon"='icons/mob/screen_gen.dmi', "icon_state"="blocked")

	cut_overlays()

	if(hud && hud.mymob)
		if(iscarbon(hud.mymob))
			var/mob/living/carbon/C = hud.mymob
			if(C.handcuffed)
				add_overlay(handcuff_overlay)

			if(held_index)
				if(!C.has_hand_for_held_index(held_index))
					add_overlay(blocked_overlay)

		if(held_index == hud.mymob.active_hand_index)
			add_overlay(active_overlay)


/obj/screen/inventory/hand/Click(location,control,params)
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1
	if(usr.incapacitated())
		return 1

	if(ismob(usr))
		var/mob/M = usr
		var/list/modifiers = params2list(params)
		if(modifiers["right"])
			var/obj/item/I = M.get_item_for_held_index(held_index)
			if(I)
				I.RightClick(M)
				return 1

		M.swap_hand(held_index)
	return 1

/obj/screen/inventory/hand/Destroy()
	active_overlay = null
	handcuff_overlay = null
	blocked_overlay = null
	return ..()

/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480


/obj/screen/bars
	icon_state = "backup"
	layer = HUD_LAYER-1
	plane = HUD_PLANE-1


/obj/screen/close
	name = "Close"
	name_ru = "Закрыть"

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = master
			S.close(usr)
	return 1


/obj/screen/drop
	name = "Drop"
	name_ru = "Уронить"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "act_drop"
	layer = 19

/obj/screen/drop/Click()
	usr.drop_item_v()

/*
/obj/screen/grab
	name = "grab"

/obj/screen/grab/Click()
	var/obj/item/weapon/grab/G = master
	G.s_click(src)
	return 1

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return
*/
/obj/screen/swap_hand
	layer = HUD_LAYER
	plane = HUD_PLANE
	name = "Swap hand"
	name_ru = "Поменять руку"

/obj/screen/swap_hand/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1

	if(usr.incapacitated())
		return 1

	if(ismob(usr))
		var/mob/M = usr
		M.swap_hand()
	return 1

/obj/screen/act_intent
	name = "Intent"
	name_ru = "Действие"
	icon_state = "help"
	screen_loc = ui_acti

/obj/screen/act_intent/Click(location, control, params)
	if(ishuman(usr))

		var/_x = text2num(params2list(params)["icon-x"])
		var/_y = text2num(params2list(params)["icon-y"])

		if(_x<=16 && _y<=16)
			usr.a_intent_change("harm")

		else if(_x<=16 && _y>=17)
			usr.a_intent_change("help")

		else if(_x>=17 && _y<=16)
			usr.a_intent_change("grab")

		else if(_x>=17 && _y>=17)
			usr.a_intent_change("disarm")

	else
		usr.a_intent_change("right")
/obj/screen/internals
	name = "Toggle internals"
	name_ru = "Подача кислорода"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "oxygen"
	screen_loc = ui_internal

/obj/screen/internals/Click(location, control, params)
	if(iscarbon(usr))
		var/list/modifiers = params2list(params)
		var/mob/living/carbon/C = usr
		if(modifiers["right"])
			if(!C.internal)
				if(!C.hold_breath)
					icon_state = "not_breathing"
					C.hold_breath = 1
					C << "<span class='notice'>You held your breath.</span>"
					return
				else
					icon_state = "oxygen"
					C.hold_breath = 0
					C << "<span class='notice'>You no longer hold your breath.</span>"
					return
		if(!C.incapacitated())
			if(C.internal)
				C.internal = null
				C << "<span class='notice'>You are no longer running on internals.</span>"
				icon_state = "internal0"
			else
				if(!istype(C.wear_mask, /obj/item/clothing/mask))
					C << "<span class='warning'>You are not wearing an internals mask!</span>"
					return 1
				else
					var/obj/item/clothing/mask/M = C.wear_mask
					if(M.mask_adjusted) // if mask on face but pushed down
						M.adjustmask(C) // adjust it back
					if( !(M.flags & MASKINTERNALS) )
						C << "<span class='warning'>You are not wearing an internals mask!</span>"
						return
					if(istype(C.l_hand, /obj/item/weapon/tank))
						C << "<span class='notice'>You are now running on internals from the [C.l_hand] on your left hand.</span>"
						C.internal = C.l_hand
					else if(istype(C.r_hand, /obj/item/weapon/tank))
						C << "<span class='notice'>You are now running on internals from the [C.r_hand] on your right hand.</span>"
						C.internal = C.r_hand
					else if(ishuman(C))
						var/mob/living/carbon/human/H = C
						if(istype(H.s_store, /obj/item/weapon/tank))
							H << "<span class='notice'>You are now running on internals from the [H.s_store] on your [H.wear_suit].</span>"
							H.internal = H.s_store
						else if(istype(H.belt, /obj/item/weapon/tank))
							H << "<span class='notice'>You are now running on internals from the [H.belt] on your belt.</span>"
							H.internal = H.belt
						else if(istype(H.l_store, /obj/item/weapon/tank))
							H << "<span class='notice'>You are now running on internals from the [H.l_store] in your left pocket.</span>"
							H.internal = H.l_store
						else if(istype(H.r_store, /obj/item/weapon/tank))
							H << "<span class='notice'>You are now running on internals from the [H.r_store] in your right pocket.</span>"
							H.internal = H.r_store

					//Seperate so CO2 jetpacks are a little less cumbersome.
					if(!C.internal && istype(C.back, /obj/item/weapon/tank))
						C << "<span class='notice'>You are now running on internals from the [C.back] on your back.</span>"
						C.internal = C.back

					if(C.internal)
						icon_state = "internal1"
					else
						C << "<span class='warning'>You don't have an oxygen tank!</span>"

/obj/screen/mov_intent
	name = "Run/Walk toggle"
	name_ru = "Ходьба/Бег"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "running"

/obj/screen/mov_intent/Click()
	switch(usr.m_intent)
		if("run")
			usr.m_intent = "walk"
			icon_state = "walking"
		if("walk")
			if(!usr.facing_dir)
				usr.m_intent = "run"
				icon_state = "running"
	usr.update_icons()
/*
/obj/screen/pull
	name = "stop pulling"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "pull"

/obj/screen/pull/Click()
	usr.stop_pulling()

/obj/screen/pull/update_icon(mob/mymob)
	if(!mymob) return
	if(mymob.pulling)
		icon_state = "pull"
	else
		icon_state = "pull0"
*/
/obj/screen/resist
	name = "Resist"
	name_ru = "Сопротивляться"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "act_resist"
	layer = 19

/obj/screen/resist/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		L.resist()

/obj/screen/storage
	name = "Storage"
	name_ru = "Место хранения"

/obj/screen/storage/Click(location, control, params)
	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if(master)
		var/obj/item/I = usr.get_active_held_item()
		if(I)
			master.attackby(I, usr, params)
	return 1

/obj/screen/throw_catch
	name = "Throw/Catch"
	name_ru = "Кинуть/Поймать"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "act_throw_off"

/obj/screen/throw_catch/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		C.toggle_throw_mode()

/obj/screen/zone_sel
	name = "Damage Zone"
	name_ru = "Кукла"
	icon_state = "stalker"
	screen_loc = ui_zonesel
	var/selecting = "chest"

/obj/screen/zone_sel/Click(location, control,params)
	if(isobserver(usr))
		return

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/choice = "chest"

	switch(icon_y)
		if(1 to 25) //Legs
			switch(icon_x)
				if(1 to 14)
					choice = "r_leg"
				if(18 to 32)
					choice = "l_leg"
//		if(26 to 31)
//			if(icon_x in 11 to 23)
//				choice = "groin"
//			else
//				return 1
		if(24 to 45) //Hands
			switch(icon_x)
				if(1 to 10)
					choice = "r_arm"
				if(23 to 32)
					choice = "l_arm"
				if(11 to 22)
					choice = "chest"
				else
					return 1
		if(47 to 48)
			if(icon_x in 15 to 18)
				choice = "mouth"
			else
				return 1
		if(51 to 52)
			if(icon_x in 14 to 19)
				choice = "eyes"
			else
				return 1
		if(49 to 51)
			if(icon_x in 12 to 21)
				choice = "face"
			else
				return 1
		if(53 to 57)
			if(icon_x in 12 to 21)
				choice = "head"
			else
				return 1

	return set_selected_zone(choice, usr)

/obj/screen/zone_sel/proc/set_selected_zone(choice, mob/user)
	if(isobserver(user))
		return

	if(choice != selecting)
		selecting = choice
		update_icon(usr)
	return 1

/obj/screen/zone_sel/update_icon(mob/user)
	cut_overlays()
	add_overlay(image('icons/stalker/hud/puppet64.dmi', "[selecting]"))
	user.zone_selected = selecting

/obj/screen/healths
	name = "Health"
	name_ru = "Самочувствие"
	icon = 'icons/stalker/hud/health_overlay.dmi'
	icon_state = "overlay"
	screen_loc = ui_health

/obj/screen/stamina
	name = "Stamina"
	name_ru = "Выносливость"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "stamina_high"
	screen_loc = ui_stamina

/obj/screen/fixeye
	name = "Fixed eye"
	name_ru = "Закрепить взгляд"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "fixeye"
	screen_loc = ui_fixeye

/obj/screen/fixeye/Click(location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		usr.close_look()
	else
		usr.face_direction()
		if(usr.facing_dir)
			icon_state = "fixeye_on"
			if(usr.m_intent == "run")
				usr.m_intent = "walk"
				usr.hud_used.mov_intent.icon_state = "walking"
		else
			icon_state = "fixeye"

/obj/screen/healthdoll
	name = "Health"
	name = "Самочувствие"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "hdoll"
	screen_loc = ui_healthdoll

/obj/screen/healthdoll/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.direct_visible_message( "DOER examines themselves.", \
								"<span class='notice'>You check yourself for injuries.</span>",\
								"DOER осматривает себя.", \
								"<span class='notice'>Ты осматриваешь себя на наличие ран.</span>",\
								null, H)

		for(var/obj/item/organ/limb/org in H.organs)
			var/status = ""
			var/status_ru = ""
			var/brutedamage = org.crush_dam + org.cut_dam
			var/burndamage = org.burn_dam
			if(H.hallucination)
				if(prob(30))
					brutedamage += rand(30,40)
				if(prob(30))
					burndamage += rand(30,40)

			if(org.crippled)
				status += "is crippled"
				status_ru += "недееспособна"

			if(org.toxic_effects.len)
				if(org.crippled)
					status += ", "
					status_ru += ", "
				for(var/e in org.toxic_effects)
					if(e == "rustpuddle")
						status += "covered with burning rust"
						status_ru += "покрыта жжущей ржавчиной"
					if(e == "vedminstuden")
						if(status)
							status += " and corroding mucus"
							status_ru += " и разъедающей слизью"
						else
							status += "covered with corrosive mucus"
							status_ru += "покрыта разъедающей слизью"

			if(status && (brutedamage || burndamage))
				status += ", and "
				status_ru += ", а так же "

			if(brutedamage >= H.str_const - 1)
				status += "mangled"
				status_ru += "изрезана"
			else if(brutedamage >= H.str_const / 2)
				status += "battered"
				status_ru += "сильно побита"
			else if(brutedamage > 0)
				status += "bruised"
				status_ru += "вся в ушибах"
			if(brutedamage > 0 && burndamage > 0)
				status += " and "
				status_ru += " и "
			if(burndamage >= H.str_const - 1)
				status += "peeling away"
				status_ru += "расслаивается"

			else if(burndamage >= H.str_const / 2)
				status += "blistered"
				status_ru += "покрыта волдырями"
			else if(burndamage > 0)
				status += "numb"
				status_ru += "онемела"
			if(org.bleeding)
				status += " and bleeding!"
				status_ru += ", так ещё и кровоточит!"
			if(status == "")
				status = "OK"
			if(status_ru == "")
				status_ru = "в порядке."
			H << H.client.select_lang("\t [status == "OK" ? "\blue" : "\red"] Твоя [parse_zone_ru2(org.name)] [status_ru]", "\t [status == "OK" ? "\blue" : "\red"] Your [org.getDisplayName()] is [status]")

			for(var/obj/item/I in org.embedded_objects)
				H << "\t <a href='byond://?src=\ref[src];embedded_object=\ref[I];embedded_limb=\ref[org]'>\red There is \a [I] embedded in your [org.getDisplayName()]!</a>"

		var/blowout_verb = null
		if(H.blowout_effects["guns"])
			blowout_verb = "приноровлялся к оружию"
		else if(H.blowout_effects["trainings"])
			blowout_verb = "тренировался"
		else if(H.blowout_effects["eyes"])
			blowout_verb = "размышлял об аномалиях"
		if(blowout_verb)
			H << "\n<span class='notice'>Во время прошлого выброса я: [blowout_verb].</span>"

/obj/screen/hunger
	name = "Hunger"
	name_ru = "Голод"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "food"

/obj/screen/thirst
	name = "Thirst"
	name_ru = "Жажда"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "hydration"

/obj/screen/stats
	name = "Stats"
	name_ru = "Характеристики"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "stat_null"

/obj/screen/stats/str
	name = "Strength"
	name_ru = "Сила"

/obj/screen/stats/str/Click()
	switch(usr.str)
		if(1 to 7)
			if(usr.client.language == "Russian")
				usr << "Я совсем слабак. Кожа да кости."
			else
				usr << "I'm extremely weak. Skin on bones."
		if(8 to 9)
			if(usr.client.language == "Russian")
				usr << "Я слабее нормы. Мышцы дряблые."
			else
				usr << "I'm weaker than average. Muscles too soft."
		if(10)
			if(usr.client.language == "Russian")
				usr << "Я неплохо развит. Но могло бы быть и лучше."
			else
				usr << "I'm not in a bad shape. But could have been better."
		if(11 to 12)
			if(usr.client.language == "Russian")
				usr << "Я в отличной физической форме. Могу месить лица."
			else
				usr << "I'm in quite a good shape. Can break some faces."
		if(13 to 14)
			if(usr.client.language == "Russian")
				usr << "Я впечатляюще силен. В тренировочном зале мне все позавидуют."
			else
				usr << "I'm impressively strong. Everyone else in the gym will be jealous of me."
		if(15 to 16)
			if(usr.client.language == "Russian")
				usr << "Я невероятно могуч. Бугрящиеся комки мышц способны гнуть подковы."
			else
				usr << "I'm incredibly strong. Bulging muscles can bend horseshoes."
		if(17 to 18)
			if(usr.client.language == "Russian")
				usr << "Я - ходячая гора мышц. Сломать человека пополам для меня не проблема."
			else
				usr << "I'm a walking pile of muscle mass. Breaking a man in half is no trouble for me."
		if(19 to INFINITY)
			if(usr.client.language == "Russian")
				usr << "Я чудовищно силен. Мои бицепсы - как гидравлические поршни, а кулаки - как молоты."
			else
				usr << "I'm enormously strong. My biceps are like hydraulic press, and my fists are sledgehammers."

/obj/screen/stats/agi
	name = "Agility"
	name_ru = "Ловкость"

/obj/screen/stats/agi/Click()
	switch(usr.agi)
		if(1 to 7)
			if(usr.client.language == "Russian")
				usr << "Моя моторика столь плохо развита, что проще купить инвалидное кресло."
			else
				usr << "My motor functions are so bad that it's easier to just buy a wheelchair."
		if(8 to 9)
			if(usr.client.language == "Russian")
				usr << "Мои координация и скорость реакции не очень впечатляют. Через скакалку не попрыгаю."
			else
				usr << "My coordination and reaction speed aren't impressive. Can't even jump rope."
		if(10)
			if(usr.client.language == "Russian")
				usr << "Мое тело достаточно подвижно и ловко. Жаловаться не на что."
			else
				usr << "My body is quite agile. Can't complain about anything."
		if(11 to 12)
			if(usr.client.language == "Russian")
				usr << "Мои скорость реакции и гибкость немного выше чем у большинства."
			else
				usr << "My reaction speed and flexibility are slightly above average."
		if(13 to 14)
			if(usr.client.language == "Russian")
				usr << "Моя ловкость впечатляет - тренировки сделали мои движения плавными и точными."
			else
				usr << "My agility is impressive - exercising made my moves fluid and precise."
		if(15 to 16)
			if(usr.client.language == "Russian")
				usr << "Мои реакция, ловкость и точность движений сравнимы с таковыми у мифических ниндзя."
			else
				usr << "My reaction, agility and precision of movement are comparable to the ones of mythical ninjas."
		if(17 to INFINITY)
			if(usr.client.language == "Russian")
				usr << "Мои движения ненормально, нечеловечески ловки. Еще немного - и смогу ловить пули руками."
			else
				usr << "My moves are unnaturally, inhumanly precise. A bit further - and I'll be able to catch bullets with bare hands."

/obj/screen/stats/hlt
	name = "Health"
	name_ru = "Здоровье"

/obj/screen/stats/hlt/Click()
	switch(usr.hlt)
		if(1 to 7)
			if(usr.client.language == "Russian")
				usr << "Мой организм едва работает."
			else
				usr << "My body is barely functioning."
		if(8 to 9)
			if(usr.client.language == "Russian")
				usr << "Мое здоровье не очень впечатляет."
			else
				usr << "My health is not very impressive."
		if(10)
			if(usr.client.language == "Russian")
				usr << "Мои иммунитет и здоровье в норме."
			else
				usr << "My immunity and health are alright."
		if(11 to 12)
			if(usr.client.language == "Russian")
				usr << "Мое здоровье весьма крепкое."
			else
				usr << "My health is above average."
		if(13 to 14)
			if(usr.client.language == "Russian")
				usr << "Моя выносливость намного превышает среднюю."
			else
				usr << "My endurance is much above average."
		if(15 to 16)
			if(usr.client.language == "Russian")
				usr << "Мое здоровье помогает мне пережить даже смертельные раны."
			else
				usr << "My health allows me to endure even fatal wounds."
		if(17 to INFINITY)
			if(usr.client.language == "Russian")
				usr << "Мое здоровье легендарно - смерть обходит меня стороной раз за разом."
			else
				usr << "My health is legendary high - it's almost impossible for me to die."

/obj/screen/stats/int
	name = "Intellect"
	name_ru = "Интеллект"

/obj/screen/stats/int/Click()
	switch(usr.int)
		if(1 to 7)
			if(usr.client.language == "Russian")
				usr << "Едва помню как дышать..."
			else
				usr << "Can barely recall how to breath..."
		if(8 to 9)
			if(usr.client.language == "Russian")
				usr << "Умом я не отличаюсь. Ых."
			else
				usr << "I ain't very intelligent. Eeh."
		if(10)
			if(usr.client.language == "Russian")
				usr << "Я неглуп. Могу без труда решить кроссворд."
			else
				usr << "I'm not dumb. Can solve a crossword or two easily."
		if(11 to 12)
			if(usr.client.language == "Russian")
				usr << "Я весьма умен. Могу решить на досуге судоку."
			else
				usr << "I'm quite smart. Can solve sudoku during free time."
		if(13 to 14)
			if(usr.client.language == "Russian")
				usr << "Я очень умен. Решение сложных логических задач - мое развлечение."
			else
				usr << "I'm very intelligent. Solving hard logical challenges is my entertainment."
		if(15 to 16)
			if(usr.client.language == "Russian")
				usr << "Я имею невероятный ум. Для меня нет неразрешимого."
			else
				usr << "I'm incredibly smart. There's nothing I can't solve."
		if(17 to INFINITY)
			if(usr.client.language == "Russian")
				usr << "Нет слов для описания ума человека, который вышел за рамки."
			else
				usr << "There are no words to describe intelligence of a man who is beyond smart."

/obj/screen/skills
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "skills"
	name = "Skills"
	name_ru = "Навыки"

/obj/screen/skills/Click()
	for(var/i in usr.gun_skills)
		var/word
		if(i == "smallarm")
			word = usr.client.select_lang("Короткоствольное оружие", "Small arms")
		if(i == "longarm")
			word = usr.client.select_lang("Длинноствольное оружие", "Long arms")
		if(i == "heavy")
			word = usr.client.select_lang("Тяжелое оружие", "Heavy arms")
		switch(usr.gun_skills["[i]"])
			if(0)
				usr << usr.client.select_lang("<span class='info'>[word]: <i>Дух</i></span>", "<span class='info'>[word]: <i>Rookie</i></span>")
			if(1 to 2)
				usr << usr.client.select_lang("<span class='info'>[word]: Дембель</span>", "<span class='info'>[word]: Private</span>")
			if(3 to 4)
				usr << usr.client.select_lang("<span class='info'>[word]: <b>Контрактник</b></span>", "<span class='info'>[word]: <b>Soldier</b></span>")
			if(5 to 6)
				usr << usr.client.select_lang("<span class='info'>[word]: <b><i>Ветеран</i></b></span>", "<span class='info'>[word]: <b><i>Veteran</i></b></span>")
			if(7 to INFINITY)
				usr << usr.client.select_lang("<span class='info'>[word]: <font color='black'><b><i>Спецназ</i></b></font></span>", "<span class='info'>[word]: <font color='black'><b><i>Special Ops</i></b></font></span>")

	for(var/i in usr.skills)
		var/word
		if(i == "melee")
			word = usr.client.select_lang("Драка", "Fighting")
			switch(usr.skills["[i]"])
				if(0)
					usr << usr.client.select_lang("<span class='info'>[word]: <i>Слизняк</i></span>", "<span class='info'>[word]: <i>Slug</i></span>")
				if(1 to 2)
					usr << usr.client.select_lang("<span class='info'>[word]: Хулиган</span>", "<span class='info'>[word]: Bully</span>")
				if(3 to 4)
					usr << usr.client.select_lang("<span class='info'>[word]: <b>Боец</b></span>", "<span class='info'>[word]: <b>Fighter</b></span>")
				if(5 to 6)
					usr << usr.client.select_lang("<span class='info'>[word]: <b><i>Эксперт</i></b></span>", "<span class='info'>[word]: <b><i>Expert</i></b></span>")
				if(7 to INFINITY)
					usr << usr.client.select_lang("<span class='info'>[word]: <font color='black'><b><i>Мастер</i></b></font></span>", "<span class='info'>[word]: <font color='black'><b><i>Master</i></b></font></span>")
		if(i == "medic")
			word = usr.client.select_lang("Медицина", "Medicine")
			switch(usr.skills["[i]"])
				if(0)
					usr << usr.client.select_lang("<span class='info'>[word]: <i>Неумёха</i></span>", "<span class='info'>[word]: <i>Useless</i></span>")
				if(1 to 2)
					usr << usr.client.select_lang("<span class='info'>[word]: Интерн</span>", "<span class='info'>[word]: Intern</span>")
				if(3 to 4)
					usr << usr.client.select_lang("<span class='info'>[word]: <b>Медик</b></span>", "<span class='info'>[word]: <b>Medic</b></span>")
				if(5 to 6)
					usr << usr.client.select_lang("<span class='info'>[word]: <b><i>Хирург</i></b></span>", "<span class='info'>[word]: <b><i>Surgeon</i></b></span>")
				if(7 to INFINITY)
					usr << usr.client.select_lang("<span class='info'>[word]: <font color='black'><b><i>Профессионал</i></b></font></span>", "<span class='info'>[word]: <font color='black'><b><i>Professional</i></b></font></span>")




	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/pivo_msg = usr.client.select_lang("<span class='info'>Твое любимое пиво: <b>","<span class='info'>Your favourite beer is: <b>")
		switch(H.favourite_beer)
			if("razin")
				pivo_msg += usr.client.select_lang("Степан Разин","Stepan Razin")
			if("gus")
				pivo_msg += usr.client.select_lang("Жатецкий Гусь","Zhatetsky Goose")
			if("obolon")
				pivo_msg += usr.client.select_lang("Оболонь","Obolon")
			if("ohota")
				pivo_msg += usr.client.select_lang("Охота Крепкое","Ohota Strong")
		pivo_msg += "</b></span>"
		usr << ""
		usr << pivo_msg


/obj/screen/weight
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "weight"
	name = "Weight"
	name_ru = "Нагрузка"

/obj/screen/weight/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		var/weight_word = "[H.stamina_coef]"
		var/weight_word_ru = "[H.stamina_coef]"
		switch(H.stamina_coef)
			if(-1)
				weight_word = "none"
				weight_word_ru = "несущественная"
			if(0)
				weight_word = "lite"
				weight_word_ru = "легкая"
			if(1)
				weight_word = "medium"
				weight_word_ru = "средняя"
			if(2)
				weight_word = "heavy"
				weight_word_ru = "тяжелая"
			if(3)
				weight_word = "very heavy"
				weight_word_ru = "очень тяжелая"
			if(4)
				weight_word = "extreme"
				weight_word_ru = "экстремально тяжелая"
			if(5)
				weight_word = "barely moving"
				weight_word_ru = "невыносимо тяжелая"
			else
				weight_word = "not moving"
				weight_word_ru = "невозможно тяжелая"

		H << usr.client.select_lang("<span class='notice'>Твоя нагрузка [weight_word_ru].</span>","<span class='notice'>Your encumbrance is [weight_word].</span>")

/obj/screen/brain
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "brain"
	name = "Memory"
	name_ru = "Память"

/obj/screen/brain/Click()
	if(usr.mind)
		usr.mind.show_memory(usr)

/obj/screen/mental
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "mental_good"
	name = "Mental State"
	name_ru = "Ментальное состояние"

/obj/screen/mental/Click()
	usr << "<span class='notice'>Пока что у тебя всё хорошо! 😀"
