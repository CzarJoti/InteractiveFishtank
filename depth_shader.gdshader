shader_type spatial;
render_mode blend_mix, depth_draw_never, cull_disabled, unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_nearest;

uniform float shimmer_strength : hint_range(0.0, 0.015) = 0.0016;
uniform float shimmer_speed = 1.6;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

float get_linear_depth(vec2 uv, mat4 inv_proj) {
	float raw_depth = texture(DEPTH_TEXTURE, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, raw_depth);
	vec4 view_pos = inv_proj * vec4(ndc, 1.0);
	return -view_pos.z / view_pos.w;
}

void fragment() {
	float depth = get_linear_depth(SCREEN_UV, INV_PROJECTION_MATRIX);

	float dist_factor = clamp(depth * 0.15, 0.0, 1.0);
	vec2 wave = vec2(
		sin(SCREEN_UV.y * 26.0 + TIME * shimmer_speed),
		cos(SCREEN_UV.x * 20.0 + TIME * (shimmer_speed * 0.85))
	) * shimmer_strength * dist_factor;

	vec2 refracted_uv = clamp(SCREEN_UV + wave, vec2(0.001), vec2(0.999));

	ALBEDO = texture(SCREEN_TEXTURE, refracted_uv).rgb;
}