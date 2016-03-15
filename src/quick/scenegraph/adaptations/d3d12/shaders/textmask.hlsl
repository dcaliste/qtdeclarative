struct VSInput
{
    float4 position : POSITION;
    float2 coord : TEXCOORD0;
};

cbuffer ConstantBuffer : register(b0)
{
    float4x4 mvp;
    float2 textureScale;
    float dpr;
    float color;
};

struct PSInput
{
    float4 position : SV_POSITION;
    float2 coord : TEXCOORD0;
};

Texture2D tex : register(t0);
SamplerState samp : register(s0);

PSInput VS_TextMask(VSInput input)
{
    PSInput result;
    result.position = mul(mvp, floor(input.position * dpr + 0.5) / dpr);
    result.coord = input.coord * textureScale;
    return result;
}

float4 PS_TextMask24(PSInput input) : SV_TARGET
{
    float4 glyph = tex.Sample(samp, input.coord);
    return float4(glyph.rgb * color, glyph.a);
}
