shader_type canvas_item;

uniform sampler2D tela: hint_screen_texture;

group_uniforms Nitidez;
uniform bool nitidez_ligado;
uniform float quant_nitidez: hint_range(0.0, 3.0) = 0.362;

group_uniforms Color_Grading;
uniform bool grading_ligado;
uniform float brilho: hint_range(-1.0, 1.0) = 0.0;
uniform float contraste: hint_range(0.0, 3.0)  = 1.0;
uniform float saturacao: hint_range(0.0, 3.0)  = 1.0;

group_uniforms Inversao_De_Cores;
uniform vec2 inversao_centro = vec2(0.5,0.5);
uniform float raio = 0.0;
uniform float inversao_suavidade = 0.2;
uniform sampler2D tileset_mascara;

group_uniforms Vignette;
uniform bool vignette_ligado;
uniform float intensidade: hint_range(0.0, 1.0) = 0; // Melhor efeito = 0.512
uniform float vignette_suavidade: hint_range(0.0, 1.0) = 1.; // Melhor efeito = 0.914
uniform vec4 cor_vignette: source_color = vec4(0.0, 0.0, 0.0, 1.0); // Preto

vec3 nitidez(vec3 cor, vec2 pixel, vec2 tela_uv){
	if (nitidez_ligado == false){
		return cor;
	}
	
	// Nitidez funciona pegando o pixel central, multiplicando por 5,
	// e depois subtraindo pelo valor dos 4 vizinhos.
	// Se o pixel for mais brilhante que os seus vizinhos, ele fica ainda mais brilhante.
	vec3 centro = texture(tela, tela_uv).rgb;
	vec3 cima = texture(tela, tela_uv + vec2(0.0, -pixel.y)).rgb;
	vec3 baixo = texture(tela, tela_uv + vec2(0.0, pixel.y)).rgb;
	vec3 esq = texture(tela, tela_uv + vec2(-pixel.x, 0.0)).rgb;
	vec3 dir = texture(tela, tela_uv + vec2(pixel.x, 0.0)).rgb;
	
	vec3 foco = (centro * 5.0) - cima - baixo - esq - dir;
	cor = mix(centro, foco, quant_nitidez);
	
	return cor;
}

vec3 color_grading(vec3 cor){
	if (grading_ligado == false){
		return cor;
	}
	
	float luminancia = dot(cor, vec3(0.2126, 0.7152, 0.0722)); // Representa o quão brilhante é um píxel (imagem preto e branco)
	cor = mix(vec3(luminancia), cor, saturacao); // 0 = preto e branco. 1 = orginal. > 1 = deepfried.
	
	// Tirando 0.5 faz com que o ponto central das cores seja um cinza entre preto e branco.
	// Multiplicando com esse ponto central faz as cores ficarem mais longe (>1) ou mais perto (<1) desse cinza.
	// Adicionando 0.5 faz a escala de cores voltar ao normal.
	// Adicionando um valor a todos (vermelho, verde, azul) faz a imagem ficar mais brilhante (>0) ou escura (<0).
	// Diminui o brilho para ele ficar menos exagerado (* 0.5).
	cor = (cor - 0.5) * contraste + 0.5 + (brilho * 0.5);
	
	return cor;
}

vec3 inversao(vec3 cor, vec2 resolucao_tela, vec2 tela_uv){
	
	// A resolução das telas de computador sempre é mais longa (x) do que alta (y)
	// por causa disso, para evitar com que o circulo se transforme num elipse
	// nós só precisisamos lidar com o x.
	vec2 resolucao = vec2(resolucao_tela.y / resolucao_tela.x, 1.);
	
	// Pegamos o UV da tela e subtraimos 0.5 para que o meio da imagem seja o (0,0)
	// Os valores agora vão de (-0,5,-0,5) até (0.5, 0.5).
	// Depois nós multiplicamos pela resolução da tela para que não seja um elipse
	// Finalmente, calculamos a distância do ponto em relação ao centro da imagem
	float distancia = distance((tela_uv - inversao_centro) * resolucao, vec2(0));
	
	float circulo = smoothstep(raio, raio - inversao_suavidade * 0.1, distancia);
	
	vec3 inversao = 1. - cor.rgb;
	
	return mix(cor.rgb, inversao, circulo);
}

vec4 vignette(vec3 cor, vec2 uv){
	if (vignette_ligado == false){
		return vec4(cor, 1.0);
	}
	
	vec2 uv_centralizado = 2. * uv - 1.; // Ponto central agora é o (0,0)
	
	// Distância do ponto central até o ponto atual.
	// (diminuindo a força do vignette para ele poder sair dos cantos da tela quando a intensidade for 0)
	float vignette = (length(uv_centralizado) * .78);
	vignette = smoothstep(1. - intensidade, (1. - intensidade) + vignette_suavidade, vignette);
	
	cor = mix(cor, cor_vignette.rgb, vignette);
	return vec4(cor, cor_vignette.a);
}

void fragment() {
	COLOR = texture(tela, SCREEN_UV);
	
	vec3 cor = nitidez(COLOR.rgb, SCREEN_PIXEL_SIZE, SCREEN_UV);
	cor = color_grading(cor);
	cor = inversao(cor, SCREEN_PIXEL_SIZE, SCREEN_UV);
	vec4 cor_final = vignette(cor, UV);
	
	COLOR = cor_final;
}
