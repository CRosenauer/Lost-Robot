extends "res://Entity/Base/IComponent.gd"

const INPUTS = preload("res://Inputs/InputMap.gd")

var m_inputArray = [0, 0, 0, 0, 0]
var m_edgeArray  = [0, 0, 0, 0, 0]


func QueryInputs():
	ClearInputs()
	
	#Cardinal Direction
	if(Input.is_action_pressed("InputDown")):
		m_inputArray[INPUTS.Input_Down] += 1
	if(Input.is_action_pressed("InputUp")):
		m_inputArray[INPUTS.Input_Down] -= 1
	
	if(Input.is_action_pressed("InputRight")):
		m_inputArray[INPUTS.Input_Right] += 1
	if(Input.is_action_pressed("InputLeft")):
		m_inputArray[INPUTS.Input_Right] -= 1
	
	#Actions
	InterpretAction(INPUTS.Input_Jump, "InputJump")
	InterpretAction(INPUTS.Input_Grapple, "InputGrapple")
	InterpretAction(INPUTS.Input_Dash, "InputDash")

func ClearInputs():
	for i in range(0, m_inputArray.size()):
		m_inputArray[i] = 0
		m_edgeArray[i]  = 0

func InterpretAction(enumValue, inputValue):
	if(Input.is_action_pressed(inputValue)):
		if(m_inputArray[enumValue] == 0):
			m_edgeArray[enumValue] += 1 #Cant use in engine rising in falling edges cause we arent using events lul.
		m_inputArray[enumValue] = 1
	else:
		if(m_inputArray[enumValue] == 1):
			m_edgeArray[enumValue] -= 1

func GetInputs():
	return m_inputArray

func GetEdges():
	return m_edgeArray
