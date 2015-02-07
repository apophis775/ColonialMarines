#define EXOSKELETON		1
#define ACID			2
#define STRUCTURE		3




/obj/machinery/xeno_analyzer
	name = "lifeform analyzer"
	desc = "Extracts lifeform data for weaponizing."
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "sextractor"
	density = 1
	anchored = 1
	var/scannedalien = 0
	var/geneticmaterial = 0
	var/geneticmaterialmax = 1000
	var/list/researched = list(0,0,0)
	var/researching = 0

/obj/machinery/xeno_analyzer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = O
		var/mob/living/carbon/alien/lifeform = G.affecting
		if(istype(lifeform, /mob/living/carbon/alien))
			user.drop_item()
			user << "<span class='notice'>You put the [lifeform] into the [src] and deconstruct it, analyzing its structure.</span>"
			var/amount = 0
			if(lifeform.stat != DEAD)
				amount += 100
			else
				amount += 50

			amount += round(lifeform.health / lifeform.maxHealth * 100)
			geneticmaterial = min(src.geneticmaterialmax, geneticmaterial + amount)
			scannedalien = 1
			del(lifeform)
		else
			user << "<span class='notice'>This isn't compatible with the [src]</span>"

	return

/obj/machinery/xeno_analyzer/attack_paw(user as mob)
	return src.attack_hand(user)

/obj/machinery/xeno_analyzer/attack_hand(user as mob)
	var/dat
	if (..())
		return
	dat = {"Exoskeleton Research Level: [researched[EXOSKELETON]]<BR>
	Acid Research Level: [researched[ACID]]<BR>
	Exoskeleton Research Level: [researched[STRUCTURE]]<BR><BR>
	"}
	if (src.researching != 0)
		dat += {"
<TT>Researching [src.researching].<BR>
Please wait until completion...</TT><BR>
<BR>
"}
	else
		if(scannedalien)
			dat += {"
	<B>Genetic Material:</B> [src.geneticmaterial]/[src.geneticmaterialmax]<BR><HR>
	<BR>
	<A href='?src=\ref[src];make=1'>Research Exoskeleton ([(100 + (researched[EXOSKELETON] * 100))])<BR>
	<A href='?src=\ref[src];make=2'>Research Acid ([(100 + (researched[ACID] * 100))])<BR>
	<A href='?src=\ref[src];make=3'>Research Structural Weakness([(100 + (researched[STRUCTURE] * 100))])<BR>
	"}
		else
			dat = {"You haven't scanned any compatible lifeforms. Nothing to research.
			"}
	user << browse("<HEAD><TITLE>Lifeform Analyzer Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=robot_fabricator")
	onclose(user, "robot_fabricator")
	return

/obj/machinery/xeno_analyzer/Topic(href, href_list)
	if (..())
		return

	usr.set_machine(src)
	src.add_fingerprint(usr)

	if (href_list["make"])
		researching = text2num(href_list["make"])
		if (src.researching != 0)
			var/amount = 100 + researched[researching] * 100
			if(geneticmaterial <= amount)
				spawn(100)
					geneticmaterial -= amount
					researched[researching] += 1
					researching = 0
			else
				usr << "You don't have enough genetic material"
				return

		return

	for (var/mob/M in viewers(1, src))
		if (M.client && M.machine == src)
			src.attack_hand(M)
