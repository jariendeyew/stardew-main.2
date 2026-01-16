shader_type canvas_item;

uniform float val = .5;
uniform vec2 offset = vec2(0,-1);
uniform sampler2D noise_texture1:repeat_enable;

void fragment(){
	vec4 orignal_color = texture(TEXTURE,UV);
	vec4 noise_color1 = texture(noise_texture1,UV+offset*TIME);
	//COLOR = orignal_color * noise_color1;
	if (val>noise_color1.r){
		orignal_color.a = 0.0;
	}
	COLOR = orignal_color;
	COLOR.r += 1.;
	COLOR.g -= 1.;
	COLOR.b += 2.;
}