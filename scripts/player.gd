extends Area2D

@export var speed = 350
var vel = Vector2.ZERO
var screensize = Vector2(480,720)

signal pickup
signal hurt

func _process(delta: float) -> void:
	var spr = $AnimatedSprite2D
	vel = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	position += vel * speed * delta
	
	# Prevent player from leaving screen edge
	#position.x = clamp(position.x,0,screensize.x)
	#position.y = clamp(position.y,0,screensize.y)
	
	# Animations
	if vel.length() > 0:
		spr.animation = "run"
	else:
		spr.animation = "idle"
	
	# Flip sprite
	if vel.x != 0:
		spr.flip_h = vel.x < 0
	
	# Screen Wrap
	if position.x > screensize.x:
		position.x = 0
	if position.x < 0:
		position.x = screensize.x
	if position.y > screensize.y:
		position.y = 0
	if position.y < 0:
		position.y = screensize.y

func start():
	print("player start")
	set_process(true) # Starts _process being called
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func die():
	print("player died")
	$AnimatedSprite2D.animation = "hurt"
	set_process(false) # Stops godot from calling _process

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		# Logic to prevent obstacle from spawning on top
		# of the player and immediately killing them
		var instance_id = area.get_instance_id()
		var instance = instance_from_id(instance_id)
		if instance.active == true:
			hurt.emit()
			die()
