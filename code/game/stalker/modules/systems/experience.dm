#define MAX_EXPERIENCE 100			//Максимальный темпоральный опыт

/mob/
	var/temp_experience = 0

/mob/proc/give_exp(amount, action, limit = 0)
	if(istype(get_area(src), /area/stalker/kyrilka))
		return
	if(!client)
		return
	if(temp_experience > MAX_EXPERIENCE)
		return
	if(limit)
		if((client.loadout.exp_actions[action] <= limit) && (temp_experience <= (MAX_EXPERIENCE - amount)))
			temp_experience += amount
			client.loadout.exp_actions[action]++
			return
	else
		temp_experience += amount

/mob/proc/convert_temp_exp()
	if(!client)
		return
	client.loadout.experience += temp_experience
	if(client.loadout.experience >= MAX_EXPERIENCE * (client.loadout.level+1))
		client.loadout.level++
		client.loadout.experience -= MAX_EXPERIENCE * (client.loadout.level)
	temp_experience = 0



GLOBAL_LIST_EMPTY(achievements)
/world/New()
	..()
	initialize_achievements()


proc/initialize_achievements()
	for(var/A in subtypesof(/datum/achievement))
		GLOB.achievements += new A


/mob/proc/check_achievement(var/datum/achievement/A)
	if(!client)
		return 0

	if(!client.achievements || !client.achievements.len)
		return 0

	return client.achievements.Find(A.name)


/mob/proc/give_achievement(achievement)
	if(!isliving(src))
		return
	if(!client)
		return 0
	var/datum/achievement/A = null
	for(var/datum/achievement/AC in GLOB.achievements)
		if(AC.name == achievement)
			A = AC
			break

	if(!A || (A && check_achievement(A)))
		return 0

	client.achievements[A.name] = A
	var/msg = ""
	msg += client.select_lang("<span class='greenannounce'><i>Получено новое достижение!</i> [A.name_ru].</span><br>", "<span class='greenannounce'><i>You've got an achivement!</i> [A.name].</span><br>")
	msg += client.select_lang("<span class='info'>[A.desc_ru]</span>", "<span class='info'>[A.desc]</span>")
	src << msg
	client.loadout.experience += A.exp_given
	if(client.loadout.experience >= MAX_EXPERIENCE * (client.loadout.level+1))
		client.loadout.level++
		client.loadout.experience -= MAX_EXPERIENCE * (client.loadout.level)
	client.save_achievements()
	return 1

/client/proc/save_achievements()
	var/savefile/S = new("data/player_saves/[copytext(ckey,1,2)]/[ckey]/achievements.sav")
	if(!S)
		return 0

	S["achievements"] << achievements
	return 1

/client/proc/load_achivements()
	if(fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/achievements.sav"))
		var/savefile/S = new("data/player_saves/[copytext(ckey,1,2)]/[ckey]/achievements.sav")
		if(!S)
			return 0

		S["achievements"] >> achievements
		if(!achievements)
			achievements = list()
		return 1
	return 0

/*
	КАК РАБОТАЕТ

пишешь give_achievement("Test") в каком-либо месте и всё работает ебать
"Test" - это имя(не русское) датума ачивки

*/


/datum/achievement
	var/name = "Achievement"
	var/name_ru = "Достижение"
	var/desc = ""
	var/desc_ru = ""
	var/exp_given = 0


/datum/achievement/retarded


//DONE
/datum/achievement/retarded/soldaten //Должна даваться, если ты первым провоцируешь солдат, и они тебя убивают; не должна даваться, если тебя убили солдаты случайным попаданием
	name = "I swear, guys, I can kill 'em"
	name_ru = "Да отвечаю, мужики, я их завалю"
	desc = "You tried real hard. The thing is, russian soldiers try even harder."
	desc_ru = "Ты попытался. Проблема в том, что русские солдаты пытаются лучше."
	exp_given = 0

//DONE
/datum/achievement/retarded/welcome //Должна даваться, если умираешь в статичной воронке возле Лелева, окруженной гибсами
	name = "Welcome to the Zone"
	name_ru = "Добро пожаловать в Зону"
	desc = "Maybe you should look around next time you visit this place."
	desc_ru = "Может, стоит смотреть по сторонам в следующий раз."
	exp_given = 0

//DONE
/datum/achievement/retarded/rage //Должна даваться, если умираешь из-за выброса либо в последние 10 минут перед ним, имея полный темпоральный пул опыта
	name = "Stay calm, drink tea"
	name_ru = "Спокойствие, пьем чай"
	desc = "Bad luck. Situations like this happen to everybody, just don't let these moments frustrate you, king."
	desc_ru = "Не повезло. Подобное случается со всеми, главное - не позволяй подобным моментам расстраивать тебя, король."
	exp_given = 0


/datum/achievement/found

//DONE
/datum/achievement/found/artifact/common //Должна даваться, если персонаж подбирает первый артефакт
	name = "Odd garbage"
	name_ru = "Странный хлам"
	desc = "You have found an anomalous object - and it was weird."
	desc_ru = "Ты нашел аномальный объект - и он был необычайным."
	exp_given = 25

//DONE
/datum/achievement/found/artifact/rare //Должна даваться, если персонаж подбирает один из особо редких артефактов - их надо будет пометить отдельной переменной
	name = "Alien tool"
	name_ru = "Инструмент нелюдей"
	desc = "You have found an anomalous object - and it was interesting."
	desc_ru = "Ты нашел аномальный объект - и он был интересен."
	exp_given = 50

//DONE
/datum/achievement/found/artifact/unique //Должна даваться, если персонаж подбирает один из уникальных артефактов - их надо будет пометить отдельной переменной
	name = "Divine art"
	name_ru = "Божественное произведение"
	desc = "You have found an anomalous object - and it was beautiful."
	desc_ru = "Ты нашел аномальный объект - и он был прекрасен."
	exp_given = 100


/datum/achievement/saw

//DONE
/datum/achievement/saw/abnormaldeath //Должна даваться, если персонаж увидел смерть от аномалии - сгореть в огне жарки, испепелиться в тесле, разорваться в воронке, понемногу расплавиться под студнем
	name = "An awful show"
	name_ru = "Отвратительное зрелище"
	desc = "Truly, there's only one way out of the Zone."
	desc_ru = "Взаправду, есть лишь один путь из Зоны"
	exp_given = 25


/datum/achievement/saw/mutant //Должна даваться, если персонаж экзаминул/убил непохожего на дикого зверя мутанта - паука, ошибочку, всех кроме звероподобных
	name = "What was that?!"
	name_ru = "Что это было?!"
	desc = "You wish you never saw it."
	desc_ru = "Тебе хотелось бы никогда не видеть это."
	exp_given = 25

//DONE
/datum/achievement/saw/visibleanomaly //Должна даваться, если персонаж увидел явно аномальную вещь - лужу студня либо теслу
	name = "Display of power"
	name_ru = "Могущество напоказ"
	desc = "You wonder if science can find an explanation for this bullshit."
	desc_ru = "Интересно, есть ли у науки объяснение этой херне."
	exp_given = 25


/datum/achievement/done