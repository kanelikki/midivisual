// https://godotshaders.com/snippet/blending-modes/
shader_type canvas_item;
render_mode blend_add;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(COLOR.r, COLOR.g, COLOR.b, UV.y*.5);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
