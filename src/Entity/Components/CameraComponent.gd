extends Camera2D

var TRANSITIONFRAMES = 15


var locked = true
var anchor
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
	anchor = get_parent().get_parent().get_node("Anchor")
	player = get_parent()
	


func _on_Button_pressed():
	if locked: #align anchor with player, reparent, then move anchor
		anchor.position.x = player.position.x
		anchor.position.y = player.position.y
		
		player.remove_child(self)
		anchor.add_child(self)

		deltaPosX = (get_viewport_rect().size.x/2-anchor.position.x)/TRANSITIONFRAMES
		deltaPosY = (get_viewport_rect().size.y/2-anchor.position.y)/TRANSITIONFRAMES
		deltaZoomX = (1.2-zoom.x)/TRANSITIONFRAMES
		deltaZoomY = (1.2-zoom.y)/TRANSITIONFRAMES
		transitionCounter = TRANSITIONFRAMES
		print("unlocking camera")
	else: #move anchor to align with player, then reparent (in _process)
		deltaPosX = (player.position.x-get_viewport_rect().size.x/2)/TRANSITIONFRAMES
		deltaPosY = (player.position.y-get_viewport_rect().size.y/2)/TRANSITIONFRAMES
		deltaZoomX = (1-zoom.x)/TRANSITIONFRAMES
		deltaZoomY = (1-zoom.y)/TRANSITIONFRAMES
		transitionCounter = TRANSITIONFRAMES
		print("locking camera")
		
	locked = !locked

func _process(delta):
	if transitionCounter > 0:
		transition()
	if transitionCounter > -1:
		transitionCounter = transitionCounter-1
	if transitionCounter == 1 and locked: #the reparent step of locking camera
		anchor.remove_child(self)
		player.add_child(self)

func transition(): #delta determined by distance between anchor and player at time of camera mode change
	#currently does not account for player movement during camera transition
	#result: sudden movement in last frame of locking camera if player is moving
	#less noticeable when TRANSITIONFRAMES is low
	#can fix by adding player velocity to anchor.position during locking
	anchor.position.x += deltaPosX
	anchor.position.y += deltaPosY
	zoom.x += deltaZoomX
	zoom.y += deltaZoomY
	
