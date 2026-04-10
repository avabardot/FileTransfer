shader_type sky;

uniform vec4 sky_top_color : source_color = vec4(0.02, 0.01, 0.06, 1.0);
uniform vec4 sky_horizon_color : source_color = vec4(0.06, 0.03, 0.12, 1.0);
uniform vec4 ground_color : source_color = vec4(0.01, 0.01, 0.02, 1.0);
uniform float star_density : hint_range(0.0, 0.02) = 0.005;
uniform float star_brightness : hint_range(0.0, 2.0) = 0.8;
uniform vec3 moon_direction = vec3(0.3, 0.6, -0.5);
uniform float moon_size : hint_range(0.0, 0.1) = 0.03;
uniform vec4 moon_color : source_color = vec4(0.8, 0.85, 1.0, 1.0);
uniform float aurora_intensity : hint_range(0.0, 1.0) = 0.3;
uniform vec4 aurora_color_1 : source_color = vec4(0.1, 0.4, 0.3, 1.0);
uniform vec4 aurora_color_2 : source_color = vec4(0.2, 0.15, 0.5, 1.0);

// Hash function for stars
float hash(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * 0.1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

// Value noise for aurora
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void sky() {
	vec3 dir = EYEDIR;

	// Sky gradient
	float horizon = smoothstep(-0.1, 0.3, dir.y);
	vec3 sky = mix(sky_horizon_color.rgb, sky_top_color.rgb, horizon);

	// Ground
	if (dir.y < 0.0) {
		sky = ground_color.rgb;
	}

	// Stars (only above horizon)
	if (dir.y > 0.0) {
		vec2 star_uv = dir.xz / (dir.y + 0.001) * 50.0;
		float star = hash(floor(star_uv));
		float star_mask = step(1.0 - star_density, star);
		float twinkle = sin(TIME * 2.0 + star * 100.0) * 0.3 + 0.7;
		sky += vec3(star_brightness * star_mask * twinkle);
	}

	// Moon
	vec3 moon_dir = normalize(moon_direction);
	float moon_dot = dot(dir, moon_dir);
	float moon_disc = smoothstep(1.0 - moon_size, 1.0 - moon_size * 0.8, moon_dot);
	float moon_glow = smoothstep(1.0 - moon_size * 4.0, 1.0 - moon_size, moon_dot) * 0.15;
	sky += moon_color.rgb * (moon_disc * 2.0 + moon_glow);

	// Aurora borealis effect
	if (dir.y > 0.1 && aurora_intensity > 0.0) {
		float aurora_y = smoothstep(0.15, 0.5, dir.y) * smoothstep(0.8, 0.4, dir.y);
		float aurora_wave = noise(vec2(dir.x * 3.0 + TIME * 0.05, dir.y * 2.0)) * 0.5
						  + noise(vec2(dir.x * 6.0 - TIME * 0.08, dir.y * 4.0)) * 0.25
						  + noise(vec2(dir.x * 12.0 + TIME * 0.03, dir.y * 8.0)) * 0.125;
		vec3 aurora = mix(aurora_color_1.rgb, aurora_color_2.rgb, aurora_wave);
		float aurora_mask = aurora_y * aurora_wave * aurora_intensity;
		sky += aurora * aurora_mask * 0.5;
	}

	COLOR = sky;
}
