//**************************************************************//
//  Effect File exported by RenderMonkey 1.6
//
//  - Although many improvements were made to RenderMonkey FX  
//    file export, there are still situations that may cause   
//    compilation problems once the file is exported, such as  
//    occasional naming conflicts for methods, since FX format 
//    does not support any notions of name spaces. You need to 
//    try to create workspaces in such a way as to minimize    
//    potential naming conflicts on export.                    
//    
//  - Note that to minimize resulting name collisions in the FX 
//    file, RenderMonkey will mangle names for passes, shaders  
//    and function names as necessary to reduce name conflicts. 
//**************************************************************//

//--------------------------------------------------------------//
// HDR
//--------------------------------------------------------------//
//--------------------------------------------------------------//
// HDR DX
//--------------------------------------------------------------//
//--------------------------------------------------------------//
// Environment
//--------------------------------------------------------------//
string HDR_HDR_DX_Environment_Sphere : ModelData = ".\\";

float4 vViewPosition : ViewPosition;
float4x4 matViewProjection : ViewProjection;

struct VS_INPUT 
{
   float3 Pos:     POSITION;
};

struct VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float3 TexCoord : TEXCOORD0;
};

VS_OUTPUT HDR_HDR_DX_Environment_Vertex_Shader_vs_main( VS_INPUT In )
{
   VS_OUTPUT Out;
   
   float3 pos = In.Pos;
   pos *= 200.0;
   pos += vViewPosition;
   
   Out.Pos = mul(matViewProjection, float4(pos,1.0));
   Out.TexCoord = normalize(In.Pos);

   return Out;
}




texture Snow_Tex
<
   string ResourceName = "..\\image-probs\\Oribi_2k.dds";
>;
samplerCUBE EnvironmentMap = sampler_state
{
   Texture = (Snow_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
};
texture FilmLut_Tex
<
   string ResourceName = ".\\FilmLut.tga";
>;
sampler2D FilmLut = sampler_state
{
   Texture = (FilmLut_Tex);
};

struct PS_INPUT 
{
   float3 TexCoord : TEXCOORD0;
};

struct PS_OUTPUT 
{
   float4 Color : COLOR;
};

PS_OUTPUT HDR_HDR_DX_Environment_Pixel_Shader_ps_main( PS_INPUT In )
{
   PS_OUTPUT Out;
   
   float3 texColor = texCUBE(EnvironmentMap,In.TexCoord);

   texColor *= 0.9;  // Hardcoded Exposure Adjustment

 

   float3 ld = 0.002;

   float linReference = 0.18;

   float logReference = 444;

   float logGamma = 0.45;

 

   float3 LogColor;

   LogColor.rgb = (log10(0.4*texColor.rgb/linReference)/ld*logGamma + logReference)/1023.f;

   LogColor.rgb = saturate(LogColor.rgb);

 

   float FilmLutWidth = 256;

   float Padding = .5/FilmLutWidth;

 

//  apply response lookup and color grading for target display

   float3 retColor;

   retColor.r = tex2D(FilmLut, float2( lerp(Padding,1-Padding,LogColor.r), .5)).r;

   retColor.g = tex2D(FilmLut, float2( lerp(Padding,1-Padding,LogColor.g), .5)).r;

   retColor.b = tex2D(FilmLut, float2( lerp(Padding,1-Padding,LogColor.b), .5)).r;
   Out.Color = float4(retColor,1);
   
   
   
   //Out.Color = texCUBE(EnvironmentMap,In.TexCoord) ;
   //Out.Color *= 1;
   //Out.Color = Out.Color /(1+Out.Color);
   //Out.Color = pow (Out.Color,1 / 2.2) ;
   
   return Out;
}




//--------------------------------------------------------------//
// Object
//--------------------------------------------------------------//
string HDR_HDR_DX_Object_Object : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\Teapot.3ds";

texture RTColor_Tex : RenderColorTarget
<
   float2 RenderTargetDimensions = {512,512};
   string Format="D3DFMT_A8R8G8B8";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float3 LightDir
<
   string UIName = "LightDir";
   string UIWidget = "Numeric";
   bool UIVisible =  false;
   float UIMin = -1.00;
   float UIMax = 1.00;
> = float3( -0.04, -1.00, -1.00 );
float4x4 HDR_HDR_DX_Object_Vertex_Shader_matViewProjection : ViewProjection;

struct HDR_HDR_DX_Object_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
   float3 Normal:   NORMAL;
   float3 Tangent:  TANGENT;
   float3 Binormal: BINORMAL;
   float2 TexCoord: TEXCOORD;
};

struct HDR_HDR_DX_Object_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
   float3 LightDirInTangent : TEXCOORD1;
};

HDR_HDR_DX_Object_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Object_Vertex_Shader_vs_main( HDR_HDR_DX_Object_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Object_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos = mul(HDR_HDR_DX_Object_Vertex_Shader_matViewProjection, float4(In.Pos,1.0));
   Out.TexCoord = In.TexCoord;
   
   float3x3 toTangentMat = float3x3(In.Tangent,
                                    In.Binormal,
                                    In.Normal);
   Out.LightDirInTangent = mul(toTangentMat,LightDir);

   return Out;
}


texture ObjectMap_Tex
<
   string ResourceName = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Textures\\Fieldstone.tga";
>;
sampler2D ObjectMap = sampler_state
{
   Texture = (ObjectMap_Tex);
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   MAGFILTER = LINEAR;
   ADDRESSU = WRAP;
   ADDRESSV = WRAP;
};
texture BumpMap_Tex
<
   string ResourceName = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Textures\\FieldstoneBumpDOT3.tga";
>;
sampler2D BumpMap = sampler_state
{
   Texture = (BumpMap_Tex);
   MAGFILTER = LINEAR;
   MINFILTER = LINEAR;
   MIPFILTER = LINEAR;
   ADDRESSU = WRAP;
   ADDRESSV = WRAP;
};

struct HDR_HDR_DX_Object_Pixel_Shader_PS_INPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
   float3 LightDirInTangent : TEXCOORD1;
};

struct HDR_HDR_DX_Object_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Object_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Object_Pixel_Shader_ps_main( HDR_HDR_DX_Object_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Object_Pixel_Shader_PS_OUTPUT Out;
   
   float4 texColor = tex2D(ObjectMap,In.TexCoord);
   float4 bump     = tex2D(BumpMap,In.TexCoord) * 2.0 - 1.0;
   
   float lighting = max(dot(bump.xyz,-normalize(In.LightDirInTangent)),0.4);
   
   Out.Color = texColor * lighting;
   Out.Color.a = 0.0;
      
   return Out;
}




//--------------------------------------------------------------//
// Shrinking
//--------------------------------------------------------------//
string HDR_HDR_DX_Shrinking_ScreenAlignedQuad : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

texture SmallSize_Tex : RenderColorTarget
<
   float2 RenderTargetDimensions = {128,128};
   string Format="D3DFMT_A16B16G16R16";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float4x4 HDR_HDR_DX_Shrinking_Vertex_Shader_matViewProjection;

struct HDR_HDR_DX_Shrinking_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
};

struct HDR_HDR_DX_Shrinking_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
};

HDR_HDR_DX_Shrinking_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Shrinking_Vertex_Shader_vs_main( HDR_HDR_DX_Shrinking_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Shrinking_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos.xy = sign(In.Pos);
   Out.Pos.z = 1.0;
   Out.Pos.w = 1.0;
   
   Out.TexCoord.x = Out.Pos.x * 0.5 + 0.5;
   Out.TexCoord.y = (1.0 - ( Out.Pos.y * 0.5 + 0.5 ));
   
   return Out;
}


sampler2D RT = sampler_state
{
   Texture = (RTColor_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};

struct HDR_HDR_DX_Shrinking_Pixel_Shader_PS_INPUT 
{
   float2 TexCoord : TEXCOORD0;
};

struct HDR_HDR_DX_Shrinking_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Shrinking_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Shrinking_Pixel_Shader_ps_main( HDR_HDR_DX_Shrinking_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Shrinking_Pixel_Shader_PS_OUTPUT Out;
   
   float4 texColor = tex2D(RT,In.TexCoord);
   
   Out.Color = texColor.a;
      
   return Out;
}




//--------------------------------------------------------------//
// Filter H
//--------------------------------------------------------------//
string HDR_HDR_DX_Filter_H_ScreenAlignedQuad : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

texture Blured1_Tex : RenderColorTarget
<
   float2 RenderTargetDimensions = {128,128};
   string Format="D3DFMT_A16B16G16R16";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float4x4 HDR_HDR_DX_Filter_H_Vertex_Shader_matViewProjection;

struct HDR_HDR_DX_Filter_H_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
};

struct HDR_HDR_DX_Filter_H_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
};

HDR_HDR_DX_Filter_H_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Filter_H_Vertex_Shader_vs_main( HDR_HDR_DX_Filter_H_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Filter_H_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos.xy = sign(In.Pos);
   Out.Pos.z = 1.0;
   Out.Pos.w = 1.0;
   
   Out.TexCoord.x = Out.Pos.x * 0.5 + 0.5;
   Out.TexCoord.y = 1.0 - (Out.Pos.y * 0.5 + 0.5);
   
   return Out;
}


sampler2D Src = sampler_state
{
   Texture = (SmallSize_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};

float4 gaussFilter[7] = 
{ 
  -3.0, 0.0, 0.0,  1.0/64.0,
  -2.0, 0.0, 0.0,  6.0/64.0,
  -1.0, 0.0, 0.0, 15.0/64.0,
   0.0, 0.0, 0.0, 20.0/64.0,
   1.0, 0.0, 0.0, 15.0/64.0,
   2.0, 0.0, 0.0,  6.0/64.0,
   3.0, 0.0, 0.0,  1.0/64.0 
 };

float texScaler = 1.0/128.0;
float texOffset = 0.0;

struct HDR_HDR_DX_Filter_H_Pixel_Shader_PS_INPUT 
{
   float2 TexCoord : TEXCOORD0;
};

struct HDR_HDR_DX_Filter_H_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Filter_H_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Filter_H_Pixel_Shader_ps_main( HDR_HDR_DX_Filter_H_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Filter_H_Pixel_Shader_PS_OUTPUT Out;
   
   float4 color = 0.0;
   
   int i;
   for (i=0;i<7;i++)
   {
      color += tex2D(Src,float2(In.TexCoord.x + gaussFilter[i].x * texScaler + texOffset,
                                In.TexCoord.y + gaussFilter[i].y * texScaler + texOffset)) * 
                    gaussFilter[i].w;
   } // End for
   
   Out.Color = color * 4.0;
      
   return Out;
}




//--------------------------------------------------------------//
// Filter V
//--------------------------------------------------------------//
string HDR_HDR_DX_Filter_V_ScreenAlignedQuad : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

texture Blured2_Tex : RenderColorTarget
<
   float2 RenderTargetDimensions = {128,128};
   string Format="D3DFMT_A16B16G16R16";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float4x4 HDR_HDR_DX_Filter_V_Vertex_Shader_matViewProjection;

struct HDR_HDR_DX_Filter_V_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
};

struct HDR_HDR_DX_Filter_V_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
};

HDR_HDR_DX_Filter_V_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Filter_V_Vertex_Shader_vs_main( HDR_HDR_DX_Filter_V_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Filter_V_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos.xy = sign(In.Pos);
   Out.Pos.z = 1.0;
   Out.Pos.w = 1.0;
   
   Out.TexCoord.x = Out.Pos.x * 0.5 + 0.5;
   Out.TexCoord.y = 1.0 - (Out.Pos.y * 0.5 + 0.5);
   
   return Out;
}


sampler2D HDR_HDR_DX_Filter_V_Pixel_Shader_Src = sampler_state
{
   Texture = (Blured1_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};

float4 HDR_HDR_DX_Filter_V_Pixel_Shader_gaussFilter[7] = 
{ 
   0.0, -3.0, 0.0,  1.0/64.0,
   0.0, -2.0, 0.0,  6.0/64.0,
   0.0, -1.0, 0.0, 15.0/64.0,
   0.0, 0.0, 0.0, 20.0/64.0,
   0.0, 1.0, 0.0, 15.0/64.0,
   0.0, 2.0, 0.0,  6.0/64.0,
   0.0, 3.0, 0.0,  1.0/64.0 
 };

float HDR_HDR_DX_Filter_V_Pixel_Shader_texScaler = 1.0/128.0;
float HDR_HDR_DX_Filter_V_Pixel_Shader_texOffset = 0.0;

struct HDR_HDR_DX_Filter_V_Pixel_Shader_PS_INPUT 
{
   float2 TexCoord : TEXCOORD0;
};

struct HDR_HDR_DX_Filter_V_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Filter_V_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Filter_V_Pixel_Shader_ps_main( HDR_HDR_DX_Filter_V_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Filter_V_Pixel_Shader_PS_OUTPUT Out;
   
   float4 color = 0.0;
   
   int i;
   for (i=0;i<7;i++)
   {
      color += tex2D(HDR_HDR_DX_Filter_V_Pixel_Shader_Src,float2(In.TexCoord.x + HDR_HDR_DX_Filter_V_Pixel_Shader_gaussFilter[i].x * HDR_HDR_DX_Filter_V_Pixel_Shader_texScaler + HDR_HDR_DX_Filter_V_Pixel_Shader_texOffset,
                                In.TexCoord.y + HDR_HDR_DX_Filter_V_Pixel_Shader_gaussFilter[i].y * HDR_HDR_DX_Filter_V_Pixel_Shader_texScaler + HDR_HDR_DX_Filter_V_Pixel_Shader_texOffset)) * 
                    HDR_HDR_DX_Filter_V_Pixel_Shader_gaussFilter[i].w;
   } // End for
   
   Out.Color = color * 4.0;
      
   return Out;
}




//--------------------------------------------------------------//
// Filter H 2
//--------------------------------------------------------------//
string HDR_HDR_DX_Filter_H_2_ScreenAlignedQuad : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

texture HDR_HDR_DX_Filter_H_2_Blured1 : RenderColorTarget
<
   float2 RenderTargetDimensions = {128,128};
   string Format="D3DFMT_A16B16G16R16";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float4x4 HDR_HDR_DX_Filter_H_2_Vertex_Shader_matViewProjection;

struct HDR_HDR_DX_Filter_H_2_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
};

struct HDR_HDR_DX_Filter_H_2_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
};

HDR_HDR_DX_Filter_H_2_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Filter_H_2_Vertex_Shader_vs_main( HDR_HDR_DX_Filter_H_2_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Filter_H_2_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos.xy = sign(In.Pos);
   Out.Pos.z = 1.0;
   Out.Pos.w = 1.0;
   
   Out.TexCoord.x = Out.Pos.x * 0.5 + 0.5;
   Out.TexCoord.y = 1.0 - (Out.Pos.y * 0.5 + 0.5);
   
   return Out;
}


sampler2D HDR_HDR_DX_Filter_H_2_Pixel_Shader_Src = sampler_state
{
   Texture = (Blured2_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};

float4 HDR_HDR_DX_Filter_H_2_Pixel_Shader_gaussFilter[7] = 
{ 
  -3.0, 0.0, 0.0,  1.0/64.0,
  -2.0, 0.0, 0.0,  6.0/64.0,
  -1.0, 0.0, 0.0, 15.0/64.0,
   0.0, 0.0, 0.0, 20.0/64.0,
   1.0, 0.0, 0.0, 15.0/64.0,
   2.0, 0.0, 0.0,  6.0/64.0,
   3.0, 0.0, 0.0,  1.0/64.0 
 };

float HDR_HDR_DX_Filter_H_2_Pixel_Shader_texScaler = 1.0/128.0;
float HDR_HDR_DX_Filter_H_2_Pixel_Shader_texOffset = 0.0;

struct HDR_HDR_DX_Filter_H_2_Pixel_Shader_PS_INPUT 
{
   float2 TexCoord : TEXCOORD0;
};

struct HDR_HDR_DX_Filter_H_2_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Filter_H_2_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Filter_H_2_Pixel_Shader_ps_main( HDR_HDR_DX_Filter_H_2_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Filter_H_2_Pixel_Shader_PS_OUTPUT Out;
   
   float4 color = 0.0;
   
   int i;
   for (i=0;i<7;i++)
   {
      color += tex2D(HDR_HDR_DX_Filter_H_2_Pixel_Shader_Src,float2(In.TexCoord.x + HDR_HDR_DX_Filter_H_2_Pixel_Shader_gaussFilter[i].x * HDR_HDR_DX_Filter_H_2_Pixel_Shader_texScaler + HDR_HDR_DX_Filter_H_2_Pixel_Shader_texOffset,
                                In.TexCoord.y + HDR_HDR_DX_Filter_H_2_Pixel_Shader_gaussFilter[i].y * HDR_HDR_DX_Filter_H_2_Pixel_Shader_texScaler + HDR_HDR_DX_Filter_H_2_Pixel_Shader_texOffset)) * 
                    HDR_HDR_DX_Filter_H_2_Pixel_Shader_gaussFilter[i].w;
   } // End for
   
   Out.Color = color * 4.0;
      
   return Out;
}




//--------------------------------------------------------------//
// Filter V 2
//--------------------------------------------------------------//
string HDR_HDR_DX_Filter_V_2_ScreenAlignedQuad : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

texture HDR_HDR_DX_Filter_V_2_Blured2 : RenderColorTarget
<
   float2 RenderTargetDimensions = {128,128};
   string Format="D3DFMT_A16B16G16R16";
   float  ClearDepth=1.000000;
   int    ClearColor=-16777216;
>;
float4x4 HDR_HDR_DX_Filter_V_2_Vertex_Shader_matViewProjection;

struct HDR_HDR_DX_Filter_V_2_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
};

struct HDR_HDR_DX_Filter_V_2_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
};

HDR_HDR_DX_Filter_V_2_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Filter_V_2_Vertex_Shader_vs_main( HDR_HDR_DX_Filter_V_2_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Filter_V_2_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos.xy = sign(In.Pos);
   Out.Pos.z = 1.0;
   Out.Pos.w = 1.0;
   
   Out.TexCoord.x = Out.Pos.x * 0.5 + 0.5;
   Out.TexCoord.y = 1.0 - (Out.Pos.y * 0.5 + 0.5);
   
   return Out;
}


sampler2D HDR_HDR_DX_Filter_V_2_Pixel_Shader_Src = sampler_state
{
   Texture = (Blured1_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};

float4 HDR_HDR_DX_Filter_V_2_Pixel_Shader_gaussFilter[7] = 
{ 
   0.0, -3.0, 0.0,  1.0/64.0,
   0.0, -2.0, 0.0,  6.0/64.0,
   0.0, -1.0, 0.0, 15.0/64.0,
   0.0, 0.0, 0.0, 20.0/64.0,
   0.0, 1.0, 0.0, 15.0/64.0,
   0.0, 2.0, 0.0,  6.0/64.0,
   0.0, 3.0, 0.0,  1.0/64.0 
 };

float HDR_HDR_DX_Filter_V_2_Pixel_Shader_texScaler = 1.0/128.0;
float HDR_HDR_DX_Filter_V_2_Pixel_Shader_texOffset = 0.0;

struct HDR_HDR_DX_Filter_V_2_Pixel_Shader_PS_INPUT 
{
   float2 TexCoord : TEXCOORD0;
};

struct HDR_HDR_DX_Filter_V_2_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Filter_V_2_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Filter_V_2_Pixel_Shader_ps_main( HDR_HDR_DX_Filter_V_2_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Filter_V_2_Pixel_Shader_PS_OUTPUT Out;
   
   float4 color = 0.0;
   
   int i;
   for (i=0;i<7;i++)
   {
      color += tex2D(HDR_HDR_DX_Filter_V_2_Pixel_Shader_Src,float2(In.TexCoord.x + HDR_HDR_DX_Filter_V_2_Pixel_Shader_gaussFilter[i].x * HDR_HDR_DX_Filter_V_2_Pixel_Shader_texScaler + HDR_HDR_DX_Filter_V_2_Pixel_Shader_texOffset,
                                In.TexCoord.y + HDR_HDR_DX_Filter_V_2_Pixel_Shader_gaussFilter[i].y * HDR_HDR_DX_Filter_V_2_Pixel_Shader_texScaler + HDR_HDR_DX_Filter_V_2_Pixel_Shader_texOffset)) * 
                    HDR_HDR_DX_Filter_V_2_Pixel_Shader_gaussFilter[i].w;
   } // End for
   
   Out.Color = color * 4.0;
      
   return Out;
}




//--------------------------------------------------------------//
// Final
//--------------------------------------------------------------//
string HDR_HDR_DX_Final_ScreenAlignedQuad : ModelData = "D:\\Program Files (x86)\\AMD\\RenderMonkey 1.82\\Examples\\Media\\Models\\ScreenAlignedQuad.3ds";

float4x4 HDR_HDR_DX_Final_Vertex_Shader_matViewProjection;

struct HDR_HDR_DX_Final_Vertex_Shader_VS_INPUT 
{
   float3 Pos:      POSITION;
};

struct HDR_HDR_DX_Final_Vertex_Shader_VS_OUTPUT 
{
   float4 Pos:       POSITION;
   float2 TexCoord : TEXCOORD0;
};

HDR_HDR_DX_Final_Vertex_Shader_VS_OUTPUT HDR_HDR_DX_Final_Vertex_Shader_vs_main( HDR_HDR_DX_Final_Vertex_Shader_VS_INPUT In )
{
   HDR_HDR_DX_Final_Vertex_Shader_VS_OUTPUT Out;
   
   Out.Pos.xy = sign(In.Pos);
   Out.Pos.z = 1.0;
   Out.Pos.w = 1.0;
   
   Out.TexCoord.x = Out.Pos.x * 0.5 + 0.5;
   Out.TexCoord.y = 1.0 - (Out.Pos.y * 0.5 + 0.5);
   
   return Out;
}

float Exposure
<
   string UIName = "Exposure";
   string UIWidget = "Numeric";
   bool UIVisible =  false;
   float UIMin = 0.00;
   float UIMax = 4.00;
> = float( 1.56 );
sampler2D SrcHDR = sampler_state
{
   Texture = (Blured2_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};
sampler2D SrcColor = sampler_state
{
   Texture = (RTColor_Tex);
   ADDRESSU = CLAMP;
   ADDRESSV = CLAMP;
};

struct HDR_HDR_DX_Final_Pixel_Shader_PS_INPUT 
{
   float2 TexCoord : TEXCOORD0;
};

struct HDR_HDR_DX_Final_Pixel_Shader_PS_OUTPUT 
{
   float4 Color : COLOR;
};

HDR_HDR_DX_Final_Pixel_Shader_PS_OUTPUT HDR_HDR_DX_Final_Pixel_Shader_ps_main( HDR_HDR_DX_Final_Pixel_Shader_PS_INPUT In )
{
   HDR_HDR_DX_Final_Pixel_Shader_PS_OUTPUT Out;
   
   float4 color  = tex2D(SrcColor,In.TexCoord);
   float4 scaler = tex2D(SrcHDR,In.TexCoord) * 2.0;
   
   Out.Color = color * ( ( 1.0 + scaler.a ) * Exposure );
      
   return Out;
}


//--------------------------------------------------------------//
// Technique Section for HDR
//--------------------------------------------------------------//
technique HDR_DX
{
   pass Environment
   {
      CULLMODE = CW;

      VertexShader = compile vs_1_1 HDR_HDR_DX_Environment_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Environment_Pixel_Shader_ps_main();
   }

   pass Object
   <
      string Script = "RenderColorTarget0 = RTColor_Tex;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      CULLMODE = CCW;

      VertexShader = compile vs_1_1 HDR_HDR_DX_Object_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Object_Pixel_Shader_ps_main();
   }

   pass Shrinking
   <
      string Script = "RenderColorTarget0 = SmallSize_Tex;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      CULLMODE = NONE;
      ZENABLE = FALSE;

      VertexShader = compile vs_1_1 HDR_HDR_DX_Shrinking_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Shrinking_Pixel_Shader_ps_main();
   }

   pass Filter_H
   <
      string Script = "RenderColorTarget0 = Blured1_Tex;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      VertexShader = compile vs_1_1 HDR_HDR_DX_Filter_H_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Filter_H_Pixel_Shader_ps_main();
   }

   pass Filter_V
   <
      string Script = "RenderColorTarget0 = Blured2_Tex;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      VertexShader = compile vs_1_1 HDR_HDR_DX_Filter_V_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Filter_V_Pixel_Shader_ps_main();
   }

   pass Filter_H_2
   <
      string Script = "RenderColorTarget0 = HDR_HDR_DX_Filter_H_2_Blured1;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      VertexShader = compile vs_1_1 HDR_HDR_DX_Filter_H_2_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Filter_H_2_Pixel_Shader_ps_main();
   }

   pass Filter_V_2
   <
      string Script = "RenderColorTarget0 = HDR_HDR_DX_Filter_V_2_Blured2;"
                      "ClearColor = (0, 0, 0, 255);"
                      "ClearDepth = 1.000000;";
   >
   {
      VertexShader = compile vs_1_1 HDR_HDR_DX_Filter_V_2_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Filter_V_2_Pixel_Shader_ps_main();
   }

   pass Final
   {
      VertexShader = compile vs_2_0 HDR_HDR_DX_Final_Vertex_Shader_vs_main();
      PixelShader = compile ps_2_0 HDR_HDR_DX_Final_Pixel_Shader_ps_main();
   }

}

