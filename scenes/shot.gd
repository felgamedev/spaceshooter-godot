extends Area2D

export var MOVE_SPEED: int = 500
var SCREEN_WIDTH: int = 320

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(SCREEN_WIDTH * delta, 0)

	if position.x >= SCREEN_WIDTH + 8:
		queue_free( )
