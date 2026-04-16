shader_type spatial;

uniform sampler2D main_texture;
uniform sampler2D noise_texture;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base_color = texture(main_texture, UV);
	vec4 noise_color = texture(noise_texture, UV);
	
	ALBEDO = mix(base_color.rgb, noise_color.rgb, noise_strength); 
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
