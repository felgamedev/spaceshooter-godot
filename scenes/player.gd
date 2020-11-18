extends Area2D
export var player_speed = 120

var can_shoot: bool = true
var dead = false

var shot = preload("res://scenes/shot.tscn")
onready var shield = preload('res://scenes/shield.tscn')

signal destroyed()

# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_position()
	add_child(shield.instance())

	$reload_timer.connect( 'timeout', self, 'reload' )
	self.connect( 'area_entered', self, '_on_area_entered')


func _input(event):
	if event.is_action_pressed("ui_select") and can_shoot:
		var new_shot = shot.instance()
		# Offset for the front of the spaceship!
		new_shot.position = position + Vector2(9, 0)
		get_parent().add_child(new_shot)
		can_shoot = false
		$reload_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_dir = Vector2()

	if not dead:
		if Input.is_action_pressed('ui_left'):
			move_dir.x -= 1
		if Input.is_action_pressed('ui_right'):
			move_dir.x += 1
		if Input.is_action_pressed('ui_up'):
			move_dir.y -= 1
		if Input.is_action_pressed('ui_down'):
			move_dir.y += 1

		position += (player_speed * delta) * move_dir

		if position.x <= 8:
			position.x = 8
		elif position.x >= 320 - 8:
			position.x = 320 - 8

		if position.y <= 8:
			position.y = 8
		elif position.y >= 180 - 8:
			position.y = 180 - 8


func reload( ):
	can_shoot = true


func _on_area_entered(area: Area2D) -> void:
	if not dead and area.is_in_group('asteroids'):
		_die()


func _die() -> void:
	position = Vector2(500, 500)
	dead = true
	emit_signal('destroyed')

	visible = false


func _reset_position() -> void:
	position.x = 20
	position.y = 40


func restart() -> void:
	_reset_position()
	visible = true
	dead = false
	add_child(shield.instance())

func shield_hit() -> void:
	if not dead:
		$shield.queue_free()
