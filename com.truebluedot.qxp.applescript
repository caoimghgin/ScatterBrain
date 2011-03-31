-- com.truebluedot.qxp.applescript
-- ScatterBrain v0.5.3

--  Created by Kevin on 8/17/06.
--  Copyright 2006 __MyCompanyName__. All rights reserved.
(*
property docPrefs : missing value

on import {img, clr}
	tell application "QuarkXPress"
		activate
		
		tell document 1 to set horizontal measure to points
		tell document 1 to set vertical measure to points
		
		tell document 1
			make picture box at beginning with properties {name:"Picture 1", bounds:(img's _bounds), color:"White"}
		end tell
	end tell
end import

on import2(img, _number)
	tell application "QuarkXPress"
		activate
		
		if exists page _number of document 1 then
		else
			tell document 1 to make new page at end
			show page _number of document 1
		end if
		
		tell document 1
			set horizontal measure to points
			set vertical measure to points
			set view scale to fit page in window
			
			set pctbox to make picture box at beginning of page _number with properties {bounds:(img's yxyxbounds()), color:"White"}
			
			--set txtFrame to make text box with properties {bounds:(img's nametag()), color:"White"}
			--set story 1 of txtFrame to ((img's _itemname) & return & "[scale:" & ((img's _scale) * 100) as string) & "%, path:" & POSIX path of (img's _itemcontainer) & "]"
			
			set theNameOverlayBox to make new text box at beginning of page _number with properties {name:"Name Overlay Box", bounds:(img's nametag()), runaround:none runaround, color:null, suppress printing:false, vertical justification:top justified}
			set story 1 of theNameOverlayBox to ((img's _itemname) & return & "[scale:" & ((img's _scale) * 100) as string) & "%, path:" & POSIX path of (img's _itemcontainer) & "]"
			
			set image 1 of pctbox to (img's _itempath)
		end tell
	end tell
end import2

on capturePrefs()
	tell application "QuarkXPress"
		set docPrefs to properties of default document 1
	end tell
end capturePrefs

on resetPrefs()
	tell application "QuarkXPress"
		
		tell document 1
			set horizontal measure to horizontal measure of docPrefs
			set vertical measure to horizontal measure of docPrefs
		end tell
		
		tell default document 1
			
			set auto constrain to auto constrain of docPrefs
			set auto kern to auto kern of docPrefs
			set auto leading to auto leading of docPrefs
			set auto page insertion location to auto page insertion location of docPrefs
			set auto picture import to auto picture import of docPrefs
			set automatic text box to automatic text box of docPrefs
			set automatic trap amount to automatic trap amount of docPrefs
			set baseline grid increment to baseline grid increment of docPrefs
			set baseline grid showing to baseline grid showing of docPrefs
			set baseline grid start to baseline grid start of docPrefs
			
			set bottom margin to bottom margin of docPrefs
			set ciceros per centimeter to ciceros per centimeter of docPrefs
			set column count to column count of docPrefs
			-- set default spread count to default spread count of docPrefs
			set facing pages to facing pages of docPrefs
			set flex space width to flex space width of docPrefs
			set fractional character widths to fractional character widths of docPrefs
			set frame inside to frame inside of docPrefs
			set greek below to greek below of docPrefs
			set guides in front to guides in front of docPrefs
			
			set ignore white to ignore white of docPrefs
			set hyphenation method to hyphenation method of docPrefs
			set horizontal measure to horizontal measure of docPrefs
			set gutter width to gutter width of docPrefs
			set guides showing to guides showing of docPrefs
			set guides showing to guides showing of docPrefs
			set indeterminate trap amount to indeterminate trap amount of docPrefs
			set inside margin to inside margin of docPrefs
			set invisibles showing to invisibles showing of docPrefs
			set item spread coords to item spread coords of docPrefs
			set keep master page items to keep master page items of docPrefs
			
			set kern above to kern above of docPrefs
			set knockout limit to knockout limit of docPrefs
			set left margin to left margin of docPrefs
			set ligatures on to ligatures on of docPrefs
			set lock guides to lock guides of docPrefs
			set low quality blends to low quality blends of docPrefs
			set maintain leading to maintain leading of docPrefs
			set maximum ligature track to maximum ligature track of docPrefs
			set maximum view scale to maximum view scale of docPrefs
			set minimum view scale to minimum view scale of docPrefs
			set outside margin to outside margin of docPrefs
			
			set overprint limit to overprint limit of docPrefs
			set page height to page height of docPrefs
			set page width to page width of docPrefs
			set points per inch to points per inch of docPrefs
			set process trap to process trap of docPrefs
			set right margin to right margin of docPrefs
			set rulers showing to rulers showing of docPrefs
			set small caps horizontal scale to small caps horizontal scale of docPrefs
			set small caps vertical scale to small caps vertical scale of docPrefs
			set snap distance to snap distance of docPrefs
			set spread height to spread height of docPrefs
			
			set spread width to spread width of docPrefs
			set subscript offset to subscript offset of docPrefs
			set subscript vertical scale to subscript vertical scale of docPrefs
			set subscript horizontal scale to subscript horizontal scale of docPrefs
			set superscript horizontal scale to superscript horizontal scale of docPrefs
			set superscript offset to superscript offset of docPrefs
			set superscript vertical scale to superscript vertical scale of docPrefs
			set superior horizontal scale to superior horizontal scale of docPrefs
			set superior vertical scale to superior vertical scale of docPrefs
			set top margin to top margin of docPrefs
			
			set trapping method to trapping method of docPrefs
			set typesetting leading mode to typesetting leading mode of docPrefs
			set vertical measure to vertical measure of docPrefs
			set view scale to view scale of docPrefs
			set view scale increment to view scale increment of docPrefs
		end tell
	end tell
end resetPrefs

on setPrefs(pgobj)
	
	tell application "QuarkXPress"
		tell default document 1
			set horizontal measure to points
			set vertical measure to points
			
			set automatic text box to false
			set page height to (_height of pgobj)
			set page width to (_width of pgobj)
			
			set top margin to (_marginTop of pgobj)
			set left margin to (_marginLeft of pgobj)
			set bottom margin to (_marginBottom of pgobj)
			set right margin to (_marginRight of pgobj)
		end tell
	end tell
end setPrefs

on createDoc()
	tell application "QuarkXPress"
		make new document
	end tell
end createDoc
*)