extends Area2D

@export var move: int
@export var speed: int
@onready var starting_x = self.position.x
@onready var animated_sprite = $AnimatedSprite2D

var killed = false

enum Directions{
	LEFT,
	RIGHT
}
var dir = Directions.RIGHT
	
func _process(delta):
	if killed:
		self.position.y += delta * speed * 2
		return
	
	if dir == Directions.RIGHT:
		self.position.x += delta * speed
		if(self.position.x >= starting_x + move):
			dir = Directions.LEFT
			animated_sprite.flip_h = true
	elif dir == Directions.LEFT:
		self.position.x -= delta * speed
		if(self.position.x <= starting_x - move):
			dir = Directions.RIGHT
			animated_sprite.flip_h = false
	
# kill slime when hit by player sword		
func _on_area_entered(_area):
	killed = true
	
