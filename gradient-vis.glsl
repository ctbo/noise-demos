// Author: Harald Bögeholz, c't magazine, bo@ct.de
// Title: gradient visualization for simplex noise algorithm
// published in c't 21/16, p. 186

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float circle(in vec2 st, in vec2 c, in float r){
    return smoothstep(-.01,0.,r-distance(st,c));
}

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;
	st = (st - .5) * 3.;
    
    float angle = u_time*.4;
    vec2 gradient = vec2(cos(angle),sin(angle));
    float b = dot(st, gradient);
    float t = 0.5 - dot(st,st);
    float red = smoothstep(-.01,0.,t) - smoothstep(0.,0.01,t);
    if (t > 0.0)
        t = t*t*t*t*16.0;
    else
        t = 0.0;
 
    vec3 color = vec3(b*t*6. * .5 + .5);

    color.r += red;

    vec2 sk = st + dot(st, vec2(0.3660254));
    vec2 skr = sk - floor(sk + vec2(.5));
    skr = skr - dot(skr, vec2(0.211324865));
    color.b += circle(skr, vec2(0.), .05);
    
    float ld = dot(st, vec2(-sin(angle),cos(angle)));
	if (t > 0.0 && b > 0.0)
    	color.g += smoothstep(-.01,.0,ld) - smoothstep(.0,.01,ld);
    
    gl_FragColor = vec4(color,1.0);
}
