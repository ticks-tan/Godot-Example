shader_type canvas_item;

uniform sampler2D vp : hint_screen_texture;
uniform float blur_radius = 0.5;

const float MATRIX = 2.3999632;
const int ITERATIONS = 200;

vec3 blur(sampler2D tex, vec2 uv, float radius)
{
	mat2 rot = mat2(vec2(cos(MATRIX), sin(MATRIX)), vec2(-sin(MATRIX), cos(MATRIX)));
	vec3 acc = vec3(0), div = acc;
  	float r = 1.;
  	vec2 vangle = vec2(0.0,radius*.01 / sqrt(float(ITERATIONS)));
   
	for (int j = 0; j < ITERATIONS; j++)
	{  
    	r += 1. / r;
		vangle = rot * vangle;
    	vec3 col = texture(tex, uv + (r-1.) * vangle).xyz; 
    	col = col * col *1.8;
		vec3 bokeh = pow(col, vec3(4));
		acc += col * bokeh;
		div += bokeh;
	}
	return acc / div;
}

void fragment(){
	COLOR = vec4(blur(vp, SCREEN_UV, blur_radius), 1);
}