shader_type canvas_item;

uniform float mix_strength: hint_range(0.0, 1.0, 0.1);
uniform float modulate_strength: hint_range(0.0, 1.0, 0.1) = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 new_color = COLOR;
	float gray = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	gray *= modulate_strength;
	new_color = vec4(gray,gray,gray,COLOR.a);
	COLOR = mix(COLOR,new_color,mix_strength);
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
