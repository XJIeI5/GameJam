extends KinematicBody


var onCanInteract := false
signal CanInteractStart
signal CanInteractStop

signal DialogStart(starter)
signal DialogStop(ender)

export var Speed := 8.0
export var GravityFactor: float = 2.0
export var JumpVelocity := 4.5
var Gravity: Vector3 = Vector3(0, -9.8*GravityFactor, 0)

var velocity: Vector3 = Vector3()

const SENSIVITY := 0.005

enum State {
	Move,
	Interact,
}

var state = State.Move

onready var neck = $Neck
onready var camera = $Neck/Camera
onready var raycast = $Neck/Camera/RayCast
onready var interactLabel = $Neck/Camera/InteractLabel/Label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	connect("DialogStart", self, "onDialogStart")
	connect("DialogStop", self, "onDialogStop")

func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action("ui_cancel"):
		get_tree().quit()
	
	if state == State.Move:
		handleRotation(event)

func _unhandled_input(event):
	if state != State.Move:
		return
	handleInteract()
	get_viewport().set_input_as_handled()

func _physics_process(delta: float) -> void:
	fall(delta)
	if state == State.Move:
		handleMovement()
	move_and_slide(velocity, Vector3.UP)

func fall(delta: float):
	if not is_on_floor():
		velocity += Gravity * delta
	
func handleRotation(event: InputEvent):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSIVITY)
		camera.rotate_x(-event.relative.y * SENSIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg2rad(-60), deg2rad(60))

func handleMovement():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JumpVelocity
	
	var input_dir := Input.get_vector("MoveLeft", "MoveRight", "MoveForward", "MoveBackward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * Speed
		velocity.z = direction.z * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		velocity.z = move_toward(velocity.z, 0, Speed)

func handleInteract():
	if not raycast.is_colliding():
		if onCanInteract:
			emit_signal("CanInteractStop")
		return
	if raycast.get_collider().collision_layer & 0b10:
		if onCanInteract:
			emit_signal("CanInteractStop")
		return
	emit_signal("CanInteractStart")
	onCanInteract = true
	
	if not Input.is_action_just_pressed("Interact"):
		return
	
	raycast.get_collider().InteractWith(self)
	emit_signal("CanInteractStop")
	
func onDialogStart(starter: Object):
	disable()

func onDialogStop(ender: Object):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	letEmMove()

func disable():
	print("DISABLE")
	velocity = Vector3()
	state = State.Interact

func letEmMove():
	print("LET EM MOVE")
	state = State.Move
