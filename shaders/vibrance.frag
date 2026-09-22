// Saturation boost, applied compositor-side (works regardless of which GPU
// is driving the panel -- needed on hybrid laptops where the iGPU, not the
// NVIDIA GPU, scans out the internal display).
#version 300 es
precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

const float saturation = 2.20;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    float gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));
    pixColor.rgb = mix(vec3(gray), pixColor.rgb, saturation);
    fragColor = pixColor;
}
