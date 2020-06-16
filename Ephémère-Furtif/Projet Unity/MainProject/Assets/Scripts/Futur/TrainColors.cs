using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrainColors : MonoBehaviour
{
    GameObject player;
    Renderer rend;
    public float waitTime;
    float currentValue;
    bool coroutineWorking;
    public Material vitre;
    public Material RandomColor1;
    public Material RandomColor2;
    public Material RandomColor3;
    public Material RandomColor4;
    public Material RandomColor5;
    public Material RandomColor6;
    public Material RandomColor7;
    public Material RandomColor8;
    void Start()
    {
        player = GameObject.FindWithTag("Player");
        rend = this.GetComponent<Renderer>();

        coroutineWorking = false;

      
    }


    void Update()
    {
        currentValue = player.GetComponent<TimeBody>().currentValue;

        if (currentValue <= 1)
        {
            rend.materials[3].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[3] = vitre;
            rend.materials[3].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[4].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[4] = vitre;
            rend.materials[4].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[6].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[6] = vitre;
            rend.materials[6].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[7].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[7] = vitre;
            rend.materials[7].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[8].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[8] = vitre;
            rend.materials[8].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[9].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[9] = vitre;
            rend.materials[9].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[10].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[10] = vitre;
            rend.materials[10].shader = Shader.Find("Shader Graphs/Vitre");
            rend.materials[11].SetFloat("Vector1_F3CE005", 0f);
            rend.materials[11] = vitre;
            rend.materials[11].shader = Shader.Find("Shader Graphs/Vitre");
            StopAllCoroutines();
            
        }

        if (currentValue > 1)
        {
            waitTime = (10.0f * Time.deltaTime)/(currentValue);

            if(coroutineWorking == false)
            {
                StartCoroutine(Epilepsy());
                
            }
        }
       
    }

    IEnumerator Epilepsy()
    {
        while (true)
        {
            yield return new WaitForSeconds(waitTime);

            rend.materials[3] = RandomColor1;
            rend.materials[3].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[3].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[3].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[4] = RandomColor2;
            rend.materials[4].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[4].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[4].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[6] = RandomColor3;
            rend.materials[6].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[6].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[6].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[7] = RandomColor4;
            rend.materials[7].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[7].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[7].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[8] = RandomColor5;
            rend.materials[8].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[8].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[8].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[9] = RandomColor6;
            rend.materials[9].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[9].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[9].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[10] = RandomColor7;
            rend.materials[10].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[10].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[10].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

            rend.materials[11] = RandomColor8;
            rend.materials[11].shader = Shader.Find("Shader Graphs/Random Color 1");
            rend.materials[11].SetFloat("Vector1_F3CE005", 1f);
            rend.materials[11].SetFloat("Vector1_9CDAACC0", Random.Range(0.0f, 1.0f));

           
        }
        
    }
}
