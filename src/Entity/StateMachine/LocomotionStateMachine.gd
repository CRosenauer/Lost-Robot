extends "res://Entity/StateMachine/IStateMachine.gd"

const INPUTS = preload("res://Inputs/InputMap.gd")
const STATES = preload("res://Entity/StateMachine/LocomotionStates.gd")

export var WallJumpTime = 0.1

var m_usedDoubleJump = false
var m_usedAirDash = false

var m_isOnFloor = true
var m_isOnWall = false
var m_direction = 1

var m_oppositeDirectionPressed = false
var m_jumpPressed = false

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
		SetTimer(WallJumpTime, "ResetWallJumpParams")
		m_oppositeDirectionPressed = true
		m_jumpPressed = false
	
	if(m_currentState == STATES.LocomotionStates.PreWallJump && edgeArr[INPUTS.Input_Jump] == 1):
		m_jumpPressed = true
	
	if(CanWallJump(inputArr, edgeArr)):
		OnWallJump()
		return
	
	if(CanJump(inputArr, edgeArr)):
		OnJump()
		return
	
	if(CanDoubleJump(inputArr, edgeArr)):
		OnDoubleJump()
		return
	
	if(CanAirDash(inputArr, edgeArr)):
		OnAirDash()
		return
	
	if(CanPreWallJump(inputArr, edgeArr)):
		OnPreWallJump()
		return
	

#Todo: Logic for grapplings
func OnGrounded():
	m_usedDoubleJump = false
	m_usedAirDash    = false
	SetState(STATES.LocomotionStates.Grounded)

func OnIsOnFloor(value):
	m_isOnFloor = value
	if(m_isOnFloor):
		OnGrounded()
	else:
		m_currentState = STATES.LocomotionStates.Jump

func OnIsOnWall(value):
	m_isOnWall = value
	if(!m_isOnWall && !m_isOnFloor):
		ResetWallJumpParams()
		m_currentState = STATES.LocomotionStates.Jump

func OnDirectionChange(nDirection):
	m_direction = nDirection

func CanJump(inputArr, edgeArr):
	return (GetState() == STATES.LocomotionStates.Grounded || GetState() == STATES.LocomotionStates.Run) && (edgeArr[INPUTS.Input_Jump] == 1)

func CanDoubleJump(inputArr, edgeArr):
	return (GetState() == STATES.LocomotionStates.Jump || GetState() == STATES.LocomotionStates.PreWallJump) && (edgeArr[INPUTS.Input_Jump] == 1) && !m_usedDoubleJump

func CanAirDash(inputArr, edgeArr):
	return !m_usedAirDash && GetState() == STATES.LocomotionStates.Jump && (edgeArr[INPUTS.Input_Dash] == 1)

func CanPreWallJump(inputArr, edgeArr):
	return m_isOnWall && !m_isOnFloor && (STATES.LocomotionStates.Jump || STATES.LocomotionStates.AirDash)

func CanWallJump(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.PreWallJump && m_oppositeDirectionPressed && m_jumpPressed

func CanRun(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.Grounded && (inputArr[INPUTS.Input_Dash] == 1)

func CanStopRun(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.Run && (inputArr[INPUTS.Input_Dash] == 0)

func IsPressingOppositeDirection(inputArr):
	return (inputArr[INPUTS.Input_Right] == 1 && m_direction == -1) || (inputArr[INPUTS.Input_Right] == -1 && m_direction == 1)

func OnJump():
	SetState(STATES.LocomotionStates.Jump)

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

func CanSetXVelocity():
	return GetState() == STATES.LocomotionStates.Grounded || GetState() == STATES.LocomotionStates.Run

func ResetWallJumpParams():
	m_oppositeDirectionPressed = false
	m_jumpPressed = false
