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
	desc = "Some fancy looking armor, that probably won't help in combat.  DONOR ITEM"
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/fluff/sas
	name = "Juggernaut Armor"
	desc = "Some fancy looking armor, that probably won't help in combat. DONOR ITEM"
	icon_state = "rig-syndi"
	item_state = "syndie_hardsuit"
	blood_overlay_type = "armor"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
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
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/swat/fluff/wright
	name = "Swat Armor"
	desc = "Some fancy looking armor, that probably won't help in combat. DONOR ITEM"
	icon_state = "deathsquad"
	item_state = "swat_suit"
	blood_overlay_type = "armor"
	allowed = list()
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0
	slowdown = 0

/obj/item/clothing/glasses/eyepatch/fluff/wright
	name = "eyepatch"
	desc = "Yarr, this be a Donor Item, YARR!"
	icon_state = "eyepatch"
	item_state = "eyepatch"