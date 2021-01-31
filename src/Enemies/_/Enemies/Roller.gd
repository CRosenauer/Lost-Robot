extends "res://Enemies/Base/BaseEnemy.gd"



export var MoveSpeed = -350

export var MaxFallSpeed = 50

var m_velocity = Vector2(MoveSpeed, 0.01)

func _physics_process(_delta):
	
	
	
	move_and_slide(m_velocity, PHYSICS.UP)
	
	if(is_on_floor() != m_wasOnFloor):
		m_wasOnFloor = !m_wasOnFloor
	
	if(is_on_wall() != m_wasOnWall):
		m_wasOnWall = !m_wasOnFloor
		ChangeDirection()
	
	if(m_wasOnFloor):
		m_velocity.y = 0.01
	else:
		m_velocity.y -= PHYSICS.GRAVITY
		#if(m_velocity.y > MaxFallSpeed):
		#	m_velocity.y = MaxFallSpeed
	


func _on_HitBox_area_entered(area):
	ChangeDirection()

func ChangeDirection():
	m_velocity.x = -m_velocity.x
	scale.x = -1
