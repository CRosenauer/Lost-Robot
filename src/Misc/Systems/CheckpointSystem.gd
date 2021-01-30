extends Node2D


var m_currentCheckpoint = Vector2()

func SetCheckPoint(checkpoint):
	m_currentCheckpoint = checkpoint


func GetCheckpoint():
	return m_currentCheckpoint
