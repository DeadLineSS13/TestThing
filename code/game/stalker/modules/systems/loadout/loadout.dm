var/list/loadout_datums = list()
GLOBAL_LIST_EMPTY(available_uniform)

/proc/create_loadout_datums()
	for(var/thing in subtypesof(/datum/loadout_equip) - subtypesof(/datum/loadout_equip/donate))
		loadout_datums += new thing()

/client
	var/list/achievements = list()

/datum/loadout
	var/client/parent
	var/path

	var/default_slot = 1
	var/points = 10
	var/money_points = 0
	var/obj/item/clothing/uniform = null
	var/backpack = "backpack"
	var/list/loadout_equipment = list()
	var/list/accessable_loadout = list()
	var/list/saved_loadout = list()

	var/tab = "weapon"

//	Experience system
	var/list/exp_actions = list()
	var/experience = 0
	var/level = 0

/datum/loadout/New(client/C)
	parent = C

	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)

	if(default_slot != parent.prefs.default_slot)
		default_slot = parent.prefs.default_slot

	load_loadout()
	if(!uniform)
		uniform = pick(GLOB.available_uniform)

	build_loadout()

/datum/loadout/proc/build_loadout()
	if(!loadout_datums.len)
		create_loadout_datums()

	points = initial(points) + level*2 + money_points

	for(var/datum/loadout_equip/LE in loadout_equipment)
		points -= LE.cost

	accessable_loadout.Cut()
	for(var/datum/loadout_equip/LE in loadout_datums)
		if(LE.name == "Test")
			continue
		if(locate(LE) in saved_loadout)
			LE.unlimited = 0
			accessable_loadout += LE
			continue
		if(LE.level_needed > level)
			continue
		if(!LE.unlimited && locate(LE) in loadout_equipment)
			continue
		accessable_loadout += LE

	var/datum/donation/D = parent.get_donation("Custom Item")
	if(D && D.items)
		for(var/item_path in D.items)
			if(!(locate(item_path) in loadout_equipment))
				accessable_loadout += new item_path()


/datum/loadout/proc/show_loadout(mob/user)
	if(!user || !user.client)
		return
	if(!parent)
		parent = user.client
		return
	if(default_slot != parent.prefs.default_slot)
		default_slot = parent.prefs.default_slot
		load_loadout()
		build_loadout()
	var/dat

	var/exp_percents = experience/(100+level*100)*100
	if(path)
		new /savefile(path)
		dat += user.client.select_lang("<p>Твой ранг: <b>[get_rank("Russian")]</b>. <br />Ты заработал <b>[exp_percents]%</b> опыта для достижения следующего ранга.</p>",
										"<p>Your rank is <b>[get_rank()]</b>. <br />You have earned <b>[exp_percents]%</b> of the experience required to earn next rank.</p>")
		dat += "<p>"
		if(money_points)
			dat += user.client.select_lang("<strong>[money_points]</strong> очков перенесено с предыдущей игры<br>", "<strong>[money_points]</strong> points were saved from the previous game<br>")
		dat += user.client.select_lang("У тебя ещё <strong>[points]</strong> очков снаряжения, а твоя одежда: <a href ='?_src_=loadout;preference=uniform;task=input'>[uniform]</a><br>",
									"You have <strong>[points]</strong> more loadout points and your uniform is: <a href ='?_src_=loadout;preference=uniform;task=input'>[uniform]</a><br>")
		dat += user.client.select_lang("На твоей спине: <a href ='?_src_=loadout;preference=backpack;task=input'>[get_ru_name(backpack)]</a>",
									"On your back is: <a href ='?_src_=loadout;preference=backpack;task=input'>[backpack]</a>")
		dat += "</p>"
		dat += "<table style=\"width: 500px; text-align: center;\"><tbody><tr>"
		dat += user.client.select_lang("<td style=\"width: 500px;\">\
										<strong><a href=?_src_=loadout;task=switch;preference=weapon>Оружие</a>&nbsp;&nbsp;&nbsp;\
										<a href=?_src_=loadout;task=switch;preference=gear>Снаряжение</a>&nbsp;&nbsp;&nbsp;\
										<a href=?_src_=loadout;task=switch;preference=ammo>Боеприпасы</a>&nbsp;&nbsp;&nbsp;\
										<a href=?_src_=loadout;task=switch;preference=meds>Медикаменты</a>",

										"<td style=\"width: 500px;\">\
										<strong><a href=?_src_=loadout;task=switch;preference=weapon>Weapon</a>&nbsp;&nbsp;&nbsp;\
										<a href=?_src_=loadout;task=switch;preference=gear>Gear</a>&nbsp;&nbsp;&nbsp;\
										<a href=?_src_=loadout;task=switch;preference=ammo>Ammo</a>&nbsp;&nbsp;&nbsp;\
										<a href=?_src_=loadout;task=switch;preference=meds>Medicine</a>")

		if(parent.get_donation("Custom Item"))
			dat += user.client.select_lang("&nbsp;&nbsp;&nbsp;<a href=?_src_=loadout;task=switch;preference=donate>Личное</a>",
										"&nbsp;&nbsp;&nbsp;<a href=?_src_=loadout;task=switch;preference=donate>Personal</a>")

		dat += "</strong></td></tr></tbody></table>"

		dat += "<table style=\"width: 500px;\" cellspacing=\"5\" cellpadding=\"5\">"
		dat += "<tbody>"
		dat += "<tr>"
		dat += "<td style=\"width: 250px;\">"
		if(loadout_equipment.len)
			dat += user.client.select_lang("<strong>Твоё снаряжение:</strong><br />",
										"<strong>Your equipment:</strong><br />")
		else
			dat += user.client.select_lang("<strong>Ты ничего не взял!</strong><br />",
										"<strong>You didnt take anything!</strong><br />")
		dat += "</td>"
		dat += "<td style=\"width: 250px;\">"
		if(accessable_loadout.len)
			dat += user.client.select_lang("<strong>Доступное снаряжение:</strong><br />",
										"<strong>Available equipment:</strong><br />")
		else
			dat += user.client.select_lang("<strong>Ты не можешь ничего взять!</strong><br />",
										"<strong>You cant take anything!</strong><br />")
		dat += "</td>"
		dat += "</tr>"
		dat += "<td style=\"width: 250px;\", valign = \"top\">"
		if(loadout_equipment.len)
			dat += "<table style=\"width: 240px;\" border=\"3\" cellspacing=\"5\" cellpadding=\"5\">"
			dat += "<tbody>"
			for(var/datum/loadout_equip/LE in loadout_equipment)
				dat += "<tr>"
				dat += user.client.select_lang("<td style=\"width: 150px; text-align: left;\"><strong>[LE.name_ru]</strong></td>",
												"<td style=\"width: 150px; text-align: left;\"><strong>[LE.name]</strong></td>")
				dat += "<td style=\"width: 20px; text-align: center;\">[LE.cost]</td>"
				dat += user.client.select_lang("<td style=\"width: 60px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=remove;task=input;item=\ref[LE]'>Убрать</a></strong></td>",
												"<td style=\"width: 60px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=remove;task=input;item=\ref[LE]'>Remove</a></strong></td>")
				dat += "</tr>"
			dat += "</tbody>"
			dat += "</table>"
		dat += "</td>"

		dat += "<td style=\"width: 250px; text-align: left;\", valign = \"top\">"
		if(accessable_loadout.len)
			dat += "<table style=\"width: 240px;\" border=\"3\" cellspacing=\"5\" cellpadding=\"5\">"
			dat += "<tbody>"
			dat += "<tr>"
			if(tab == "weapon")
				for(var/datum/loadout_equip/weapon/LE in accessable_loadout)
					dat += user.client.select_lang("<tr><td style=\"width: 160px; text-align: left;\"><strong>[LE.name_ru]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>",
													"<td style=\"width: 160px; text-align: left;\"><strong>[LE.name]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>")
					dat += user.client.select_lang("<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Взять</a></strong></td></tr>",
												"<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Take</a></strong></td></tr>")
			if(tab == "gear")
				for(var/datum/loadout_equip/gear/LE in accessable_loadout)
					dat += user.client.select_lang("<tr><td style=\"width: 160px; text-align: left;\"><strong>[LE.name_ru]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>",
													"<td style=\"width: 160px; text-align: left;\"><strong>[LE.name]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>")
					dat += user.client.select_lang("<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Взять</a></strong></td></tr>",
												"<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Take</a></strong></td></tr>")
			if(tab == "ammo")
				for(var/datum/loadout_equip/ammo/LE in accessable_loadout)
					dat += user.client.select_lang("<tr><td style=\"width: 160px; text-align: left;\"><strong>[LE.name_ru]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>",
													"<td style=\"width: 160px; text-align: left;\"><strong>[LE.name]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>")
					dat += user.client.select_lang("<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Взять</a></strong></td></tr>",
												"<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Take</a></strong></td></tr>")
			if(tab == "meds")
				for(var/datum/loadout_equip/meds/LE in accessable_loadout)
					dat += user.client.select_lang("<tr><td style=\"width: 160px; text-align: left;\"><strong>[LE.name_ru]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>",
													"<td style=\"width: 160px; text-align: left;\"><strong>[LE.name]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>")
					dat += user.client.select_lang("<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Взять</a></strong></td></tr>",
												"<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Take</a></strong></td></tr>")

			if(tab == "donate")
				for(var/datum/loadout_equip/donate/LE in accessable_loadout)
					dat += user.client.select_lang("<tr><td style=\"width: 160px; text-align: left;\"><strong>[LE.name_ru]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>",
													"<td style=\"width: 160px; text-align: left;\"><strong>[LE.name]</strong></td><td style=\"width: 20px; text-align: center;\">[LE.cost]</td>")
					dat += user.client.select_lang("<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Взять</a></strong></td></tr>",
												"<td style=\"width: 50px; text-align: center;\"><strong><a href ='?_src_=loadout;preference=pick;task=input;item=\ref[LE]'>Take</a></strong></td></tr>")


			dat += "</tr></tbody></table>"
		dat += "</td></tr></tbody></table>"

	var/datum/browser/popup
	if(user.client.language == "Russian")
		popup = new(user, "loadout", "<div align='center'>Экипировка</div>", 560, 700)
	else
		popup = new(user, "loadout", "<div align='center'>Loadout</div>", 560, 700)
	popup.set_content(dat)
	popup.open(0)

/datum/loadout/proc/process_link(mob/user, list/href_list)
	switch(href_list["task"])
		if("input")
			switch(href_list["preference"])
				if("pick")
					var/datum/loadout_equip/LE = locate(href_list["item"])
					if(points - LE.cost < 0)
						return
					loadout_equipment += LE
					points -= LE.cost
					if(!LE.unlimited)
						accessable_loadout -= LE
				if("remove")
					var/datum/loadout_equip/LE = locate(href_list["item"])
					if(!LE)
						return
					loadout_equipment -= LE
					points += LE.cost
					if(!LE.unlimited)
						accessable_loadout += LE
				if("uniform")
					var/new_uniform = input(user, "Choose your uniform:", "Uniform") as null|anything in GLOB.available_uniform
					if(new_uniform)
						uniform = new_uniform
				if("backpack")
					var/new_backpack
					if(user.client.language == "Russian")
						new_backpack = input(user, "Выбери себе рюкзак:", "Рюкзак") as null|anything in list("рюкзак", "сумка")
						new_backpack = get_en_name(new_backpack)
					else
						new_backpack = input(user, "Choose your backpack:", "Backpack") as null|anything in list("backpack", "satchel")
					if(new_backpack)
						backpack = new_backpack
		if("switch")
			switch(href_list["preference"])
				if("weapon")
					tab = "weapon"
				if("gear")
					tab = "gear"
				if("ammo")
					tab = "ammo"
				if("meds")
					tab = "meds"
				if("donate")
					tab = "donate"

	sortList(loadout_equipment)
	sortList(accessable_loadout)
	show_loadout(user)
	save_loadout()

/datum/loadout/proc/get_ru_name(name)
	switch(name)
		if("sweater")
			return "свитер"
		if("sweater dark")
			return "тёмный свитер"
		if("tracksuit")
			return "спортивный костюм"
		if("telnashka")
			return "тельняшка"
		if("backpack")
			return "рюкзак"
		if("satchel")
			return "сумка"

/datum/loadout/proc/get_en_name(name)
	switch(name)
		if("рюкзак")
			return "backpack"
		if("сумка")
			return "satchel"

/datum/loadout/proc/load_path(ckey,filename="loadout.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"


/datum/loadout/proc/save_loadout()
	if(!path)
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/loadout[default_slot]"

	S["experience"] << experience
	S["level"] << level
	S["money_points"] << money_points
	S["loadout_equipment"] << loadout_equipment
	S["saved_loadout"] << saved_loadout
	S["exp_actions"] << exp_actions
	S["uniform"] << uniform
	S["backpack"] << backpack
	return 1

/datum/loadout/proc/load_loadout()
	if(!path)
		return 0
	if(!fexists(path))
		return 0
	var/savefile/S = new /savefile(path)
	if(!S)
		return 0
	S.cd = "/loadout[default_slot]"

	S["experience"] >> experience
	if(!experience)
		experience = initial(experience)
	S["level"] >> level
	if(!level)
		level = initial(level)
	S["money_points"] >> money_points
	if(!money_points)
		money_points = initial(money_points)
	S["loadout_equipment"] >> loadout_equipment
	if(!loadout_equipment)
		loadout_equipment = list()
	S["saved_loadout"] >> saved_loadout
	if(!saved_loadout)
		saved_loadout = list()
	S["exp_actions"] >> exp_actions
	if(!exp_actions)
		exp_actions = list()
	S["uniform"] >> uniform
	if(!uniform)
		uniform = pick(GLOB.available_uniform)
	S["backpack"] >> backpack
	if(!backpack)
		backpack = "backpack"
	return 1

/datum/loadout/proc/get_rank(language = "English")
	if(language == "English")
		switch(level)
			if(0)
				return "Nameless"
			if(1)
				return "Lockpick"
			if(2)
				return "Rookie"
			if(3)
				return "Vagabond"
			if(4)
				return "Walker"
			if(5)
				return "Experienced"
			if(6)
				return "Hardened"
			if(7)
				return "Veteran"
			if(8)
				return "Expert"
			if(9)
				return "Professional"
			if(10)
				return "Master"
	if(language == "Russian")
		switch(level)
			if(0)
				return "Безымянный"
			if(1)
				return "Отмычка"
			if(2)
				return "Новичок"
			if(3)
				return "Бродяга"
			if(4)
				return "Ходок"
			if(5)
				return "Опытный"
			if(6)
				return "Закалённый"
			if(7)
				return "Ветеран"
			if(8)
				return "Эксперт"
			if(9)
				return "Профессионал"
			if(10)
				return "Мастер"


/mob/living/carbon/human/proc/convert_equip_tomoney()
	if(!client)
		return
	if(!SSstat.blowouts_happened)
		return
	var/list/items = get_all_slots()
	items += get_active_held_item()
	items += get_inactive_held_item()
	client.loadout.saved_loadout.Cut()
	for(var/obj/item/I in items)
		for(var/datum/loadout_equip/LE in loadout_datums)
			if(istype(I, LE.item_path))
				client.loadout.saved_loadout += LE

	client.loadout.money_points = 0
	var/points = min(money, 100000)
/*
	if(wear_id)
		if(istype(wear_id, /obj/item/device/pager))
			var/obj/item/device/pager/P = wear_id
			money = min(P.money, 100000)

		else if(istype(wear_id, /obj/item/money_card))
			var/obj/item/money_card/P = wear_id
			money = min(P.money, 100000)
*/
	client.loadout.money_points = round(points/5000)
	client.loadout.save_loadout()