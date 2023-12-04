Shader "Custom/Shader1"
{
    Properties
    {
        _ColorPrimary ("Primary Color", Color) = (1,1,1,1)
        _ColorSecondary ("Secondary Color", Color) = (1,1,1,1)
        _COlorTriple ("Triple Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _ColorPrimary;
        fixed4 _ColorSecondary;
        fixed4 _COlorTriple;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            
            

            float deltaTime = 1;
            float currPos = (_Time.y % (deltaTime*2)) / (deltaTime*2);
            float currPos2 = (_Time.y % deltaTime) / deltaTime;

            fixed4 currentColor1 = (currPos > 0.5) ? _COlorTriple : _ColorPrimary;
            fixed4 currentColor2 = (currPos > 0.5) ? _ColorPrimary : _COlorTriple;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * currentColor2;
            o.Albedo = c.xyz;
            
            if (abs(IN.worldPos.y + 0.5 - currPos2) < 0.05)
            {
                o.Albedo = _ColorSecondary;
            }
            if (abs(IN.worldPos.y + 1 - currPos2) < 0.5)
            {
                o.Albedo = currentColor1;
            }
            // Albedo comes from a texture tinted by color

            // o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
