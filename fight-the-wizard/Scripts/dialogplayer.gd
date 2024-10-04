extends CanvasLayer

@export_file var scene_text_file = ""

const READ_SPEED = 0.02

var scene_text = {}
var selected_text = []
var in_progress = false

@onready var background = $background
@onready var text_label = $background/Label

func _ready():
	background.visible = false
	scene_text = load_scene_text()
	# connect dialog player to display dialog signal
	# dialog player will now be called whenever the display_dialog signal is sent
	Signalbus.display_dialog.connect(on_display_dialog)
	
func on_display_dialog(text_key, xoffset, yoffset):
	if in_progress:
		next_line()
	else:
		# position dialog box
		self.offset.x = xoffset
		self.offset.y = yoffset
		
		# pause game
		get_tree().paused = true
		# diaplyay dialog
		background.visible = true
		in_progress = true
		
		# get set of texts for this dialog
		selected_text = scene_text[text_key].duplicate()
		show_text()
	
func show_text():
	# display text
	var text_tmp = selected_text.pop_front()
	text_label.text = text_tmp
	
	# animate dialog text
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(text_label, "visible_characters", len(text_tmp), len(text_tmp) * READ_SPEED).from(0).finished

func next_line():
	# check if there are more texts to display
	if selected_text.size() > 0:
		show_text()
	else:
		finish()

func finish():
	text_label.text = ""
	background.visible = false
	in_progress = false
	get_tree().paused = false
	
func load_scene_text():
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	return JSON.parse_string(file.get_as_text())
