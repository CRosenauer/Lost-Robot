extends "res://Enemies/Enemies/Floater.gd"


func _physics_process(delta):
	
	var directionToTravel = m_playerPosition - global_position
	
	m_velocity.y += directionToTravel.y * Acceleration * delta
	
	if(m_velocity.y > MaxSpeed):
		m_velocity.y = MaxSpeed
	elif(m_velocity.y < -MaxSpeed):
		m_velocity.y = -MaxSpeed
	
	m_velocity = move_and_slide(m_velocity)
