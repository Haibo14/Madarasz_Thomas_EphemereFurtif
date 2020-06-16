using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PetalsColor : MonoBehaviour
{
    private ParticleSystem ps;

    GameObject player;

    Color randomColor;

    float currentValue;

    void Start()
    {
        player = GameObject.FindWithTag("Player");

        ps = GetComponent<ParticleSystem>();
    }

    // Update is called once per frame
    void Update()
    {
        currentValue = player.GetComponent<TimeBody>().currentValue;

        var main = ps.main;

        if (currentValue <= 1)
        {
            main.startColor = Color.white;

           
        }

        if (currentValue > 1)
        {
            randomColor = new Color(
               Random.Range(0f, 1f),
               Random.Range(0f, 1f),
               Random.Range(0f, 1f)
               );

            main.startColor = randomColor;
        }
    }

}