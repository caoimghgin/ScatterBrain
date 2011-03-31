-- library.applescript
-- Bombay

--  Created by Kevin Muldoon on 8/16/06.
--  Copyright 2006 __MyCompanyName__. All rights reserved.

(* works with "10.3.3" and above *)

on layoutObj() -- Extends imageObj()
	
	script layoutClass
		
		property parent : imageObj()
		property _id : null
		property _relativexy : null
		property _draw : true
		property _point : missing value
		property _scale : 1.0
		property _rotate : 0
		property errlog : ""
		
		on initialize(x)
			set _id to (((random number from 1 to 1000) as string) & ((random number from 1 to 1000) as string)) & ((random number from 1 to 1000) as string) as real
			set r to continue initialize(x)
			xyposition({0, 0}, 1)
			returnProperties()
		end initialize
		
		on nametag()
			return {yxyx(3) + 3, yxyx(2), yxyx(3) + 33, yxyx(4)}
		end nametag
		
		on imageGroupHeight()
			return item 3 of nametag() as item
		end imageGroupHeight
		
		on imageGroupWidth()
			return item 4 of nametag() as item
		end imageGroupWidth
		
		on scaleMax(w, h, r)
			
			-- if the object is bigger than the max size given then the object is scaled to best fit
			if physicalwidth() is less than or equal to w and physicalheight() is less than or equal to h then return true
			
			if w is greater than or equal to h and physicalwidth() is greater than or equal to physicalheight() then -- same orientation
			else
				if r then
					if _rotate = 90 then
						set _rotate to 0
					else
						set _rotate to 90
					end if
				end if
			end if
			
			set xScale to w / (physicalwidth())
			set yScale to h / (physicalheight())
			
			if yScale < xScale then
				set _scale to (round (yScale * 10000)) / 10000
			else if yScale > xScale then
				set _scale to (round (xScale * 10000)) / 10000
			else if yScale = xScale then
				set _scale to (round (yScale * 10000)) / 10000
			end if
			
		end scaleMax
		
		on reverseorientation()
			if _rotate is 90 then
				set _rotate to 0
			else
				set _rotate to 90
			end if
		end reverseorientation
		
		on getSquareArea()
			return (my _imagewidth) * (my _imageheight)
		end getSquareArea
		
		on orientationSelf()
			if (my _imagewidth) > (my _imageheight) then return "landscape"
			if (my _imagewidth) < (my _imageheight) then return "portrait"
			if (my _imagewidth) = (my _imageheight) then return "square"
		end orientationSelf
		
		on getOrientation(w, h)
			if w > h then return "landscape"
			if w < h then return "portrait"
			if w = h then return "square"
		end getOrientation
		
		on nudge(x, y)
			set _point to {((item 1 of _point) + x), ((item 2 of _point) + y)}
		end nudge
		
		on xyposition(xy, pt)
			if pt = 1 then set _point to {(item 1 of xy) + ((physicalwidth()) / 2), (item 2 of xy) + (physicalheight() / 2)} -- xyposition on top left
			if pt = 2 then set _point to {(item 1 of xy) - (physicalwidth() / 2), (item 2 of xy) + (physicalheight() / 2)} -- xyposition on top right
			if pt = 3 then set _point to {(item 1 of xy) - (physicalwidth() / 2), (item 2 of xy) - (physicalheight() / 2)} -- xyposition on bottom right
			if pt = 4 then set _point to {(item 1 of xy) + (physicalwidth() / 2), (item 2 of xy) - (physicalheight() / 2)} -- xyposition on bottom left
			if pt = 5 then set _point to {item 1 of xy, item 2 of xy} -- xyposition on center
		end xyposition
		
		on yxyxbounds()
			return {(item 2 of _point) - (physicalheight() / 2), (item 1 of _point) - (physicalwidth() / 2), (item 2 of _point) + (physicalheight() / 2), (item 1 of _point) + (physicalwidth() / 2)}
		end yxyxbounds
		
		on yxyx(i)
			return item i of yxyxbounds()
		end yxyx
		
		on pointarray()
			set r to {topleft:null, topright:null, bottomleft:null, bottomright:null}
			
			set (topleft of r) to {rounder(item 2 of yxyxbounds()), rounder(item 1 of yxyxbounds())}
			set (topright of r) to {rounder((item 2 of yxyxbounds()) + physicalwidth()), rounder(item 1 of yxyxbounds())}
			set (bottomleft of r) to {rounder((item 2 of yxyxbounds())), rounder((item 1 of yxyxbounds()) + physicalheight())}
			set (bottomright of r) to {rounder((item 2 of yxyxbounds()) + physicalwidth()), rounder((item 1 of yxyxbounds()) + physicalheight())}
			return r
		end pointarray
		
		on scaleToFitBounds(maxW, maxH, rotatebool)
			if physicalwidth() > maxW or physicalheight() > maxH then
				if orientationSelf() is not equal to "square" and getOrientation(maxW, maxH) is not equal to "square" and orientationSelf() is not equal to getOrientation(maxW, maxH) and rotatebool then
					my reverseorientation()
				end if
				if physicalwidth() > maxW or physicalheight() > maxH then my setscale(maxW, maxH)
			end if
		end scaleToFitBounds
		
		on setscale(x, y)
			set xScale to x / (physicalwidth())
			set yScale to y / (physicalheight())
			if yScale < xScale then
				set _scale to (round (yScale * 10000)) / 10000
			else if yScale > xScale then
				set _scale to (round (xScale * 10000)) / 10000
			else if yScale = xScale then
				set _scale to (round (yScale * 10000)) / 10000
			end if
		end setscale
		
		on setRotate(r)
			set _rotate to r
		end setRotate
		
		on physicalwidth()
			if _rotate = 0 then return (my _imagewidth) * _scale
			if _rotate = 90 then return (my _imageheight) * _scale
		end physicalwidth
		
		on physicalheight()
			if _rotate = 0 then return (my _imageheight) * _scale
			if _rotate = 90 then return (my _imagewidth) * _scale
		end physicalheight
		
		on rounder(n)
			set z to n * 10000
			set y to round z
			return y / 10000
		end rounder
		
		on returnProperties()
			set r to continue returnProperties()
			set r to r & {_id:_id, _relativexy:_relativexy, _draw:_draw, _point:_point, _scale:_scale, _rotate:_rotate}
			return r
		end returnProperties
		
	end script
end layoutObj


on imageObj() -- Extends finderObj()
	
	script imageClass
		
		property parent : finderObj()
		property _imageppi : null
		property _imagewidth : null
		property _imageheight : null
		property _imagebitdepth : null
		property _imagecolorspace : null
		property _imageprofile : null
		
		on initialize(x)
			set r to continue initialize(x)
			infoImage(r's _itempath, r's _itemfiletype)
			returnProperties()
		end initialize
		
		on returnProperties()
			set r to continue returnProperties()
			set r to r & {_imagewidth:_imagewidth, _imageheight:_imageheight, _imageppi:_imageppi, _imagebitdepth:_imagebitdepth, _imagecolorspace:_imagecolorspace, _imageprofile:_imageprofile}
			return r
		end returnProperties
		
		on infoImage(_itempath, _itemfiletype)
			
			tell application "Image Events"
				launch
				set _v_ to version
			end tell
			
			if {"EPSF", "EPS "} contains (_itemfiletype) then
				return my infoImageEPSF(_itempath)
			else
				try
					tell application "Image Events"
						launch
						set img to open _itempath
						
						tell img
							
							set r to (resolution)
							set d to (dimensions)
							set _imageppi to ((item 1 of r) as real)
							set _imagewidth to ((item 1 of (d)) / (_imageppi / 72))
							set _imageheight to ((item 2 of (d)) / (_imageppi / 72))
							
							if (_v_ as real) > 1.0 then
								
								try
									set r to (name of embedded profile)
									if (count of r) > 0 then
										set _imageprofile to (name of embedded profile)
									end if
								on error
									set _imageprofile to missing value
								end try
								
								-- I like to coerce the bit depth into a string
								-- to make it easier to put result into other apps
								-- the bit depth returned is a data type that may not 
								-- work outside of the "Image Events" tell statement
								
								try
									if (bit depth) = missing value then
										set _imagebitdepth to ""
									else if (bit depth) = sixteen colors then
										set _imagebitdepth to "sixteen colors"
									else if (bit depth) = color then
										set _imagebitdepth to "color"
									else if (bit depth) = four grays then
										set _imagebitdepth to "four grays"
									else if (bit depth) = black & white then
										set _imagebitdepth to "black & white"
									else if (bit depth) = thousands of colors then
										set _imagebitdepth to "thousands of colors"
									else if (bit depth) = grayscale then
										set _imagebitdepth to "grayscale"
									else if (bit depth) = two hundred fifty six grays then
										set _imagebitdepth to "two hundred fifty six grays"
									else if (bit depth) = four colors then
										set _imagebitdepth to "four colors"
									else if (bit depth) = sixteen grays then
										set _imagebitdepth to "sixteen grays"
									else if (bit depth) = millions of colors then
										set _imagebitdepth to "millions of colors"
									else if (bit depth) = best then
										set _imagebitdepth to "best"
									else if (bit depth) = two hundred fifty six colors then
										set _imagebitdepth to "two hundred fifty six colors"
									else if (bit depth) = millions of colors then
										set _imagebitdepth to "millions of colors"
									end if
								end try
							end if
							
							-- I like to coerce the color space/mode into a string
							-- to make it easier to put result into other apps. The  
							-- color space/mode returned is a data type that may not 
							-- work outside of the "Image Events" tell statement
							
							if (color space) = CMYK then
								set _imagecolorspace to "CMYK"
							else if (color space) = RGB then
								set _imagecolorspace to "RGB"
							else if (color space) = Gray then
								set _imagecolorspace to "Gray"
							else if (color space) = Lab then
								set _imagecolorspace to "Lab"
							else if (color space) = XYZ then
								set _imagecolorspace to "XYZ"
							else if (color space) = named then
								set _imagecolorspace to "Named"
							else if (color space) = Five channel or (color space) = Five color then
								set _imagecolorspace to "Five channel"
							else if (color space) = Six channel or (color space) = Six color then
								set _imagecolorspace to "Six channel"
							else if (color space) = Seven channel or (color space) = Seven color then
								set _imagecolorspace to "Seven channel"
							else if (color space) = Eight channel or (color space) = Eight color then
								set _imagecolorspace to "Eight channel"
							else
								set _imagecolorspace to (color space) as string
							end if
							
						end tell
						close img
					end tell
					
					return {_imageppi:_imageppi, _imagewidth:_imagewidth, _imageheight:_imageheight, _imagebitdepth:_imagebitdepth, _imageprofile:_imageprofile, _imagecolorspace:_imagecolorspace}
					
				on error errmsg
					return errmsg
				end try
			end if
			
		end infoImage
		
		on infoImageEPSF(_alias)
			try
				set _alias to _alias as text
				open for access file (_alias)
				set storedInfo to read file (_alias) from 1 to 1000000
				close access file (_alias)
				repeat with i from 1 to the number of paragraphs of storedInfo
					if paragraph i of storedInfo contains "BoundingBox" then
						--it looks something like this "%%BoundingBox: 0 0 144 144"
						set epsfBounds to paragraph i of storedInfo
						exit repeat
					end if
				end repeat
				--get rid of spaces before and after the data
				set x to offset of ":" in epsfBounds
				set theData to characters (x + 1) thru -1 of epsfBounds
				repeat until first item of theData is not " "
					set theData to the rest of theData
				end repeat
				
				if last item of theData is " " then
					set theData to items 1 thru -2 of theData
				end if
				
				set theCleanData to ""
				repeat with i in theData
					set theCleanData to theCleanData & i
				end repeat
				
				set oldDelims to AppleScript's text item delimiters
				set AppleScript's text item delimiters to " "
				--lower left horizontal
				set boxA to text item 1 of theCleanData as number
				--lower left vertical
				set boxB to text item 2 of theCleanData as number
				--upper right horizontal
				set boxC to text item 3 of theCleanData as number
				--upper right vertical
				set boxD to text item 4 of theCleanData as number
				set AppleScript's text item delimiters to oldDelims
				
				set imageWidthInPoints to boxC - boxA
				set imageHeightInPoints to boxD - boxB
				
				--return {imageWidthInPoints, imageHeightInPoints}
				set _imagewidth to imageWidthInPoints
				set _imageheight to imageHeightInPoints
				
				return {_imageppi:null, _imagewidth:_imagewidth, _imageheight:_imageheight, _imagebitdepth:null, _imageprofile:null, _imagecolorspace:null}
			on error errText number errNum
				close access file (_alias)
				return {_imageppi:null, _imagewidth:null, _imageheight:null, _imagebitdepth:null, _imageprofile:null, _imagecolorspace:null}
			end try
		end infoImageEPSF
	end script
end imageObj

on finderObj() -- Extends application "Finder"
	
	script finderClass
		
		property parent : application "Finder"
		property _osxversion : my version
		property _itemname : null
		property _itempath : null
		property _itemcreationdate : null
		property _itemmodificationdate : null
		property _itemiconposition : null
		property _itemsize : null
		property _itemfolder : null
		property _itemalias : null
		property _itempackagefolder : null
		property _itemvisible : null
		property _itemextensionhidden : null
		property _itemnameextension : null
		property _itemdisplayedname : null
		property _itemdefaultapplication : null
		property _itemkind : null
		property _itemfiletype : null
		property _itemfilecreator : null
		property _itemtypeidentifier : null
		property _itemlocked : null
		property _itembusystatus : null
		property _itemshortversion : null
		property _itemlongversion : null
		property _itemclass : null
		property _itemindex : null
		property _itemcontainer : null
		property _itemposition : null
		property _itemdesktopposition : null
		property _itembounds : null
		property _itemlabelindex : null
		property _itemdescription : null
		property _itemcomment : null
		property _itemphysicalsize : null
		property _itemicon : null
		property _itemURL : null
		property _itemowner : null
		property _itemgroup : null
		property _itemownerprivileges : null
		property _itemgroupprivileges : null
		property _itemeveryonesprivileges : null
		property _itemcreatortype : null
		property _itemstationery : null
		property _itemproductversion : null
		property _itemversion : null
		property _itemnameminusext : null
		property _eventLog : {}
		
		on initialize(x)
			set r to infoItem(x)
			propertiesItemSet(r)
		end initialize
		
		on infoItem(x)
			set _itempath to (x as alias)
			set r1 to continue info for _itempath
			tell application "Finder" to set r2 to properties of _itempath
			set r to r1 & r2 & {_itempath:(x as alias)}
			return r
		end infoItem
		
		on propertiesItemSet(r)
			
			set _itemname to (name of r)
			
			-- set _itempath to (_itempath of r)
			set _itemcreationdate to (creation date of r)
			set _itemmodificationdate to (modification date of r)
			-- set _itemiconposition to (item path of r)
			set _itemsize to (size of r)
			set _itemfolder to (folder of r)
			
			set _itemalias to (alias of r)
			set _itempackagefolder to (package folder of r)
			set _itemvisible to (visible of r)
			set _itemextensionhidden to (extension hidden of r)
			set _itemnameextension to (name extension of r)
			set _itemdisplayedname to (displayed name of r)
			set _itemdefaultapplication to (default application of r)
			set _itemkind to (kind of r)
			set _itemfiletype to (file type of r)
			set _itemfilecreator to (file creator of r)
			
			
			if (_itemkind is not equal to "Folder") and (_itemkind is not equal to "Volume") then
				
				try
					set _itemtypeidentifier to (type identifier of r)
				on error
					set _itemtypeidentifier to missing value
				end try
				
				set _itemlocked to (locked of r)
				set _itembusystatus to (busy status of r)
				set _itemshortversion to (short version of r)
				set _itemlongversion to (long version of r)
			end if
			set _itemclass to ((class of r) as string)
			set _itemindex to (index of r)
			
			
			tell application "Finder"
				set _itemcontainer to ((container of r) as alias)
				set _itemposition to (position of r)
				try
					set _itemdesktopposition to (desktop position of r)
				on error
					set _itemdesktopposition to missing value
				end try
				
				set _itembounds to (bounds of r)
				set _itemlabelindex to (label index of r)
				set _itemdescription to (description of r)
				set _itemcomment to (comment of r)
				set _itemphysicalsize to (physical size of r)
				set _itemicon to (icon of r)
				set _itemURL to (URL of r)
				set _itemowner to (owner of r)
				set _itemgroup to (group of r)
				set _itemownerprivileges to ((owner privileges of r) as string)
				set _itemgroupprivileges to ((group privileges of r) as string)
				set _itemeveryonesprivileges to ((everyones privileges of r) as string)
				
				if (_itemkind is not equal to "Folder") and (_itemkind is not equal to "Volume") then
					set _itemcreatortype to (creator type of r)
					set _itemstationery to (stationery of r)
					set _itemproductversion to (product version of r)
					set _itemversion to (version of r)
				end if
				
			end tell
			
			if (_itemnameextension) is not equal to missing value then
				set _itemnameminusext to characters 1 thru -((length of (_itemnameextension)) + 2) of _itemname as string
			else
				set _itemnameminusext to _itemname
			end if
			
			returnProperties()
			
		end propertiesItemSet
		
		on propertiesImageSet(r)
			set _imageppi to (_imageppi of r)
			set _imagewidth to (_imagewidth of r)
			set _imageheight to (_imageheight of r)
			set _imagebitdepth to (_imagebitdepth of r)
			set _imageprofile to (_imageprofile of r)
			set _imagecolorspace to (_imagecolorspace of r)
			returnProperties()
		end propertiesImageSet
		
		on moveSelf(f)
			set end of _eventLog to "moveSelf() '" & ((my _itempath) as string) & "' to '" & f & "'."
			tell application "Finder" to move (my _itempath) to (f as alias)
			initialize(((f as string) & my _itemname) as alias)
			--my initialize  Item(((f as string) & my _itemname) as alias)
			-- my propertiesItemSet(my infoItem(((f as string) & my _itemname) as alias))
		end moveSelf
		
		on nameSelf(nn)
			set end of _eventLog to "nameSelf() '" & ((my _itempath) as string) & "' to '" & nn & "'."
			tell application "Finder" to set name of (my _itempath) to nn (* rename item  *)
			set my _itemname to nn (* update object properties *)
		end nameSelf
		
		(*
		on moveSelfSafe(f)
			set fobj to load script file (((path to scripts folder) as string) & "Library:" & "com.truebluedot.iteminfo.scpt")
			fobj's propertiesItemSet(fobj's infoItem(f))
			if (fobj's _itemkind  is not equal to  "Folder") and (fobj's _itemkind  is not equal to  "Volume") then error "moveSelfSafe(f):Destination is not Volume or Folder."
			
			if existsItem(((fobj's _itempath) as string) & my _itemname) = false then
				my moveSelf(f)
			else
				
				repeat 500 times
					set nn to my _itemnameminusext & " " & (do shell script "date +\"%H-%M-%S\"") & "." & my _itemnameextension
					set newloc to (fobj's _itemcontainer as string) & nn
					set currloc to (my _itemcontainer as string) & nn
					
					if existsItem(newloc) = false and existsItem(currloc) = false then
						my nameSelf(nn)
						my moveSelf(f)
						exit repeat
					end if
				end repeat
			end if
			
		end moveSelfSafe
		*)
		
		on move x to f
			set x to (x as alias)
			set f to (f as alias)
			set r to continue move x to f
			return (r as alias)
		end move
		
		on existsItem(p)
			set r to false
			try
				set p to p as alias
				set r to true
			end try
			return r
		end existsItem
		
		on existsItemStartsWith(_pathVar, _ssVar)
			tell application "Finder"
				set r to every folder of alias _pathVar whose name begins with _ssVar
				if (count of r) = 1 then
					set _itempath to r as alias
					set _itemname to name of _itempath
				end if
				if (count of r) > 1 then set _multipleitems to true
			end tell
		end existsItemStartsWith
		
		on setLabelIndex(intVar)
			tell application "Finder" to set label index of _itempath to intVar
			set _itemlabelindex to intVar
		end setLabelIndex
		
		on returnProperties()
			return {_itemname:_itemname, _itempath:_itempath, _itemcreationdate:_itemcreationdate, _itemmodificationdate:_itemmodificationdate, _itemiconposition:_itemiconposition, _itemsize:_itemsize, _itemfolder:_itemfolder, _itemalias:_itemalias, _itempackagefolder:_itempackagefolder, _itemvisible:_itemvisible, _itemextensionhidden:_itemextensionhidden, _itemnameextension:_itemnameextension, _itemdisplayedname:_itemdisplayedname, _itemdefaultapplication:_itemdefaultapplication, _itemkind:_itemkind, _itemfiletype:_itemfiletype, _itemfilecreator:_itemfilecreator, _itemtypeidentifier:_itemtypeidentifier, _itemlocked:_itemlocked, _itembusystatus:_itembusystatus, _itemshortversion:_itemshortversion, _itemlongversion:_itemlongversion, _itemclass:_itemclass, _itemindex:_itemindex, _itemcontainer:_itemcontainer, _itemposition:_itemposition, _itemdesktopposition:_itemdesktopposition, _itembounds:_itembounds, _itemlabelindex:_itemlabelindex, _itemdescription:_itemdescription, _itemcomment:_itemcomment, _itemphysicalsize:_itemphysicalsize, _itemicon:_itemicon, _itemURL:_itemURL, _itemowner:_itemowner, _itemgroup:_itemgroup, _itemownerprivileges:_itemownerprivileges, _itemgroupprivileges:_itemgroupprivileges, _itemeveryonesprivileges:_itemeveryonesprivileges, _itemcreatortype:_itemcreatortype, _itemstationery:_itemstationery, _itemproductversion:_itemproductversion, _itemversion:_itemversion, _itemnameminusext:_itemnameminusext, _osxversion:_osxversion}
		end returnProperties
		
	end script
	
end finderObj

(*
on finderObj()
	script foo
		property parent : ext()
		property _multipleitems : false
		property _itemname : missing value
		property _itempath : missing value
		on ifExistsStartsWith(_pathVar, _ssVar)
			tell application "Finder"
				set r to every folder of alias _pathVar whose name begins with _ssVar
				if (count of r) = 1 then
					set _itempath to r as alias
					set _itemname to name of _itempath
				end if
				if (count of r) > 1 then set _multipleitems to true
			end tell
		end ifExistsStartsWith
	end script
end finderObj
*)

(*
on ext()
	script bar
		property _name : "BOBBYSUE"
	end script
end ext
*)