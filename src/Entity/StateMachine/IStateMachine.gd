extends Node2D


signal OnStateChanged(state)

var m_currentState

func GetState():
	return m_currentState

func SetState(nState):
	m_currentState = nState
	emit_signal("OnStateChanged", m_currentState)
