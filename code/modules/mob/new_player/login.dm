/mob/new_player/Login()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()

	if(join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"

	if(admin_notice)
		src << "<span class='notice'><b>Admin Notice:</b>\n \t [admin_notice]</span>"

	if(CONFIG_GET(number/soft_popcap) && living_player_count() >= CONFIG_GET(number/soft_popcap))
		src << "<span class='notice'><b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]</span>"

	if(length(GLOB.newplayer_start))
		loc = pick(GLOB.newplayer_start)
	else
		loc = locate(1,1,1)

	sight |= SEE_TURFS | SEE_OBJS

//	new_player_panel()
	var/list/obj/lobby/lobby_screens = typesof(/obj/lobby)
	for(var/L in lobby_screens)
		var/obj/lobby/lobby = new L()
		client.screen += lobby

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/

	spawn(40)
		if(client)
			client.playtitlemusic()
