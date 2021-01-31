extends "res://Enemies/Base/BaseEnemy.gd"


export var JumpSpeed = Vector2(300, -400)
export var MaxMoveSpeed  = 100

var m_velocity = Vector2()

func _physics_process(delta):
	
	move_and_slide(JumpSpeed, PHYSICS.UP)
	
	if(is_on_wall()):
		m_velocity.x = -m_velocity.x
		scale.x = -1
	
	if(is_on_floor()):
		$AnimatedSprite.play("hopper")
		m_velocity = Vector2()
		if($Timer.is_stopped()):
			$Timer.start()
	else:
		m_velocity.y -= PHYSICS.GRAVITY * delta * 60
		if m_velocity.y > MaxMoveSpeed:
			m_velocity.y = MaxMoveSpeed


func _on_Timer_timeout():
	m_velocity = JumpSpeed
	m_velocity.x = m_velocity.x * scale.x
	$AnimatedSprite.play("hop")
