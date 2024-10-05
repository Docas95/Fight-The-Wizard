extends CanvasLayer

@onready var heart1 = $Panel/Heart
@onready var heart2 = $Panel/Heart2
@onready var heart3 = $Panel/Heart3

func _ready():
	Signalbus.update_player_health.connect(_on_update_player_health)
	
func _on_update_player_health(hp):
	if hp == 1:
		heart1.visible = true
		heart2.visible = false
		heart3.visible = false
	elif hp == 2:
		heart1.visible = true
		heart2.visible = true
		heart3.visible = false
	elif hp == 3:
		heart1.visible = true
		heart2.visible = true
		heart3.visible = false
	elif hp == 0:
		heart1.visible = false
		heart2.visible = false
		heart3.visible = false
	
