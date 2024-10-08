extends Area2D

@export var move: int
@export var speed: int
@onready var starting_x = self.position.x
@onready var animated_sprite = $AnimatedSprite2D

enum Directions{
	LEFT,
	RIGHT
}
var dir = Directions.RIGHT

func _on_body_entered(_body):
	Signalbus.emit_signal("hurt_player")
	
func _process(delta):
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
			
	
