// Enhanced Lighting Shader for TOTK
// Author: Unix228

#include "common.h"

struct Light {
    float3 position;
    float3 direction;
    float3 color;
    float intensity;
    float range;
    float type; // 0 = directional, 1 = point, 2 = spot
};

cbuffer LightingCB : register(b0) {
    Light lights[4];
    float3 ambientColor;
    float ambientIntensity;
    float3 fogColor;
    float fogDensity;
    float3 sunDirection;
    float sunIntensity;
}

// Enhanced PBR lighting calculation
float3 CalculateLighting(float3 worldPos, float3 normal, float3 albedo, float metallic, float roughness) {
    float3 N = normalize(normal);
    float3 V = normalize(cameraPos - worldPos);
    float3 F0 = lerp(0.04, albedo, metallic);
    
    float3 Lo = 0;
    
    // Directional light (sun)
    float3 L = normalize(-sunDirection);
    float3 H = normalize(V + L);
    float NdotL = max(dot(N, L), 0.0);
    float NdotH = max(dot(N, H), 0.0);
    float NdotV = max(dot(N, V), 0.0);
    
    // Cook-Torrance BRDF
    float D = DistributionGGX(NdotH, roughness);
    float G = GeometrySmith(NdotV, NdotL, roughness);
    float3 F = FresnelSchlick(max(dot(H, V), 0.0), F0);
    
    float3 numerator = D * G * F;
    float denominator = 4.0 * NdotV * NdotL + 0.0001;
    float3 specular = numerator / denominator;
    
    float3 kS = F;
    float3 kD = (1.0 - kS) * (1.0 - metallic);
    
    Lo += (kD * albedo / PI + specular) * sunIntensity * NdotL;
    
    // Point lights
    for (int i = 0; i < 4; i++) {
        if (lights[i].type == 1) { // Point light
            float3 L = normalize(lights[i].position - worldPos);
            float distance = length(lights[i].position - worldPos);
            float attenuation = 1.0 / (1.0 + distance * distance / (lights[i].range * lights[i].range));
            
            float NdotL = max(dot(N, L), 0.0);
            if (NdotL > 0.0) {
                float3 H = normalize(V + L);
                float NdotH = max(dot(N, H), 0.0);
                
                float D = DistributionGGX(NdotH, roughness);
                float G = GeometrySmith(NdotV, NdotL, roughness);
                float3 F = FresnelSchlick(max(dot(H, V), 0.0), F0);
                
                float3 numerator = D * G * F;
                float denominator = 4.0 * NdotV * NdotL + 0.0001;
                float3 specular = numerator / denominator;
                
                float3 kS = F;
                float3 kD = (1.0 - kS) * (1.0 - metallic);
                
                Lo += (kD * albedo / PI + specular) * lights[i].color * lights[i].intensity * attenuation * NdotL;
            }
        }
    }
    
    // Ambient lighting
    float3 ambient = ambientColor * ambientIntensity * albedo;
    
    return ambient + Lo;
}

// Enhanced fog calculation
float3 ApplyFog(float3 color, float3 worldPos) {
    float distance = length(cameraPos - worldPos);
    float fogFactor = 1.0 - exp(-distance * fogDensity);
    return lerp(color, fogColor, fogFactor);
}