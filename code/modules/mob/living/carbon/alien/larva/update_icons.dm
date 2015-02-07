
/mob/living/carbon/alien/larva/regenerate_icons()
	overlays = list()
	update_icons()

/mob/living/carbon/alien/larva/update_icons()
	var/state = "Bloody"
	if(amount_grown > 150)
		state = "Normal"
	else if(amount_grown > 50)
		state = "Normal"

	if(stat == DEAD)
		icon_state = "[state] Larva Dead"
	else if (handcuffed || legcuffed)
		icon_state = "[state] Larva Cuff"
	else if (stunned)
		icon_state = "[state] Larva Stunned"
	else if(lying || resting)
		icon_state = "[state] Larva Sleeping"
	else
		icon_state = "[state] Larva"
