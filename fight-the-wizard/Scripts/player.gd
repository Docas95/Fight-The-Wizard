extends CharacterBody2D


const SPEED = 7500.0
const JUMP_VELOCITY = -275.0
const MAX_JUMP_TIME = 0.3
const MAX_ACTION_TIME = 0.3

@onready var animated_sprite = $AnimatedSprite2D

var player_state = "idle"
var wall_jump_time = 0.0
var direction = 1.0
var action1 = "sword"
var action2 = "null"
var action = ""
var action_time = 0.0

func player_movement(delta):
	# end wall jump after X seconds
	if player_state == "wall jumping":
		wall_jump_time += delta
		if wall_jump_time > MAX_JUMP_TIME:
			player_state = "idle"
			wall_jump_time = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta				
	
	# Get the input direction
	if player_state != "wall jumping":
		direction = Input.get_axis("walk_left", "walk_right")
		if player_state != "action":
			if direction == 0 and is_on_floor():
				player_state = "idle"
			elif direction != 0 and is_on_floor():
				player_state = "running"
	
	# Handle jump
	if Input.is_action_pressed("jump") and (is_on_floor() or is_on_wall()):
		player_state = "jumping"
		velocity.y = JUMP_VELOCITY
		if is_on_wall():
			player_state = "wall jumping"
			velocity.x = -direction * SPEED * delta	
	
	# Move player
	if player_state != "wall jumping":
		if direction:
			velocity.x = direction * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

func player_action(delta):
	if player_state == "action":
		action_time += delta
		if action_time > MAX_ACTION_TIME:
			action_time = 0
			player_state = "idle"
	
	if Input.is_action_just_pressed("action_1") and is_on_floor():
		player_state = "action"
		action = action1

func set_player_animation():
	# flip sprite based on directional input
	if direction != 0:
		if direction > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true	
			
	match player_state:
		"idle":
			animated_sprite.play("idle")
		"running":
			animated_sprite.play("running")
		"jumping", "wall jumping":
			animated_sprite.play("jumping")
		"action":
			animated_sprite.play(action)

func _physics_process(delta):
	player_movement(delta)
	player_action(delta)
	set_player_animation()
	move_and_slide()
