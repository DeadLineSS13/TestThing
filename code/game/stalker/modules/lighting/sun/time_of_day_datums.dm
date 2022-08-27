/datum/time_of_day
	var/name = ""
	var/color = ""
	var/duration = 300

/datum/time_of_day/day_sunny
	name = "Sunny Day"
	color = "#FFFFFF"
	duration = 9000

/datum/time_of_day/day_cloudly
	name = "Cloudly Day"
	color = "#afafaf"
	duration = 9000

/datum/time_of_day/morning_sunny
	name = "Morning"
	color = "#808599"
	duration = 4500

/datum/time_of_day/morning_cloudly
	name = "Morning"
	color = "#585c69"
	duration = 4500

/datum/time_of_day/evening_sunny
	name = "Evening"
	color = "#FFA891"
	duration = 4500

/datum/time_of_day/evening_cloudly
	name = "Evening"
	color = "#af7464"
	duration = 4500

/datum/time_of_day/night_sunny
	name = "Bright Night"
	color = "#050d29"
	duration = 9000

/datum/time_of_day/night_cloudly
	name = "Dark Night"
	color = "#000000"
	duration = 9000

var/day=1
var/month=1
//var/year=2255

proc/dodaychange()
	day+=1
	if(day>=31)
		month+=1
		day=1