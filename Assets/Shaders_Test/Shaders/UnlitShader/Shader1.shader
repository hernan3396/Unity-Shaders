Shader "Unlit/Shader1"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent" // tag to inform the render pipeline of what type this is
            "Queue" = "Transparent" // changes the render order (buscar unity render queue)
        }

        Pass
        {
            // pass tags
            Cull Off
            ZWrite Off
            Blend One One // additive


            // Blend DstColor Zero // multiply 

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define TAU 6.28318530718

            #include "UnityCG.cginc"
            
            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;

            // automatically filled out by unity
            // per vertex mesh data
            struct MeshData 
            {
                float4 vertex : POSITION; // vertex position
                // float4 tangent : TANGENT;
                float3 normals : NORMAL;
                // float4 color : COLOR;
                float2 uv0 : TEXCOORD0; // uv0 coordinates
                // float2 uv1 : TEXCOORD1; // uv1 coordinates
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; // clip space position 
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                // float2 uv : TEXCOORD0;
            };


            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); // converts local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normals); // just pass through
                o.uv = v.uv0; //(v.uv0 + _Offset) * _Scale;
                // o.vertex = v.vertex;

                return o;
            }

            float InverseLerp(float a, float b, float v)
            {
                return (v-a)/(b-a);
            }

            // float (32 bit float)
            // half (16 bit float)
            // fixed (lower precision)

            float4 frag (Interpolators i) : SV_Target
            {
                // lerp - blends two colors based on the x UV coordinate
                // float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x));
                // frac = v - floor(v)
                // t = frac(t);
                // float t =abs(frac(i.uv.x * 5) * 2 - 1);

                // return i.uv.y;

                float xOffset = cos( i.uv.x * TAU * 8) * 0.01f;

                float t = cos((i.uv.y + xOffset - _Time.y * 0.1f) * TAU * 5) * 0.5 + 0.5;
                t *= 1-i.uv.y;

                float topBottomRemover = (abs( i.normal.y) < 0.999f);
                float waves = t * topBottomRemover;
                    
                // return t;
                // return t * (abs( i.normal.y) < 0.999f) ;

                float4 gradient = lerp(_ColorA, _ColorB, i.uv.y);

                return gradient * waves;


                // float4 outColor = lerp(_ColorA, _ColorB, t);
                
                // return outColor;
            }
            ENDCG
        }
    }
}
