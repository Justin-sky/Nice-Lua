using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class RotateMesh : MonoBehaviour
{
    [HideInInspector]
    public Vector3 rotDir = new Vector3(0, 0.5f, 1);
    [HideInInspector]
    public Vector3 posDir = new Vector3(0, 0, 0);
    [HideInInspector]
    public Vector3 scaleDir = new Vector3(1, 1, 1);


    public void Start()
    {
        this.DoUpdateMaterial();
    }


    public void DoUpdateMaterial()
    {
        Quaternion q = Quaternion.LookRotation(rotDir);
        Matrix4x4 rot = new Matrix4x4();
     
        rot.SetTRS(posDir, q, scaleDir);
        MaterialPropertyBlock mb = new MaterialPropertyBlock();
        this.GetComponent<MeshRenderer>().GetPropertyBlock(mb);
        mb.SetMatrix("_RotationMatrix", rot);
        this.GetComponent<MeshRenderer>().SetPropertyBlock(mb);

    }
}
