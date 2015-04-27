/datum/controller/gameticker/proc/scoreboard()
//MARINES
	// Who is MIA
	for (var/mob/living/carbon/human/I in mob_list)
		if (I.stat == 2 && !I.z == 6)
			score_marines_mia += 1 //Bodies not on Sulaco are missing
	// Who is KIA
		else if (I.stat == 2)
			score_marines_kia += 1
	// Who is alive and active
	for(var/client/C in clients)
		if(ishuman(C.mob) && C.mob.stat != DEAD)
			score_marines_survived++
	//Aliens killed
	for (var/mob/living/carbon/alien/K in mob_list)
		if (K.stat == 2)
			score_aliens_killed += 1

//End game score bonus
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
	// Queens dead
		if (A.stat == 2 && isqueen(A))
			score_queens_dead += 1
	// Original Queen alive
		if (score_queens_dead == 0)
			score_queen_survived = 1
	// Alive Active Aliens
	for(var/client/C in clients)
		if(isalien(C.mob) && C.mob.stat != DEAD)
			score_aliens_survived++

	// Check how many weeds there are
	for (var/obj/effect/alien/weeds/M in world)
		score_weeds_made += 1


//-*------------------------------------------*-\\

//MARINE SCORE
	var/marine_mia_points = score_marines_mia * 500
	var/marine_kia_points = score_marines_kia * 200
	var/marine_survived_points = score_marines_survived * 100
	var/marine_aliens_killed_points = score_aliens_killed * 250
	var/marine_hit_called_points = score_hit_called * 2000
	var/marine_won_points = score_marines_won * 5000


//Calculate Marine Good Things
	score_marinescore += marine_aliens_killed_points
	score_marinescore += marine_survived_points
	score_marinescore += marine_survived_points
	score_marinescore += marine_won_points

//Calculate Marine Bad Things
	score_marinescore -= marine_mia_points
	score_marinescore -= marine_kia_points
	score_marinescore -= marine_hit_called_points



//ALIEN SCORE
	var/alien_survived_points = score_aliens_survived * 200
	var/alien_queen_survived_points = score_queen_survived * 2000
	var/alien_dead_points = score_aliens_dead * 500
	var/alien_queens_dead_points = score_queens_dead * 2000
	var/alien_eggs_made_points = score_eggs_made * 25
	var/alien_weeds_made_points = score_weeds_made * 2
	var/alien_hosts_infected_points = score_hosts_infected * 100
	var/alien_won_points = score_aliens_won * 5000

//Calculate Alien Good Things
	score_alienscore += alien_survived_points
	score_alienscore += alien_queen_survived_points
	score_alienscore += alien_eggs_made_points
	score_alienscore += alien_weeds_made_points
	score_alienscore += alien_hosts_infected_points
	score_alienscore += alien_won_points

//Calculate Alien Bad Things
	score_alienscore -= alien_dead_points
	score_alienscore -= alien_queens_dead_points

//-*------------------------------------------*-\\

	// Show the score
	world << "<b>The game final score is:</b>"
	world << "<b><font size='4'>[score_marinescore - score_alienscore]</font></b>"
	for(var/mob/E in player_list)
		if(E.client) E.scorestats()
	return


//Show the score window
/mob/proc/scorestats()
	var/dat = {"<B>Round Statistics and Score</B><BR><HR>"}


//Aliens
	dat += {"<B><U>ALIEN STATS</U></B><BR>
	<U>THE GOOD:</U><BR>"}
	var/alien_win_message
	if (score_aliens_won == 0)
		alien_win_message = "Failed"
	else if (score_aliens_won == 1)
		alien_win_message = "Infestation remains"
	else if (score_aliens_won == 2)
		alien_win_message = "Infestation expands"
	dat +={"<B>Infestation expanded?:</B>				[alien_win_message] 			([score_aliens_won * 5000] Points)<BR>
	<B>Total live aliens:</B>					[score_aliens_survived]			 ([score_aliens_survived * 200] Points)<BR>
	<B>Original queen survived:</B>				[score_queen_survived ? "Yes" : "No"] 			([score_queen_survived * 2000] Points)<BR>
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
	else if (score_marines_won == 1)
		marine_win_message = "Nuke deployed"
	else if (score_marines_won == 2)
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