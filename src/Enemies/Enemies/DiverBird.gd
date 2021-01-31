extends "res://Enemies/Base/BaseEnemy.gd"



export var FlySpeed = 500
export var DiveSpeed = 1000
export var Lift = 100

var m_velocity = Vector2()
var m_isDiving = false

func _physics_process(delta):
	pass
	#if(!m_isDiving)
