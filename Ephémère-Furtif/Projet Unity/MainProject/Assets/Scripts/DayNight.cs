using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayNight : MonoBehaviour
{
    GameObject player;
    GameObject arduinoMaster;

    Material skyboxMaterial;

    float currentValue;
    float t;
    float a;
    float b;
    float c;
    float potentiometer;

    void Start()
    {
        player = GameObject.FindWithTag("Player");
        arduinoMaster = GameObject.FindWithTag("ArduinoMaster");

        skyboxMaterial = RenderSettings.skybox;
        skyboxMaterial.shader = Shader.Find("Shader Graphs/SkyBox");
        t = 0;
        b = 0;
    }


    void Update()
    {

        currentValue = player.GetComponent<TimeBody>().currentValue;

        if (currentValue > 1)
        {
            

            potentiometer = arduinoMaster.GetComponent<TestArduino>()._potentiometerNumber;
            a = potentiometer / 1000.0f;

            t = t + (a * Time.deltaTime);
            b = 0;
            
            if (t <= 1)
            {
                
                skyboxMaterial.SetFloat("Vector1_F36AB62C", t);
            }

        }

        if (currentValue <= 1)
        {
            t = 0;

            potentiometer = arduinoMaster.GetComponent<TestArduino>()._potentiometerNumber;
            a = potentiometer / 10.0f;

            b = b + ((a + 1f) * Time.deltaTime);
            c = 1 - b;

            if (c >= 0)
            {
                skyboxMaterial.SetFloat("Vector1_F36AB62C", c);
            }
        }
    }
}
