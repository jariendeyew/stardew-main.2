shader_type canvas_item;

// 暴露给编辑器的透明度参数（0.0完全透明 - 1.0完全不透明）
uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float shake_intensity = 0.0;//震动强度
uniform float shake_speed = 10.0;//震动速度

void fragment() {
    // 获取原始纹理颜色
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 保持 RGB 颜色不变，仅修改 Alpha 通道
    COLOR = vec4(tex_color.rgb, tex_color.a * alpha);
}

void vertex() {
	vec2 shake = vec2(0.0); //定义shake矢量
	if(VERTEX.y < 0.0){
		shake.x = sin(TIME * shake_speed + VERTEX.y) * shake_intensity;
	}
	VERTEX.xy += shake;
}

