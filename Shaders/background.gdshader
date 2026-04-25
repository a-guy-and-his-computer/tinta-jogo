shader_type canvas_item;

uniform float desfoque_quant : hint_range(0.0, 10.0) = 0.0;
uniform float transicao : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D textura_original; // COLOCAR TEXTURA AQUI
uniform sampler2D proxima_textura;

vec2 uv_alinhado(sampler2D textura, vec2 uv){
	vec2 texture_pixel_size = 1.0 / vec2(textureSize(textura, 0));
	vec2 uv_da_textura = (floor(uv / texture_pixel_size) + 0.5) * texture_pixel_size;
	
	return uv_da_textura;
}

vec2 calculo_texel(sampler2D textura){
	vec2 texture_pixel_size = 1.0 / vec2(textureSize(textura, 0));
	float desfoque_passos = round(desfoque_quant);
	vec2 texel = texture_pixel_size * desfoque_passos;
	
	return texel;
}

vec4 desfoque_gaussiano(sampler2D textura, vec2 uv) {
	vec2 uv_alinhado = uv_alinhado(textura, uv);
	vec2 texel = calculo_texel(textura);
	
	vec4 cor = vec4(0.0);
	
	cor += texture(textura, uv_alinhado) * 0.4;
	cor += texture(textura, uv_alinhado + vec2(texel.x, 0.0)) * 0.15;
	cor += texture(textura, uv_alinhado - vec2(texel.x, 0.0)) * 0.15;
	cor += texture(textura, uv_alinhado + vec2(0.0, texel.y)) * 0.15;
	cor += texture(textura, uv_alinhado - vec2(0.0, texel.y)) * 0.15;
	
	return cor;
}

void fragment() {
	vec4 cor_original = desfoque_gaussiano(textura_original, UV);
	vec4 cor_proxima_textura = desfoque_gaussiano(proxima_textura, UV);
	
	COLOR = mix(cor_original, cor_proxima_textura, transicao);
}