Shader "Unlit/FrequencyVisualizer"
{
    Properties
    {
        _TimeScale("Speed", Float) = 1.0
        _White("White", Color) = (1, 1, 1, 1)
		_Red ("Red", Color) = (1,0,0,1)
		_Green ("Green", Color) = (0,1,0,1)
		_Blue ("Blue", Color) = (0,0,1,1)
		_Yellow ("Yellow", Color) = (1,1,0,1)    
        _Persistence ("Persistence", Float) = 0.5
        _Lacuranity ("Lacuranity", Float) = 1.0
        _Octaves ("Octaves", int) = 1 
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX
            
            // output of vert shader
            varying vec2 UV;
            varying vec3 localSpacePosition;
            
            uniform vec4 _White;
            uniform vec4 _Blue;

            void main()
            {
                localSpacePosition = gl_Vertex.xyz;
                gl_Position = gl_ModelViewProjectionMatrix * vec4(localSpacePosition, 1.0);
                UV = gl_MultiTexCoord0.xy;
            }

            #endif

            #ifdef FRAGMENT

            uniform float _TimeScale;
            uniform vec4 _Time;
            uniform vec4 _White;
            uniform vec4 _Blue;
            uniform vec4 _Red;
            uniform int _Octaves;
            uniform float _Persistence;
            uniform float _Lacuranity;

            // out of vert shader
            varying vec2 UV;
            varying vec3 localSpacePosition;

            float INVERSE_LERP(float current, float min, float max)
            {
                return (current - min) / (max - min);
            }

            float REMAP(float current, float inMin, float inMax, float outMin, float outMax)
            {
                float value = INVERSE_LERP(current, inMin, inMax);
                return mix(outMin, outMax, value);
            }

            float sdfLine(vec2 p, vec2 a, vec2 b) {
                vec2 pa = p - a;
                vec2 ba = b - a;
                float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);

                return length(pa - ba * h);
            }

            // fbm
            float evaluateFunction(float x)
            {
                float y = 0.0;

                float amplitude = 100;

                float frequency = 1.0/64.0;

                for(int i = 0; i < _Octaves; i++)
                {
                    // the function is sine wave
                    y += sin(frequency * x) * amplitude;
                    amplitude *= _Persistence;
                    frequency *= _Lacuranity;
                }
                
                return y;
            }

            float plotFunction(vec2 p, float px, float curTime) {
                float result = 100000.0;
  
                for (float i = -5.0; i < 5.0; i += 1.0) 
                {
                    vec2 c1 = p + vec2(px * i, 0.0);
                    vec2 c2 = p + vec2(px * (i + 1.0), 0.0);

                    vec2 a = vec2(c1.x, evaluateFunction(c1.x + curTime));
                    vec2 b = vec2(c2.x, evaluateFunction(c2.x + curTime));
                    result = min(result, sdfLine(p, a, b));
                }

                return result;
            }

            void main()
            {
                vec3 outputColor;

                float time = _Time.y;
                float zVertRange = 5.0;
                float normalizedRange = 1.0;
                float thickness = 0.005;

                float zAxis = REMAP(localSpacePosition.z, -zVertRange, zVertRange, 0.0, normalizedRange);
                float xAxis = REMAP(localSpacePosition.x, -5.0, 5.0, 0.0, normalizedRange);

                float function = 0.5;
                float distanceToFunction = abs(zAxis - function);
                float lineMask = 1 - smoothstep(0.0, thickness, distanceToFunction);
                outputColor = vec3(mix(_White.xyz, _Blue.xyz, lineMask));

                vec2 pixelCoords = vec2(xAxis * 1920, (zAxis - 0.5) * 1080);
                float pixelSize = 1;

                // Draw graph of our function
                float distToFunction = plotFunction(pixelCoords, pixelSize, time * _TimeScale);
                float waveMask = 1 - smoothstep(0.0, 4.0, distToFunction);

                outputColor = vec3(mix(outputColor, _Red.xyz, waveMask));

                gl_FragColor = vec4(outputColor, 1);
            }

            #endif

            ENDGLSL
        }
    }
}
