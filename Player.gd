#extends "res://Gravity.gd"
extends KinematicBody2D
export (int) var speed = 200
var screensize = 480*270
const MOTION_SPEED = 100 # Pixels/second
#warning-ignore:unused_class_variable
var istrench = true	

func _ready():
	screensize = get_viewport_rect().size
	set_process_input(true)

func _physics_process(delta):
	var motion = Vector2()
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
	var velocity = Vector2() #the player's movement vector
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1

	position += velocity * delta
	
	motion = motion.normalized() * MOTION_SPEED


func _input(event):
    #this event is called once per key-press
	if event.is_action_pressed("ui_switchchar") and istrench == true:
		istrench = false
		$AnimatedSprite.animation = "Turtleneck"
	elif event.is_action_pressed("ui_switchchar") and istrench == false:
		istrench = true
		$AnimatedSprite.animation = "Trenchcoat"
