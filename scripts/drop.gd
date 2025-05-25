extends NinePatchRect
class_name DropClass

var _active = false
var _stretching = false
var _is_right = false
const _speed = 400
var _margin = 0

@export var drop_color_l: Color
@export var drop_color_r: Color

func _ready() -> void:
	_margin = patch_margin_top + patch_margin_bottom + 2

func _start(is_right:bool) -> void:
	modulate = drop_color_r if is_right else drop_color_l
	visible = true
	position.y=-_margin-22
	_is_right = is_right
	_stretching = true

func _stop() -> void:
	_stretching = false
	_active = true
	position.y=0
	size.y = max(size.y-_margin, _margin)

#!!! VISUALISATION ONLY !!!
func _process(delta:float) -> void:
	if _stretching:
		size.y += delta*_speed
		position.y=-_margin
	elif _active:
		position.y+=delta*_speed
	if position.y + size.y > 812:
		get_parent()._on_play(_is_right)
		#key.gd _on_play
	if position.y > 812 :
		get_parent()._on_stop()
		queue_free()
