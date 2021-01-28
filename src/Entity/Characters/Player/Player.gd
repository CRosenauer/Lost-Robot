extends "res://Entity/Base/IEntity.gd"

const INPUTS = preload("res://Inputs/InputMap.gd")
const LOCOMOTIONSTATES = preload("res://Entity/StateMachine/LocomotionStates.gd")
const PHYSICS = preload("res://Physics/Physics.gd")

var m_velocity = Vector2()

var m_wasOnFloor = false
var m_wasOnWall  = false

export var JumpVelocity = -5
export var MoveSpeed    = 250
export var MaxFallSpeed = 100

func _physics_process(_delta):
	$Components/InputComponent.QueryInputs()
	
	var inputs = $Components/InputComponent.GetInputs()
	var edges  = $Components/InputComponent.GetEdges()
	
	if(inputs[INPUTS.Input_Jump] == 1):
		pass
	
	$LocomotionStateMachine.ReceiveInputs(inputs, edges)
	
	if($LocomotionStateMachine.CanSetXVelocity()):
		m_velocity.x = inputs[INPUTS.Input_Right]
	
	move_and_slide(m_velocity * MoveSpeed, PHYSICS.UP)
	
	
	if(is_on_wall() != m_wasOnWall):
		m_wasOnWall = !m_wasOnWall
		$LocomotionStateMachine.OnIsOnWall(m_wasOnWall)
	
	if(is_on_floor() != m_wasOnFloor):
		m_wasOnFloor = !m_wasOnFloor
		$LocomotionStateMachine.OnIsOnFloor(m_wasOnFloor)
	
	if(is_on_ceiling()):
		m_velocity.y = 0
	
	if(m_wasOnFloor):
		m_velocity.y = 0.01
	else:
		m_velocity.y -= PHYSICS.GRAVITY * _delta
		if(m_velocity.y > MaxFallSpeed):
			m_velocity.y = MaxFallSpeed

func _on_locomotion_stateChanged(state):
	match state:
		LOCOMOTIONSTATES.LocomotionStates.Jump:
			m_velocity.y =  JumpVelocity
		LOCOMOTIONSTATES.LocomotionStates.WallJump:
			m_velocity.y =  JumpVelocity
