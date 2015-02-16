/obj/item/device/motiondetector
	name = "motion detector"
	icon = 'motiondetector.dmi'
	icon_state = "off"
	flags = FPRINT | TABLEPASS| CONDUCT
	slot_flags = SLOT_BELT
	w_class = 2.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	m_amt = 500
	var/active = 0
	var/detector_ping = 1
	var/obj/detector_image = new()

mob/var/tracker_position = null
mob/var/current_detector = null

/obj/item/device/motiondetector/attack_self(mob/user as mob)
	CreateDetectorImage(user, 'detectorscreen.dmi')
	ToggleDetector(user)

/obj/item/device/motiondetector/proc/CreateDetectorImage(mob/user,image) //Creates the animated detector background
	if(detector_image in user.client.screen)
		return
	else
		detector_image.icon = image
		detector_image.screen_loc = "detector:1,1"
		user.client.screen+=detector_image
	return

/obj/item/device/motiondetector/proc/Redraw(mob/user)
	while(active && user.client)
		var/mob/M = user
		var/list/detected = list()

		if(user.r_hand != src && user.l_hand != src)
			active = 0 //If the radar isn't in hand, disable it and stop the loop.
			break
		for(var/obj/Blip/o in user.client.screen)
			user.client.screen-=o //Remove all blips from the tracker, then..
			pool("detector_blips", o)	//Store all removed blips in the pool

		for(var/mob/living/t in range(10,M))
			if(t != M)
				if(istype(t, /mob/living/carbon/human))
					var/mob/living/carbon/human/C = t
					if(istype(C.wear_suit, /obj/item/clothing/suit/storage/marine2))
						continue
					C.tracker_position = C.loc

				else
					t.tracker_position = t.loc

		sleep(3) //Amount of time to "check" for movement
		for(var/mob/living/t in range(10,M))
			if((t.tracker_position != null) && (get_dist(t.tracker_position, t.loc) >= 1))
				spawn(3) t.tracker_position = null
				detected += t

		if(detected.len>=1)
			for(var/mob/living/t in detected)
				var/obj/Blip/o = unpool("detector_blips", /obj/Blip) // Get a blip from the blip pool
				o.pixel_x = (t.x-M.x)*6-4 // Make the blip in the right position on the radar (multiplied by the icon dimensions)
				o.pixel_y = (t.y-M.y)*6-4 //-4 is a slight offset south and west
				o.screen_loc = "detector:3:[o.pixel_x],3:[o.pixel_y]" // Make it appear on the radar map
				user.client.screen+=o // Add it to the radar
				flick("blip", o)
			detected = null
			if(detector_ping)
				playsound(src.loc, 'detector.ogg', 150, 0, 2) //If player isn't the only blip, play ping
		playsound(src.loc, 'tick.ogg', 125)
		flick("", detector_image)
		sleep(4)
	active = 0
	icon_state = "off"
	user.current_detector = null
	winshow(user,"detectorwindow",0)

/obj/item/device/motiondetector/proc/ToggleDetector(mob/user)
	if(winget(user,"detectorwindow","is-visible")=="true" && user.current_detector == src) //Checks if radar window is already open and if radar is assigned
		active = 0 //Sets the active state of the radar to off
		icon_state = "off"
		user << "\red You deactivate the radar."
		winshow(user,"detectorwindow",0) //Closes the radar window
		playsound(null) //Stops the radar pings
		//user.current_detector = null
	else if(!user.current_detector)
		active = 1
		icon_state = "on"
		user << "\blue You activate the radar."
		winshow(user,"detectorwindow",1)
		user.current_detector = src
		Redraw(user)
	else user << "\red You're already using another tracker."

/obj/item/device/motiondetector/verb/Toggle_Ping_Sound()
	detector_ping = !detector_ping

/obj/item/device/motiondetector/dropped(mob/user)
	if(active)
		ToggleDetector(user) //Disables the radar if dropped
		icon_state = "off"

/obj/item/device/motiondetector/pickup(mob/user)
	if(active && user.current_detector == src) //If the radar on the floor is active and tied to the user
		winshow(user,"detectorwindow",1)

obj/Blip
	icon = 'detector-blips.dmi'
	icon_state = "blip"
	layer = 5
obj/Blip/unpooled()
	src.loc = null