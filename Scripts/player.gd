extends CharacterBody2D


const SPEED = 130.0

@onready var animated_sprite = $AnimatedSprite2D

@export var inv: Inv

var idle_dir = "side"

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:

	# Direction Control
	var x_dir := Input.get_axis("Move_Left", "Move_Right")
	var y_dir := Input.get_axis("Move_Up", "Move_Down")
	
	# Movement
	velocity.x = x_dir * SPEED
	velocity.y = y_dir * SPEED
	
	if x_dir != 0:
		animated_sprite.play("Moving side")
		animated_sprite.flip_h = x_dir < 0
		idle_dir = "side"
	elif y_dir > 0:
		animated_sprite.play("Moving down")
		idle_dir = "down"
	elif y_dir < 0:
		animated_sprite.play("Moving up")
		idle_dir = "up"
	else: # not moving
		animated_sprite.play("Idle " + idle_dir)

	move_and_slide()

#Inventory Handling
func collect(item):
	inv.insert(item)
