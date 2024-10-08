extends RigidBody2D

func _ready():
	self.gravity_scale = 0.0

func _on_trigger_fall_body_entered(body):
	self.gravity_scale = 1.0
