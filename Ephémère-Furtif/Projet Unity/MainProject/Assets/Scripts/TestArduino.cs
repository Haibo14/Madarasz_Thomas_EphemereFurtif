using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestArduino : MonoBehaviour
{

    public int _potentiometerNumber;

    public int potentiometerNumber {

        get {
            return _potentiometerNumber;
        }

        set {
            _potentiometerNumber = value;
        
        }
    
    }
 
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log(_potentiometerNumber);
    }
}
