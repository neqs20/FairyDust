extends MeshInstance

# Creates a Shape from MeshInctance's `mesh` variable and saves it in res://
# Then this .tres file can be dragged to CollisionShape in the editor (Inspector Tab) 

func _ready():
	ResourceSaver.save("res://terrain-shape.tres", mesh.create_convex_shape())
