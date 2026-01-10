Shader "Unlit/BuiltInFuncs"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM
            
            #ifdef VERTEX

            varying vec2 vUvs;

            void main()
            {
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
                vUvs = gl_MultiTexCoord0.xy;
            }

            #endif 
            
            #ifdef FRAGMENT

            varying vec2 vUvs;
            
            void main()
            {
                float middle = 0.5; // uv middle threshold
                float edge0 = 0.0; // uv edge value
                float thickness = 0.005;
                float alpha = 1.0;

                vec3 red = vec3(1,0,0);
                vec3 blue = vec3(0,0,1);
                vec3 white = vec3(1,1,1);
                vec3 outputColor = vec3(0.0);

                float d1 = abs(vUvs.y - middle);
                float separationLine = smoothstep(edge0, thickness, d1);

                float linearValue = vUvs.x;
                float function = mix(0.5, 1, linearValue); // y = 0.5 + 0.5 * x, telling the fragement shader which pixels should be rendered
                float distance = abs(vUvs.y - function);
                float linearLine = smoothstep(edge0, thickness, distance);

                float nonLinearValue = smoothstep(0.0, 1, vUvs.x); // f(x) = 3x^2 − 2x^3 (for x in[0,1])
                float function2 = mix(0, 0.5, nonLinearValue); // f(x) = 1.5x^2 − x^3
                float d2 = abs(vUvs.y - function2);
                float nonLinearLine = smoothstep(edge0, thickness, d2);

                if (vUvs.y >= middle)
                {
                    outputColor = mix(blue, red, linearValue);
                }

                else
                {
                    outputColor = mix(blue, red, nonLinearValue); 
                }

                outputColor = mix(white, outputColor, separationLine); 
                outputColor = mix(white, outputColor, linearLine); // illustrate the color by drawing a graph
                outputColor = mix(white, outputColor, nonLinearLine);

                gl_FragColor = vec4(outputColor, alpha);
            }

            #endif
            ENDGLSL
        }
    }
}
