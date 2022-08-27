/*
 	Miauw's big Say() rewrite.
	This file has the basic atom/movable level speech procs.
	And the base of the send_speech() proc, which is the core of saycode.
*/
var/list/freqtospan = list(
	"1351" = "sciradio",
	"1355" = "medradio",
	"1357" = "engradio",
	"1347" = "suppradio",
	"1349" = "servradio",
	"1359" = "secradio",
	"1353" = "comradio",
	"1447" = "aiprivradio",
	"1213" = "syndradio",
	"1337" = "centcomradio"
	)

/atom/movable/proc/say(message, message_ru)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	var/list/spans = get_spans()
	if(!message_ru)
		message_ru = message
	else
		message_ru = sanitize_russian(message_ru)
	send_speech(message, 7, src, , spans, msg_ru = message_ru)

/atom/movable/proc/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans)
	return

/atom/movable/proc/can_speak()
	return 1

/atom/movable/proc/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, msg_ru)
	for(var/atom/movable/AM in get_hearers_in_view(range, src))
		var/rendered = compose_message(src, languages, message, , spans, AM)
		var/rendered_ru = compose_message(src, languages, msg_ru, , spans, AM)
		AM.Hear(rendered, src, languages, message, , spans, msg_ru = rendered_ru)

//To get robot span classes, stuff like that.
/atom/movable/proc/get_spans()
	return list()

/atom/movable/proc/compose_message(atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, atom/movable/hearer)
	//This proc uses text() because it is faster than appending strings. Thanks BYOND.
	//Basic span
	var/spanpart1 = "<span class='[radio_freq ? get_radio_span(radio_freq) : "game say"]'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq)]\] " : ""
	//Speaker name
	var/namepart =  "[speaker.GetVoice()][speaker.get_alt_name()]"
	if(ismob(speaker) && ismob(hearer))
		var/mob/M = speaker
		var/mob/H = hearer
		if(M.client && H.client)
			if(H.clients_names[M])
				var/name_new = H.clients_names[M]
				namepart = "[name_new]"
			else if(H.client.language == "Russian")
				if(ishuman(src))
					var/mob/living/carbon/human/HU = src
					namepart = HU.get_uniq_name("RU")
				else
					namepart = name_ru
			else
				if(ishuman(src))
					var/mob/living/carbon/human/HU = src
					namepart = HU.get_uniq_name("EN")
				else
					namepart = name
	//End name span.
	var/endspanpart = "</span>"
	//Message
	var/messagepart = " <span class='message'>[lang_treat(speaker, message_langs, raw_message, spans, hearer)]</span></span>"

	return "[spanpart1][spanpart2][freqpart][compose_track_href(speaker, namepart)][namepart][compose_job(speaker, message_langs, raw_message, radio_freq)][endspanpart][messagepart]"

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_quote(input, list/spans=list(), atom/movable/hearer)
	if(!input)
		return "says, \"...\""	//not the best solution, but it will stop a large number of runtimes. The cause is somewhere in the Tcomms code
	var/ending = copytext(input, length(input))
	if(copytext(input, length(input) - 1) == "!!")
		spans |= SPAN_YELL
		if(ismob(hearer))
			var/mob/H = hearer
			if(verb_yell_ru && H.client && H.client.language == "Russian")
				return "[verb_yell_ru], \"[attach_spans(input, spans)]\""
		return "[verb_yell], \"[attach_spans(input, spans)]\""
	input = attach_spans(input, spans)
	if(ending == "?")
		if(ismob(hearer))
			var/mob/H = hearer
			if(verb_ask_ru && H.client && H.client.language == "Russian")
				return "[verb_ask_ru], \"[input]\""
		return "[verb_ask], \"[input]\""
	if(ending == "!")
		if(ismob(hearer))
			var/mob/H = hearer
			if(verb_exclaim_ru && H.client && H.client.language == "Russian")
				return "[verb_exclaim_ru], \"[input]\""
		return "[verb_exclaim], \"[input]\""
	if(ismob(hearer))
		var/mob/H = hearer
		if(verb_say_ru && H.client && H.client.language == "Russian")
			return "[verb_say_ru], \"[input]\""
	return "[verb_say], \"[input]\""

/atom/movable/proc/lang_treat(atom/movable/speaker, message_langs, raw_message, list/spans, mob/hearer)
	if(languages & message_langs)
		var/atom/movable/AM = speaker.GetSource()
		if(AM) //Basically means "if the speaker is virtual"
			if(AM.verb_say != speaker.verb_say || AM.verb_ask != speaker.verb_ask || AM.verb_exclaim != speaker.verb_exclaim || AM.verb_yell != speaker.verb_yell) //If the saymod was changed
				return speaker.say_quote(raw_message, spans, hearer)
			return AM.say_quote(raw_message, spans, hearer)
		else
			return speaker.say_quote(raw_message, spans, hearer)
	else if(message_langs & HUMAN)
		var/atom/movable/AM = speaker.GetSource()
		if(AM)
			return AM.say_quote(stars(raw_message), spans, hearer)
		else
			return speaker.say_quote(stars(raw_message), spans, hearer)
	else if(message_langs & MONKEY)
		return "chimpers."
	else if(message_langs & ALIEN)
		return "hisses."
	else if(message_langs & ROBOT)
		return "beeps rapidly."
	else if(message_langs & DRONE)
		return "chitters."
	else
		return "makes a strange sound."

/proc/get_radio_span(freq)
	var/returntext = freqtospan["[freq]"]
	if(returntext)
		return returntext
	return "radio"

/proc/get_radio_name(freq)
	var/returntext = radiochannelsreverse["[freq]"]
	if(returntext)
		return returntext
	return "[copytext("[freq]", 1, 4)].[copytext("[freq]", 4, 5)]"

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

/atom/movable/proc/GetVoice()
	return name

/atom/movable/proc/IsVocal()
	return 1

/atom/movable/proc/get_alt_name()

//HACKY VIRTUALSPEAKER STUFF BEYOND THIS POINT
//these exist mostly to deal with the AIs hrefs and job stuff.

/atom/movable/proc/GetJob() //Get a job, you lazy butte

/atom/movable/proc/GetSource()

/atom/movable/proc/GetRadio()

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/device/radio/radio

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetSource()
	return source

/atom/movable/virtualspeaker/GetRadio()
	return radio

/atom/movable/virtualspeaker/Destroy()
	..()
	return QDEL_HINT_QUEUE