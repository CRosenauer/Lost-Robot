extends Camera2D

#This isn't good...
func GetEntity(): #This could crash. Lets hope we use it correctly.
	if(get_parent().has_method("GetEntity")):
		return get_parent().GetEntity()
	else:
		return get_parent().get_parent().GetEntity()

func GetPuppet():
	pass
