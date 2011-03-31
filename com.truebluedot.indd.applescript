property viewPrefs : missing value
property docPrefs : missing value
property marginPrefs : missing value
property swatchIDwhite : missing value
property swatchIDnone : missing value


on createDoc(pg)
	tell application "Adobe InDesign CS3"
		set mydocument to make document
		tell document preferences of mydocument
			set page width to ((pg's _width) as string) & " pt"
			set page height to ((pg's _height) as string) & " pt"
		end tell
		
		set swatchIDwhite to (id of swatch "Paper" of mydocument)
		set swatchIDnone to (id of swatch "None" of mydocument)
		
	end tell
end createDoc

on import {img, clr}
	tell application "Adobe InDesign CS3"
		activate
		try
			-- Turn off user interaction to avoid Place PDF dialog
			--set user interaction level to never interact
			tell document 1
				
				tell page 1
					set imgFrame to make rectangle with properties {geometric bounds:(img's _bounds), stroke color:swatch id 18, fill color:swatch id 18}
					--set img to place (img's _path) on imgFrame
				end tell
				
			end tell
		on error errmsg
			activate
			-- display dialog errMsg
		end try
		-- Turn user interaction back on again
		--set user interaction level to interact with all
	end tell
end import

on import2(img, _number)
	tell application "Adobe InDesign CS3"
		activate
		try
			tell document 1
				
				if exists page _number then
				else
					make new page at end
				end if
				
				tell page _number
					set imgFrame to make rectangle with properties {geometric bounds:(img's _bounds), stroke color:swatch id swatchIDnone, fill color:swatch id swatchIDwhite}
					
					set ximg to place (img's _path) on imgFrame
					tell imgFrame
						tell ximg
							set absolute rotation angle to (img's _rotate)
						end tell
						fit given proportionally
						--set realScale to vertical scale of image 1
					end tell
					
				end tell
				
			end tell
		on error errmsg
			activate
			display dialog errmsg
		end try
		--my placeImageInfoTag(last item of (my tokenizer(p as string, ":")) as string, iBounds, pg, realScale)
	end tell
end import2

on capturePrefs()
	tell application "Adobe InDesign CS3"
		set viewPrefs to properties of view preferences
		set docPrefs to properties of document preferences
		set marginPrefs to properties of margin preferences
	end tell
end capturePrefs

on resetPrefs()
	tell application "Adobe InDesign CS3"
		
		tell document 1
			tell view preferences
				set horizontal measurement units to horizontal measurement units of viewPrefs
				set vertical measurement units to vertical measurement units of viewPrefs
			end tell
		end tell
		
		tell view preferences
			set horizontal measurement units to horizontal measurement units of viewPrefs
			set vertical measurement units to vertical measurement units of viewPrefs
		end tell
		
		
		tell document preferences
			set pages per document to pages per document of docPrefs
			set page orientation to page orientation of docPrefs
			set page height to page height of docPrefs
			set page width to page width of docPrefs
		end tell
		
		
		tell margin preferences
			set column count to column count of marginPrefs
			set column gutter to column gutter of marginPrefs
			set top to top of marginPrefs
			set left to left of marginPrefs
			set bottom to bottom of marginPrefs
			set right to right of marginPrefs
		end tell
		
	end tell
end resetPrefs

on setPrefs(pgobj)
	
	tell application "Adobe InDesign CS3"
		
		tell view preferences
			set horizontal measurement units to points
			set vertical measurement units to points
		end tell
		
		tell document preferences
			--set pages per document to (pgCnt of foo)
			
			set page height to (_height of pgobj)
			set page width to (_width of pgobj)
			
			if (_orientation of pgobj) = 2 then set page orientation to portrait
			if (_orientation of pgobj) is less than or equal to 1 then set page orientation to landscape
			set facing pages to false
		end tell
		
		tell margin preferences
			set column count to 1
			-- set column gutter to 12
			
			set top to (_marginTop of pgobj)
			set left to (_marginLeft of pgobj)
			set bottom to (_marginBottom of pgobj)
			set right to (_marginRight of pgobj)
			
			(* for INDD 2.0.2 *)
			--  set margin top to 36
			--   set margin bottom to 48
			--   set margin left to 36
			--   set margin right to 36
			
		end tell
	end tell
end setPrefs



on import3(img, _number)
	tell application "Adobe InDesign CS3"
		activate
		try
			tell document 1
				
				if exists page _number then
				else
					make new page at end
				end if
				
				tell page _number
					set imgFrame to make rectangle with properties {geometric bounds:(img's yxyxbounds()), stroke color:swatch id swatchIDnone, fill color:swatch id swatchIDwhite}
					
					
					set txtFrame to make text frame with properties {geometric bounds:(img's nametag()), fill color:swatch id swatchIDnone}
					set contents of insertion point -1 of txtFrame to ((img's _itemname) & return & "[scale:" & ((img's _scale) * 100) as string) & "%, path:" & POSIX path of (img's _itemcontainer) & "]"
					
					set ximg to place (img's _itempath) on imgFrame
					
					--(theAngle + 180) * 2
					
					-- this
					
					if (img's _rotate) = 90 then
						set rot to (((img's _rotate) + 180))
					else
						set rot to (img's _rotate)
					end if
					
					my rotateItem(ximg, rot)
					fit imgFrame given proportionally
					
					(*
					tell imgFrame
						tell ximg
							set absolute rotation angle to (img's _rotate)
						end tell
						fit given proportionally
						--set realScale to vertical scale of image 1
					end tell
					*)
					
				end tell
				
			end tell
		on error errmsg
			activate
			display dialog errmsg
		end try
		--my placeImageInfoTag(last item of (my tokenizer(p as string, ":")) as string, iBounds, pg, realScale)
	end tell
end import3

on rotateItem(theObject, theAngle)
	tell application "Adobe InDesign CS3"
		set myMatrix to make transformation matrix with properties {counterclockwise rotation angle:theAngle}
		transform theObject in inner coordinates from center anchor with matrix myMatrix
	end tell
end rotateItem
