extends CharacterBody2D
class_name RainbowCat

@onready var hit_component: HitComponent = $HitComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed:int = 50
var player:Player
var direction
var i:int = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	direction = player.global_position.direction_to(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	#direction = Vector2(1,1)
	#global_position += speed * direction
	i +=1
	if i<30:
		velocity = speed * direction
	else:
		hit_component.get_child(0).set_deferred("disabled",false)
		velocity = speed * direction * 20
	var angle = velocity.angle() + PI / 2
	sprite_2d.rotation = angle
	if direction.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	if i > (1/delta)*3:
		queue_free()
	move_and_slide()
