var/list/department_radio_keys = list(
	  ":r" = "right hand",	"#r" = "right hand",	".r" = "right hand",
	  ":l" = "left hand",	"#l" = "left hand",		".l" = "left hand",
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":c" = "Command",		"#c" = "Command",		".c" = "Command",
	  ":n" = "Science",		"#n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		"#m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", "#e" = "Engineering",	".e" = "Engineering",
	  ":s" = "Security",	"#s" = "Security",		".s" = "Security",
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":b" = "binary",		"#b" = "binary",		".b" = "binary",
	  ":a" = "alientalk",	"#a" = "alientalk",		".a" = "alientalk",
	  ":t" = "Syndicate",	"#t" = "Syndicate",		".t" = "Syndicate",
	  ":u" = "Supply",		"#u" = "Supply",		".u" = "Supply",
	  ":v" = "Service",		"#v" = "Service",		".v" = "Service",
	  ":o" = "AI Private",	"#o" = "AI Private",	".o" = "AI Private",
	  ":g" = "changeling",	"#g" = "changeling",	".g" = "changeling",
	  ":y" = "Centcom",		"#y" = "Centcom",		".y" = "Centcom",

	  ":R" = "right hand",	"#R" = "right hand",	".R" = "right hand",
	  ":L" = "left hand",	"#L" = "left hand",		".L" = "left hand",
	  ":I" = "intercom",	"#I" = "intercom",		".I" = "intercom",
	  ":H" = "department",	"#H" = "department",	".H" = "department",
	  ":C" = "Command",		"#C" = "Command",		".C" = "Command",
	  ":N" = "Science",		"#N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		"#M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	"#E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	"#S" = "Security",		".S" = "Security",
	  ":W" = "whisper",		"#W" = "whisper",		".W" = "whisper",
	  ":B" = "binary",		"#B" = "binary",		".B" = "binary",
	  ":A" = "alientalk",	"#A" = "alientalk",		".A" = "alientalk",
	  ":T" = "Syndicate",	"#T" = "Syndicate",		".T" = "Syndicate",
	  ":U" = "Supply",		"#U" = "Supply",		".U" = "Supply",
	  ":V" = "Service",		"#V" = "Service",		".V" = "Service",
	  ":O" = "AI Private",	"#O" = "AI Private",	".O" = "AI Private",
	  ":G" = "changeling",	"#G" = "changeling",	".G" = "changeling",
	  ":Y" = "Centcom",		"#Y" = "Centcom",		".Y" = "Centcom",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":?" = "right hand",	"#?" = "right hand",	".?" = "right hand",
	  ":?" = "left hand",	"#?" = "left hand",		".?" = "left hand",
	  ":?" = "intercom",	"#?" = "intercom",		".?" = "intercom",
	  ":?" = "department",	"#?" = "department",	".?" = "department",
	  ":?" = "Command",		"#?" = "Command",		".?" = "Command",
	  ":?" = "Science",		"#?" = "Science",		".?" = "Science",
	  ":?" = "Medical",		"#?" = "Medical",		".?" = "Medical",
	  ":?" = "Engineering",	"#?" = "Engineering",	".?" = "Engineering",
	  ":?" = "Security",	"#?" = "Security",		".?" = "Security",
	  ":?" = "whisper",		"#?" = "whisper",		".?" = "whisper",
	  ":?" = "binary",		"#?" = "binary",		".?" = "binary",
	  ":?" = "alientalk",	"#?" = "alientalk",		".?" = "alientalk",
	  ":?" = "Syndicate",	"#?" = "Syndicate",		".?" = "Syndicate",
	  ":?" = "Supply",		"#?" = "Supply",		".?" = "Supply",
	  ":?" = "changeling",	"#?" = "changeling",	".?" = "changeling"
)

var/list/crit_allowed_modes = list(MODE_WHISPER,MODE_CHANGELING,MODE_ALIEN)

/mob/living/say(message, message_ru, bubble_type)
	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message_ru)
		message_ru = message
	message_ru = trim(copytext_char(sanitize_russian(message_ru), 1, MAX_MESSAGE_LEN))

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
		message = copytext_char(message, 2)
	else if(message_mode)
		message = copytext_char(message, 3)
	if(findtext(message, " ", 1, 2))
		message = copytext_char(message, 2)

	if(handle_inherent_channels(message, message_mode)) //Hiveminds, binary chat & holopad.
		return

	if(!can_speak_vocal(message))
		src << "<span class='warning'>You find yourself unable to speak!</span>"
		return

	if(message_mode != MODE_WHISPER) //whisper() calls treat_message(); double process results in "hisspering"
		message = treat_message(message)
		message_ru = treat_message(message_ru)
	var/spans = list()
	spans += get_spans()

	if(!message || !message_ru)
		return

	//Log of what we've said, plain message, no spans or junk
	say_log += message

	var/message_range = 7
	var/radio_return = radio(message, message_mode, spans)
	if(radio_return & NOPASS) //There's a whisper() message_mode, no need to continue the proc if that is called
		return
	if(radio_return & ITALICS)
		spans |= SPAN_ITALICS
	if(radio_return & REDUCE_RANGE)
		message_range = 1

	//No screams in space, unless you're next to someone.
//	var/turf/T = get_turf(src)
//	var/datum/gas_mixture/environment = T.return_air()
//	var/pressure = (environment)? environment.return_pressure() : 0
	/*if(pressure < SOUND_MINIMUM_PRESSURE)
		message_range = 1 */

	/*if(pressure < ONE_ATMOSPHERE*0.4) //Thin air, let's italicise the message
		spans |= SPAN_ITALICS*/

	send_speech(message, message_range, src, bubble_type, spans, message_ru)

	log_say("[name]/[key] : [message]")
	return 1

/mob/living/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, msg_ru)
	if(!client)
		return
	var/deaf_message
	var/deaf_type
	if(speaker != src)
		if(!radio_freq) //These checks have to be seperate, else people talking on the radio will make "You can't hear yourself!" appear when hearing people over the radio while deaf.
			deaf_message = "<span class='name'>[speaker]</span> [speaker.verb_say] something but you cannot hear them."
			deaf_type = 1
	else
		deaf_message = "<span class='notice'>You can't hear yourself!</span>"
		deaf_type = 2 // Since you should be able to hear yourself without looking
	if(!(message_langs & languages) || force_compose) //force_compose is so AIs don't end up without their hrefs.
		message = compose_message(speaker, message_langs, raw_message, radio_freq, spans, src)
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.tangled)
			var/new_message = msg_ru
			var/msg_to_find
			var/lenght_change = 0
			var/list/words_on_replace = list("???", "??????", "???","????????", "???????????","????????",   "??????",  " ????",   "????","????", "?????", "?????","?????", "??????","????","?? ","??")
			var/list/words_to_replace = list("????","???????","??", "?????????","??????????", "?? ????????","????????"," ?? ????","???", "?????","??????","??",   "??????","?????", "????","",   ""  )
			for(var/i = 1 to words_on_replace.len)
				var/msg_num = findtext(lowerrustext(msg_ru), words_on_replace[i])
				if(msg_num)
					msg_to_find = copytext(msg_ru, msg_num, msg_num+length(words_on_replace[i]))
					new_message = replacetext(new_message, msg_to_find, words_to_replace[i], msg_num+lenght_change, msg_num+length(msg_to_find)+lenght_change)
					lenght_change -= length(words_on_replace[i])-length(words_to_replace[i])
				else
					msg_num = findtext(lowerrustext(msg_ru), words_to_replace[i])
					if(msg_num)
						msg_to_find = copytext(msg_ru, msg_num, msg_num+length(words_to_replace[i]))
						new_message = replacetext(new_message, msg_to_find, words_on_replace[i], msg_num+lenght_change, msg_num+length(msg_to_find)+lenght_change)
						lenght_change -= length(words_on_replace[i])-length(words_to_replace[i])
			if(speaker != src)
				msg_ru = new_message
	show_message(message, 2, deaf_message, deaf_type, msg_ru)
	return message

/mob/living/send_speech(message, message_range = 7, obj/source = src, bubble_type = bubble_icon, list/spans, msg_ru)
	if(!msg_ru)
		msg_ru = message
	var/list/listening = get_hearers_in_view(message_range, source)
	for(var/mob/M in GLOB.player_list)
		if(M.stat == DEAD && M.client && ((M.client.prefs && (M.client.prefs.chat_toggles & CHAT_GHOSTEARS)) || (get_dist(M, src) <= 7)) && client) // client is so that ghosts don't have to listen to mice
			listening |= M

	for(var/atom/movable/AM in listening)
		var/rendered = compose_message(src, languages, message, , spans, AM)
		var/rendered_ru = compose_message(src, languages, msg_ru, , spans, AM)
		AM.Hear(rendered, src, languages, message, , spans, rendered_ru)

	//speech bubble
	var/list/speech_bubble_recipients = list()
	for(var/mob/M in listening)
		if(M.client)
			speech_bubble_recipients.Add(M.client)
	spawn(0)
		flick_overlay(image('icons/mob/talk.dmi', src, "[bubble_type][say_test(message)]",MOB_LAYER+1), speech_bubble_recipients, 30)

/mob/proc/binarycheck()
	return 0

/mob/living/can_speak(message) //For use outside of Say()
	if(can_speak_basic(message) && can_speak_vocal(message))
		return 1

/mob/living/proc/can_speak_basic(message) //Check BEFORE handling of xeno and ling channels
	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "<span class='danger'>You cannot speak in IC (muted).</span>"
			return 0
		if(client.handle_spam_prevention(message,MUTE_IC))
			return 0

	return 1

/mob/living/proc/can_speak_vocal(message) //Check AFTER handling of xeno and ling channels
	if(disabilities & MUTE)
		return 0

	if(is_muzzled())
		return 0

	if(!IsVocal())
		return 0

	return 1

/mob/living/proc/check_emote(message)
	if(copytext(message, 1, 2) == "*")
		emote(copytext(message, 2))
		return 1

/mob/living/proc/get_message_mode(message)
	if(copytext(message, 1, 2) == ";")
		return MODE_HEADSET
	else if(length(message) > 2)
		return department_radio_keys[copytext(message, 1, 3)]

/mob/living/proc/handle_inherent_channels(message, message_mode)
//	if(message_mode == MODE_ALIEN)
//		if(hivecheck())
//			alien_talk(message)
//			return 1
	return 0

/mob/living/proc/treat_message(message)
//	if(getBrainLoss() >= 60)
//		message = derpspeech(message, stuttering)

	if(stuttering)
		message = stutter(message)

	if(slurring)
		message = slur(message)

	message = capitalize(message)

	return message

/mob/living/proc/radio(message, message_mode, list/spans)
	switch(message_mode)
		if(MODE_R_HAND)
			if (r_hand)
				r_hand.talk_into(src, message, , spans)
			return ITALICS | REDUCE_RANGE

		if(MODE_L_HAND)
			if (l_hand)
				l_hand.talk_into(src, message, , spans)
			return ITALICS | REDUCE_RANGE

		if(MODE_INTERCOM)
//			for (var/obj/item/device/radio/intercom/I in view(1, null))
//				I.talk_into(src, message, , spans)
			return ITALICS | REDUCE_RANGE

		if(MODE_BINARY)
//			if(binarycheck())
//				robot_talk(message)
			return ITALICS | REDUCE_RANGE //Does not return 0 since this is only reached by humans, not borgs or AIs.

		if(MODE_WHISPER)
			whisper(message)
			return NOPASS
	return 0

/mob/living/lingcheck() //Returns 1 if they are a changeling. Returns 2 if they are a changeling that can communicate through the hivemind
	return 0

/mob/living/say_quote(input, list/spans)
	var/tempinput = attach_spans(input, spans)
	if (stuttering)
		if(client)
			return client.select_lang("?????????, \"[tempinput]\"", "stammers, \"[tempinput]\"")
	return ..()