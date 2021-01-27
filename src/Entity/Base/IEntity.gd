extends KinematicBody2D


func GetEntity():
	return self

func GetComponents():
	return $Components.get_children()

func GetPuppet():
	pass
