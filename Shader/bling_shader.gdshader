shader_type canvas_item;

uniform float outline_width = 1.0;
uniform vec4 outline_color : source_color; //vec4类型变量，source_color可以在检视器面板用色盘调色

void fragment() {
	vec2 uv = UV; //UV是一个二维矢量变量，由于其本身不能更改值，则赋值给uv来改变。
	
	vec2 uv_up = uv + vec2(0,TEXTURE_PIXEL_SIZE.y) * outline_width; //uv坐标上移一个像素
	vec2 uv_down = uv + vec2(0,-TEXTURE_PIXEL_SIZE.y) * outline_width;
	vec2 uv_left = uv + vec2(TEXTURE_PIXEL_SIZE.x,0) * outline_width;
	vec2 uv_right = uv + vec2(-TEXTURE_PIXEL_SIZE.x,0) * outline_width;
	
	vec4 color_up = texture(TEXTURE,uv_up);//采样uv_up坐标对应的颜色
	vec4 color_down = texture(TEXTURE,uv_down);
	vec4 color_left = texture(TEXTURE,uv_left);
	vec4 color_right = texture(TEXTURE,uv_right);
	
	vec4 outline = color_up + color_right + color_down + color_left;//原有纹理向外增加一像素的轮廓
	float t = abs(sin(TIME));
	outline = mix(outline,vec4(1,0,1,0),t);
	outline.rgb = outline_color.rgb; //任何一个vec4变量的rgba都可以单独拿出来修改，这里是让四个纹理颜色不叠加
	outline.a = min(outline.a,1); // 限制轮廓透明度不超过1
	
	vec4 orignal_color = texture(TEXTURE,UV); //获得原始颜色
	
	COLOR = mix(outline,orignal_color,orignal_color.a);
	//第三个值用透明度，是为了在原来该显示坤的地方会显示坤，其他地方显示描边颜色
}

