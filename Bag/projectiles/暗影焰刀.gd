extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

var speed:int = 500
var player:Player
var direction
var i:int = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	direction = player.global_position.direction_to(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	i +=1
	velocity = speed * direction
	hit_component.get_child(0).set_deferred("disabled",false)
	var angle = velocity.angle() + PI / 2
	sprite_2d.rotation = angle
	sprite_2d_2.rotation = angle
	if direction.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	if i > (1/delta)*3:
		queue_free()
	move_and_slide()
