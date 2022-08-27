/obj/screen/human
	icon = 'icons/mob/screen_midnight.dmi'

/obj/screen/human/toggle
	name = "toggle"
	icon_state = "toggle"

/obj/screen/human/toggle/Click()

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		usr.hud_used.inventory_shown = 0
		usr.client.screen -= targetmob.hud_used.toggleable_inventory
	else
		usr.hud_used.inventory_shown = 1
		usr.client.screen += targetmob.hud_used.toggleable_inventory

	targetmob.hud_used.hidden_inventory_update(usr)

/obj/screen/human/sleep_int
	name = "sleep"
	icon_state = "sleep"

/obj/screen/human/sleep_int/Click()
	var/mob/living/targetmob = usr

	targetmob.mob_sleep()

	if(targetmob.sleeping)
		icon_state = "awake"
		name = "awake"
	else
		icon_state = "sleep"
		name = "sleep"

/obj/screen/human/rest_int
	name = "rest"
	icon = 'icons/mob/screen_midnight.dmi'
	icon_state = "rest"
	screen_loc = ui_rest	//"SOUHT+5:13,EAST+1:7"

/obj/screen/human/rest_int/Click()
	var/mob/living/targetmob = usr

	targetmob.lay_down()
	update_icon(targetmob)

/obj/screen/human/rest_int/update_icon(mob/living/targetmob)
	if(targetmob && targetmob.resting)
		icon_state = "rest2"
	else
		icon_state = "rest"


/obj/screen/human/equip
	name = "equip"
	icon_state = "act_equip"

/obj/screen/human/equip/Click()
	var/mob/living/carbon/human/H = usr
	H.quick_equip()

/mob/living/carbon/human/create_mob_hud()
	if(client && !hud_used)
		hud_used = new /datum/hud/human(src, ui_style2icon(client.prefs.UI_style))


/datum/hud/human/New(mob/living/carbon/human/owner, ui_style = 'icons/mob/screen_midnight.dmi')
	..()

	var/obj/screen/using
	var/obj/screen/inventory/inv_box

/*	using = new /obj/screen/inventory/craft
	using.icon = ui_style
	static_inventory += using

	using = new/obj/screen/wheel/talk
	using.icon = ui_style
	wheels += using
	static_inventory += using

	using = new /obj/screen/inventory/area_creator
	using.icon = ui_style
	static_inventory += using
*/

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,14"
	using.screen_loc = "EAST+1,NORTH:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,13"
	using.screen_loc = "EAST+1,NORTH-1:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,12"
	using.screen_loc = "EAST+1,NORTH-2:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,11"
	using.screen_loc = "EAST+1,NORTH-3:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,10"
	using.screen_loc = "EAST+1,NORTH-4:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,9"
	using.screen_loc = "EAST+1,NORTH-5:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,8"
	using.screen_loc = "EAST+1,NORTH-6:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,7"
	using.screen_loc = "EAST+1,NORTH-7:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,6"
	using.screen_loc = "EAST+1,NORTH-8:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,5"
	using.screen_loc = "EAST+1,NORTH-9:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,4"
	using.screen_loc = "EAST+1,NORTH-10:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,3"
	using.screen_loc = "EAST+1,NORTH-11:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,2"
	using.screen_loc = "EAST+1,NORTH-12:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,1"
	using.screen_loc = "EAST+1,NORTH-13:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,0"
	using.screen_loc = "EAST+1,NORTH-14:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,15"
	using.screen_loc = "EAST+1,NORTH-15:6"
	bars += using

	using = new /obj/screen/bars(src) //Right hud bar
	using.icon = 'icons/stalker/hud/vertical_background.dmi'
	using.icon_state = "0,16"
	using.screen_loc = "EAST+1,NORTH-15"
	bars += using


	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "0,0"
	using.screen_loc = "SOUTH-1,1"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "1,0"
	using.screen_loc = "SOUTH-1,2"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "2,0"
	using.screen_loc = "SOUTH-1,3"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "3,0"
	using.screen_loc = "SOUTH-1,4"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "4,0"
	using.screen_loc = "SOUTH-1,5"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "5,0"
	using.screen_loc = "SOUTH-1,6"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "6,0"
	using.screen_loc = "SOUTH-1,7"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "7,0"
	using.screen_loc = "SOUTH-1,8"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "8,0"
	using.screen_loc = "SOUTH-1,9"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "9,0"
	using.screen_loc = "SOUTH-1,10"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "10,0"
	using.screen_loc = "SOUTH-1,11"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "11,0"
	using.screen_loc = "SOUTH-1,12"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "12,0"
	using.screen_loc = "SOUTH-1,13"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "13,0"
	using.screen_loc = "SOUTH-1,14"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "14,0"
	using.screen_loc = "SOUTH-1,15"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "15,0"
	using.screen_loc = "SOUTH-1,16"
	bars += using

	using = new /obj/screen/bars(src) //Lower hud bar
	using.icon = 'icons/stalker/hud/horizontal_background.dmi'
	using.icon_state = "16,0"
	using.screen_loc = "SOUTH-1,17"
	bars += using

	using = new /obj/screen/act_intent()
	using.icon_state = mymob.a_intent
	static_inventory += using
	action_intent = using

	mov_intent = new /obj/screen/mov_intent()
	mov_intent.icon = ui_style
	mov_intent.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	mov_intent.screen_loc = ui_movi
	static_inventory += mov_intent

	using = new /obj/screen/drop()
	using.name = "Drop"
	using.name_ru = "Уронить"
	using.icon = ui_style
	using.screen_loc = ui_drop
	static_inventory += using

	using = new /obj/screen/fixeye()
	using.name = "Fixed Eye"
	using.name = "Закрепить взгляд"
	using.icon = ui_style
	using.screen_loc = ui_fixeye
	static_inventory += using

	using = new /obj/screen/skills()
	using.name = "Skills"
	using.name_ru = "Навыки"
	using.icon = ui_style
	using.screen_loc = ui_skills
	static_inventory += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Uniform"
	inv_box.name_ru = "Одежда"
	inv_box.icon = ui_style
	inv_box.slot_id = slot_w_uniform
	inv_box.icon_state = "uniform"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_iclothing
	toggleable_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Upper suit"
	inv_box.name_ru = "Верхний костюм"
	inv_box.icon = ui_style
	inv_box.slot_id = slot_wear_suit
	inv_box.icon_state = "suit"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_oclothing
	toggleable_inventory += inv_box

	build_hand_slots(ui_style)

	using = new /obj/screen/swap_hand()
	using.name = "Swap hands"
	using.name_ru = "Сменить руку"
	using.icon = ui_style
	using.icon_state = "swap_1"
	using.screen_loc = ui_swap1
	static_inventory += using

	using = new /obj/screen/swap_hand()
	using.name = "Swap hands"
	using.name_ru = "Сменить руку"
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swap2
	static_inventory += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Device"
	inv_box.name_ru = "Устройство"
	inv_box.icon = ui_style
	inv_box.icon_state = "id"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_id
	inv_box.slot_id = slot_wear_id
	static_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Mask"
	inv_box.name_ru = "Маска"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_mask
	inv_box.slot_id = slot_wear_mask
	toggleable_inventory += inv_box

/*	inv_box = new /obj/screen/inventory()
	inv_box.name = "neck"
	inv_box.icon = ui_style
	inv_box.icon_state = "neck"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_neck
	inv_box.slot_id = slot_neck
	static_inventory += inv_box*/

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Back"
	inv_box.name_ru = "Спина"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_back
	inv_box.slot_id = slot_back
	static_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Back Weapon"
	inv_box.name_ru = "Оружие на спине"
	inv_box.icon = ui_style
	inv_box.icon_state = "back2"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_back2
	inv_box.slot_id = slot_back2
	static_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Pocket"
	inv_box.name_ru = "Карман"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_storage1
	inv_box.slot_id = slot_l_store
	static_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Pocket"
	inv_box.name_ru = "Карман"
	inv_box.icon = ui_style
	inv_box.icon_state = "pocket"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_storage2
	inv_box.slot_id = slot_r_store
	static_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Lower head"
	inv_box.name_ru = "Шлем"
	inv_box.icon = ui_style
	inv_box.icon_state = "head_hard"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_head_hard
	inv_box.slot_id = slot_head_hard
	toggleable_inventory += inv_box

	using = new /obj/screen/resist()
	using.name = "Resist"
	using.name_ru = "Сопротивляться"
	using.icon = ui_style
	using.screen_loc = ui_resist
	hotkeybuttons += using

	using = new /obj/screen/human/toggle()
	using.name = "Side panel"
	using.name_ru = "Боковая панель"
	using.icon = 'icons/stalker/hud/background.dmi'
	using.icon_state = "button"
	using.screen_loc = "SOUTH-1:-3, WEST"
	static_inventory += using

/*	using = new /obj/screen/human/equip()
	using.icon = ui_style
	using.screen_loc = ui_equip_position(mymob)
	static_inventory += using*/

	using = new /obj/screen/inventory()
	using.icon = 'icons/stalker/hud/panel.dmi'
	using.icon_state = ""
	using.screen_loc = "SOUTH:6, WEST"
	toggleable_inventory += using

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Gloves"
	inv_box.name_ru = "Перчатки"
	inv_box.icon = ui_style
	inv_box.icon_state = "gloves"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_gloves
	inv_box.slot_id = slot_gloves
	toggleable_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Eyes"
	inv_box.name_ru = "Глаза"
	inv_box.icon = ui_style
	inv_box.icon_state = "glasses"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_glasses
	inv_box.slot_id = slot_glasses
	toggleable_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Lower suit"
	inv_box.name_ru = "Нижний костюм"
	inv_box.icon = ui_style
	inv_box.icon_state = "suit_hard"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_oclothing_hard
	inv_box.slot_id = slot_wear_suit_hard
	toggleable_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Upper head"
	inv_box.name_ru = "Головной убор"
	inv_box.icon = ui_style
	inv_box.icon_state = "head"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_head
	inv_box.slot_id = slot_head
	toggleable_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Shoes"
	inv_box.name_ru = "Обувь"
	inv_box.icon = ui_style
	inv_box.icon_state = "shoes"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_shoes
	inv_box.slot_id = slot_shoes
	toggleable_inventory += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "Belt"
	inv_box.name_ru = "Пояс"
	inv_box.icon = ui_style
	inv_box.icon_state = "belt"
//	inv_box.icon_full = "template_small"
	inv_box.screen_loc = ui_belt
	inv_box.slot_id = slot_belt
	static_inventory += inv_box

	hunger = new /obj/screen/hunger()
	hunger.name = "Hunger"
	hunger.name_ru = "Голод"
	hunger.screen_loc = "NORTH-5:6, EAST+1"
	infodisplay += hunger

	thirst = new /obj/screen/thirst()
	thirst.name = "Thirst"
	thirst.name_ru = "Жажда"
	thirst.screen_loc = "NORTH-5:6, EAST+2:-7"
	infodisplay += thirst

	weight = new /obj/screen/weight()
	weight.screen_loc = ui_mental_physic
	infodisplay += weight

	mental = new /obj/screen/mental()
	mental.screen_loc = ui_mental_physic
	infodisplay += mental

	using = new /obj/screen/brain()
	using.screen_loc = ui_mental_physic
	infodisplay += using


	rest_icon = new /obj/screen/human/rest_int()
	rest_icon.name = "Rest"
	rest_icon.name_ru = "Лечь/Встать"
	static_inventory += rest_icon
/*
	using = new /obj/screen/human/sleep_int()
	using.name = "sleep"
	using.icon = ui_style
	using.icon_state = "sleep"
	using.screen_loc = ui_sleep
	static_inventory += using
*/
	throw_icon = new /obj/screen/throw_catch()
	throw_icon.name = "Throw"
	throw_icon.name_ru = "Кинуть"
	throw_icon.icon = ui_style
	throw_icon.screen_loc = ui_throw
	hotkeybuttons += throw_icon

	internals = new /obj/screen/internals()
	infodisplay += internals


/*
	var/i_h = 0
	while(i_h < HEALTH_BAR_Y_SIZE)
		i_h++
		using = new /obj/screen/healths()
		using.screen_loc = "EAST+1:29,NORTH-6:[12+i_h]"
		healths += using
		healths[i_h] = using
		if(i_h == 1)
			using = new /obj/screen()
			using.icon = 'icons/stalker/hud/fade.dmi'
			using.icon_state = "down"
			using.name = ""
			using.screen_loc = "EAST+1:29,NORTH-6:[12+i_h]"
			using.layer = 21
			bars += using

		if(i_h == (HEALTH_BAR_Y_SIZE-9))
			using = new /obj/screen()
			using.icon = 'icons/stalker/hud/fade.dmi'
			using.icon_state = "up"
			using.name = ""
			using.screen_loc = "EAST+1:29,NORTH-6:[12+i_h]"
			using.layer = 21
			bars += using


//	infodisplay += healths

	var/i_s = 0
	while(i_s < HEALTH_BAR_Y_SIZE)
		i_s++
		using = new /obj/screen/stamina()
		using.screen_loc = "EAST+1:13,NORTH-6:[12+i_s]"
		staminas += using
		staminas[i_s] = using
		if(i_s == 1)
			using = new /obj/screen()
			using.icon = 'icons/stalker/hud/fade.dmi'
			using.icon_state = "down"
			using.name = ""
			using.screen_loc = "EAST+1:13,NORTH-6:[12+i_s]"
			using.layer = 21
			bars += using

		if(i_s == (HEALTH_BAR_Y_SIZE-9))
			using = new /obj/screen()
			using.icon = 'icons/stalker/hud/fade.dmi'
			using.icon_state = "up"
			using.name = ""
			using.screen_loc = "EAST+1:13,NORTH-6:[12+i_s]"
			using.layer = 21
			bars += using
*/
	healthdoll = new /obj/screen/healthdoll()
	healthdoll.screen_loc = "EAST+1:9,NORTH-3:17"
	infodisplay += healthdoll

	stamina = new /obj/screen/stamina()
	infodisplay += stamina

	str = new /obj/screen/stats/str() //9
	str.screen_loc = "EAST+1, NORTH-1:15"
	infodisplay += str

	agi = new /obj/screen/stats/agi() //10
	agi.screen_loc = "EAST+2:4, NORTH-1:15"
	infodisplay += agi

	hlt = new /obj/screen/stats/hlt() //10
	hlt.screen_loc = "EAST+1:12, NORTH-1:15"
	infodisplay += hlt

	int = new /obj/screen/stats/int() //13
	int.screen_loc = "EAST+1:24, NORTH-1:15"
	infodisplay += int

	zone_select =  new /obj/screen/zone_sel()
	zone_select.icon = 'icons/stalker/hud/puppet64.dmi'
	zone_select.update_icon(mymob)
	static_inventory += zone_select

	//mymob.pulseimage = new /obj/screen/pulseimage()
	//mymob.whitenoise = new /obj/screen/whitenoise()




	for(var/obj/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[inv.slot_id] = inv
			inv.update_icon()



//	using = new /obj/screen/(null)
//	using.icon_state = "alarm"
//	using.screen_loc = "EAST,NORTH-4 to EAST,NORTH-8"
//	static_inventory += using

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "CENTER-7,CENTER-7"
	mymob.blind.mouse_opacity = 0
	mymob.blind.layer = 0
	mymob.blind.alpha = 0

	mymob.damageoverlay = new /obj/screen()
	mymob.damageoverlay.icon = 'icons/mob/screen_full.dmi'
	mymob.damageoverlay.icon_state = "oxydamageoverlay0"
	mymob.damageoverlay.name = "dmg"
	mymob.damageoverlay.blend_mode = BLEND_OVERLAY
	mymob.damageoverlay.screen_loc = "CENTER-7,CENTER-7"
	mymob.damageoverlay.mouse_opacity = 0
	mymob.damageoverlay.layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.

	mymob.whitenoise = new /obj/screen()
	mymob.whitenoise.icon = 'icons/mob/screen_full.dmi'
	mymob.whitenoise.icon_state = "whitenoise"
	mymob.whitenoise.name = "whitenoise"
	mymob.whitenoise.blend_mode = BLEND_ADD
	mymob.whitenoise.screen_loc = "CENTER-7,CENTER-7"
	mymob.whitenoise.mouse_opacity = 0
	mymob.whitenoise.layer = 18.05
	mymob.whitenoise.alpha = 0

	mymob.nightvision = new /obj/screen()
	mymob.nightvision.icon = 'icons/stalker/hud_full.dmi'
	mymob.nightvision.icon_state = "nvg_hud1"
	mymob.nightvision.name = "nightvision"
	mymob.nightvision.blend_mode = BLEND_MULTIPLY
	mymob.nightvision.screen_loc = "CENTER-7,CENTER-7"
	mymob.nightvision.mouse_opacity = 0
	mymob.nightvision.layer = 19
	mymob.nightvision.alpha = 0

	mymob.pulseimage = new /obj/screen()
	mymob.pulseimage.icon = 'icons/stalker/mob/pulseimage.dmi'
	mymob.pulseimage.icon_state = "pulseimage"
	mymob.pulseimage.name = "pulseimage"
	mymob.pulseimage.blend_mode = BLEND_ADD
	mymob.pulseimage.screen_loc = "CENTER-7,CENTER-7"
	mymob.pulseimage.mouse_opacity = 0
	mymob.pulseimage.layer = 19
	mymob.pulseimage.alpha = 0

	mymob.flash = new /obj/screen()
	mymob.flash.icon_state = "blank"
	mymob.flash.name = ""
	mymob.flash.blend_mode = BLEND_ADD
	mymob.flash.screen_loc = "WEST,SOUTH to EAST,NORTH"
	mymob.flash.layer = 21

/*
	mymob.lighting_backdrop_lit = new /obj/screen()
	mymob.lighting_backdrop_lit.icon = 'icons/mob/screen_gen.dmi'
	mymob.lighting_backdrop_lit.icon_state = "flash"
	mymob.lighting_backdrop_lit.transform = matrix(200, 0, 0, 0, 200, 0)
	mymob.lighting_backdrop_lit.plane = LIGHTING_PLANE
	mymob.lighting_backdrop_lit.blend_mode = BLEND_OVERLAY
	mymob.lighting_backdrop_lit.layer = 13
	mymob.lighting_backdrop_lit.color = "#000"
	mymob.lighting_backdrop_lit.alpha = 255

	mymob.lighting_backdrop_unlit = new /obj/screen()
	mymob.lighting_backdrop_unlit.icon = 'icons/mob/screen_gen.dmi'
	mymob.lighting_backdrop_unlit.icon_state = "flash"
	mymob.lighting_backdrop_unlit.transform = matrix(200, 0, 0, 0, 200, 0)
	mymob.lighting_backdrop_unlit.plane = LIGHTING_PLANE
	mymob.lighting_backdrop_unlit.blend_mode = BLEND_OVERLAY
	mymob.lighting_backdrop_unlit.layer = 12
	mymob.lighting_backdrop_unlit.alpha = 255


	mymob.sun_lighting_backdrop_lit = new /obj/screen()
	mymob.sun_lighting_backdrop_lit.icon = 'icons/mob/screen_gen.dmi'
	mymob.sun_lighting_backdrop_lit.icon_state = "flash"
	mymob.sun_lighting_backdrop_lit.transform = matrix(200, 0, 0, 0, 200, 0)
	mymob.sun_lighting_backdrop_lit.plane = SUNLIGHTING_PLANE
	mymob.sun_lighting_backdrop_lit.blend_mode = BLEND_OVERLAY
	mymob.sun_lighting_backdrop_lit.layer = 13
	mymob.sun_lighting_backdrop_lit.color = "#000"
	mymob.sun_lighting_backdrop_lit.alpha = 255

	mymob.sun_lighting_backdrop_lit = new /obj/screen()
	mymob.sun_lighting_backdrop_lit.icon = 'icons/mob/screen_gen.dmi'
	mymob.sun_lighting_backdrop_lit.icon_state = "flash"
	mymob.sun_lighting_backdrop_lit.transform = matrix(200, 0, 0, 0, 200, 0)
	mymob.sun_lighting_backdrop_lit.plane = SUNLIGHTING_PLANE
	mymob.sun_lighting_backdrop_lit.blend_mode = BLEND_OVERLAY
	mymob.sun_lighting_backdrop_lit.layer = 12
	mymob.sun_lighting_backdrop_lit.alpha = 255
*/

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used.inventory_shown && screenmob.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = ui_shoes
			H.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = ui_gloves
			H.client.screen += H.gloves
		if(H.ears)
			H.ears.screen_loc = ui_ears
			H.client.screen += H.ears
		if(H.glasses)
			H.glasses.screen_loc = ui_glasses
			H.client.screen += H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = ui_iclothing
			H.client.screen += H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = ui_oclothing
			H.client.screen += H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = ui_mask
			H.client.screen += H.wear_mask
		if(H.head)
			H.head.screen_loc = ui_head
			H.client.screen += H.head
		if(H.s_store)
			H.s_store.screen_loc = ui_sstore
			H.client.screen += H.s_store
		if(H.wear_suit_hard)
			H.wear_suit_hard.screen_loc = ui_oclothing_hard
			H.client.screen += H.wear_suit_hard
		if(H.head_hard)
			H.head_hard.screen_loc = ui_head_hard
			H.client.screen += H.head_hard
	else
		if(H.shoes)
			H.shoes.screen_loc = null
			H.client.screen -= H.shoes
		if(H.gloves)
			H.gloves.screen_loc = null
			H.client.screen -= H.gloves
		if(H.ears)
			H.ears.screen_loc = null
			H.client.screen -= H.ears
		if(H.glasses)
			H.glasses.screen_loc = null
			H.client.screen -= H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = null
			H.client.screen -= H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = null
			H.client.screen -= H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = null
			H.client.screen -= H.wear_mask
		if(H.head)
			H.head.screen_loc = null
			H.client.screen -= H.head
		if(H.s_store)
			H.s_store.screen_loc = null
			H.client.screen -= H.s_store
		if(H.wear_suit_hard)
			H.wear_suit_hard.screen_loc = null
			H.client.screen -= H.wear_suit_hard
		if(H.head_hard)
			H.head_hard.screen_loc = null
			H.client.screen -= H.head_hard



/datum/hud/human/persistant_inventory_update(mob/viewer)
	if(!mymob)
		return
	..()
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
//		if(screenmob.hud_used.hud_shown)
		if(H.wear_id)
			H.wear_id.screen_loc = ui_id
			screenmob.client.screen += H.wear_id
		if(H.belt)
			H.belt.screen_loc = ui_belt
			screenmob.client.screen += H.belt
		if(H.back)
			H.back.screen_loc = ui_back
			screenmob.client.screen += H.back
		if(H.back2)
			H.back2.screen_loc = ui_back2
			screenmob.client.screen += H.back2
		if(H.l_store)
			H.l_store.screen_loc = ui_storage1
			screenmob.client.screen += H.l_store
		if(H.r_store)
			H.r_store.screen_loc = ui_storage2
			screenmob.client.screen += H.r_store
	else
		if(H.wear_id)
			screenmob.client.screen -= H.wear_id
		if(H.belt)
			screenmob.client.screen -= H.belt
		if(H.back)
			screenmob.client.screen -= H.back
		if(H.back2)
			H.back2.screen_loc = ui_back2
			screenmob.client.screen += H.back2
		if(H.l_store)
			screenmob.client.screen -= H.l_store
		if(H.r_store)
			screenmob.client.screen -= H.r_store
/*
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			screenmob.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			screenmob.client.screen -= I
*/

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1
