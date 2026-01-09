Shader "VarryingExercise" { // defines the name of the shader 
   SubShader { // Unity chooses the subshader that fits the GPU best
      Pass { // some shaders require multiple passes
         GLSLPROGRAM // here begins the part in Unity's GLSL

         #ifdef VERTEX // here begins the vertex shader

         varying vec2 vUvs;

         void main() // all vertex shaders define a main() function
         {
            gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            vUvs = gl_MultiTexCoord0.xy;
         }

         #endif // here ends the definition of the vertex shader

         #ifdef FRAGMENT // here begins the fragment shader

         varying vec2 vUvs;

         void main() // all fragment shaders define a main() function
         {
            // vec3 color = vec3(vUvs.x);
            // vec3 color = vec3(1-vUvs.x); to flip the color 

            // gl_FragColor = vec4(color, 1.0);
            gl_FragColor = mix(vec4(1.0, 0.0, 0.0, 1.0), vec4(0.0, 1.0, 0.0, 1.0), vUvs.x);
         }

         #endif // here ends the definition of the fragment shader

         ENDGLSL // here ends the part in GLSL 
      }
   }
}