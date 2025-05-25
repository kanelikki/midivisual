extends Control
class_name KeyClass

@onready var initial_modulate: Color = $Piano/Sprite2D.modulate
@export var press_color_l: Color
@export var press_color_r: Color
@export var press_spotlight_l: Color
@export var press_spotlight_r: Color
var _drop_left: DropClass = null
var _drop_right: DropClass = null

signal on_piano_hit()

func _play(is_right:bool) -> DropClass:
	var drop = _get_drop(is_right)
	if drop!=null:
		return drop
	#node creation
	drop = $Drop.duplicate() as NinePatchRect
	add_child(drop)
	drop._start(is_right)
	_set_drop(is_right, drop)
	return drop

func _stop(is_right:bool) -> void:
	var drop = _get_drop(is_right)
	if drop == null:
		return
	_set_drop(is_right, null)
	drop._stop()
	
func _get_drop(is_right:bool) -> DropClass:
	if is_right:
		return _drop_right
	else:
		return _drop_left

func _set_drop(is_right:bool, value:DropClass) -> void:
	if is_right:
		_drop_right = value
	else:
		_drop_left = value

func _on_play(is_right:bool) -> void:
	$Piano/Sprite2D.modulate = press_color_r if is_right else press_color_l
	$Piano/ColorRect.modulate = press_spotlight_r if is_right else press_spotlight_l
	$Piano/GPUParticles2D.emitting = true
	$Piano/ColorRect.visible = true
	on_piano_hit.emit()

func _on_stop() -> void:
	$Piano/Sprite2D.modulate = initial_modulate
	$Piano/GPUParticles2D.emitting = false
	$Piano/ColorRect.visible = false
