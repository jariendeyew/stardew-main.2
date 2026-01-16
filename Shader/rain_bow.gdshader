shader_type canvas_item;

uniform bool flip_h = false;
uniform vec2 offset = vec2(0,0);
uniform sampler2D noise_texture:repeat_enable;

void vertex(){
	UV = vec2(UV.y,UV.x);
	if(flip_h){
		UV = vec2(-UV.x,-UV.y);
	}
}
void fragment(){
	vec4 orignal_color = texture(TEXTURE,UV);
	vec4 noise_color = texture(noise_texture,UV+offset*TIME);
	if(noise_color.r<.5){
		COLOR.a = 0.;
	}
	//if(flip_h){
		//if(UV.y>=UV.x){
			//COLOR.a = 0.0;
		//}
	//}else{
	if(UV.x>=UV.y){
		COLOR.a = 0.0;
	}
	COLOR.r = 5.;
	COLOR.b = 2.;
}