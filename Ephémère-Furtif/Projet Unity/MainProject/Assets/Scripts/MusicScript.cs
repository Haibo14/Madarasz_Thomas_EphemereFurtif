using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MusicScript : MonoBehaviour
{

    AudioSource audioSource;

    GameObject player;

    float currentValue;

    bool rewinding;

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
        //audioSource.timeSamples = audioSource.clip.samples - 1;
        audioSource.pitch = 0.9f;
        audioSource.Play();

        player = GameObject.FindWithTag("Player");

    }



    void Update()
    {
        currentValue = player.GetComponent<TimeBody>().currentValue;
        rewinding = player.GetComponent<TimeBody>().rewinding;


        if (currentValue == 1 && rewinding == false) 
        {
            audioSource.pitch = currentValue * 0.9f;
        }

        if (currentValue > 1)
        {
            audioSource.pitch = 2.0f;
        }

        if (rewinding == true)
        {
            audioSource.pitch = -1.0f;
        }
        
        Debug.Log(audioSource.pitch);
    }
}
