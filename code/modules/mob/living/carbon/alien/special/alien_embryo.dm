// This is to replace the previous datum/disease/alien_embryo for slightly improved handling and maintainability
// It functions almost identically (see code/datums/diseases/alien_embryo.dm)

/obj/item/alien_embryo
	name = "alien embryo"
	desc = "All slimy and yuck."
	icon = 'icons/Xeno/1x1_Accurate_Xenos.dmi'
	icon_state = "Bloody Larva Dead"
	var/mob/living/affected_mob
	var/stage = 0
	var/stage_age = 0
	var/protect = 0

/obj/item/alien_embryo/New()
	..()
	score_hosts_infected++
	process_larva()
	if(istype(loc, /mob/living))
		affected_mob = loc
		spawn(0)
			AddInfectionImages(affected_mob)
	else
		del(src)

/obj/item/alien_embryo/Del()
	if(affected_mob)
		affected_mob.status_flags &= ~(XENO_HOST)
		spawn(0)
			RemoveInfectionImages(affected_mob)
	..()

/obj/item/alien_embryo/proc/process_larva()
	spawn while(1)
		if(!affected_mob)	return
		if(loc != affected_mob)
			affected_mob.status_flags &= ~(XENO_HOST)
			RemoveInfectionImages(affected_mob)
			affected_mob = null
			return
	/*
		if(affected_mob.stat == DEAD && !protect) //If the host of the xeno baby dies and the protect var = 0, kill the baby with them.
			affected_mob.status_flags &= ~(XENO_HOST)
			processing_objects.Remove(src)
			spawn(0)
				RemoveInfectionImages(affected_mob)
				affected_mob = null
			return*/
		stage_age++
		if(stage < 5 && stage_age > 60)
			stage++
			stage_age = 0
			spawn(0)
				RefreshInfectionImage(affected_mob)
		switch(stage)
			if(1)
				if(prob(5))
					affected_mob << "\red You taste blood in your mouth."
				if(prob(1))
					affected_mob << "\red You feel cold."
					affected_mob.emote("shiver")
			if(2)
				if(prob(1))
					affected_mob.emote("sneeze")
				if(prob(1))
					affected_mob.emote("cough")
				if(prob(5))
					affected_mob << "\red Your throat feels sore."

			if(3)
				if(prob(10))
					affected_mob << "\red Mucous runs down the back of your throat."
				if(prob(5))
					affected_mob << "\red Your chest feels tight."
				if(prob(3))
					affected_mob << "\red Your chest aches."
					if(istype(affected_mob, /mob/living/carbon/human))
						affected_mob.take_organ_damage(5)
				if(prob(10))
					affected_mob << "\red You feel hungry."
					affected_mob.nutrition -= 20
				if(prob(25) && affected_mob.paralysis == 0)
					affected_mob << "\red <b>You black out.</b>"
					affected_mob.paralysis = 5
			if(4)
				if(prob(10))
					affected_mob.emote("sneeze")
				if(prob(10))
					affected_mob.emote("cough")
				if(prob(30))
					affected_mob << "\red Your chest hurts."
					if(prob(50))
						if(istype(affected_mob, /mob/living/carbon/human))
							affected_mob.take_organ_damage(10)
				if(prob(20))
					affected_mob << "\red Your stomach hurts."
					if(prob(50))
						if(istype(affected_mob, /mob/living/carbon/human))
							affected_mob.adjustToxLoss(1)
							affected_mob.updatehealth()
			if(5)
				if(istype(affected_mob, /mob/living/carbon/human))
					affected_mob.adjustToxLoss(2)

				affected_mob << "\red You feel something tearing its way out of your stomach..."
				AttemptGrow()
				stage = 6
				if(prob(70))
					if(istype(affected_mob, /mob/living/carbon/human))
						affected_mob.adjustBruteLoss(5)
						affected_mob.updatehealth()
			if(6)
				stage = 4
				stage_age = 57
		sleep(20)


/obj/item/alien_embryo/proc/AttemptGrow(var/gib_on_success = 1)

	affected_mob.emote("scream")

	spawn(20)
		var/list/candidates = list()
		var/picked
		if(!affected_mob)//hopefully fix a runtime error
			return

		if(istype(affected_mob, /mob/living/carbon/human) && affected_mob.stat == DEAD)
			return
		for(var/mob/dead/observer/G in player_list)
			if(G)
				if(G.client)
					if(G.client.prefs.be_special & BE_ALIEN)
						candidates += G.key

		// To stop clientless larva, we will check that our host has a client
		// if we find no ghosts to become the alien. If the host has a client
		// he will become the alien but if he doesn't then we will set the stage
		// to 4, so we don't do a process heavy check everytime.

		if(candidates.len)
			picked = pick(candidates)
		else if(affected_mob.client)
			picked = affected_mob.key
		if(!picked)
			stage = 4 // Let's try again later.
			stage_age = 35
			return

		affected_mob.death()
		affected_mob.stat = DEAD
		src.protect = 1

		var/turf/T = affected_mob.loc
		var/mob/living/carbon/alien/larva/new_xeno = new(T)
		affected_mob.birth = 1

		new_xeno.key = picked
		new_xeno << sound('sound/voice/hiss5.ogg',0,0,0,100)	//To get the player's attention
		affected_mob.update_icons()
		affected_mob.death()
		affected_mob.stat = DEAD
		src.protect = 1
		if(ishuman(affected_mob))
			score_marines_chestbursted++

		for(var/mob/L in range(src, 10))
			L << "\red <b>[new_xeno] crawls out of [affected_mob]!</b>"
		affected_mob.overlays += image('icons/mob/alien.dmi', loc = affected_mob, icon_state = "bursted_stand")
	//	if(gib_on_success)
		//	affected_mob.gib()
		del(src)

/*----------------------------------------
Proc: RefreshInfectionImage()
Des: Removes all infection images from aliens and places an infection image on all infected mobs for aliens.
----------------------------------------*/
/obj/item/alien_embryo/proc/RefreshInfectionImage()
	for(var/mob/living/carbon/alien/alien in player_list)
		if(alien.client)
			for(var/image/I in alien.client.images)
				if(dd_hasprefix_case(I.icon_state, "infected"))
					del(I)
			for(var/mob/living/L in mob_list)
				if(iscorgi(L) || iscarbon(L))
					if(L.status_flags & XENO_HOST)
						var/I = image('icons/mob/alien.dmi', loc = L, icon_state = "infected[stage]")
						alien.client.images += I

/*----------------------------------------
Proc: AddInfectionImages(C)
Des: Checks if the passed mob (C) is infected with the alien egg, then gives each alien client an infected image at C.
----------------------------------------*/
/obj/item/alien_embryo/proc/AddInfectionImages(var/mob/living/C)
	if(C)
		for(var/mob/living/carbon/alien/alien in player_list)
			if(alien.client)
				if(C.status_flags & XENO_HOST)
					var/I = image('icons/mob/alien.dmi', loc = C, icon_state = "infected[stage]")
					alien.client.images += I

/*----------------------------------------
Proc: RemoveInfectionImage(C)
Des: Removes the alien infection image from all aliens in the world located in passed mob (C).
----------------------------------------*/

/obj/item/alien_embryo/proc/RemoveInfectionImages(var/mob/living/C)
	if(C)
		for(var/mob/living/carbon/alien/alien in player_list)
			if(alien.client)
				for(var/image/I in alien.client.images)
					if(I.loc == C)
						if(dd_hasprefix_case(I.icon_state, "infected"))
							del(I)