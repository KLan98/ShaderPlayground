Shader "Unlit/HemiLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
        GLSLPROGRAM

            #ifdef VERTEX

            varying vec3 vNormal;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                vNormal = normalize(gl_NormalMatrix * gl_Normal); // transform the normals from object space into view (camera) space so it can be used correctly for lighting in the fragment shader.
            }

            #endif

            #ifdef FRAGMENT
            varying vec3 vNormal;

            float inverseLerp(float value, float min, float max)
            {
                return (value - min)/(max-min);
            }

            float remap(float value, float inMin, float inMax, float outMin, float outMax)
            {
                float t = inverseLerp(value, inMin, inMax);
                return mix(outMin, outMax, t);
            }

            void main()
            {
                vec3 baseColor = vec3(0.5);
                vec3 lighting = vec3(1.0); 
                vec3 SKY_COLOUR = vec3(0.2, 0.5, 1.0);
                vec3 GROUND_COLOUR = vec3(0.3, 0.15, 0.025);

                // AmbientLight
                vec3 ambient = vec3(0.3);

                vec3 outputColor = baseColor * lighting;

                float hemiMix = remap(vNormal.y, -1.0, 1.0, 0.0, 1.0);

                vec3 hemiLight = mix(SKY_COLOUR, GROUND_COLOUR, hemiMix);

                // the nature of lighting is addictive
                lighting = ambient + hemiLight;

                outputColor = baseColor * hemiLight;

                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
