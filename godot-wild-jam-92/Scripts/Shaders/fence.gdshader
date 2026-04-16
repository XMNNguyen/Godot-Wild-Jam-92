shader_type spatial;
render_mode depth_prepass_alpha;

uniform sampler2D main_texture;
uniform sampler2D noise_texture;
uniform sampler2D cloud_noise_texture;
uniform float noise_strength : hint_range(0.0, 1.0) = 0.8;
uniform vec2 cloud_dir = vec2(1.0, 0.0);
uniform float scroll_speed = 0.002;

uniform float texture_scale = 0.01;
uniform float blend_sharpness = 4.0;
uniform vec3 object_scale = vec3(1.0);

varying vec3 world_position;

void vertex() {
	// Calculate world position
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Extract scale from matrix and apply to world_position
    vec3 scale;
    scale.x = length(MODEL_MATRIX[0].xyz);
    scale.y = length(MODEL_MATRIX[1].xyz);
    scale.z = length(MODEL_MATRIX[2].xyz);

	world_position /= (scale + 100.0);
}

void fragment() {
	// get the texture colors
	vec4 base_color = texture(main_texture, UV);
	float noise_color = texture(noise_texture, UV).r;
	
	//handle clouds
	vec2 scroll = cloud_dir * TIME * scroll_speed * 0.02;
	float cloud_color = texture(cloud_noise_texture , (world_position.xz * texture_scale) + scroll).r;
	
	// get noise and clouds
	float darkness = mix(1.0, noise_color, noise_strength);
	float clouds = mix(1.0, cloud_color, noise_strength);
    
    // 4. Apply modulation to the texture color
    ALBEDO = base_color.rgb * darkness * clouds * vec3(1, 2, 1);
 
    ALPHA = base_color.a; // Preserve texture alpha
}


float fresnel(vec3 normal, vec3 view)
{
	return 1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0);
}


void light() {
	float light = max(dot(NORMAL, LIGHT), 0.0) * ATTENUATION;

	light = round(light * 4.0) / 4.0;
	
	vec3 diffuse = vec3(light) * LIGHT_COLOR / PI;
	
	DIFFUSE_LIGHT += diffuse;
}
