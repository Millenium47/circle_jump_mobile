extends Area2D

signal captured
signal died

onready var trail = $Trail/Points

var velocity = Vector2(100, 0)  # start value for testing
var jump_speed = 1000
var target = null  # if we're on a circle
var trail_lenght = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if trail.points.size() > trail_lenght:
		trail.remove_point(0)
	trail.add_point(position)
		
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.pressed:
		jump()

func jump():
	target.implode()
	target = null
	velocity = transform.x * jump_speed

func die():
	target = null
	queue_free()

func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2.ZERO
	emit_signal("captured", area)


func _on_VisibilityNotifier2D_screen_exited():
	if !target:
		die()
