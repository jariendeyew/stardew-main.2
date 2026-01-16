extends RigidBody2D
class_name Projectile

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	_AI(delta)
	
func _AI(delta:float)->void:
	pass
