extends "res://Entity/StateMachine/IStateMachine.gd"

const INPUTS    = preload("res://Inputs/InputMap.gd")
const STATES    = preload("res://Entity/StateMachine/LocomotionStates.gd")
const ABILITIES = preload("res://Entity/StateMachine/LockedInputs.gd")

export var WallJumpTime = 0.1

var m_usedDoubleJump = false
var m_usedAirDash = false

var m_isOnFloor = true
var m_isOnWall = false
var m_direction = 1

var m_oppositeDirectionPressed = false
var m_jumpPressed = false

var m_disabledAbilities = [true, true, true, true, true]

var m_lastKnownVelocity = 0

func _ready():
	m_currentState = STATES.LocomotionStates.Grounded

func ReceiveInputs(inputArr, edgeArr):
	#Todo: finish
	
	if(CanSetXVelocity()):
		m_direction = GetEntity().GetDirection()
	
	if(CanRun(inputArr, edgeArr)):
		OnRun()
	
	if(CanStopRun(inputArr, edgeArr)):
		OnRunEnd()
	
	if(m_currentState == STATES.LocomotionStates.PreWallJump && IsPressingOppositeDirection(inputArr)):
		m_oppositeDirectionPressed = true
		m_jumpPressed = false
	
	if(m_currentState == STATES.LocomotionStates.PreWallJump && edgeArr[INPUTS.Input_Jump] == 1):
		m_jumpPressed = true
	
	if(CanWallJump(inputArr, edgeArr)):
		OnWallJump()
		return
	
	if(CanDoubleJump(inputArr, edgeArr)):
		OnDoubleJump()
		return
	
	if(CanPreWallJump(inputArr, edgeArr)):
		OnPreWallJump()
		return
	
	if(CanJump(inputArr, edgeArr)):
		OnJump()
		return
	
	if(CanAirDash(inputArr, edgeArr)):
		OnAirDash()
		return

#Todo: Logic for grapplings
func OnGrounded():
	m_usedDoubleJump = false
	m_usedAirDash    = false
	SetState(STATES.LocomotionStates.Grounded)

func OnIsOnFloor(value):
	if(m_isOnFloor && !value && GetState() != STATES.LocomotionStates.Jump):
		$CoyoteTime.start()
	m_isOnFloor = value
	if(m_isOnFloor):
		OnGrounded()
	else:
		m_currentState = STATES.LocomotionStates.Jump

func OnIsOnWall(value):
	m_isOnWall = value
	if(GetState() != STATES.LocomotionStates.PreWallJump):
		m_direction = sign(m_lastKnownVelocity)
	if(!m_isOnWall && !m_isOnFloor):
		SetTimer(WallJumpTime, "ResetWallJumpParams")
	#	m_currentState = STATES.LocomotionStates.Jump
	#	get_parent().get_node("Components/AnimatedComponent").SetAnimation("Jump")

func OnDirectionChange(nDirection):
	m_direction = nDirection

func CanJump(inputArr, edgeArr):
	return !m_disabledAbilities[ABILITIES.Jump] && (GetState() == STATES.LocomotionStates.Grounded || GetState() == STATES.LocomotionStates.Run || !$CoyoteTime.is_stopped()) && (edgeArr[INPUTS.Input_Jump] == 1)

func CanDoubleJump(inputArr, edgeArr):
	if !m_disabledAbilities[ABILITIES.DoubleJump]:
		if (GetState() == STATES.LocomotionStates.Jump || GetState() == STATES.LocomotionStates.PreWallJump):
			if edgeArr[INPUTS.Input_Jump] == 1:
				return !m_usedDoubleJump
	
	return false

func CanAirDash(inputArr, edgeArr):
	return !m_disabledAbilities[ABILITIES.AirDash] && !m_usedAirDash && ( GetState() == STATES.LocomotionStates.Jump ||  GetState() == STATES.LocomotionStates.PreWallJump ) && (edgeArr[INPUTS.Input_Dash] == 1)

func CanPreWallJump(inputArr, edgeArr):
	return !m_disabledAbilities[ABILITIES.WallJump] && m_isOnWall && !m_isOnFloor && (STATES.LocomotionStates.Jump || STATES.LocomotionStates.AirDash)

func CanWallJump(inputArr, edgeArr):
	return !m_disabledAbilities[ABILITIES.WallJump] && GetState() == STATES.LocomotionStates.PreWallJump && m_oppositeDirectionPressed && m_jumpPressed

func CanRun(inputArr, edgeArr):
	return !m_disabledAbilities[ABILITIES.Run] && GetState() == STATES.LocomotionStates.Grounded && (inputArr[INPUTS.Input_Dash] == 1)

func CanStopRun(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.Run && (inputArr[INPUTS.Input_Dash] == 0 || inputArr[INPUTS.Input_Right] == 0)

func IsPressingOppositeDirection(inputArr):
	return (inputArr[INPUTS.Input_Right] == 1 && m_direction == -1) || (inputArr[INPUTS.Input_Right] == -1 && m_direction == 1)

func OnJump():
	SetState(STATES.LocomotionStates.Jump)
	$CoyoteTime.stop()

func OnDoubleJump():
	m_usedDoubleJump = true
	SetState(STATES.LocomotionStates.Jump)

func OnAirDash():
	m_usedAirDash = true
	SetState(STATES.LocomotionStates.AirDash)
	m_currentState = STATES.LocomotionStates.Jump

func OnAirDashEnd():
	SetState(STATES.LocomotionStates.Jump)

func OnPreWallJump():
	SetState(STATES.LocomotionStates.PreWallJump)

func EndPreWallJump():
	SetState(STATES.LocomotionStates.Jump)

func OnWallJump():
	ResetWallJumpParams()
	SetState(STATES.LocomotionStates.WallJump)
	m_currentState = STATES.LocomotionStates.Jump
	m_direction = -m_direction

func OnWallJumpEnd():
	SetState(STATES.LocomotionStates.Jump)

func OnRun():
	SetState(STATES.LocomotionStates.Run)

func OnRunEnd():
	if(m_isOnFloor):
		SetState(STATES.LocomotionStates.Grounded)
	else:
		SetState(STATES.LocomotionStates.Jump)

func OnHitstun():
	$StateTimer.stop()
	SetState(STATES.LocomotionStates.HitStun)

func CanSetXVelocity():
	return GetState() == STATES.LocomotionStates.Grounded || GetState() == STATES.LocomotionStates.Run

func ResetWallJumpParams():
	if(!m_isOnWall):
		m_oppositeDirectionPressed = false
		m_jumpPressed = false
		if(STATES.LocomotionStates.PreWallJump == GetState()):
			m_currentState = STATES.LocomotionStates.Jump
			get_parent().get_node("Components/AnimatedComponent").play("Jump")

func LockAbilities(lock, disable):
	m_disabledAbilities[lock] = disable
