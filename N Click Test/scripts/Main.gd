extends Control

# Instantiate vars
var clicks: int
var average_cps: float
var cps: float
var best_cps: float
var time_past: float
var time_past_between_clicks: float
var time_last_click: float

# Initialize vars
func start():
	clicks = 0
	average_cps = 0
	cps = 0
	best_cps = cps
	time_past = 0
	time_past_between_clicks = INF
	time_last_click = 0

# Called once
func _ready():
	start()

# Called every frame
func _process(delta):
#----------------Calculate CPS--------------------------------------------------
	time_past += delta
	average_cps = round_to_dec(clicks / time_past, 1)
	cps = 1000 / time_past_between_clicks if time_past_between_clicks != INF else 0
	cps = round_to_dec(cps, 1)
	best_cps = cps if cps > best_cps else best_cps
	
#----------------Change texts in labels-----------------------------------------
	$Average.text = "Average CPS: %s" % [average_cps]
	$CPS.text = "CPS: %s" % [cps]
	$Best.text = "Best: %s" % [best_cps]

# Called when click on the button to calculate CPS
func _on_Button_pressed():
	clicks += 1
	if clicks > 2:
		time_past_between_clicks = OS.get_ticks_msec() - time_last_click
	time_last_click = OS.get_ticks_msec()

# Round floats by a decided decimal place
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

# Restart vars
func _on_Stop_pressed():
	start()
