#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

// MARK: - Noise Functions

float noise1(float seed1, float seed2) {
    return (fract(seed1 + 12.34567 * 
                  fract(100.0 * (abs(seed1 * 0.91) + seed2 + 94.68) * 
                        fract((abs(seed2 * 0.41) + 45.46) * 
                              fract((abs(seed2) + 757.21) * 
                                    fract(seed1 * 0.0171))))))
           * 1.0038 - 0.00185;
}

float noise2(float seed1, float seed2, float seed3) {
    float buff1 = abs(seed1 + 100.81) + 1000.3;
    float buff2 = abs(seed2 + 100.45) + 1000.2;
    float buff3 = abs(noise1(seed1, seed2) + seed3) + 1000.1;
    buff1 = (buff3 * fract(buff2 * fract(buff1 * fract(buff2 * 0.146))));
    buff2 = (buff2 * fract(buff2 * fract(buff1 + buff2 * fract(buff3 * 0.52))));
    buff1 = noise1(buff1, buff2);
    return buff1;
}

float noise3(float seed1, float seed2, float seed3) {
    float buff1 = abs(seed1 + 100.813) + 1000.314;
    float buff2 = abs(seed2 + 100.453) + 1000.213;
    float buff3 = abs(noise1(buff2, buff1) + seed3) + 1000.17;
    buff1 = (buff3 * fract(buff2 * fract(buff1 * fract(buff2 * 0.14619))));
    buff2 = (buff2 * fract(buff2 * fract(buff1 + buff2 * fract(buff3 * 0.5215))));
    buff1 = noise2(noise1(seed2, buff1), noise1(seed1, buff2), noise1(seed3, buff3));
    return buff1;
}

// MARK: - Gradient Shader

[[ stitchable ]] half4 animatedGradient(float2 position, half4 currentColor, float time, float2 size, float page) {
    float2 st = position / size;
    
    // Domain warping
    st.x += (sin(time / 2.1) + 2.0) * 0.12 * sin(sin(st.y * st.x + time / 6.0) * 8.2);
    st.y -= (cos(time / 1.73) + 2.0) * 0.12 * cos(st.x * st.y * 5.1 - time / 4.0);
    
    float3 bg = float3(0.0);
    
    // Color palettes for each page
    float3 color1, color2, color3, color4, color5;
    int pageIndex = int(page);
    
    if (pageIndex == 0) {
        // Sunset
        color1 = float3(252.0/255.0, 60.0/255.0, 0.0/255.0);
        color2 = float3(253.0/255.0, 0.0/255.0, 12.0/255.0);
        color3 = float3(26.0/255.0, 0.5/255.0, 6.0/255.0);
        color4 = float3(128.0/255.0, 0.0/255.0, 17.0/255.0);
        color5 = float3(255.0/255.0, 15.0/255.0, 8.0/255.0);
    } else if (pageIndex == 1) {
        // Ocean
        color1 = float3(183.0/255.0, 246.0/255.0, 254.0/255.0);
        color2 = float3(50.0/255.0, 160.0/255.0, 251.0/255.0);
        color3 = float3(3.0/255.0, 79.0/255.0, 231.0/255.0);
        color4 = float3(1.0/255.0, 49.0/255.0, 161.0/255.0);
        color5 = float3(3.0/255.0, 12.0/255.0, 47.0/255.0);
    } else if (pageIndex == 2) {
        // Lagoon
        color1 = float3(102.0/255.0, 231.0/255.0, 255.0/255.0);
        color2 = float3(4.0/255.0, 207.0/255.0, 213.0/255.0);
        color3 = float3(0.0/255.0, 160.0/255.0, 119.0/255.0);
        color4 = float3(0.0/255.0, 175.0/255.0, 139.0/255.0);
        color5 = float3(2.0/255.0, 37.0/255.0, 27.0/255.0);
    } else {
        // Neon
        color1 = float3(255.0/255.0, 50.0/255.0, 134.0/255.0);
        color2 = float3(236.0/255.0, 18.0/255.0, 60.0/255.0);
        color3 = float3(178.0/255.0, 254.0/255.0, 0.0/255.0);
        color4 = float3(0.0/255.0, 248.0/255.0, 209.0/255.0);
        color5 = float3(0.0/255.0, 186.0/255.0, 255.0/255.0);
    }
    
    // Build gradient with multiple animated circles
    float mixValue = smoothstep(0.0, 0.8, distance(st, float2(sin(time / 5.0) + 0.5, sin(time / 6.1) + 0.5)));
    float3 outColor = mix(color1, bg, mixValue);
    
    mixValue = smoothstep(0.1, 0.9, distance(st, float2(sin(time / 3.94) + 0.7, sin(time / 4.2) - 0.1)));
    outColor = mix(color2, outColor, mixValue);
    
    mixValue = smoothstep(0.1, 0.8, distance(st, float2(sin(time / 3.43) + 0.2, sin(time / 3.2) + 0.45)));
    outColor = mix(color3, outColor, mixValue);
    
    mixValue = smoothstep(0.14, 0.89, distance(st, float2(sin(time / 5.4) - 0.3, sin(time / 5.7) + 0.7)));
    outColor = mix(color4, outColor, mixValue);
    
    mixValue = smoothstep(0.01, 0.89, distance(st, float2(sin(time / 9.5) + 0.23, sin(time / 3.95) + 0.23)));
    outColor = mix(color5, outColor, mixValue);
    
    mixValue = smoothstep(0.01, 0.89, distance(st, float2(cos(time / 8.5) / 2.0 + 0.13, sin(time / 4.95) - 0.23)));
    outColor = mix(color1, outColor, mixValue);
    
    mixValue = smoothstep(0.1, 0.9, distance(st, float2(cos(time / 6.94) / 2.0 + 0.7, sin(time / 4.112) + 0.66)));
    outColor = mix(color2, outColor, mixValue);
    
    mixValue = smoothstep(0.1, 0.8, distance(st, float2(cos(time / 4.43) / 2.0 + 0.2, sin(time / 6.2) + 0.85)));
    outColor = mix(color3, outColor, mixValue);
    
    mixValue = smoothstep(0.14, 0.89, distance(st, float2(cos(time / 10.4) / 2.0 - 0.3, sin(time / 5.7) + 0.8)));
    outColor = mix(color4, outColor, mixValue);
    
    mixValue = smoothstep(0.01, 0.89, distance(st, float2(cos(time / 4.5) / 2.0 + 0.63, sin(time / 4.95) + 0.93)));
    outColor = mix(color5, outColor, mixValue);
    
    // Add noise texture
    float2 st_unwarped = position / size;
    float3 noise = float3(noise3(st_unwarped.x * 0.000001, st_unwarped.y * 0.000001, time * 1e-15));
    outColor = (outColor * 0.85) - (noise * 0.1);
    
    return half4(half3(outColor), 1.0);
}

