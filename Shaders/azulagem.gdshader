shader_type canvas_item;

uniform vec3 azul_fundo: source_color = vec3(0.65, 0.8, 1.0);
uniform float quant_azul = 0.5;

void fragment() {
	vec4 textura = texture(TEXTURE, UV);
	
	textura.rgb = mix(textura.rgb, azul_fundo, quant_azul * 0.1);
	
	COLOR = textura;
}