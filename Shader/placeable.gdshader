shader_type canvas_item;

uniform bool PREVIEW = false;
uniform bool PLACEABLE = true;

void fragment() {
	vec4 previous_color = texture(TEXTURE,UV);
	vec4 white_color = vec4(1.0,1.0,1.0,previous_color.a);
	vec4 new_color = previous_color;
	if(PREVIEW){
		if(!PLACEABLE){
			new_color.r = 0.9;
			new_color.g = new_color.g/2.0;
			new_color.b = new_color.b/2.0;
		}else{
			new_color = texture(TEXTURE,UV);
		}
		if(new_color.a == 1.0){
			new_color.a = 0.75;
		}
	}else{
		new_color = texture(TEXTURE,UV);
	}
	COLOR = new_color;
}
