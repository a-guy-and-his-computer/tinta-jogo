shader_type canvas_item;

uniform float desfoque_quant: hint_range(0.0, 10.0) = 1.0;

void fragment() {
	// Blur
	vec2 texel = TEXTURE_PIXEL_SIZE * desfoque_quant; // Pegue o pixel que está a 3 pixels de distância
	
	vec4 color = vec4(0.0);
	
	// Pegar os pixels ao redor e fazer a média
	
	// (-1,-1) (0,-1) (1,-1)
	// (-1, 0) (0, 0) (1, 0)
	// (-1, 1) (0, 1) (1, 1)
	
	color += texture(TEXTURE, UV + vec2(-texel.x, -texel.y));
	color += texture(TEXTURE, UV + vec2(0, -texel.y));
	color += texture(TEXTURE, UV + vec2(texel.x, -texel.y));
	
	color += texture(TEXTURE, UV + vec2(-texel.x, 0));
	color += texture(TEXTURE, UV + vec2(0, 0));
	color += texture(TEXTURE, UV + vec2(texel.x, 0));
	
	color += texture(TEXTURE, UV + vec2(-texel.x, texel.y));
	color += texture(TEXTURE, UV + vec2(0, texel.y));
	color += texture(TEXTURE, UV + vec2(texel.x, texel.y));
	
	COLOR = color / 9.;
}
