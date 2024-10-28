extends Node2D

var credits:Array[Array] = [
	['Main Fuckos', 'me me me i worked on this hi helelo!!!'],
	['Unholywanderer04', 'unholy', 'Wahoo programming', \
		Color.REBECCA_PURPLE, func(): get_tree().quit()],
	['TheConcealedCow', 'cow', 'Main artist fr fr trust me on god', \
		Color(0.88, 0.88, 0.88), func(): 
			$cow.visible = true
			$cow.play()],
	['Ashley', 'puta', 'Other main artist fr fr fr', \
		Color.CYAN, func(): pass],
		
	['People I Stole From', 'i love stealing code'],
	['Shadow Mario', 'shadow', 'Stole plenty of psych code and sprites', \
		Color.DIM_GRAY, func(): OS.shell_open('https://github.com/ShadowMario')],
		
	['Zyflx', 'zyflx', 'Stole note handling and other shit', \
		Color(0.24, 0.78, 0.29), func(): OS.shell_open('https://www.youtube.com/@Zyflx')],
		
	['Crowplexus', 'crow', 'Stole funny godot code and ideas', \
		Color.DARK_RED, func(): OS.shell_open('https://github.com/crowplexus')],
		
	['Maru', 'maru',  'Stole spritesheets and also code i think', \
		Color(0.21, 0.54, 0.76), func(): OS.shell_open('https://www.youtube.com/watch?v=BLqqWorGGz0')],
		
	['Daniel', 'daniel', 'who the FUCK', \
		Color(0.22, 0.21, 0.34), func(): Prefs.daniel = true],
		
	#['Give me free art', 'cool art people'],
	
	#['Ashley', 'puta', 'Made Epic and Miss Judgements', \
	#	Color.CYAN, func(): pass],
	#['TheConcealedCow', 'empty', 'Made funny event strum and hurt note', \
	#	Color(0.88, 0.88, 0.88), func(): 
	#		$cow.visible = true
	#		$cow.play()],
	
	['Funkin\' Crew'],
	['NinjaMuffin99', 'empty', 'You know him'],
	['Phantom Arcade', 'empty', 'That art guy with the animation'],
	['Kawai Sprite', 'empty', 'Music indiviudial i think'],
	['EvilSk8r', 'empty', 'holy arts above'],
	['EliteMasterEric', 'empty', 'You know him also'],
]

var quotes:Dictionary = {
	'unholywanderer04': ['wee wee whaha yahoo yippee yay!!'],
	'shadow mario': ['WikiHow: How to handle fame'],
	'zyflx': ['i still dont know what i want my quote to be, i have no ideas'],
	'crowplexus': ['Venha pequena fruta, venha comigo', 'Press [ Crow ] to crow', 'sans is at my door'],
	'maru': ['oogie boogie please call my phone number'],
	'betty': ['daniel.........:heart;'],
	'ashley': ['play beatblock 🎉🎉'],
	'theconcealedcow': ['who are you why are you in my house']
}

#var credits = [
#	['Test',      'empty',     'He did',                Color.ROSY_BROWN],
#	['Daniel',    'daniel',    'heieh',                 Color(0.22, 0.21, 0.34)],
#	['Doggo',     'doggo',     'guy',   Color(0.51, 0.70, 0.99)],
#	['Moonlight', 'moonlight', 'ga gooberer :flushed:', Color(0.59, 0.31, 0.98)]
#]

var tests = []
var cred_group:Array = []
var cred_desc:Alphabet
var cur_select:int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Discord.change_presence('Maining some Menus', 'Checkin Credits')
	$cow.animation_finished.connect(func(): $cow.visible = false)
	for i in credits:
		var tes = Credit.new(i, i.size() == 2)
		tes.is_menu = true
		tes.screen_offset = 90
		tes.spacing = Vector2(100, 200)
		
		tes.scroll_dir = Alphabet.Scroll.RIGHT_TO_LEFT
		add_child(tes)
		move_child(tes, 4)
		tes.target_y = credits.find(i)
		cred_group.append(tes)
		
		if !tes.is_header:
			var icon = Icon.new()
			icon.change_icon(tes.icon, false, true)
			tes.add_child(icon)
			icon.position = Vector2(tes.width / 2.0, -(icon.texture.get_height() / 2.0))
			#icon.follow_spr = tes
	
	cred_desc = Alphabet.new('Empty Empty', false)
	cred_desc.scale = Vector2(0.5, 0.5)
	cred_desc.color = Color.WHITE
	cred_desc.position = Vector2(600, 650)
	add_child(cred_desc)
	update_selection()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event:InputEvent) -> void:
	if Input.is_action_just_pressed("accept"):
		cred_group[cur_select].on_press.call()
	if Input.is_action_just_pressed("back"):
		Game.switch_scene('menus/main_menu')
		
	if Input.is_action_just_pressed('menu_up'): update_selection(-1)
	if Input.is_action_just_pressed('menu_down'): update_selection(1)

var col_tween
func update_selection(amount:int = 0) -> void:
	if amount != 0: Audio.play_sound('scrollMenu')
	cur_select = wrapi(cur_select + amount, 0, credits.size())
	var cur_cred:Credit = cred_group[cur_select]
	
	$CreditImage.visible = ResourceLoader.exists('res://assets/images/credits/'+ cur_cred.icon +'_img')
	if $CreditImage.visible:
		$CreditImage.texture = load('res://assets/images/credits/'+ cur_cred.icon +'_img')
		
	cred_desc.text = cur_cred.description
	cred_desc.color = Color.WHITE
	
	if quotes.has(cur_cred.creditee.to_lower()):
		$Quote.text = '"'+ quotes[cur_cred.creditee.to_lower()].pick_random() +'"'
	else:
		$Quote.text = '"Thank You!"'

	
	if col_tween: col_tween.kill()
	col_tween = create_tween()
	col_tween.tween_property($BG, 'modulate', cur_cred.bg_color, 0.5)
	
	for i in credits.size():
		var item = cred_group[i]
		item.target_y = i - cur_select
		item.modulate.a = (1.0 if i == cur_select else 1.0 - (abs(item.target_y) / 4.0))

class Credit extends Alphabet:
	var creditee:String = 'nope'
	var icon:String = 'empty'
	var description:String = ''
	var bg_color:Color = Color.WHITE
	var on_press:Callable = func(): pass
	
	var is_header:bool = false
	
	func _init(cred_info:Array = ['nope'], header:bool = false):
		creditee = cred_info[0]
		is_header = header
		var da_size:int = cred_info.size()
		if header:
			if da_size > 1: description = cred_info[1]
		else:
			# fuck me
			if da_size > 1: icon = cred_info[1]
			if da_size > 2: description = cred_info[2]
			if da_size > 3: bg_color = cred_info[3]
			if da_size > 4: on_press = cred_info[4]
		
		super(creditee)
