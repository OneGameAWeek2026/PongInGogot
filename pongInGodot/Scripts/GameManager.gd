extends Node2D

const PADDLE_SPEED = 500

var score := [0,0]

var mode = 1

var win_height:int
var p_height : int

@onready var Player1 = $Player1
@onready var p1Score = $HUD/Player1Score
@onready var Player2 = $Player2
@onready var p2Score = $HUD/Player2Score
@onready var Ball = $Ball
@onready var BallTimer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var scoreSound = preload("res://Sounds/Score.wav")

var paused = false

var ballPos: Vector2
var dist : int
var moveby: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = int(get_viewport_rect().size.y)
	p_height = $Player1/ColorRect.get_size().y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if paused:
		return
	
	if Input.is_action_pressed("P1Up"):
		Player1.position.y -= PADDLE_SPEED * delta
	elif Input.is_action_pressed("P1Down"):
		Player1.position.y += PADDLE_SPEED * delta
	
	Player1.position.y = clamp(Player1.position.y, float(p_height)/2, float(win_height) - (float(p_height)/2))
	
	if mode == 1:
		if Input.is_action_pressed("P2Up"):
			Player2.position.y -= PADDLE_SPEED * delta
		elif Input.is_action_pressed("P2Down"):
			Player2.position.y += PADDLE_SPEED * delta
		
	else:
		ballPos = Ball.position
		dist = Player2.position.y - ballPos.y
		if abs(dist) > PADDLE_SPEED * delta:
			moveby = PADDLE_SPEED * delta * (dist / abs(dist))
		else:
			moveby = dist
		Player2.position.y -= moveby

	Player2.position.y = clamp(Player2.position.y, float(p_height)/2, float(win_height) - (float(p_height)/2))

func pause():
	Ball.pause()
	paused = true

func unpause():
	paused = false
	Ball.unpause()

func _on_score_left_body_entered(_body: Node2D) -> void:
	audio_stream_player.stream = scoreSound
	audio_stream_player.play()
	score[1] += 1
	p2Score.text = str(score[1])
	BallTimer.start()

func _on_score_right_body_entered(_body: Node2D) -> void:
	audio_stream_player.stream = scoreSound
	audio_stream_player.play()
	score[0] += 1
	p1Score.text = str(score[0])
	BallTimer.start()
