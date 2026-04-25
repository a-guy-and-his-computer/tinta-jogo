shader_type canvas_item;

uniform float desfoque_quant : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec2 texel = TEXTURE_PIXEL_SIZE * desfoque_quant;

    vec4 color = vec4(0.0);
	
	// Pegar os pixels ao redor e tratar os que estão mais perto com importância
	// Colocando pesos maiores aos que estão mais perto
	
	// 1 2 1
	// 2 4 2
	// 1 2 1

    color += texture(TEXTURE, UV) * 0.4;

    color += texture(TEXTURE, UV + vec2(texel.x, 0.0)) * 0.15;
    color += texture(TEXTURE, UV - vec2(texel.x, 0.0)) * 0.15;

    color += texture(TEXTURE, UV + vec2(0.0, texel.y)) * 0.15;
    color += texture(TEXTURE, UV - vec2(0.0, texel.y)) * 0.15;

    COLOR = color;
}