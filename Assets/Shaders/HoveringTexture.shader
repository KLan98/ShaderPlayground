Shader "Unlit/HoveringTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TimeScale ("Speed", float) = 1.0
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

            uniform sampler2D _MainTex;
            uniform float _TimeScale;
            uniform vec4 _Time;
            varying vec2 vUvs;

            vec3 HOVERTEXTURE(sampler2D text, vec2 vUvs, float time)
            {
                float offset = 0.1 * sin(time * 10);
                vec3 black = vec3(0.0);
                
                vUvs.y += offset; // movement in the UVs.y

                float crop = step(0.0, vUvs.y) * step(vUvs.y, 1.0); // AND logic

                vec3 texels = texture2D(text, vUvs).rgb; // sample the texture

                return mix(black, texels, crop); // mix the colors 
            }

            void main()
            {
                float t = _TimeScale * _Time.y;
                vec3 outputColor = HOVERTEXTURE(_MainTex, vUvs, t);
                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
