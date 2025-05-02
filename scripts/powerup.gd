extends Area2D

var screensize = Vector2.ZERO
var active = false
@export var width = 30

func _ready():
	$AnimatedSprite2D.frame = randi() % 5
	$AnimatedSprite2D.hide()

# Called when the node enters the scene tree for the first time.
func pickup() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.3)
	tw.tween_property(self, "modulate:a", 0.0, 0.3)
	await tw.finished
	remove_powerup()

func _on_lifetime_timeout():
	remove_powerup()

func remove_powerup():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles") or area.is_in_group("no_spawn"):
		position = Vector2(randi_range(width,screensize.x - width),
		randi_range(width,screensize.y - width))

func _on_active_timer_timeout() -> void:
	$AnimatedSprite2D.show()
	active = true
