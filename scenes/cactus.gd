extends Area2D

@export var width = 30
var screensize = Vector2.ZERO
var active = false

func _ready():
	$Sprite2D.hide()

# Move Cactus if spawns inside player no_spawn zone
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("no_spawn") and active == false:
		position = Vector2(randi_range(width,screensize.x - width),
		randi_range(width,screensize.y - width))

func remove_cactus():
	queue_free()

func _on_activate_timer_timeout() -> void:
	active = true
	$Sprite2D.show()
