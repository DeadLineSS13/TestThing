/mob/living/carbon/human/emote(act,m_type=1,message = null,message_ru = null)
	var/param = null

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)


	var/muzzled = is_muzzled()
	//var/m_type = 1

//	for (var/obj/item/weapon/implant/I in src)
//		if (I.implanted)
//			I.trigger(act, src)

	var/miming=0
	if(mind)
		miming=mind.miming

	if(src.stat == 2 && (act != "deathgasp"))
		return
	switch(act) //Please keep this alphabetically ordered when adding or changing emotes.
		if ("aflap") //Any emote on human that uses miming must be left in, oh well.
			if (!src.restrained())
				message = "<B>DOER</B> flaps his wings ANGRILY!"
				m_type = 2

		if ("choke","chokes")
			if (miming)
				message = "<B>DOER</B> clutches his throat desperately!"
			else
				..(act)

		if ("chuckle","chuckles")
			if(miming)
				message = "<B>DOER</B> appears to chuckle."
			else
				..(act)

		if ("clap","claps")
			if (!src.restrained())
				message = "<B>DOER</B> claps."
				m_type = 2

		if ("collapse","collapses")
			Paralyse(2)
			adjustStaminaLoss(100) // Hampers abuse against simple mobs, but still leaves it a viable option.
			message = "<B>DOER</B> collapses!"
			m_type = 2

		if ("cough","coughs")
			if (miming)
				message = "<B>DOER</B> appears to cough!"
			else
				if (!muzzled)
					message = "<B>DOER</B> coughs!"
					message_ru = "<B>DOER<b> ???????!"
					m_type = 2
				else
					message = "<B>DOER</B> makes a strong noise."
					m_type = 2

		if ("cry","crys","cries") //I feel bad if people put s at the end of cry. -Sum99
			if (miming)
				message = "<B>DOER</B> cries."
			else
				if (!muzzled)
					message = "<B>DOER</B> cries."
					m_type = 2
				else
					message = "<B>DOER</B> makes a weak noise. He frowns."
					m_type = 2

		if ("custom")
			//if(jobban_isbanned(src, "emote"))
			//	src << "You cannot send custom emotes (banned)"
			//	return
			if(src.client)
				if(client.prefs.muted & MUTE_IC)
					src << "You cannot send IC messages (muted)."
					return
			var/input = copytext(sanitize(input("Choose an emote to display.") as text|null),1,MAX_MESSAGE_LEN)
			if (!input)
				return
			if(copytext(input,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,6) == "yells")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(input,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					if(miming)
						return
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>DOER</B> [input]"

		if ("dap","daps")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "<B>DOER</B> gives daps to [M]."
				else
					message = "<B>DOER</B> sadly can't find anybody to give daps to, and daps himself. Shameful."

		if ("eyebrow")
			message = "<B>DOER</B> raises an eyebrow."
			m_type = 1

		if ("flap","flaps")
			if (!src.restrained())
				message = "<B>DOER</B> flaps his wings."
				m_type = 2

		if ("gasp","gasps")
			if (miming)
				message = "<B>DOER</B> appears to be gasping!"
			else
				..(act)

		if ("giggle","giggles")
			if (miming)
				message = "<B>DOER</B> giggles silently!"
			else
				..(act)

		if ("groan","groans")
			if (miming)
				message = "<B>DOER</B> appears to groan!"
			else
				if (!muzzled)
					message = "<B>DOER</B> groans!"
					m_type = 2
				else
					message = "<B>DOER</B> makes a loud noise."
					m_type = 2

		if ("grumble","grumbles")
			if (!muzzled)
				message = "<B>DOER</B> grumbles!"
			else
				message = "<B>DOER</B> makes a noise."
				m_type = 2

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "<B>DOER</B> shakes hands with [M]."
					else
						message = "<B>DOER</B> holds out his hand to [M]."

		if ("hug","hugs")
			m_type = 1
			if (!src.restrained())
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M = null
				if (M)
					message = "<B>DOER</B> hugs [M]."
				else
					message = "<B>DOER</B> hugs himself."

		if ("me")
			if(silent)
				return
			//if(jobban_isbanned(src, "emote"))
			//	src << "You cannot send custom emotes (banned)"
			//	return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<span class='danger'>You cannot send IC messages (muted).</span>"
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			if(copytext(message,1,5) == "says")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,9) == "exclaims")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,6) == "yells")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else if(copytext(message,1,5) == "asks")
				src << "<span class='danger'>Invalid emote.</span>"
				return
			else
				message = "<B>DOER</B> [message]"

		if ("moan","moans")
			if(miming)
				message = "<B>DOER</B> appears to moan!"
			else
				message = "<B>DOER</B> moans!"
				m_type = 2

		if ("mumble","mumbles")
			message = "<B>DOER</B> mumbles!"
			m_type = 2

		if ("pale")
			message = "<B>DOER</B> goes pale for a second."
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "<B>DOER</B> raises a hand."
			m_type = 1

		if ("salute","salutes")
			if (!src.buckled)
				var/M = null
				if (param)
					for (var/mob/A in view(1, src))
						if (param == A.name)
							M = A
							break
				if (!M)
					param = null
				if (param)
					message = "<B>DOER</B> salutes to [param]."
				else
					message = "<B>DOER</b> salutes."
			m_type = 1

		if ("scream","screams")
			if (miming)
				message = "<B>DOER</B> acts out a scream!"
			else
				..(act)

		if ("shiver","shivers")
			message = "<B>DOER</B> shivers."
			m_type = 1

		if ("shrug","shrugs")
			message = "<B>DOER</B> shrugs."
			m_type = 1

		if ("sigh","sighs")
			if(miming)
				message = "<B>DOER</B> sighs."
			else
				..(act)

		if ("signal","signals")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "<B>DOER</B> raises [t1] finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "<B>DOER</B> raises [t1] finger\s."
			m_type = 1

		if ("sneeze","sneezes")
			if (miming)
				message = "<B>DOER</B> sneezes."
			else
				..(act)

		if ("sniff","sniffs")
			message = "<B>DOER</B> sniffs."
			m_type = 2

		if ("snore","snores")
			if (miming)
				message = "<B>DOER</B> sleeps soundly."
			else
				..(act)

		if ("whimper","whimpers")
			if (miming)
				message = "<B>DOER</B> appears hurt."
			else
				..(act)

		if ("yawn","yawns")
			if (!muzzled)
				message = "<B>DOER</B> yawns."
				m_type = 2

		if("wag","wags")
			if(dna && dna.species && (("tail_lizard" in dna.species.mutant_bodyparts) || ((dna.features["tail_human"] != "None") && !("waggingtail_human" in dna.species.mutant_bodyparts))))
				message = "<B>DOER</B> wags his tail."
				startTailWag()
			else if(dna && dna.species && (("waggingtail_lizard" in dna.species.mutant_bodyparts) || ("waggingtail_human" in dna.species.mutant_bodyparts)))
				endTailWag()
			else
				src << "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>"

		if ("help") //This can stay at the bottom.
			src << "Help for human emotes. You can use these emotes with say \"*emote\":\n\naflap, airguitar, blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough, cry, custom, dance, dap, deathgasp, drool, eyebrow, faint, flap, frown, gasp, giggle, glare-(none)/mob, grin, groan, grumble, handshake, hug-(none)/mob, jump, laugh, look-(none)/mob, me, moan, mumble, nod, pale, point-(atom), raise, salute, scream, shake, shiver, shrug, sigh, signal-#1-10, sit, smile, sneeze, sniff, snore, stare-(none)/mob, sulk, sway, tremble, twitch, twitch_s, wave, whimper, wink, wag, yawn"

		else
			..(act)

	if(miming)
		m_type = 1


	if(!message_ru)
		message_ru = message

	if (message)
		log_emote("[name]/[key] : [message]")

 //Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		for(var/mob/M in GLOB.dead_mob_list)
			if(!M.client || istype(M, /mob/new_player))
				continue //skip monkeys, leavers and new players
			if(M.stat == DEAD && M.client && (M.client.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		if (m_type & 1)
			direct_visible_message(message, message_ru = message_ru, doer = src)
		else if (m_type & 2)
			direct_visible_message(message, message_ru = message_ru, doer = src)
//			audible_message(message)



//Don't know where else to put this, it's basically an emote
/mob/living/carbon/human/proc/startTailWag()
	if(!dna || !dna.species)
		return
	if("tail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_lizard"
		dna.species.mutant_bodyparts -= "spines"
		dna.species.mutant_bodyparts |= "waggingtail_lizard"
		dna.species.mutant_bodyparts |= "waggingspines"
	if("tail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "tail_human"
		dna.species.mutant_bodyparts |= "waggingtail_human"
	update_body()


/mob/living/carbon/human/proc/endTailWag()
	if(!dna || !dna.species)
		return
	if("waggingtail_lizard" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_lizard"
		dna.species.mutant_bodyparts -= "waggingspines"
		dna.species.mutant_bodyparts |= "tail_lizard"
		dna.species.mutant_bodyparts |= "spines"
	if("waggingtail_human" in dna.species.mutant_bodyparts)
		dna.species.mutant_bodyparts -= "waggingtail_human"
		dna.species.mutant_bodyparts |= "tail_human"
	update_body()