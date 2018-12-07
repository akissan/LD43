shader_type canvas_item;

vec4 sample_glow_pixel(sampler2D tex, vec2 uv) {
    float hdr_threshold = 0.3; // Pixels with higher color than 1 will glow
    return max(texture(tex, uv) - hdr_threshold, vec4(0.0));
}

vec3 bloomTile(float lod, vec2 offset, vec2 uv){
    return texture(iChannel1, uv * exp2(-lod) + offset).rgb;
}

vec3 getBloom(vec2 uv){

    vec3 blur = vec3(0.0);

    blur = pow(bloomTile(2., vec2(0.0,0.0), uv),vec3(2.2))       	   	+ blur;
    blur = pow(bloomTile(3., vec2(0.3,0.0), uv),vec3(2.2)) * 1.3        + blur;
    blur = pow(bloomTile(4., vec2(0.0,0.3), uv),vec3(2.2)) * 1.6        + blur;
    blur = pow(bloomTile(5., vec2(0.1,0.3), uv),vec3(2.2)) * 1.9 	   	+ blur;
    blur = pow(bloomTile(6., vec2(0.2,0.3), uv),vec3(2.2)) * 2.2 	   	+ blur;

    return blur * colorRange;
}

void fragment() {
   	
	
	color += pow(getBloom(uv), vec3(2.2));
    vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec4 glowing_col = 0.25 * (col0 + col1 + col2 + col3);

    COLOR = vec4(col.rgb + glowing_col.rgb, col.a);
}