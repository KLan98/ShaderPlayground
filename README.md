This project contains a collection of GLSL shaders designed for use in Unity-based graphics applications. The shaders demonstrate various rendering techniques such as lighting, real-time GPU-based rendering effects, Custom vertex and fragment shaders written in GLSL.

Although Unity primarily uses HLSL/ShaderLab, GLSL shaders can be utilized through OpenGL-compatible rendering pipelines or converted into Unity-compatible shader formats. The goal of this project is to showcase shader programming concepts that can be integrated into Unity workflows.

Mathematical concepts used in this repo:
- Linear interpolation and reverse linear interpolation for moving objects, creating transition between colors 
- Euclidean distance, Chebyshev  distance, Manhattan distance
- Sine and cosine for animating rendered shapes, colors

Applied GLSL built-in and non built-in functions:
Remap, Max, Min, Step, Smoothstep, Clamp, Sat, Fract...

## Signed distance field

A technique for rendering shapes by storing the minimum distance from a given point to the edge of the surface in 2D or 3D.

To draw a finite line passing through points A and B, use SDF, distance of point P to closest point on the finite line needs to be computed. Steps:
- Direction vector: $\vec{V}$ = $\vec{B}$ - $\vec{A}$
- Point vector: $\vec{U}$ = $\vec{P}$ - $\vec{A}$
- Projection variable: dot($\vec{U}$, $\vec{V}$) / dot($\vec{V}$, $\vec{V}$), clamp to [0, 1] is optional
- Distance from p to its closest point to finite line AB: Length($\vec{U}$ - $\vec{V}$ * projection) 

### Application of SDF

SDF can be used to render all sorts of exotic shapes. Here a combination of SDF and Fractal Brownian Motion is implemented to draw sine wave:

<img width="600" height="395" alt="wave" src="https://github.com/user-attachments/assets/56ef18f2-eb96-490a-acec-cc5650bfe8e2" />
