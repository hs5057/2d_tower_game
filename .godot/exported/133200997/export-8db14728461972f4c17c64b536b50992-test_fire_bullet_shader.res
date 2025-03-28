RSRC                    VisualShader            ��������                                            =      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    parameter_name 
   qualifier    texture_type    color_default    texture_filter    texture_repeat    texture_source    script    source    texture    op_type    input_name 	   operator    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        1   local://VisualShaderNodeTexture2DParameter_gfgpk �      &   local://VisualShaderNodeTexture_n0pg4 f      )   local://VisualShaderNodeSmoothStep_hriew �      $   local://VisualShaderNodeInput_fy2nq �      &   local://VisualShaderNodeFloatOp_0btlf 1	      1   local://VisualShaderNodeTexture2DParameter_nbi6p e	      &   local://VisualShaderNodeTexture_tfjvg �	      8   res://source/entity/Bullet/test_fire_bullet_shader.tres 
      #   VisualShaderNodeTexture2DParameter             DissolveTexture                            VisualShaderNodeTexture                                               VisualShaderNodeSmoothStep             VisualShaderNodeInput                             color          VisualShaderNodeFloatOp                   #   VisualShaderNodeTexture2DParameter             FireTexture                   VisualShaderNodeTexture                                      VisualShader          �  shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform sampler2D DissolveTexture : source_color, repeat_enable;
uniform sampler2D FireTexture : source_color;



void fragment() {
// Input:5
	vec4 n_out5p0 = COLOR;
	float n_out5p4 = n_out5p0.a;


	vec4 n_out3p0;
// Texture2D:3
	n_out3p0 = texture(DissolveTexture, UV);
	float n_out3p1 = n_out3p0.r;


// SmoothStep:4
	float n_in4p1 = 1.00000;
	float n_out4p0 = smoothstep(n_out5p4, n_in4p1, n_out3p1);


	vec4 n_out8p0;
// Texture2D:8
	n_out8p0 = texture(FireTexture, UV);
	float n_out8p1 = n_out8p0.r;


// FloatOp:6
	float n_out6p0 = n_out4p0 * n_out8p1;


// Output:0
	COLOR.rgb = vec3(n_out5p0.xyz);
	COLOR.a = n_out6p0;


}
                                
     �D  �B                
      �  �C             !   
     ��  �B"            #   
     \C  �B$            %   
     ��  ��&            '   
     �C  �B(            )   
     �C  D*            +   
     �C  �C,                                                                                                                           RSRC