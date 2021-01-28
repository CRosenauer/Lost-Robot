extends Camera2D

var TRANSITIONTIME = 60

var locked = true
var scene
var player
var transitionCounter = 0

var deltaPosX
var deltaPosY
var deltaZoomX
var deltaZoomY

#This isn't good...
func GetEntity(): #This could crash. Lets hope we use it correctly.
	if(get_parent().has_method("GetEntity")):
		return get_parent().GetEntity()
	else:
		if(get_parent().get_parent().has_method("GetEntity")):
			return get_parent().get_parent().GetEntity()
		else:
			return null

func GetPuppet():
	pass

func _ready():
	print("ready")
	scene = get_parent().get_parent()
	player = get_parent()
	
	position.x = -get_viewport_rect().size.x/2
	position.y = -get_viewport_rect().size.y/2

func _on_Button_pressed():
	if locked:
		player.remove_child(self)
		scene.add_child(self)
		deltaPosX = (0-position.x)/TRANSITIONTIME
		deltaPosY = (0-position.y)/TRANSITIONTIME
		deltaZoomX = (1.2-zoom.x)/TRANSITIONTIME
		deltaZoomY = (1.2-zoom.y)/TRANSITIONTIME
		transitionCounter = TRANSITIONTIME
		print("unlocking camera")
	else:
		scene.remove_child(self)
		player.add_child(self)
		deltaPosX = (-get_viewport_rect().size.x/2-position.x)/TRANSITIONTIME
		deltaPosY = (-get_viewport_rect().size.y/2-position.y)/TRANSITIONTIME
		deltaZoomX = (1-zoom.x)/TRANSITIONTIME
		deltaZoomY = (1-zoom.y)/TRANSITIONTIME
		transitionCounter = TRANSITIONTIME
		print("locking camera")
	locked = !locked

func _process(delta):
	if transitionCounter > 0:
		transition()
	transitionCounter = transitionCounter-1


func transition():
		position.x += deltaPosX
		position.y += deltaPosY
		zoom.x += deltaZoomX
		zoom.y += deltaZoomY
		
		
