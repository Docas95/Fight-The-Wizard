extends CharacterBody2D

const SPEED = 7500.0
const JUMP_VELOCITY = -210.0
const SWORD_TIME = 0.3
const HURT_TIME = 1.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var collisions = $CollisionShape2D
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


func _ready():
	Signalbus.hurt_player.connect(enemy_hit)

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

func enemy_hit():
	hp -= 1
	if hp > 0:
		change_state(State.HURT)
	else:
		collisions.queue_free()
		Engine.time_scale = 0.5
		timer.start()
		animated_sprite.play("dead")
		change_state(State.DEAD)
		
	Signalbus.emit_signal("update_player_health", hp)

func _on_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
