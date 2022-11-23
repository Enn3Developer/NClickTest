extends Control

export var cps_text = "CPS: %s"
export var best_text = "Best: %s"
export var average_text = "Average CPS: %s"
export var time_text = "Time past: %s"

# Instantiate vars
var clicks: int
var average_cps: float
var cps: float
var best_cps: float
var time_past: float
var time_past_between_clicks: float
var time_last_click: float
var restarted = false
var running = false
var time_timer = 0

# Initialize vars
func start():
	clicks = 0
	average_cps = 0
	cps = 0
	best_cps = cps
	time_past = 0
	time_past_between_clicks = INF
	time_last_click = 0
	time_timer = $SpinBox.value
	$Average.visible = false
	$Best.visible = false
	$Time.visible = false
	restarted = false

# Called once
func _ready():
	start()

# Called every frame
func _process(delta):
	if time_timer and running:
		$ClickTimer.start(time_timer)
		time_timer = 0
#	Calculate CPS
	if running:
		time_past += delta if clicks > 0 else 0
		average_cps = round_to_dec(clicks / time_past, 1) if time_past else 0
		cps = round_to_dec(clicks / time_past, 2) if time_past > 0.5 else 0
		best_cps = cps if cps > best_cps else best_cps
	
#	Change texts in labels
	$CPS.text = cps_text % [cps]
	if not running:
		$Average.text = average_text % [average_cps]
		$Best.text = best_text % [best_cps]
		$Time.text = time_text % [round_to_dec(time_past, 1)]

func stop_clicking():
	$Average.visible = true
	$Best.visible = true
	$Time.visible = true
	$StopTimer.start(2)
	running = false

# Called when click on the button to calculate CPS
func _on_Button_pressed():
	if restarted:
		start()
	if not running:
		running = true
	var new_time_past = 0
	clicks += 1
	if clicks > 2:
		new_time_past = OS.get_ticks_msec()
		time_past_between_clicks = new_time_past - time_last_click
	time_last_click = new_time_past

# Round floats by a decided decimal place
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

# Restart vars
func _on_Stop_pressed():
	stop_clicking()

func _on_Timer_timeout():
	stop_clicking()

func _on_SpinBox_value_changed(value):
	time_timer = value


func _on_StopTimer_timeout():
	restarted = true
