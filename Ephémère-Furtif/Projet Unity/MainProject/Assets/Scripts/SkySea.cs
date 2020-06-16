using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkySea : MonoBehaviour
{
    GameObject player;

    public Renderer rend;

    public float speed;
    float startTime;
    float t;
    float a;
    float b;
    float currentValue;

    Color currentColor1;
    Color currentColor2;
    public Color randomColor1;
    public Color randomColor2;
    public Color baseColor1;
    public Color baseColor2;
    public Color Blue;
    public Color Cyan;
    public Color Orange;
    public Color Rose;
    public Color Rouge;
    public Color Noir;
    public Color Vert;
    public Color Jaune;

    public float potentiometer;
    GameObject arduinoMaster;

    bool playOnce;

    void Start()
    {
        startTime = Time.time;

        player = GameObject.FindWithTag("Player");

        rend = GetComponent<Renderer>();
        rend.material.shader = Shader.Find("Unlit Master");

        arduinoMaster = GameObject.FindWithTag("ArduinoMaster");

        rend.material.SetColor("Color_A593EF6", baseColor1);
        rend.material.SetColor("Color_1121E21B", baseColor2);

        t = 0;
        b = 0;

        playOnce = true;
    }

    // Update is called once per frame
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

                if (playOnce == true)
                {
                    randomColor1 = new Color(
                Random.Range(0f, 1f),
                Random.Range(0f, 1f),
                Random.Range(0f, 1f)
                );

                    randomColor2 = new Color(
                Random.Range(0f, 1f),
                Random.Range(0f, 1f),
                Random.Range(0f, 1f)
                );
                    playOnce = false;
                }

                rend.material.SetColor("Color_A593EF6", Color.Lerp(currentColor1, randomColor1, t));
                rend.material.SetColor("Color_1121E21B", Color.Lerp(currentColor2, randomColor2, t));
                currentColor1 = rend.material.GetColor("Color_A593EF6");
                currentColor2 = rend.material.GetColor("Color_1121E21B");
            }
            else
            {
                t = t - 1;
                playOnce = true;
            }

            rend.material.SetFloat("Vector1_1AD22367", 0.7f);
            rend.material.SetFloat("Vector1_AE77181D", 200f);
        }

        if (currentValue <= 1)
        {

            potentiometer = arduinoMaster.GetComponent<TestArduino>()._potentiometerNumber;
            a = potentiometer / 1000.0f;

            b = b + (a * Time.deltaTime);

            currentColor1 = rend.material.GetColor("Color_A593EF6");
            currentColor2 = rend.material.GetColor("Color_1121E21B");
            rend.material.SetColor("Color_A593EF6", Color.Lerp(currentColor1, baseColor1, b));
            rend.material.SetColor("Color_1121E21B", Color.Lerp(currentColor2, baseColor2, b));

            rend.material.SetFloat("Vector1_1AD22367", 1.3f);
            rend.material.SetFloat("Vector1_AE77181D", 30f);
            
        }



        /*
        potentiometer = arduinoMaster.GetComponent<TestArduino>()._potentiometerNumber;
        a = potentiometer / 100000.0f;
        
        t = t + a;
        if (t <= 1)
        {
            rend.material.SetColor("Color_A593EF6", Color.Lerp(Blue, Jaune, t));
            rend.material.SetColor("Color_1121E21B", Color.Lerp(Cyan, Vert, t));
        }
        if (t > 1 && t <= 2)
        {
            rend.material.SetColor("Color_A593EF6", Color.Lerp(Jaune, Rose, t - 1));
            rend.material.SetColor("Color_1121E21B", Color.Lerp(Vert, Orange, t- 1));
        }
        if (t > 2 && t <= 3)
        {
            rend.material.SetColor("Color_A593EF6", Color.Lerp(Rose, Rouge, t - 2));
            rend.material.SetColor("Color_1121E21B", Color.Lerp(Orange, Noir, t - 2));
        }
        if (t > 3 && t < 4)
        {
            rend.material.SetColor("Color_A593EF6", Color.Lerp(Rouge, Blue, t - 3));
            rend.material.SetColor("Color_1121E21B", Color.Lerp(Noir, Cyan, t - 3));
        }
        if (t >= 4)
        {
            t = t - 4;
        }

        
        */
    }
}
