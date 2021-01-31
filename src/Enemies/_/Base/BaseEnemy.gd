extends KinematicBody2D

const PHYSICS = preload("res://Physics/Physics.gd")

var m_playerPosition = Vector2()
var m_wasOnFloor   = false
var m_wasOnWall    = false
var m_wasOnCeiling = false


func RecievePlayerPosition(pos):
	m_playerPosition = pos

func PlayAnimation(name):
	$AnimatedSprite.play(name)

