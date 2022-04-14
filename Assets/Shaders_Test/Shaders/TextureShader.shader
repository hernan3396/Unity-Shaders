Shader "Unlit/TextureShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Pattern ("Pattern", 2D) = "white" {}
        _Rock ("Rock", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #define TAU 6.28318530718

            #include "UnityCG.cginc"

            float GetWave( float2 coord)
            {
                float wave = cos((coord - _Time.y * 0.1f) * TAU * 5) * 0.5 + 0.5;
                wave *= 1-coord;
                return wave;
            }

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST; // optional (offset / tilling)
            sampler2D _Pattern;
            sampler2D _Rock;

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.worldPos = mul( unity_ObjectToWorld, float4( v.vertex.xyz , 1 ));
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                // o.uv.x += _Time.y *0.1;
                return o;
            }

            fixed4 frag (Interpolators i) : SV_Target
            {
                float2 topDownProjection = i.worldPos.xz;
                float4 moss = tex2D(_MainTex, topDownProjection);
                float4 rock = tex2D(_Rock, topDownProjection);
                float pattern = tex2D(_Pattern, i.uv);

                float4 finalColor = lerp(rock, moss, pattern);

                return finalColor;

                // return float4(topDownProjection, 0 , 1);
                // sample the texture
            }
            ENDCG
        }
    }
}
