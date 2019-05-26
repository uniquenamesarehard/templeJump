extends AnimatedSprite

var num_frames
var current_frame = 0

func _ready():
    set_process_input(true)
    num_frames = get_sprite_frames().get_frame_count("anim_name")

func _input(event):
	if Input.is_action_pressed("ui_left"):
        current_frame = (current_frame + 1) % num_frames
        set_frame(current_frame)
	if Input.is_action_pressed("ui_right"):
		current_frame = (current_frame -1) % num_frames
		set_frame(current_frame)
		
		