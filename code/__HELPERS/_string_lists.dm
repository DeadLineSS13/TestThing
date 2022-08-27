#define pick_list(FILE, KEY) (pick(strings(FILE, KEY)))

GLOBAL_LIST_EMPTY(string_cache)

/proc/strings(filename as text, key as text)
	var/list/fileList
	if(!GLOB.string_cache)
		GLOB.string_cache = new
	if(!(filename in GLOB.string_cache))
		if(fexists("strings/[filename]"))
			GLOB.string_cache[filename] = list()
			var/list/stringsList = list()
			fileList = file2list("strings/[filename]")
			for(var/s in fileList)
				stringsList = text2list(s, "@=")
				if(stringsList.len != 2)
					CRASH("Invalid string list in strings/[filename]")
				if(findtext(stringsList[2], "@,"))
					GLOB.string_cache[filename][stringsList[1]] = text2list(stringsList[2], "@,")
				else
					GLOB.string_cache[filename][stringsList[1]] = stringsList[2] // Its a single string!
		else
			CRASH("file not found: strings/[filename]")
	if((filename in GLOB.string_cache) && (key in GLOB.string_cache[filename]))
		return GLOB.string_cache[filename][key]
	else
		CRASH("strings list not found: strings/[filename], index=[key]")
