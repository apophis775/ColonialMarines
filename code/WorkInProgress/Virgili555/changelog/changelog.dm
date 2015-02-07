var/changelogmysql = null
var/limit = 15 // Putting it here so it can be accessed easier later.
/client/proc/showchanges()
	if(!changelogmysql)
		var/DBQuery/r_query = dbcon.NewQuery("SELECT * FROM `changelog` ORDER BY `id` DESC")
		changelogmysql += "<head><style type='text/css'>div.ex{width:400px;padding:10px;border-bottom:thin dashed #ff0000;margin:auto;}<body>body{font-size: 9pt;font-family: Verdana, sans-serif;}h1, h2, h3, h4, h5, h6{color: #00f;font-family: Georgia, Arial, sans-serif;}img { border: 0px; }p.lic {font-size: 6pt;}</style></head>"
		src << browse_rsc('html/postcardsmall.jpg')
		src << browse_rsc('html/somerights20.png')
		src << browse_rsc('html/88x31.png')
		changelogmysql += {"
<h2>Changelog</h2><br>
		"}
		if(!r_query.Execute())
			world << "Failed-[r_query.ErrorMsg()]"
		else
			var/counter
			while(r_query.NextRow())
				var/list/column_data = r_query.GetRowData()
				changelogmysql += "<h3>Revision [column_data["version"]] - [column_data["date"]]</h3>"
				changelogmysql += "<b><u>[column_data["bywho"]]:</u><br></b>"
				changelogmysql += "[column_data["changes"]]<br>"
				counter++
				if(counter >= limit)
					break
	//	changelogmysql += "<br><p><b>Developers</b>: Virgil, IMVader<br>"
		changelogmysql += "<b>Special thanks</b>: /TG/Station, Baystation12, Goon Station 13"
		changelogmysql += "<p class=\"lic\"><a name=\"license\" href=\"http://creativecommons.org/licenses/by-nc-sa/3.0/\"><img src=\"88x31.png\" alt=\"Creative Commons License\" /></a><br><i><font size=\"1\">Except where otherwise noted, SS-CN is licensed under a <a href=\"http://creativecommons.org/licenses/by-nc-sa/3.0/\">Creative Commons Attribution-Noncommercial-Share Alike 3.0 License</a>.<br>All Rights Reserved</font></i></p>"
		changelogmysql += "</body>"

		src << browse(changelogmysql,"window=changes;size=400x650;")
	else
		src << browse(changelogmysql,"window=changes;size=400x650;")


/client/verb/shownewlog()
	set name = "Show changelog"
	set category = "OOC"

	showchanges()

/*
This proc is currently bugged, just remove and remake a changelog entry if you need to modify it for now.

client/proc/modifychange()
	set name = "Edit Changelog Entry"
	set category = "Admin"

	if(!check_rights(0))	return

	var/revision = input("Changelog revision to modify","Revision:",0) as num|null
	if(!revision)	return

	var/DBQuery/r_query = dbcon.NewQuery("SELECT * FROM `changelog` WHERE `version`=[revision]")
	var/column_data = r_query.GetRowData()
	if(!r_query.Execute())
		world << "Failed-[r_query.ErrorMsg()]"
		return

	var/newchanges = input("Add your changelog entry. Supports basic html.","Changelog entry", "[column_data["changes"]]") as message|null
	if(!newchanges)	return

	var/DBQuery/r_query2 = dbcon.NewQuery("UPDATE `changelog` SET `changes`=[newchanges] WHERE `version`=[revision]")
	if(!r_query2.Execute())
		world << "Failed-[r_query.ErrorMsg()]"
	else
	//	usr << "<b>Changelog updated successfully.</b>"
		log_admin("[key_name_admin(src)] edited a changelog entry for revision [revision].")
		message_admins("[key_name_admin(src)] edited changelog entry for revision [revision].", 1)
		changelogmysql = null*/