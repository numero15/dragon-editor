@tool
extends Node3D

#@onready var mesh_instance = $Skeleton3D/MeshBody
var mesh_instance
@onready var skel = $Skeleton3D
@export var body_height_curve_path : NodePath
@export var body_width_curve_path : NodePath
var body_height_curve_3d : Curve3D
var body_width_curve_3d : Curve3D
var unaltered_vertices : Array = []
var mdt
@export var gradient : GradientTexture1D
var radial_segments = 16
const dragon_body = preload("res://mesh_dragon.tscn")

func _ready():
	remesh()
	
func change_length(_l : int) :
	remesh(_l)
	
func remesh(_l : int =20):
	mesh_instance  = dragon_body.instantiate()
	mesh_instance.make(_l)
	for _c in skel.get_children():
		skel.remove_child(_c)
	skel.add_child(mesh_instance)
	unaltered_vertices = []
	
	mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh_instance.mesh, 0)
	for i in range(mdt.get_vertex_count()):
		unaltered_vertices.append(mdt.get_vertex(i))
		
		
	mesh_instance.get_active_material(0).set_shader_parameter("gradient", gradient)
	body_height_curve_3d = get_node(body_height_curve_path).curve
	body_width_curve_3d = get_node(body_width_curve_path).curve

	var _mesh_length : float = 0
	for i in range(mdt.get_vertex_count()):
		if _mesh_length < abs(mdt.get_vertex(i).z) : _mesh_length = abs(mdt.get_vertex(i).z)

	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
#		position du vertex dans le mesh (entre 0 et 1) * longueur de la courbe 
		var sample_h = body_height_curve_3d.sample_baked(abs(vert.z)/_mesh_length * -body_height_curve_3d.get_point_position(body_height_curve_3d.point_count-1).z)
		var sample_w = body_width_curve_3d.sample_baked(abs(vert.z)/_mesh_length * -body_width_curve_3d.get_point_position(body_width_curve_3d.point_count-1).z)
		vert.y = unaltered_vertices[i].y*-sample_h.y # Scales the vertex by doubling size.
		vert.x =  unaltered_vertices[i].x*-sample_w.x # Scales the vertex by doubling size.
		vert.y = vert.y + sample_h.y*.6 #décaller vers le bas pour faire le ventre
		mdt.set_vertex(i, vert)
#		calculer la normale
#cette méthode ne fonctionne pas pour les permiers et derniers points de chaque segment
		var prev_vert : Vector2
		if i == 0 :
			prev_vert.y = unaltered_vertices[mdt.get_vertex_count()-1].y*-sample_h.y # Scales the vertex by doubling size.
			prev_vert.x =  unaltered_vertices[mdt.get_vertex_count()-1].x*-sample_w.x
		else :
			prev_vert.y = unaltered_vertices[i-1].y*-sample_h.y # Scales the vertex by doubling size.
			prev_vert.x =  unaltered_vertices[i-1].x*-sample_w.x
		var next_vert : Vector2
		if i == mdt.get_vertex_count()-1 :
			next_vert.y = unaltered_vertices[0].y*-sample_h.y # Scales the vertex by doubling size.
			next_vert.x =  unaltered_vertices[0].x*-sample_w.x
		else :
			next_vert.y = unaltered_vertices[i+1].y*-sample_h.y # Scales the vertex by doubling size.
			next_vert.x =  unaltered_vertices[i+1].x*-sample_w.x#	
		var tangent : Vector2 = next_vert - prev_vert
		var normal : Vector2 = tangent.rotated(-PI/2).normalized()
		mdt.set_vertex_normal(i,Vector3(normal.x, normal.y,.0))
#		print(i/radial_segments)
#		mdt.set_vertex_bones(i, PackedInt32Array([1,1,1,1]) )
		
	mesh_instance.mesh.clear_surfaces() # Deletes the first surface of the mesh.
	mdt.commit_to_surface(mesh_instance.mesh)
	
	skel.make(_l)
