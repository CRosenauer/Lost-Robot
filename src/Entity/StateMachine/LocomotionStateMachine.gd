extends "res://Entity/StateMachine/IStateMachine.gd"


const STATES = preload("res://Entity/StateMachine/LocomotionStates.gd")

func _ready():
	m_currentState = STATES.LocomotionStates.Grounded

func RecieveInputs(inputArr, edgeArr):
	pass
