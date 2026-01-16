shader_type canvas_item;

uniform float skew = 0.0;

void vertex() {
	if(VERTEX.y < 0.0){
		VERTEX.x += (1.0-UV.y)*skew;
	}
}

