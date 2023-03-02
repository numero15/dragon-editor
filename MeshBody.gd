extends MeshInstance3D

var rings = 60
var radial_segments = 16
var height = 1
var radius = 1

func _ready():
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	var bones = PackedInt32Array()
	var weights = PackedFloat32Array()

   # Vertex indices.
	var thisrow = 0
	var prevrow = 0
	var point = 0

	# Loop over rings.
	for i in range(rings + 1):
		var v = float(i) / rings * 4
		var z = -i*2

		# Loop over segments in ring.
		for j in range(radial_segments):
			var u = float(j) / radial_segments
			var x = cos(u * PI * 2.0)
			var y = sin(u * PI * 2.0)
			var vert = Vector3(x * radius, y * radius, z)
			verts.append(vert)
			normals.append(Vector3(vert.x,vert.y,0).normalized())
			if u <= .5 :
				u = u*2
			else :
				u = 1/u -1
				
			uvs.append(Vector2(u, v))
			bones.append(i)
			bones.append(i)
			bones.append(i)
			bones.append(i)
			weights.append(1.0)
			weights.append(0.0)
			weights.append(0.0)
			weights.append(0.0)
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
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	surface_array[Mesh.ARRAY_BONES] = bones
	surface_array[Mesh.ARRAY_WEIGHTS] =weights

	# Create mesh surface from mesh array.
	# No blendshapes, lods, or compression used.var arr_mesh = ArrayMesh.new()

	var arr_mesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	
	mesh = arr_mesh
