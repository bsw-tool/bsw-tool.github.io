GDPC                                                                                       	   P   res://.godot/exported/133200997/export-dbe59258b6e7c5860bca2a5bbd0223c3-main.scn0      N      qv;��\$4�F!I߇J�    ,   res://.godot/global_script_class_cache.cfg  �.             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�             ：Qt�E�cO���       res://.godot/uid_cache.bin  �2      =       s�./DU�2m��M��       res://icon.svg   /      �      k����X3Y���f       res://icon.svg.import   �-      �       �avHɁl �ke����       res://project.binary 3      �      ��%c2
< �E�G̹       res://src/main.tscn.remap   p.      a       6�-�	��6��s�M�       res://src/main/main.gd          0      �$�	A��'9�F(�            extends Control


@export var keyboard : HFlowContainer
@export var timer : Label
@export var task : Label
@export var answer : Label
@export var label_log : Label
@export var option : OptionButton

var _start_timer : float = 0
var _prev_timer : float = 0
var _task_t : String
var _is_start : bool = false
var _logs : Array[String]

var _answer : int
var _correct : int 


func _ready():
	keyboard.add_child( button( "START", start))
	keyboard.add_child( button( "0" ) )
	keyboard.add_child( button( "STOP", stop))
	keyboard.add_child( button( "1" ) )
	keyboard.add_child( button( "2" ) )
	keyboard.add_child( button( "3" ) )
	keyboard.add_child( button( "4" ) )
	keyboard.add_child( button( "5" ) )
	keyboard.add_child( button( "6" ) )
	keyboard.add_child( button( "7" ) )
	keyboard.add_child( button( "8" ) )
	keyboard.add_child( button( "9" ) )
	keyboard.add_child( button( "NEW" ) )


func _process(_delta):
	var t = func(t_pass : float) -> String:
		var minutes : int = floor(t_pass / 60)
		var second : int = int(t_pass) - minutes * 60
		var milisecond : int = (int(t_pass * 100) - minutes * 6000) % 60
		return str("0" if minutes < 10 else "" , minutes, " : ",
				"0" if second < 10 else "" , second, " : " ,
				"0" if milisecond < 10 else "" , milisecond)
	
	if _is_start and _start_timer != 0:
		timer.text = t.call(Time.get_unix_time_from_system() - _start_timer)
		_task_t = t.call(Time.get_unix_time_from_system() - _prev_timer)
		if (Time.get_unix_time_from_system() - _start_timer) > 60:
			stop()


func _unhandled_input(event):
	var submit_answer = func (text : String):
		answer.text += text
		if answer.text.length() == str(_answer).length():
			submit()
	
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE and not _is_start:
			start()
		
		elif event.keycode == KEY_ESCAPE and _is_start:
			stop()
		
		elif event.keycode == KEY_0 and _is_start:
			submit_answer.call("0")
			
		elif event.keycode == KEY_1 and _is_start:
			submit_answer.call("1")
			
		elif event.keycode == KEY_2 and _is_start:
			submit_answer.call("2")
			
		elif event.keycode == KEY_3 and _is_start:
			submit_answer.call("3")
			
		elif event.keycode == KEY_4 and _is_start:
			submit_answer.call("4")
			
		elif event.keycode == KEY_5 and _is_start:
			submit_answer.call("5")
			
		elif event.keycode == KEY_6 and _is_start:
			submit_answer.call("6")
			
		elif event.keycode == KEY_7 and _is_start:
			submit_answer.call("7")
			
		elif event.keycode == KEY_8 and _is_start:
			submit_answer.call("8")
			
		elif event.keycode == KEY_9 and _is_start:
			submit_answer.call("9")


func start():
	if _is_start:
		return
	_correct = 0
	_logs.clear()
	_start_timer = Time.get_unix_time_from_system()
	_is_start = true
	new_task() 


func stop():
	if not _is_start:
		return
	_is_start = false
	label_log.text += str("\nTRUE = ", _correct, "/", _logs.size()) 


func new_task():
	_prev_timer = Time.get_unix_time_from_system()
	if randf() < 0.5:
		if option.selected == 0:
			addition(99)
		elif option.selected == 1 :
			multiplication(99)
		elif option.selected == 2:
			addition(9)
		elif option.selected == 3 :
			multiplication(9)
	else:
		if option.selected == 0:
			substraction(99)
		elif option.selected == 1:
			division(99)
		elif option.selected == 2:
			substraction(9)
		elif option.selected == 3:
			division(9)


func addition(maxv : int):
	var a : int = randi_range(0, maxv)
	var b : int = randi_range(1, 9)
	task.text = str(a, " + ", b, " = ")
	_answer = a + b


func substraction(maxv : int):
	var a : int = randi_range(9, maxv)
	var b : int = randi_range(1, 9)
	task.text = str(a, " - ", b, " = ")
	_answer = a - b


func multiplication(maxv : int):
	var a : int = randi_range(0, maxv)
	var b : int = randi_range(1, 9)
	task.text = str(a, " * ", b, " = ")
	_answer = a * b


func division(maxv : int):
	var a : int = randi_range(9, maxv)
	var b : int = randi_range(1, 9)
	task.text = str(a, " : ", b, " = ")
	_answer = int(a / float(b))


func button(text : String, callback : Callable = Callable()) -> Button:
	var btn := Button.new()
	btn.add_theme_font_size_override("font_size", 24)
	btn.focus_mode = Control.FOCUS_NONE
	btn.text = text
	btn.custom_minimum_size = Vector2(size.x / 4, size.x / 8)
	if callback.is_valid():
		btn.pressed.connect(callback)
	elif text == "NEW":
		btn.pressed.connect(submit)
	else:
		btn.pressed.connect(func():
			if not _is_start:
				return
			answer.text += text
			if answer.text.length() == str(_answer).length():
				submit()
			)
	return btn


func submit():
	if not _is_start:
		return
	if answer.text == str(_answer):
		_correct += 1
	_logs.push_back(str(_logs.size(),".) ", task.text , answer.text, " is ",
			str(answer.text == str(_answer)).to_upper(),
			" -> [", _answer, "] {", timer.text ," | ", _task_t , "}"))
	label_log.text = ""
	for txt in _logs:
		label_log.text += "\n" + txt
	new_task()
	answer.text = ""
RSRC                    PackedScene            ��������                                                  VBC 	   Keyboard    MarginContainer    View    Timer    HBoxContainer    Task    Answer    ScrollContainer    Log    OptionButton    resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script 	   _bundled       Script    res://src/main/main.gd ��������      local://LabelSettings_xlp20 �         local://LabelSettings_37852 �         local://LabelSettings_2gvio �         local://PackedScene_r7vvh           LabelSettings                      LabelSettings                      LabelSettings                      PackedScene          	         names "   7      Main    layout_mode    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    script 	   keyboard    timer    task    answer 
   label_log    option    Control    VBC    VBoxContainer    MarginContainer    size_flags_vertical %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    View    Timer    offset_right    offset_bottom    Label    OptionButton    anchor_top    offset_top    focus_mode    item_count 	   selected    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    popup/item_3/text    popup/item_3/id    HBoxContainer 
   alignment    Task    label_settings    horizontal_alignment    vertical_alignment    Answer    ScrollContainer    anchor_left    offset_left    Log 	   Keyboard    HFlowContainer    	   variants    !                    �?                                                                                                               	                   
                            B     �A            ?     x�     pB     xA      +-       *:       s+-       s*:            �                              ��     T�               node_count             nodes     �   ��������       ����                                                @   	  @   
  @     @     @	     @
                     ����                                                        ����                                                         ����                                 ����                                      ����                                                                !      "      #      $      %      &      '      (      )                  *   *   ����	                                                   +                    ,   ����         -      .      /                    0   ����         -                 1   1   ����	               2                  3                            	          4   ����         -                  6   5   ����                +                conn_count              conns               node_paths              editable_instances              version             RSRC  GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://diha8and7s27w"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                [remap]

path="res://.godot/exported/133200997/export-dbe59258b6e7c5860bca2a5bbd0223c3-main.scn"
               list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              �v�_3N�<   res://src/main.tscnrRT[>Yk   res://icon.svg   ECFG      application/config/name      
   Drill Tool     application/run/main_scene         res://src/main.tscn    application/config/features   "         4.2    Mobile     application/config/icon         res://icon.svg  "   display/window/size/viewport_width        #   display/window/size/viewport_height      �  #   display/window/handheld/orientation         #   rendering/renderer/rendering_method         mobile                