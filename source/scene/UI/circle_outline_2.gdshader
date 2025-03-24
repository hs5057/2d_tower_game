shader_type canvas_item;
uniform vec4 color: source_color = vec4(1.0);
uniform float radius = 0.5; // Circle Diameter
uniform float center_pos = 0.5; // Circle Diameter

void fragment() {
    vec2 center = vec2(center_pos, center_pos); // 中心点
    float distance = length(UV - center);
    COLOR = (distance < radius) ? color : vec4(0.0); // 红色圆形
}