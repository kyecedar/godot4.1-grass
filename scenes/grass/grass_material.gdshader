shader_type spatial;
render_mode cull_disabled;

uniform sampler2D noise;
uniform sampler2D ground_height;
uniform float ground_spread : hint_range(1.0, 500.0) = 200.0;
uniform float ground_amplitude : hint_range(0.0, 100.0) = 2.0;
uniform float old_grass_height : hint_range(0.0, 50.0) = 1.1;
uniform float max_height : hint_range(0.0, 50.0) = 1.5;
uniform float min_height : hint_range(0.0, 50.0) = 0.3;
uniform float model_height : hint_range(0.0, 5.0) = 0.811296; // Your model's blade height.
uniform vec3 ao_color : source_color = vec3(0.30, 0.19, 0.007);
uniform vec3 mid_color : source_color = vec3(0.29, 0.56, 0.37);
uniform vec3 tip_color : source_color = vec3(0.80, 0.78, 0.57);
uniform float wind_direction : hint_range(0.0, 3.14) = 3.14;

varying vec4 worldPos;
varying float height;

void vertex() {
	// holy shit this took too long.
	// >> https://github.com/godotengine/godot/issues/19800#issuecomment-1312531417
	// >> https://www.reddit.com/r/godot/comments/v59x0a/godot_4_alpha_9_world_matrix_renamed_or_removed/
	worldPos = MODEL_MATRIX * vec4(VERTEX, 1.0);
	
	height = (texture(noise, worldPos.xz / 10.0).r) * (max_height - min_height) + min_height;
	
	VERTEX.y /= model_height; // normalize.
	
	VERTEX.y *= height;
	VERTEX.y *= model_height;
	VERTEX.y += texture(ground_height, worldPos.xz / ground_spread).r * ground_amplitude;
	
	float wind = (sin((worldPos.x + worldPos.z) + TIME) / 5.0) * (worldPos.y / height);
	VERTEX.xz += wind;
}

void fragment() {
	float UVH = worldPos.y / height;
	
	vec3 color = vec3(1.0);
	
	if(height > old_grass_height) {
		color = mix(ao_color, tip_color, UVH);
	} else {
		color = mix(ao_color, mid_color, UVH);
	}
	
	ALBEDO = color;
}