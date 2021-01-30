extends "res://Entity/Base/IEntity.gd"

const INPUTS = preload("res://Inputs/InputMap.gd")
const LOCOMOTIONSTATES = preload("res://Entity/StateMachine/LocomotionStates.gd")
const PHYSICS = preload("res://Physics/Physics.gd")
const ABILITIES = preload("res://Entity/StateMachine/LockedInputs.gd")

var m_velocity = Vector2()

var m_wasOnFloor  = false
var m_wasOnWall   = false

var m_runMultiplier = 1

export var JumpVelocity = -5
export var MoveSpeed    = 250
export var MaxFallSpeed = 100
export var RunSpeed     = 0
export var AirDashVelocity  = Vector2(3, -1) #WARNING: Will be multiplied by MoveSpeed
export var WallJumpVelocity = Vector2(2, -3.5) # ^^^

var m_inputs

func _ready():
	LockAbilities(ABILITIES.Jump, false)
	LockAbilities(ABILITIES.Run, false)
	LockAbilities(ABILITIES.DoubleJump, false)
	LockAbilities(ABILITIES.WallJump, false)
	LockAbilities(ABILITIES.AirDash, false)

func _physics_process(_delta):
	$Components/InputComponent.QueryInputs()
	
	m_inputs = $Components/InputComponent.GetInputs()
	var edges  = $Components/InputComponent.GetEdges()
	
	if(m_inputs[INPUTS.Input_Jump] == 1):
		pass
	
	$LocomotionStateMachine.ReceiveInputs(m_inputs, edges)
	
	if($LocomotionStateMachine.CanSetXVelocity()):
		m_velocity.x = m_inputs[INPUTS.Input_Right]
		SetDirection(m_inputs[INPUTS.Input_Right])
	
	var tempVelocity
	tempVelocity    = m_velocity
	tempVelocity.x *= m_runMultiplier
	tempVelocity   *= MoveSpeed
	
	move_and_slide(tempVelocity , PHYSICS.UP)
	$Components/AnimatedComponent.SetXVelocity(m_velocity.x)
	
	if(is_on_floor() != m_wasOnFloor):
		m_wasOnFloor = !m_wasOnFloor
		$LocomotionStateMachine.OnIsOnFloor(m_wasOnFloor)
	
	if(is_on_wall() != m_wasOnWall):
		m_wasOnWall = !m_wasOnWall
		$LocomotionStateMachine.OnIsOnWall(m_wasOnWall)
		if(m_wasOnWall):
			m_velocity.x = sign(m_velocity.x) * 0.5
	
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
			$Components/AnimatedComponent.SetAnimation("Jump")
			m_velocity.y = JumpVelocity
			if(m_velocity.x == 0):
				m_velocity.x = sign(m_inputs[INPUTS.Input_Right])
			else:
				m_velocity.x = abs(m_velocity.x) * sign(m_inputs[INPUTS.Input_Right])
			SetDirection(m_inputs[INPUTS.Input_Right])
		LOCOMOTIONSTATES.LocomotionStates.WallJump:
			m_runMultiplier = 1
			$Components/AnimatedComponent.SetAnimation("Jump")
			FlipDirection()
			if(m_inputs[INPUTS.Input_Right] != 0):
				m_velocity.x = m_inputs[INPUTS.Input_Right] * WallJumpVelocity.x
			else:
				m_velocity.x = GetDirection() * WallJumpVelocity.x
			m_velocity.y = WallJumpVelocity.y
		LOCOMOTIONSTATES.LocomotionStates.Run:
			m_runMultiplier = 2
			$Components/AnimatedComponent.SetAnimation("Walk")
			m_wasOnWall = true
		LOCOMOTIONSTATES.LocomotionStates.Grounded:
			m_runMultiplier = 1
			if(m_velocity.x != 0):
				$Components/AnimatedComponent.SetAnimation("Walk")
			else:
				$Components/AnimatedComponent.SetAnimation("Idle")
		LOCOMOTIONSTATES.LocomotionStates.AirDash:
			m_runMultiplier = 1
			if(m_inputs[INPUTS.Input_Right] != 0):
				m_velocity.x = m_inputs[INPUTS.Input_Right] * AirDashVelocity.x
				SetDirection(m_inputs[INPUTS.Input_Right])
			else:
				m_velocity.x = GetDirection() * AirDashVelocity.x
			m_velocity.y = AirDashVelocity.y
		LOCOMOTIONSTATES.LocomotionStates.PreWallJump:
			$Components/AnimatedComponent.SetAnimation("PreWallJump")

func LockAbilities(lock, disable):
	$LocomotionStateMachine.LockAbilities(lock, disable)
