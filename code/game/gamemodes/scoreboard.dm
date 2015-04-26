/datum/controller/gameticker/proc/scoreboard()
/*
	//calls auto_declare_completion_* for all modes
	for(var/handler in typesof(/datum/game_mode/proc))
		if (findtext("[handler]","auto_declare_completion_"))
			call(mode, handler)()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	// Score Calculation and Display
*/

//MARINES
	// Who is MIA
	for (var/mob/living/carbon/human/I in mob_list)
		if (I.stat == 2 && !I.z == 6)
			score_marines_mia += 1 //Bodies not on Sulaco are missing
	// Who is KIA
		if (I.stat == 2 && I.z == 6)
			score_marines_kia += 1
	// Who is alive
		if (!I.stat == 2)
			score_marines_survived += 1 //Marines alive

	for (var/mob/living/carbon/alien/K in mob_list) //Aliens killed
		if (K.stat == 2)
			score_aliens_killed += 1


	if (round_end_situation == 1)
		score_aliens_won = 1
	else if (round_end_situation == 2)
		score_marines_won = 1
	else if (round_end_situation == 4)
		score_aliens_won = 2
	else if (round_end_situation == 5)
		score_marines_won = 2

//ALIENS
	// Who is dead
	for (var/mob/living/carbon/alien/humanoid/A in mob_list)
		if (A.stat == 2 && !isqueen(A))
			score_aliens_dead += 1
	// Who is alive
		if (!A.stat == 2)
			score_aliens_survived += 1
	// Queens dead
		if (A.stat == 2 && isqueen(A))
			score_queens_dead += 1
	// Original Queen alive
		if (!A.stat == 2 && isqueen(A) && score_queens_dead == 0)
			score_queen_survived += 1

	// Check how many weeds there are
	for (var/obj/effect/alien/weeds/M in world)
		score_weeds_made += 1
/*
	for(var/mob/living/player in mob_list)
		if (player.client)
			if (player.stat != 2)
				var/turf/location = get_turf(player.loc)
				var/area/escape_zone = locate(/area/shuttle/escape/centcom)
				if (location in escape_zone)
					score_escapees += 1
*/

/*	var/cashscore = 0
	var/dmgscore = 0
	for(var/mob/living/carbon/human/E in mob_list)
		cashscore = 0
		dmgscore = 0
		var/turf/location = get_turf(E.loc)
		var/area/escape_zone = locate(/area/shuttle/escape/centcom)
		if(E.stat != 2 && location in escape_zone) // Escapee Scores
			for (var/obj/item/weapon/card/id/C1 in E.contents) cashscore += C1.money
			for (var/obj/item/weapon/spacecash/C2 in E.contents) cashscore += C2.worth
			for (var/obj/item/weapon/storage/S in E.contents)
				for (var/obj/item/weapon/card/id/C3 in S.contents) cashscore += C3.money
				for (var/obj/item/weapon/spacecash/C4 in S.contents) cashscore += C4.worth
//			for(var/datum/data/record/Ba in data_core.bank)
//				if(Ba.fields["name"] == E.real_name) cashscore += Ba.fields["current_money"]
			if (cashscore > score_richestcash)
				score_richestcash = cashscore
				score_richestname = E.real_name
				score_richestjob = E.job
				score_richestkey = E.key
			dmgscore = E.bruteloss + E.fireloss + E.toxloss + E.oxyloss
			if (dmgscore > score_dmgestdamage)
				score_dmgestdamage = dmgscore
				score_dmgestname = E.real_name
				score_dmgestjob = E.job
				score_dmgestkey = E.key
*/
/*
	var/nukedpenalty = 1000
	if (ticker.mode.config_tag == "nuclear")
		var/foecount = 0
		for(var/datum/mind/M in ticker.mode:syndicates)
			foecount++
			if (!M || !M.current)
				score_opkilled++
				continue
			var/turf/T = M.current.loc
			if (T && istype(T.loc, /area/security/brig)) score_arrested += 1
			else if (M.current.stat == 2) score_opkilled++
		if(foecount == score_arrested) score_allarrested = 1
*/
/*
		score_disc = 1
		for(var/obj/item/weapon/disk/nuclear/A in world)
			if(A.loc != /mob/living/carbon) continue
			var/turf/location = get_turf(A.loc)
			var/area/bad_zone1 = locate(/area)
			var/area/bad_zone2 = locate(/area/syndicate_station)
			var/area/bad_zone3 = locate(/area/wizard_station)
			if (location in bad_zone1) score_disc = 0
			if (location in bad_zone2) score_disc = 0
			if (location in bad_zone3) score_disc = 0
			if (!(A.loc.z in config.station_levels)) score_disc = 0
*/
/*
		if (score_nuked)
			for (var/obj/machinery/nuclearbomb/NUKE in machines)
				if (NUKE.r_code == "Nope") continue
				var/turf/T = NUKE.loc
				if (istype(T,/area/syndicate_station) || istype(T,/area/wizard_station) || istype(T,/area/solar)) nukedpenalty = 1000
				else if (istype(T,/area/security/main) || istype(T,/area/security/brig) || istype(T,/area/security/armoury) || istype(T,/area/security/checkpoint2)) nukedpenalty = 50000
				else if (istype(T,/area/engine)) nukedpenalty = 100000
				else nukedpenalty = 10000
*/
/*
	if (ticker.mode.config_tag == "infestation")
		for(var/datum/mind/M in ticker.mode:head_revolutionaries)
			foecount++
			if (!M || !M.current)
				score_opkilled++
				continue
			var/turf/T = M.current.loc
			if (istype(T.loc, /area/security/brig)) score_arrested += 1
			else if (M.current.stat == 2) score_opkilled++
		if(foecount == score_arrested) score_allarrested = 1
		for(var/mob/living/carbon/human/player in world)
			if(player.mind)
				var/role = player.mind.assigned_role
				if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director"))
					if (player.stat == 2) score_deadcommand++
*/


//MARINE SCORE
	var/marine_mia_points = score_marines_mia * 500
	var/marine_kia_points = score_marines_kia * 200
	var/marine_survived_points = score_marines_survived * 100
	var/marine_aliens_killed_points = score_aliens_killed * 250
	var/marine_hit_called_points = score_hit_called * 2000




//	var/researchpoints = score_researchdone * 30
//	var/eventpoints = score_eventsendured * 50
//	var/escapoints = score_escapees * 25 //done
//	var/harvests = score_stuffharvested * 5 //done
//	var/shipping = score_stuffshipped * 5
//	var/mining = score_oremined * 2 //done
//	var/meals = score_meals * 5 //done, but this only counts cooked meals, not drinks served
//	var/power = score_powerloss * 20
//	var/messpoints
//	if (score_mess != 0) messpoints = score_mess //done
//	var/plaguepoints = score_disease * 30
/*
	// Mode Specific
	if (ticker.mode.config_tag == "nuclear")
		if (score_disc) score_crewscore += 500
		var/killpoints = score_opkilled * 250
		var/arrestpoints = score_arrested * 1000
		score_crewscore += killpoints
		score_crewscore += arrestpoints
		if (score_nuked) score_crewscore -= nukedpenalty

	if (ticker.mode.config_tag == "revolution")
		var/arrestpoints = score_arrested * 1000
		var/killpoints = score_opkilled * 500
		var/comdeadpts = score_deadcommand * 500
		if (score_traitorswon) score_crewscore -= 10000
		score_crewscore += arrestpoints
		score_crewscore += killpoints
		score_crewscore -= comdeadpts
*/
//Calculate Marine Good Things
	score_marinescore += marine_aliens_killed_points
	score_marinescore += marine_survived_points
//	score_marinescore += escapoints

//Calculate Marine Bad Things
	score_marinescore -= marine_mia_points
	score_marinescore -= marine_kia_points
	score_marinescore -= marine_hit_called_points


//	if (score_deadaipenalty) score_crewscore -= 250
//	score_crewscore -= power
	//if (score_crewscore != 0) // Dont divide by zero!
	//	while (traitorwins > 0)
	//		score_crewscore /= 2
	//		traitorwins -= 1
//	score_crewscore -= messpoints
//	score_crewscore -= plaguepoints



//ALIEN SCORE
	var/alien_survived_points = score_aliens_survived * 200
	var/alien_queen_survived_points = score_queen_survived * 5000
	var/alien_dead_points = score_aliens_dead * 500
	var/alien_queens_dead_points = score_queens_dead * 2000
	var/alien_eggs_made_points = score_eggs_made * 25
	var/alien_weeds_made_points = score_weeds_made * 2
	var/alien_hosts_infected_points = score_hosts_infected * 100

//Calculate Alien Good Things
	score_alienscore += alien_survived_points
	score_alienscore += alien_queen_survived_points
	score_alienscore += alien_eggs_made_points
	score_alienscore += alien_weeds_made_points
	score_alienscore += alien_hosts_infected_points

//Calculate Alien Bad Things
	score_alienscore -= alien_dead_points
	score_alienscore -= alien_queens_dead_points



	// Show the score - might add "ranks" later
	world << "<b>The game final score is:</b>"
	world << "<b><font size='4'>[score_marinescore - score_alienscore]</font></b>"
	for(var/mob/E in player_list)
		if(E.client) E.scorestats()
	return



/mob/proc/scorestats()
	var/dat = {"<B>Round Statistics and Score</B><BR><HR>"}
	/*
	if (ticker.mode.name == "nuclear emergency")
		var/foecount = 0
		var/crewcount = 0
		var/diskdat = ""
		var/bombdat = null
		for(var/datum/mind/M in ticker.mode:syndicates)
			foecount++
		for(var/mob/living/C in world)
			if (!istype(C,/mob/living/carbon/human) || !istype(C,/mob/living/silicon/robot) || !istype(C,/mob/living/silicon/ai)) continue
			if (C.stat == 2) continue
			if (!C.client) continue
			crewcount++
*//*
		for(var/obj/item/weapon/disk/nuclear/N in world)
			if(!N) continue
			var/atom/disk_loc = N.loc
			while(!istype(disk_loc, /turf))
				if(istype(disk_loc, /mob))
					var/mob/M = disk_loc
					diskdat += "Carried by [M.real_name] "
				if(istype(disk_loc, /obj))
					var/obj/O = disk_loc
					diskdat += "in \a [O.name] "
				disk_loc = disk_loc.loc
			diskdat += "in [disk_loc.loc]"
			break // Should only need one go-round, probably
		var/nukedpenalty = 0
		for(var/obj/machinery/nuclearbomb/NUKE in world)
			if (NUKE.r_code == "Nope") continue
			var/turf/T = NUKE.loc
			bombdat = T.loc
			if (istype(T,/area/syndicate_station) || istype(T,/area/wizard_station) || istype(T,/area/solar/) || istype(T,/area)) nukedpenalty = 1000
			else if (istype(T,/area/security/main) || istype(T,/area/security/brig) || istype(T,/area/security/armoury) || istype(T,/area/security/checkpoint2)) nukedpenalty = 50000
			else if (istype(T,/area/engine)) nukedpenalty = 100000
			else nukedpenalty = 10000
			break
		if (!diskdat) diskdat = "Uh oh. Something has fucked up! Report this."
		dat += {"<B><U>MODE STATS</U></B><BR>
		<B>Number of Operatives:</B> [foecount]<BR>
		<B>Number of Surviving Crew:</B> [crewcount]<BR>
		<B>Final Location of Nuke:</B> [bombdat]<BR>
		<B>Final Location of Disk:</B> [diskdat]<BR><BR>
		<B>Operatives Arrested:</B> [score_arrested] ([score_arrested * 1000] Points)<BR>
		<B>Operatives Killed:</B> [score_opkilled] ([score_opkilled * 250] Points)<BR>
		<B>Station Destroyed:</B> [score_nuked ? "Yes" : "No"] (-[nukedpenalty] Points)<BR>
		<B>All Operatives Arrested:</B> [score_allarrested ? "Yes" : "No"] (Score tripled)<BR>
		<HR>"}
		*/
		/*
//		<B>Nuclear Disk Secure:</B> [score_disc ? "Yes" : "No"] ([score_disc * 500] Points)<BR>
	if (ticker.mode.name == "revolution")
		var/foecount = 0
		var/comcount = 0
		var/revcount = 0
		var/loycount = 0
		for(var/datum/mind/M in ticker.mode:head_revolutionaries)
			if (M.current && M.current.stat != 2) foecount++
		for(var/datum/mind/M in ticker.mode:revolutionaries)
			if (M.current && M.current.stat != 2) revcount++
		for(var/mob/living/carbon/human/player in world)
			if(player.mind)
				var/role = player.mind.assigned_role
				if(role in list("Captain", "Head of Security", "Head of Personnel", "Chief Engineer", "Research Director"))
					if (player.stat != 2) comcount++
				else
					if(player.mind in ticker.mode:revolutionaries) continue
					loycount++
		for(var/mob/living/silicon/X in world)
			if (X.stat != 2) loycount++
		var/revpenalty = 10000
		dat += {"<B><U>MODE STATS</U></B><BR>
		<B>Number of Surviving Revolution Heads:</B> [foecount]<BR>
		<B>Number of Surviving Command Staff:</B> [comcount]<BR>
		<B>Number of Surviving Revolutionaries:</B> [revcount]<BR>
		<B>Number of Surviving Loyal Crew:</B> [loycount]<BR><BR>
		<B>Revolution Heads Arrested:</B> [score_arrested] ([score_arrested * 1000] Points)<BR>
		<B>Revolution Heads Slain:</B> [score_opkilled] ([score_opkilled * 500] Points)<BR>
		<B>Command Staff Slain:</B> [score_deadcommand] (-[score_deadcommand * 500] Points)<BR>
		<B>Revolution Successful:</B> [score_traitorswon ? "Yes" : "No"] (-[score_traitorswon * revpenalty] Points)<BR>
		<B>All Revolution Heads Arrested:</B> [score_allarrested ? "Yes" : "No"] (Score tripled)<BR>
		<HR>"}
		*/
//Aliens
	dat += {"<B><U>ALIEN STATS</U></B><BR>
	<U>THE GOOD:</U><BR>"}
	var/alien_win_message
	if (score_aliens_won == 0)
		alien_win_message = "Failed"
	if (score_aliens_won == 1)
		alien_win_message = "Infestation remains"
	if (score_aliens_won == 2)
		alien_win_message = "Infestation expands"
	dat +={"<B>Infestation expanded?:</B>				[alien_win_message] 			([score_aliens_won * 5000] Points)<BR>
	<B>Total live aliens:</B>					[score_aliens_survived]			 ([score_aliens_survived * 200] Points)<BR>
	<B>Original queen survived:</B>				[score_queen_survived ? "Yes" : "No"] 			([score_queen_survived * 5000] Points)<BR>
	<BR>
	<B>Eggs produced:</B>						[score_eggs_made] 			([score_eggs_made * 25] Points)<BR>
	<B>Station tiles infested:</B>				[score_weeds_made] 			([score_weeds_made * 2] Points)<BR>
	<B>Hosts infected:</B> 						[score_hosts_infected] 			([score_hosts_infected * 100] Points) <BR>
	<BR>"}
	dat += {"<U>THE BAD:</U><BR>
	<B>Queens died:</B> 						[score_queens_dead] 			(-[score_queens_dead * 2000] Points)<BR>
	<B>Aliens died:</B> 						[score_aliens_dead] 			(-[score_aliens_dead * 500] Points)<BR>
	<B>Larvas died:</B> 														(-) Points)<BR>
	<BR>
	<B>Larvas extracted:</B> 													(-) Points)<BR>
	<BR>
	<U>OTHER</U><BR>
	<B>Resin constructed:</B> 					[score_resin_made]<BR>
	<B>Tackles:</B> 							[score_tackles_made]<BR>
	<B>Slashes:</B>								[score_slashes_made]<BR>
	<BR>"}
	dat += {"<HR><BR>
	<B><U>FINAL ALIEN SCORE: [score_alienscore]</U></B><BR><HR>"}

//Marines
	dat += {"<B><U>MARINE STATS</U></B><BR>
	<U>THE GOOD:</U><BR>"}
	var/marine_win_message
	if (score_marines_won == 0)
		marine_win_message = "Failed"
	if (score_marines_won == 1)
		marine_win_message = "Nuke deployed"
	if (score_marines_won == 2)
		marine_win_message = "Infestation cleaned"
	dat +={"<B>Infestation eradicated?:</B> 				[marine_win_message] 			([score_marines_won * 5000] Points)<BR>
	<B>Survivors saved:</B> 													(-) Points)<BR>
	<B>Marines survived:</B> 					[score_marines_survived] ([score_marines_survived * 100] Points)<BR>
	<B>	Aliens killed:</B> 						[score_aliens_killed] ([score_aliens_killed * 250] Points)<BR>
	<BR>
	<B>Marines revived:</B> 													(-) Points)<BR>
	<B>Marines cloned</B> 														(-) Points)<BR>
	<B>Larvas extracted</B> 													(-) Points)<BR>
	<BR>"}
	dat += {"<U>THE BAD:</U><BR>
	<B>Marines MIA:</B> 						[score_marines_mia] 			(-[score_marines_mia * 500] Points)<BR>
	<B>Marines KIA:</B> 						[score_marines_kia] 			(-[score_marines_kia * 200] Points)<BR>
	<B>Marines chestbursted:</B> 												(-) Points)<BR>
	<BR>
	<B>HIT called:</B>							[score_hit_called ? "Yes" : "No"] 			([score_hit_called * 2000] Points)<BR>
	<B>Sulaco evacuated:</B> 													(-) Points)<BR>
	<B>Marines left behind:</B> 												(-) Points)<BR>
	<BR>
	<U>OTHER</U><BR>
	<B>Rounds fired:</B> 						[score_rounds_fired]<BR>
	<B>Rounds hit:</B> 							[score_rounds_hit] ([score_rounds_hit * 100 / score_rounds_fired]%)<BR>
	<B>Clamps:</B> 								[score_aliens_clamped]<BR>
	<BR>"}
	dat += {"<HR><BR>
	<B><U>FINAL MARINE SCORE: [score_marinescore]</U></B><BR>"}
	dat += {"<HR><BR>
	<B><U>TOTAL SCORE: [score_marinescore - score_alienscore]</U></B><BR>"}
//TODO: Score rating for marines(positive number) and aliens(negative number)
	var/score_rating = "The Aristocrats!"
	switch(score_marinescore)
		if(-99999 to -50000) score_rating = "Even the Singularity Deserves Better"
		if(-49999 to -5000) score_rating = "Singularity Fodder"
		if(-4999 to -1000) score_rating = "You're All Fired"
		if(-999 to -500) score_rating = "A Waste of Perfectly Good Oxygen"
		if(-499 to -250) score_rating = "A Wretched Heap of Scum and Incompetence"
		if(-249 to -100) score_rating = "Outclassed by Lab Monkeys"
		if(-99 to -21) score_rating = "The Undesirables"
		if(-20 to 20) score_rating = "Ambivalently Average"
		if(21 to 99) score_rating = "Not Bad, but Not Good"
		if(100 to 249) score_rating = "Skillful Servants of Science"
		if(250 to 499) score_rating = "Best of a Good Bunch"
		if(500 to 999) score_rating = "Lean Mean Machine Thirteen"
		if(1000 to 4999) score_rating = "Promotions for Everyone"
		if(5000 to 9999) score_rating = "Ambassadors of Discovery"
		if(10000 to 49999) score_rating = "The Pride of Science Itself"
		if(50000 to INFINITY) score_rating = "Nanotrasen's Finest"
	dat += "<B><U>RATING:</U></B> [score_rating]"
	src << browse(dat, "window=roundstats;size=500x600")
	return