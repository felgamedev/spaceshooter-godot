extends Sprite

export var scroll_speed:int = 30
var SCREEN_WIDTH:int = 320


func _process(delta:float):
	position += Vector2( -scroll_speed * delta, 0.0 )

	if ( position.x <= -SCREEN_WIDTH ):
		position.x = 0
