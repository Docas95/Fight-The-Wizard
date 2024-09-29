extends CharacterBody2D


const SPEED = 7500.0
const JUMP_VELOCITY = -275.0
const MAX_JUMP_TIME = 0.3

@onready var animated_sprite = $AnimatedSprite2D

var wall_jumping = false
var wall_jump_time = 0.0
var direction = 1.0

func _physics_process(delta):
	if wall_jumping:
		wall_jump_time += delta
		if wall_jump_time > MAX_JUMP_TIME:
			wall_jumping = false
			wall_jump_time = 0.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
					
	# Get the input direction
	if not wall_jumping:
		direction = Input.get_axis("walk_left", "walk_right")
	
	# Handle jump.
	if Input.is_action_pressed("jump") and (is_on_floor() or is_on_wall()):
		velocity.y = JUMP_VELOCITY
		if is_on_wall():
			wall_jumping = true;
			velocity.x = -direction * SPEED * delta
	
	# set animated sprite
	if direction != 0:
		animated_sprite.play("running")
		if direction > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")
	if not is_on_floor():
		animated_sprite.play("jumping")
	
	# Move player
	if not wall_jumping:
		if direction:
			velocity.x = direction * SPEED * delta
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
