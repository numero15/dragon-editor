shader_type spatial;

uniform sampler2D gradient : hint_default_black;
void fragment() {
	
	ALBEDO  = texture(gradient,vec2(UV.y,0.0)).rgb;
//	ALPHA = UV.y;
}
