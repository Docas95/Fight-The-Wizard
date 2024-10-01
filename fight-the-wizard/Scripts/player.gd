extends CharacterBody2D

const SPEED = 7500.0
const JUMP_VELOCITY = -280.0
const WALL_JUMP_TIME = 0.3
const SWORD_TIME = 0.3

@onready var animated_sprite = $AnimatedSprite2D

enum State{
	IDLE,
	RUNNING,
	JUMPING,
	WALL_JUMPING,
	SWORD,
}

enum Action{
	NONE,
	SWORD
}

var player_state = State.JUMPING
var action_1 = Action.SWORD
var action_2 = Action.NONE
var direction = 1.0

var timing = 0.0

func change_state(state):
	player_state = state
	print("Changed state to:" + str(state))

func _physics_process(delta):
	match player_state:
		State.IDLE:
			# check if player wants to move
			get_player_direction_input()
			if direction != 0:
				change_state(State.RUNNING)
			
			# check if player wants to jump
			if get_player_jump_input():
				jump()
			
			# check if player is falling
			if not is_on_floor():
				change_state(State.JUMPING)
			
			# play idle animation
			animated_sprite.play("idle")
		State.RUNNING:
			#check if player wants to keep moving
			get_player_direction_input()
			if direction == 0:
				change_state(State.IDLE)
			move_player_horizontal(delta)
			
			# check if player wants to jump
			if get_player_jump_input():
				jump()
			
			# check if player is falling
			if not is_on_floor():
				change_state(State.JUMPING)
			
			# play running animation
			animated_sprite.play("running")
		State.JUMPING:
			# check if player wants to move
			get_player_direction_input()
			move_player_horizontal(delta)
			
			# check if player has hit the floor yet
			if is_on_floor():
				change_state(State.IDLE)
			move_player_vertical(delta)
			
			# check if player wants to peform a wall jump
			if is_on_wall() and get_player_jump_input():
				jump()
				change_state(State.WALL_JUMPING)
			
			# player jumping animation
			animated_sprite.play("jumping")
		State.WALL_JUMPING:
			# end wall jump after a set time
			timing += delta
			if timing >= WALL_JUMP_TIME:
				timing = 0.0
				change_state(State.JUMPING)
			
			# check if player is touching the floor
			if is_on_floor():
				timing = 0.0
				change_state(State.IDLE)
			
			# bounce off the wall
			if timing == delta:
				direction *= -1
				
			# move player
			move_player_horizontal(delta)
			move_player_vertical(delta)
		
			# play jumping animation
			animated_sprite.play("jumping")
	
	move_and_slide()
			
			
func get_player_direction_input():
	direction = Input.get_axis("walk_left", "walk_right")

func get_player_jump_input():
	return Input.is_action_pressed("jump")
	
func move_player_horizontal(delta):
	if direction != 0:
		if direction > 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func move_player_vertical(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func jump():
	velocity.y = JUMP_VELOCITY
