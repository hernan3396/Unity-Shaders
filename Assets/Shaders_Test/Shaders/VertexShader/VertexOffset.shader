Shader "Unlit/VertexOffset"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _ColorStart ("Color Start", Range(0,1)) = 0
        _ColorEnd ("Color End", Range(0,1)) = 1
        _WaveAmp ("Wave Ampluted", Range(0,1)) = 0.1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque" // tag to inform the render pipeline of what type this is
            "Queue" = "Geometry" // changes the render order (buscar unity render queue)
        }

        Pass
        {
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
            float _WaveAmp;

            float GetWave( float2 uv)
            {
                float2 uvsCentered = uv * 2 - 1;

                float radialDistance = length(uvsCentered);

                float wave = cos((radialDistance - _Time.y * 0.1f) * TAU * 5) * 0.5 + 0.5;
                wave *= 1-radialDistance;
                return wave;
            }

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

                // float wave = cos((v.uv0.y - _Time.y * 0.1f) * TAU * 5);
                // float wave2 = cos((v.uv0.x - _Time.y * 0.1f) * TAU * 5);

                // v.vertex.y = wave * wave2 * _WaveAmp;
                v.vertex.y = GetWave(v.uv0) * _WaveAmp; 

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
                return GetWave(i.uv);
            }
            ENDCG
        }
    }
}
