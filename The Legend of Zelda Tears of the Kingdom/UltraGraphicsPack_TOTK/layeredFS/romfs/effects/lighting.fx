// Enhanced Lighting Shader for The Legend of Zelda: Tears of the Kingdom
// Author: Unix228
// Maximum graphics quality without overclocking

#include "common.h"

struct Light {
    float3 position;
    float3 direction;
    float3 color;
    float intensity;
    float range;
    float type;
};

cbuffer LightingCB : register(b0) {
    Light lights[8];
    float3 ambientColor;
    float ambientIntensity;
    float3 fogColor;
    float fogDensity;
    float3 sunDirection;
    float sunIntensity;
    float3 moonDirection;
    float moonIntensity;
    float timeOfDay;
    float3 worldOrigin;
    float worldSize;
}

// Enhanced PBR lighting calculation for TOTK
float3 CalculateLighting(float3 worldPos, float3 normal, float3 albedo, float metallic, float roughness) {
    float3 N = normalize(normal);
    float3 V = normalize(cameraPos - worldPos);
    float3 F0 = lerp(0.04, albedo, metallic);
    
    float3 Lo = 0;
    
    // Dynamic sun/moon lighting based on time of day
    float3 sunL = normalize(-sunDirection);
    float3 moonL = normalize(-moonDirection);
    
    float sunDot = max(dot(N, sunL), 0.0);
    float moonDot = max(dot(N, moonL), 0.0);
    
    // Day lighting with enhanced sun
    if (timeOfDay > 0.2 && timeOfDay < 0.8) {
        float3 H = normalize(V + sunL);
        float NdotH = max(dot(N, H), 0.0);
        float NdotV = max(dot(N, V), 0.0);
        
        // Enhanced Cook-Torrance BRDF
        float D = DistributionGGX(NdotH, roughness);
        float G = GeometrySmith(NdotV, sunDot, roughness);
        float3 F = FresnelSchlick(max(dot(H, V), 0.0), F0);
        
        float3 numerator = D * G * F;
        float denominator = 4.0 * NdotV * sunDot + 0.0001;
        float3 specular = numerator / denominator;
        
        float3 kS = F;
        float3 kD = (1.0 - kS) * (1.0 - metallic);
        
        // Enhanced sun intensity with atmospheric scattering
        float sunIntensityEnhanced = sunIntensity * (1.0 + sin(timeOfDay * PI * 2.0) * 0.3);
        Lo += (kD * albedo / PI + specular) * sunIntensityEnhanced * sunDot;
    }
    
    // Night lighting with enhanced moon
    if (timeOfDay < 0.2 || timeOfDay > 0.8) {
        float3 H = normalize(V + moonL);
        float NdotH = max(dot(N, H), 0.0);
        float NdotV = max(dot(N, V), 0.0);
        
        float D = DistributionGGX(NdotH, roughness);
        float G = GeometrySmith(NdotV, moonDot, roughness);
        float3 F = FresnelSchlick(max(dot(H, V), 0.0), F0);
        
        float3 numerator = D * G * F;
        float denominator = 4.0 * NdotV * moonDot + 0.0001;
        float3 specular = numerator / denominator;
        
        float3 kS = F;
        float3 kD = (1.0 - kS) * (1.0 - metallic);
        
        // Enhanced moon intensity with stars reflection
        float moonIntensityEnhanced = moonIntensity * (1.0 + cos(timeOfDay * PI * 2.0) * 0.5);
        Lo += (kD * albedo / PI + specular) * moonIntensityEnhanced * moonDot;
    }
    
    // Point lights (torches, magic, etc.)
    for (int i = 0; i < 8; i++) {
        if (lights[i].type == 1) {
            float3 L = normalize(lights[i].position - worldPos);
            float distance = length(lights[i].position - worldPos);
            float attenuation = 1.0 / (1.0 + distance * distance / (lights[i].range * lights[i].range));
            
            float NdotL = max(dot(N, L), 0.0);
            if (NdotL > 0.0) {
                float3 H = normalize(V + L);
                float NdotH = max(dot(N, H), 0.0);
                float NdotV = max(dot(N, V), 0.0);
                
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
    
    // Enhanced ambient lighting
    float3 ambient = ambientColor * ambientIntensity * albedo;
    
    return ambient + Lo;
}

// Enhanced fog with atmospheric scattering
float3 ApplyFog(float3 color, float3 worldPos) {
    float distance = length(cameraPos - worldPos);
    float fogFactor = 1.0 - exp(-distance * fogDensity);
    
    // Time-based fog color variation
    float3 fogColorFinal = fogColor;
    if (timeOfDay > 0.2 && timeOfDay < 0.8) {
        fogColorFinal = lerp(fogColor, float3(0.8, 0.9, 1.0), 0.3);
    } else if (timeOfDay < 0.2) {
        fogColorFinal = lerp(fogColor, float3(0.2, 0.3, 0.5), 0.5);
    } else if (timeOfDay > 0.8) {
        fogColorFinal = lerp(fogColor, float3(0.1, 0.2, 0.4), 0.7);
    }
    
    return lerp(color, fogColorFinal, fogFactor);
}