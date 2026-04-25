shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float desfoque_quant = 2.0;
uniform float opacidade: hint_range(0.0, 1.0);

void fragment() {
    vec2 texel = SCREEN_PIXEL_SIZE * desfoque_quant;

    vec4 blur = vec4(0.0);
	
	// Blur horizontal da tela atrás do sprite

    blur += texture(screen_texture, SCREEN_UV + vec2(-texel.x, 0.0));
    blur += texture(screen_texture, SCREEN_UV);
    blur += texture(screen_texture, SCREEN_UV + vec2(texel.x, 0.0));

    blur /= 3.0;
	
	vec4 base = texture(TEXTURE, UV);
	
	COLOR = mix(base, blur, opacidade * base.a);
}