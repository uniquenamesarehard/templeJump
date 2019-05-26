extends KinematicBody2D

# Member variables
var GRAVITY = 20.0 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 90
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 200
const JUMP_MAX_AIRBORNE_TIME = 0.8

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one psixel

const SPEED = 200
const JUMP_HEIGHT = -575
const UP = Vector2(0, -1)

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false

var motion = Vector2()

var vine_on = false;
var coins = 0
var god_mode = false
var win = false

func _physics_process(delta):
	
	if not win:
		var youWin = get_parent().get_parent().get_node("Endgame/youWin")
		youWin.hide()
	
	
	#Code that updates coins text
	var LabelNode = get_parent().get_parent().get_node("Scene Counter/UI/Control/RichTextLabel")
	if (coins < 50):
		LabelNode.text = "Coins: " + str(coins)
	else:
		LabelNode.text = "God Mode Activated!\n"+ str(coins)
	
	if coins >= 50:
		god_mode = true
	
	# Create forces
	var force = Vector2(0, GRAVITY)
	motion.y += GRAVITY
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	
	var stop = true
	
	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	
	
		
		
	# Integrate velocity into motion and move
	if not vine_on:
		velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	
	#movement code
	
	if god_mode:
		if Input.is_action_pressed("ui_right"):
			motion.x = SPEED
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
		elif Input.is_action_pressed("ui_left"):
			motion.x = -SPEED
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
		else:
			motion.x = 0
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
	else:
		if Input.is_action_pressed("ui_right"):
			motion.x = SPEED
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				motion.y = JUMP_HEIGHT
		elif Input.is_action_pressed("ui_left"):
			motion.x = -SPEED
			if Input.is_action_just_pressed("ui_up") and is_on_floor():
				motion.y = JUMP_HEIGHT
		else:
			motion.x = 0
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
			
	
	#Ladder code
	if vine_on == true:
		GRAVITY = 0
		on_air_time = 0
		
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
	

#Coin code
func _on_Coin_body_entered(body):
	coins+=1
	print(coins)
	pass # Replace with function body.

func _on_Vine_body_entered(body):
	vine_on = true
	pass # Replace with function body.


func _on_Vine_body_exited(body):
	vine_on = false
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	var youWin = get_parent().get_parent().get_node("Endgame/youWin")
	youWin.show()
	pass # Replace with function body.
