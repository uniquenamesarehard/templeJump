shader_type canvas_item;

// Gonkee's fog shader for Godot 3 - full tutorial https://youtu.be/QEaTsz_0o44
// If you use this shader, I would prefer it if you gave credit to me and my channel


uniform vec3 color = vec3(0.60, 0.60, 0.65);
uniform int OCTAVES = 4;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(86, 176)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.6;

	for(int i = 0; i < OCTAVES; i++){
		value += noise(coord) * scale;
		coord *= 1.1;
		scale *= .9;
	}
	return value;
}

void fragment() {
	vec2 coord = UV * 11.2;

	vec2 motion = vec2( fbm(coord + vec2(TIME * -0.57, TIME * 0.5)) *1.5);

	float final = fbm(coord + motion);

	COLOR = vec4(color, final * 0.2);
}
//
//float noise( in vec3 x )
//{
//    vec3 p = floor(x);
//    vec3 f = fract(x);
//	f = f*f*(3.0-2.0*f);
//	vec2 uv = (p.xy+vec2(37.0,17.0)*p.z) + f.xy;
//	vec2 rg = textureLod(TEXTURE, (uv+ 0.5)/256.0, 0.0 ).yx;
//	return 1. - 0.82*mix( rg.x, rg.y, f.z );
//}
//
//float fbm(vec3 x) {
//    float h = 0.0;
//    float a = 0.5;
//    float p = 1.0;
//    for(int i = 0; i < 6; i++) {
//        h += noise(x * p) * a;
//        a *= 0.5;
//        p *= 2.0;
//    }
//    return h;
//}
//
//void mainImage( out vec4 COLOR, in vec2 FRAGCOORD )
//{
//    // Normalized pixel coordinates (from 0 to 1)
//    vec2 uv = FRAGCOORD/screen_size.xy;
//
//    //set gradients
//	float num_gradients = 10.0;
//
//    //calculate noise
//	float n = fbm(vec3(uv*10.0, iTime*0.4));
//
//    //posterize noise
//    n *= num_gradients + 1.0;
//    n = floor(n) / num_gradients;
//
//    vec3 col = vec3(n);
//
//    // Output to screen
//    COLOR = vec4(col,1.0);
//}