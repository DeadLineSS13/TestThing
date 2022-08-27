/obj/machinery/stalker
	icon = 'icons/stalker/structure/electric.dmi'

/obj/machinery/stalker/sidormat
	name = "Jaba"
	name_ru = "����"
	desc = "Local trader."
	desc_ru = "������� ��������."
	icon = 'icons/stalker/sidorovich.dmi'
	icon_state = "jaba"
	density = 1
	anchored = 1
	var/itemloc = null
	var/itemloc2 = null
	var/balance = 0
	var/rating = 0
	var/switches = 0
	var/real_assorment = list()
	var/list/special_factions = list("Loners", "Bandits")
	var/path_ending = null
	var/current_tab = 0
	var/category
	var/datum/data/stalker_quests/quest_category = null
	var/message = ""

/datum/asset/simple/sidormat
	assets = list(
		"ded"				= 'icons/stalker/images/ded.gif',
		"background"			= 'interface/background.png'
		)

/obj/machinery/stalker/sidormat/New()
	itemloc = locate(x - 1, y, z)
	itemloc2 = locate(x + 1, y, z)

/obj/machinery/stalker/sidormat/attack_hand(mob/user)
	balance = 0
	if(..())
		return

	if(!ishuman(user))
		say("You are not a human.")
		return

	var/mob/living/carbon/human/H = user

	interact(H)

/obj/machinery/stalker/sidormat/interact(mob/living/carbon/human/H)

//	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
//		say("Put on your money card or pager.","Put on your money card or pager.")
//		return

	H.set_machine(src)
	balance = H.money

//	if(istype(H.wear_id, /obj/item/device/pager))
//		var/obj/item/device/pager/P = H.wear_id
//		balance = P.money

//	if(istype(H.wear_id, /obj/item/money_card))
//		var/obj/item/money_card/P = H.wear_id
//		balance = P.money
	switch(current_tab)
		if(0)
			if(!message)
				var/hello_word = pick("�� �������","������","�������","����������","������","�� �� ���� �� ������, �����������")
				var/intro_word = pick("� ��� ���������?","���� �����?","�� ��� ���?","���� �����?","�� �� ���� ��� ������ ���������?")
				var/hello_word_en = pick("Hello", "Hi","Welcome")
				var/intro_word_en = pick("How is it?","What do you need?")
				message = H.client.select_lang("[hello_word], [H.real_name]. [intro_word]",
												"[hello_word_en],[H.real_name]. [intro_word_en]")
		if(1)
			if(!message)
				var/trade_word = pick("����������� ������? ��, ����� ���������, ��� ��� � ����.","����� ���������� ����� ���������?","�� � ��� �� ���� ��� ��������?","��-��, ��������, ��� ��� � ����.")
				var/asking_word = pick("�������, �� �� �����, ���","�������, �� ��� �������, ���","���� �� �����, ��","�� ������, ���")
				var/trade_word_en = pick("Lets look what you've got.")
				var/asking_word_en = pick("I hope you remember that you need to")
				message = H.client.select_lang("[trade_word] [asking_word] ����� ���� ���������� �� <b>�����</b> �����, � �������� �� <b>������</b>.",
												"[trade_word_en] [asking_word_en] put habar for sale on the <b>left</b> table and take it on the <b>right</b>")
		if(2)
			if(!message)
				var/quest_word = pick("�������? ������ ��������, ��� � ���� ���� �� �������.","������� �����? �� ������, ��� ������. ��������?","�������, ��������? �� ����� ���������. ������ �����, ������ ������ ���� ������������")
				var/quest_word_en = pick("Let's see what we've got here...")
				message = H.client.select_lang("[quest_word]",
												"[quest_word_en]")
		if(3)
			if(!message)
				var/help_word = pick("������ ������? �� ����� ������", "���������� ������ ��� � ���������. ����... ������� ������� ���� ���� ���������.")
				var/help_word_en = pick("Okay, listen to me")
				message = H.client.select_lang("[help_word]",
												"[help_word_en]")

	var/dat
	dat +="<html> \
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />\
	\
	<style>\
		a:link {color: #C58439;}\
		a:visited {color: #C58439;}\
		a:active {color: #C58439;}\
		a:hover {\
			background-color: #261f19;\
		}\
	}\
	a {text-decoration: none;\
	}\
	html {cursor: url('html/cursors/arrow.ani');}\
	body {\
		background-image: url(background);\
		width: 100%;\
		height: 100%;\
		overflow: hidden;\
		color: #9e6852;\
	}\
	.child{\
	width: 100%;\
	height: 100%;\
	overflow-y: scroll;\
	padding-right: 17px;\
	box-sizing: content-box;\
	}\
	.left-menu {\
		font-size: 16px;\
		margin-bottom: 6px;\
	}\
	#left-menu a {\
		float: left;\
		color: #C58439;\
		text-align: center;\
		margin-bottom: 6px;\
		text-decoration: none;\
		background-color: #261f19;\
		border: 5 outset #73645A;\
		width: 175px;\
	}\
	#left-menu a:hover {\
		background-color: #261f19;\
		border: 5 inset #73645A;\
	}\
	#left-menu a.linkOn {\
		color: #C58439;\
		background-color: #261f19;\
		border: 5 inset #73645A;\
	}\
	.navbar {\
		position: fixed;\
		top: 0;\
		width: 100%;\
		padding-top: 3px;\
		padding-bottom: 3px;\
		font-size: 24px;\
	}\
	#navbar a {\
		float: left;\
		color: #C58439;\
		text-align: center;\
		padding-right: 10px;\
		padding-left: 10px;\
		text-decoration: none;\
		font-size: 24px;\
		background-color: #261f19;\
		border: 5 outset #73645A;\
		margin-bottom: 3px;\
	}\
	#navbar a:hover {\
		background-color: #261f19;\
		border: 5 inset #73645A;\
		text-align: center;\
	}\
	#navbar a.linkOn {\
		color: #C58439;\
		background-color: #261f19;\
		border: 5 inset #73645A;\
		text-align: center;\
		padding-right: 10px;\
		padding-left: 10px;\
	}\
	#table-shop {\
		padding: 15px;\
		margin-bottom: 10px;\
		color: #C58439;\
		border: 5 groove #9e6852;\
		border-collapse: collapse;\
		overflow: auto;\
	}\
	#table-shop th {\
		text-align: left;\
		border: 5 groove #9e6852;\
	}\
	#table-shop td {\
		text-align: left;\
		border: 5 groove #9e6852;\
	}\
	</style>"
	dat += "<div class='statusDisplay'>"
	dat += "<table border=0>"
	dat += "<td width = 72><img src=ded width=64 height=64></td>"
	dat += "<td width=500>[message]"
	dat += "<br><table>"
	dat += "<td width = 150>�� �����: [num2text(balance, 8)] RU</td>"
	if(current_tab == 1)
		dat += "<td width = 120><A href='?src=\ref[src];choice=estimate'><b>������� �����</b></A></td>"
		dat += "<td width = 100><A href='?src=\ref[src];choice=take'><b>����� �����</b></A></td>"
		dat += "<td width = 130><A href='?src=\ref[src];choice=cash'><b>������ �������</b></A></td>"
	if(H.current_quest && current_tab == 2)
		dat += "<td><A href='?src=\ref[src];choice=take_quest'><b>����� �����</b></A></td>"
	dat += "</table>"
	dat += "<td valign=\"top\" width=40><div align=right><a href='?src=\ref[src];choice=close'><b>X</b></A><div></td>"
	dat += "</td></table></div>"

	dat += "<div align=\"center\"><table id = \"navbar\">"
	dat += H.client.select_lang("<td valign = \"center\"><a href='?src=\ref[src];choice=shop' [current_tab == 1 ? "class='linkOn'" : ""]>�������</a></td>",
								"<td valign = \"center\"><a href='?src=\ref[src];choice=shop' [current_tab == 1 ? "class='linkOn'" : ""]>Shop</a></td>")
	dat += H.client.select_lang("<td valign = \"center\"><a href='?src=\ref[src];choice=quests' [current_tab == 2 ? "class='linkOn'" : ""]>�������</a></td>",
								"<td valign = \"center\"><a href='?src=\ref[src];choice=quests' [current_tab == 2 ? "class='linkOn'" : ""]>Quests</a></td>")
	dat += H.client.select_lang("<td valign = \"center\"><a href='?src=\ref[src];choice=help' [current_tab == 3 ? "class='linkOn'" : ""]>������</a></td>",
								"<td valign = \"center\"><a href='?src=\ref[src];choice=help' [current_tab == 3 ? "class='linkOn'" : ""]>Help</a></td>")
	dat += "</table></div>"

	switch(current_tab)
		if(1)
			dat += "<div class='child'>"
			dat += "<table border = '0' width = '600' height = '400'>"
			dat += "<td><table id=\"left-menu\" border = '0' width = '180' height = '400'>"
			for(var/L in global_sidormat_list)
				if(L == "Unbuyable" && !(switches & SELL_UNBUYABLE))
					continue
				var/category_check = L
				if(category_check)
					dat += "<tr><a href='?src=\ref[src];tabchoice=[L]'[category == category_check ? "class='linkOn'" : ""]>[L]</a></tr>"
			dat += "</table></td>"

			if(category)
				dat += "<td valign = \"top\"><div align=\"left\">"
				dat += "<table id =\"table-shop\" width='400' height = '[global_sidormat_list[category].len*20]'>"
				for(var/datum/data/stalker_equipment/prize in global_sidormat_list[category])
					dat += H.client.select_lang("<tr><td width=240>[prize.name_ru]</td><td><center>[prize.cost]</center></td><td><center>[prize.assortment_level]</center></td><td><A href='?src=\ref[src];purchase=\ref[prize]'><center>������</center></A></td></tr>",
												"<tr><td width=240>[prize.name_en]</td><td><center>[prize.cost]</center></td><td><center>[prize.assortment_level]</center></td><td><A href='?src=\ref[src];purchase=\ref[prize]'><center>Buy</center></A></td></tr>")
				dat += "</table>"
				dat += "</div></td>"
			dat += "</table>"
			dat += "</div>"
		if(2)
			if(quest_category)
				dat += H.client.select_lang("<br><b>��������: </b>[quest_category.name_ru]<br><br>",
						"<br><b>Name: </b>[quest_category.name_en]<br><br>")
				dat += H.client.select_lang("<b>��������: </b>[quest_category.desc_ru]<br><br>",
						"<b>Description: </b>[quest_category.desc_en]<br>")
				if(quest_category.icon)
					var/icon/I = icon(quest_category.icon, quest_category.icon_state, frame = 1)
					H << browse_rsc(I, quest_category.icon_state)
					dat += "<table><tr>"
					dat += H.client.select_lang("<td><b>����������: </b></td><td><table border = 1; bordercolor = #9e6852><tr><td><img src = [quest_category.icon_state]></table></td></tr></td>",
											"<td><b>Photo: </b></td><td><table border = 1; bordercolor = #9e6852><tr><td><img src = [quest_category.icon_state]></table></td></tr></td>")
					dat += "</tr></table><br>"
				dat += H.client.select_lang("<b>�������: </b>[quest_category.reward]<br><br>",
											"<b>Reward: </b>[quest_category.reward]<br><br>")

				dat += "<A href='?src=\ref[src];choice=give_quest'><b>����� �����</b></A>         "
				dat += "      <A href='?src=\ref[src];choice=quest_back'><b>�����</b></A>"
			else
//				dat += "<br><A href='?src=\ref[src];choice=quest_forkill'>�������� ��������   </A>"
				if(H.current_quest)
					dat += "<A href='?src=\ref[src];choice=quest_refuse'><b>���������� �� �������</b></A>"
				dat += "<br><table border = '0'><tr></tr>"
				for(var/datum/data/stalker_quests/q in quest_list_available)
					dat += H.client.select_lang("<tr><td>[q.name_ru]</td><td><A href='?src=\ref[src];inform=\ref[q]'>���������</A><td></tr>",
												"<tr><td>[q.name_ru]</td><td><A href='?src=\ref[src];inform=\ref[q]'>Information</A><td></tr>")
				dat += "</table>"
		if(3)
			dat += "    ������ ����, �����. ����� - ����, � ������� ������� �������� �� �����. ��� ������ ���� ���������� ������� ���������� ������ � ������, ��, ��� �� ������� - ������� ���� �����, \
					������� ������ ����� ��� ������. ���� � ������� � ���������� ��� ����� � ��������� �� ������� ��������������, �� �������, �� ��� ���� - ���� �� ���, � ���� ����. ��� ����� ������, \
					���������� � �������� ���� ����������, ��� ��� ����������� �� ���������� ����������� ���� ����������� �������, ���� ��� ���������, ������� �������, ����, ������� �� ����� ������������. \
					� �� �� ����� � �������� �� � ���� ���� �� ��������� �� �� ������� ������� ���������, ��� ��� ������� ���� �� ���� ������� ���� ��������� � ������� ���� � ������������ ��� �������. \
					���� �� ��� ���� ������� ��������� ������ - �� ������ ���������� � ���� ����������� ��������: ������, ������� � ����, ��� � �����������. ��� ����� ������, ��� ����� ���� �����������. \
					���� � ���� �������� �������� ������ � ���� - �����������, �����, � �������, � ��� ���� ����������, ��� ������� ��������� - �� ���, �� ����."

	dat += "</html>"

	winshow(H, "sidormat", 1)
	winset(H, "sidormat", "is-visible=true")
	H << browse(sanitize_russian(dat, "window=sidormat.screen_browser;size=640x711"))
//	var/datum/browser/popup = new(H, "miningvendor", "SIDORMAT 3000", 650, 700)
//	popup.set_content(dat)
//	popup.open(0)

	return

/obj/machinery/stalker/sidormat/Topic(href, href_list)
	..()

	if(!usr.canUseTopic(src))
		usr.unset_machine()
		winshow(usr, "sidormat", 0)
		return

	var/mob/living/carbon/human/H = usr

//	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
//		say("Put on your money card or pager.","Put on your money card or pager.")
//		updateUsrDialog()
//		usr.unset_machine()
//		winshow(usr, "sidormat", 0)
//		return
//	var/obj/item/device/pager/PG = H.wear_id

	get_asset_datum(/datum/asset/simple/sidormat).send(H)

	switch(href_list["choice"])
		if("close")
			H.unset_machine()
			winshow(H, "sidormat", 0)
		if("shop")
			if(current_tab != 1)
				current_tab = 1
				message = null
		if("quests")
			if(current_tab != 2)
				current_tab = 2
				message = null
				quest_category = null
		if("help")
			if(current_tab != 3)
				current_tab = 3
				message = null
		if("take")
			SellItems()
		if("estimate")
			EstimateItems()
		if("cash")
			var/input = input(H, "How much?") as num
			input = round(input, 50)
			input = max(0, min(H.money, input))
			if(!input)
				return
			H.money -= input
			GiveCash(input)
			say("��� ���� [input] ������.", "Here are your [input] roubles.")
		if("take_quest")
			QuestTake(H)
		if("give_quest")
			QuestGive(H)
		if("quest_back")
			quest_category = null
		if("quest_forkill")
			var/name_kill = input(H, "Write targets's name","Target's name") as text|null
			if(name_kill == H.name)
				say("Do you really wanna kill youself? Go and suicide!","Do you really wanna kill youself? Go and suicide!")
				updateUsrDialog()
				return
			var/price
			var/founded = 0
			for(var/mob/living/carbon/human/HM in world)
				if(HM.real_name != name_kill)
					continue
				else if(HM.stat != DEAD)
					founded = 1
					price = input(H, "Enter reward", "Reward") as num|null
					if(H.money >= price)
						H.money -= price
						balance = H.money
					else
						say("You don't have enough money","You don't have enough money")
						updateUsrDialog()
						return
			if(!founded)
				say("There's no live stalkers with such name!","There's no live stalkers with such name!")
				updateUsrDialog()
				return

			var/datum/data/stalker_quests/kill = new(src)
			kill.name_ru = "����� �� ��������"
			kill.name_en = "Killing quest"
			kill.desc_ru = "���������� � ������� ������� ����� �������� �� �������� [name_kill]. �������� - [H.name]"
			kill.desc_en = "You should kill as fast as possible stalker named [name_kill]. Orderer - [H.name]"
			kill.reward = price - price/20
			kill.name_kill = name_kill

			quest_list_available += kill
		if("quest_refuse")
			quest_list_available += H.current_quest
			H.current_quest = null
			if(H.mind)
				H.mind.remove_quest()

	if(current_tab == 1)
		for(var/i = 1 to global_sidormat_list.len-1)
			if(global_sidormat_list[i] == href_list["tabchoice"])
				category = global_sidormat_list[i]
				break


	if(href_list["purchase"])
		var/datum/data/stalker_equipment/prize = locate(href_list["purchase"])

		if (!prize)
			updateUsrDialog()
			return

		if(!prize.assortment_level)
			updateUsrDialog()
			return

		if(prize.cost > H.money)
			say("You don't have enough money to buy [prize.name].","You don't have enough money to buy [prize.name].")
			updateUsrDialog()
			return

		H.money -= prize.cost
		balance = H.money

/*
		if(istype(H.wear_id, /obj/item/device/pager))
			var/obj/item/device/pager/P = H.wear_id

			if(prize.cost > P.money)
				say("You don't have enough money to buy [prize.name].","You don't have enough money to buy [prize.name].")
				updateUsrDialog()
				return

			P.money -= prize.cost
			balance = P.money
			//PoolOrNew(prize.equipment_path, itemloc2)

		if(istype(H.wear_id, /obj/item/money_card))
			var/obj/item/money_card/P = H.wear_id

			if(prize.cost > P.money)
				say("You don't have enough money to buy [prize.name].","You don't have enough money to buy [prize.name].")
				updateUsrDialog()
				return

			P.money -= prize.cost
			balance = P.money
			//PoolOrNew(prize.equipment_path, itemloc2)
*/
		prize.assortment_level--
		prize.cost -= prize.cost * ((prize.estimated_demand - max(prize.estimated_demand, prize.total_sold)) - (prize.estimated_supply - max(prize.estimated_supply, prize.total_bought))) * 0.03
		prize.cost = round(prize.cost)
		prize.sale_price = round(prize.cost/2)
		prize.total_sold++
		SSstat.items_bought++
		SSstat.money_earned_by_players -= prize.cost
/*
		if(ispath(prize.equipment_path, /obj/item/weapon/gun))
			var/obj/item/weapon/gun/G = PoolOrNew(prize.equipment_path, itemloc2)
			if(!(H.education == "Military college" || H.profession == "Soldier" || H.trait == "Gun nut"))
				var/dice = dice6(3)
				if(!H.rolld(dice, H.int))
					if(dice-H.int < 7)
						G.durability -= G.durability/10*(dice-H.int)
					else
						G.durability = G.durability*0.19
					updateUsrDialog()
					return
			else
				G.durability -= G.durability/100*rand(1,10)
				updateUsrDialog()
				return
		else
*/
		new prize.equipment_path(itemloc2)

	if(href_list["inform"])
		var/datum/data/stalker_quests/quest = locate(href_list["inform"])

		if(!quest)
			updateUsrDialog()
			return

		quest_category = quest

	updateUsrDialog()

/mob/living/carbon/human
	var/datum/data/stalker_quests/current_quest = null

/obj/machinery/stalker/sidormat/proc/QuestGive(mob/living/carbon/human/H)
	if(H.current_quest)
		say("You already have a quest","You already have a quest")
		return 0
	if(H.name == quest_category.name_kill)
		say("You can't take killing yourself quest","You can't take a killing yourself quest")
		return 0

	H.current_quest = quest_category
	quest_list_available -= quest_category
	if(H.mind)
		H.mind.store_quest(H.client.select_lang("�������: [quest_category.name_ru]<BR>", "Quest: [quest_category.name_en]<BR>"))
		H.mind.store_quest(H.client.select_lang("�����������: [quest_category.desc_ru]<BR>","Description: [quest_category.desc_en]<BR>"))
		H.mind.store_quest(H.client.select_lang("�������: [quest_category.reward] ������<BR>","Reward: [quest_category.reward] roubles<BR>"))
//	var/datum/data/stalker_quests/quest_category_old = quest_category
//	spawn(9000)
//		quest_list_available += quest_category_old							//������� ������ ������� �����
	quest_category = null

/obj/machinery/stalker/sidormat/proc/QuestTake(mob/living/carbon/human/H)
	if(!H.current_quest)
		say("You dont have a quest","You dont have a quest")
		return 0
/*
	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
		say("Put on your money card or pager.","Put on your money card or pager.")
		return 0

	var/obj/item/device/pager/P = H.wear_id
	if(H.current_quest.name_kill)
		if(P.made_photo)
			P.money += H.current_quest.reward
			balance = P.money
			P.made_photo = 0
			H.current_quest = null
			say("Good job","Good job")
*/
	for(var/obj/item/I in itemloc)
		if(istype(I, H.current_quest.needed))
/*
			if(istype(H.wear_id, /obj/item/device/pager))
				P.money += H.current_quest.reward
				balance = P.money

			if(istype(H.wear_id, /obj/item/money_card))
				var/obj/item/money_card/MC = H.wear_id
				MC.money += H.current_quest.reward
				balance = MC.money
*/

			H.money += H.current_quest.reward
			balance = H.money

			H.current_quest = null
			if(H.mind)
				H.mind.remove_quest()
			qdel(I)
			say("Good job","Good job")
		else
			say("Gonna cheat me?", "Gonna cheat me?")

/obj/machinery/stalker/sidormat/proc/EstimateItems()
	var/list/ontable = GetItemsOnTable()
	var/total_cost = GetOnTableCost(ontable)

	if(total_cost)
		say("<b>Habar estimate price is [total_cost] roubles.</b>","<b>�� ��� � �� ��� ���� [total_cost] ������, �� ��������� �� ���������������.</b>")
	else
		say("<b>I won't buy this shit!</b>","<b>� ��� ������ �������� �� ����!</b>")


/obj/machinery/stalker/sidormat/proc/SellItems()
	var/mob/living/carbon/human/H = usr

/*
	if(!istype(H.wear_id, /obj/item/device/pager) && !istype(H.wear_id, /obj/item/money_card))
		say("Put on your money card or pager.","Put on your money card or pager.")
		return

	if(istype(H.wear_id, /obj/item/money_card))
		var/obj/item/money_card/P = H.wear_id
		balance = P.money
*/
	balance = H.money

	var/list/ontable = GetItemsOnTable()
	var/total_cost = GetOnTableCost(ontable)
	var/real_cost

	if(total_cost < 100)
		say("Habar was not sold.","Habar was not sold.")

	for(var/obj/item/I in ontable)
		if(I.loc != itemloc)
			continue

		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			if(S.amount != S.max_amount)
				continue

		for(var/datum/data/stalker_equipment/se in real_sidormat_items)
			if(I.type == se.equipment_path || (istype(I, /obj/item/artefact) && ispath(I.type, se.equipment_path)))
				se.assortment_level++
				se.total_bought++
				if(se.can_be_sold)
					se.cost += se.cost * ((se.estimated_demand - max(se.estimated_demand, se.total_sold)) - (se.estimated_supply - max(se.estimated_supply, se.total_bought))) * 0.02
					se.cost = round(se.cost)
					se.sale_price = round(se.cost/2)
				else
					se.sale_price = se.cost
				SSstat.items_sold++

/*
		if(istype(H.wear_id, /obj/item/device/pager))
			var/obj/item/device/pager/P = H.wear_id
			P.money += GetCost(I.type)
			balance = P.money

		if(istype(H.wear_id, /obj/item/money_card))
			var/obj/item/money_card/P = H.wear_id
			P.money += GetCost(I.type)
			balance = P.money
*/
		var/cost = GetCost(I.type) * I.current_stack
		H.money += cost
		real_cost += cost
		balance = H.money


		qdel(I)
		CHECK_TICK

	if(total_cost)
		say("<b>Habar was successfully sold for [real_cost] roubles.</b>","<b>����� ��� ������� ������ �� [real_cost] ������.</b>")

	SSstat.money_earned_by_players += real_cost

	updateUsrDialog()
	return

/obj/machinery/stalker/sidormat/proc/GetItemsOnTable()
	var/list/ontable = list()
	for(var/atom/movable/AM in itemloc)
		if(!GetCost(AM.type))
			continue

		if(istype(AM, /obj/item/clothing))
			var/obj/item/clothing/C = AM
			if((C.durability / initial(C.durability)) * 100 < 80)
				say("[AM] is too broken for sale.","[AM] is too broken for sale.")
				continue

		if(istype(AM, /obj/item/weapon/storage/backpack) && AM.contents.len)
			say("Empty [AM] before selling.","Empty [AM] before selling.")
			continue

		if(istype(AM, /obj/item/ammo_box))
			var/obj/item/ammo_box/AB = AM
			if(AB.stored_ammo.len < AB.max_ammo)
				say("Fill [AB] before selling.","Fill [AB] before selling.")
				continue

		ontable += AM

	return ontable

/obj/machinery/stalker/sidormat/proc/GetOnTableCost(var/list/ontable)
	var/total_cost = 0

	for(var/obj/item/item_on_table in ontable)
		if(istype(item_on_table, /obj/item/stack))
			var/obj/item/stack/S = item_on_table
			if(S.amount != S.max_amount)
				continue
		var/cost = GetCost(item_on_table.type)
		if(cost)
			if(item_on_table.stackable)
				total_cost += cost * item_on_table.current_stack
			else
				total_cost += cost
	return total_cost

/obj/machinery/stalker/sidormat/proc/GetCost(itemtype)
	for(var/datum/data/stalker_equipment/se in real_sidormat_items)
		if(ispath(se.equipment_path, /obj/item/artefact))
			if(ispath(itemtype, se.equipment_path))
				return se.sale_price
		if(itemtype == se.equipment_path && se.can_be_bought)
			return se.sale_price
	return 0

/obj/machinery/stalker/sidormat/ex_act(severity, target)
	return


/obj/machinery/stalker/sidormat/proc/GiveCash(amount)
	var/balance = amount
	var/oldbalance = 0

	while(balance >= 50)
		oldbalance = balance

		var/to_give = round(balance / 5000)
		GiveBills(to_give, 5000)
		var/count = to_give * 5000
		balance -= count

		to_give = round(balance / 2000)
		GiveBills(to_give, 2000)
		count = to_give * 2000
		balance -= count

		to_give = round(balance / 1000)
		GiveBills(to_give, 1000)
		count = to_give * 1000
		balance -= count

		to_give = round(balance / 500)
		GiveBills(to_give, 500)
		count = to_give * 500
		balance -= count

		to_give = round(balance / 200)
		GiveBills(to_give, 200)
		count = to_give * 200
		balance -= count

		to_give = round(balance / 100)
		GiveBills(to_give, 100)
		count = to_give * 100
		balance -= count

		to_give = round(balance / 50)
		GiveBills(to_give, 50)
		count = to_give * 50
		balance -= count

		if(balance == oldbalance)
			break

/obj/machinery/stalker/sidormat/proc/GiveBills(amount, billtype)
	if(!amount)
		return

	var/obj/item/spacecash/bill = null
	switch(billtype)
		if(5000)
			bill = new /obj/item/spacecash/c5000(itemloc2)
		if(2000)
			bill = new /obj/item/spacecash/c2000(itemloc2)
		if(1000)
			bill = new /obj/item/spacecash/c1000(itemloc2)
		if(500)
			bill = new /obj/item/spacecash/c500(itemloc2)
		if(200)
			bill = new /obj/item/spacecash/c200(itemloc2)
		if(100)
			bill = new /obj/item/spacecash/c100(itemloc2)
		if(50)
			bill = new /obj/item/spacecash/c50(itemloc2)
	bill.current_stack = amount
