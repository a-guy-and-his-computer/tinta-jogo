shader_type canvas_item;

uniform sampler2D tela: hint_screen_texture;

group_uniforms Nitidez;
uniform bool nitidez_ligado;
uniform float quant_nitidez: hint_range(0.0, 3.0) = 0.0;

group_uniforms Color_Grading;
uniform bool grading_ligado;
uniform float brilho: hint_range(-1.0, 1.0) = 0.0;
uniform float contraste: hint_range(0.0, 3.0)  = 1.0;
uniform float saturacao: hint_range(0.0, 3.0)  = 1.0;

group_uniforms Vignette;
uniform bool vignette_ligado;
uniform float intensidade: hint_range(0.0, 1.0) = 0; // Melhor efeito = 0.512
uniform float suavidade: hint_range(0.0, 1.0) = 1.; // Melhor efeito = 0.914
uniform vec4 cor_vignette: source_color = vec4(0.0, 0.0, 0.0, 1.0); // Preto

void vertex() {
	// Called for every vertex the material is visible on.
}

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

vec4 vignette(vec3 cor, vec2 uv){
	if (vignette_ligado == false){
		return vec4(cor, 1.0);
	}
	
	vec2 uv_centralizado = 2. * uv - 1.; // Ponto central agora é o (0,0)
	
	// Distância do ponto central até o ponto atual.
	// (diminuindo a força do vignette para ele poder sair dos cantos da tela quando a intensidade for 0)
	float vignette = (length(uv_centralizado) * .78);
	vignette = smoothstep(1. - intensidade, (1. - intensidade) + suavidade, vignette);
	
	cor = mix(cor, cor_vignette.rgb, vignette);
	return vec4(cor, cor_vignette.a);
}

void fragment() {
	COLOR = texture(tela, SCREEN_UV);
	
	vec3 cor = nitidez(COLOR.rgb, SCREEN_PIXEL_SIZE, SCREEN_UV);
	cor = color_grading(cor);
	vec4 cor_final = vignette(cor, UV);
	
	COLOR = cor_final;
}
