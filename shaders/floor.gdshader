shader_type spatial;

uniform sampler2D texture_map: repeat_enable;

uniform sampler2D color_map: repeat_enable;
uniform sampler2D normal_map: repeat_enable;

uniform float normal_depth : hint_range(0.0, 2.0) = 1.2;

uniform float color_scale = 3.0;

uniform sampler2D color_gradient : source_color, repeat_disable, filter_linear;

uniform float max_height = 0.3;

void vertex() {
	float h = textureLod(texture_map, UV, 0.0).r;
	VERTEX.y += h * max_height;
	
	float eps = 0.01;
	float h_x = textureLod(texture_map, UV + vec2(eps, 0.0), 0.0).r;
	float h_z = textureLod(texture_map, UV + vec2(0.0, eps), 0.0).r;
	NORMAL = normalize(vec3((h - h_x) * max_height * 40.0, 1.0, (h - h_z) * max_height * 40.0));
}

void fragment() {
	vec2 color_uv = UV * color_scale;
	
	float color_val = texture(color_map, color_uv).r;
	ALBEDO = texture(color_gradient, vec2(color_val, 0.5)).rgb;
	NORMAL_MAP = texture(normal_map, color_uv).rgb;
	NORMAL_MAP_DEPTH = normal_depth;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
