using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class VertexMesh : MonoBehaviour
{
    void Start()
    {
        Mesh mesh = new Mesh();

        // Simple quad
        mesh.vertices = new Vector3[]
        {
            new Vector3(0, 0, 0),
            new Vector3(1, 0, 0),
            new Vector3(0, 1, 0),
            new Vector3(1, 1, 0)
        };

        mesh.colors = new Color[]
        {
            Color.red,    // bottom-left
            Color.blue,   // bottom-right
            Color.green,  // top-left
            Color.yellow  // top-right
        };

        mesh.triangles = new int[]
        {
            0,2,1, // clock wise
            2,3,1
        };

        // UV0 required even if unused
        mesh.uv = new Vector2[]
        {
            new Vector2(0,0),
            new Vector2(1,0),
            new Vector2(0,1),
            new Vector2(1,1)
        };

        mesh.RecalculateNormals();
        GetComponent<MeshFilter>().mesh = mesh;
    }
}