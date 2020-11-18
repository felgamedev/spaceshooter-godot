extends Area2D

const explosion = preload('res://scenes/explosion.tscn')

signal score()
signal hit_shield()

var score_emitted: bool = false
export var speed:int = 100
var vertical_speed: int = 0
var health:int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed += rand_range( -(speed*0.2), speed*0.2)
	vertical_speed += rand_range(-20,+20)


func _process(delta: float) -> void:
	position -= Vector2(speed * delta, vertical_speed * delta)

	if position.x <= -10 or position.y <= -8 or position.y >= 188:
		queue_free()


func _on_asteroid_area_entered(area: Area2D) -> void:
	# Reduce health
	if not score_emitted and area.is_in_group('shot') or area.is_in_group('player'):
		health -= 1

	if not score_emitted and area.is_in_group('shot'):
		if health == 0:
			emit_signal('score')
			score_emitted = true
			die()

		area.queue_free()

	elif not score_emitted and area.is_in_group('player') or area.is_in_group('shields'):
		if area.is_in_group('shields'):
			emit_signal('hit_shield')

		die()


func die() -> void:
		var my_explosion = explosion.instance()
		my_explosion.position = position
		get_parent().add_child(my_explosion)

		queue_free()
