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
	msg += "����� �������: [total_steps]<br>"
	msg += "��������� �������: [items_sold]<br>"
	msg += "��������� �������: [items_bought]<br>"
	msg += "���������� ����� ��������: [money_earned_by_players]<br>"
	msg += "���������� �������: [artefacts_picked]<br>"
	msg += "�������� ������������: [anomalies_triggered]<br>"
	msg += "�������� ��������� : [blowouts_happened]<br>"

	world << msg

	return