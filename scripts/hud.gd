extends CanvasLayer

signal start_game

var game_started = false

func update_score(value):
	$MarginContainer/Score.text = str(value)

func update_timer(value):
	$MarginContainer/Time.text = str(value)

func show_message(text,time = null,fontsize = 72):
	$Message.text = text
	$Message.add_theme_font_size_override("font_size",fontsize)
	$Message.show()
	if time != null: $Timer.start(time)
	
func _on_timer_timeout() -> void:
	$Message.hide()

func _input(event):   
	if event.is_action_pressed("start_button") and game_started == false:
		start_button()

func _on_start_button_pressed():
	start_button()
	
func start_button():
	print("start button pressed")
	game_started = true
	$StartButton.hide()
	$Message.hide()
	start_game.emit()

func show_game_over():
	show_message("Game Over",5)
	await $Timer.timeout
	game_started = false
	$StartButton.show()
	$Message.text = "Coin Dash!"
	$Message.show()
