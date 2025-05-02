extends Node

@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var cactus_scene : PackedScene
@export var playtime = 30

# set initial variable values
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false
var cactus_count = 0
const game_title = "Coin Dash!"

func _ready():
	print("Ready")
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	$HUD.show_message(game_title)

func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() <= 0:
		next_level()

func new_game():
	print("New Game")
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	clear_junk()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	level_message(level)

func level_message(levelNumber):
	$HUD.show_message("Level " + str(levelNumber),1.5)

func next_level():
	# Start Next Level
	$LevelSound.play()
	level += 1
	time_left += 5
	level_message(level)
	$PowerupTimer.start(randi_range(1,15))
	print("level "+str(level))
	# Spawning Things
	## Cactus Spawning Logic
	if level >= 4 and level % 2 == 0 and cactus_count <= 10:
		print("creating cactus...")
		cactus_count += 1
		spawn_cactus()
	## Spawn Coins
	spawn_coins()

	# ==== END OF NEXT LEVEL ====

func clear_junk():
	get_tree().call_group("coins","queue_free")
	get_tree().call_group("powerups","queue_free")
	get_tree().call_group("obstacles","queue_free")

func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range($Coin.width,screensize.x - $Coin.width),
		randi_range($Coin.width,screensize.y - $Coin.width))

func spawn_cactus():
	#print("Cactus Count: " + str(cactus_count))
	#var new_cactus_count = cactus_count - get_tree().get_nodes_in_group("obstacles").size()
	#for i in new_cactus_count:
	var c = cactus_scene.instantiate()
	add_child(c)
	c.screensize = screensize
	c.position = Vector2(randi_range($Cactus.width,screensize.x - $Cactus.width),
	randi_range($Cactus.width,screensize.y - $Cactus.width))

func _on_game_timer_timeout():
	time_left -= 1
	#print("time left: " + str(time_left))
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()

func _on_player_hurt():
	game_over()

func _on_player_pickup(type):
	match type:
			"coin":
				$CoinSound.play()
				score += 1
				$HUD.update_score(score)
			"powerup":
				$PowerupSound.play()
				time_left += 5
				$HUD.update_timer(time_left)

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	$PowerupTimer.stop()
	$HUD.show_game_over()
	$Player.die()
	$DeathAnimationTimer.start()
	await $DeathAnimationTimer.timeout
	$Player.hide()
	clear_junk()

func _on_hud_start_game():
	print("start_game_emit")
	new_game()

# when PowerupTimer runs out spawn a powerup
func _on_powerup_timer_timeout() -> void:
	spawn_powerup()

func spawn_powerup():
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range($Powerup.width,screensize.x - $Powerup.width),
	randi_range($Powerup.width,screensize.y - $Powerup.width))

func _input(event):
	if event.is_action_pressed("debug_newgame"):
		print($Player.position)
