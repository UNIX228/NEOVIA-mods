# Enhanced Lighting Shader for DELTARUNE

// PBR Lighting with enhanced effects for DELTARUNE
float3 CalculateLighting(float3 worldPos, float3 normal, float3 albedo, float metallic, float roughness) {
    // Enhanced PBR lighting calculation
    float3 lightDir = normalize(float3(1.0, 1.0, 0.5));
    float3 viewDir = normalize(cameraPos - worldPos);
    float3 halfDir = normalize(lightDir + viewDir);
    
    // Enhanced ambient lighting
    float3 ambient = albedo * 0.3;
    
    // Enhanced diffuse lighting
    float NdotL = max(dot(normal, lightDir), 0.0);
    float3 diffuse = albedo * NdotL;
    
    // Enhanced specular lighting with Cook-Torrance BRDF
    float NdotH = max(dot(normal, halfDir), 0.0);
    float NdotV = max(dot(normal, viewDir), 0.0);
    float HdotL = max(dot(halfDir, lightDir), 0.0);
    
    // Enhanced specular calculation
    float3 specular = CalculateSpecular(NdotH, NdotV, HdotL, roughness, metallic);
    
    return ambient + diffuse + specular;
}

// Enhanced specular calculation for DELTARUNE
float3 CalculateSpecular(float NdotH, float NdotV, float HdotL, float roughness, float metallic) {
    // Enhanced Cook-Torrance BRDF implementation
    float alpha = roughness * roughness;
    float D = DistributionGGX(NdotH, alpha);
    float G = GeometrySmith(NdotV, NdotL, alpha);
    float F = FresnelSchlick(max(dot(halfDir, viewDir), 0.0), F0);
    
    float3 numerator = D * G * F;
    float denominator = 4.0 * NdotV * NdotL + 0.0001;
    float3 specular = numerator / denominator;
    
    return specular * metallic;
}

// GGX Distribution function
float DistributionGGX(float NdotH, float alpha) {
    float alpha2 = alpha * alpha;
    float denom = NdotH * NdotH * (alpha2 - 1.0) + 1.0;
    return alpha2 / (PI * denom * denom);
}

// Smith's Geometry function
float GeometrySmith(float NdotV, float NdotL, float alpha) {
    return GeometrySchlickGGX(NdotV, alpha) * GeometrySchlickGGX(NdotL, alpha);
}

float GeometrySchlickGGX(float NdotV, float alpha) {
    float r = (alpha + 1.0) / 2.0;
    float k = r * r / 8.0;
    float nom = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    return nom / denom;
}

// Fresnel function
float3 FresnelSchlick(float cosTheta, float3 F0) {
    return F0 + (1.0 - F0) * pow(clamp(1.0 - cosTheta, 0.0, 1.0), 5.0);
}
