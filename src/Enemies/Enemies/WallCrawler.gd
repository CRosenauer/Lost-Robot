extends "res://Enemies/Base/BaseEnemy.gd"


export var MoveSpeed = 150

var m_velocity = Vector2(0, MoveSpeed)

func _physics_process(delta):
	
	move_and_slide(m_velocity, PHYSICS.UP)
	
	if(is_on_floor() != m_wasOnFloor):
		m_wasOnFloor = !m_wasOnFloor
		if(m_wasOnFloor):
			ChangeDirection()
	
	if(is_on_ceiling() != m_wasOnCeiling):
		m_wasOnCeiling = !m_wasOnCeiling
		if(m_wasOnCeiling):
			ChangeDirection()


func ChangeDirection():
	m_velocity.y = -m_velocity.y
	scale.y = -1 * scale.y 
