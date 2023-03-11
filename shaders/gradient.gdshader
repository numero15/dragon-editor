shader_type spatial;
render_mode  diffuse_toon;

uniform sampler2D gradient : hint_default_black;
void fragment() {
	
	ALBEDO  = texture(gradient,vec2(UV.y,0.0)).rgb;
	ROUGHNESS = 0.08;
	METALLIC = 0.0;
	SPECULAR = 0.0;
//	ALPHA = UV.y;
}
