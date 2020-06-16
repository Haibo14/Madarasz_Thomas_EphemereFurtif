using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestArduino2 : MonoBehaviour
{
    public int _pressedButton;

    public int pressedButton
    {
        get
        {
            return _pressedButton;
        }

        set
        {
            _pressedButton = value;
        }
    }
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(_pressedButton);

        if (_pressedButton == 1)
        {
            //Debug.Log("Pressed");
        }

        if (_pressedButton == 0)
        {
            //Debug.Log("PasPressed");
        }
    }
}
