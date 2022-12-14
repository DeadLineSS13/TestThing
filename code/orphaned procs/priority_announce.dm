/proc/priority_announce(text, title = "", sound = 'sound/effects/adminhelp.ogg', type)
	if(!text)
		return

	var/announcement

	if(type == "Priority")
		announcement += "<h1 class='alert'>Priority Announcement</h1>"
		if (title && length(title) > 0)
			announcement += sanitize_russian("<br><h2 class='alert'>[rhtml_encode(title)]</h2>")
	else if(type == "Captain")
		announcement += "<h1 class='alert'>Captain Announces</h1>"
//		news_network.SubmitArticle(text, "Captain's Announcement", "Station Announcements", null)

	else
		announcement += "<h1 class='alert'>[command_name()] Update</h1>"
		if (title && length(title) > 0)
			announcement += sanitize_russian("<br><h2 class='alert'>[rhtml_encode(title)]</h2>")
//		if(title == "")
//			news_network.SubmitArticle(text, "Central Command Update", "Station Announcements", null)
//		else
//			news_network.SubmitArticle(title + "<br><br>" + text, "Central Command", "Station Announcements", null)

	announcement += sanitize_russian("<br><span class='alert'>[text]</span><br>")
	announcement += "<br>"

	for(var/mob/M in GLOB.player_list)
		if(!istype(M,/mob/new_player) && !M.ear_deaf)
			M << announcement
			M << sound(sound)

/proc/print_command_report(text = "", title = "Central Command Update")
	return

/proc/minor_announce(message, title = "Attention:", alert)
	if(!message)
		return

	for(var/mob/M in GLOB.player_list)
		if(!istype(M,/mob/new_player) && !M.ear_deaf)
			M << "<b><font size = 3><font color = red>[title]</font color><BR>[message]</font size></b><BR>"
			if(alert)
				M << sound('sound/misc/notice1.ogg')
			else
				M << sound('sound/misc/notice2.ogg')