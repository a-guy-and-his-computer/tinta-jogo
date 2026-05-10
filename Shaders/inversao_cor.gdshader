shader_type canvas_item;

void fragment() {
	COLOR.rgb = 1. - COLOR.rgb;
}