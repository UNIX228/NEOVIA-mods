// Enhanced Particle System for BAYO3
// Author: Unix228

#include "common.h"

struct Particle {
    float3 position;
    float3 velocity;
    float3 color;
    float size;
    float life;
    float maxLife;
    float type;
};

cbuffer ParticleCB : register(b0) {
    Particle particles[1024];
    float3 cameraPos;
    float deltaTime;
    float3 gravity;
    float windStrength;
    float3 windDirection;
    float particleScale;
    float bloomIntensity;
}

// Enhanced particle rendering
float4 RenderParticle(float3 worldPos, float3 velocity, float3 color, float size, float life, float maxLife) {
    float3 N = normalize(cameraPos - worldPos);
    float3 V = normalize(cameraPos - worldPos);
    
    // Particle animation
    float3 animatedPos = worldPos + velocity * deltaTime;
    
    // Gravity effect
    animatedPos += gravity * deltaTime * deltaTime * 0.5;
    
    // Wind effect
    animatedPos += windDirection * windStrength * deltaTime;
    
    // Life-based scaling
    float lifeRatio = life / maxLife;
    float currentSize = size * (1.0 - lifeRatio * 0.5);
    
    // Enhanced color based on life
    float3 enhancedColor = color;
    
    // Fire particles
    if (particleType == 0) {
        enhancedColor = lerp(color, vec3(1.0, 0.3, 0.0), lifeRatio);
        enhancedColor *= 1.0 + sin(life * 10.0) * 0.3;
    }
    
    // Magic particles
    if (particleType == 1) {
        enhancedColor = lerp(color, vec3(0.5, 0.8, 1.0), lifeRatio);
        enhancedColor *= 1.0 + cos(life * 8.0) * 0.2;
    }
    
    // Blood particles
    if (particleType == 2) {
        enhancedColor = lerp(color, vec3(0.8, 0.1, 0.1), lifeRatio);
    }
    
    // Explosion particles
    if (particleType == 3) {
        enhancedColor = lerp(color, vec3(1.0, 0.6, 0.0), lifeRatio);
        enhancedColor *= 1.0 + sin(life * 15.0) * 0.5;
    }
    
    // Bloom effect
    float bloomFactor = bloomIntensity * (1.0 - lifeRatio);
    enhancedColor += bloomFactor * enhancedColor;
    
    // Alpha blending
    float alpha = 1.0 - lifeRatio;
    alpha = smoothstep(0.0, 1.0, alpha);
    
    return float4(enhancedColor, alpha);
}

// Particle physics simulation
void UpdateParticle(inout Particle particle) {
    // Update position
    particle.position += particle.velocity * deltaTime;
    
    // Apply gravity
    particle.velocity += gravity * deltaTime;
    
    // Apply wind
    particle.velocity += windDirection * windStrength * deltaTime;
    
    // Update life
    particle.life -= deltaTime;
    
    // Size variation
    particle.size *= 1.0 - deltaTime * 0.1;
    
    // Color fade
    particle.color *= 1.0 - deltaTime * 0.05;
}

// Enhanced particle trail effect
float3 CalculateTrail(float3 position, float3 velocity, float life) {
    float3 trail = 0;
    
    // Motion blur trail
    float trailLength = length(velocity) * 0.1;
    float3 trailDir = normalize(velocity);
    
    for (int i = 0; i < 5; i++) {
        float t = float(i) / 5.0;
        float3 trailPos = position - trailDir * trailLength * t;
        float trailAlpha = (1.0 - t) * life;
        
        trail += CalculateTrailColor(trailPos, trailAlpha);
    }
    
    return trail;
}