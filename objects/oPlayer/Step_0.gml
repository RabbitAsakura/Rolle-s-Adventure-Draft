//Inputs
getControls()

//Get out of solid movePlat
#region
var _rightwall = noone
var _leftwall = noone
var _bottomwall = noone
var _topwall = noone
var _list = ds_list_create()
var _listsize = instance_place_list(x, y, Omoveplat, _list, false)

for(var i = 0; i < _listsize; i++)
{
	var _listInst = _list[| i]
	
	if _listInst.bbox_left - _listInst.xspd >= bbox_right-1
	{
		if !instance_exists(_rightwall) || _listInst.bbox_left < _rightwall.bbox_left
		{
			_rightwall = _listInst	
		}
	}
	
	if _listInst.bbox_right - _listInst.xspd <= bbox_left+1
	{
		if !instance_exists(_leftwall) || _listInst.bbox_right > _leftwall.bbox_right
		{
			_leftwall = _listInst
		}	
	}
	
	if _listInst.bbox_top - _listInst.yspd >= bbox_bottom-1
	{
		if !instance_exists(_bottomwall) || _listInst.bbox_top < _bottomwall.bbox_top
		{
			_bottomwall = _listInst	
		}	
	}
	
	if _listInst.bbox_bottom - _listInst.yspd <= bbox_top+1
	{
		if !instance_exists(_topwall) || _listInst.bbox_bottom > _topwall.bbox_bottom
		{
			_topwall = _listInst	
		}	
	}	
}	

ds_list_destroy(_list)

if instance_exists(_rightwall)
{
	var _rightDist = bbox_right - x	
	x = _rightwall.bbox_left - _rightDist
}

if instance_exists(_leftwall)
{
	var _leftDist = x - bbox_left
	x = _leftwall.bbox_right + _leftDist
}	

if instance_exists(_bottomwall)
{
	var _bottomDist = bbox_bottom - y
	y = _bottomwall.bbox_top - _bottomDist
}

if instance_exists(_topwall)
{
	var _topDist = y - bbox_top
	var _targetY = _topwall.bbox_bottom + _topDist
	if !place_meeting(x, _targetY,oWall)
	{
		y = _targetY
	}	
}	
#endregion

//Don't get left behind by movePlat
earlyMoveplatXspd = false
if instance_exists(myFloorPlat) && myFloorPlat.xspd != 0 && !place_meeting(x, y + moveplatMaxYspd+1,myFloorPlat)
{
	var _xCheck = myFloorPlat.xspd
	if !place_meeting(x + _xCheck, y, oWall)
	{
		x += myFloorPlat.xspd
		earlyMoveplatXspd = true
	}	
}



//X Movements
moveDir = DirRight - DirLeft

if moveDir != 0
{
   face = moveDir
}
runType = runKey
xspd = moveDir * moveSpr[runType]

//X Collision
var _subpixel = .5
if place_meeting(x + xspd, y, oWall)
{
  
  if !place_meeting(x + xspd, y - abs(xspd)-1, oWall)
  {
	  while place_meeting(x + xspd, y, oWall)
	  {
		  y -= _subpixel
	  }
  }
  else
  {
	  
  if !place_meeting(x + xspd, y + abs(xspd)+1, oWall)
  {
	  while place_meeting(x + xspd, y, oWall)
	  {
		  y += _subpixel
	  }
  }
  var _pixelcheck = _subpixel * sign(xspd)
  while !place_meeting(x + _pixelcheck,y,oWall)
  {
	  x += _pixelcheck
  }	  
  xspd = 0
}
}

if yspd >= 0 && !place_meeting(x + xspd, y + 1 ,oWall) && place_meeting(x + xspd, y + abs(xspd)+1, oWall)
{
	while !place_meeting(x + xspd, y + _subpixel, oWall)
	{
			y += _subpixel
	}
}

x += xspd

//Y Movements
if coyoteHangTimer > 0
{
	coyoteHangTimer--
}	
else
{
	yspd += grav
	setOnGround(false)
}	


if onGround 
{
	jumpCount = 0
	coyoteJumpTimer = coyoteJumpFrames
}
else
{
	coyoteJumpTimer--
	if jumpCount == 0 && coyoteJumpTimer <= 0
	{
		jumpCount = 1	
	}	
}	

//Jump
if jumpbuffer && jumpCount < jumpMax
{
	//Resetting Buffer
	jumpbuffer = false
	jumpbuffTimer = 0
	
	jumpCount++
	
	jumpHoldTimer = jumpHoldFrames[jumpCount-1]
	setOnGround(false)
}

if !jumpkey
{
	jumpHoldTimer = 0	
}	

if jumpHoldTimer > 0
{
	yspd=jspd[jumpCount-1]
	jumpHoldTimer--
}	

if yspd > termVel
{
	yspd = termVel	
}	

//Y Collision
//var _subpixel = .5

if yspd < 0 && place_meeting(x, y + yspd, oWall)
{
		var _Slopeslide = false
		if moveDir == 0 && !place_meeting(x - abs(yspd)-1,y + yspd, oWall)
		{
			while place_meeting(x, y + yspd, oWall)
			{
				x -= 1
			}
			_Slopeslide = true
		}
		
		if moveDir == 0 && !place_meeting(x + abs(yspd)+1,y + yspd, oWall)
		{
			while place_meeting(x, y + yspd, oWall)
			{
				x += 1
			}
			_Slopeslide = false
		}
		
		if !_Slopeslide
		{
		 var _pixelcheck = _subpixel * sign(yspd)
	     while !place_meeting(x, y + _pixelcheck, oWall)
	      {
		    y += _pixelcheck
	      }	
		}
		
		if yspd < 0
	{
	   jumpHoldTimer = 0
	}
	yspd = 0
		
		
}	



var _clampYspd = max(0,yspd)
var _list = ds_list_create()
var _array = array_create(0)
array_push(_array, oWall, oSolidwall)
var _listSize = instance_place_list(x, y+1 +_clampYspd + termVel, _array, _list, false)

var _yCheck = y+1 + _clampYspd
if instance_exists(myFloorPlat)
{
	_yCheck += max(0, myFloorPlat.yspd)
}	

var _semiSolid = setSolid(x, _yCheck)


for(var i = 0; i < _listSize; i++)
{
	var _listInst = _list[| i]	
	
	if _listInst != forgetSemiSolid && (_listInst.yspd <= yspd || instance_exists(myFloorPlat)) && (_listInst.yspd > 0 || place_meeting(x, y+1 + _clampYspd, _listInst)) || (_listInst == _semiSolid)
	{
	if _listInst.object_index == oWall || object_is_ancestor(_listInst.object_index, oWall) || floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd)
	{
			if !instance_exists(myFloorPlat) || _listInst.bbox_top + _listInst.yspd <= myFloorPlat.bbox_top + myFloorPlat.yspd || _listInst.bbox_top + _listInst.yspd <= bbox_bottom
			{
				myFloorPlat = _listInst	
			}	
	}
	}
}
ds_list_destroy(_list)

if instance_exists(myFloorPlat) && !place_meeting(x,y + termVel,myFloorPlat)
{
	myFloorPlat = noone
}	

if instance_exists(myFloorPlat)
{
	//var _subpixel = .5
	while !place_meeting(x, y + _subpixel, myFloorPlat) && !place_empty(x, y, oWall)
	{
		y += _subpixel
	}
	if myFloorPlat.object_index == oSolidwall || object_is_ancestor(myFloorPlat.object_index, oSolidwall)
	{
		while place_meeting(x,y,myFloorPlat)
		{
			y -= _subpixel	
		}	
	}
	
	y = floor(y)
	yspd = 0
	setOnGround(true)
}	



if DirDown && jumpkey
{
	if instance_exists(myFloorPlat) && (myFloorPlat.object_index == oSolidwall || object_is_ancestor(myFloorPlat.object_index, oSolidwall))
	{
		var _yCheck = y + max(1, myFloorPlat.yspd+1)
		if !place_meeting(x,y + _yCheck,oWall)
		{
			y += 1
			
			yspd = _yCheck-1
			
			forgetSemiSolid = myFloorPlat
			setOnGround(false)
		}	
	}	
	
}	





if !place_meeting(x, y + yspd,oWall)
{
y += yspd
}

if instance_exists(forgetSemiSolid) && !place_meeting(x,y,forgetSemiSolid)
{
	forgetSemiSolid = noone
}	



moveplatXspd = 0

if !earlyMoveplatXspd
{
if instance_exists(myFloorPlat)
{
	moveplatXspd = myFloorPlat.xspd	
}	

if place_meeting(x + moveplatXspd, y, oWall)
{
	var _subpixel = .5
	var _pixelcheck = _subpixel * sign(moveplatXspd)
	while !place_meeting(x + _pixelcheck, y, oWall)
	{
		x += _pixelcheck
	}	
	
	moveplatXspd = 0
}	
}
x += moveplatXspd



if instance_exists(myFloorPlat) && (myFloorPlat.yspd != 0 || myFloorPlat.object_index == Omoveplat || object_is_ancestor(myFloorPlat.object_index, Omoveplat))
{
	if !place_meeting(x, myFloorPlat.bbox_top,oWall) && myFloorPlat.bbox_top >= bbox_bottom-termVel
	{
		y = myFloorPlat.bbox_top
	}	
	
	/*if myFloorPlat.yspd < 0 && place_meeting(x, y + myFloorPlat.yspd, oWall)
	{
		if myFloorPlat.object_index == oSolidwall || object_is_ancestor(myFloorPlat.object_index, oSolidWall)
		{
			var _subpixel = 25
			while place_meeting(x, y + myFloorPlat.yspd, oWall)
			{
				y += _subpixel
			}	
			while place_meeting(x, y, oWall)
			{
				y -= _subpixel
			}	
			y = round(y)
		}	
		setOnGround(false)
	}*/	
	
}	

if instance_exists(myFloorPlat) && (myFloorPlat.object_index == oSolidwall || object_is_ancestor(myFloorPlat.object_index,oSolidwall)) && place_meeting(x, y, oWall)
{
	var _maxPushDist = 10
	var _pushedDist = 0
	var _startY = y
	while place_meeting(x, y, oWall) && _pushedDist <= _maxPushDist
	{
		y++
		_pushedDist++
	}	
	myFloorPlat = false
	
	if _pushedDist > _maxPushDist
	{
		y = _startY	
	}	
}	


image_blend = c_white
if place_meeting(x,y,oWall)
{
	image_blend = c_blue
}	

if place_meeting(x,y,oWall)
{
	crushTimer++
	if crushTimer > crushDeathtime
	{
	instance_destroy()
	}
}
else
{
	crushTimer = 0	
}	

if abs(xspd) > 0
{
  sprite_index = rollSpr
}

if xspd == 0
{
	sprite_index = idleSpr
}

if !onGround
{
	sprite_index = jumpSPr
}

mask_index = idleSpr


if place_meeting(x,y,oBad)
{
	room_restart()	
}	

//Jump Sound effect
if (keyboard_check_pressed(vk_space) || keyboard_check(ord("W")))
{
	if !audio_is_playing(Jump_sfx)
	{
	audio_play_sound(Jump_sfx, 0, false)
	}
}	