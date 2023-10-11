class_name PlayerPhysics

var landed:bool = false
var velocity:Vector3
var groundSpeed:float
var maxGroundSpeed:float = 0.06
var gravity:float = 0.021875
var maxYVelocity:float = 0.5
var acceleration:float = 0.0046875
var relativeAngle:float
var slopeFactor:float
var player:Player
var direction:int

var debugGroundCollisionLineA
var debugGroundCollisionLineB
var debugHorizontalCollisionLineA
var debugHorizontalCollisionLineB


func _init(newPlayer:Player):
	player = newPlayer
	
func update_movement():
	if landed:
		ground_movement()
		print("ground")
	else:
		air_movement()
		print("air")

func air_movement():
	velocity.y -= gravity
	
	if abs(velocity.y) > maxYVelocity:
		velocity.y = maxYVelocity * sign(velocity.y)
	
	var horizontalCollisions = CollisionsHorizontal()
	if horizontalCollisions != null:
		var boundsOffset = 0.5
		velocity.x = (horizontalCollisions.get("distance") - boundsOffset) * sign(velocity.x)
	
	if velocity.y <= 0:
		var belowCollisions = _collision_below()
		if belowCollisions != null:
			landed = true
			var size = 2
			var minDistance = 2 / 8
			var groundDirection = -1
			var normal = belowCollisions.get("normal")
			relativeAngle = set_angle(Vector2(normal.x, normal.y))
			velocity.y = (belowCollisions.get("distance") - size + minDistance) * groundDirection
	
	player.position += velocity
	
func ground_movement():
	groundSpeed += slopeFactor * sin(deg_to_rad(relativeAngle))
	print("relative"+str(relativeAngle))
	velocity.x = cos(deg_to_rad(relativeAngle)) * groundSpeed
	velocity.y = sin(deg_to_rad(relativeAngle)) * groundSpeed

	var horizontalCollisions = CollisionsHorizontal()
	if horizontalCollisions != null:
		var boundsOffset = 0.5
		velocity.x = (horizontalCollisions.get("distance") - boundsOffset) * sign(velocity.x)
		
	var belowCollisions = _collision_below()	
	if belowCollisions != null:
		position_player_z_axis(belowCollisions)
		var normal = belowCollisions.get("normal")
		relativeAngle = set_angle(Vector2(normal.x, normal.y))
		landed = true
	else :
		landed = false
		relativeAngle = 0
		print("fell")
		
	player.position += velocity
	
func position_player_z_axis(currentCollision: Dictionary):
	var mesh = currentCollision.get("collider").get_parent()
	player.position.z = mesh.position.z
	
func _collision_below():
	var space_state = player.get_world_3d().direct_space_state
	
	var originA = player.position + Vector3(-0.5, 1, 0)
	var endA = originA - Vector3(0, 2.5, 0)
	var queryA = PhysicsRayQueryParameters3D.create(originA, endA)
	queryA.collide_with_areas = true
	var resultA = space_state.intersect_ray(queryA)
	if(debugGroundCollisionLineA != null) :
		debugGroundCollisionLineA.queue_free()
	debugGroundCollisionLineA = Draw3d.line(Vector3(originA.x, originA.y, originA.z + 1), Vector3(endA.x, endA.y, endA.z + 1), Color(1, 0, 0)) 

	var originB = player.position + Vector3(0.5, 1, 0)
	var endB = originB - Vector3(0, 2.5, 0)
	var queryB = PhysicsRayQueryParameters3D.create(originB, endB)
	queryB.collide_with_areas = true
	var resultB = space_state.intersect_ray(queryB)
	if(debugGroundCollisionLineB != null) :
		debugGroundCollisionLineB.queue_free()
	debugGroundCollisionLineB = Draw3d.line(Vector3(originB.x, originB.y, originB.z + 1), Vector3(endB.x, endB.y, endB.z + 1), Color(1, 0, 0)) 
	
	var distanceA
	var distanceB
	if !resultA.is_empty():
		distanceA = originA.distance_to(resultA.get('position'))
		resultA["distance"] = distanceA
	if !resultB.is_empty():
		distanceB = originB.distance_to(resultB.get('position'))
		resultB["distance"] = distanceB
	
	if !resultA.is_empty() && !resultB.is_empty() :
		print('hit!')
		if distanceA < distanceB :
			return resultA
		else :
			return resultB
	elif !resultA.is_empty():
		print('hitA!')
		return resultA
	elif !resultB.is_empty():
		print('hitB!')
		return resultB
	return null

func CollisionsHorizontal():
	var space_state = player.get_world_3d().direct_space_state
	var origin = player.position + Vector3(0, 0.5, 0)
	var boundsOffset = 0.5
	
	var endA = origin + Vector3((velocity.x) + (boundsOffset * sign(velocity.x)), 0, 0)
	var queryA = PhysicsRayQueryParameters3D.create(origin, endA)
	queryA.collide_with_areas = true
	var resultA = space_state.intersect_ray(queryA)
	if(debugHorizontalCollisionLineA != null) :
		debugHorizontalCollisionLineA.queue_free()
	debugHorizontalCollisionLineA = Draw3d.line(Vector3(origin.x, origin.y, origin.z + 1), Vector3(endA.x, endA.y, endA.z + 1), Color(1, 1, 0)) 

	var endB = origin + Vector3((velocity.x) + (boundsOffset * sign(velocity.x)), 0, 0)
	var queryB = PhysicsRayQueryParameters3D.create(origin, endB)
	queryB.collide_with_areas = true
	var resultB = space_state.intersect_ray(queryB)
	if(debugHorizontalCollisionLineB != null) :
		debugHorizontalCollisionLineB.queue_free()
	debugHorizontalCollisionLineB = Draw3d.line(Vector3(origin.x, origin.y, origin.z + 1), Vector3(endB.x, endB.y, endB.z + 1), Color(1, 1, 0)) 
	
	
	if !resultA.is_empty():
		resultA["distance"] = origin.distance_to(resultA.get('position'))
	if !resultB.is_empty():
		resultB["distance"] = origin.distance_to(resultB.get('position'))

	if !resultA.is_empty() && !resultB.is_empty() :
		if velocity.x < 0 :
			return resultA
		else :
			return resultB
	elif !resultA.is_empty():
		return resultA
	elif !resultB.is_empty():
		return resultB
	return null
	
func set_angle(normal: Vector2) -> float:
	return -rad_to_deg(normal.angle_to(Vector2(0, 1)))

