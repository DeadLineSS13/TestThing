/*
 * Paper
 * also scraps of paper
 *
 * lipstick wiping is in code/game/objects/items/weapons/cosmetics.dm!
 */

/obj/item/weapon/paper
	name = "paper"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	throwforce = 0
	w_class = 1
	throw_range = 1
	throw_speed = 1
	layer = 3
	pressure_resistance = 0
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	burn_state = FLAMMABLE
	burntime = 5

	var/info		//What's actually written on the paper.
	var/info_links	//A different version of the paper which includes html links at fields and EOF
	var/stamps		//The (text for the) stamps on the paper.
	var/fields		//Amount of user created fields
	var/list/stamped
	var/rigged = 0
	var/spam_flag = 0


/obj/item/weapon/paper/New()
	..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)
	spawn(2)
//		update_icon()
		updateinfolinks()


/obj/item/weapon/paper/examine(mob/user)
	..()
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/paper)
	assets.send(user)

	if(in_range(user, src) || isobserver(user))
		if( !(ishuman(user) || isobserver(user)) )
			user << browse("<HTML><meta charset=\"utf-8\"><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[stars(info)]<HR>[stamps]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
		else
			user << browse("<HTML><meta charset=\"utf-8\"><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[info]<HR>[stamps]</BODY></HTML>", "window=[name]")
			onclose(user, "[name]")
	else
		user << "<span class='notice'>It is too far away.</span>"


/obj/item/weapon/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr

	if(usr.stat || !usr.canmove || usr.restrained())
		return

	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.disabilities & CLUMSY && prob(25))
		H << "<span class='warning'>You cut yourself on the paper! Ahhhh! Ahhhhh!</span>"
		H.damageoverlaytemp = 9001
		return
	var/n_name = sanitize_russian(stripped_input(usr, "What would you like to label the paper?", "Paper Labelling", null, MAX_NAME_LEN))
	if((loc == usr && usr.stat == 0))
		name = sanitize_russian("paper[(n_name ? text("- '[n_name]'") : null)]", 1)
	add_fingerprint(usr)

/obj/item/weapon/paper/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] scratches a grid on their wrist with the paper! It looks like \he's trying to commit sudoku..</span>")
	return (BRUTELOSS)

/obj/item/weapon/paper/attack_self(mob/user)
	user.examinate(src)

/obj/item/weapon/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(1)	//I know this can cause infinite loops and fuck up the whole server, but the if(istart==0) should be safe as fuck
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)

		if(istart == 0)
			return	//No field found with matching id

		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)

			//textindex = istart+26
			textindex = iend
			break

	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()


/obj/item/weapon/paper/proc/updateinfolinks()
	info_links = info
	var/i = 0
	for(i=1,i<=fields,i++)
		addtofield(i, "<font face=\"[PEN_FONT]\"><A href='?src=\ref[src];write=[i]'>write</A></font>", 1)
	info_links = info_links + "<font face=\"[PEN_FONT]\"><A href='?src=\ref[src];write=end'>write</A></font>"


/obj/item/weapon/paper/proc/clearpaper()
	info = null
	stamps = null
	stamped = list()
	overlays.Cut()
	updateinfolinks()
	update_icon()


/obj/item/weapon/paper/proc/parsepencode(t, obj/item/weapon/pen/P, mob/user, iscrayon = 0)
	if(length(t) < 1)		//No input means nothing needs to be parsed
		return

//	t = copytext(t,1,MAX_MESSAGE_LEN)
	t = dd_replaceText(t, "\[center\]", "<center>")
	t = dd_replaceText(t, "\[/center\]", "</center>")
	t = dd_replaceText(t, "\[br\]", "<BR>")
	t = dd_replaceText(t, "\[b\]", "<B>")
	t = dd_replaceText(t, "\[/b\]", "</B>")
	t = dd_replaceText(t, "\[i\]", "<I>")
	t = dd_replaceText(t, "\[/i\]", "</I>")
	t = dd_replaceText(t, "\[u\]", "<U>")
	t = dd_replaceText(t, "\[/u\]", "</U>")
	t = dd_replaceText(t, "\[large\]", "<font size=\"4\">")
	t = dd_replaceText(t, "\[/large\]", "</font>")
	t = dd_replaceText(t, "\[sign\]", "<font face=\"[SIGNFONT]\"><i>[user.real_name]</i></font>")

	if(!iscrayon)
		t = dd_replaceText(t, "\[*\]", "<li>")
		t = dd_replaceText(t, "\[hr\]", "<HR>")
		t = dd_replaceText(t, "\[small\]", "<font size = \"1\">")
		t = dd_replaceText(t, "\[/small\]", "</font>")
		t = dd_replaceText(t, "\[list\]", "<ul>")
		t = dd_replaceText(t, "\[/list\]", "</ul>")

		t = "<font face=\"[PEN_FONT]\">[t]</font>"

//	t = dd_replaceText(t, "#", "") // Junk converted to nothing!
	return t


/obj/item/weapon/paper/proc/openhelp(mob/user)
	user << browse({"<HTML><HEAD><TITLE>Pen Help</TITLE></HEAD>
	<BODY>
		<b><center>Crayon&Pen commands</center></b><br>
		<br>
		\[br\] : Creates a linebreak.<br>
		\[center\] - \[/center\] : Centers the text.<br>
		\[b\] - \[/b\] : Makes the text <b>bold</b>.<br>
		\[i\] - \[/i\] : Makes the text <i>italic</i>.<br>
		\[u\] - \[/u\] : Makes the text <u>underlined</u>.<br>
		\[large\] - \[/large\] : Increases the <font size = \"4\">size</font> of the text.<br>
		\[sign\] : Inserts a signature of your name in a foolproof way.<br>
		<br>
		<b><center>Pen exclusive commands</center></b><br>
		\[small\] - \[/small\] : Decreases the <font size = \"1\">size</font> of the text.<br>
		\[list\] - \[/list\] : A list.<br>
		\[*\] : A dot used for lists.<br>
		\[hr\] : Adds a horizontal rule.
	</BODY></HTML>"}, "window=paper_help")


/obj/item/weapon/paper/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return

	if(href_list["write"])
		var/id = href_list["write"]
		var/t =  sanitize_russian(stripped_multiline_input("Enter what you want to write:", "Write"),1)
		if(!t)
			return
		var/obj/item/i = usr.get_active_held_item()	//Check to see if he still got that darn pen, also check if he's using a crayon or pen.

		if(!in_range(src, usr) && loc != usr && usr.get_active_held_item() != i)	//Some check to see if he's allowed to write
			return
		t = parsepencode(t, i, usr, 0) // Encode everything from pencode to html
		if(t != null)	//No input from the user means nothing needs to be added
			if(id!="end")
				addtofield(text2num(id), t) // He wants to edit a field, let him.
			else
				info += t // Oh, he wants to edit to the end of the file, let him.
				updateinfolinks()

			usr << browse("<HTML><meta charset=\"utf-8\"><HEAD><TITLE>[name]</TITLE></HEAD><BODY>[info_links]<HR>[stamps]</BODY></HTML>", "window=[name]") // Update the window
			update_icon()


/obj/item/weapon/paper/attackby(obj/item/weapon/P, mob/living/carbon/human/user, params)
	..()

	if(burn_state == ON_FIRE)
		return

	if(is_blind(user))
		return

	if(P.is_hot())
		if(user.disabilities & CLUMSY && prob(10))
			user.visible_message("<span class='warning'>[user] accidentally ignites themselves!</span>", \
								"<span class='userdanger'>You miss the paper and accidentally light yourself on fire!</span>")
			user.unEquip(P)
			user.IgniteMob()
			return

		if(!(in_range(user, src))) //to prevent issues as a result of telepathically lighting a paper
			return

		user.unEquip(src)
		user.visible_message("<span class='danger'>[user] lights [src] ablaze with [P]!</span>", "<span class='danger'>You light [src] on fire!</span>")
		fire_act()



	add_fingerprint(user)


/obj/item/weapon/paper/bloody
	icon_state = "scrap_bloodied"
	info = "пиши сюда свое гавно если хочешь"

/obj/item/weapon/paper/bloody2
	icon_state = "scrap_bloodied"
	info = "пиши сюда свое гавно если хочешь2"

/obj/item/weapon/paper/eballat
	icon_state = "eballat"
	info = {"
	<br>
	<b>Аппендицит</b>: артефакт, изредка выпадающий из убитых мутантов-клонов (мясные хуевины), при пассивном ношении высасывает силы (стамина восстанавливается на ~25% медленнее), но ускоряет выздоровление (1 хп в минуту); Сжатие, Удар и Порез вызывают мгновенную "гибель" Аппендицита - будет дополнительный спрайт appendix_dead для этого состояния. В нем он теряет все свои эффекты, а также ценность. Потирание вызывает временное усиление эффекта - на 2д6 минут Аппендицит начинает жрать 50% восстановления стамины, но выздоровление ускоряется до 3 хп в минуту, после окончания эффекта Аппендицит также "гибнет". Тряска и Лизь ничего не вызывают. На вкус "как сырое мясо".<br>
	<br>
	<b>Зеленый воск</b>: - артефакт с необычным способом появления. Его должно быть возможным выкопать из земли в тех местах, где до прошлого выброса были лужи Ведьминого студня - т.е. надо запомнить места, взять лопату и выкопать. Один воск включает в себя после выкапывания 2д6 порций, и его можно делить. Каждую порцию можно либо нанести на открытую часть тела, ткнув человека комком (лечит в минуту 3 единицы ожогового урона, но не обычного), либо можно проглотить, ткнув на рот мобу (должно выводить радиацию из организма и защищать от получения новой)). Остальные действия ничего не принесут, если Лизнуть - на вкус будет "никаким, безвкусным".<br>
	<br>
	<b>Мозаика</b>: артефакт, выглядящий как осколок витражного синего стекла, можно найти возле электрических аномалий. Пассивный эффект - дает 2 брони всему телу против обжигающего урона (и от молний, и от жарок, и от обжигающих кислот), но Ловкость снижается на 1 за каждую Мозаику. Неэффективен против Ведьминого Студня. Таким образом, набив полный пояс и карманы мозаик, можно будет ловить очень мало либо вообще ноль урона от некоторых аномалий. Нет никаких активных эффектов, если Лизнуть - на вкус будет "как пыльное бутылочное стекло".<br>
	<br>
	<b>Пузырь</b>: артефакт, спавнящийся изредка возле Воронок. Пассивный эффект - снижает общую нагрузку на 10 кг (весит -10 кг, считай, при осмотре должно писаться таким вещам "ощущается невесомым" вместо "много меньше килограмма"). Активный - при Порезе мгновенно взрывается, образуя Воронку на своем месте, которая сразу активируется и исчезает после окончания действия, при Сжимании либо Потрясти сначала теплеет, через д6 секунд включается анимация puzir-use и генерируется Плешь с максимальным умножением веса и средними размерами. Это длится в течение 2д6х5 секунд, после чего Пузырь лопается и исчезает вместе с Плешью. Если Лизнуть, на вкус будет "как земля"..<br>
	<br>
	<b>Кристальная Кровь</b>: артефакт, спавнящийся возле огненных аномалий. Пассивный эффект - Кровотечения закрываются сами через четверть минуты, без нужды использовать бинты, и стамина восстанавливается на 25% быстрее, но голод и жажда набираются на 50% быстрее. Активный - при Потирании врубается анимация, и следующие д6 минут артефакт дает владельцу 10 брони от обжигающего урона, мгновенно закрывает кровоточащие раны при их появлении, повышает восстановление стамины на 50% вместо 25%, но голод и жажда набираются на 200% быстрее (т.е. х3 нахуй). После окончания работы в активированном состоянии, с шансом в 40% разрушается, если не разрушился - можно пользоваться дальше. Если Ударить - также включается анимация, однако, эффект иной, по истечению д6 секунд кристалл взрывается, нанося 1д6+1 урона огнем в каждую часть тела всем в радиусе 3 тайлов и поджигая их. Если Лизнуть - на вкус "как теплое стекло".<br>
	<br>
	<b>Изумруд</b>: артефакт, спавнящийся в Студне. Пассивный эффект - повышает Интеллект и Ловкость на 1, но каждую минуту совершается проверка Здоровья, при провале наносится 1 урона токсинами, при критпровале - падаешь в конвульсиях на некоторое время. Активный - при Ударе совершается проверка Силы с -4, с -2 при использовании предмета, если проверка успешна - в чат пишет, что на артефакте появляется трещина, из которой течет зеленый дым, после чего через 2д6 секунд Изумруд разрушается, выпуская облака едкого газа, эквивалентного газу Ржавой лужи, но только зеленого цвета вместо рыжего. Если лизнуть, на вкус будет "как шершавый пластик".<br>
	<br>
	<b>Корень</b>: артефакт, иногда появляющийся в определенных зонах после Выброса, является видоизмененным растением. Пассивный эффект отсутствует, Активный - при съедании на 2д6 минут дает регенерацию 3 хп в минуту, эффект усиливается до 5 хп в минуту, если предварительно Сжать корень, но после употребления на 2д6 минут Сила, Интеллект и Ловкость понижаются на 1 (лишь если Корень был сжат для доп. хила). При этом, никаких надписей, указывающих на изменение эффекта, не должно быть после Сжатия. На вкус "как свежий огурец".<br>
	<br>
	<b>Радио</b>: очень редко в индустриальных зонах можно будет найти такие вот "радио". Артефакт должен издавать статические шумы, а также изредка передавать чьи-то слова, являющиеся наборами случайных слов, и с очень маленьким шансом (крит. успех на броске 3д6) - какую-нибудь полезную информацию, вроде "... э-эй... друг... покопайся в земле... где были лужи голубой едкой жидкости... после того, как они исчезнут с выбросом...". Если радио Порезать - открывается мясистый кокон наверху, после чего радио умолкает и больше ничего не говорит, а маленький артефакт можно из этого кокона забрать. Этот артефакт - Мячик.<br>
	<br>
	<b>Мячик</b>: пассивный эффект выражается в способности читать чужие мысли, экзаминя других персонажей, если на них не надето шлемов (именно защитных, не головных уборов), также повышает Интеллект на 1, но Ловкость падает на 2. Чтение мыслей должно выражаться в том, что когда экзаминишь персонажа, то в чат также пишет одну из фраз, что он сказал до этого в течение последней четверти часа, также может написаться описание одного из его атрибутов (т.е., если экзаминишь чувака с Х интеллекта, может написать в чат тот же текст, что этот персонаж видит, когда кликает на интерфейсе на отображатель инты). Если лизнуть, на вкус "как жвачка, которую кто-то жевал".<br>
	<br>
	<b>Чертов Рог</b>: артефакт, спавнящийся возле жарок. Пассивный эффект - повышает все атрибуты на 1, НО ПРИ ЭТОМ, накладывает на все проверки штраф -3, и атрибутов, и навыков, таким образом тебе кажется, что он тебя баффает, а на деле ты страдаешь. При Встряске, артефакт сначала нагревается, а потом через д6 секунд разрушается, создавая на своем месте жарку (и мгновенно сжигая владельца, если не выпустить артефакт), а также еще 1д6 рандомных жарок в области 5 х 5 с центром на месте, где был артефакт. Если таким образом реализовать слишком ебля - тупо сделать каждому тайлу в упомянутом квадрате 5 х 5 шанс 15% образоваться жарке. Все жарки исчезнут через 2д6 минут. На вкус - "как теплый камень".<br>
	<br>
	<b>Корсар</b>: артефакт, появляющийся только возле Демонов, а не обычных жарок, является своеобразной идеальной версией Чертова Рога, и дает +1 ко всем атрибутам без штрафов. Однако, каждый раз, когда персонаж получает физический урон (от гравианомалий, пуль, ножей и т.д.), совершается бросок д6, и при выпадении 6 персонаж загорается; если персонаж умирает с Корсаром, то сразу сгорает в пепел со всеми не-артефактными вещами. При Встряске, поджигает владельца. На вкус такой же, как и Чертов Рог - "как теплый камень".<br>
	<br>
	<b>Шип</b>: появляется В ЦЕНТРЕ Петли Мебиуса, один из немногих артефактов без плохих свойств, дает +2 к Здоровью. Если Лизнуть - наносит 1 урона голове, и пишет "Ай! Укололся...", если Сжать или Ударить голой рукой - наносит 1 урона в руку, и пишет то же самое. Эту хуйню хрен достанешь, она должна пропадать с Выбросом, если не поднята с земли, так что придется очень люто рискнуть жопой, если хочется забрать.<br>
	<br>
	<b>Кирпич</b>: появляется возле Разрядника с очень низким шансом. Пассивный эффект - дает +2 к проверкам Осмотра, а также накладывает дополнительный штраф в -2 на все броски попадания по владельцу из огнестрельного оружия, однако, сам владелец получает -4 на все проверки стрельбы из огнестрельного оружия, а также раз в д6 минут бьет током, нанося в случайную часть тела 1 ожогового урона, и в чат раз в минуту пишет "Проклятье... все тело зудит.", "Ни секунды покоя из-за этого зуда...", "Ар-ргх. Лишь бы этот чертов зуд прекратился!". Если Ударить, совершается проверка Силы с -4, с -2 при использовании предмета, при успехе - артефакт просто разрушается; если Встряхнуть - сразу же бьет током на 1 урона, если Лизнуть - пишет то же самое, что и Запзап, и тоже наносит 1 урона в голову.<br>
	<br>
	<b>Запзап</b>: появляется только из "разозленных" тесл после их исчезновения, с шансом в 40%. Пассивный эффект - понижает Здоровье на 2 и удваивает урон от электрических атак, но повышает Силу и Ловкость на 1, регенерацию Стамины - на 25%. Если лизнуть - наносит 1д6 обжигающего урона в голову, и пишет "А-А-АЙ! МОЙ ЯЗЫК! С-сука, током бьет...", если Ударить - совершается проверка Силы с -6, с -4 при использовании предмета, если успешна - владельца мгновенно сжигает в пепел, а на его месте появляется новая обычная Тесла.<br>
	<br>
	<b>Крот</b>: иногда появляется рядом с Ржавой лужей. Пассивный эффект - повышает Силу и Здоровье на 1, но при ранении владельца совершается бросок д6, при выпадении 6 артефакт выпускает клубы ржавого дыма, такого же, как и у ржавой лужи, но меньше (лишь 3 на 3). Если Сжать, издает писк. Если Порезать - разрушается, выпуская полноценное ржавое облако 5х5. Если Потрясти - бонусы к атрибутам увеличатся до 2, но шанс Крота лопнуть при ранении владельца возрастает до 5-6 (т.е. если выпадает 5-6 на д6 то артефакт взрывается), и когда артефакт лопается, то наносит владельцу урон, эквивалентный Трамплину, также распространяя ржавое облако 5х5. На вкус "как гниль... пфу, тьфе, гадость."<br>
	<br>
	<b>МАСКА ДЖОКЕРА</b>: то есть, маска клоуна, крайне редкая хуйня которая должна спавниться в некоторых домах жилых, дает полную защиту от вдыхаемых токсинов, а также позволяет видеть СПИНОЙ; также дает +2 к броскам осмотра. Однако, если проносить дольше, чем 20 минут подряд, ее становится невозможно отцепить, а все мобы выглядят как мутанты, включая людей. Энджой клоунада!<br>
	<br>
	<b>Огненная звезда</b>: появляется рядом с жарками в редких случаях. При попытке взять, наносит в руку 1 обжигающего урона, если этот урон прошел (т.е. у владельца нет перчаток на руке или артефакта дающего защиту от огненного урона) - происходит проверка Здоровья, при провале артефакт падает на землю, при успехе артефакт остается в руке, но урон наносится каждые 10 секунд, после чего вновь происходит проверка если урон в руку прошел. Пассивный эффект - по умолчанию отсутствует, однако, будет очень дорого стоить и также будет являться очень мощным катализатором для некоторых других артефактов. Если потереть - через д6 секунд резко увеличивает температуру, нанося держащему его либо стоящему на одном тайле с ним человеку 10 обжигающего урона в каждую часть тела каждую секунду, в радиусе 1 тайла - 8 урона, в радиусе 2 - 4 урона, в радиусе 3 - 2 урона. Персонаж, державший артефакт, в любом случае роняет его и не может поднять, пока тот не остынет.  Каждую минуту, наносимый во всех радиусах урон снижается на 2, покуда через 5 минут урон в том же тайле что и артефакт не достигнет 0; с этого момента, его можно снова поднять и он будет действовать как и раньше. Также в тайлах, где наносится урон, все объекты и мобы должны загораться. Если ударить, совершается проверка Силы с -6, с -4 при использовании предмета, если успешна - происходит взрыв, урон которого пропишем позднее (примечание - правильно настроенные ссочные взрывы все еще работают неплохо даже с гурпсом, я уже это тестировал с рпг-снарядами, которые при правильном расчете наносят ровно столько урона сколько и надо по гурпсу)<br>
	<br>
	<b>Хлам и Мусор</b>: Два немного различающихся артефакта, спавнящихся возле магнитных аномалий (сами они при этом не должны быть подвержены намагничиванию). Хлам (Trash) является "неактивным" вариантом Мусора (Garbage), и о нем будет дописано отдельно. Мусор издает с периодичностью в д6х5 секунд неприятные скрежещущие звуки, а также раз в д6 минут должен "поглощать" из вещей владельца рандомные мелкие металлические предметы (магазины, горсти вытащенных патронов, ножи), в будущем этот эффект должно быть возможно остановить при наличии контейнера. Потерянные предметы невосстановимы, ничего крупнее магазина не должен быть способен "поглотить". Хлам, в отличие от Мусора, имеет вдвое более долгие периоды между указанными эффектами (скрежет лишь раз в д6х10 секунд, предметы ворует каждые д6х2 секунд). Пассивный эффект на владельца - снижает Здоровье на 2, а все выстрелы и атаки металлическим холодным оружием по носителю получают +2 на попадание. Эффекты вдвое ниже для Хлама (-1 к Здоровью и +1 на попадание). Полезных эффектов по умолчанию нет - основной его прикол наступает в других ситуациях. Если ударить Мусор (не Хлам!), совершается проверка Силы с -4, с -2 при использовании предмета, если успешна - Мусор с анимацией garbage-use рассыпается в труху, оставляя после себя д6 рандомных патронов и д6х2 рандомных гильз, гаек и прочего хлама.Если лизнуть Мусор или Хлам, на вкус будет "как ржавый, грязный металлолом... тьфу, блять.". ОДНАКО! Если носить Мусор/Хлам в карманах или одном сторейдже с некоторыми определенными электрическими артефактами (Запзап/Кирпич как пример, т.к. они подразумевают наличие в себе скрытого заряда, но не неактивная Мозаика), он перестает "поглощать" металлические вещицы владельца, а бонус на попадание по владельцу сменяется на штраф, обратный бонусу (т.е. если носить в одном кармане Запзап, а в другом Мусор, то вместо +2 на попадание по владельцу артефактов будет штраф -2). ТАКЖЕ! Если положить Мусор/Хлам в один сторейдж/карманы с большинством "активных" ОГНЕННЫХ артефактов, таким как Огненная звезда, Корсар, Чертов рог или Кристальная кровь после потирания (т.е. когда у нее включена искрящаяся анимация, а в обычном состоянии такого эффекта не будет), то при ношении вместе в течение больше минуты происходит взрыв, уничтожающий оба артефакта!<br>
	<br>
	<b>Шкатулка</b>: эта маленькая коробочка хранит в себе другой, очень ценный артефакт, но может быть открыта лишь если шепотом сказать, держа ее в активной руке, "Поделись со мной". Охуеть секретно? Охуеть секретно! Однако, ингейм будет способ узнать о таком необычном методе открывания, в частности о нем должно быть возможно узнать из передач по Радио, в числе тех что говорят правдивые советы. Никаких других эффектов нет, совершенно. Появляется в некоторых уникальных местах, вроде подземных лабораторий, и не спавнится от обычных аномалий.<br>
	<br>
	<b>Панцирь</b>: редкий артефакт, появляющийся только в зонах, где будут повышенные шансы спавна и электрических, и токсичных аномалий (хотя бы пару таких зон раскидаем), не зависит непосредственно от аномалий - лишь от зон, где они есть. Пассивный эффект - издает низкий гул, который вызывает у всех в пределах видимости, кроме людей, уже носящих Панцирь, штраф в -1 к Ловкости и Интеллекту (штраф возрастает до -2 к каждому атрибуту в радиусе 3 тайлов), а также надписи в чат "Мне тошно...", "Укачивает...", "Как плохо..." с частотой в д6х2 секунд. Носитель, однако, каждые 15 минут должен совершать проверку Здоровья, при провале он получает НАКОПИТЕЛЬНЫЙ штраф к собственным Ловкости и Интеллекту в -1, вплоть до суммарного -4 к каждому атрибуту; этот штраф сохраняется и после того, как артефакт покидает владельца, постепенно снижаясь со скоростью -1 штрафа за 15 минут (т.е. полный штраф в -4 через час исчезнет); штраф, получаемый владельцем от ношения артефакта, СКЛАДЫВАЕТСЯ со штрафом, который накладывается, если он уже не имеет Панциря, но все еще находится рядом с ним, в сумме получая до -6 штрафа, если сначала проносил Панцирь так долго что получил -4 штраф, а потом отдал его товарищу, который теперь его носит в пределах 3 тайлов от бывшего владельца. Эффекты как для владельца, так и для мобов вокруг, неприменяются при помещении артефакта в контейнер. Продолжает издавать гул даже будучи вне инвентаря, на земле. Штрафы от нескольких Панцирей НЕ складываются как для владельца, так и для людей вокруг. Активных эффектов нет. Если лизнуть, на вкус будет "как вымазанный в земле пенопласт."<br>
	<br>
	<b>Батарейка</b>: данная хуета должна, как и Шкатулка, появляться только в лабораториях, подземке и прочих "технологичных" местах. Представляет собой бесконечный энергоисточник, что в будущем будет охуеть как полезно для некоторых девайсов. Имеет три состояния - закрытое, открытое и открытое активное. Всегда появляется по умолчанию в первом. Закрытая батарейка не имеет никаких эффектов, но если Потереть ее или Ударить - она перейдет во второе состояние. Открытая батарейка дает +1 к Силе, Здоровью и Ловкости, тонизируя организм, но каждую минуту совершается бросок 3д6 против значения в 12, если бросок провален (т.е. выпало 13 или выше) - персонаж получает -1 к Здоровью, данный штраф накопителен вплоть до -5, и исчезает со скоростью -1 штрафа в 5 минут, если артефакт снят с владельца или "закрыт". Чтобы закрыть, необходимо Потереть, в этом случае артефакт вновь переходит в первое состояние; если ударить, совершается проверка Силы с -2, без штрафа при использовании предмета, при успехе владельца мгновенно обращает в пепел, сама исчезает, а на ее месте появляется новая агрессивная Тесла. Если же Встряхнуть - переходит в активное состояние. Полизывание нанесет д6 обжигающего урона в голову. Открытая активная батарейка дает эффект обычной открытой, но также спустя д6х2 секунд после активации начинает биться током, нанося раз в две секунды д6 обжигающего урона в руку владельца (либо торс, если помещена в карман/рюкзак), покуда находится не внутри артефактного контейнера. Чтобы установить батарейку в качестве источника энергии, требуется сначала перевести ее именно в это состояние, в закрытом или обычном открытом она не производит энергии. Очень нестабильна в данном состоянии - Бросок активной батарейкой, Дроп на землю (не передача из рук в руки или перекладывание на стол), Удар, Встряхивание приведут к мгновенному испепелению ВСЕХ мобов в радиусе тайла от батарейки, сама батарейка разрушается и появляется две разных агрессивных Теслы.<br>
	<br>
"}