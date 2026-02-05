extends CharacterBody2D

const START_SPEED : int = 500
const ACCEL:int = 50

var win_size : Vector2
var speed:int
var dir:Vector2
var prevDir

var bounceSounds : Array[AudioStreamWAV] = [preload("res://Sounds/Pop1.wav"),preload("res://Sounds/Pop2.wav"),preload("res://Sounds/Pop3.wav"),preload("res://Sounds/Pop4.wav"),preload("res://Sounds/Pop5.wav"),preload("res://Sounds/Pop6.wav"),preload("res://Sounds/Pop7.wav"),preload("res://Sounds/Pop8.wav")]


@onready var gameManager = $".."
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	win_size = get_viewport_rect().size

func new_ball():
	position.x = win_size.x / 2
	position.y = randi_range(200,int(win_size.y-200))
	speed = START_SPEED
	dir.x = [1,-1].pick_random()
	dir.y = randf_range(-1,1)
	dir = dir.normalized()
	
func _physics_process(delta: float) -> void:
	if gameManager.paused:
		dir = Vector2.ZERO
		move_and_collide(dir)
		return
	
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		audio_stream_player.stream = bounceSounds[randi() % bounceSounds.size()]
		audio_stream_player.play()
		collider = collision.get_collider()
		if collider == $"../Player1" or collider == $"../Player2":
			speed += ACCEL
			dir = new_dir(collider)
		else:
			dir = dir.bounce(collision.get_normal())

func new_dir(collider):
	var newDir = Vector2.ZERO
	if dir.x > 0:
		newDir.x = -1
	else:
		newDir.x = 1
	
	var dist = position.y - collider.position.y
	newDir.y = (dist / (gameManager.p_height/2))
	return newDir.normalized()

func pause():
	prevDir = dir

func unpause():
	dir = prevDir

func _on_timer_timeout() -> void:
	new_ball()
