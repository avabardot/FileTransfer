shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 base_color : source_color = vec4(0.1, 0.08, 0.15, 1.0);
uniform float roughness : hint_range(0.0, 1.0) = 0.7;
uniform float metallic : hint_range(0.0, 1.0) = 0.0;
uniform float rim_intensity : hint_range(0.0, 2.0) = 0.4;
uniform vec4 rim_color : source_color = vec4(0.3, 0.25, 0.5, 1.0);
uniform float color_bands : hint_range(2.0, 32.0) = 12.0;
uniform float ambient_tint_strength : hint_range(0.0, 1.0) = 0.15;

void fragment() {
	// Base color with subtle quantization for stylized look
	vec3 color = base_color.rgb;
	color = floor(color * color_bands + 0.5) / color_bands;

	// Normal-based ambient tinting — adds depth in shadows
	float up_factor = dot(NORMAL, vec3(0.0, 1.0, 0.0)) * 0.5 + 0.5;
	vec3 ambient_tint = mix(vec3(0.02, 0.01, 0.04), vec3(0.06, 0.05, 0.1), up_factor);
	color = mix(color, color + ambient_tint, ambient_tint_strength);

	ALBEDO = color;
	ROUGHNESS = roughness;
	METALLIC = metallic;

	// Fresnel-based rim lighting — helps silhouettes read in darkness
	float fresnel = pow(1.0 - dot(NORMAL, VIEW), 3.0);
	EMISSION = rim_color.rgb * fresnel * rim_intensity;
}
