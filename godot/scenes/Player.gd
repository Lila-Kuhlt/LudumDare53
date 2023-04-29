extends CharacterBody2D

const Package = preload("res://scenes/Package.tscn")
const Bullet = preload("res://scenes/Bullet.tscn")

const SPEED: float = 300.0
const MAX_QUEUE_SIZE: int = 5
const PACKAGE_SPAWN_AREA_ATLAS_COORDS := Vector2i(2, 2)

var rng := RandomNumberGenerator.new()

var package_queue := []
var package_spawn_areas := []

func populate_package_spawn_areas():
	var ground: TileMap = get_parent().get_node('GroundTileMap')
	var areas := ground.get_used_cells_by_id(0, 1, PACKAGE_SPAWN_AREA_ATLAS_COORDS)
	for area in areas:
		package_spawn_areas.append(ground.map_to_local(area))

func _ready():
	populate_package_spawn_areas()

func build_package():
	var package: Node2D = Package.instantiate()
	var idx := rng.randi_range(0, len(package_spawn_areas))
	package.position = package_spawn_areas[idx]
	return package

## Tries to add a package to the queue and returns wether the package could be added.
func add_package() -> bool:
	if package_queue.size() < MAX_QUEUE_SIZE:
		var package = build_package()
		get_parent().add_child(package)
		package.start_timer(2.0, _on_package_timeout.bind(package))
		package_queue.append(package)
		print("added package")
		return true
	else:
		return false

## This function is called when a package timer reaches 0.
func _on_package_timeout(package):
	print("dropped package")
	package_queue.erase(package)
	package.queue_free()

func _physics_process(_delta):
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()

	# wrap position
	var screen_size := get_viewport_rect().size
	position.x = fposmod(position.x, screen_size.x)
	position.y = fposmod(position.y, screen_size.y)

var tmp_t := 0.0

func _process(delta: float) -> void:
	tmp_t += delta
	if Input.is_action_just_pressed("shoot"):
		var bullet = Bullet.instantiate()
		bullet.position = position
		bullet.vel = Vector2(sin(tmp_t), cos(tmp_t)) * 100.0
		get_parent().add_child(bullet)
