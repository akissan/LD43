extends Button

var cur_state = "EMPTY"

var module_options = [ "UPGRADE", "REWORK", "SCRAP" ]
var empty_options = [ "CREATE_S", "CREATE_M", "CREATE_B" ]

var all_states = [ "MODULE" , "UPGRADE", "REWORK", "SCRAP", "EMPTY", "CREATE_S", "CREATE_M", "CREATE_B" ]
var icons = [ 'm', 'u', 'r', 's', 'e', 'cs', 'cm', 'cb' ]

func module_define(def):
	strings[0] = def

func find_tooltip():
	return strings[all_states.find(cur_state)]

var tooltip_rad = 40
var hover_rad = 60

var mp = Vector2()

signal me_pressed

func _process(delta):
	check_tooltip()
	check_hover()

func check_tooltip():
	mp = get_local_mouse_position()
	if mp.length() < tooltip_rad:
		get_parent().TOOLTIP = true
	else:
		get_parent().TOOLTIP = false
	
func check_hover():
	mp = get_local_mouse_position()
	if mp.length() < hover_rad:
		get_parent().HOVERED = true
	else:
		get_parent().HOVERED = false
#
#func on_area_entered(is_tooltip): 
#	get_parent().HOVERED = true
#	if is_tooltip: get_parent().TOOLTIP = true
#
#func on_area_left(is_tooltip):
#	if is_tooltip: get_parent().TOOLTIP = false
#	else: get_parent().HOVERED = false
#
var strings = [ 
	"Click to get some info about this module", 
	'Spend 1 ◰, 1 ▥ and 1 ◩ to upgrade this module',
	'Spend 1 resource to recycle this module into more powerful one',
	'Scrap this module to get back some resource',
	'This partition is empty',
	'Spend 1 ◰, 1 ⧈▥ and 1 ◩ to create weak module',
	'Spend half of ur resources to create average module',
	'Spend everything to create POWERFULL module'
	]

func icon_refresh():
	self.text = icons[all_states.find(cur_state)]

func _ready():
	icon_refresh()

func is_mod():
	if cur_state == "MODULE":
		return true
	return false

func is_empty():
	if cur_state == "EMPTY":
		return true
	return false

func is_option():
	if not ( self.is_mod() or self.is_empty() ):
		return true
	return false 

func set_state(state):
	cur_state = state
	icon_refresh()

func _on_butt_pressed():
	emit_signal("me_pressed")
