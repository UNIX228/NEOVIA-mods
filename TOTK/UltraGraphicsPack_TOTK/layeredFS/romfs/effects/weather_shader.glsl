// Enhanced Weather Shader for TOTK
// Author: Unix228

#version 450

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;

layout(location = 0) out vec2 outTexCoord;
layout(location = 1) out vec3 outWorldPos;
layout(location = 2) out vec3 outNormal;

layout(set = 0, binding = 0) uniform CameraUBO {
    mat4 view;
    mat4 proj;
    vec3 cameraPos;
    float time;
} camera;

layout(set = 1, binding = 0) uniform ModelUBO {
    mat4 model;
} model;

layout(set = 2, binding = 0) uniform WeatherUBO {
    float rainIntensity;
    float fogDensity;
    float windStrength;
    vec3 fogColor;
    float lightningIntensity;
    float snowIntensity;
} weather;

void main() {
    vec4 worldPos = model.model * vec4(inPosition, 1.0);
    
    // Rain effect on vertices
    if (weather.rainIntensity > 0.0) {
        float rainOffset = sin(worldPos.x * 10.0 + camera.time * 2.0) * 
                          cos(worldPos.z * 8.0 + camera.time * 1.5) * 
                          weather.rainIntensity * 0.1;
        worldPos.y += rainOffset;
    }
    
    // Wind effect
    if (weather.windStrength > 0.0) {
        float windOffset = sin(camera.time * 0.5) * cos(worldPos.x * 0.1) * 
                          weather.windStrength * 0.05;
        worldPos.x += windOffset;
    }
    
    gl_Position = camera.proj * camera.view * worldPos;
    
    outTexCoord = inTexCoord;
    outWorldPos = worldPos.xyz;
    outNormal = mat3(model.model) * inNormal;
}

// Fragment shader
#version 450

layout(location = 0) in vec2 inTexCoord;
layout(location = 1) in vec3 inWorldPos;
layout(location = 2) in vec3 inNormal;

layout(location = 0) out vec4 outColor;

layout(set = 3, binding = 0) uniform sampler2D albedoMap;
layout(set = 3, binding = 1) uniform sampler2D normalMap;
layout(set = 3, binding = 2) uniform sampler2D roughnessMap;
layout(set = 3, binding = 3) uniform sampler2D metallicMap;

layout(set = 2, binding = 0) uniform WeatherUBO {
    float rainIntensity;
    float fogDensity;
    float windStrength;
    vec3 fogColor;
    float lightningIntensity;
    float snowIntensity;
} weather;

void main() {
    vec3 albedo = texture(albedoMap, inTexCoord).rgb;
    vec3 normal = normalize(texture(normalMap, inTexCoord).rgb * 2.0 - 1.0);
    float roughness = texture(roughnessMap, inTexCoord).r;
    float metallic = texture(metallicMap, inTexCoord).r;
    
    // Rain wetness effect
    if (weather.rainIntensity > 0.0) {
        float wetness = weather.rainIntensity;
        roughness = mix(roughness, 0.1, wetness);
        albedo = mix(albedo, albedo * 0.8, wetness * 0.3);
    }
    
    // Snow effect
    if (weather.snowIntensity > 0.0) {
        float snowCover = smoothstep(0.0, 0.5, weather.snowIntensity);
        vec3 snowColor = vec3(0.95, 0.95, 0.95);
        albedo = mix(albedo, snowColor, snowCover);
        roughness = mix(roughness, 0.2, snowCover);
    }
    
    // Lightning flash effect
    if (weather.lightningIntensity > 0.0) {
        vec3 lightningColor = vec3(1.0, 1.0, 0.8);
        albedo = mix(albedo, lightningColor, weather.lightningIntensity * 0.3);
    }
    
    // Enhanced fog
    float distance = length(inWorldPos - camera.cameraPos);
    float fogFactor = 1.0 - exp(-distance * weather.fogDensity);
    
    vec3 finalColor = albedo;
    finalColor = mix(finalColor, weather.fogColor, fogFactor);
    
    outColor = vec4(finalColor, 1.0);
}