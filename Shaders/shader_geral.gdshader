shader_type canvas_item;

group_uniforms Nitidez;
uniform bool nitidez_ligado;
uniform vec2 tamanho_tela_px = vec2(640.0, 360.0); // tamanho do sprite renderizado em pixels de tela
uniform float quant_nitidez: hint_range(0.0, 3.0) = 0.362;

group_uniforms Color_Grading;
uniform bool grading_ligado;
uniform float brilho: hint_range(-1.0, 1.0) = 0.0;
uniform float contraste: hint_range(0.0, 3.0)  = 1.0;
uniform float saturacao: hint_range(0.0, 3.0)  = 1.0;

group_uniforms Noite;
uniform bool noite_ligada;
uniform float intens_noite: hint_range(0.0, 1.0) = 0.0;
uniform vec4 cor_noite: source_color = vec4(0.1, 0.1, 0.53, 0.66);

group_uniforms Azulagem;
uniform bool azul_dia_ligado;
uniform bool azul_noite_ligado;
uniform float intens_azul_dia = 0.5;
uniform float intens_azul_noite = 0.5;
uniform vec4 azulagem_dia: source_color = vec4(0.65, 0.8, 1.0, 1.0);
uniform vec4 azulagem_noite: source_color = vec4(0.05, 0.1, 0.2, 1.0);

group_uniforms Inversao_De_Cores;
uniform bool inversao_ligada;

group_uniforms Vignette;
uniform bool vignette_ligado;
uniform float intensidade: hint_range(0.0, 1.0) = 0; // Melhor efeito = 0.512
uniform float suavidade: hint_range(0.0, 1.0) = 1.; // Melhor efeito = 0.914
uniform vec4 cor_vignette: source_color = vec4(0.0, 0.0, 0.0, 1.0); // Preto

vec3 nitidez(vec3 cor, sampler2D textura, vec2 textura_uv){
	if (nitidez_ligado == false){
		return cor;
	}
	
	// Converte pixel de tela para offset em UV da textura
	vec2 pixel = 1.0 / tamanho_tela_px;
	
	// Nitidez funciona pegando o pixel central, multiplicando por 5,
	// e depois subtraindo pelo valor dos 4 vizinhos.
	// Se o pixel for mais brilhante que os seus vizinhos, ele fica ainda mais brilhante.
	vec3 centro = texture(textura, textura_uv).rgb;
	vec3 cima = texture(textura, textura_uv + vec2(0.0, -pixel.y)).rgb;
	vec3 baixo = texture(textura, textura_uv + vec2(0.0, pixel.y)).rgb;
	vec3 esq = texture(textura, textura_uv + vec2(-pixel.x, 0.0)).rgb;
	vec3 dir = texture(textura, textura_uv + vec2(pixel.x, 0.0)).rgb;
	
	vec3 foco = (centro * 5.0) - cima - baixo - esq - dir;
	cor = mix(centro, foco, quant_nitidez * 0.1);
	
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

vec4 noite(vec4 cor){
	if (noite_ligada == false){
		return cor;
	}
	
	// Escurece
	cor.rgb *= mix(1.0, 0.45, intens_noite);
	
	// Remove um pouco da saturação
	float luminancia = dot(cor.rgb, vec3(0.2126, 0.7152, 0.0722));
	cor.rgb = mix(cor.rgb, vec3(luminancia), intens_noite * 0.35);
	
	// Adiciona tonalidade azulada
	cor.rgb = mix(cor.rgb, cor.rgb * cor_noite.rgb, intens_noite * 0.5);
	
	return cor;
}

vec4 azulagem(vec4 cor){
	if (azul_dia_ligado == true){
		cor.rgb = mix(cor.rgb, azulagem_dia.rgb, intens_azul_dia * 0.1);
	}
	
	else if (azul_dia_ligado == false && azul_noite_ligado == true){
		cor.rgb = mix(cor.rgb, azulagem_noite.rgb, intens_azul_noite * 0.1);
	}
	
	return cor;
}

vec4 vignette(vec4 cor, vec2 uv){
	if (vignette_ligado == false){
		return cor;
	}
	
	vec2 uv_centralizado = 2. * uv - 1.; // Ponto central agora é o (0,0)
	
	// Distância do ponto central até o ponto atual.
	// (diminuindo a força do vignette para ele poder sair dos cantos da tela quando a intensidade for 0)
	float vignette = (length(uv_centralizado) * .78);
	vignette = smoothstep(1. - intensidade, (1. - intensidade) + suavidade, vignette);
	
	cor = mix(cor, cor_vignette, vignette);
	return cor;
}

void fragment() {
	float alpha = COLOR.a;
	
	vec3 cor = nitidez(COLOR.rgb, TEXTURE, UV);
	cor = color_grading(cor);
	
	if (inversao_ligada){
		cor = 1. - cor;
	}
	
	vec4 cor_com_alpha = noite(vec4(cor, alpha));
	vec4 cor_final = azulagem(cor_com_alpha);
	cor_final = vignette(cor_final, UV);
	
	COLOR = vec4(cor_final.rgb, cor_final.a);
	
}
