extends CharacterBody2D

@onready var characterSprite = $AnimatedSprite2D

const MAX_SPEED = 100.0
const ACCELERATION = 50.0
const JUMP_VELOCITY = -250.0
const GROUND_FRICTION = 0.6
const AIR_FRICTION = 0.8
const BASE_COYOTE = 7
const TERMINAL_VELOCITY = 300
var coyote

const BASE_WALL_COYOTE = 5
var wall_coyote
const WALL_BUFFER = 5
var wall_buffer

const JUMP_BUFFER = 3  
const JUMP_TIME = 15
var jumpcounter
@onready var wall_check_r = $wallCheckR
@onready var wall_check_l = $WallCheckL
const WALLJUMP_VECTOR = Vector2(200, -150)
var can_walljump
var jump_buffer
var isOnWallR
var isOnWallL
var isOnWall
var LastWallL



# Get the gravity from the project settings to be synced with RigidBody nodes.
var BASE_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = BASE_GRAVITY


func _init():
	coyote = BASE_COYOTE
	wall_coyote = BASE_WALL_COYOTE
	wall_buffer = WALL_BUFFER
	jump_buffer = 0
	jumpcounter = JUMP_TIME

func _process(delta):
	if abs(velocity.x) <= 0.01 and is_on_floor(): characterSprite.play("idle")
	elif is_on_floor() and abs(velocity.x) > 0.01: characterSprite.play("walk")
	elif !is_on_floor() and !is_on_wall() and velocity.y > 0: characterSprite.play("fall")
		
	if isOnWallL or isOnWallR: isOnWall = true
	else: isOnWall = false


func _physics_process(delta):
	
	if not is_on_floor():
		if velocity.y < TERMINAL_VELOCITY: 
			velocity.y += gravity * delta
		velocity.x *= AIR_FRICTION
		coyote -= 1
		if isOnWall: wall_coyote = BASE_WALL_COYOTE
	if is_on_floor():
		coyote = BASE_COYOTE
		jumpcounter = JUMP_TIME
		velocity.x *= GROUND_FRICTION
	
	# Jump
	if Input.is_action_just_pressed("jump"): # Handle yump buffering
		jump_buffer = JUMP_BUFFER
		wall_buffer = WALL_BUFFER
		
	else: jump_buffer -= 1
	if jump_buffer > 0 and coyote > 0:
		velocity.y = JUMP_VELOCITY
		coyote = 0
	if velocity.y < 0 and !Input.is_action_pressed("jump"): # slow upward momentum faster when not holding yump
		velocity.y = max(velocity.y, JUMP_VELOCITY/3)
	
	# Wall Jump
	wall_buffer -= 1
	wall_coyote -= 1
	if !is_on_floor() and isOnWall:
		if velocity.y > 0:
			if Input.is_action_pressed("right"):
				velocity.y = 10
			if Input.is_action_pressed("left"):
				velocity.y = 10
		# walljump
	if is_on_floor(): wall_buffer = 0
	if wall_buffer > 0 and wall_coyote > 0:
		if LastWallL: velocity = WALLJUMP_VECTOR * Vector2(1, 1)
		if !LastWallL: velocity = WALLJUMP_VECTOR * Vector2(-1, 1)
		
		
# move and flip sprite
	if Input.is_action_pressed("left"): 
		if abs(velocity.x) <= MAX_SPEED:
			velocity.x -= ACCELERATION
			characterSprite.flip_h = false
	elif Input.is_action_pressed("right"): 
			if abs(velocity.x) <= MAX_SPEED:
				velocity.x += ACCELERATION
				characterSprite.flip_h = true
	
	move_and_slide()



func _on_wall_check_r_body_entered(body):
	isOnWallR = true
	LastWallL = false
	

func _on_wall_check_r_body_exited(body):
	isOnWallR = false
	if !is_on_floor(): wall_coyote = BASE_WALL_COYOTE

func _on_wall_check_l_body_entered(body):
	isOnWallL = true
	LastWallL = true

func _on_wall_check_l_body_exited(body):
	isOnWallL = false
	if !is_on_floor(): wall_coyote = BASE_WALL_COYOTE
