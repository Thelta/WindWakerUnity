Shader "Custom/OceanShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_OceanBlue ("OceanBlue", Color) = (1, 1, 1, 1)
		_DarkBlue ("DarkBlue", Color) = (1, 1, 1, 1)
	}

	Subshader
	{
		Pass
		{
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment ExteriorFragmentProgram
			#pragma target 3.0
			#include "UnityCG.cginc"
			
			#define SIN1(x,t) ((sin(x + 2*t) + sin(0.7*x - 2*t + 0.2) - sin(1.5*x+0.93 - t) + sin(0.2*t)) / 6)
			#define SIN2(x,t) ((sin(0.7*x) - sin(0.2*x - 1 + 3*t) + sin(2*x - 0.93) + sin(t + 5)) / 6)
			

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _OceanBlue;
			float4 _DarkBlue;

			struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			struct VertexData
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;
				v.position.y += SIN2(v.position.x, _Time.y) / 2;
				v.position.y += SIN1(_Time.y, v.position.z) / 2	;
				

				i.position = mul(UNITY_MATRIX_MVP, v.position);
				i.uv.xy = v.uv.xy * _MainTex_ST.xy;
												
				return i;
			}

			float4 ExteriorFragmentProgram(Interpolators i) : SV_TARGET
			{
				i.uv.x += SIN1(i.uv.y, i.uv.y + _Time.y / 2);
				i.uv.y -= SIN2(i.uv.x + _Time.y / 2, i.uv.x);								
				
				if(tex2D(_MainTex, i.uv - _MainTex_ST.zw).x > 0.5f && tex2D(_MainTex, i.uv).x < 0.5f)
				{
					return _DarkBlue;
				}

				if(tex2D(_MainTex, i.uv).x < 0.5f)
				{
					return _OceanBlue;
				}
			
				return tex2D(_MainTex, i.uv);
			}

			ENDCG
		}
	}
}