extends "res://Entity/StateMachine/IStateMachine.gd"

const INPUTS = preload("res://Inputs/InputMap.gd")
const STATES = preload("res://Entity/StateMachine/LocomotionStates.gd")

export var WallJumpTime = 0.1

var m_usedDoubleJump = false
var m_usedAirDash = false

var m_isOnFloor = true
var m_isOnWall = false
var m_direction = 1

func _ready():
	m_currentState = STATES.LocomotionStates.Grounded

func ReceiveInputs(inputArr, edgeArr):
	#Todo: finish
	
	if(CanRun(inputArr, edgeArr)):
		OnRun()
	else:
		OnRunEnd()
	
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
	
	if(CanWallJump(inputArr, edgeArr)):
		OnWallJump()
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

func OnIsOnWall(value):
	m_isOnWall = value

func OnDirectionChange(nDirection):
	m_direction = nDirection

func CanJump(inputArr, edgeArr):
	return (GetState() == STATES.LocomotionStates.Grounded) && (edgeArr[INPUTS.Input_Jump] == 1)

func CanDoubleJump(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.Jump && (edgeArr[INPUTS.Input_Jump] == 1) && !m_usedDoubleJump

func CanAirDash(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.Grounded && (edgeArr[INPUTS.Input_Dash] == -1)

func CanPreWallJump(inputArr, edgeArr):
	return m_isOnWall && (STATES.LocomotionStates.Jump || STATES.LocomotionStates.AirDash)

func CanWallJump(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.PreWallJump && IsPressingOppositeDirection(inputArr) && edgeArr[INPUTS.Input_Jump]

func CanRun(inputArr, edgeArr):
	return GetState() == STATES.LocomotionStates.Grounded && (inputArr[INPUTS.Input_Dash] == 1)

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

func OnAirDashEnd():
	SetState(STATES.LocomotionStates.Jump)

func OnPreWallJump():
	SetState(STATES.LocomotionStates.AirDash)

func EndPreWallJump():
	SetState(STATES.LocomotionStates.Jump)

func OnWallJump():
	DisconnectTimer()
	SetState(STATES.LocomotionStates.WallJump)

func OnWallJumpEnd():
	SetState(STATES.LocomotionStates.Jump)

func OnRun():
	SetState(STATES.LocomotionStates.Run)

func OnRunEnd():
	SetState(STATES.LocomotionStates.Grounded)

func CanSetXVelocity():
	return GetState() == STATES.LocomotionStates.Grounded || GetState() == STATES.LocomotionStates.Run
