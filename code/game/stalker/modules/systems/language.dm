/client
	var/language = "Russian"

/client/proc/select_lang(var/rus_msg, var/eng_msg)
	if(mob.client)
		switch(language)
			if("Russian")
				return rus_msg
			if("English")
				return eng_msg
	else
		return eng_msg

/client/verb/change_lang()
	set name = "Change Language"
	set category = "OOC"

	if(usr.client.language == "English")
		usr.client.language = "Russian"
		usr << "Теперь ваш язык Русский"
	else if(usr.client.language == "Russian")
		usr.client.language = "English"
		usr << "Now your language is English"