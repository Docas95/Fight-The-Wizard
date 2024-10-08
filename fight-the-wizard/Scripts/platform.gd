extends StaticBody2D

@export var color : String
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play(color)
	
