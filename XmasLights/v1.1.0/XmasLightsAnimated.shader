Shader "Unlit/XmasLightsAnimated"
{
    Properties
    {
		_Params ("Offset/Multipler/Size/Count", Float) = (1,1,1,1)
		_MainTex ("Colour Array", 2D) = "white" {}
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
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            fixed4 _Params;
            fixed _Emission;

            v2f vert (appdata v)
            {
                uint size = uint(_Params.z);
                uint index = uint(floor(mad(_Time.y, _Params.y, _Params.x) % _Params.w));

                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = (float2(index % size, index / size) + 0.5) * _MainTex_TexelSize.xy;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * 3.5;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
