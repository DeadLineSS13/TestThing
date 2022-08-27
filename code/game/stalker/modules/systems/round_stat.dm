SUBSYSTEM_DEF(stat)
	name = "Round Statistic"
	flags = SS_NO_FIRE

	var/total_steps = 0
	var/items_sold = 0
	var/items_bought = 0
	var/money_earned_by_players = 0
	var/artefacts_picked = 0
	var/anomalies_triggered = 0
	var/blowouts_happened = 0

/datum/controller/subsystem/stat/proc/show_stat()
	var/msg
	msg += "ROUND STATISTIC<br>"
	msg += "Шагов сделано: [total_steps]<br>"
	msg += "Предметов продано: [items_sold]<br>"
	msg += "Предметов куплено: [items_bought]<br>"
	msg += "Заработано денег игроками: [money_earned_by_players]<br>"
	msg += "Артефактов собрано: [artefacts_picked]<br>"
	msg += "Аномалий активировано: [anomalies_triggered]<br>"
	msg += "Выбросов произошло : [blowouts_happened]<br>"

	world << msg

	return