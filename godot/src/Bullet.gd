extends Area2D

const Globals = preload("res://src/Globals.gd")

var vel: Vector2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += vel * delta
	if (position.x > Globals.LOWER_RIGHT.x or position.y > Globals.LOWER_RIGHT.y
			or position.x < Globals.UPPER_LEFT.x or position.y < Globals.UPPER_LEFT.y):
		print('a')
		queue_free()
		return
	if has_overlapping_bodies():
		print('b')
		queue_free()
		return
