using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sandglass : MonoBehaviour
{

    public Material material;
    float speed = 0.00003f;

    private float t = 0.035f;
    
    void Start()
    {
        
    }

 
    void Update()
    {
        t -= speed * Time.deltaTime * transform.up.y;
        t = Mathf.Clamp01(t);
        material.SetFloat("Vector1_1ACCCD71", t);
    }
}
