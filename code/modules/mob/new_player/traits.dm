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
			return "���������"
		if("razin")
			return "������ �����"
		if("gus")
			return "�������� ����"
		if("obolon")
			return "�������"
		if("ohota")
			return "����� �������"

/proc/init_traits_subtypes(prototype, list/L)
	if(!istype(L))
		L = list()

	for(var/path in subtypesof(prototype))
		var/datum/traits/D = new path()

		L[D.name] = D

	return L

/datum/traits
	var/name = "Trait"				//��� ���������
	var/name_ru = "�����"			//������� ��� ���������
	var/info_ru = "Trait"			//���������� � ������ �� �������
	var/info = "Trait"				//���������� � ������
	var/str = 0						//���������� ����
	var/hlt = 0						//���������� ���������
	var/agi = 0						//���������� ��������
	var/int = 0						//���������� ���������
	var/smallarm_skill = 0			//���������� ����� ������ ������
	var/longarm_skill = 0			//���������� ����� �������� ������
	var/melee_skill = 0				//���������� ����� �������� ���
	var/heavy_skill = 0				//���������� ����� ��������� � ������������� � ������������ �������
	var/med_skill = 0				//���������� ����� ��������
	var/traps_skill = 0				//���������� ����� �������
	var/craft_skill = 0				//���������� ����� ��������� � ������ � �����������

/*
	������ ��� ������ ��������� ����� ������

/datum/traits/[�����]/[��������_������]
	name = "�������� ������"
	info = "������ �����"
	str = 5
	agi = 2
	int = -3
	rifle_skill = 4
	shotgun_skill = -2
��� ���� ��������� ��� � ������ [�����] �������� ������, ������� ��������� ������ 5 ����, 2 �������� � ����������� ������ �������� ���������� �� 4
������, �� ��� �� ������� 3 ���������� � �������� ����� �������� ����������� �� 2

//////////////////////////////////////////////

[�����] - ��� ��� ������, ����� �� 4:
	education - �����������
	profession - ���������
	lifestyle - ����� �����
	trait - �������������� �����

[��������_������] - ��������� ��������, ������ �������� ������ _
�� ����� ���� ������� ����� ��� �����, ������������ �������� ����� � "name"
������ ���������� ����� [��������_������] ��������������� "name"

������������� ���� � ���, ��������, "name" = "School Middle", �� [��������_������] ������ ���� [shcool_middle]
�� ��, ������� [] � ����� ���� ���� �� ������, ��� ��� ������ ����� �������� ��������.

������� "�" ��� � ��� � �� ��������
*/
/datum/traits/education/student
	name = "Diligent student"
	name_ru = "��������� �������"
	info = "You have studied well, gaining knowledge of many subjects, although you aren't very proficient in anything specific. Maybe some of that knowledge will be useful in Zone."
	info_ru = "�� �������� ������, ������� ����� �� ����� �����������, �� ������������� ������, ������� ������ ���� ������ ���� ���������� � �����. ��������, ��������� �� ��� ���������� � ������."
	int = 1

/*/datum/traits/education/techie
	name = "Erudite technician"
	name_ru = "������������� �������"
	info = "You always had an opinion that classical education sucks. Well, now is your chance to proof that your knowledge of engineering and physics has it's uses."
	info_ru = "�� ������ �������, ��� ����������� - ����������� � ������ �������. ��� ��, ������ ��� ����� ���� ���������, ����� �� ������� � ���� �������� �������� � ������ ����, ���� ������������ ��� ��������."
	craft_skill = 3
	traps_skill = 1*/

/datum/traits/education/medic
	name = "Educated medic"
	name_ru = "��������� �������"
	info = "Your studies were more specific - you have impressive skills of swining your scalpel around as well as using it for surgeries."
	info_ru = "���� ����� ���� ����� ���������������� - � ���� �������� ������ �������� ���������� � �����, �� �� �� ����� �������� � ������ ���������."
	med_skill = 3
	melee_skill = 1

/datum/traits/education/army
	name = "Military college"
	name_ru = "������� �������"
	info = "You have spent your youth in the military college, going through the basic training and learning more about the modern weaponary. You don't have high combat skills, but that's better than nothing."
	info_ru = "�� ������ ������ � ������� ��������, ������� ��������� ���������� � ��������� � ������������ ��������� ������. ��� ���� ���� ����� ������� �� ������ �������."
	longarm_skill = 1
	smallarm_skill = 1

/datum/traits/education/badboy
	name = "Young recidivist"
	name_ru = "���� ����������"
	info = "Your youth was full of crime. The experience of getting arrested and doing illegal business made you stronger and taught how to fight for yourself, but it wasn't the best way to spend your young years.."
	info_ru = "������ �� ������ �� ������� �������������� � �������, ��������, ���� ������� � ������� ��� ������������������. ���� ���� ������� ������� ����, ��, ��������, ��� �� ������ �� ���������."
	str = 1
	melee_skill = 2

/datum/traits/education/country
	name = "Countryside inhabitant"
	name_ru = "�������������� ������"
	info = "There never were any colleges or universities in your countryside, so you had to spend your time with parents growing crops and having premature sex in the barn. You don't have any special knowledge, but your body is strong and tough."
	info_ru = "� ����� ������ ��������� ������� � �� ���� ������� ��������� ��� �������������, ��� ��� ��������� �� ������ � ������ � �������� � �����. �� �� ������ ������ ������, �� ���� �������� ������, ��� � ���������."
	str = 1
	hlt = 1

/datum/traits/profession/hobo
	name = "Hobo"
	name_ru = "�������"
	info = "You were specifically unlucky - you didn't manage to find a job and lost your house. You became a vagabond and slept outside a lot. On the other hand, you gained a lot of street wisdom and had to participate in many fist fights, which is, kind of, wise too."
	info_ru = "���� ����� �� ������� - �� �� ������ �� ����� ������, �� � ������� ��� ��-�� �������. �� ����� ����������� � ���� ��� �������� �����. � ������ �������, ���� ������� �������� ������ ����� � ������ ����� ������ ���������, � ������� ����� ����� ������� ���� ���� � ������ ������ �������� �����."
	int = 1
	hlt = 1
	melee_skill = 2
	med_skill = 1
	craft_skill = 1

/datum/traits/profession/scientist
	name = "Scientist"
	name_ru = "������"
	info = "You managed to find a good job at the scientific enterprise. Even if you had no actual college studies before, you got enough knowledge beaten into your head during that time."
	info_ru = "�� ���������� - ����, ���� � ��� �� ���� �������� �����������, ��� �������� - �� ������ � ������� ����� ������������. ����� ���� ��������� ������ �� ������ ������� ��������� ��������, ������� ������ ����� �����������, ���� �� ������� ���������� � ������ ��������� ������ ���������� � ������. � ��� ����� ����� �������� ����������� ���������, ��������� ���������������� ������ - �����, ��� ������������ � ����������."
	int = 2
	med_skill = 1
	craft_skill = 1


/datum/traits/profession/grunt
	name = "Soldier"
	name_ru = "������"
	info = "No matter if you were a contract combatant, an ukrainian novorussian conflict veteran or a soldier of any other army, you had your experience in the combat zones. You know how to use war weapons - pistols, long arms and even heavier guns like grenade launchers."
	info_ru = "���� �� ��������-������������� ��� ��������� ����������� ���������, ���� ����������� � ������ ������� �����. � ���� ������� ���� � ������������� �������� ������ - ��������, ���������� � ���� ����� ������ ����� ����� ��������� � ������������."
	smallarm_skill = 1
	longarm_skill = 2
	heavy_skill = 2
	melee_skill = 2

/datum/traits/profession/police
	name = "Policeman"
	name_ru = "�����������"
	info = "The training you went through taught you how to use small arms, pistols and non-lethal melee for incapacitating the criminals and rioters. You were also taught a little on how to give medical aid to others."
	info_ru = "����������, ������� �� �������, ��������������� ���� ��������� ������������ ��������������� ������������� ������������ � �����������, � ����� ������������� ����������������� ������, ����������� ��� ��������� �������. ���� ������ ����� ������������, ���� �� ����� �������, ��� ����������� ������� ����������."
	smallarm_skill = 3
	melee_skill = 2
	med_skill = 2

/datum/traits/profession/criminal
	name = "Criminal"
	name_ru = "����������"
	info = "You spent most of your life either behind the bars imprisoned, or commiting crimes and robberies. You've had experience with pistols and melee weapons specifically, but you also have some skills with shotguns and small arms."
	info_ru = "������� ����� �������� ����� �� ������ ���� �� ��������, ���� �� ��������� � ����������. ��� ����������� ���������� � ��������, ��������������� � �������������� ������� ����� ���������� ��� ��, �� �� �������� ������� �� �� ������."
	smallarm_skill = 2
	longarm_skill = 1
	melee_skill = 4

/datum/traits/lifestyle/normal
	name = "Average"
	name_ru = "��������������"
	info = "You're an average man. A lot of people are jealous of your balanced lifestyle."
	info_ru = "�� - ����� ������� �������, ��� ������ ����������� ��� �����������. ������ ���������� ������ ����������������� ������ �����."

/datum/traits/lifestyle/lazy
	name = "Lazy"
	name_ru = "�������"
	info = "You never liked physical activities, preferring to surf the internet instead of doing sports. You are slightly out of shape, but some of the knowledge you gained oughta help you..."
	info_ru = "�� ������� �� ����� ���������� �������, ������ ������� ������������ ���������. �� ������� ����� �� �����, ��, �� ������� ����, ����� ����������� ������ ���������� � ����."
	str = -1
	hlt = -1
	int = 1

/datum/traits/lifestyle/intelligent
	name = "Intellectual"
	name_ru = "�����������"
	info = "You focused heavily on the intellectual improvement since your childhood. It's hard to say if your weakened body is worth it, but you really are smart."
	info_ru = "� ������ ������� �� ����������� ���������� �������� �����������. ������ �������, ������ �� ��� ���������� ��������, ��������� ����� ������� �����, �� �� ������ ���������."
	str = -2
	int = 2
	agi = -1

/datum/traits/lifestyle/athletic
	name = "Athletic"
	name_ru = "�����"
	info = "Doing sports and eating healthy made you into a nice, fit man. Sadly enough, you never had enough time to improve yourself mentally."
	info_ru = "�������� �� ����� � ���������� ������� �������� ���� ��������. ���� ������, ��� ������ ������������ �� ������ �������� �������."
	str = 1
	hlt = 1
	int = -1

/datum/traits/lifestyle/bodybuilder
	name = "Bobybuilder"
	name_ru = "����������"
	info = "Dangerous synthetic stimulators and constant training turned you into a real fuckin' terminator! Although the amount of drugs you took made your muscles stiff and slow, worsening your agility."
	info_ru = "������� ������������� ����������� � ���������� ���������� ���������� ���� � ���������� �����������! ������, ����� ���� ��������� ��������� ���� ������� �������, ������� ������� � �������� ����. �� ��� �� ��� ����� ���?"
	str = 4
	agi = -2

/datum/traits/lifestyle/acrobatic
	name = "Acrobatic"
	name_ru = "�������"
	info = "You spent many years practicing the different exercises to improve your dexterity and flexibility. You are very agile, but your strength and health are significantly worse than of any other man."
	info_ru = "����������� ���������� �� �������� � ����������� ������ ���� ��������, �� ���� �� ���� ����� �����, ��� ������ �������."
	str = -2
	hlt = -2
	agi = 2

/datum/traits/trait/muscular
	name = "Muscular"
	name_ru = "�����"
	info = "You are stronk, yes. You can feel your muscles growing stronker."
	info_ru = "���� ���������� ���������� �����, ��� � �����������."
	str = 2

/datum/traits/trait/sturdy
	name = "Sturdy"
	name_ru = "������"
	info = "Your endurance is higher than average."
	info_ru = "���� �������� ������, ��� � �����������."
	hlt = 2

/datum/traits/trait/smart
	name = "Smart"
	name_ru = "�����"
	info = "Your smarts are sharper than average."
	info_ru = "���� �� ������, ��� � �����������."
	int = 1

/datum/traits/trait/agile
	name = "Gymnast"
	name_ru = "�������"
	info = "Your body is more agile than average."
	info_ru = "���� ���� ���������, ��� � �����������."
	agi = 1

/datum/traits/trait/medex
	name = "Anatomy expert"
	name_ru = "������� � ��������"
	info = "From different sources, you gained knowledge of the human anatomy. Your medical and melee skills are improved."
	info_ru = "�� ��������� ���������� �� ������ �������� ����� �� ���������� ������������� ����. ���� ������ �������� � �������� ��� ��������."
	med_skill = 2
	melee_skill = 2

/*/datum/traits/trait/mechanic
	name = "Experienced mechanic"
	name_ru = "������� �������"
	info = "You spent many years studying mechanics. Your skills with mechanics and technical devices are improved."
	info_ru = "������������ ����� ����� ����� ���� ��������� � ���������� ���� �� ���������. ���� ������ ������ � ����������� ��������."
	craft_skill = 2
	traps_skill = 2*/

/datum/traits/trait/gunnut
	name = "Gun nut"
	name_ru = "����� ������"
	info = "You have experience with different firearms, gained from the shooting clubs and simulators. You have slightly improved skills with most guns."
	info_ru = "�� ������ ������ ������� � ��������� ���������� ������. � ���� ���� ��������� ���� � ������� ������ ������."
	smallarm_skill = 1
	longarm_skill = 1

/datum/traits/trait/heavyhand
	name = "Heavy hand"
	name_ru = "�������"
	info = "You are stronger and have greater skills in melee combat."
	info_ru = "�� �����, � ����� ������ � ������� ����."
	melee_skill = 2
	str = 1

/datum/traits/trait/hunter
	name = "Hunter"
	name_ru = "�������"
	info = "You have a lot of hunting experience. Your skills with shotguns are improved, as well as your knowledge of traps."
	info_ru = "�� ����� �������� � ��������� ����� � ������ ������� ���� � ����������� � �������. ����� �� ������� ������������ � ��������."
	longarm_skill = 1
	traps_skill = 2

/datum/traits/trait/pistoleer
	name = "Pistoleer"
	name_ru = "����������"
	info = "You are some kind of a soy kid, thus you really don't like weapons heavier than a handgun. Your skill with pistols is improved."
	info_ru = "�� ����������� �������� �� ������������� ����������, ����� ���������� ������. ���� ����� � ����������� �������."
	smallarm_skill = 2