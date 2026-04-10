shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform vec4 emission_color : source_color = vec4(1.0, 0.7, 0.3, 1.0);
uniform float emission_strength : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_speed : hint_range(0.0, 5.0) = 0.0;
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.2;
uniform float base_alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	// Optional pulsing animation
	float pulse = 1.0;
	if (pulse_speed > 0.0) {
		pulse = 1.0 - pulse_amount + pulse_amount * (sin(TIME * pulse_speed * 3.14159) * 0.5 + 0.5);
	}

	vec3 color = emission_color.rgb * emission_strength * pulse;
	ALBEDO = color;
	ALPHA = base_alpha;
}
