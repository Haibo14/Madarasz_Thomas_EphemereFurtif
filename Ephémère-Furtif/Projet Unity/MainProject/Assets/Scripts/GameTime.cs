using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameTime : MonoBehaviour
{
    public static float ScrollWheel { get { return Input.mouseScrollDelta.y; } }

    public int currentValue;
    public int currentTime;
    void Start()
    {
     
        currentTime = 1;
        currentValue = 1;

        
    }

    
    void FixedUpdate()
    {
        currentValue = currentValue + (int)ScrollWheel;
        currentTime = currentValue;

        if(Time.timeScale <= 0)
        {
            currentTime = 1;
        }
        if(Time.timeScale >= 5)
        {
            currentTime = 5;
        }
        if(currentValue <= 0)
        {
            currentTime = 1;
            this.gameObject.GetComponent<TimeBody>().StartRewind();
        }

        Time.timeScale = currentTime;
    }
}
