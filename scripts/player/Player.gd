class_name Player
extends Node

var physics
var action
var previousAction
var bufferedAction

var actionJump
var actionRun

func _init():
	physics = PlayerPhysics.new(self)
	actionJump = ActionJump.new(self)
	actionRun = ActionRun.new(self)
	action = actionJump
	previousAction = actionJump
	
func _ready():
	pass

func _physics_process(delta):
	if previousAction == null || bufferedAction != null :
		if action != null:
			action.end_action()
		previousAction = action
		action = bufferedAction
		bufferedAction = null
		action.begin_action()
		
	action.action()
