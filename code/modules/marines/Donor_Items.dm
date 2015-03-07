////SS13 DONATOR CUSTOM ITEM STORAGE ZONE OF MAGICAL HAPPINESS APOPHIS - LAST UPDATE - 25JAN2015

//General Donor Items
/obj/item/clothing/suit/storage/marine/fluff/santa
	name = "Santa's suit"
	desc = "Festive!  DONOR ITEM"
	icon_state = "santa"
	item_state = "santa"

/obj/item/clothing/suit/storage/marine/fluff/cia
	name = "CIA jacket"
	desc = "An armored jacket with CIA on the back.  DONOR ITEM"
	icon_state = "cia"
	item_state = "cia"

/obj/item/clothing/suit/storage/marine/fluff/armorammo
	name = "marine armor w/ ammo"
	desc = "A marine combat vest with ammunition on it.  DONOR ITEM"
	icon_state = "bulletproofammo"
	item_state = "bulletproofammo"
	item_color = "bulletproofammo"

/obj/item/clothing/under/fluff/turtleneck
	name = "Black Ops Turtleneck"
	desc = "A $900 black turtleneck woven from only the purest Azerbaijani cashmere wool.  DONOR ITEM"


//Specific Items for Specific People

/obj/item/clothing/mask/balaclava/obey
	name = "Black Ops Balaclava"
	desc = "The latest fashion, when your trying to hide your identity.  DONOR ITEM"
	flags_inv = 0

/obj/item/clothing/gloves/black/obey
	desc = "Black gloves, favored by Special Operations teams.  DONOR ITEM"
	name = "Black Ops Black Gloves"

/obj/item/clothing/suit/armor/fluff/obey
	name = "Black Ops Ablative Armor Vest"
	desc = "Some fancy looking armor.  DONOR ITEM"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 80, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/fluff/sas
	name = "Juggernaut Armor"
	desc = "Some fancy looking armor. DONOR ITEM"
	icon_state = "rig-syndi"
	item_state = "syndie_hardsuit"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 80, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/head/fluff/sas
	name = "Juggernaut Helmet"
	icon_state = "rig0-syndi"
	item_state = "syndie_helm"
	item_color = "syndi"
	desc = "A red helmet, for pairing with JuggerNaut Armor. DONOR ITEM"
	flags = FPRINT|TABLEPASS
	siemens_coefficient = 0


/obj/item/clothing/suit/fluff/penguin
	name = "Trenchcoat"
	desc = "An 18th-century trenchcoat. Someone who wears this means serious business.  DONOR ITEM"
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list()
	armor = list(melee = 50, bullet = 80, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/swat/fluff/wright
	name = "Swat Armor"
	desc = "Some fancy looking armor. DONOR ITEM"
	icon_state = "deathsquad"
	item_state = "swat_suit"
	blood_overlay_type = "armor"
	allowed = list()
	armor = list(melee = 50, bullet = 80, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0
	slowdown = 0

/obj/item/clothing/glasses/eyepatch/fluff/wright
	name = "eyepatch"
	desc = "Yarr, this be a Donor Item, YARR!"
	icon_state = "eyepatch"
	item_state = "eyepatch"

/obj/item/clothing/suit/armor/fluff/tristan
	name = "Sciency Teleport Armor"
	desc = "Some fancy looking armor, with lots of lights and buttons.  DONOR ITEM"
	icon_state = "reactive"
	item_state = "reactive"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 80, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	siemens_coefficient = 0


/obj/item/clothing/head/helmet/marine/fluff/tristan
	name = "Fancy Helmet"
	desc = "That's not red paint. That's real blood. DONOR ITEM"
	icon_state = "syndicate"
	item_state = "syndicate"
	armor = list(melee = 50, bullet = 80, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)


/obj/item/clothing/under/fluff/tristan
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon_state = "camojump"
	item_state = "camojump_s"
	item_color = "camojump"
	flags = FPRINT | TABLEPASS

/obj/item/weapon/lighter/zippo/fluff/ghost
	name = "Gold zippo lighter"
	desc = "A Golden Zippo lighter, engraved with the name John Donable: "
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "bluezippo"
	icon_on = "GOLDzippoon"
	icon_off = "GOLDzippo"

/obj/item/clothing/mask/cigarette/fluff/ghost
	name = "XXX's custom Cigar"
	desc = "A custom rolled giant, made specifically for John Donable in the best, hottest, and most abusive of cuban sweat shops."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 30


//GHOST CIGAR CODE
/obj/item/clothing/mask/cigarette/cigar/fluff/ghost/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/lighter/zippo/fluff/ghost))
		..()
	else
		user << "<span class='notice'>\The [src] straight out REFUSES to be lit by anything other than a purple zippo.</span>"