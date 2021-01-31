extends "res://Enemies/Base/BaseEnemy.gd"


export var Acceleration = 10
export var MaxSpeed     = 800

var m_velocity = Vector2()


func _physics_process(delta):
	
	var directionToTravel = m_playerPosition - global_position
	
	m_velocity.x += directionToTravel.x * Acceleration * delta
	
	if(m_velocity.x > MaxSpeed):
		m_velocity.x = MaxSpeed
	elif(m_velocity.x < -MaxSpeed):
		m_velocity.x = -MaxSpeed
	
	m_velocity = move_and_slide(m_velocity)
