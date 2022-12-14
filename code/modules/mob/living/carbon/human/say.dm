/mob/living/carbon/human/say(message, message_ru, bubble_type)
	if(!message_ru)
		message_ru = message
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
	message_ru = trim(copytext(sanitize(message_ru), 1, MAX_MESSAGE_LEN))

	if(stat == DEAD)
//		say_dead(message)
		return

	if(check_emote(message))
		return

	if(!can_speak_basic(message)) //Stat is seperate so I can handle whispers properly.
		return

	var/message_mode = get_message_mode(message)

	if(stat && !(message_mode in crit_allowed_modes))
		return

	if(message_mode == MODE_HEADSET || message_mode == MODE_ROBOT)
		message = copytext(message, 2)
	else if(message_mode)
		message = copytext(message, 3)
	if(findtext(message, " ", 1, 2))
		message = copytext(message, 2)

	if(handle_inherent_channels(message, message_mode)) //Hiveminds, binary chat & holopad.
		return

	if(!can_speak_vocal(message))
		return

	if(message_mode != MODE_WHISPER) //whisper() calls treat_message(); double process results in "hisspering"
		message = treat_message(message)
	var/spans = list()
	spans += get_spans()

	if(!message || !message_ru)
		return

	//Log of what we've said, plain message, no spans or junk
	if(!zombiefied)
		say_log += message

	var/message_range = 7
	var/radio_return = radio(message, message_mode, spans)
	if(radio_return & NOPASS) //There's a whisper() message_mode, no need to continue the proc if that is called
		return
	if(radio_return & ITALICS)
		spans |= SPAN_ITALICS
	if(radio_return & REDUCE_RANGE)
		message_range = 1

	send_speech(message, message_range, src, bubble_type, spans, message_ru)

	log_say("[name]/[key] : [message]")
	return 1

/mob/living/carbon/human/say_quote(input, spans)
	if(!input)
		return "says, \"...\""	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
	verb_say = dna.species.say_mod
	if(src.slurring)
		input = attach_spans(input, spans)
		if(src.client && src.client.language == "Russian")
			return "бормочет, \"[input]\""
		return "slurs, \"[input]\""

	return ..()

/mob/living/carbon/human/get_spans()
	return ..() | dna.mutations_get_spans() | dna.species_get_spans()

/mob/living/carbon/human/IsVocal()
	if(mind)
		return !mind.miming
	return 1

/mob/living/carbon/human/proc/SetSpecialVoice(new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/binarycheck()
	return
//	if(ears)
//		var/obj/item/device/radio/headset/dongle = ears
//		if(!istype(dongle)) return 0
//		if(dongle.translate_binary) return 1

/mob/living/carbon/human/radio(message, message_mode, list/spans)
	. = ..()
	if(. != 0)
		return .

	switch(message_mode)
		if(MODE_HEADSET)
			if (ears)
				ears.talk_into(src, message, , spans)
			return ITALICS | REDUCE_RANGE

		if(MODE_DEPARTMENT)
			if (ears)
				ears.talk_into(src, message, message_mode, spans)
			return ITALICS | REDUCE_RANGE

	if(message_mode in radiochannels)
		if(ears)
			ears.talk_into(src, message, message_mode, spans)
			return ITALICS | REDUCE_RANGE

	return 0

/mob/living/carbon/human/get_alt_name()
	if(name != GetVoice())
		return " (as [get_id_name("Unknown")])"

/mob/living/carbon/human/proc/forcesay(list/append) //this proc is at the bottom of the file because quote fuckery makes notepad++ cri
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//"case sensitive means

				temp = replacetext(temp, ";", "")	//general radio

				if(findtext(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				if(findtext(temp, "*", 1, 2))	//emotes
					return

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")
