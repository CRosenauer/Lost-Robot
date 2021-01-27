extends Node2D


signal OnStateChanged(state)

var m_currentState
var m_timerCallback

func GetState():
	return m_currentState

func SetState(nState):
	m_currentState = nState
	emit_signal("OnStateChanged", m_currentState)

func SetTimer(delay, callback):
	DisconnectTimer()
	$StateTimer.wait_time = delay
	$StateTimer.connect("timeout", self, callback)
	m_timerCallback = callback
	$StateTimer.start()

func DisconnectTimer():
	$StateTimer.disconnect("timeout", self, m_timerCallback)
