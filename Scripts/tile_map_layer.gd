extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pegar_tamanho_nivel_pixels()
	print(pegar_tamanho_nivel_pixels())


func pegar_tamanho_nivel_pixels():
	var tamanho_da_tile = tile_set.tile_size
	var area_usada_nivel = get_used_rect()
	var tamanho_do_nivel_pixels = area_usada_nivel.size * tamanho_da_tile
	
	print(tamanho_do_nivel_pixels)
	
	return tamanho_do_nivel_pixels;
