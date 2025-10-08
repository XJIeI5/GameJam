extends KinematicBody


var rot_x=0
var rot_y=0

const gravity=80

var vel=Vector3()


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	
	var dir=Vector3()
	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_down"):
		dir.z=+10
	if Input.is_action_pressed("ui_up"):
		dir.z=-10
	if Input.is_action_pressed("ui_left"):
		dir.x=-10
	if Input.is_action_pressed("ui_right"):
		dir.x=10
	
	if dir:
		dir=dir.rotated(Vector3(0,1,0), rotation.y)
		
	vel.x=dir.x
	vel.z=dir.z
	vel=move_and_slide(vel, Vector3(0,1,0))
	
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			vel.y=+15


	
func _input(event):
	if event is InputEventMouseMotion:
		rot_y -= event.relative.x*0.01
		rot_x -= event.relative.y * 0.01
		
		if rot_x < -PI/4: rot_x = -PI/4
		elif rot_x > PI/4: rot_x = PI/4

		transform.basis=Basis(Vector3(0,1,0),rot_y)
		$Camera.transform.basis=Basis(Vector3(1,0,0),rot_x)


