#https://docs.godotengine.org/en/stable/classes/class_inputeventmidi.html
extends Control

@onready var octaves = [
	$Piano/Octave1,
	$Piano/Octave2,
	$Piano/Octave3,
	$Piano/Octave4,
	$Piano/Octave5
]

@export var left_color: Color
@export var right_color: Color
@export var right_trackname: String

@onready var full_keys = []
@onready var mp1:MidiPlayer = $"../MidiPlayer"
@onready var mp2:MidiPlayer = $"../MidiPlayer2"

const _piano_pos = 812
var drop_started = false

func _ready() -> void:
	for k in octaves:
		for p in k.piano_keys:
			full_keys.push_back(p)
	await get_tree().create_timer(2).timeout.connect(mp1.play)
	#full_keys.push_back()
	#_play_midi(60, 10)
	#var tts = 60.0/150.0
	#for e in mp2.track_status.events.slice(0,100):
	#	if e.event is SMF.MIDIEventNoteOn:
	#		print_debug("Time %s note %s on" % [e.time * mp2.timebase_to_seconds, e.event.note])
	#_play_midi(61, 20)

func _create_drop(key:int, is_right:bool) -> void:
	var key_class = _get_key(key)
	if key_class == null:
		return
	var color = left_color
	if is_right: #Everything is bank 0, what
		color = right_color
	key_class._play(is_right)
	
func _end_drop(key:int, is_right:bool) -> void:
	var key_class = _get_key(key)
	if key_class == null:
		return
	key_class._stop(is_right)
	if !drop_started:
		drop_started = true
		var delay:float = _piano_pos/DropClass._speed
		#idk magic delay?
		get_tree().create_timer(delay - 0.25).timeout.connect(_play_music)
		
func _play_music() -> void:
	mp2.play(0)
	return

func _get_key(key:int) -> KeyClass:
	key-=36
	if key < 0 || key > 59:
		return null
	return full_keys[key]

func _on_midi_player_midi_event(channel: MidiPlayer.GodotMIDIPlayerChannelStatus, event: SMF.MIDIEvent) -> void:
	if event is SMF.MIDIEventNoteOn:
		_create_drop(event.note, channel.track_name != right_trackname)
	if event is SMF.MIDIEventNoteOff:
		_end_drop(event.note, channel.track_name != right_trackname)
