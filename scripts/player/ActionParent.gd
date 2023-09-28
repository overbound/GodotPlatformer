class_name ActionParent

var player

func _init(newPlayer:Player):
	player = newPlayer
	
func begin_action():
	print("begin action default - you should probably override this.")
	pass
	
func action():
	print("action default - you should probably override this.")
	pass
	
func end_action():
	print("end action default - you should probably override this.")
	pass
