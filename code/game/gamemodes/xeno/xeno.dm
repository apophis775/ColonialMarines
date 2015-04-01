/datum/game_mode
	var/list/datum/mind/aliens = list()
	var/list/datum/mind/survivors = list()

/datum/game_mode/infestation
	name = "infestation"
	config_tag = "infestation"
	required_players = 2
	recommended_enemies = 2
	required_enemies = 2
	var/checkwin_counter = 0
	var/finished = 0
	var/humansurvivors = 0
	var/aliensurvivors = 0
	var/ready_aliens = 0
	var/ready_survivors = 0
	
// Edit these as needed
	var/min_aliens = 2
	var/max_aliens = 8
	var/min_survivors = 0
	var/max_survivors = 3


//////////////////////////////////////////
//////////////////////////////////////////
/* Pre-pre-startup */

/datum/game_mode/infestation/can_start()
	if(!..())
		return

	var/readyplayers = num_players()
	
// 1 Alien per 5 players, 1 Survivor per 10 players
	for(var/C = 0, C < readyplayers, C += 5)
		ready_aliens++
	for(var/C = 0, C < readyplayers, C += 10)
		ready_survivors++

	
// Handle Aliens
	// ready_aliens = Clamp((readyplayers/5), min_aliens, max_aliens) //(n, minimum, maximum)		
	var/list/datum/mind/possible_aliens = get_players_for_role(BE_ALIEN)
	if(possible_aliens.len < min_aliens)
		world << "<h2 style=\"color:red\">Not enough players have chosen 'Be alien' in their character setup. Aborting.</h2>"
		return
	for(var/i = 0, i < ready_aliens, i++)
		var/datum/mind/alien = pick(possible_aliens)
		aliens += alien
	for(var/datum/mind/A in aliens)
		// modePlayer += A
		A.assigned_role = "MODE" //So they aren't chosen for other jobs.
		A.special_role = "Drone"
		// A.original = A.current

// Handle Survivors
	// ready_survivors = Clamp((readyplayers/10), min_survivors, max_survivors) //(n, minimum, maximum)
	var/list/datum/mind/possible_survivors = get_players_for_role(BE_SURVIVOR) // Get all players with "Be survivor: Yes"
	if(possible_survivors.len > 0) // If no players want to be a survivor, do nothing
		// Add players to "survivors" list
		for(var/i = 0, i < ready_survivors, i++) 
			var/datum/mind/surv = pick(possible_survivors)
			survivors += surv
		// Wait! If they also have "Be alien: Yes", remove them from the list (this prevents a major bug found that spawns aliens into survivor landmarks. Can probably be improved. 
		for(var/mob/new_player/player in player_list) 
			if(player.client.prefs.be_special & BE_ALIEN)
				var/datum/mind/surv = pick(possible_survivors)
				survivors -= surv
		for(var/datum/mind/S in survivors)
			// modePlayer += S
			S.assigned_role = "Survivor" //So they aren't chosen for other jobs.
			S.special_role = "Survivor"
			// S.original = S.current

	return 1


//////////////////////////////////////////
//////////////////////////////////////////
/* Pre-setup */

/datum/game_mode/infestation/pre_setup()
	//Spawn aliens
	for(var/datum/mind/alien in aliens)
		alien.current.loc = pick(xeno_spawn)
	//Spawn survivors
	for(var/datum/mind/surv in survivors)
		surv.current.loc = pick(surv_spawn)
	spawn (50)
		command_alert("Distress signal received from the NSS Nostromo. A response team from NMV Sulaco will be dispatched shortly to investigate.", "NMV Sulaco")
	return 1


//////////////////////////////////////////
//////////////////////////////////////////
/* Post-setup */

/datum/game_mode/infestation/post_setup()
	defer_powernet_rebuild = 2 // Apparently this can help with lag
	//Do stuff to the aliens
	for(var/datum/mind/alien in aliens)
		transform_player(alien.current)
	//Do stuff to the survivors
	for(var/datum/mind/surv in survivors)
		transform_player2(surv.current)
	tell_story()

/datum/game_mode/proc/transform_player(mob/living/carbon/human/H)
	H.Alienize2()
	return 1

/datum/game_mode/proc/transform_player2(mob/living/carbon/human/H)
	H.take_organ_damage(rand(1,25), rand(1,25))
	H.client << "<h2>You are a survivor!</h2>"
	H.client << "\blue You were a crew member on the Nostromo. Your crew was wiped out by an alien infestation. You should try to locate and help other survivors (If there are any other than you.)"
	return 1

var/list/survivorstory = list("You watched your friend {name}'s chest burst and an alien larva come out. You tried to capture it but it escaped through the vents. ", "{name} was attacked by a facehugging alien, which impregnated them with an alien lifeform. {name}'s chest burst and a larva emerged and escaped through the vents", "You watched {name} get the alien lifeform's acid on them, melting away their flesh. You can still hear the screams... ", "The Head of Security, {name}, made an announcement that the aliens killed the Captain and Head of Personnel, and that all crew should hide and wait for rescue." )
var/list/survivorstorymulti = list("You were separated from your friend, {surv}. You hope they're still alive. ", "You were having some drinks at the bar with {surv} and {name} when an alien crawled out of the vent and dragged {name} away. You and {surv} split up to find help. ")
var/list/toldstory = list()
/datum/game_mode/infestation/proc/tell_story()
	for(var/datum/mind/surv in survivors)
		if(!(surv.name in toldstory))
			var/story
			var/mob/living/carbon/human/OH
			var/mob/living/carbon/human/H = surv.current
			var/list/otherplayers = survivors
			for(var/datum/mind/surv2 in otherplayers)
				if(surv == surv2)
					otherplayers.Remove(surv2)
			var/randomname = random_name(FEMALE)
			if(prob(50))
				randomname = random_name(MALE)
			if(length(survivors) > 1)
				if(length(toldstory) == length(survivors) - 1 || length(otherplayers) == 0)
					story = pick(survivorstory)
					survivorstory.Remove(story)
				else
					story = pick(survivorstorymulti)
					survivorstorymulti.Remove(story)
					OH = pick(otherplayers)
			else
				story = pick(survivorstory)
				survivorstory.Remove(story)
			story = replacetext(story, "{name}", "[randomname]")
			if(istype(OH))
				toldstory.Add(OH.name)
				OH << replacetext(story, "{surv}", "[H.name]")
				H << replacetext(story, "{surv}", "[OH.name]")

			toldstory.Add(H.name)
			

//////////////////////////////////////////
//////////////////////////////////////////
/* Victory Conditions */

// Add dead/alive aliens/humans every few seconds to see if there's a winner
/datum/game_mode/infestation/process()
	//Reset the survivor count to zero per process call.
	humansurvivors = 0
	aliensurvivors = 0

	//For each survivor, add one to the count. Should work accurately enough.
	for(var/mob/living/carbon/human/H in living_mob_list)
		var/nestedhost = (H.status_flags & XENO_HOST) && H.buckled
		if(H) //Prevent any runtime errors
			if(H.client && H.brain_op_stage != 4 && H.stat != DEAD && !nestedhost) // If they're connected/unghosted, alive, not debrained, and not a nested host
				humansurvivors += 1 //Add them to the amount of people who're alive.
	for(var/mob/living/carbon/alien/A in living_mob_list)
		if(A) //Prevent any runtime errors
			if(A.client && A.brain_op_stage != 4 && A.stat != DEAD) // If they're connected/unghosted and alive and not debrained
				aliensurvivors += 1


	checkwin_counter++
	if(checkwin_counter >= 3)
		if(!finished)
			ticker.mode.check_win()
		checkwin_counter = 0
	return 0

	
//Checks to see who won
/datum/game_mode/infestation/check_win()
	if(check_alien_victory())
		finished = 1
	else if(check_marine_victory())
		finished = 2
	if(check_nosurvivors_victory())
		finished = 3
	else if(check_survivors_victory())
		finished = 4
	else if(check_nuclear_victory())
		finished = 5
	..()

//Checks if the round is over
/datum/game_mode/infestation/check_finished()
	if(finished != 0)
		return 1
	else
		return 0

//Checks for alien victory
datum/game_mode/infestation/proc/check_alien_victory()
	if(aliensurvivors > 0 && humansurvivors < 1)
		return 1
	else
		return 0

//Check for a neutral victory
/datum/game_mode/infestation/proc/check_nosurvivors_victory()
	if(humansurvivors < 1 && aliensurvivors < 1)
		return 1
	else
		return 0

//Checks for marine victory
/datum/game_mode/infestation/proc/check_marine_victory()
	if(aliensurvivors < 1 && humansurvivors > 0)
		return 1
	else
		return 0

//Check for minor marine victor (shuttle)
/datum/game_mode/infestation/proc/check_survivors_victory()
	if(emergency_shuttle.location==2)
		return 1
	else
		return 0

//Check for a nuclear victory (Draw)
/datum/game_mode/infestation/proc/check_nuclear_victory()
	if(station_was_nuked)
		return 1
	else
		return 0

//Announces the end of the game with all relavent information stated
/datum/game_mode/infestation/declare_completion()
	if(finished == 1)
		feedback_set_details("round_end_result","alien major victory - marine incursion fails")
		world << "\red <FONT size = 4><B>Alien major victory!</B></FONT>"
		world << "\red <FONT size = 3><B>The aliens have successfully wiped out the marines and will live to spread the infestation!</B></FONT>"
		if(prob(50))
			world << 'sound/misc/Game_Over_Man.ogg'
		else
			world << 'sound/misc/asses_kicked.ogg'

	else if(finished == 2)
		feedback_set_details("round_end_result","marine major victory - xenomorph infestation erradicated")
		world << "\red <FONT size = 4><B>Marines major victory!</B></FONT>"
		world << "\red <FONT size = 3><B>The marines managed to wipe out the aliens and stop the infestation!</B></FONT>"
		if(prob(50))
			world << 'sound/misc/hardon.ogg'
		else
			world << 'sound/misc/hell_march.ogg'

	else if(finished == 3)
		feedback_set_details("round_end_result","marine minor victory - infestation stopped at a great cost")
		world << "\red <FONT size = 3><B>Marine minor victory.</B></FONT>"
		world << "\red <FONT size = 3><B>Both the marines and the aliens have been terminated. At least the infestation has been erradicated!</B></FONT>"
	else if(finished == 4)
		feedback_set_details("round_end_result","alien minor victory - infestation survives")
		world << "\red <FONT size = 3><B>Alien minor victory.</B></FONT>"
		world << "\red <FONT size = 3><B>The station has been evacuated... but the infestation remains!</B></FONT>"
	else if(finished == 5)
		feedback_set_details("round_end_result","draw - the station has been nuked")
		world << "\red <FONT size = 3><B>Draw.</B></FONT>"
		world << "\red <FONT size = 3><B>The station has blown by a nuclear fission device... there are no winners!</B></FONT>"

	..()
	return 1

// Display antags at round-end
/datum/game_mode/proc/auto_declare_completion_infestation()
	if( aliens.len || (ticker && istype(ticker.mode,/datum/game_mode/infestation)) )
		var/text = "<FONT size = 2><B>The aliens were:</B></FONT>"
		for(var/mob/living/L in mob_list)
			if(L.mind && L.mind.assigned_role)
				if(L.mind.assigned_role == "Alien")
					var/mob/M = L.mind.current
					if(M)
						text += "<br>[M.key] was [M.name] ("
						if(M.stat == DEAD)
							text += "died"
						else
							text += "survived"
					else
						text += "body destroyed"
					text += ")"
		world << text