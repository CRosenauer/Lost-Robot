extends Node2D


func GetEntity():
	if(get_parent().has_method("GetEntity")):
		return get_parent().GetEntity()
	else:
		return get_parent().get_parent().GetEntity()

func GetPuppet():
	pass
