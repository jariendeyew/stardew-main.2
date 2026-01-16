extends State

@export var player:Player
@export var anim:AnimationPlayer
@export var tool_collistion:CollisionShape2D

var i:int

func _enter():
	i=0
	_update_animation()
	
	
func _exit():
	anim.stop()
	tool_collistion.disabled = true
	
func _physics_update(delta):
	i+=1
	if i == 20 : #让碰撞在20帧后执行
		tool_collistion.disabled = false
	if !anim.is_playing():
		transition_to.emit("Idle")
	
func _update_animation():
	if player.player_direction == Vector2.UP:
		anim.play("draft_up")
		tool_collistion.position = Vector2(0,-18)
	elif player.player_direction == Vector2.DOWN:
		anim.play("draft_down")
		tool_collistion.position = Vector2(0,2)
	elif player.player_direction == Vector2.LEFT:
		anim.play("draft_left")
		tool_collistion.position = Vector2(-10,-12)
	elif player.player_direction == Vector2.RIGHT:
		anim.play("draft_right")
		tool_collistion.position = Vector2(10,-12)
