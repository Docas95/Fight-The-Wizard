extends CharacterBody2D

const SPEED = 7500.0
const JUMP_VELOCITY = -220.0
const SWORD_TIME = 0.3
const HURT_TIME = 0.3

@onready var animated_sprite = $AnimatedSprite2D
@onready var collisions = $CollisionShape2D
@onready var weapon_hit = $WeaponHitbox
@onready var timer = $Timer

enum State{
	IDLE,
	RUNNING,
	JUMPING,
	SWORD,
	HURT,
	DEAD
}

enum Action{
	NONE,
	SWORD
}

var hp = 3
var player_state = State.JUMPING
var action_1 = Action.SWORD
var action_2 = Action.NONE
var direction = 1.0
var timing = 0.0
var jump_count = 0


func _ready():
	weapon_hit.collision_layer = 8

func change_state(state):
	player_state = state
	#print("Changed state to:" + str(state))

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
			
			# check if player is performing action 1
			if Input.is_action_just_pressed("action_1"):
				change_state(change_state_to_action(action_1))
				
			# check if player if performing action 2
			if Input.is_action_just_pressed("action_2"):
				change_state(change_state_to_action(action_2))
			
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
			
			# check if player is performing action 1
			if Input.is_action_just_pressed("action_1"):
				change_state(change_state_to_action(action_1))
				
			# check if player if performing action 2
			if Input.is_action_just_pressed("action_2"):
				change_state(change_state_to_action(action_2))
			
			# play running animation
			animated_sprite.play("running")
		State.JUMPING:
			# check if player wants to move
			get_player_direction_input()
			move_player_horizontal(delta)
			
			# check if player has hit the floor yet
			if is_on_floor():
				jump_count = 0
				change_state(State.IDLE)
			move_player_vertical(delta)
			
			# double jump
			if get_player_jump_input() and jump_count < 2:
				jump()
			
			# check if player is performing action 1
			if Input.is_action_just_pressed("action_1"):
				change_state(change_state_to_action(action_1))
				
			# check if player if performing action 2
			if Input.is_action_just_pressed("action_2"):
				change_state(change_state_to_action(action_2))
			
			# player jumping animation
			animated_sprite.play("jumping")
		State.HURT:
			timing += delta
			if timing >= HURT_TIME:
				timing = 0.0;
				change_state(State.IDLE)
				
			# check if player wants to move
			get_player_direction_input()
			move_player_horizontal(delta)
			
			# check if player wants to jump
			if get_player_jump_input():
				jump()
			move_player_vertical(delta)

			# play hurt animation
			animated_sprite.play("hurt")
		State.DEAD:
			move_player_horizontal(delta)
			move_player_vertical(delta)
		State.SWORD:
			weapon_hit.collision_layer = 2
			# end state after a certain amount of time
			timing += delta
			if timing >= SWORD_TIME:
				weapon_hit.collision_layer = 8
				timing = 0.0
				change_state(State.IDLE)
			
			# check if player wants to move
			get_player_direction_input()
			move_player_horizontal(delta)
			
			# check if player wants to jump
			if get_player_jump_input():
				jump()
			move_player_vertical(delta)
			
			# check if player if performing action 2
			if Input.is_action_just_pressed("action_2"):
				timing = 0.0
				change_state(change_state_to_action(action_2))
			
			# play sword animation
			animated_sprite.play("sword")
			
	move_and_slide()
			
			
func get_player_direction_input():
	direction = Input.get_axis("walk_left", "walk_right")

func get_player_jump_input():
	return Input.is_action_just_pressed("jump")
	
func move_player_horizontal(delta):
	if direction != 0:
		if direction > 0:
			animated_sprite.flip_h = false
			weapon_hit.rotation_degrees = 0
		else:
			animated_sprite.flip_h = true
			weapon_hit.rotation_degrees = 180
		velocity.x = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func move_player_vertical(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func jump():
	velocity.y = JUMP_VELOCITY
	if(jump_count == 1):
		velocity.y += JUMP_VELOCITY * 0.2
	jump_count += 1

func change_state_to_action(action):
	match action:
		Action.NONE:
			return State.IDLE
		Action.SWORD:
			return State.SWORD

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

func _on_hitbox_area_entered(_area):
	hp -= 1
	if hp > 0:
		change_state(State.HURT)
	else:
		if player_state != State.DEAD:
			collisions.queue_free()
			Engine.time_scale = 0.5
			timer.start()
			animated_sprite.play("dead")
			change_state(State.DEAD)
		
	Signalbus.emit_signal("update_player_health", hp)
