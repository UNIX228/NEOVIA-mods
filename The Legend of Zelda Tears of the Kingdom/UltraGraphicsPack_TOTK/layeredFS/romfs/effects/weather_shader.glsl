// Weather Shader for The Legend of Zelda: Tears of the Kingdom
// Author: Unix228
// Maximum graphics quality without overclocking

#version 450

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;

layout(set = 0, binding = 0) uniform Camera {
    mat4 view;
    mat4 proj;
    vec3 position;
    float time;
} camera;

layout(set = 1, binding = 0) uniform Model {
    mat4 model;
} model;

layout(set = 2, binding = 0) uniform Weather {
    float rainIntensity;
    float snowIntensity;
    float windStrength;
    float windDirection;
    float fogDensity;
    float lightningIntensity;
    float thunderIntensity;
} weather;

layout(location = 0) out vec2 outTexCoord;
layout(location = 1) out vec3 outWorldPos;
layout(location = 2) out vec3 outNormal;

void main() {
    vec4 worldPos = model.model * vec4(inPosition, 1.0);
    
    // Rain effect on vertices
    if (weather.rainIntensity > 0.0) {
        float rainOffset = sin(worldPos.x * 10.0 + camera.time * 2.0) * 
                          cos(worldPos.z * 8.0 + camera.time * 1.5) * 
                          weather.rainIntensity * 0.1;
        worldPos.y += rainOffset;
    }
    
    // Snow effect on vertices
    if (weather.snowIntensity > 0.0) {
        float snowOffset = sin(worldPos.x * 5.0 + camera.time * 0.5) * 
                          cos(worldPos.z * 6.0 + camera.time * 0.8) * 
                          weather.snowIntensity * 0.05;
        worldPos.y += snowOffset;
    }
    
    // Wind effect
    if (weather.windStrength > 0.0) {
        float windOffset = sin(camera.time * 0.5) * cos(worldPos.x * 0.1) * 
                          weather.windStrength * 0.05;
        worldPos.x += windOffset;
        
        // Wind direction variation
        float windDirOffset = cos(weather.windDirection) * sin(worldPos.z * 0.1) * 
                             weather.windStrength * 0.03;
        worldPos.z += windDirOffset;
    }
    
    gl_Position = camera.proj * camera.view * worldPos;
    outTexCoord = inTexCoord;
    outWorldPos = worldPos.xyz;
    outNormal = mat3(model.model) * inNormal;
}