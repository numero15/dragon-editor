shader_type spatial;
render_mode  diffuse_toon;

uniform sampler2D gradient;
uniform sampler2D albedo_texture : hint_default_white;
uniform sampler2D normal_texture : hint_normal;
uniform sampler2D ao_texture : hint_default_white;
uniform float scale_x : hint_range(.1, 5);
uniform float scale_y : hint_range(.1, 5);
uniform float rotation : hint_range(0, 6.28);

vec2 rotateUV(vec2 uv, vec2 pivot, float _rotation) {
    float cosa = cos(_rotation);
    float sina = sin(_rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

void fragment() {
	vec3 color = texture(albedo_texture, rotateUV(UV, vec2(0.0,0.0), rotation)*vec2(scale_x,scale_y)).rgb;
	float gray = dot(color, vec3(0.299, 0.587, 0.114));
	color = texture(gradient, vec2(gray, 0.5)).rgb;
	ALBEDO  =  color;
//	NORMAL = texture(normal_texture, rotateUV(UV, vec2(0.0,0.0), rotation)*vec2(scale_x,scale_y)).rbg;
//	AO = texture(ao_texture, rotateUV(UV, vec2(0.0,0.0), rotation)*vec2(scale_x,scale_y)).r;
	ROUGHNESS = 0.0;
	METALLIC = 0.0;
	SPECULAR = 0.0;
}

