extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$shield_sprite.modulate.a = 0.3
	self.connect('on_area_entered', self, '_on_area_entered')


func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group('asteroids'):
		queue_free()
