extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_node("/root/Game/Player");

@export var item: InvItem

func _ready() -> void:
	interactable.interact = _on_interact

func _on_interact():
	if animated_sprite_2d.frame == 0:
		interactable.is_interactable = false
		player.collect(item)
		queue_free()
