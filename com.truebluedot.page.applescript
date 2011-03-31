property _width : missing value
property _height : missing value
property _orientation : missing value
property _number : missing value

property _marginTop : missing value
property _marginLeft : missing value
property _marginBottom : missing value
property _marginRight : missing value

property _placedimglst : {}

on init(xy, n)
	
	set _width to (item 1 of xy)
	set _height to (item 2 of xy)
	set _number to n
	
	if _width > _height then set _orientation to "landscape"
	if _width < _height then set _orientation to "portrait"
	if _width = _height then set _orientation to "square"
end init

on mainx(xy, n)
	
	set _width to (item 1 of xy)
	set _height to (item 2 of xy)
	set _number to n
	
	if _width > _height then set _orientation to "landscape"
	if _width < _height then set _orientation to "portrait"
	if _width = _height then set _orientation to "square"
end mainx

on addimg(img)
	set end of _placedimglst to img
end addimg

on set_margins(y1, x1, y2, x2)
	set _marginTop to y1
	set _marginLeft to x2
	set _marginBottom to y2
	set _marginRight to x2
end set_margins

on set_number(x)
	if ((class of x) is not integer) and ((class of x) is not real) then error "error:set_number(x) -- did not receive a number value."
	if (x < 0) then error "error:set_number(x) -- received a negative value."
	set _number to x
	if _number = missing value then error "error:set_number(x) --> _number is missing value."
end set_number
