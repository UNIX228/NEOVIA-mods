// Enhanced Lighting Shader for SMO
// Author: Unix228

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
    Light lights[6];
    float3 ambientColor;
    float ambientIntensity;
    float3 fogColor;
    float fogDensity;
    float3 sunDirection;
    float sunIntensity;
    float3 moonDirection;
    float moonIntensity;
    float timeOfDay;
    float3 worldColor;
    float worldIntensity;
}

// Enhanced lighting calculation for SMO
float3 CalculateLighting(float3 worldPos, float3 normal, float3 albedo, float metallic, float roughness) {
    float3 N = normalize(normal);
    float3 V = normalize(cameraPos - worldPos);
    float3 F0 = lerp(0.04, albedo, metallic);
    
    float3 Lo = 0;
    
    // World-specific lighting (different kingdoms have different lighting)
    float3 worldLight = worldColor * worldIntensity;
    
    // Dynamic sun/moon lighting based on time of day
    float3 sunL = normalize(-sunDirection);
    float3 moonL = normalize(-moonDirection);
    
    float sunDot = max(dot(N, sunL), 0.0);
    float moonDot = max(dot(N, moonL), 0.0);
    
    // Day lighting
    if (timeOfDay > 0.2 && timeOfDay < 0.8) {
        float3 H = normalize(V + sunL);
        float NdotH = max(dot(N, H), 0.0);
        float NdotV = max(dot(N, V), 0.0);
        
        // Cook-Torrance BRDF
        float D = DistributionGGX(NdotH, roughness);
        float G = GeometrySmith(NdotV, sunDot, roughness);
        float3 F = FresnelSchlick(max(dot(H, V), 0.0), F0);
        
        float3 numerator = D * G * F;
        float denominator = 4.0 * NdotV * sunDot + 0.0001;
        float3 specular = numerator / denominator;
        
        float3 kS = F;
        float3 kD = (1.0 - kS) * (1.0 - metallic);
        
        Lo += (kD * albedo / PI + specular) * sunIntensity * sunDot;
    }
    
    // Night lighting
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
        
        Lo += (kD * albedo / PI + specular) * moonIntensity * moonDot;
    }
    
    // Point lights (lamps, power moons, etc.)
    for (int i = 0; i < 6; i++) {
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
    
    // World-specific ambient lighting
    float3 ambient = ambientColor * ambientIntensity * albedo + worldLight * albedo;
    
    return ambient + Lo;
}

// Enhanced fog with world-specific colors
float3 ApplyFog(float3 color, float3 worldPos) {
    float distance = length(cameraPos - worldPos);
    float fogFactor = 1.0 - exp(-distance * fogDensity);
    
    // World-specific fog colors
    float3 capFog = vec3(0.8, 0.9, 1.0);      // Cap Kingdom
    float3 cascadeFog = vec3(0.6, 0.8, 0.9);   // Cascade Kingdom
    float3 sandFog = vec3(0.9, 0.8, 0.6);      // Sand Kingdom
    float3 lakeFog = vec3(0.7, 0.8, 0.9);      // Lake Kingdom
    float3 woodedFog = vec3(0.6, 0.7, 0.5);    // Wooded Kingdom
    float3 cloudFog = vec3(0.9, 0.9, 0.9);     // Cloud Kingdom
    float3 lostFog = vec3(0.3, 0.3, 0.4);      // Lost Kingdom
    float3 metroFog = vec3(0.4, 0.4, 0.5);     // Metro Kingdom
    float3 snowFog = vec3(0.9, 0.9, 0.95);     // Snow Kingdom
    float3 seasideFog = vec3(0.7, 0.8, 0.9);   // Seaside Kingdom
    float3 luncheonFog = vec3(0.8, 0.6, 0.5);  // Luncheon Kingdom
    float3 ruinedFog = vec3(0.5, 0.4, 0.3);    // Ruined Kingdom
    float3 bowserFog = vec3(0.3, 0.2, 0.4);    // Bowser's Kingdom
    float3 moonFog = vec3(0.1, 0.1, 0.2);      // Moon Kingdom
    float3 mushroomFog = vec3(0.8, 0.7, 0.8);  // Mushroom Kingdom
    
    float3 fogColorFinal = fogColor;
    
    // Select fog color based on world
    if (worldType == 0) fogColorFinal = capFog;
    else if (worldType == 1) fogColorFinal = cascadeFog;
    else if (worldType == 2) fogColorFinal = sandFog;
    else if (worldType == 3) fogColorFinal = lakeFog;
    else if (worldType == 4) fogColorFinal = woodedFog;
    else if (worldType == 5) fogColorFinal = cloudFog;
    else if (worldType == 6) fogColorFinal = lostFog;
    else if (worldType == 7) fogColorFinal = metroFog;
    else if (worldType == 8) fogColorFinal = snowFog;
    else if (worldType == 9) fogColorFinal = seasideFog;
    else if (worldType == 10) fogColorFinal = luncheonFog;
    else if (worldType == 11) fogColorFinal = ruinedFog;
    else if (worldType == 12) fogColorFinal = bowserFog;
    else if (worldType == 13) fogColorFinal = moonFog;
    else if (worldType == 14) fogColorFinal = mushroomFog;
    
    return lerp(color, fogColorFinal, fogFactor);
}