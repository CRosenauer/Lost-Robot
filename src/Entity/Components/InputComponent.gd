extends "res://Entity/Base/IComponent.gd"

const INPUTS = preload("res://Inputs/InputMap.gd")

var m_inputArray = [0, 0, 0, 0, 0, 0, 0]
var m_edgeArray  = [0, 0, 0, 0, 0, 0, 0]


func QueryInputs():
	pass

func GetInputs():
	return m_inputArray

func GetEdges():
	return m_edgeArray
