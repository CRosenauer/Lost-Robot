extends "res://Entity/Base/IEntity.gd"

const PHYSICS = preload("res://Physics/Physics.gd")

var m_velocity = Vector2()

export var MoveSpeed    = 250
export var MaxFallSpeed = 100

func _physics_process(_delta):
	$Components/InputComponent.QueryInputs()
	
	var inputs = $Components/InputComponent.GetInputs()
	
	m_velocity.x = inputs[1]
	move_and_slide(m_velocity * MoveSpeed, PHYSICS.UP)
	
	if(is_on_floor()):
		m_velocity.y = 0
	else:
		m_velocity.y -= PHYSICS.GRAVITY * _delta

func _on_locomotion_stateChanged(state):
	pass
