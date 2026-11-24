extends CharacterBody2D

const SPEED = 4000
const SPRINT_BOOST = 1 # multiple of speed to add when sprinting

enum DIR {NW = -3, N, NE, E, SE, S, SW, W} # E = 0
func get_dir(angle: float) -> String:
	# get the angle in 8th's of a circle
	var ang = velocity.angle() * 8 / TAU
	# return the direction
	return DIR.find_key(int(ang))

@onready var animated_sprite = $AnimatedSprite2D
@export var inv: Inv
var idle_dir = "side"

func get_inputs(delta: float) -> void:
	var input_direction = Input.get_vector(
		"Move_Left", "Move_Right",
		"Move_Up",   "Move_Down",
	)
	var isSprint = Input.is_action_pressed("Sprint")
	velocity = input_direction * SPEED * (1 + int(isSprint) * SPRINT_BOOST) * delta

@warning_ignore("unused_parameter")
func animate() -> void:
	# Movement
	if velocity.is_zero_approx(): # not moving
		animated_sprite.play("idle" + idle_dir)
		return
	
	else: 
		var dir = get_dir(velocity.angle())
		match dir:
			"N": 
				animated_sprite.play("moving_up")
				idle_dir = "up"

			"S":
				animated_sprite.play("moving_down")
				idle_dir = "down"

			"NE", "E", "SE":
				animated_sprite.play("moving_side")
				animated_sprite.flip_h = false
				idle_dir = "side"
				
			"NW", "W", "SW":
				animated_sprite.play("moving_side")
				animated_sprite.flip_h = true
				idle_dir = "side"

func _physics_process(delta: float) -> void:
	get_inputs(delta)
	# animate()
	if !velocity.is_zero_approx(): print(get_dir(velocity.angle()))
	move_and_slide()

#Inventory Handling
func collect(item):
	inv.insert(item)
