/mob/living/carbon/human/whisper(message as text)
	if(!IsVocal())
		return
	if(!message)
		return

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	if(stat)
		return

	message = trim(message)
	if(!can_speak(message))
		return

	message = "[message]"
	log_whisper("[src.name]/[src.key] : [message]")

	if (src.client)
		if (src.client.prefs.muted & MUTE_IC)
			src << "<span class='danger'>You cannot whisper (muted).</span>"
			return

	log_whisper("[src.name]/[src.key] : [message]")

	message = treat_message(message)

	var/list/listening = get_hearers_in_view(1, src)
	var/list/eavesdropping = get_hearers_in_view(2, src)
	eavesdropping -= listening
	var/list/watching  = hearers(5, src)
	watching  -= listening
	watching  -= eavesdropping

	var/s_name
	var/rendered
	var/rendered_ru

	var/spans = list(SPAN_ITALICS)

	for(var/mob/M in watching)
		if(M.clients_names[src])
			s_name = M.clients_names[src]
		else if(M.client.language == "Russian")
			s_name = get_uniq_name("RU")
		else
			s_name = get_uniq_name("EN")
		rendered = "<span class='game say'><span class='name'>[s_name]</span> whispers something.</span>"
		rendered_ru = "<span class='game say'><span class='name'>[s_name]</span> что-то шепчет.</span>"
		M.Hear(rendered, src, languages, message, , spans, src, msg_ru = rendered_ru)

	for(var/atom/movable/AM in listening)
		if(istype(AM,/obj/item/device/radio))
			continue
		if(ismob(AM))
			var/mob/M = AM
			if(M.clients_names[src])
				s_name = M.clients_names[src]
			else if(M.client.language == "Russian")
				s_name = get_uniq_name("RU")
			else
				s_name = get_uniq_name("EN")
		rendered = "<span class='game say'><span class='name'>[s_name]</span> whispers, <span class='message'>\"[attach_spans(message, spans)]\"</span></span>"
		rendered_ru = "<span class='game say'><span class='name'>[s_name]</span> шепчет, <span class='message'>\"[attach_spans(message, spans)]\"</span></span>"
		AM.Hear(rendered, src, languages, message, , spans, src, msg_ru = rendered_ru)

	message = stars(message)

	for(var/atom/movable/AM in eavesdropping)
		if(istype(AM,/obj/item/device/radio))
			continue
		if(ismob(AM))
			var/mob/M = AM
			if(M.clients_names[src])
				s_name = M.clients_names[src]
			else if(M.client.language == "Russian")
				s_name = get_uniq_name("RU")
			else
				s_name = get_uniq_name("EN")
		rendered = "<span class='game say'><span class='name'>[s_name]</span> whispers, <span class='message'>\"[attach_spans(message, spans)]\"</span></span>"
		rendered_ru = "<span class='game say'><span class='name'>[s_name]</span> шепчет, <span class='message'>\"[attach_spans(message, spans)]\"</span></span>"
		AM.Hear(rendered, src, languages, message, , spans, src, msg_ru = rendered_ru)