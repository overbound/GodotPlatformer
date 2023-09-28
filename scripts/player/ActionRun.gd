class_name ActionRun
extends ActionParent

func begin_action():
	player.physics.landed = true

func action():
	if player.physics.landed:
		handle_ground_movement()
	else:
		handle_air_movement()
	
	player.physics.update_movement()

func handle_air_movement():
	var inputDir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	player.physics.direction =  inputDir.x
	player.physics.velocity.x = min(abs(player.physics.velocity.x) + player.physics.acceleration, player.physics.maxGroundSpeed)  * inputDir.x

func handle_ground_movement():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	player.physics.groundSpeed = min(abs(player.physics.groundSpeed) + player.physics.acceleration, player.physics.maxGroundSpeed)  * input_dir.x
	print(player.physics.groundSpeed)
	if Input.is_action_pressed("ui_accept"):
		player.bufferedAction = player.actionJump
		player.physics.landed = false

