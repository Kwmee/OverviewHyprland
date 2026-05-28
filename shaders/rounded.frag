#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float radius;
};

layout(binding = 1) uniform sampler2D source;

// Signed distance function para rectangulo redondeado
float roundedBoxSDF(vec2 pos, vec2 size, float r) {
    vec2 q = abs(pos) - size + r;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void main() {
    vec2 uv = qt_TexCoord0;
    vec2 pos = uv - 0.5;

    // Normalizar segun el aspect ratio del fragmento
    // Asumimos que el item ya gestiona el aspect ratio
    float dist = roundedBoxSDF(pos, vec2(0.5), radius / 200.0);

    float alpha = 1.0 - smoothstep(-0.002, 0.002, dist);
    fragColor = texture(source, uv) * alpha * qt_Opacity;
}
