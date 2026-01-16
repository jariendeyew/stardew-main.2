extends State

@export var player:Player
@export var anim:AnimationPlayer
@export var tool_collistion:CollisionShape2D

func _enter():
	_update_animation()
	
func _exit():
	anim.stop()
	
func _physics_update(delta):
	if !anim.is_playing():
		transition_to.emit("Idle")
	
func _update_animation():
	if player.player_direction == Vector2.UP:
		anim.play("hoe_up")
	elif player.player_direction == Vector2.DOWN:
		anim.play("hoe_down")
	elif player.player_direction == Vector2.LEFT:
		anim.play("hoe_left")
	elif player.player_direction == Vector2.RIGHT:
		anim.play("hoe_right")
