shader_type canvas_item;

uniform vec2 offset = vec2(0);

void vertex(){
	UV = UV + offset*TIME;
}