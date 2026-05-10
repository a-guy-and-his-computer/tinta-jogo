shader_type canvas_item;

uniform sampler2D mapa_gradiente;

void fragment(){
	vec4 tex = texture(TEXTURE, UV);
	
	// Pega a escala da luminosidade como ela é interpretada por olhos humanos
	// Multiplica a cor do fragmento para que caia nessa escala (escuro até claro)
	float luminosidade = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
	
	// Vê qual é a posição da cor na escala e muda a cor de acordo com o gradiente que você pode mexer no inspector
	vec4 textura_mapeada = texture(mapa_gradiente, vec2(luminosidade, 0.0));
	
	// Muda a cor de acordo com a cor que ele encontrou na escala
	COLOR = vec4(textura_mapeada.rgb, tex.a);
}