/proc/captain_announce(var/text)
	var/p1 = "Priority Announcement"
	var/p2 = fix_ja_input(text)
	var/p3 = "<br>"
	for(var/mob/M in player_list)
		if(istype(M, /mob/living/carbon/alien))
			M << "<h1 class='alert'>[stars(p1,10)]</h1>"
			M << "<span class='alert'>[fix_ja_output(html_encode(stars(p2,10)))]</span>"
			M << p3
		else
			M << "<h1 class='alert'>[p1]</h1>"
			M << "<span class='alert'>[fix_ja_output(html_encode(p2))]</span>"
			M << p3
