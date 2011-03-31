-- com.truebluedot.scatterbrain.applescript
-- ScatterBrain v0.5.3

--  Created by Kevin on 8/17/06.
--  Copyright 2006 __TrueBlueDot, Inc.__. All rights reserved.

property imglst : {}
property pglst : {}
property tagdepth : missing value
property xSpace : missing value
property ySpace : missing value
property pgWidth : missing value
property pgHeight : missing value
property reducePage : missing value
property BrainSize : missing value
property itemList : missing value
property pgobj : missing value
property maxImageWidth : ""
property maxImageHeight : ""
property forcelandscape : false
property forceportrait : false
property dpthBrain0 : 0
property layoutApplication : missing value

on scatterbrain()
	
	set imglst to {}
	set pglst to {}
	
	set pgobj to load script POSIX file (path for main bundle script "com.truebluedot.page" extension "scpt")
	set imgobj to load script POSIX file (path for main bundle script "com.truebluedot.item" extension "scpt")
	
	(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	(* :::::::::::::::::::: CREATE FIRST PAGE OBJECT  ::::::::::::::::::: *)
	(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	
	copy pgobj to pg
	pg's init({pgWidth, pgHeight}, 1)
	pg's set_margins(36, 36, 36, 36)
	set end of pglst to pg
	
	(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	(* ::::::::::::::::::::::::: INIT IMAGE OBJECTS  ::::::::::::::::::::::: *)
	(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	
	repeat with i in itemList
		set img to imgobj's layoutObj()
		img's initialize(i)
		
		if placeableBool(img) then
			if maxImageWidth is not 0 and maxImageWidth is not 0 then img's scaleToFitBounds(maxImageWidth, maxImageHeight, true)
			
			if forcelandscape or forceportrait then
				if img's orientationSelf() is not "square" then
					if forcelandscape then
						if img's orientationSelf() is not "landscape" then img's reverseorientation()
					end if
					if forceportrait then
						if img's orientationSelf() is not "portrait" then img's reverseorientation()
					end if
				end if
			end if
			
			img's scaleToFitBounds(pgWidth, (pgHeight - tagdepth), true)
			img's xyposition({0, 0}, 1)
			set end of imglst to img
		end if
	end repeat
	
	(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	(* :::::::::::::::::::::::::::::::: BEGIN AI  :::::::::::::::::::::::::::::: *)
	(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	
	set thinkstart to (current date)
	
	
	if BrainSize = 0 then brain0()
	if BrainSize = 3 then brain3()
	if BrainSize = 4 then brain4()
	if BrainSize = 5 then brain5()
	
	(*
	set thinkend to ((thinkstart - (current date)) as string) & " seconds."
	set msg to ((BrainSize as string) & tab & (length of itemList) as string) & tab & thinkend
	my writeFileAsString(((path to desktop) as string) & "log.txt", msg)
	*)
	--display dialog "END AI" & ((current date) - xyz) as string
	--set xyz to current date
	if layoutApplication = "Adobe InDesign" then
		set indd to load script POSIX file (path for main bundle script "com.truebluedot.indd" extension "scpt")
		
		-- set indd to load script file (((path to scripts folder) as string) & "Library:" & "com.truebluedot.indd.scpt")
		
		indd's capturePrefs()
		indd's setPrefs(first item of pglst)
		
		
		--			
		--				
		
		set reduceHeight to 0
		set reduceWidth to 0
		if length of pglst = 1 and reducePage = 1 then
			repeat with img in pg's _placedimglst
				if img's imageGroupHeight() > reduceHeight then set reduceHeight to img's imageGroupHeight()
				if img's imageGroupWidth() > reduceWidth then set reduceWidth to img's imageGroupWidth()
			end repeat
			pg's init({reduceWidth, reduceHeight}, 1)
		end if
		
		indd's createDoc(first item of pglst)
		
		repeat with pg in pglst
			repeat with img in pg's _placedimglst
				indd's import3(img, pg's _number)
			end repeat
		end repeat
		
		
		indd's resetPrefs()
	else if layoutApplication = "QuarkXPress" then
		-- set qxp to load script file (((path to scripts folder) as string) & "Library:" & "com.truebluedot.qxp.scpt")
		set qxp to load script POSIX file (path for main bundle script "com.truebluedot.qxp" extension "scpt")
		
		qxp's capturePrefs()
		qxp's setPrefs(first item of pglst)
		qxp's createDoc()
		repeat with pg in pglst
			repeat with img in pg's _placedimglst
				qxp's import2(img, pg's _number)
			end repeat
		end repeat
		qxp's resetPrefs()
		
	end if
	
end scatterbrain


(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
(* :::::::::::::::::::::::::::: SUBROUTINES  ::::::::::::::::::::::::::: *)
(* ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)

on brain0()
	set imglst to my sortimglst(imglst, true)
	
	repeat until (length of imglst) = 0
		set imageplaced to false
		
		-- PLACE FIRST ITEM
		if length of (last item of pglst)'s _placedimglst = 0 then
			
			(item 1 of imglst)'s xyposition({0, 0}, 1)
			
			(last item of pglst)'s addimg(item 1 of imglst)
			set imglst to my poplst(imglst, 1)
			set imageplaced to true
			if dpthBrain0 < (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace) then set dpthBrain0 to (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace)
			
		end if
		
		-- attempt place NEXT in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				
				if dpthBrain0 < (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace) then set dpthBrain0 to (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace)
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
				
			end if
		end if
		
		
		-- MAKE NEW ROW
		if imageplaced = false then
			set xy to {0, dpthBrain0}
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
				
			end if
		end if
		
		-- MAKE NEW PAGE
		if imageplaced = false then -- make new page	
			-- display dialog (item 1 of imglst)'s _itemname & " new page."
			
			
			set pgnumber to ((last item of pglst)'s _number) + 1
			copy pgobj to (end of pglst)
			(last item of pglst)'s init({pgWidth, pgWidth}, pgnumber)
			(last item of pglst)'s set_margins(0, 0, 0, 0)
			set dpthBrain0 to 0
		end if
		
	end repeat
	
end brain0


(*
on brain0()
	-- no collision detection. Just a typewriter routine.
	
	set imglst to my sortimglst(imglst, true)
	
	repeat until (length of imglst) = 0
		set imageplaced to false
		
		-- PLACE FIRST ITEM
		if length of (last item of pglst)'s _placedimglst = 0 then
			(item 1 of imglst)'s xyposition({0, 0}, 1)
			(last item of pglst)'s addimg(item 1 of imglst)
			set imglst to my poplst(imglst, 1)
			set imageplaced to true
			if dpthBrain0 is less than (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace) then set dpthBrain0 to (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace)
			
		end if
		
		-- attempt place FIRST in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
				if dpthBrain0 < (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace) then set dpthBrain0 to (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace)
				
			end if
		else
			
		end if
		
		-- attempt place FIRST in list in next row down
		if imageplaced = false then
			set xy to {0, dpthBrain0}
			(item 1 of imglst)'s xyposition({(item 1 of xy), (item 2 of xy)}, 1)
			if (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
				if dpthBrain0 < (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace) then set dpthBrain0 to (((item 1 of imglst)'s yxyx(3)) + tagdepth + ySpace)
			end if
		end if
		
		-- MAKE NEW PAGE
		if imageplaced = false then -- make new page					
			set dpthBrain0 to 0
			set pgnumber to ((last item of pglst)'s _number) + 1
			copy pgobj to (end of pglst)
			(last item of pglst)'s init({pgWidth, pgWidth}, pgnumber)
			(last item of pglst)'s set_margins(0, 0, 0, 0)
		else	
			
		end if
		
	end repeat
	
end brain0
*)
on brain3()
	set imglst to my sortimglst(imglst, true)
	
	repeat until (length of imglst) = 0
		set imageplaced to false
		
		-- PLACE FIRST ITEM
		if length of (last item of pglst)'s _placedimglst = 0 then
			(item 1 of imglst)'s xyposition({0, 0}, 1)
			(last item of pglst)'s addimg(item 1 of imglst)
			set imglst to my poplst(imglst, 1)
			set imageplaced to true
		end if
		
		-- attempt place FIRST in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if pg_collision(item 1 of imglst as item, (last item of pglst)'s _placedimglst) = false and (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
			end if
		end if
		
		-- attempt place LAST in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			set imglst to reverse of imglst
			if pg_collision(item 1 of imglst as item, (last item of pglst)'s _placedimglst) = false and (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
			end if
			set imglst to reverse of imglst
		end if
		
		-- attempt place ALL at BOTTOM-LEFT of ALL images
		if imageplaced = false then
			repeat with j in (last item of pglst)'s _placedimglst
				set xy to bottomleft of j's pointarray()
				repeat with i from 1 to (length of imglst)
					(item i of imglst)'s xyposition({(item 1 of xy), (item 2 of xy) + ySpace + tagdepth}, 1)
					if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight) then
						(last item of pglst)'s addimg(item i of imglst)
						set imglst to my poplst(imglst, i)
						set imageplaced to true
						exit repeat
					end if
					if imageplaced then exit repeat
				end repeat
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- MAKE NEW PAGE
		if imageplaced = false then -- make new page		
			set pgnumber to ((last item of pglst)'s _number) + 1
			copy pgobj to (end of pglst)
			(last item of pglst)'s init({pgWidth, pgWidth}, pgnumber)
			(last item of pglst)'s set_margins(0, 0, 0, 0)
			
		end if
		
	end repeat
	
end brain3

on brain4()
	set imglst to my sortimglst(imglst, true)
	
	repeat until (length of imglst) = 0
		set imageplaced to false
		
		-- PLACE FIRST ITEM
		if length of (last item of pglst)'s _placedimglst = 0 then
			(item 1 of imglst)'s xyposition({0, 0}, 1)
			(last item of pglst)'s addimg(item 1 of imglst)
			set imglst to my poplst(imglst, 1)
			set imageplaced to true
		end if
		
		-- attempt place NEXT in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if pg_collision(item 1 of imglst as item, (last item of pglst)'s _placedimglst) = false and (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
			end if
		end if
		
		-- attempt place ALL at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			repeat with i from 1 to (length of imglst)
				(item i of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
				if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
					(last item of pglst)'s addimg(item i of imglst)
					set imglst to my poplst(imglst, i)
					set imageplaced to true
					exit repeat
				end if
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- attempt place ALL at BOTTOM-LEFT of ALL images
		if imageplaced = false then
			repeat with j in (last item of pglst)'s _placedimglst
				set xy to bottomleft of j's pointarray()
				repeat with i from 1 to (length of imglst)
					(item i of imglst)'s xyposition({(item 1 of xy), (item 2 of xy) + ySpace}, 1)
					if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
						(last item of pglst)'s addimg(item i of imglst)
						set imglst to my poplst(imglst, i)
						set imageplaced to true
						exit repeat
					end if
					if imageplaced then exit repeat
				end repeat
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- MAKE NEW PAGE
		if imageplaced = false then -- make new page		
			set pgnumber to ((last item of pglst)'s _number) + 1
			copy pgobj to (end of pglst)
			(last item of pglst)'s init({pgWidth, pgWidth}, pgnumber)
			(last item of pglst)'s set_margins(0, 0, 0, 0)
			
		end if
		
	end repeat
	
end brain4

on brain5()
	set imglst to my sortimglst(imglst, true)
	
	repeat until (length of imglst) = 0
		set imageplaced to false
		
		-- PLACE FIRST ITEM
		if length of (last item of pglst)'s _placedimglst = 0 then
			(item 1 of imglst)'s xyposition({0, 0}, 1)
			(last item of pglst)'s addimg(item 1 of imglst)
			set imglst to my poplst(imglst, 1)
			set imageplaced to true
		end if
		
		-- attempt place NEXT in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if pg_collision(item 1 of imglst as item, (last item of pglst)'s _placedimglst) = false and (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
			end if
		end if
		
		-- attempt place ALL at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			repeat with i from 1 to (length of imglst)
				(item i of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
				if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
					(last item of pglst)'s addimg(item i of imglst)
					set imglst to my poplst(imglst, i)
					set imageplaced to true
					exit repeat
				end if
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- attempt place ALL at BOTTOM-LEFT of ALL images
		if imageplaced = false then
			repeat with j in (last item of pglst)'s _placedimglst
				set xy to bottomleft of j's pointarray()
				repeat with i from 1 to (length of imglst)
					(item i of imglst)'s xyposition({(item 1 of xy), (item 2 of xy) + ySpace + tagdepth}, 1)
					if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
						(last item of pglst)'s addimg(item i of imglst)
						set imglst to my poplst(imglst, i)
						set imageplaced to true
						exit repeat
					end if
					if imageplaced then exit repeat
				end repeat
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- ROTATE and attempt place NEXT in list at TOP-RIGHT of LAST image
		if imageplaced = false then
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			
			(item 1 of imglst)'s reverseorientation()
			
			(item 1 of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
			if pg_collision(item 1 of imglst as item, (last item of pglst)'s _placedimglst) = false and (item 1 of imglst)'s yxyx(4) is less than or equal to pgWidth and (item 1 of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
				(last item of pglst)'s addimg(item 1 of imglst)
				set imglst to my poplst(imglst, 1)
				set imageplaced to true
			else
				
				(item 1 of imglst)'s reverseorientation()
				
			end if
		end if
		
		-- ROTATE and attempt place ALL at TOP-RIGHT of LAST image
		if imageplaced = false then
			
			set xy to topright of (last item of _placedimglst)'s pointarray() of (last item of pglst)
			repeat with i from 1 to (length of imglst)
				
				(item i of imglst)'s reverseorientation()
				
				(item i of imglst)'s xyposition({(item 1 of xy) + xSpace, (item 2 of xy)}, 1)
				if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
					(last item of pglst)'s addimg(item i of imglst)
					set imglst to my poplst(imglst, i)
					set imageplaced to true
					exit repeat
				else
					
					(item i of imglst)'s reverseorientation()
					
				end if
				
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- ROTATE and attempt place ALL at BOTTOM-LEFT of ALL images
		if imageplaced = false then
			repeat with j in (last item of pglst)'s _placedimglst
				set xy to bottomleft of j's pointarray()
				repeat with i from 1 to (length of imglst)
					
					(item i of imglst)'s reverseorientation()
					
					(item i of imglst)'s xyposition({(item 1 of xy), (item 2 of xy) + ySpace + tagdepth}, 1)
					if pg_collision(item i of imglst as item, (last item of pglst)'s _placedimglst) = false and (item i of imglst)'s yxyx(4) is less than or equal to pgWidth and (item i of imglst)'s yxyx(3) is less than or equal to (pgHeight - tagdepth) then
						(last item of pglst)'s addimg(item i of imglst)
						set imglst to my poplst(imglst, i)
						set imageplaced to true
						exit repeat
					else
						
						(item i of imglst)'s reverseorientation()
						
					end if
					
					if imageplaced then exit repeat
				end repeat
				if imageplaced then exit repeat
			end repeat
		end if
		
		-- MAKE NEW PAGE
		if imageplaced = false then -- make new page		
			set pgnumber to ((last item of pglst)'s _number) + 1
			copy pgobj to (end of pglst)
			(last item of pglst)'s init({pgWidth, pgWidth}, pgnumber)
			(last item of pglst)'s set_margins(0, 0, 0, 0)
			
		end if
		
	end repeat
	
end brain5


on rnd(n)
	return random number from 1 to n
end rnd

on sortimglst(lst, rev)
	if class of lst is not list then error "BubbleSort() did not receive a list"
	
	set lstlen to length of lst
	
	repeat with i from 1 to lstlen
		repeat with j from 2 to (lstlen - i + 1)
			
			set a to ((item (j - 1)) of lst)'s getSquareArea()
			set b to ((item (j)) of lst)'s getSquareArea()
			
			if a > b then
				set temp to (item (j - 1) of lst)
				set (item (j - 1) of lst) to (item j of lst)
				set (item j of lst) to temp
			end if
			
		end repeat
	end repeat
	
	if rev then set lst to (reverse of lst)
	set imglst to lst
	
end sortimglst


on poplst(lst, idx)
	
	(*
Copyright (c) 2003 HAS

property __name__ : "List"
property __version__ : "0.1.0"
property __lv__ : 1

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)
	
	try
		if lst's class is not list then error "not a list." number -1704
		script k
			property l : lst
		end script
		set len to count of k's l
		set ndx to idx as integer
		if ndx is 0 then
			error "index 0 is out of range." number -1728
		else if ndx < 0 then
			set ndx to len + 1 + ndx
			if ndx < 1 then error "index " & idx & " is out of range." number -1728
		else if ndx > len then
			error "index " & idx & " is out of range." number -1728
		end if
		if ndx is 1 then
			return rest of k's l
		else if ndx is len then
			return k's l's items 1 thru -2
		else
			return (k's l's items 1 thru (ndx - 1)) & (k's l's items (ndx + 1) thru -1)
		end if
	on error eMsg number eNum
		error "Can't deleteItem: " & eMsg number eNum
	end try
end poplst

on collision(z, a)
	
	(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	(* ::::::::   ACCEPTS two img objects and determines if any point of Z collides with A     ::::: *)
	(* ::::::::         if items are placed beyond bounds of page, results will be erratic            ::::: *)
	(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
	
	set x to (item 1 of z's _point) - (item 1 of a's _point)
	set y to (item 2 of z's _point) - (item 2 of a's _point)
	
	if x = 0 and y = 0 then -- at least one of the x or y's of center point of Z is DIRECTLY ON TOP of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center points on top of each other"
		(* items will definately collide. Return true*)
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	else if x < 0 and y = 0 then -- Z is DIRECTLY LEFT of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center point of new item is DIRECTLY LEFT of center point of placed item"
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set xtest to (item 1 of topleft of a's _pointarray) - (item 1 of topright of z's _pointarray)
		if xtest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	else if x > 0 and y = 0 then --Z is DIRECTLY RIGHT of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center point of new item is DIRECTLY RIGHT of center point of placed item"
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set xtest to (item 1 of bottomleft of z's _pointarray) - (item 1 of bottomright of a's _pointarray)
		if xtest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	else if x = 0 and y > 0 then --Z is DIRECTLY BELOW of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center point of new item is DIRECTLY BELOW of center point of placed item"
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set ytest to (item 2 of topleft of z's _pointarray) - (item 2 of bottomright of a's _pointarray)
		if ytest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	else if x = 0 and y < 0 then -- Z is DIRECTLY ABOVE of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
		-- display dialog "center point of new item is DIRECTLY ABOVE of center point of placed item"
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set ytest to (item 2 of topleft of a's _pointarray) - (item 2 of bottomleft of z's _pointarray)
		if ytest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
		
		(* I saw a problem here in LeftBelow, but was lazy and didn't capture the data...*)
		
	else if x is less than or equal to 0 and y is greater than or equal to 0 then -- Z is LEFT & BELOW of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		--display dialog "center point of new item is LEFT and BELOW of center point of placed item"
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set xtest to (item 1 of topleft of a's _pointarray) - (item 1 of bottomright of z's _pointarray)
		set ytest to (item 2 of topright of z's _pointarray) - (item 2 of bottomleft of a's _pointarray)
		if xtest < 0 and ytest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
		--display dialog "{" & xtest & ", " & ytest & "}"
		
	else if x is less than or equal to 0 and y is less than or equal to 0 then -- Z is LEFT & ABOVE of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center point of new item is LEFT and ABOVE center point of placed item"
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set xtest to (item 1 of topleft of a's _pointarray) - (item 1 of bottomright of z's _pointarray)
		set ytest to (item 2 of topleft of a's _pointarray) - (item 2 of bottomright of z's _pointarray)
		if xtest < 0 and ytest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	else if x is greater than or equal to 0 and y is greater than or equal to 0 then -- Z is RIGHT & BELOW of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center point of new item is RIGHT and BELOW center point of placed item"
		(* means that if topright of new item is > bottom right of place item, it's OK *)
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set xtest to (item 1 of topleft of z's _pointarray) - (item 1 of bottomright of a's _pointarray)
		set ytest to (item 2 of topleft of z's _pointarray) - (item 2 of bottomright of a's _pointarray)
		if xtest < 0 and ytest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	else if x is greater than or equal to 0 and y is less than or equal to 0 then -- Z is RIGHT & ABOVE of A
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		-- display dialog "center point of new item is RIGHT and ABOVE center point of placed item"
		(* means that if bottomleft of new item is > top right of place item, it's OK *)
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		set xtest to (item 1 of bottomleft of z's _pointarray) - (item 1 of topright of a's _pointarray)
		set ytest to (item 2 of topright of a's _pointarray) - (item 2 of bottomleft of z's _pointarray)
		if xtest < 0 and ytest < 0 then return true
		(* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: *)
		
	end if
	return false
end collision

on pg_collision(x, xlst)
	set r to false
	repeat with i in xlst
		if collision({_point:x's _point, _pointarray:x's pointarray()}, {_point:i's _point, _pointarray:i's pointarray()}) then set r to true
	end repeat
	return r
end pg_collision
(*
on importLayoutObject(obj)
	
	tell application "Adobe InDesign CS2"
		activate
		try
			
			-- Turn off user interaction to avoid Place PDF dialog
			--set user interaction level to never interact
			tell document 1
				
				
				tell page 1
					if obj's _itempath is not equal to null then
						set imgFrame to make rectangle with properties {geometric bounds:(obj's yxyxbounds()), stroke color:swatch id 18, fill color:swatch id 18}
						-- set ximg to place (obj's _itempath) on imgFrame
					else
						
						set txtFrame to make text frame with properties {geometric bounds:(obj's yxyxbounds()), stroke color:swatch id 18, fill color:swatch id 18}
						set contents of insertion point -1 of txtFrame to (obj's _itemname)
					end if
				end tell
				
				if obj's _itempath is not equal to null then
					set ximg to place (obj's _itempath) on imgFrame
					tell imgFrame
						tell ximg
							set absolute rotation angle to (obj's _rotate)
						end tell
						fit given proportionally
						--set realScale to vertical scale of image 1
					end tell
				end if
				
			end tell
			
		on error errmsg
			activate
			-- display dialog errMsg
			
		end try
		-- Turn user interaction back on again
		--set user interaction level to interact with all
	end tell
end importLayoutObject
*)
on writeFileAsString(fileSpec, txt)
	try
		set txt to txt as string
		open for access (fileSpec as file specification) with write permission returning fileRef
		try
			set eof of fileRef to 0
			write txt to fileRef as string
		on error eMsg number eNum
			close access fileRef
			error eMsg number eNum
		end try
		close access fileRef
		return
	on error eMsg number eNum
		error "Can't writeFile: " & eMsg number eNum
	end try
end writeFileAsString

on itemlistcnt()
	return length of itemList
end itemlistcnt

on placeableBool(img)
	if layoutApplication = "QuarkXPress" then
		if img's _itemnameextension = "psd" then return false
	end if
	return true
end placeableBool