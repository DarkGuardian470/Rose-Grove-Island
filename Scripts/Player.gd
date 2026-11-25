extends CharacterBody2D

const SPEED = 4000
const SPRINT_BOOST = 1 # multiple of speed to add when sprinting

@onready var animated_sprite = $AnimatedSprite2D
@export var inv: Inv

enum SPRITE_DIR {UP, RIGHT, DOWN}
var sprite_dir: SPRITE_DIR = SPRITE_DIR.RIGHT

func get_inputs(delta: float) -> void:
	var input_direction = Input.get_vector(
		"Move_Left", "Move_Right",
		"Move_Up",   "Move_Down",
	)
	var isSprint = Input.is_action_pressed("Sprint")
	velocity = input_direction * SPEED * (1 + int(isSprint) * SPRINT_BOOST) * delta

func animate_movement() -> void:
	if velocity.is_zero_approx(): # not moving
		animated_sprite.play("IDLE_" + SPRITE_DIR.find_key(sprite_dir))
		return
		
	# Else
	match Direction.from_vector(velocity):
		"N":
			sprite_dir = SPRITE_DIR.UP

		"S":
			sprite_dir = SPRITE_DIR.DOWN

		"NE", "E", "SE":
			sprite_dir = SPRITE_DIR.RIGHT
			animated_sprite.flip_h = false
			
		"NW", "W", "SW":
			sprite_dir = SPRITE_DIR.RIGHT
			animated_sprite.flip_h = true
	
	# Then
	animated_sprite.play("MOVE_" +  SPRITE_DIR.find_key(sprite_dir))

func _physics_process(delta: float) -> void:
	get_inputs(delta)
	animate_movement()
	move_and_slide()

#Inventory Handling
func collect(item):
	inv.insert(item)
