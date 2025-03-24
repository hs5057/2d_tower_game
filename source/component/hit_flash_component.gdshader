shader_type canvas_item;

//将白色亮度设置在 Shader Parameters 里可以手动调整的
uniform float lerp_percent : hint_range(0.0, 1.0, 0.1);


void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	//mix线性插值混合颜色，将角色纹理颜色到白色混合，
	//texture_color.a代表透明度，如果用1.0的话那么整个图块都会变白，如果用texture_color.a则只会将有纹理的地方变白
	//最后的1.0代表权重，1.0是全白，0.5就是50%的白
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	// 添加对 modulate.a 的支持
    final_color.a *= COLOR.a; // 确保外部透明度修改生效

	COLOR = final_color;

}
