class_name ActionJump
extends ActionParent

var isJumping = false

func begin_action():
	if player.physics.landed:
		begin_jump()
	else :
		begin_fall()
	
func begin_jump():
	isJumping = true
	player.physics.relativeAngle = 0
	player.physics.landed = false
	player.physics.velocity.x -= -(player.physics.maxYVelocity * sin(deg_to_rad(player.physics.relativeAngle)))
	player.physics.velocity.y -= -(player.physics.maxYVelocity * cos(deg_to_rad(player.physics.relativeAngle)))

func begin_fall():
	player.physics.landed = false
	player.physics.relativeAngle = 0
	player.physics.groundSpeed = 0
	
func action():
	var minJump = 0.3125
	
	if !Input.is_action_pressed('ui_accept') && isJumping:
		if player.physics.velocity.y > minJump:
			player.physics.velocity.y = minJump
			isJumping = false
		
	var inputDir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.physics.direction =  inputDir.x
	player.physics.velocity.x = min(abs(player.physics.velocity.x) + player.physics.acceleration, player.physics.maxGroundSpeed) * inputDir.x

	player.physics.update_movement()
	
	if player.physics.landed :
		player.bufferedAction = player.actionRun
