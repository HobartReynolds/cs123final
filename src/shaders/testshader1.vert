//uniform variables
uniform samplerCube CubeMap;

uniform float sea_level;
uniform sampler2D bumpmap;
uniform sampler2D region1ColorMap;
uniform sampler2D region2ColorMap;
uniform sampler2D region3ColorMap;
uniform sampler2D region4ColorMap;
uniform float region1Max;
uniform float region2Max;
uniform float region3Max;
uniform float region4Max;
uniform float region1Min;
uniform float region2Min;
uniform float region3Min;
uniform float region4Min;

uniform float offsetX;
uniform float offsetY;

//varying variables
varying float intensity;
varying float height;
varying float blur;
uniform float focalDistance, focalRange;
varying float isWater;

varying vec4 V; //vertex
varying vec4 E; //eye
varying vec3 N; //surface normal

//constant
const vec4 L = vec4(1.0, 1.0, 1.0, 0.0); //light direction

void main(){
	//get the tex coord
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	//get the norm of the vertex
	vec3 vertexNorm = gl_NormalMatrix * gl_Normal;
	
	V = gl_ModelViewMatrix * gl_Vertex;
	E = gl_ProjectionMatrixInverse * vec4(0.0, 0.0, 0.0, 1.0);
	N = normalize(vertexNorm);
	
	float EPSILON = 1e-5;
	
	//check to see if the position is below the sea level
	if (gl_Vertex.z <= sea_level + EPSILON) {
		isWater = 1.0;
	}
	else {
		isWater = 0.0;
	}
	
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	
	blur = clamp(abs(-gl_Position.z - focalDistance) / focalRange, 0.0, 1.0);
	
	vec3 normalizedNorm = normalize(vertexNorm);
	
	//get the light direction
	vec4 lightDirection = gl_ModelViewMatrix * L;
	vec4 normalizedLight = normalize(lightDirection);
	
	intensity = dot(normalizedNorm, normalizedLight.xyz);
	
	//get the height
	height = gl_Vertex.z;
}
