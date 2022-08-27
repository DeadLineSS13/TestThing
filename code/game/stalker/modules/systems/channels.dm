/*������� ������������� �������� ������� �� ����� ����

��� ����� ������ ���� ����������������� �������

1 - ticker.dm, preferences.dm, ����� �����
2 - playsound.dm, ������ � ����� ����� ������
3 - turnrable.dm, ��������
4-11 - blowout.dm, ����� ��� �������
12-14 - weather.dm, ����� �����
15-18 - ambient.dm, ����� ��������
19-20 - campfire.dm, ����� ������
21 - cars.dm, ����� ����������
22-30 - simulated.dm, ����� �����
31 - life.dm, ���� ������� ������
32 - geiger_counter.dm, ���� �������� �������
33 - sounded.dm, ��� ����
34 - dyatel.dm, ��� �����(��������)
35 - guards.dm, �����

��� �� � ����� sounded.dm ������������� ���������� ������, �� ��� �������������

*/
SUBSYSTEM_DEF(channels)
	name = "Channels management"
	flags = SS_NO_FIRE

	var/list/reserved_channels = list()
	var/list/channels = list()

//datum/controller/subsystem/channels/stat_entry()
//	..("CH:[channels.len]")

/datum/controller/subsystem/channels/proc/get_reserved_channel(forced_channel = 0)
	if(forced_channel)
		if(!reserved_channels[num2text(forced_channel)])
			reserved_channels[num2text(forced_channel)] = 1
		return forced_channel
	for(var/i = 1 to 124)
		if(!reserved_channels["[i]"])
			reserved_channels["[i]"] = 1
			return i

/datum/controller/subsystem/channels/proc/get_channel(time_till_remove)
	for(var/i = 125 to 1024)
		if(!channels["[i]"])
			channels["[i]"] = 1
			spawn(time_till_remove)
				channels.Remove("[i]")
			return i