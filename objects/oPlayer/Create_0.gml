//Custom
function setOnGround(_val = true)
{
	if _val == true
	{
		onGround = true
		coyoteHangTimer = coyoteHangFrames
	}
	else
	{
		onGround = false
		myFloorPlat = noone
		coyoteHangTimer = 0
	}	
}


function setSolid(_x,_y)
{
	var _rtrn = noone
		if yspd >= 0 && place_meeting(_x,_y,oSolidwall)
		{
				var _list = ds_list_create()
				var _listsize = instance_place_list(_x,_y,oSolidwall,_list,false)
				
				for(var i = 0; i < _listsize; i++)
				{
					var _listInst = _list[| i]
					if _listInst != forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd)
					{
						_rtrn = _listInst
						i = _listsize
					}	
				}
				ds_list_destroy(_list)
		}
		return _rtrn
}	

depth = -30

//Control Set
setControls()

//Sprite
idleSpr = IdleSpr
rollSpr = RollingSpr
jumpSPr = JumpSpr
crouchSpr = CrouchSpr 


//Moving
face = 1
moveDir = 0;
runType = 0;
moveSpr[0]=2;
moveSpr[1] = 3.5
xspd = 0;
vsp = 0
yspd = 0;


//Jumping
grav = .275;
termVel = 4;
jspd[0]=-3.15
jumpMax = 1
jumpCount = 0
jumpHoldTimer = 0
jumpHoldFrames[0]=18
jumpHoldFrames[1] = 10
jspd[1]=-2.85
onGround = true

//Creat Coyote time
coyoteHangFrames = 2
coyoteHangTimer = 0
coyoteJumpFrames = 5
coyoteJumpTimer = 0

//Moving Platforms
myFloorPlat = noone
earlyMoveplatXspd = false
forgetSemiSolid = noone
moveplatXspd = 0
moveplatMaxYspd = termVel
crushTimer = 0
crushDeathtime = 3