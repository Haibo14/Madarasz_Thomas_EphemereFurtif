Shader "Unlit Master"
{
    Properties
    {
        Vector4_BB09ACBD("Rotate Projection", Vector) = (1, 0, 0, 0)
        Vector1_BF320109("Noise Scale", Float) = 10
        Vector1_6D9BD116("Noise Speed", Float) = 0.1
        Vector1_6456C52("Noise Height", Float) = 100
        Vector4_C854FE8B("Noise Remap", Vector) = (0, 1, -1, 1)
        [HDR]Color_A593EF6("Color Peak", Color) = (1, 1, 1, 0)
        [HDR]Color_1121E21B("Color Valley", Color) = (0, 0, 0, 0)
        Vector1_B2C646A0("Noise Edge 1", Float) = 0
        Vector1_E0C44976("Noise Edge 2", Float) = 1
        Vector1_C9CDB2CB("Noise Power ", Float) = 2
        Vector1_A631F5A2("Base Scale", Float) = 5
        Vector1_AE77181D("Base Speed", Float) = 0.2
        Vector1_C91936D9("Base Strength", Float) = 2
        Vector1_1AD22367("Emission Strength", Float) = 2
        Vector1_5B746A44("Curvature Radius", Float) = 0
        Vector1_75D132BA("Fresnel Power", Float) = 2
        Vector1_52B02E5A("Fresnel Opacity", Float) = 1
        Vector1_5D08E19("Fade Depth", Float) = 100
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            Name "Pass"
            Tags 
            { 
                // LightMode: <None>
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma shader_feature _ _SAMPLE_GI
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_UNLIT
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_BB09ACBD;
            float Vector1_BF320109;
            float Vector1_6D9BD116;
            float Vector1_6456C52;
            float4 Vector4_C854FE8B;
            float4 Color_A593EF6;
            float4 Color_1121E21B;
            float Vector1_B2C646A0;
            float Vector1_E0C44976;
            float Vector1_C9CDB2CB;
            float Vector1_A631F5A2;
            float Vector1_AE77181D;
            float Vector1_C91936D9;
            float Vector1_1AD22367;
            float Vector1_5B746A44;
            float Vector1_75D132BA;
            float Vector1_52B02E5A;
            float Vector1_5D08E19;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_426602DA_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_426602DA_Out_2);
                float _Property_24EE9EDC_Out_0 = Vector1_5B746A44;
                float _Divide_491E48E3_Out_2;
                Unity_Divide_float(_Distance_426602DA_Out_2, _Property_24EE9EDC_Out_0, _Divide_491E48E3_Out_2);
                float _Power_61450591_Out_2;
                Unity_Power_float(_Divide_491E48E3_Out_2, 3, _Power_61450591_Out_2);
                float3 _Multiply_C959B8D2_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_61450591_Out_2.xxx), _Multiply_C959B8D2_Out_2);
                float _Property_A381476F_Out_0 = Vector1_B2C646A0;
                float _Property_8B069924_Out_0 = Vector1_E0C44976;
                float4 _Property_2B98FF0C_Out_0 = Vector4_BB09ACBD;
                float _Split_CF0194C6_R_1 = _Property_2B98FF0C_Out_0[0];
                float _Split_CF0194C6_G_2 = _Property_2B98FF0C_Out_0[1];
                float _Split_CF0194C6_B_3 = _Property_2B98FF0C_Out_0[2];
                float _Split_CF0194C6_A_4 = _Property_2B98FF0C_Out_0[3];
                float3 _RotateAboutAxis_FA6782D8_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_2B98FF0C_Out_0.xyz), _Split_CF0194C6_A_4, _RotateAboutAxis_FA6782D8_Out_3);
                float _Property_A6566A31_Out_0 = Vector1_6D9BD116;
                float _Multiply_8D359B39_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_A6566A31_Out_0, _Multiply_8D359B39_Out_2);
                float2 _TilingAndOffset_490CAB2C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_8D359B39_Out_2.xx), _TilingAndOffset_490CAB2C_Out_3);
                float _Property_9764123B_Out_0 = Vector1_BF320109;
                float _GradientNoise_9D62F445_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_490CAB2C_Out_3, _Property_9764123B_Out_0, _GradientNoise_9D62F445_Out_2);
                float2 _TilingAndOffset_89726A34_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_89726A34_Out_3);
                float _GradientNoise_E9B9B822_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_89726A34_Out_3, _Property_9764123B_Out_0, _GradientNoise_E9B9B822_Out_2);
                float _Add_7631ABE6_Out_2;
                Unity_Add_float(_GradientNoise_9D62F445_Out_2, _GradientNoise_E9B9B822_Out_2, _Add_7631ABE6_Out_2);
                float _Divide_3A13ABE0_Out_2;
                Unity_Divide_float(_Add_7631ABE6_Out_2, 2, _Divide_3A13ABE0_Out_2);
                float _Saturate_577BE965_Out_1;
                Unity_Saturate_float(_Divide_3A13ABE0_Out_2, _Saturate_577BE965_Out_1);
                float _Property_C7839A3A_Out_0 = Vector1_C9CDB2CB;
                float _Power_956F0853_Out_2;
                Unity_Power_float(_Saturate_577BE965_Out_1, _Property_C7839A3A_Out_0, _Power_956F0853_Out_2);
                float4 _Property_3BBF5BF4_Out_0 = Vector4_C854FE8B;
                float _Split_D7D14ECD_R_1 = _Property_3BBF5BF4_Out_0[0];
                float _Split_D7D14ECD_G_2 = _Property_3BBF5BF4_Out_0[1];
                float _Split_D7D14ECD_B_3 = _Property_3BBF5BF4_Out_0[2];
                float _Split_D7D14ECD_A_4 = _Property_3BBF5BF4_Out_0[3];
                float4 _Combine_C24E1A18_RGBA_4;
                float3 _Combine_C24E1A18_RGB_5;
                float2 _Combine_C24E1A18_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_R_1, _Split_D7D14ECD_G_2, 0, 0, _Combine_C24E1A18_RGBA_4, _Combine_C24E1A18_RGB_5, _Combine_C24E1A18_RG_6);
                float4 _Combine_D87D4E0D_RGBA_4;
                float3 _Combine_D87D4E0D_RGB_5;
                float2 _Combine_D87D4E0D_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_B_3, _Split_D7D14ECD_A_4, 0, 0, _Combine_D87D4E0D_RGBA_4, _Combine_D87D4E0D_RGB_5, _Combine_D87D4E0D_RG_6);
                float _Remap_DD98F6C9_Out_3;
                Unity_Remap_float(_Power_956F0853_Out_2, _Combine_C24E1A18_RG_6, _Combine_D87D4E0D_RG_6, _Remap_DD98F6C9_Out_3);
                float _Absolute_47D58F21_Out_1;
                Unity_Absolute_float(_Remap_DD98F6C9_Out_3, _Absolute_47D58F21_Out_1);
                float _Smoothstep_32D30026_Out_3;
                Unity_Smoothstep_float(_Property_A381476F_Out_0, _Property_8B069924_Out_0, _Absolute_47D58F21_Out_1, _Smoothstep_32D30026_Out_3);
                float _Property_580A9D5D_Out_0 = Vector1_AE77181D;
                float _Multiply_21EBF1FD_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_580A9D5D_Out_0, _Multiply_21EBF1FD_Out_2);
                float2 _TilingAndOffset_262D76C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_21EBF1FD_Out_2.xx), _TilingAndOffset_262D76C_Out_3);
                float _Property_5E7655DE_Out_0 = Vector1_A631F5A2;
                float _GradientNoise_5A3FDB78_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_262D76C_Out_3, _Property_5E7655DE_Out_0, _GradientNoise_5A3FDB78_Out_2);
                float _Property_CA4974CC_Out_0 = Vector1_C91936D9;
                float _Multiply_D8984132_Out_2;
                Unity_Multiply_float(_GradientNoise_5A3FDB78_Out_2, _Property_CA4974CC_Out_0, _Multiply_D8984132_Out_2);
                float _Add_156C9593_Out_2;
                Unity_Add_float(_Smoothstep_32D30026_Out_3, _Multiply_D8984132_Out_2, _Add_156C9593_Out_2);
                float _Add_63BDC2FD_Out_2;
                Unity_Add_float(1, _Property_CA4974CC_Out_0, _Add_63BDC2FD_Out_2);
                float _Divide_50C8FD18_Out_2;
                Unity_Divide_float(_Add_156C9593_Out_2, _Add_63BDC2FD_Out_2, _Divide_50C8FD18_Out_2);
                float3 _Multiply_FF1A2A2_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_50C8FD18_Out_2.xxx), _Multiply_FF1A2A2_Out_2);
                float _Property_E92B26A_Out_0 = Vector1_6456C52;
                float3 _Multiply_FBD95215_Out_2;
                Unity_Multiply_float(_Multiply_FF1A2A2_Out_2, (_Property_E92B26A_Out_0.xxx), _Multiply_FBD95215_Out_2);
                float3 _Add_9AF10170_Out_2;
                Unity_Add_float3(IN.AbsoluteWorldSpacePosition, _Multiply_FBD95215_Out_2, _Add_9AF10170_Out_2);
                float3 _Add_3F87EC84_Out_2;
                Unity_Add_float3(_Multiply_C959B8D2_Out_2, _Add_9AF10170_Out_2, _Add_3F87EC84_Out_2);
                description.VertexPosition = _Add_3F87EC84_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceViewDirection;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float4 ScreenPosition;
                float3 TimeParameters;
            };
            
            struct SurfaceDescription
            {
                float3 Color;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_A89ABE3D_Out_0 = Color_1121E21B;
                float4 _Property_F18D87D8_Out_0 = Color_A593EF6;
                float _Property_A381476F_Out_0 = Vector1_B2C646A0;
                float _Property_8B069924_Out_0 = Vector1_E0C44976;
                float4 _Property_2B98FF0C_Out_0 = Vector4_BB09ACBD;
                float _Split_CF0194C6_R_1 = _Property_2B98FF0C_Out_0[0];
                float _Split_CF0194C6_G_2 = _Property_2B98FF0C_Out_0[1];
                float _Split_CF0194C6_B_3 = _Property_2B98FF0C_Out_0[2];
                float _Split_CF0194C6_A_4 = _Property_2B98FF0C_Out_0[3];
                float3 _RotateAboutAxis_FA6782D8_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_2B98FF0C_Out_0.xyz), _Split_CF0194C6_A_4, _RotateAboutAxis_FA6782D8_Out_3);
                float _Property_A6566A31_Out_0 = Vector1_6D9BD116;
                float _Multiply_8D359B39_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_A6566A31_Out_0, _Multiply_8D359B39_Out_2);
                float2 _TilingAndOffset_490CAB2C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_8D359B39_Out_2.xx), _TilingAndOffset_490CAB2C_Out_3);
                float _Property_9764123B_Out_0 = Vector1_BF320109;
                float _GradientNoise_9D62F445_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_490CAB2C_Out_3, _Property_9764123B_Out_0, _GradientNoise_9D62F445_Out_2);
                float2 _TilingAndOffset_89726A34_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_89726A34_Out_3);
                float _GradientNoise_E9B9B822_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_89726A34_Out_3, _Property_9764123B_Out_0, _GradientNoise_E9B9B822_Out_2);
                float _Add_7631ABE6_Out_2;
                Unity_Add_float(_GradientNoise_9D62F445_Out_2, _GradientNoise_E9B9B822_Out_2, _Add_7631ABE6_Out_2);
                float _Divide_3A13ABE0_Out_2;
                Unity_Divide_float(_Add_7631ABE6_Out_2, 2, _Divide_3A13ABE0_Out_2);
                float _Saturate_577BE965_Out_1;
                Unity_Saturate_float(_Divide_3A13ABE0_Out_2, _Saturate_577BE965_Out_1);
                float _Property_C7839A3A_Out_0 = Vector1_C9CDB2CB;
                float _Power_956F0853_Out_2;
                Unity_Power_float(_Saturate_577BE965_Out_1, _Property_C7839A3A_Out_0, _Power_956F0853_Out_2);
                float4 _Property_3BBF5BF4_Out_0 = Vector4_C854FE8B;
                float _Split_D7D14ECD_R_1 = _Property_3BBF5BF4_Out_0[0];
                float _Split_D7D14ECD_G_2 = _Property_3BBF5BF4_Out_0[1];
                float _Split_D7D14ECD_B_3 = _Property_3BBF5BF4_Out_0[2];
                float _Split_D7D14ECD_A_4 = _Property_3BBF5BF4_Out_0[3];
                float4 _Combine_C24E1A18_RGBA_4;
                float3 _Combine_C24E1A18_RGB_5;
                float2 _Combine_C24E1A18_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_R_1, _Split_D7D14ECD_G_2, 0, 0, _Combine_C24E1A18_RGBA_4, _Combine_C24E1A18_RGB_5, _Combine_C24E1A18_RG_6);
                float4 _Combine_D87D4E0D_RGBA_4;
                float3 _Combine_D87D4E0D_RGB_5;
                float2 _Combine_D87D4E0D_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_B_3, _Split_D7D14ECD_A_4, 0, 0, _Combine_D87D4E0D_RGBA_4, _Combine_D87D4E0D_RGB_5, _Combine_D87D4E0D_RG_6);
                float _Remap_DD98F6C9_Out_3;
                Unity_Remap_float(_Power_956F0853_Out_2, _Combine_C24E1A18_RG_6, _Combine_D87D4E0D_RG_6, _Remap_DD98F6C9_Out_3);
                float _Absolute_47D58F21_Out_1;
                Unity_Absolute_float(_Remap_DD98F6C9_Out_3, _Absolute_47D58F21_Out_1);
                float _Smoothstep_32D30026_Out_3;
                Unity_Smoothstep_float(_Property_A381476F_Out_0, _Property_8B069924_Out_0, _Absolute_47D58F21_Out_1, _Smoothstep_32D30026_Out_3);
                float _Property_580A9D5D_Out_0 = Vector1_AE77181D;
                float _Multiply_21EBF1FD_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_580A9D5D_Out_0, _Multiply_21EBF1FD_Out_2);
                float2 _TilingAndOffset_262D76C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_21EBF1FD_Out_2.xx), _TilingAndOffset_262D76C_Out_3);
                float _Property_5E7655DE_Out_0 = Vector1_A631F5A2;
                float _GradientNoise_5A3FDB78_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_262D76C_Out_3, _Property_5E7655DE_Out_0, _GradientNoise_5A3FDB78_Out_2);
                float _Property_CA4974CC_Out_0 = Vector1_C91936D9;
                float _Multiply_D8984132_Out_2;
                Unity_Multiply_float(_GradientNoise_5A3FDB78_Out_2, _Property_CA4974CC_Out_0, _Multiply_D8984132_Out_2);
                float _Add_156C9593_Out_2;
                Unity_Add_float(_Smoothstep_32D30026_Out_3, _Multiply_D8984132_Out_2, _Add_156C9593_Out_2);
                float _Add_63BDC2FD_Out_2;
                Unity_Add_float(1, _Property_CA4974CC_Out_0, _Add_63BDC2FD_Out_2);
                float _Divide_50C8FD18_Out_2;
                Unity_Divide_float(_Add_156C9593_Out_2, _Add_63BDC2FD_Out_2, _Divide_50C8FD18_Out_2);
                float4 _Lerp_8F06EB55_Out_3;
                Unity_Lerp_float4(_Property_A89ABE3D_Out_0, _Property_F18D87D8_Out_0, (_Divide_50C8FD18_Out_2.xxxx), _Lerp_8F06EB55_Out_3);
                float _Property_8635C094_Out_0 = Vector1_75D132BA;
                float _FresnelEffect_BEC56A49_Out_3;
                Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_8635C094_Out_0, _FresnelEffect_BEC56A49_Out_3);
                float _Multiply_805FF81C_Out_2;
                Unity_Multiply_float(_Divide_50C8FD18_Out_2, _FresnelEffect_BEC56A49_Out_3, _Multiply_805FF81C_Out_2);
                float _Property_A54A3DCD_Out_0 = Vector1_52B02E5A;
                float _Multiply_D6CD7C51_Out_2;
                Unity_Multiply_float(_Multiply_805FF81C_Out_2, _Property_A54A3DCD_Out_0, _Multiply_D6CD7C51_Out_2);
                float4 _Add_F90FBFA8_Out_2;
                Unity_Add_float4(_Lerp_8F06EB55_Out_3, (_Multiply_D6CD7C51_Out_2.xxxx), _Add_F90FBFA8_Out_2);
                float _Property_1608876_Out_0 = Vector1_1AD22367;
                float4 _Multiply_81FA1D37_Out_2;
                Unity_Multiply_float(_Add_F90FBFA8_Out_2, (_Property_1608876_Out_0.xxxx), _Multiply_81FA1D37_Out_2);
                float _SceneDepth_11839528_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_11839528_Out_1);
                float4 _ScreenPosition_523BADB7_Out_0 = IN.ScreenPosition;
                float _Split_C8258E59_R_1 = _ScreenPosition_523BADB7_Out_0[0];
                float _Split_C8258E59_G_2 = _ScreenPosition_523BADB7_Out_0[1];
                float _Split_C8258E59_B_3 = _ScreenPosition_523BADB7_Out_0[2];
                float _Split_C8258E59_A_4 = _ScreenPosition_523BADB7_Out_0[3];
                float _Subtract_BEA11057_Out_2;
                Unity_Subtract_float(_Split_C8258E59_A_4, 1, _Subtract_BEA11057_Out_2);
                float _Subtract_68EE2B92_Out_2;
                Unity_Subtract_float(_SceneDepth_11839528_Out_1, _Subtract_BEA11057_Out_2, _Subtract_68EE2B92_Out_2);
                float _Property_F3AD9663_Out_0 = Vector1_5D08E19;
                float _Divide_BC8EFF54_Out_2;
                Unity_Divide_float(_Subtract_68EE2B92_Out_2, _Property_F3AD9663_Out_0, _Divide_BC8EFF54_Out_2);
                float _Saturate_50824368_Out_1;
                Unity_Saturate_float(_Divide_BC8EFF54_Out_2, _Saturate_50824368_Out_1);
                surface.Color = (_Multiply_81FA1D37_Out_2.xyz);
                surface.Alpha = _Saturate_50824368_Out_1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                float3 normalWS;
                float3 viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float3 interp02 : TEXCOORD2;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyz = input.viewDirectionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.viewDirectionWS = input.interp02.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpaceNormal =            input.normalWS;
                output.WorldSpaceViewDirection =     input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                output.WorldSpacePosition =          input.positionWS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                output.TimeParameters =              _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_SHADOWCASTER
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_BB09ACBD;
            float Vector1_BF320109;
            float Vector1_6D9BD116;
            float Vector1_6456C52;
            float4 Vector4_C854FE8B;
            float4 Color_A593EF6;
            float4 Color_1121E21B;
            float Vector1_B2C646A0;
            float Vector1_E0C44976;
            float Vector1_C9CDB2CB;
            float Vector1_A631F5A2;
            float Vector1_AE77181D;
            float Vector1_C91936D9;
            float Vector1_1AD22367;
            float Vector1_5B746A44;
            float Vector1_75D132BA;
            float Vector1_52B02E5A;
            float Vector1_5D08E19;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_426602DA_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_426602DA_Out_2);
                float _Property_24EE9EDC_Out_0 = Vector1_5B746A44;
                float _Divide_491E48E3_Out_2;
                Unity_Divide_float(_Distance_426602DA_Out_2, _Property_24EE9EDC_Out_0, _Divide_491E48E3_Out_2);
                float _Power_61450591_Out_2;
                Unity_Power_float(_Divide_491E48E3_Out_2, 3, _Power_61450591_Out_2);
                float3 _Multiply_C959B8D2_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_61450591_Out_2.xxx), _Multiply_C959B8D2_Out_2);
                float _Property_A381476F_Out_0 = Vector1_B2C646A0;
                float _Property_8B069924_Out_0 = Vector1_E0C44976;
                float4 _Property_2B98FF0C_Out_0 = Vector4_BB09ACBD;
                float _Split_CF0194C6_R_1 = _Property_2B98FF0C_Out_0[0];
                float _Split_CF0194C6_G_2 = _Property_2B98FF0C_Out_0[1];
                float _Split_CF0194C6_B_3 = _Property_2B98FF0C_Out_0[2];
                float _Split_CF0194C6_A_4 = _Property_2B98FF0C_Out_0[3];
                float3 _RotateAboutAxis_FA6782D8_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_2B98FF0C_Out_0.xyz), _Split_CF0194C6_A_4, _RotateAboutAxis_FA6782D8_Out_3);
                float _Property_A6566A31_Out_0 = Vector1_6D9BD116;
                float _Multiply_8D359B39_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_A6566A31_Out_0, _Multiply_8D359B39_Out_2);
                float2 _TilingAndOffset_490CAB2C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_8D359B39_Out_2.xx), _TilingAndOffset_490CAB2C_Out_3);
                float _Property_9764123B_Out_0 = Vector1_BF320109;
                float _GradientNoise_9D62F445_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_490CAB2C_Out_3, _Property_9764123B_Out_0, _GradientNoise_9D62F445_Out_2);
                float2 _TilingAndOffset_89726A34_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_89726A34_Out_3);
                float _GradientNoise_E9B9B822_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_89726A34_Out_3, _Property_9764123B_Out_0, _GradientNoise_E9B9B822_Out_2);
                float _Add_7631ABE6_Out_2;
                Unity_Add_float(_GradientNoise_9D62F445_Out_2, _GradientNoise_E9B9B822_Out_2, _Add_7631ABE6_Out_2);
                float _Divide_3A13ABE0_Out_2;
                Unity_Divide_float(_Add_7631ABE6_Out_2, 2, _Divide_3A13ABE0_Out_2);
                float _Saturate_577BE965_Out_1;
                Unity_Saturate_float(_Divide_3A13ABE0_Out_2, _Saturate_577BE965_Out_1);
                float _Property_C7839A3A_Out_0 = Vector1_C9CDB2CB;
                float _Power_956F0853_Out_2;
                Unity_Power_float(_Saturate_577BE965_Out_1, _Property_C7839A3A_Out_0, _Power_956F0853_Out_2);
                float4 _Property_3BBF5BF4_Out_0 = Vector4_C854FE8B;
                float _Split_D7D14ECD_R_1 = _Property_3BBF5BF4_Out_0[0];
                float _Split_D7D14ECD_G_2 = _Property_3BBF5BF4_Out_0[1];
                float _Split_D7D14ECD_B_3 = _Property_3BBF5BF4_Out_0[2];
                float _Split_D7D14ECD_A_4 = _Property_3BBF5BF4_Out_0[3];
                float4 _Combine_C24E1A18_RGBA_4;
                float3 _Combine_C24E1A18_RGB_5;
                float2 _Combine_C24E1A18_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_R_1, _Split_D7D14ECD_G_2, 0, 0, _Combine_C24E1A18_RGBA_4, _Combine_C24E1A18_RGB_5, _Combine_C24E1A18_RG_6);
                float4 _Combine_D87D4E0D_RGBA_4;
                float3 _Combine_D87D4E0D_RGB_5;
                float2 _Combine_D87D4E0D_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_B_3, _Split_D7D14ECD_A_4, 0, 0, _Combine_D87D4E0D_RGBA_4, _Combine_D87D4E0D_RGB_5, _Combine_D87D4E0D_RG_6);
                float _Remap_DD98F6C9_Out_3;
                Unity_Remap_float(_Power_956F0853_Out_2, _Combine_C24E1A18_RG_6, _Combine_D87D4E0D_RG_6, _Remap_DD98F6C9_Out_3);
                float _Absolute_47D58F21_Out_1;
                Unity_Absolute_float(_Remap_DD98F6C9_Out_3, _Absolute_47D58F21_Out_1);
                float _Smoothstep_32D30026_Out_3;
                Unity_Smoothstep_float(_Property_A381476F_Out_0, _Property_8B069924_Out_0, _Absolute_47D58F21_Out_1, _Smoothstep_32D30026_Out_3);
                float _Property_580A9D5D_Out_0 = Vector1_AE77181D;
                float _Multiply_21EBF1FD_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_580A9D5D_Out_0, _Multiply_21EBF1FD_Out_2);
                float2 _TilingAndOffset_262D76C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_21EBF1FD_Out_2.xx), _TilingAndOffset_262D76C_Out_3);
                float _Property_5E7655DE_Out_0 = Vector1_A631F5A2;
                float _GradientNoise_5A3FDB78_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_262D76C_Out_3, _Property_5E7655DE_Out_0, _GradientNoise_5A3FDB78_Out_2);
                float _Property_CA4974CC_Out_0 = Vector1_C91936D9;
                float _Multiply_D8984132_Out_2;
                Unity_Multiply_float(_GradientNoise_5A3FDB78_Out_2, _Property_CA4974CC_Out_0, _Multiply_D8984132_Out_2);
                float _Add_156C9593_Out_2;
                Unity_Add_float(_Smoothstep_32D30026_Out_3, _Multiply_D8984132_Out_2, _Add_156C9593_Out_2);
                float _Add_63BDC2FD_Out_2;
                Unity_Add_float(1, _Property_CA4974CC_Out_0, _Add_63BDC2FD_Out_2);
                float _Divide_50C8FD18_Out_2;
                Unity_Divide_float(_Add_156C9593_Out_2, _Add_63BDC2FD_Out_2, _Divide_50C8FD18_Out_2);
                float3 _Multiply_FF1A2A2_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_50C8FD18_Out_2.xxx), _Multiply_FF1A2A2_Out_2);
                float _Property_E92B26A_Out_0 = Vector1_6456C52;
                float3 _Multiply_FBD95215_Out_2;
                Unity_Multiply_float(_Multiply_FF1A2A2_Out_2, (_Property_E92B26A_Out_0.xxx), _Multiply_FBD95215_Out_2);
                float3 _Add_9AF10170_Out_2;
                Unity_Add_float3(IN.AbsoluteWorldSpacePosition, _Multiply_FBD95215_Out_2, _Add_9AF10170_Out_2);
                float3 _Add_3F87EC84_Out_2;
                Unity_Add_float3(_Multiply_C959B8D2_Out_2, _Add_9AF10170_Out_2, _Add_3F87EC84_Out_2);
                description.VertexPosition = _Add_3F87EC84_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_11839528_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_11839528_Out_1);
                float4 _ScreenPosition_523BADB7_Out_0 = IN.ScreenPosition;
                float _Split_C8258E59_R_1 = _ScreenPosition_523BADB7_Out_0[0];
                float _Split_C8258E59_G_2 = _ScreenPosition_523BADB7_Out_0[1];
                float _Split_C8258E59_B_3 = _ScreenPosition_523BADB7_Out_0[2];
                float _Split_C8258E59_A_4 = _ScreenPosition_523BADB7_Out_0[3];
                float _Subtract_BEA11057_Out_2;
                Unity_Subtract_float(_Split_C8258E59_A_4, 1, _Subtract_BEA11057_Out_2);
                float _Subtract_68EE2B92_Out_2;
                Unity_Subtract_float(_SceneDepth_11839528_Out_1, _Subtract_BEA11057_Out_2, _Subtract_68EE2B92_Out_2);
                float _Property_F3AD9663_Out_0 = Vector1_5D08E19;
                float _Divide_BC8EFF54_Out_2;
                Unity_Divide_float(_Subtract_68EE2B92_Out_2, _Property_F3AD9663_Out_0, _Divide_BC8EFF54_Out_2);
                float _Saturate_50824368_Out_1;
                Unity_Saturate_float(_Divide_BC8EFF54_Out_2, _Saturate_50824368_Out_1);
                surface.Alpha = _Saturate_50824368_Out_1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Back
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS_DEPTHONLY
            #define REQUIRE_DEPTH_TEXTURE
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Vector4_BB09ACBD;
            float Vector1_BF320109;
            float Vector1_6D9BD116;
            float Vector1_6456C52;
            float4 Vector4_C854FE8B;
            float4 Color_A593EF6;
            float4 Color_1121E21B;
            float Vector1_B2C646A0;
            float Vector1_E0C44976;
            float Vector1_C9CDB2CB;
            float Vector1_A631F5A2;
            float Vector1_AE77181D;
            float Vector1_C91936D9;
            float Vector1_1AD22367;
            float Vector1_5B746A44;
            float Vector1_75D132BA;
            float Vector1_52B02E5A;
            float Vector1_5D08E19;
            CBUFFER_END
        
            // Graph Functions
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
            {
                Rotation = radians(Rotation);
            
                float s = sin(Rotation);
                float c = cos(Rotation);
                float one_minus_c = 1.0 - c;
                
                Axis = normalize(Axis);
            
                float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                          one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                          one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                        };
            
                Out = mul(rot_mat,  In);
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            
            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }
            
            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            { 
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            void Unity_Saturate_float(float In, out float Out)
            {
                Out = saturate(In);
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
            {
                Out = smoothstep(Edge1, Edge2, In);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 AbsoluteWorldSpacePosition;
                float3 TimeParameters;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Distance_426602DA_Out_2;
                Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.AbsoluteWorldSpacePosition, _Distance_426602DA_Out_2);
                float _Property_24EE9EDC_Out_0 = Vector1_5B746A44;
                float _Divide_491E48E3_Out_2;
                Unity_Divide_float(_Distance_426602DA_Out_2, _Property_24EE9EDC_Out_0, _Divide_491E48E3_Out_2);
                float _Power_61450591_Out_2;
                Unity_Power_float(_Divide_491E48E3_Out_2, 3, _Power_61450591_Out_2);
                float3 _Multiply_C959B8D2_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, (_Power_61450591_Out_2.xxx), _Multiply_C959B8D2_Out_2);
                float _Property_A381476F_Out_0 = Vector1_B2C646A0;
                float _Property_8B069924_Out_0 = Vector1_E0C44976;
                float4 _Property_2B98FF0C_Out_0 = Vector4_BB09ACBD;
                float _Split_CF0194C6_R_1 = _Property_2B98FF0C_Out_0[0];
                float _Split_CF0194C6_G_2 = _Property_2B98FF0C_Out_0[1];
                float _Split_CF0194C6_B_3 = _Property_2B98FF0C_Out_0[2];
                float _Split_CF0194C6_A_4 = _Property_2B98FF0C_Out_0[3];
                float3 _RotateAboutAxis_FA6782D8_Out_3;
                Unity_Rotate_About_Axis_Degrees_float(IN.AbsoluteWorldSpacePosition, (_Property_2B98FF0C_Out_0.xyz), _Split_CF0194C6_A_4, _RotateAboutAxis_FA6782D8_Out_3);
                float _Property_A6566A31_Out_0 = Vector1_6D9BD116;
                float _Multiply_8D359B39_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_A6566A31_Out_0, _Multiply_8D359B39_Out_2);
                float2 _TilingAndOffset_490CAB2C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_8D359B39_Out_2.xx), _TilingAndOffset_490CAB2C_Out_3);
                float _Property_9764123B_Out_0 = Vector1_BF320109;
                float _GradientNoise_9D62F445_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_490CAB2C_Out_3, _Property_9764123B_Out_0, _GradientNoise_9D62F445_Out_2);
                float2 _TilingAndOffset_89726A34_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_89726A34_Out_3);
                float _GradientNoise_E9B9B822_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_89726A34_Out_3, _Property_9764123B_Out_0, _GradientNoise_E9B9B822_Out_2);
                float _Add_7631ABE6_Out_2;
                Unity_Add_float(_GradientNoise_9D62F445_Out_2, _GradientNoise_E9B9B822_Out_2, _Add_7631ABE6_Out_2);
                float _Divide_3A13ABE0_Out_2;
                Unity_Divide_float(_Add_7631ABE6_Out_2, 2, _Divide_3A13ABE0_Out_2);
                float _Saturate_577BE965_Out_1;
                Unity_Saturate_float(_Divide_3A13ABE0_Out_2, _Saturate_577BE965_Out_1);
                float _Property_C7839A3A_Out_0 = Vector1_C9CDB2CB;
                float _Power_956F0853_Out_2;
                Unity_Power_float(_Saturate_577BE965_Out_1, _Property_C7839A3A_Out_0, _Power_956F0853_Out_2);
                float4 _Property_3BBF5BF4_Out_0 = Vector4_C854FE8B;
                float _Split_D7D14ECD_R_1 = _Property_3BBF5BF4_Out_0[0];
                float _Split_D7D14ECD_G_2 = _Property_3BBF5BF4_Out_0[1];
                float _Split_D7D14ECD_B_3 = _Property_3BBF5BF4_Out_0[2];
                float _Split_D7D14ECD_A_4 = _Property_3BBF5BF4_Out_0[3];
                float4 _Combine_C24E1A18_RGBA_4;
                float3 _Combine_C24E1A18_RGB_5;
                float2 _Combine_C24E1A18_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_R_1, _Split_D7D14ECD_G_2, 0, 0, _Combine_C24E1A18_RGBA_4, _Combine_C24E1A18_RGB_5, _Combine_C24E1A18_RG_6);
                float4 _Combine_D87D4E0D_RGBA_4;
                float3 _Combine_D87D4E0D_RGB_5;
                float2 _Combine_D87D4E0D_RG_6;
                Unity_Combine_float(_Split_D7D14ECD_B_3, _Split_D7D14ECD_A_4, 0, 0, _Combine_D87D4E0D_RGBA_4, _Combine_D87D4E0D_RGB_5, _Combine_D87D4E0D_RG_6);
                float _Remap_DD98F6C9_Out_3;
                Unity_Remap_float(_Power_956F0853_Out_2, _Combine_C24E1A18_RG_6, _Combine_D87D4E0D_RG_6, _Remap_DD98F6C9_Out_3);
                float _Absolute_47D58F21_Out_1;
                Unity_Absolute_float(_Remap_DD98F6C9_Out_3, _Absolute_47D58F21_Out_1);
                float _Smoothstep_32D30026_Out_3;
                Unity_Smoothstep_float(_Property_A381476F_Out_0, _Property_8B069924_Out_0, _Absolute_47D58F21_Out_1, _Smoothstep_32D30026_Out_3);
                float _Property_580A9D5D_Out_0 = Vector1_AE77181D;
                float _Multiply_21EBF1FD_Out_2;
                Unity_Multiply_float(IN.TimeParameters.x, _Property_580A9D5D_Out_0, _Multiply_21EBF1FD_Out_2);
                float2 _TilingAndOffset_262D76C_Out_3;
                Unity_TilingAndOffset_float((_RotateAboutAxis_FA6782D8_Out_3.xy), float2 (1, 1), (_Multiply_21EBF1FD_Out_2.xx), _TilingAndOffset_262D76C_Out_3);
                float _Property_5E7655DE_Out_0 = Vector1_A631F5A2;
                float _GradientNoise_5A3FDB78_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_262D76C_Out_3, _Property_5E7655DE_Out_0, _GradientNoise_5A3FDB78_Out_2);
                float _Property_CA4974CC_Out_0 = Vector1_C91936D9;
                float _Multiply_D8984132_Out_2;
                Unity_Multiply_float(_GradientNoise_5A3FDB78_Out_2, _Property_CA4974CC_Out_0, _Multiply_D8984132_Out_2);
                float _Add_156C9593_Out_2;
                Unity_Add_float(_Smoothstep_32D30026_Out_3, _Multiply_D8984132_Out_2, _Add_156C9593_Out_2);
                float _Add_63BDC2FD_Out_2;
                Unity_Add_float(1, _Property_CA4974CC_Out_0, _Add_63BDC2FD_Out_2);
                float _Divide_50C8FD18_Out_2;
                Unity_Divide_float(_Add_156C9593_Out_2, _Add_63BDC2FD_Out_2, _Divide_50C8FD18_Out_2);
                float3 _Multiply_FF1A2A2_Out_2;
                Unity_Multiply_float(IN.ObjectSpaceNormal, (_Divide_50C8FD18_Out_2.xxx), _Multiply_FF1A2A2_Out_2);
                float _Property_E92B26A_Out_0 = Vector1_6456C52;
                float3 _Multiply_FBD95215_Out_2;
                Unity_Multiply_float(_Multiply_FF1A2A2_Out_2, (_Property_E92B26A_Out_0.xxx), _Multiply_FBD95215_Out_2);
                float3 _Add_9AF10170_Out_2;
                Unity_Add_float3(IN.AbsoluteWorldSpacePosition, _Multiply_FBD95215_Out_2, _Add_9AF10170_Out_2);
                float3 _Add_3F87EC84_Out_2;
                Unity_Add_float3(_Multiply_C959B8D2_Out_2, _Add_9AF10170_Out_2, _Add_3F87EC84_Out_2);
                description.VertexPosition = _Add_3F87EC84_Out_2;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpacePosition;
                float4 ScreenPosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _SceneDepth_11839528_Out_1;
                Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_11839528_Out_1);
                float4 _ScreenPosition_523BADB7_Out_0 = IN.ScreenPosition;
                float _Split_C8258E59_R_1 = _ScreenPosition_523BADB7_Out_0[0];
                float _Split_C8258E59_G_2 = _ScreenPosition_523BADB7_Out_0[1];
                float _Split_C8258E59_B_3 = _ScreenPosition_523BADB7_Out_0[2];
                float _Split_C8258E59_A_4 = _ScreenPosition_523BADB7_Out_0[3];
                float _Subtract_BEA11057_Out_2;
                Unity_Subtract_float(_Split_C8258E59_A_4, 1, _Subtract_BEA11057_Out_2);
                float _Subtract_68EE2B92_Out_2;
                Unity_Subtract_float(_SceneDepth_11839528_Out_1, _Subtract_BEA11057_Out_2, _Subtract_68EE2B92_Out_2);
                float _Property_F3AD9663_Out_0 = Vector1_5D08E19;
                float _Divide_BC8EFF54_Out_2;
                Unity_Divide_float(_Subtract_68EE2B92_Out_2, _Property_F3AD9663_Out_0, _Divide_BC8EFF54_Out_2);
                float _Saturate_50824368_Out_1;
                Unity_Saturate_float(_Divide_BC8EFF54_Out_2, _Saturate_50824368_Out_1);
                surface.Alpha = _Saturate_50824368_Out_1;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_Position;
                float3 positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_Position;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                float3 interp00 : TEXCOORD0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
                output.WorldSpacePosition =          input.positionWS;
                output.ScreenPosition =              ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
    }
    FallBack "Hidden/Shader Graph/FallbackError"
}
