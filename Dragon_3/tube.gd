extends Node3D

@onready var mesh_instance = $Armature/Skeleton3D/Cylinder
@export var body_curve_path : NodePath
var body_curve_3d : Curve3D
var unaltered_vertices : Array = []
var mdt 

func _ready():	
	mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh_instance.mesh, 0)
	for i in range(mdt.get_vertex_count()):
		unaltered_vertices.append(mdt.get_vertex(i))
	
func remesh():
#	var mdt = MeshDataTool.new()
#	mdt.create_from_surface(mesh_instance.mesh, 0)
	body_curve_3d = get_node(body_curve_path).curve

	var _mesh_length : float = 0
	for i in range(mdt.get_vertex_count()):
		if _mesh_length < abs(mdt.get_vertex(i).z) : _mesh_length = abs(mdt.get_vertex(i).z)

	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
#		position du vertex dans le mesh (entre 0 et 1) * longueur de la courbe 
		var sample = body_curve_3d.sample_baked(abs(vert.z)/_mesh_length * -body_curve_3d.get_point_position(body_curve_3d.point_count-1).z)
		vert.y = unaltered_vertices[i].y*-sample.y # Scales the vertex by doubling size.
		vert.x =  unaltered_vertices[i].x*-sample.y # Scales the vertex by doubling size.
		mdt.set_vertex(i, vert)
		
	mesh_instance.mesh.clear_surfaces() # Deletes the first surface of the mesh.
	mdt.commit_to_surface(mesh_instance.mesh)
	


