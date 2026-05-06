shader_type canvas_item;

uniform float intens_geral: hint_range(0.0, 1.0) = 1.0;

uniform float quant_raios: hint_range(2.0, 16.0, 1.0) = 7.0;
uniform float tmnho_raio: hint_range(0.0, 1.0)  = 0.45;
uniform float veloc_raio: hint_range(0.0, 1.0)  = 0.04;
uniform float intens_raio: hint_range(0.0, 2.0)  = 0.9;

uniform float circulo: hint_range(0.0, 0.5)  = 0.257;
uniform float tmnho_brilho: hint_range(1.0, 20.0) = 5.0;
uniform float intens_brilho: hint_range(0.0, 3.0) = 1.4;

uniform vec4 cor_raio: source_color = vec4(1.0, 0.97, 0.80, 1.0);

void fragment() {
    vec2 uv_centralizado = UV - 0.5;
    float dist_do_centro  = length(uv_centralizado);
    float angulo = atan(uv_centralizado.y, uv_centralizado.x);

    float raio = cos(angulo * quant_raios + TIME * veloc_raio);
    raio = smoothstep(1.0 - tmnho_raio, 1.0, raio);

    float enfraquecer = smoothstep(0.5, circulo, dist_do_centro);

    float mascara_circulo = smoothstep(circulo - 0.015, circulo + 0.015, dist_do_centro);

    float brilho = exp(-dist_do_centro * tmnho_brilho) * intens_brilho;

    float alpha_raios = raio * enfraquecer * mascara_circulo * intens_raio;
    float total = clamp(alpha_raios + brilho * mascara_circulo, 0.0, 1.0);

    COLOR = vec4(cor_raio.rgb, total * intens_geral);
}