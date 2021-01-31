extends "res://Entity/Base/IEntity.gd"

#Imports
const INPUTS = preload("res://Inputs/InputMap.gd")
const LOCOMOTIONSTATES = preload("res://Entity/StateMachine/LocomotionStates.gd")
const PHYSICS = preload("res://Physics/Physics.gd")
const ABILITIES = preload("res://Entity/StateMachine/LockedInputs.gd")

#Signals
signal OnDeath()
signal OnLifeChanged(m_currentLife)


#Other shit
var m_velocity = Vector2()

var m_wasOnFloor  = false
var m_wasOnWall   = false

var m_runMultiplier = 1

var m_inputs

const TOTAL_LIFE = 3
var m_currentLife = TOTAL_LIFE

#Editable Vars
export var JumpVelocity       = -4
export var DoubleJumpVelocity = -4 # unused
export var MoveSpeed          = 250
export var MaxFallSpeed       = 4
export var RunSpeed           = 0
export var AirDashVelocity    = Vector2(4, -1.5) #WARNING: Will be multiplied by MoveSpeed
export var WallJumpVelocity   = Vector2(2, -3.5) # ^^^
export var AirDriftMod        = 10
export var FastAirDriftMod    = 10
export var XSpeedCap          = 1
export var KnockbackVelocity  = Vector2(-0.4, -2)
export var AirDrag            = 4

func _ready():
	LockAbilities(ABILITIES.Jump, false)
	LockAbilities(ABILITIES.Run, false)
	#LockAbilities(ABILITIES.DoubleJump, false)
	#LockAbilities(ABILITIES.WallJump, false)
	#LockAbilities(ABILITIES.AirDash, false)

func _physics_process(_delta):
	$Components/InputComponent.QueryInputs()
	
	m_inputs = $Components/InputComponent.GetInputs()
	var edges  = $Components/InputComponent.GetEdges()
	
	$LocomotionStateMachine.ReceiveInputs(m_inputs, edges)
	
	if(m_inputs[INPUTS.Input_Jump] == 1):
		pass
	
	if($LocomotionStateMachine.CanSetXVelocity()):
		m_velocity.x = m_inputs[INPUTS.Input_Right] * XSpeedCap
		SetDirection(m_inputs[INPUTS.Input_Right])
	else: #Air drift
		if($LocomotionStateMachine.GetState() != LOCOMOTIONSTATES.LocomotionStates.HitStun):
			if( abs( m_velocity.x ) > XSpeedCap):
				if( abs( m_velocity.x + m_inputs[INPUTS.Input_Right] * AirDriftMod * _delta) < XSpeedCap || sign(m_velocity.x) != sign(m_inputs[INPUTS.Input_Right]) ):
					m_velocity.x += m_inputs[INPUTS.Input_Right] * AirDriftMod * _delta
			else:
				if( abs( m_velocity.x + m_inputs[INPUTS.Input_Right] * FastAirDriftMod * _delta ) < XSpeedCap || sign(m_velocity.x) != sign(m_inputs[INPUTS.Input_Right])):
					m_velocity.x += m_inputs[INPUTS.Input_Right] * FastAirDriftMod * _delta
	
	#if(abs(m_velocity.x) > WallJumpVelocity.x ):
	#	m_velocity.x -= AirDrag * sign(m_velocity.x) * _delta
	
	$LocomotionStateMachine.m_lastKnownVelocity = m_velocity.x
	
	var tempVelocity
	tempVelocity    = m_velocity
	tempVelocity.x *= m_runMultiplier
	tempVelocity   *= MoveSpeed * 1.4
	
	move_and_slide(tempVelocity , PHYSICS.UP)
	$Components/AnimatedComponent.SetXVelocity(m_velocity.x)
	
	if(is_on_floor() != m_wasOnFloor):
		m_wasOnFloor = !m_wasOnFloor
		$LocomotionStateMachine.OnIsOnFloor(m_wasOnFloor)
		if(!m_wasOnFloor):
			$Components/AnimatedComponent.stop()
	
	
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
			$Components/AudioComponent.PlayAudio("Jump", false)
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
			$Components/AudioComponent.PlayAudio("Jump", false)
			#FlipDirection()
			if(m_inputs[INPUTS.Input_Right] != 0):
				m_velocity.x = m_inputs[INPUTS.Input_Right] * WallJumpVelocity.x
			else:
				m_velocity.x = GetDirection() * WallJumpVelocity.x
			m_velocity.y = WallJumpVelocity.y
		LOCOMOTIONSTATES.LocomotionStates.Run:
			m_runMultiplier = 2
			if(m_velocity.x != 0):
				$Components/AnimatedComponent.SetAnimation("Run")
			m_wasOnWall = true
		LOCOMOTIONSTATES.LocomotionStates.Grounded:
			m_runMultiplier = 1
			if(m_velocity.x != 0):
				$Components/AnimatedComponent.SetAnimation("Walk")
			else:
				$Components/AnimatedComponent.SetAnimation("Idle")
		LOCOMOTIONSTATES.LocomotionStates.AirDash:
			m_runMultiplier = 1
			$Components/AnimatedComponent.SetAnimation("Jump")
			if(m_inputs[INPUTS.Input_Right] != 0):
				m_velocity.x = m_inputs[INPUTS.Input_Right] * AirDashVelocity.x
				SetDirection(m_inputs[INPUTS.Input_Right])
				$LocomotionStateMachine.OnDirectionChange(m_inputs[INPUTS.Input_Right])
			else:
				m_velocity.x = GetDirection() * AirDashVelocity.x
			m_velocity.y = AirDashVelocity.y
		LOCOMOTIONSTATES.LocomotionStates.PreWallJump:
			$Components/AnimatedComponent.SetAnimation("PreWallJump")
			SetDirection(-sign(m_velocity.x))
		LOCOMOTIONSTATES.LocomotionStates.HitStun:
			$Components/AudioComponent.PlayAudio("Hit", false)
			#Need animation or something

func LockAbilities(lock, disable):
	$LocomotionStateMachine.LockAbilities(lock, disable)

#Used for enemies and stuff
func _on_HitBoxComponent_area_entered(_area):
	m_velocity.x = KnockbackVelocity.x * $LocomotionStateMachine.m_direction
	m_velocity.y = KnockbackVelocity.y 
	GainLife(-1)
	$LocomotionStateMachine.OnHitstun()

func GainLife(life):
	m_currentLife += life
	if(m_currentLife <= 0):
		m_currentLife = 0
		OnDeath()
		$Components/AnimatedComponent.visible = false
	elif(m_currentLife > 3):
		m_currentLife = 3
	emit_signal("OnLifeChanged", m_currentLife)
	#Send info to life bar component
	#Something to play a death animation... idk

func OnDeath():
	$Components/HitBoxComponent/HitBoxShape.set_deferred("disabled", true)
	$Components/AnimatedComponent.visible = false
	emit_signal("OnDeath")
