// BIG HUGE HELP from devmar's video and code.
// >> https://www.youtube.com/watch?v=YCBt-55PaOc

shader_type particles;
render_mode disable_velocity;

uniform float rows = 1000.0;
uniform float spacing : hint_range(0.0, 2.0) = 0.05; // multiplied to position.
uniform float rotation : hint_range(0.0, 1.0) = 0.5;
uniform float rand_rot : hint_range(0.0, 1.0) = 0.5; 
uniform float rand_pos : hint_range(0.0, 1.0) = 0.1; // multiplied to noise, cos/sin.
uniform sampler2D noise_texture;

void start() {
	vec3 pos = vec3(0.0);
	
	pos.z = float(INDEX);
	pos.x = mod(pos.z, rows);
	pos.z = (pos.z - pos.x) / rows;
	
	pos.x -= rows * 0.5;
	pos.z -= rows * 0.5;
	
	pos *= spacing;
	
	// Offset by emmision object xz position.
	pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], spacing);
	pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], spacing);
	
	vec3 noise = texture(noise_texture, pos.xz).rgb;
	
	pos.x -= noise.x * rand_pos;
	pos.z -= noise.z * rand_pos;
	
	TRANSFORM[3][0] = pos.x;
	TRANSFORM[3][1] = pos.y;
	TRANSFORM[3][2] = pos.z;
	
	TRANSFORM[0][0] = cos(noise.x * rand_rot + (rotation * 6.28));
	TRANSFORM[0][2] = -sin(noise.x * rand_rot + (rotation * 6.28));
	TRANSFORM[2][0] = sin(noise.z * rand_rot + (rotation * 6.28));
	TRANSFORM[2][2] = cos(noise.z * rand_rot + (rotation * 6.28));
}

void process() {
	// Place process code here.
}
