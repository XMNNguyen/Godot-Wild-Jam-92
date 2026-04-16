shader_type spatial;

uniform sampler2D main_texture;
uniform sampler2D noise_texture;
uniform sampler2D cloud_noise_texture;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.8;
uniform vec2 cloud_dir = vec2(1.0, 0.0);
uniform float scroll_speed = 0.05;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 base_color = texture(main_texture, UV);
	float noise_color = texture(noise_texture, UV).r;
	
	//handle clouds
	vec2 scroll = cloud_dir * TIME * scroll_speed;
	float cloud_color = texture(cloud_noise_texture, UV + scroll).r;
	
	float darkness = mix(1.0, noise_color, noise_strength);
	float clouds = mix(1.0, cloud_color, noise_strength);
    
    // 4. Apply modulation to the texture color
    ALBEDO = base_color.rgb * darkness * clouds * vec3(1, 2, 1);
    ALPHA = base_color.a; // Preserve texture alpha
	//ALBEDO = mix(ALBEDO.rgb, cloud_color.rgb, noise_strength);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
