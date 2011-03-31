-- ScatterBrain 1.0.1.applescript
-- ScatterBrain 1.0.1

--  Created by Kevin on 5/7/09.
--  Copyright 2009 __MyCompanyName__. All rights reserved.
-- ScatterBrain v0.5.applescript
-- ScatterBrain v0.5

--  Created by Kevin on 7/24/06.
--  Copyright 2006 __MyCompanyName__. All rights reserved.

-- ScatterBrain 0.4.applescript
-- ScatterBrain 0.4

--  Created by Kevin Muldoon on 7/24/06.
--  Copyright 2006 __MyCompanyName__. All rights reserved.

property scatterbrain : missing value

on idle
	(* Add any idle time processing here. *)
end idle

on open itemList
	set theWindow to window "Main"
	set scatterbrain to load script POSIX file (path for main bundle script "com.truebluedot.scatterbrain" extension "scpt")
	
	set scatterbrain's itemList to itemList
	(*
	set (contents of text field "name tag depth" of theWindow) to 30
	set (contents of text field "xspace" of theWindow) to 36
	set (contents of text field "yspace" of theWindow) to 8
	set (contents of text field "page width" of theWindow) to (1440 / 72)
	set (contents of text field "page height" of theWindow) to (864 / 72)
	*)
	set (contents of text field "item list count" of theWindow) to "Ready to ScatterBrain " & (scatterbrain's itemlistcnt() as string) & " item(s)"
	
	tell theWindow to center
	set visible of theWindow to true
	
end open

on clicked theObject
	set theWindow to the window of theObject
	if name of theObject = "OK" then
		set scatterbrain's tagdepth to (contents of text field "name tag depth" of theWindow) as real
		set scatterbrain's xSpace to (contents of text field "xspace" of theWindow) as real
		set scatterbrain's ySpace to (contents of text field "yspace" of theWindow) as real
		set scatterbrain's pgWidth to inches2points(contents of text field "page width" of theWindow)
		set scatterbrain's pgHeight to inches2points(contents of text field "page height" of theWindow)
		set scatterbrain's reducePage to (integer value of button "fitPage" of theWindow)
		
		if length of scatterbrain's itemList < 40 then
			set scatterbrain's BrainSize to 5
		else
			set scatterbrain's BrainSize to 0
		end if
		
		set scatterbrain's maxImageWidth to inches2points(contents of text field "Max Image Width" of theWindow)
		set scatterbrain's maxImageHeight to inches2points(contents of text field "Max Image Height" of theWindow)
		set scatterbrain's layoutApplication to title of current menu item of popup button "layoutApplication" of theWindow
		
		set visible of theWindow to false
		
		tell window "ScatterBrain Progress"
			center
			set uses threaded animation of progress indicator "progress" to true
			start progress indicator "progress"
			set visible to true
		end tell
		
		scatterbrain's scatterbrain()
		quit
	else if name of theObject = "Cancel" then
		quit
	end if
end clicked

on loadLib(lib)
	set p to scripts path of main bundle & "/" & lib
	try
		set theScriptObj to load script POSIX file (p)
	on error errmsg number errNum
		log "ERROR loadLib(). " & "Error:  " & errNum & " Msg: " & errmsg
		display dialog "ERROR loadLib(): " & errNum & ".  " & errmsg
	end try
	log "loadLib(lib) loads '" & lib & "'"
	return theScriptObj
end loadLib

on inches2points(x)
	try
		set r to x as real
		set r to r * 72
		return r
	on error
		return 0
	end try
end inches2points

on will quit theObject
	set theWindow to window "Main"
	
	set nameTagDepth to (contents of text field "name tag depth" of theWindow)
	set xSpace to (contents of text field "xspace" of theWindow)
	set ySpace to (contents of text field "yspace" of theWindow)
	set pageWidth to (contents of text field "page width" of theWindow)
	set pageHeight to (contents of text field "page height" of theWindow)
	set layoutApplication to (title of popup button "layoutapplication" of theWindow)
	set maxImageWidth to (contents of text field "Max Image Width" of theWindow)
	set maxImageHeight to (contents of text field "Max Image Height" of theWindow)
	set fitPage to (integer value of button "fitPage" of theWindow)
	
	tell user defaults
		make new default entry at end of default entries with properties {name:"nameTagDepth", contents:nameTagDepth}
		make new default entry at end of default entries with properties {name:"xspace", contents:xSpace}
		make new default entry at end of default entries with properties {name:"yspace", contents:ySpace}
		make new default entry at end of default entries with properties {name:"pageWidth", contents:pageWidth}
		make new default entry at end of default entries with properties {name:"pageHeight", contents:pageHeight}
		make new default entry at end of default entries with properties {name:"layoutApplication", contents:layoutApplication}
		make new default entry at end of default entries with properties {name:"maxImageWidth", contents:maxImageWidth}
		make new default entry at end of default entries with properties {name:"maxImageHeight", contents:maxImageHeight}
		make new default entry at end of default entries with properties {name:"fitPage", contents:fitPage}
		
		register
		
		set contents of default entry "nameTagDepth" to nameTagDepth
		set contents of default entry "xSpace" to xSpace
		set contents of default entry "ySpace" to ySpace
		set contents of default entry "pageWidth" to pageWidth
		set contents of default entry "pageHeight" to pageHeight
		set contents of default entry "layoutApplication" to layoutApplication
		set contents of default entry "maxImageWidth" to maxImageWidth
		set contents of default entry "maxImageHeight" to maxImageHeight
		set contents of default entry "fitPage" to fitPage
		
		(*
		make new default entry at end of default entries with properties {name:"nameTagDepth", contents:nameTagDepth}
		make new default entry at end of default entries with properties {name:"xspace", contents:xSpace}
		make new default entry at end of default entries with properties {name:"yspace", contents:ySpace}
		make new default entry at end of default entries with properties {name:"pageWidth", contents:pageWidth}
		make new default entry at end of default entries with properties {name:"pageHeight", contents:pageHeight}
		make new default entry at end of default entries with properties {name:"layoutApplication", contents:layoutApplication}
		make new default entry at end of default entries with properties {name:"maxImageWidth", contents:maxImageWidth}
		make new default entry at end of default entries with properties {name:"maxImageHeight", contents:maxImageHeight}
		register
		*)
	end tell
	
	
end will quit

on will finish launching theObject
	set theWindow to window "Main"
	
	try
		tell user defaults
			set nameTagDepth to contents of default entry "nameTagDepth"
			set xSpace to contents of default entry "xspace"
			set ySpace to contents of default entry "yspace"
			set pageWidth to contents of default entry "pageWidth"
			set pageHeight to contents of default entry "pageHeight"
			set layoutApplication to contents of default entry "layoutApplication"
			set maxImageWidth to contents of default entry "maxImageWidth"
			set maxImageHeight to contents of default entry "maxImageHeight"
			set fitPage to contents of default entry fitPage
			
		end tell
		
		set (contents of text field "name tag depth" of theWindow) to nameTagDepth
		set (contents of text field "xspace" of theWindow) to xSpace
		set (contents of text field "yspace" of theWindow) to ySpace
		set (contents of text field "page width" of theWindow) to pageWidth
		set (contents of text field "page height" of theWindow) to pageHeight
		set (title of popup button "layoutApplication" of theWindow) to layoutApplication
		set (contents of text field "Max Image Width" of theWindow) to maxImageWidth
		set (contents of text field "Max Image Height" of theWindow) to maxImageHeight
		set (integer value of button "fitPage" of theWindow) to fitPage
	end try
end will finish launching

on will hide theObject
	(*Add your script here.*)
end will hide
