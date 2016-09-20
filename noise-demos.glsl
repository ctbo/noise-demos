// Author: Harald Bögeholz, c't magazine, bo@ct.de
// Title: Educational example code for noise algorithms
// published in c't 21/16, p. 186

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float random (in vec2 st) { 
  return fract(sin(
      dot(st,vec2(12.9898,78.233))
    ) * 4758.1234);
}

// value noise
float vnoise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = smoothstep(0.,1.,f);
    return mix( mix(a, b, u.x),
                mix(c, d, u.x), u.y);
}

vec2 random2(in vec2 st){
    float a = random(st)*6.2831853;
    return vec2(cos(a), sin(a));
}

// gradient noise
float gnoise(vec2 st) {
  vec2 i=floor(st);
  vec2 g00=random2(i);
  vec2 g10=random2(i+vec2(1.0,0.0));
  vec2 g01=random2(i+vec2(0.0,1.0));
  vec2 g11=random2(i+vec2(1.0,1.0));

  vec2 f=fract(st);
  float v00=dot(g00, f);
  float v10=dot(g10, f-vec2(1.0,0.0));
  float v01=dot(g01, f-vec2(0.0,1.0));
  float v11=dot(g11, f-vec2(1.0,1.0));

  vec2 u=smoothstep(0.0,1.0,f);
  return mix( mix(v00,v10,u.x),
              mix(v01,v11,u.x), u.y)*1.4;
}

float wiggle(vec2 v, vec2 x, vec2 g){
  float d2=dot(v-x,v-x);
  float t=.5-d2;
  if (t > 0.0)
    return dot(g, v-x)*t*t*t*t;
  return 0.0;
}

// 2D simplex noise
float snoise(vec2 v) {
    const float F=0.366025403784439; // 0.5*(sqrt(3.0)-1.0)
    vec2 w = v + F*(v.x+v.y);
    vec2 i0 = floor(w);
    vec2 f = fract(w);
    vec2 i1 = vec2(0.0);
    if (f.x > f.y)
        i1 = i0 + vec2(1.0,0.0);
    else
        i1 = i0 + vec2(0.0,1.0);
    vec2 i2 = i0 + vec2(1.0,1.0);

    vec2 g0 = random2(i0);
    vec2 g1 = random2(i1);
    vec2 g2 = random2(i2);
    
	const float G=0.211324865405187; // (3.0-sqrt(3.0))/6.0
    vec2 x0 = i0 - G*(i0.x+i0.y);
	vec2 x1 = i1 - G*(i1.x+i1.y);
    vec2 x2 = i2 - G*(i2.x+i2.y);
    
    float v0 = wiggle(v, x0, g0);
    float v1 = wiggle(v, x1, g1);
    float v2 = wiggle(v, x2, g2);

    return (v0+v1+v2)*80.0;
    }

vec3 random3(in vec3 st){
    float a = random(st.xy)*6.2831853;
    float b = random(st.yz+vec2(17.,42.));
    return vec3(cos(a), -sin(a)*cos(b), sin(a)*sin(b));
}

float wiggle(vec3 v, vec3 x, vec3 g){
  float d2=dot(v-x,v-x);
  float t=.5-d2;
  if (t > 0.0)
    return dot(g, v-x)*t*t*t*t;
  return 0.0;
}

// 3D simplex noise
float snoise(vec3 v) {
    const float F=.3333333;
    vec3 w = v + F*(v.x+v.y+v.z);
    vec3 i0 = floor(w);
    vec3 f = fract(w);
    vec3 i1, i2;
    if (f.x < f.y) {
        if (f.y < f.z) { // x<y<z
            i1 = i0+vec3(0.,0.,1.);
            i2 = i0+vec3(0.,1.,1.);
        }
        else {
            if (f.x < f.z) { // x<z<y
            	i1 = i0+vec3(0.,1.,0.);
            	i2 = i0+vec3(0.,1.,1.);
        	}
            else { // z<x<y
                i1 = i0+vec3(0.,1.,0.);
                i2 = i0+vec3(1.,1.,0.);
            }
        }
    }
    else { // y<x
        if (f.x < f.z) { // y<x<z
            i1 = i0+vec3(0.,0.,1.);
            i2 = i0+vec3(1.,0.,1.);
        }
        else {
            if (f.z < f.y) { // z<y<x
                i1 = i0+vec3(1.,0.,0.);
                i2 = i0+vec3(1.,1.,0.);
            }
            else { // y<z<x
                i1 = i0+vec3(1.,0.,0.);
                i2 = i0+vec3(1.,0.,1.);
            }
        }
    }
    vec3 i3 = i0 + vec3(1.0,1.0,1.0);

    vec3 g0 = random3(i0);
    vec3 g1 = random3(i1);
    vec3 g2 = random3(i2);
    vec3 g3 = random3(i3);
    
	const float G=0.166666666;
    vec3 x0 = i0 - G*(i0.x+i0.y+i0.z);
	vec3 x1 = i1 - G*(i1.x+i1.y+i1.z);
    vec3 x2 = i2 - G*(i2.x+i2.y+i2.z);
	vec3 x3 = i3 - G*(i3.x+i3.y+i3.z);    
    
    float v0 = wiggle(v, x0, g0);
    float v1 = wiggle(v, x1, g1);
    float v2 = wiggle(v, x2, g2);
    float v3 = wiggle(v, x3, g3);

    return (v0+v1+v2+v3)*80.0;
    }

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;

    st *= 5.0;
    
    vec3 color = vec3(1.0);
    //color = vec3(random(floor(st+vec2(.5))));
    //color = vec3(vnoise(st));
    //color = vec3(gnoise(st)*.5+.5);
    //color = vec3(snoise(st)*.5+.5);
    //color = vec3(snoise(vec3(st, 0.0))*.5 + .5);
    //color = vec3(snoise(vec3(st, u_time*.2))*.5 + .5);
	float lava = smoothstep(0.126,0.524,snoise(vec3(st, u_time*.1)));
    color = mix(vec3(0.,0.,.2),vec3(.6,0.,0.),lava);
    gl_FragColor = vec4(color,1.0);
}
