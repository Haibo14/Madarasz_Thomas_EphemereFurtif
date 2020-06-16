using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ground : MonoBehaviour
{
    public GameObject groundParcel;

    public GameObject railPrefab;

    float playerZ;
    float railCreateCounter;

    int groundZ;
    int createCounterZ;
    int deleteCounterZ;
    int deleteCounter;

    void Start()
    {
       /* groundZ = 0;
        for (int j = 0; j < 5; j++)
        {
            for (int i = 0; i < 3; i++)
            {
                var newGroundParcel = (GameObject) Instantiate(groundParcel, new Vector3(10 * (i - 1), 0, j * 10), Quaternion.identity);
                newGroundParcel.name = "Ground" + i + "," + j;
            }
        }
        createCounterZ = 4;
        deleteCounterZ = 40;
        deleteCounter = 0;
        CreateGround();
        */
        for (int k = 0; k < 30; k++)
        {
            var newRail = (GameObject)Instantiate(railPrefab, new Vector3(0, 0.1f, k * 1.2f), Quaternion.identity);
        }

        railCreateCounter = 0.0f;
        CreateRail();

    }

    // Update is called once per frame
    void Update()
    {
        playerZ = this.transform.position.z;

       /* if(playerZ >= (groundZ + 2f))
        {
            groundZ = groundZ + 10;
            
            CreateGround();
        }

        if (playerZ >= deleteCounterZ)
        {
            deleteCounterZ = deleteCounterZ + 10;

            DeleteGround();
        }
        */
        if(playerZ >= (1.2f + railCreateCounter))
        {
            railCreateCounter = railCreateCounter + 1.2f;
            CreateRail();

        }
    }

  /*  void CreateGround()
    {
        createCounterZ++;
        for (int i = 0; i < 3; i++)
        {
           var newGroundParcel = (GameObject) Instantiate(groundParcel, new Vector3(10 * (i - 1), 0, groundZ + 40), Quaternion.identity);
           newGroundParcel.name = "Ground" + i + "," + createCounterZ;

        }
    }

    void DeleteGround()
    {
        string groundParcelName1 = "Ground" + 0 + "," + deleteCounter;
        string groundParcelName2 = "Ground" + 1 + "," + deleteCounter;
        string groundParcelName3 = "Ground" + 2 + "," + deleteCounter;

        GameObject groundParcel1 = GameObject.Find(groundParcelName1);
        GameObject groundParcel2 = GameObject.Find(groundParcelName2);
        GameObject groundParcel3 = GameObject.Find(groundParcelName3);

        Destroy(groundParcel1.gameObject);
        Destroy(groundParcel2.gameObject);
        Destroy(groundParcel3.gameObject);

        deleteCounter++;

    }*/

    void CreateRail()
    {
        var newRail = (GameObject)Instantiate(railPrefab, new Vector3(0, 0.1f, railCreateCounter + 36), Quaternion.identity);
    }
}
