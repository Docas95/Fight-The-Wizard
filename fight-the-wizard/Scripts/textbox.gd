extends CanvasLayer

const READ_SPEED = 0.03

@onready var textbox_container = $TextBoxContainer
@onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
@onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
@onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label
@onready var tween = get_tree().create_tween()

enum State{
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	queue_text("First text has been added!")
	queue_text("Second text has been added!")
	queue_text("Third text has been added!")
	queue_text("Fourth text has been added!")

func _process(delta):
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				tween = get_tree().create_tween()
				display_text()
		State.READING:
			if Input.is_action_just_pressed("action_1"):
				label.visible_ratio = 1.0
				tween.stop()
				on_tween_finished()
		State.FINISHED:
			if Input.is_action_just_pressed("action_1"):
				change_state(State.READY)
				if text_queue.is_empty():
					hide_textbox()
				

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func queue_text(text):
	text_queue.push_back(text)

func display_text():
	var text = text_queue.pop_front()
	change_state(State.READING)
	label.text = text
	show_textbox()
	label.visible_ratio = 0.0
	end_symbol.text = ""
	tween.tween_property(label, "visible_characters", len(text),len(text) * READ_SPEED).from(0).finished
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	end_symbol.text = "*"
	change_state(State.FINISHED)
	
func change_state(state):
	current_state = state
	match state:
		State.READY:
			print("Changed state to: State.READY")
		State.READING:
			print("Changed state to: State.READING")
		State.FINISHED:
			print("Changed state to: State.FINISHED")
