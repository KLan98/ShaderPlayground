Shader "Unlit/ShadertoyPort"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv  : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float2x2 rot(float a)
            {
                float s = sin(a);
                float c = cos(a);
                return float2x2(c, s, -s, c);
            }

            float4 frag (v2f i) : SV_Target
            {
                float2 fragCoord = i.uv * _ScreenParams.xy;
                float2 iResolution = _ScreenParams.xy;
                float iTime = _Time.y;

                float3 col = 0;

                #define AA 2
                for (int j = 0; j < AA; j++)
                for (int k = 0; k < AA; k++)
                {
                    float2 p = (fragCoord + float2(k, j) / AA - iResolution * 0.5) / iResolution.y;

                    float ttm = cos(sin(iTime / 8.0)) * 6.2831;
                    p = mul(rot(ttm), p);
                    p -= float2(cos(iTime / 2.0) / 2.0, sin(iTime / 3.0) / 5.0);

                    float zm = 200.0 + sin(iTime / 7.0) * 50.0;
                    float2 cc = float2(-0.57735 + 0.004, 0.57735) + p / zm;

                    float2 z = 0;
                    float2 dz = 0;

                    const int iter = 128;
                    int ik = iter;
                    float3 fog = 0;

                    for (int n = 0; n < iter; n++)
                    {
                        dz = mul(float2x2(z.x, -z.y, z.y, z.x), dz) * 2.0 + float2(1, 0);
                        z  = mul(float2x2(z.x, -z.y, z.y, z.x), z) + cc;

                        if (dot(z, z) > 1.0 / 0.005)
                        {
                            ik = n;
                            break;
                        }
                    }

                    float ln = step(0.0, length(z) / 15.5 - 1.0);

                    float d = sqrt(1.0 / max(length(dz), 0.0001)) * log(dot(z, z));
                    d = saturate(d * 50.0);

                    float dir = fmod(ik, 2) < 1 ? -1.0 : 1.0;
                    float sh = (iter - ik) / (float)iter;

                    float2 tuv = z / 320.0;
                    float tm = -ttm * sh * sh * 16.0;
                    tuv = mul(rot(tm), tuv);
                    tuv = abs(fmod(tuv, 1.0 / 8.0) - 1.0 / 16.0);

                    float pat = smoothstep(0, 1.0 / length(dz), length(tuv) - 1.0 / 32.0);
                    pat = min(pat,
                        smoothstep(0, 1.0 / length(dz),
                        abs(max(tuv.x, tuv.y) - 1.0 / 16.0) - 0.04 / 16.0));

                    float3 lCol = pow(
                        min(float3(1.5, 1.0, 1.0) * min(d * 0.85, 0.96), 1.0),
                        float3(1, 3, 16)
                    ) * 1.15;

                    lCol = dir < 0
                        ? lCol * min(pat, ln)
                        : (sqrt(lCol) * 0.5 + 0.7) * max(1.0 - pat, 1.0 - ln);

                    float3 rd = normalize(float3(p, 1));
                    rd = reflect(rd, float3(0, 0, -1));
                    float diff = saturate(dot(z * 0.5 + 0.5, rd.xy)) * d;

                    lCol += lerp(lCol, 1.0, 0.5) * diff * diff * 0.5 * (pat * 0.6 + 0.6);

                    if (fmod(ik, 6) < 1) lCol = lCol.yxz;
                    lCol = lerp(lCol.xzy, lCol, d / 1.2);

                    lCol = lerp(lCol, 0,
                        (1.0 - step(0.0, -(length(z) * 0.05 * ik / iter - 1.0))) * 0.95);

                    lCol = lerp(fog, lCol, sh * d);

                    col += saturate(lCol);
                }

                col /= (AA * AA);

                float2 uv = fragCoord / iResolution;
                col *= pow(16.0 * uv.x * uv.y * (1 - uv.x) * (1 - uv.y), 1.0 / 8.0) * 1.15;

                return float4(sqrt(max(col, 0)), 1);
            }
            ENDCG
        }
    }
}