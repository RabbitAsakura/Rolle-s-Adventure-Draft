function setControls()
{
	bufferTime = 3
	jumpbuffer = 0
	jumpbuffTimer = 0
	
}

function getControls()
{
DirRight = keyboard_check(vk_right) + keyboard_check(ord("D")) + gamepad_button_check(0, gp_padr)
DirRight = clamp(DirRight,0,1)

DirLeft = keyboard_check(vk_left) + keyboard_check(ord("A")) + gamepad_button_check(0, gp_padl)
DirLeft = clamp(DirLeft,0,1)

DirJump = keyboard_check_pressed(vk_space) + keyboard_check(ord("W")) + gamepad_button_check_pressed(0, gp_face1)
DirJump = clamp(DirJump,0,1)

DirDown = keyboard_check(vk_down) + keyboard_check(ord("S")) + gamepad_button_check(0, gp_padd)
DirDown = clamp(DirDown,0,1)

jumpkey = keyboard_check(vk_space) + keyboard_check(ord("W")) + gamepad_button_check(0,gp_face1)
jumpkey = clamp(jumpkey,0,1)

runKey =   keyboard_check(ord("H")) + gamepad_button_check(0,gp_face3)
runkey = clamp(runKey,0,1)

if DirJump
{
	jumpbuffTimer = bufferTime
}

if jumpbuffTimer > 0
{
	jumpbuffer = 1
	jumpbuffTimer--
}
else
{
	jumpbuffer = 0	
}	

}	