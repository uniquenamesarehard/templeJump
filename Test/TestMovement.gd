extends KinematicBody2D
#extends "res://Gravity.gd"
const UP = Vector2(0, -1)
var GRAVITY = 20
const SPEED = 200
const JUMP_HEIGHT = -500

var score = 0
var motion = Vector2()

var ladder_on = false
func _physics_process(delta):
	
	print(ladder_on)
	
	var LabelNode = get_parent().get_parent().get_node("Scene Counter/UI/Control/RichTextLabel")
	LabelNode.text = str(score)
	motion.y += GRAVITY
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
	else:
		motion.x = 0
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	
	if ladder_on == true:
		GRAVITY = 0
		if Input.is_action_pressed("ui_up"):
			motion.y = -SPEED
		elif Input.is_action_pressed("ui_down"):
			motion.y = SPEED
		else:
			motion.y = 0
	else:
		GRAVITY = 20
	
	
	motion = move_and_slide(motion, UP)
	pass
	


func _on_Coin_body_entered(body):
	score+=1
	print(score)
	pass # Replace with function body.


func _on_Ladder_body_entered(body):
	ladder_on = true
	pass # Replace with function body.


func _on_Ladder_body_exited(body):
	ladder_on = false
	pass # Replace with function body.
