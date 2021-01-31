extends "res://Enemies/Base/BaseEnemy.gd"


var m_velocity = Vector2(-100, 100)

func _physics_process(delta):
	
	
	m_velocity = move_and_slide(m_velocity)
