/mob/dead/observer/say(message)
	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if (!message)
		return

	log_say("Ghost/[src.key] : [message]")

	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			src << "<span class='danger'>You cannot talk in deadchat (muted).</span>"
			return

		if (src.client.handle_spam_prevention(message,MUTE_DEADCHAT))
			return

	return
//	. = src.say_dead(message)

/mob/dead/observer/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, msg_ru)
	if(radio_freq)
		var/atom/movable/virtualspeaker/V = speaker

		speaker = V.source
	if(client && client.language == "Russian" && msg_ru)
		src << "<a href=?src=\ref[src];follow=\ref[speaker]>(F)</a> [msg_ru]"
	else
		src << "<a href=?src=\ref[src];follow=\ref[speaker]>(F)</a> [message]"

