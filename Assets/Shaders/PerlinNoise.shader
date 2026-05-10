Shader "Unlit/PerlinNoise"
{
    Properties
    {
        _TimeScale("Speed", Float) = 1.0
        _Amplitude("Amplitude", Float) = 1.0
        _Frequency("Frequency", Float) = 1.0
        _Octave("Octave", Int) = 10
        _Persistence("Persistence", Float) = 0.5
        _Lacunarity("Lacunarity", Float) = 2
    }
    SubShader
    {
        Pass
        {
            GLSLPROGRAM

            #ifdef VERTEX

            varying vec3 localSpacePosition;

            void main()
            {
                localSpacePosition = gl_Vertex.xyz;
                gl_Position = gl_ModelViewProjectionMatrix * vec4(localSpacePosition, 1.0);
            }

            #endif

            #ifdef FRAGMENT

            uniform sampler2D baseNoise;

            varying vec2 texCoord;
            varying vec4 v_color;
            varying vec3 localSpacePosition;

            uniform float _TimeScale;
            uniform float _Persistence;
            uniform float _Amplitude;
            uniform float _Lacunarity;
            uniform int _Octave;
            uniform float _Frequency;
            uniform vec4 _Time;

            vec2 random2(vec2 st){
                st = vec2( dot(st,vec2(127.1,311.7)),
                          dot(st,vec2(269.5,183.3)));
                return -1.0 + 2.0*fract(sin(st)*43758.5453123);
            }

            // Gradient Noise by Inigo Quilez - iq/2013
            // https://www.shadertoy.com/view/XdXGW8
            float noise(vec2 st) {
                vec2 i = floor(st);
                vec2 f = fract(st);

                vec2 u = f*f*(3.0-2.0*f);

                return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                                 dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                            mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                                 dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
            }

            float FBM(vec3 position)
            {
                float amplitude = _Amplitude;
                float frequency = _Frequency;
                float total = 0.0;
                float persistence = _Persistence;
                float lacunarity = _Lacunarity;

                for (int i = 0; i < _Octave; i++)
                {
                    total += noise(position.xy * frequency + vec2(_Time.y * _TimeScale)) * amplitude;
                    frequency *= lacunarity;
                    amplitude *= persistence;
                }

                return total;
            }

            float INVERSE_LERP(float current, float min, float max)
            {
                return (current - min) / (max - min);
            }

            float REMAP(float current, float inMin, float inMax, float outMin, float outMax)
            {
                float value = INVERSE_LERP(current, inMin, inMax);
                return mix(outMin, outMax, value);
            }

            void main()
            {
                float xAxis = REMAP(localSpacePosition.x, -5.0, 5.0, -1.0, 1.0);
                float yAxis = REMAP(localSpacePosition.z, -5.0, 5.0, -1.0, 1.0);

                vec3 coord = vec3(localSpacePosition.x, localSpacePosition.z, _Time.y);

                float noiseSample = FBM(coord);

                vec3 color = vec3(0.0, 0.0, 1.0);
                vec3 outputColor = vec3(noiseSample) * color;
                gl_FragColor = vec4(outputColor, 1.0);
            }

            #endif

            ENDGLSL
        }
    }
}
