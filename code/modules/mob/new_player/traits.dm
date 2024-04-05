GLOBAL_LIST_EMPTY(education_list)

GLOBAL_LIST_EMPTY(profession_list)

GLOBAL_LIST_EMPTY(lifestyle_list)

GLOBAL_LIST_EMPTY(trait_list)

GLOBAL_LIST_INIT(beer, list("random", "razin", "gus", "obolon", "ohota"))

/proc/get_education_runame(education)
	var/datum/traits/education/E = GLOB.education_list[education]
	return sanitize_russian(E.name_ru, 1)

/proc/get_profession_runame(profession)
	var/datum/traits/profession/P = GLOB.profession_list[profession]
	return sanitize_russian(P.name_ru, 1)

/proc/get_lifestyle_runame(lifestyle)
	var/datum/traits/lifestyle/L = GLOB.lifestyle_list[lifestyle]
	return sanitize_russian(L.name_ru, 1)

/proc/get_trait_runame(trait)
	var/datum/traits/trait/T = GLOB.trait_list[trait]
	return sanitize_russian(T.name_ru, 1)

/proc/get_beer_runame(custom_beer)
	switch(custom_beer)
		if("random")
			return "случайное"
		if("razin")
			return "Степан Разин"
		if("gus")
			return "Жатецкий Гусь"
		if("obolon")
			return "Оболонь"
		if("ohota")
			return "Охота крепкое"

/proc/init_traits_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()

	for(var/path in subtypesof(prototype))
		var/datum/traits/D = new path()

		L[D.name] = D

	return L

/datum/traits
	var/name = "Trait"				//Имя профессии
	var/name_ru = "Аллах"			//Русское имя профессии
	var/info_ru = "Trait"			//Информация о трейте на русском
	var/info = "Trait"				//Информация о трейте
	var/str = 0						//Добавочная сила
	var/hlt = 0						//Добавочная живучесть
	var/agi = 0						//Добавочная ловкость
	var/int = 0						//Добавочный интеллект
	var/smallarm_skill = 0			//Добавочный навык малого оружия
	var/longarm_skill = 0			//Добавочный навык длинного оружия
	var/melee_skill = 0				//Добавочный навык ближнего боя
	var/heavy_skill = 0				//Добавочный навык обращения с гранатометами и экзотическим оружием
	var/med_skill = 0				//Добавочный навык медицины
	var/traps_skill = 0				//Добавочный навык ловушек
	var/craft_skill = 0				//Добавочный навык крафтинга и работы с механизмами

/*
	Пример как должен выглядеть датум трейта

/datum/traits/[трейт]/[название_трейта]
	name = "Название Трейта"
	info = "Тестим хуйню"
	str = 5
	agi = 2
	int = -3
	rifle_skill = 4
	shotgun_skill = -2
Код выше добавляет нам в выборе [трейт] Название Трейта, который добавляет игроку 5 силы, 2 ловкости и увеличивает умение владения винтовками на 4
Однако, он так же отнимет 3 интеллекта и понижает навык владения дробовиками на 2

//////////////////////////////////////////////

[трейт] - это тип трейта, всего их 4:
	education - образование
	profession - профессия
	lifestyle - образ жизни
	trait - дополнительный трейт

[название_трейта] - очевидное название, вместо пробелов ставим _
На самом деле плевать каким оно будет, отображаемое название будет в "name"
Однако желательно чтобы [название_трейта] соответствовало "name"

Следовательно если у нас, например, "name" = "School Middle", то [название_трейта] должно быть [shcool_middle]
Ах да, никаких [] в самом коде быть не должно, тут это просто чтобы обратить внимание.

буковка "я" это у нас я не забываем
*/
/datum/traits/education/student
	name = "Diligent student"
	name_ru = "Прилежный студент"
	info = "You have studied well, gaining knowledge of many subjects, although you aren't very proficient in anything specific. Maybe some of that knowledge will be useful in Zone."
	info_ru = "Ты прилежно учился, получив пласт не очень углубленных, но разнообразных знаний, которые должны были помочь тебе устроиться в жизни. Возможно, некоторые из них пригодятся и сейчас."
	int = 1

/*/datum/traits/education/techie
	name = "Erudite technician"
	name_ru = "Эрудированный технарь"
	info = "You always had an opinion that classical education sucks. Well, now is your chance to proof that your knowledge of engineering and physics has it's uses."
	info_ru = "Вы всегда считали, что гуманитарии - бесполезные и глупые невежды. Что же, теперь вам выпал шанс проверить, будет ли полезно в Зоне черчение чертежей и знание того, куда подсоединять тот проводок."
	craft_skill = 3
	traps_skill = 1*/

/datum/traits/education/medic
	name = "Educated medic"
	name_ru = "Обученный санитар"
	info = "Your studies were more specific - you have impressive skills of swining your scalpel around as well as using it for surgeries."
	info_ru = "Твоя учеба была более специализирована - у тебя неплохие навыки владения скальпелем и нитью, но ты не особо посвящен в другие искусства."
	med_skill = 3
	melee_skill = 1

/datum/traits/education/army
	name = "Military college"
	name_ru = "Военное училище"
	info = "You have spent your youth in the military college, going through the basic training and learning more about the modern weaponary. You don't have high combat skills, but that's better than nothing."
	info_ru = "Ты провел юность в военной академии, получая несложные тренировки и знакомясь с современными образцами оружия. Это дало тебе самые базовые из боевых навыков."
	longarm_skill = 1
	smallarm_skill = 1

/datum/traits/education/badboy
	name = "Young recidivist"
	name_ru = "Юный рецидивист"
	info = "Your youth was full of crime. The experience of getting arrested and doing illegal business made you stronger and taught how to fight for yourself, but it wasn't the best way to spend your young years.."
	info_ru = "Юность ты провел за мелкими преступлениями и кражами, возможно, даже залетев в колонию для несовершеннолетних. Этот опыт немного закалил тебя, но, возможно, был не лучшим из возможных."
	str = 1
	melee_skill = 2

/datum/traits/education/country
	name = "Countryside inhabitant"
	name_ru = "Провинциальный парень"
	info = "There never were any colleges or universities in your countryside, so you had to spend your time with parents growing crops and having premature sex in the barn. You don't have any special knowledge, but your body is strong and tough."
	info_ru = "В твоей родной провинции никогда и не было никаких колледжей или университетов, так что молодость ты провел с семьей в огородах и полях. Ты не имеешь особых знаний, но твое здоровье крепче, чем у остальных."
	str = 1
	hlt = 1

/datum/traits/profession/hobo
	name = "Hobo"
	name_ru = "Бродяга"
	info = "You were specifically unlucky - you didn't manage to find a job and lost your house. You became a vagabond and slept outside a lot. On the other hand, you gained a lot of street wisdom and had to participate in many fist fights, which is, kind of, wise too."
	info_ru = "Тебе особо не повезло - ты не только не нашел работу, но и потерял дом из-за неуплат. Ты много бродяжничал и спал под открытым небом. С другой стороны, тебе удалось повидать разные места и узнать много мелких хитростей, а тяжелый образ жизни закалил твое тело и научил многим секретам жизни."
	int = 1
	hlt = 1
	melee_skill = 2
	med_skill = 1
	craft_skill = 1

/datum/traits/profession/scientist
	name = "Scientist"
	name_ru = "Ученый"
	info = "You managed to find a good job at the scientific enterprise. Even if you had no actual college studies before, you got enough knowledge beaten into your head during that time."
	info_ru = "Вы устроились - либо, если у вас не было должного образования, ВАС устроили - на работу в научную сферу деятельности. Здесь вашу черепушку забили до отвала разными полезными знаниями, которые теперь могут пригодиться, плюс вы неплохо заработали и имеете несколько лучшую экипировку в начале. В эту черту также включено большинство профессий, требующих интеллектуальной работы - такие, как библиотекари и профессора."
	int = 2
	med_skill = 1
	craft_skill = 1


/datum/traits/profession/grunt
	name = "Soldier"
	name_ru = "Солдат"
	info = "No matter if you were a contract combatant, an ukrainian novorussian conflict veteran or a soldier of any other army, you had your experience in the combat zones. You know how to use war weapons - pistols, long arms and even heavier guns like grenade launchers."
	info_ru = "Будь ты солдатом-контрактником или ветераном донбасского конфликта, тебя забрасывало в разные горячие точки. У тебя большой опыт в использовании военного оружия - винтовок, пистолетов и даже более редких вещей вроде пулеметов и гранатометов."
	smallarm_skill = 1
	longarm_skill = 2
	heavy_skill = 2
	melee_skill = 2

/datum/traits/profession/police
	name = "Policeman"
	name_ru = "Полицейский"
	info = "The training you went through taught you how to use small arms, pistols and non-lethal melee for incapacitating the criminals and rioters. You were also taught a little on how to give medical aid to others."
	info_ru = "Тренировки, которые ты получил, преимущественно были посвящену нелетальному противодействию невооруженным преступникам и бунтовщикам, а также использованию короткоствольного оружия, подходящего для городских условий. Твои знания более универсальны, хотя не столь глубоки, как полноценная военная подготовка."
	smallarm_skill = 3
	melee_skill = 2
	med_skill = 2

/datum/traits/profession/criminal
	name = "Criminal"
	name_ru = "Преступник"
	info = "You spent most of your life either behind the bars imprisoned, or commiting crimes and robberies. You've had experience with pistols and melee weapons specifically, but you also have some skills with shotguns and small arms."
	info_ru = "Большую часть прожитой жизни ты провел либо за решеткой, либо за грабежами и воровством. Вам приходилось обращаться с холодным, гладкоствольным и малогабаритным оружием вроде дробовиков или ПП, но на опытного стрелка вы не тянете."
	smallarm_skill = 2
	longarm_skill = 1
	melee_skill = 4

/datum/traits/lifestyle/normal
	name = "Average"
	name_ru = "Невыделяющийся"
	info = "You're an average man. A lot of people are jealous of your balanced lifestyle."
	info_ru = "Ты - самый обычный человек, без особых недостатков или преимуществ. Многие позавидуют вашему сбалансированному образу жизни."

/datum/traits/lifestyle/lazy
	name = "Lazy"
	name_ru = "Ленивец"
	info = "You never liked physical activities, preferring to surf the internet instead of doing sports. You are slightly out of shape, but some of the knowledge you gained oughta help you..."
	info_ru = "Ты никогда не любил заниматься спортом, взамен отдавая предпочтение интернету. Ты немного вышел из формы, но, по крайней мере, часть накопленных знаний пригодится в Зоне."
	str = -1
	hlt = -1
	int = 1

/datum/traits/lifestyle/intelligent
	name = "Intellectual"
	name_ru = "Интеллигент"
	info = "You focused heavily on the intellectual improvement since your childhood. It's hard to say if your weakened body is worth it, but you really are smart."
	info_ru = "С самого детства ты предпочитал умственное развитие физическому. Сложно сказать, стоило ли это физической слабости, вызванной таким образом жизни, но ты весьма образован."
	str = -2
	int = 2
	agi = -1

/datum/traits/lifestyle/athletic
	name = "Athletic"
	name_ru = "Атлет"
	info = "Doing sports and eating healthy made you into a nice, fit man. Sadly enough, you never had enough time to improve yourself mentally."
	info_ru = "Пробежки по утрам и регулярная зарядка закалили твое здоровье. Жаль только, что своему саморазвитию ты уделял маловато времени."
	str = 1
	hlt = 1
	int = -1

/datum/traits/lifestyle/bodybuilder
	name = "Bobybuilder"
	name_ru = "Культурист"
	info = "Dangerous synthetic stimulators and constant training turned you into a real fuckin' terminator! Although the amount of drugs you took made your muscles stiff and slow, worsening your agility."
	info_ru = "Опасные синтетические стимуляторы и постоянные тренировки превратили тебя в настоящего терминатора! Правда, такие дозы стероидов повредили вашу нервную систему, ухудшив реакцию и гибкость мышц. Но так ли оно нужно вам?"
	str = 4
	agi = -2

/datum/traits/lifestyle/acrobatic
	name = "Acrobatic"
	name_ru = "Акробат"
	info = "You spent many years practicing the different exercises to improve your dexterity and flexibility. You are very agile, but your strength and health are significantly worse than of any other man."
	info_ru = "Многолетние упражнения на гибкость и подвижность стоили тебе здоровья, но зато ты куда более ловок, чем прочие невежды."
	str = -2
	hlt = -2
	agi = 2

/datum/traits/trait/muscular
	name = "Muscular"
	name_ru = "Силач"
	info = "You are stronk, yes. You can feel your muscles growing stronker."
	info_ru = "Твоя физическая подготовка лучше, чем у большинства."
	str = 2

/datum/traits/trait/sturdy
	name = "Sturdy"
	name_ru = "Живчик"
	info = "Your endurance is higher than average."
	info_ru = "Твое здоровье крепче, чем у большинства."
	hlt = 2

/datum/traits/trait/smart
	name = "Smart"
	name_ru = "Умник"
	info = "Your smarts are sharper than average."
	info_ru = "Твой ум острее, чем у большинства."
	int = 1

/datum/traits/trait/agile
	name = "Gymnast"
	name_ru = "Гимнаст"
	info = "Your body is more agile than average."
	info_ru = "Твое тело подвижнее, чем у большинства."
	agi = 1

/datum/traits/trait/medex
	name = "Anatomy expert"
	name_ru = "Эксперт в анатомии"
	info = "From different sources, you gained knowledge of the human anatomy. Your medical and melee skills are improved."
	info_ru = "Из различных источников ты знаешь довольно много об устройстве человеческого тела. Твои навыки медицины и ближнего боя повышены."
	med_skill = 2
	melee_skill = 2

/*/datum/traits/trait/mechanic
	name = "Experienced mechanic"
	name_ru = "Опытный механик"
	info = "You spent many years studying mechanics. Your skills with mechanics and technical devices are improved."
	info_ru = "Значительная часть твоей жизни была потрачена в мастерской либо за чертежами. Твои навыки работы с механизмами повышены."
	craft_skill = 2
	traps_skill = 2*/

/datum/traits/trait/gunnut
	name = "Gun nut"
	name_ru = "Фанат оружия"
	info = "You have experience with different firearms, gained from the shooting clubs and simulators. You have slightly improved skills with most guns."
	info_ru = "Ты провел немало времени в различных стрелковых клубах. У тебя есть небольшой опыт с большей частью оружия."
	smallarm_skill = 1
	longarm_skill = 1

/datum/traits/trait/heavyhand
	name = "Heavy hand"
	name_ru = "Громила"
	info = "You are stronger and have greater skills in melee combat."
	info_ru = "Ты силен, и лучше знаком с ближним боем."
	melee_skill = 2
	str = 1

/datum/traits/trait/hunter
	name = "Hunter"
	name_ru = "Охотник"
	info = "You have a lot of hunting experience. Your skills with shotguns are improved, as well as your knowledge of traps."
	info_ru = "Ты много охотился в свободное время и имеешь большой опыт с дробовиками и ружьями. Также ты немного разбираешься в ловушках."
	longarm_skill = 1
	traps_skill = 2

/datum/traits/trait/pistoleer
	name = "Pistoleer"
	name_ru = "Пистольеро"
	info = "You are some kind of a soy kid, thus you really don't like weapons heavier than a handgun. Your skill with pistols is improved."
	info_ru = "По собственным причинам ты предпочитаешь компактное, легко скрываемое оружие. Твой навык с пистолетами повышен."
	smallarm_skill = 2