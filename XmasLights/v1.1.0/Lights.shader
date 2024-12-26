// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Lights"
{
	Properties {
		_Params ("Offset/Multipler/Step", Float) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass {
			Tags { "LightMode" = "Always" }
			
			Fog { Mode Off }
			ZWrite On
			ZTest LEqual
			Cull Back
			Lighting Off
	
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest

				fixed4 _Params;
				
				struct appdata {
					float4 vertex : POSITION;
				};
				
				struct v2f {
					float4 vertex : POSITION;
				};
				
				float3 HUEtoRGB(in float H)
				{
					float R = abs(H * 6 - 3) - 1;
					float G = 2 - abs(H * 6 - 2);
					float B = 2 - abs(H * 6 - 4);
					return saturate(float3(R,G,B));
				}

				float4 GetColour(float offset, float multipler, float stepping) {
					float4 col = float4(HUEtoRGB(mad(_Time.y, multipler, offset) % 1), 1);
					return step(stepping, col);
				}
				
				v2f vert (appdata v) {
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					return o;
				}
				
				fixed4 frag (v2f i) : COLOR {
					return GetColour(_Params.x, _Params.y, _Params.z);
				}
			ENDCG
	
		}
	} 
}
