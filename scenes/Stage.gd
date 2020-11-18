extends Node2D

var asteroid = preload('res://scenes/asteroid.tscn')
var asteroid_strong = preload('res://scenes/asteroid_strong.tscn')

var score:int = 0
var game_over:bool = false
var level:int = 1
onready var default_spawn_offset:float = $spawn_timer.wait_time

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$player.connect( 'destroyed', self, 'on_player_destroyed')
	$spawn_timer.connect('timeout', self, 'spawn_asteroid')


func _input(event) -> void:
	if game_over and event.is_action_pressed('ui_accept'):
		game_over = false
		score = 0
		update_score()
		$player.restart()
		level = 1
		$UI/retry.visible = false

		# Ensure the spawn timer gets reset!
		$spawn_timer.wait_time = default_spawn_offset

	if event.is_action_pressed('quit'):
		get_tree().quit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func on_score():
	score += 1
	update_score()

	if score%5 == 0:
		level += 1

func on_player_destroyed() -> void:
	game_over = true
	$player.visible = false
	$UI.show()

func update_score() -> void:
	$UI/score.update_score(score)

func spawn_asteroid() -> void:
	var new_asteroid

	var spawner = rand_range(0,100)
	if spawner > 20:
		new_asteroid = asteroid.instance()
	else:
		new_asteroid = asteroid_strong.instance()

	new_asteroid.position.y = rand_range(0, 180)
	new_asteroid.position.x = 340
	new_asteroid.connect('score', self, 'on_score')
	new_asteroid.connect('hit_shield', $player, 'shield_hit')

	add_child(new_asteroid)

	$spawn_timer.wait_time = $spawn_timer.wait_time * 0.99
	$spawn_timer.start()
