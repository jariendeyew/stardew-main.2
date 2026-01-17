extends State

@export var player: Player
@export var anim: AnimationPlayer
@export var tool_collistion: CollisionShape2D

@onready var delay_timer: Timer = Timer.new()

func _enter() -> void:
	tool_collistion.disabled = true
	add_child(delay_timer)
	delay_timer.one_shot = true
	delay_timer.timeout.connect(_enable_collision)
	delay_timer.start(20 / Engine.physics_ticks_per_second)
	_update_animation()

func _exit() -> void:
	anim.stop()
	tool_collistion.disabled = true
	delay_timer.queue_free()

func _physics_update(delta: float) -> void:
	if not anim.is_playing():
		transition_to.emit("Idle")

func _enable_collision() -> void:
	tool_collistion.disabled = false

func _update_animation() -> void:
	match player.last_direction:
		Vector2.UP: 
			anim.play("draft_up")
			tool_collistion.position = Vector2(0, -18)
		Vector2.DOWN: 
			anim.play("draft_down")
			tool_collistion.position = Vector2(0, 2)
		Vector2.LEFT: 
			anim.play("draft_left")
			tool_collistion.position = Vector2(-10, -12)
		Vector2.RIGHT: 
			anim.play("draft_right")
			tool_collistion.position = Vector2(10, -12)
