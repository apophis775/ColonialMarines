/mob/living/carbon/human/say(var/message)

	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/gas/voice/space_ninja) && wear_mask:voice == "Unknown")
			if(copytext(message, 1, 2) != "*")
				var/list/temp_message = text2list(message, " ")
				var/list/pick_list = list()
				for(var/i = 1, i <= temp_message.len, i++)
					pick_list += i
				for(var/i=1, i <= abs(temp_message.len/3), i++)
					var/H = pick(pick_list)
					if(findtext(temp_message[H], "*") || findtext(temp_message[H], ";") || findtext(temp_message[H], ":")) continue
					temp_message[H] = ninjaspeak(temp_message[H])
					pick_list -= H
				message = dd_list2text(temp_message, " ")
				message = replacetext(message, "o", "¤")
				message = replacetext(message, "p", "þ")
				message = replacetext(message, "l", "£")
				message = replacetext(message, "s", "§")
				message = replacetext(message, "u", "µ")
				message = replacetext(message, "b", "ß")

		if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
				if(!(copytext(message, 1, 2) == "*" || (mind && mind.changeling && department_radio_keys[copytext(message, 1, 3)] != "changeling")))
					message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
		if(istype(wear_mask, /obj/item/weapon/combat_knife))
			if(!(copytext(message, 1, 2) == "*" || (mind && mind.changeling && department_radio_keys[copytext(message, 1, 3)] != "changeling")))
				message = replacetext(message, "á", "ï")
				message = replacetext(message, "â", "ô")
				message = replacetext(message, "ã", "ê")
				message = replacetext(message, "ä", "'ò")
				message = replacetext(message, "ñ", "ø")
				message = replacetext(message, "æ", "'ø")
				message = replacetext(message, "ç", "'ø")
				message = replacetext(message, "ì", "'")
				message = replacetext(message, "í", "'í")
				message = replacetext(message, "ï", "ô")
				message = replacetext(message, "ð", "'ã")
				message = replacetext(message, "ö", "'ñ")
				message = replacetext(message, "÷", "'ù")
				message = replacetext(message, "þ", "'ó")

				message = replacetext(message, "Á", "Ï")
				message = replacetext(message, "Â", "ô")
				message = replacetext(message, "Ã", "Ê")
				message = replacetext(message, "Ä", "'Ò")
				message = replacetext(message, "Ñ", "Ø")
				message = replacetext(message, "Æ", "'Ø")
				message = replacetext(message, "Ç", "'Ø")
				message = replacetext(message, "Ì", "'")
				message = replacetext(message, "Í", "'Í")
				message = replacetext(message, "Ï", "Ô")
				message = replacetext(message, "Ð", "'Ã")
				message = replacetext(message, "Ö", "'Ñ")
				message = replacetext(message, "×", "'Ù")
				message = replacetext(message, "Þ", "'Ó")

	if ((HULK in mutations) && health >= 25 && length(message))
		if(copytext(message, 1, 2) != "*")
			message = "[uppertext(message)]!!" //because I don't know how to code properly in getting vars from other files -Bro

	if (src.slurring)
		if(copytext(message, 1, 2) != "*")
			message = slur(message)
	..(message)

/mob/living/carbon/human/say_understands(var/other,var/datum/language/speaking = null)


	if (istype(other, /mob/living/silicon))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	if (istype(other, /mob/living/carbon/slime))
		return 1
	return ..()

/mob/living/carbon/human/GetVoice()
	if(istype(src.wear_mask, /obj/item/clothing/mask/gas/voice))
		var/obj/item/clothing/mask/gas/voice/V = src.wear_mask
		if(V.vchange)
			return V.voice
		else
			return name
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

