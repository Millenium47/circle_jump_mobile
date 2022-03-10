extends Node


var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var score = 0 setget set_score
var level = 0
 
func _ready():
	randomize()
	$HUD.hide()
	
func new_game():
	set_score(0)
	level = 1
	$HUD.update_score(score)
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("died", self, "_on_Jumper_died")
	spawn_circle($StartPosition.position)
	$HUD.show()
	$HUD.show_message("GO!")
	if Settings.enable_music:
		$Music.play()
	
func spawn_circle(_position=null):
	var c = Circle.instance()
	if !_position:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x,y)
	add_child(c)
	c.init(_position, level)
	
func _on_Jumper_captured(object):
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	set_score(score + 1)

func _on_Jumper_died():
	get_tree().call_group("circles", "implode")
	$HUD.hide()
	$Screens.game_over()
	if Settings.enable_music:
		$Music.play()
	
func set_score(new_score):
	score = new_score
	$HUD.update_score(score)
	if score > 0 and score % Settings.circles_per_level == 0:
		level += 1
		$HUD.show_message("Level %s" % str(level))
	


func set_tween(object, key):
	pass # Replace with function body.
