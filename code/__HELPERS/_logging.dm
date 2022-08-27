//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
/proc/warning(msg)
	world.log << "## WARNING: [msg]"

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	world.log << "## NOTICE: [msg]"

//print a testing-mode debug message to world.log
/proc/testing(msg)
#ifdef TESTING
	world.log << "## TESTING: [msg]"
#endif

/proc/log_admin(text)
	GLOB.admin_log.Add(text)
	if (CONFIG_GET(flag/log_admin))
		diary << "\[[time_stamp()]]ADMIN: [text]"

/proc/log_adminsay(text)
	if (CONFIG_GET(flag/log_adminchat))
		log_admin("ASAY: [text]")

/proc/log_dsay(text)
	if (CONFIG_GET(flag/log_adminchat))
		log_admin("DSAY: [text]")

/proc/log_game(text)
	if (CONFIG_GET(flag/log_game))
		diary << "\[[time_stamp()]]GAME: [text]"

/proc/log_vote(text)
	if (CONFIG_GET(flag/log_vote))
		diary << "\[[time_stamp()]]VOTE: [text]"

/proc/log_access(text)
	if (CONFIG_GET(flag/log_access))
		diary << "\[[time_stamp()]]ACCESS: [text]"

/proc/log_say(text)
	if (CONFIG_GET(flag/log_say))
		diary << "\[[time_stamp()]]SAY: [text]"

/proc/log_prayer(text)
	if (CONFIG_GET(flag/log_prayer))
		diary << "\[[time_stamp()]]PRAY: [text]"

/proc/log_law(text)
	if (CONFIG_GET(flag/log_law))
		diary << "\[[time_stamp()]]LAW: [text]"

/proc/log_ooc(text)
	if (CONFIG_GET(flag/log_ooc))
		diary << "\[[time_stamp()]]OOC: [text]"

/proc/log_looc(text)
	if (CONFIG_GET(flag/log_ooc))
		diary << "\[[time_stamp()]]LOOC: [text]"

/proc/log_whisper(text)
	if (CONFIG_GET(flag/log_whisper))
		diary << "\[[time_stamp()]]WHISPER: [text]"

/proc/log_emote(text)
	if (CONFIG_GET(flag/log_emote))
		diary << "\[[time_stamp()]]EMOTE: [text]"

/proc/log_attack(text)
	if (CONFIG_GET(flag/log_attack))
		diaryofmeanpeople << "\[[time_stamp()]]ATTACK: [text]"

/proc/log_pda(text)
	if (CONFIG_GET(flag/log_pda))
		diary << "\[[time_stamp()]]PDA: [text]"

/proc/log_comment(text)
	if (CONFIG_GET(flag/log_pda))
		//reusing the PDA option because I really don't think news comments are worth a config option
		diary << "\[[time_stamp()]]COMMENT: [text]"

/proc/log_world(text)
	world.log << text

/proc/log_config(text)
	world.log << text

/proc/log_qdel(text)
//	WRITE_LOG(GLOB.world_qdel_log, "QDEL: [text]")
	world.log << text