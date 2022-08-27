
SUBSYSTEM_DEF(text)
	name = "Text"
	flags = SS_NO_FIRE

	var/list/areas_entrances = list()

	var/pre_rained = 0
	var/pre_blowout_1 = 0
	var/pre_blowout_2 = 0

	var/ON = 1

/datum/controller/subsystem/text/Initialize()
	if(!initialized)
		for(var/area/A in world)
			var/list/clients = new
			areas_entrances[A] += clients
		initialized = TRUE

/datum/controller/subsystem/text/proc/pre_rain()
	if(!ON)
		return
	pre_rained = 1
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H.client)
			if(H.int >= 13)
				spawn(rand(0, 100))
					if(istype(get_area(H), /area/stalker/blowout/outdoor))
						H << sanitize_russian(H.client.select_lang(pick(list("<i>�� ����... ����� ������ ������ ������ ����������? ����� ������ �� ���� ������� - � �� ������ ����. ��� ���� ���������� ����? ��� �� �� �� ����, ������, ���������� ������.</i>","<i>��, ������� ��� ���� ��� ��������... ������ ����� ������ ����, ������ - ��� ���� � �����. ��� ��� � �������, ���������. ��, ������ ������, ������ ��� �� ������������� �������...</i>")),
																pick(list("",""))))

/datum/controller/subsystem/text/proc/rain_start()
	if(!ON)
		return
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H.client)
			spawn(rand(0, 100))
				var/message
				if(istype(get_area(H), /area/stalker/blowout/outdoor))
					if(H.hlt < 10)
						message =  sanitize_russian(H.client.select_lang(pick(list("�� �������! ���� ������ ������... ��� � ������������ �������.","������ �����... �������, �� �� ��������� �����. ���� ������� � ���� - ����, � ������� �� ����� ����� ����� � ������ ��������.")),
																pick(list("",""))))
					if(H.str < 10)
						message =  sanitize_russian(H.client.select_lang(pick(list("����� ��� ������ ���������... ���� ������ ������� ������� �����, ������ ����������. �� ��� � ��������. ��-��!","����� ��� �� �������, ��� ����� ��� ����� ������� ����.")),
																pick(list("",""))))
					if(H.int >= 13)
						message =  sanitize_russian(H.client.select_lang(pick(list("�-��, �� � �������. ������ �������� ������� ����� �������... ����� ��� ������ �����, ��������, ������� ����.","���� �� �� ���� �����, ����� �. ���� ���! � ����� ������ ����������� ������� �������� �� ���������. ����� ���� �����, ��������, ������ ��������.")),
																pick(list("",""))))
					if(!message)
						message = sanitize_russian(H.client.select_lang(pick(list("����� ������� � ���� ������ �������... ������ ��������� ������, ��� � ���� �� ������ ����... ����, ������ ���� - ������ �� ���.","����� �, �����, ���� ��� �����? �� �������! �� ��� ��� ����. � ��������� �� ����� ��� ���������� ����������...")),
															pick(list("",""))))
				else
					message =  sanitize_russian(H.client.select_lang(pick(list("������, ����� ������ �������. �� ����� �������� ��� ������, ��� ���� ������� � ������� ������ � �����.","������� �� ����� ����. ����� ������� ����� ������� ���������, ��� ����������� ����� ��� ���... �� ������� ����� �������� �������.")),
															pick(list("",""))))
				H << "<i>[message]</i>"

/datum/controller/subsystem/text/proc/pre_blowout()
	if(!ON)
		return
	if(!pre_blowout_1)
		for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
			if(H.client)
				if(H.rolld(dice6(3)+2,H.int))
					spawn(rand(0,100))
						H << sanitize_russian(H.client.select_lang(pick(list("���-�� � ����� ����� ��������� ���...","���-�� ���������� ������, �� ����������...")),
																pick(list("",""))))
		pre_blowout_1 = 1
		return
	if(!pre_blowout_2)
		for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
			if(H.client)
				if(H.rolld(dice6(3),H.int))
					spawn(rand(0,100))
						H << sanitize_russian(H.client.select_lang(pick(list("��, ������� � ��. ������, ������ ��������...","�������� �����. �� �������� ��������, ���� ���.")),
																pick(list("",""))))
		pre_blowout_2 = 1


/area/
	var/list/enter_message = list("Morning" = list("Hello morning dude"),
									"Day" = list("Hello day dude"),
									"Evening" = list("Hello evening dude"),
									"Night" = list("Hello night dude"))
	var/list/enter_message_ru = list("Morning" = list("������� �������� �����"),
									"Day" = list("������� ������� �����"),
									"Evening" = list("������� �������� �����"),
									"Night" = list("������� ������ �����"))

/area/stalker
	enter_message_ru = list("Morning" = list(""),
						"Day" = list(""),
						"Evening" = list(""),
						"Night" = list("")
						)
	enter_message = list("Morning" = list(""),
						"Day" = list(""),
						"Evening" = list(""),
						"Night" = list("")
						)

/area/Entered(atom/A)
	if(!SStext.ON)
		return ..()
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(!H.client)
			return
		if(!SStext.areas_entrances[src].Find(H.client))
			var/msg
			switch(SSsunlighting.current_step)
				if(STEP_MORNING)
					msg += H.client.select_lang(pick(enter_message_ru["Morning"]),pick(enter_message["Morning"]))
				if(STEP_DAY)
					msg += H.client.select_lang(pick(enter_message_ru["Day"]),pick(enter_message["Day"]))
				if(STEP_EVENING)
					msg += H.client.select_lang(pick(enter_message_ru["Evening"]),pick(enter_message["Evening"]))
				if(STEP_DAY)
					msg += H.client.select_lang(pick(enter_message_ru["Night"]),pick(enter_message["Night"]))
			if(msg)
				H << "<i>[msg]</i>"
			SStext.areas_entrances[src].Add(H.client)
	..()


/*
	enter_message = list("Morning" = list(""),
						"Day" = list(""),
						"Evening" = list(""),
						"Night" = list(""))

	enter_message_ru = list("Morning" = list(""),
							"Day" = list(""),
							"Evening" = list(""),
							"Night" = list(""))

	ambient_music = list()
*/

/area/stalker/blowout/buildings/factory/administrative

/area/stalker/blowout/buildings/factory/garages

/area/stalker/blowout/buildings/factory/cargo

/area/stalker/blowout/buildings/factory/production

/area/stalker/blowout/buildings/factory/kpp



/area/stalker/blowout/buildings/lelev/hangar

/area/stalker/blowout/buildings/lelev/administrative

/area/stalker/blowout/buildings/lelev/house



/area/stalker/blowout/buildings/farm/south

/area/stalker/blowout/buildings/farm/north

/area/stalker/blowout/buildings/farm/utility



/area/stalker/blowout/buildings/wild/house


/area/stalker/blowout/outdoor
	ambient_music = list('sound/stalker/ambience/forest1.ogg', 'sound/stalker/ambience/forest2.ogg', 'sound/stalker/ambience/forest3.ogg', 'sound/stalker/ambience/forest4.ogg')


/area/stalker/blowout/outdoor/prezone
	enter_message_ru = list("Morning" = list("��� � ������ ����������. ����� ���� ������� ���������, � �� ��� �����, ��� � ����, ����� ������� � �������. ������ ����� ����, � ������ ����������� ����� ������������� �������� � ����� �����. ������ ���� ������ ���������? ����, ���� ������ ������."),
						"Day" = list("���������, ��������� ������� ����. ������ ������ ������, �������������, �� ����������� ������� ������. ����� � ������ ����� �������� �����, � ���-�� �������. � ������ �����... ������� � ��� ����� �� �����."),
						"Evening" = list("�������� - ������� �� ����� ����� ��� �������. � � ���� �������� ��������� ����������, �� ���� ����� ���� ��������� ����������� - ������� ������������������ ��, ��������� � ����� � ����. ������ ���������� ������ ����� ��� �����-�� ������ ���������... ����� ������ ������? ���, ��������. ���� �� ���������."),
						"Night" = list("������ �������� ���� ������� ������ ����. � ���� ������������� ����� - �������������, ���������. ���, ������, �� ��������, ��� �� �������� �� ������ ������, ��� �����, ��� ����������� ������ �����������, ���� � ������, ������. ����� � ��� � ��������� ��� �������� �����? ������ ���� ����� ���������� ��, ���� �� �������, ����� � ��� ��������� ������.")
						)
	enter_message = list("Morning" = list("The sun is up once again. Soon, it will become slightly warmer - a very pleasant change, considering how uncomfortable it is to stay outside during a night. The winds have calmed down, and the sweet scent of decaying nature and wet earth replaced it. Was it even worth the trouble, coming here? Although, I have no choice now."),
						"Day" = list("It's just terrible how slow, sluggish everything around feels. The air is heavy, almost unpleasant to breath, as if it was stale for weeks. Once again, odd thoughts scatter in my head, memories of my past. Of the old life... that I can barely recall."),
						"Evening" = list("Evening is getting closer - it might be a good idea to find a place to spend nightly times at. I could probably be good with staying outdoors, but while there's a shard of civilisation nearby - it is desireable to use the possibilities, spend time in the warmth and comforty. I really should get some sleep."),
						"Night" = list("The skies are absolutely black, covering the camp from above. The unpleasant angst tears my consciousness apart, as I realise how dangerous it would be to sleep in a field while in the Zone itself. Can't call those soldiers anything but fuckheads, but at least they do provide protection.")
						)


/area/stalker/blowout/outdoor/anomaly


/area/stalker/blowout/outdoor/map_edge
	ambient_music = list('sound/stalker/ambience/edge1.ogg')


/area/stalker/blowout/outdoor/lelev
	ambient_music = list('sound/stalker/ambience/lelev1.ogg','sound/stalker/ambience/lelev2.ogg')
	enter_message_ru = list("Morning" = list("������� ��� ������ ������������ ��-�� �������� �� �������. ��, ������ ������ ������, � �� ����� ������ ���������... ����-�� ���, ��� ���� ��� ���� ��� ���� ����. � ��� ����? ��� ��� ���� ���� � ���������� � ���?.."),
						"Day" = list("���� � ��������, �� ��� �����, ������. ������ ����-���� ���������, �� ����� ����������, ����� �������� ���������� ������������. �������� �� ������ ���� ���-�� � ����� �� ������, �� ������-������ ������. � ������� ������ ���� �������� ������� �����-�� ����, ����� ��������� � ������� ����������. ������ ����������? ��� �������."),
						"Evening" = list("�������� ���� - ������ �������� ��������-�������, �������� �� ��, ��� ��� ���� �� �������� ���������. ��������� ���������� ����? ��������, ��. � ������ �������� ������� ����� ������ ������ ������ � �����-�� ����, ��������� �������� ������� �������� ���� � ��������, �������������� ������ ����. ���� �� ������ ������..."),
						"Night" = list("������� �����, ��� ���� ���� ������ - ������� �� ��������. � �����, ���������� �����, ���� ����� ������� ����� �� ��������, � � ��������� - ��� �������. � ������������ ����� ����� �� ���� ������� ����� ����� - ��� ������, ������������ ��������� � �����, ��� ���-�� ������ �� ������ ���� ��������� �����, ���� ����������� ���� ����� �� ������ ����. ���� � ��������� ������ � ����� ����, ���� ���� ����������.")
						)
	enter_message = list("Morning" = list("The golden sphere of the sun slowly rises above the woods in the east. Finally, it will get warmer, nights in here are spine-chilling... but what is this new day to Zone? Just another cycle, nothing special. What is it to me? What is Zone to me, what is it's meaning to my life?.."),
						"Day" = list("The sky is cloudy, but I can see the rays of sun falling down through the holes in the gray cover. I can feel the warmth of it even through the clothes, this makes me desire for something as simple as just resting in the grass. I wish I was in the fields like these, but somewhere far, far away from the Zone, from the anomalies... I can smell faint aroma of some herbs, wet wood and burnt plastics in the air. Why plastics? How odd."),
						"Evening" = list("The nigh is coming - sun shines with orange and pink instead of the yellowish glimmer, despite not even reaching the horizon yet. Another weird anomaly of the Zone? Yes, probably, A heavy aroma of berries and something sweet floats in the air, replacing the smell of burnt meat and plastics which appears every morning. I should probably look for a shelter."),
						"Night" = list("It's so dark that even losing an eye wouldn't make me see less. In the dim light of the moon, shadowy silhouettes of the buildings and trees can be noticed, but not the smaller structures and objects. In the darkness, which fell down on the Zone, sounds appear to be clearer - I can notice the insects creaking in the tall grass, and the howls of invisible creatures come from the north, making me shiver. If I wish to walk outside during the night like this, I should be careful.")
						)

/area/stalker/blowout/outdoor/anomaly/PUSO
	ambient_music = list('sound/stalker/ambience/puso.ogg')
	enter_message_ru = list("Morning" = list("������� ��� ������ ������������ ��-�� �������� �� �������. ��, ������ ������ ������, � �� ����� ������ ���������... ����-�� ���, ��� ���� ��� ���� ��� ���� ����. � ��� ����? ��� ��� ���� ���� � ���������� � ���?.."),
						"Day" = list("���� � ��������, �� ��� �����, ������. ������ ����-���� ���������, �� ����� ����������, ����� �������� ���������� ������������. �������� �� ������ ���� ���-�� � ����� �� ������, �� ������-������ ������. � ������� ������ ���� �������� ������� �����-�� ����, ����� ��������� � ������� ����������. ������ ����������? ��� �������."),
						"Evening" = list("�������� ���� - ������ �������� ��������-�������, �������� �� ��, ��� ��� ���� �� �������� ���������. ��������� ���������� ����? ��������, ��. � ������ �������� ������� ����� ������ ������ ������ � �����-�� ����, ��������� �������� ������� �������� ���� � ��������, �������������� ������ ����. ���� �� ������ ������..."),
						"Night" = list("������� �����, ��� ���� ���� ������ - ������� �� ��������. � �����, ���������� �����, ���� ����� ������� ����� �� ��������, � � ��������� - ��� �������. � ������������ ����� ����� �� ���� ������� ����� ����� - ��� ������, ������������ ��������� � �����, ��� ���-�� ������ �� ������ ���� ��������� �����, ���� ����������� ���� ����� �� ������ ����. ���� � ��������� ������ � ����� ����, ���� ���� ����������.")
						)
	enter_message = list("Morning" = list("The golden sphere of the sun slowly rises above the woods in the east. Finally, it will get warmer, nights in here are spine-chilling... but what is this new day to Zone? Just another cycle, nothing special. What is it to me? What is Zone to me, what is it's meaning to my life?.."),
						"Day" = list("The sky is cloudy, but I can see the rays of sun falling down through the holes in the gray cover. I can feel the warmth of it even through the clothes, this makes me desire for something as simple as just resting in the grass. I wish I was in the fields like these, but somewhere far, far away from the Zone, from the anomalies... I can smell faint aroma of some herbs, wet wood and burnt plastics in the air. Why plastics? How odd."),
						"Evening" = list("The nigh is coming - sun shines with orange and pink instead of the yellowish glimmer, despite not even reaching the horizon yet. Another weird anomaly of the Zone? Yes, probably, A heavy aroma of berries and something sweet floats in the air, replacing the smell of burnt meat and plastics which appears every morning. I should probably look for a shelter."),
						"Night" = list("It's so dark that even losing an eye wouldn't make me see less. In the dim light of the moon, shadowy silhouettes of the buildings and trees can be noticed, but not the smaller structures and objects. In the darkness, which fell down on the Zone, sounds appear to be clearer - I can notice the insects creaking in the tall grass, and the howls of invisible creatures come from the north, making me shiver. If I wish to walk outside during the night like this, I should be careful.")
						)

/area/stalker/blowout/outdoor/lelev_village

/area/stalker/blowout/outdoor/factory
	ambient_music = list('sound/stalker/ambience/zavod1.ogg','sound/stalker/ambience/zavod2.ogg','sound/stalker/ambience/zavod3.ogg')
	enter_message_ru = list("Morning" = list("������� ��� ������ ������������ ��-�� �������� �� �������. ��, ������ ������ ������, � �� ����� ������ ���������... ����-�� ���, ��� ���� ��� ���� ��� ���� ����. � ��� ����? ��� ��� ���� ���� � ���������� � ���?.."),
						"Day" = list("���� � ��������, �� ��� �����, ������. ������ ����-���� ���������, �� ����� ����������, ����� �������� ���������� ������������. �������� �� ������ ���� ���-�� � ����� �� ������, �� ������-������ ������. � ������� ������ ���� �������� ������� �����-�� ����, ����� ��������� � ������� ����������. ������ ����������? ��� �������."),
						"Evening" = list("�������� ���� - ������ �������� ��������-�������, �������� �� ��, ��� ��� ���� �� �������� ���������. ��������� ���������� ����? ��������, ��. � ������ �������� ������� ����� ������ ������ ������ � �����-�� ����, ��������� �������� ������� �������� ���� � ��������, �������������� ������ ����. ���� �� ������ ������..."),
						"Night" = list("������� �����, ��� ���� ���� ������ - ������� �� ��������. � �����, ���������� �����, ���� ����� ������� ����� �� ��������, � � ��������� - ��� �������. � ������������ ����� ����� �� ���� ������� ����� ����� - ��� ������, ������������ ��������� � �����, ��� ���-�� ������ �� ������ ���� ��������� �����, ���� ����������� ���� ����� �� ������ ����. ���� � ��������� ������ � ����� ����, ���� ���� ����������.")
						)
	enter_message = list("Morning" = list("The golden sphere of the sun slowly rises above the woods in the east. Finally, it will get warmer, nights in here are spine-chilling... but what is this new day to Zone? Just another cycle, nothing special. What is it to me? What is Zone to me, what is it's meaning to my life?.."),
						"Day" = list("The sky is cloudy, but I can see the rays of sun falling down through the holes in the gray cover. I can feel the warmth of it even through the clothes, this makes me desire for something as simple as just resting in the grass. I wish I was in the fields like these, but somewhere far, far away from the Zone, from the anomalies... I can smell faint aroma of some herbs, wet wood and burnt plastics in the air. Why plastics? How odd."),
						"Evening" = list("The nigh is coming - sun shines with orange and pink instead of the yellowish glimmer, despite not even reaching the horizon yet. Another weird anomaly of the Zone? Yes, probably, A heavy aroma of berries and something sweet floats in the air, replacing the smell of burnt meat and plastics which appears every morning. I should probably look for a shelter."),
						"Night" = list("It's so dark that even losing an eye wouldn't make me see less. In the dim light of the moon, shadowy silhouettes of the buildings and trees can be noticed, but not the smaller structures and objects. In the darkness, which fell down on the Zone, sounds appear to be clearer - I can notice the insects creaking in the tall grass, and the howls of invisible creatures come from the north, making me shiver. If I wish to walk outside during the night like this, I should be careful.")
						)

/area/stalker/blowout/outdoor/anomaly/factory
	ambient_music = list('sound/stalker/ambience/zavod4.ogg')


/area/stalker/buildings/cellar/lelev

/area/stalker/buildings/cellar/wild

/area/stalker/buildings/cellar/farm