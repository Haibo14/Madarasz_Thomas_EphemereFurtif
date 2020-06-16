using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateShader : MonoBehaviour
{
    public Renderer rend;
    public GameObject manager;

    float scrollValue;
    float shaderTimer;
    void Start()
    {
        rend = GetComponent<Renderer>();
        rend.material.shader = Shader.Find("Shader Graphs/Test");

        scrollValue = 1;
    }


    void Update()
    {
        scrollValue = this.gameObject.transform.parent.GetComponent<TimeBody>().currentValue;
        shaderTimer = shaderTimer + scrollValue * 0.001f;
        rend.material.SetFloat("Vector1_E154BCFA", shaderTimer);
        
        
    }
}
