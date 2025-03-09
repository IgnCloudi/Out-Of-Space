shader_type canvas_item;

uniform sampler2D noise_texture;
uniform vec2 noise_pan_speed = vec2(0.1, 0.1); // Adjust speed


void fragment() {
    vec2 uv = UV;

    // Move the noise texture
    vec2 panned_uv = UV + TIME * noise_pan_speed;

    // Sample the noise texture
    vec4 noise_color = texture(noise_texture, panned_uv);

    // Sample radial mask from the original UV
    float radial_mask = smoothstep(0.5, 1.0, length(uv - vec2(0.5)));

    // Apply the mask to the noise
    vec4 final_color = noise_color * (1.0 - radial_mask);

    COLOR = final_color;
}