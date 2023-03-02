extends MeshInstance3D

var rings = 32
var radial_segments = 32
@export var length : int = 10 : set = set_length
@export var width_curve : Curve
var radius = 1

var mdt: MeshDataTool
var verts := PackedVector3Array()
var uvs := PackedVector2Array()
var normals := PackedVector3Array()
var indices := PackedInt32Array()

#var sin_pos : float = 0

func set_length(new_length):
	if length != new_length:
		length = new_length
		# Do what you want when the variable changed
#		remesh()

func _ready():
	remesh()
	
func animate(_pos):
	for i in range(mdt.get_vertex_count()):
		var vert = mdt.get_vertex(i)
		vert.y= verts[i].y+cos(_pos+(verts[i].x/4))*(verts[i].x/10+0.0)
		mdt.set_vertex(i, vert)
	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	
func remesh():
	var surface_array = ArrayMesh.new()
	# PackedVector**Arrays for mesh construction.

	# Vertex indices.
	var thisrow = 0
	var prevrow = 0
	var point = 0

	# Loop over rings.
	for i in range(rings + 1):
		var v = float(i) / rings
		var w = width_curve.sample(v)*2
		var x = v  * length
		var y_decal = sin(v*10)*sin(v)
		y_decal =-w


		# Loop over segments in ring.
		for j in range(radial_segments):
			var u = float(j) / radial_segments
			var y = sin(u * PI * 2.0)
			var z = cos(u * PI * 2.0)
			var vert = Vector3(x, y * radius * w + y_decal, z * radius * w)
			verts.append(vert)
			normals.append( Vector3(0, y * radius  , z * radius).normalized())
			uvs.append(Vector2(u, v))
			point += 1

			# Create triangles in ring using indices.
			if i > 0 and j > 0:
				indices.append(prevrow + j - 1)
				indices.append(prevrow + j)
				indices.append(thisrow + j - 1)

				indices.append(prevrow + j)
				indices.append(thisrow + j)
				indices.append(thisrow + j - 1)

		if i > 0:
			indices.append(prevrow + radial_segments - 1)
			indices.append(prevrow)
			indices.append(thisrow + radial_segments - 1)

			indices.append(prevrow)
			indices.append(prevrow + radial_segments)
			indices.append(thisrow + radial_segments - 1)

		prevrow = thisrow
		thisrow = point

 # Assign arrays to surface array.
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	
	# Create mesh surface from mesh array.
	surface_array.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays) # No blendshapes, lods, or compression used.
	mesh=surface_array
	mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
