shader_type canvas_item;

uniform float desfoque_quant : hint_range(0.0, 10.0) = 2.0;

void fragment() {
	vec2 texel = TEXTURE_PIXEL_SIZE * desfoque_quant;
	
	// Pegar os pixels ao redor na vertical e fazer a média
	// Isso é menos custoso para a GPU que um 3x3
	
	// (0,-1)
	// (0, 0)
	// (0, 1)
	
	vec4 color = vec4(0.0);
	
	color += texture(TEXTURE, UV + vec2(0.0, -texel.y));
	color += texture(TEXTURE, UV);
	color += texture(TEXTURE, UV + vec2(0.0, texel.y));
	
	COLOR = color / 3.0;
}