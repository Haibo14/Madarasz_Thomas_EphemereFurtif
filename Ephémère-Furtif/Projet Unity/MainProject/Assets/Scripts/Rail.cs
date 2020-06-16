using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rail : MonoBehaviour
{
    GameObject planche1;
    GameObject planche2;
    GameObject railDroit;
    GameObject railGauche;

    Rigidbody rb_planche1;
    Rigidbody rb_planche2;
    Rigidbody rb_railDroit;
    Rigidbody rb_railGauche;

    Vector3 p1_gravity;
    Vector3 p2_gravity;
    Vector3 rd_gravity;
    Vector3 rg_gravity;

    Vector3 p1_torque;
    Vector3 p2_torque;
    Vector3 rd_torque;
    Vector3 rg_torque;

    float resetTime;
    float timer;
    public float timeLeft;

    bool deleteBegin;

    // Start is called before the first frame update
    void Start()
    {
        planche1 = this.gameObject.transform.GetChild(0).gameObject;
        planche2 = this.gameObject.transform.GetChild(1).gameObject;
        railDroit = this.gameObject.transform.GetChild(2).gameObject;
        railGauche = this.gameObject.transform.GetChild(3).gameObject;

        rb_planche1 = planche1.GetComponent<Rigidbody>();
        rb_planche2 = planche2.GetComponent<Rigidbody>();
        rb_railDroit = railDroit.GetComponent<Rigidbody>();
        rb_railGauche = railGauche.GetComponent<Rigidbody>();

        timeLeft = 20.0f;

        deleteBegin = false;

        
    }

    // Update is called once per frame
    void Update()
    {
        if(deleteBegin == true && !Input.GetKeyDown(KeyCode.Return))
        {
           
            timeLeft -= Time.deltaTime;

        }
        else
        {
            timeLeft = 20.0f;
        }

        if(timeLeft <= 0)
        {
           
            Destroy(this.gameObject);
        }

       
    }

    private void OnTriggerExit(Collider collider)
    {
        if(collider.tag == "Player")
        {
            rb_planche1.constraints = RigidbodyConstraints.None;
            rb_planche2.constraints = RigidbodyConstraints.None;
            rb_railDroit.constraints = RigidbodyConstraints.None;
            rb_railGauche.constraints = RigidbodyConstraints.None;

            rb_planche1.useGravity = true;
            rb_planche2.useGravity = true;
            rb_railDroit.useGravity = true;
            rb_railGauche.useGravity = true;

            p1_gravity = new Vector3(Random.Range(-50.0f, 50.0f), Random.Range(0.0f, 40.0f), Random.Range(-10.0f, 0.0f));
            p2_gravity = new Vector3(Random.Range(-50.0f, 50.0f), Random.Range(0.0f, 40.0f), Random.Range(-10.0f, 0.0f));
            rd_gravity = new Vector3(Random.Range(20.0f, 50.0f), Random.Range(0.0f, 40.0f), Random.Range(-10.0f, 0.0f));
            rg_gravity = new Vector3(Random.Range(-50.0f, -20.0f), Random.Range(0.0f, 40.0f), Random.Range(-10.0f, 0.0f));

            p1_torque = new Vector3( 0, Random.Range(-40.0f, 40.0f), 0);
            p2_torque = new Vector3( 0, Random.Range(-40.0f, 40.0f), 0);
            rd_torque = new Vector3( 0, Random.Range(-40.0f, 40.0f),  0);
            rg_torque = new Vector3( 0, Random.Range(-40.0f, 40.0f),  0);


            rb_planche1.AddForce(p1_gravity);
            rb_planche2.AddForce(p2_gravity);
            rb_railDroit.AddForce(rd_gravity);
            rb_railGauche.AddForce(rg_gravity);

            rb_planche1.AddTorque(p1_torque);
            rb_planche2.AddTorque(p2_torque);
            rb_railDroit.AddTorque(rd_torque);
            rb_railGauche.AddTorque(rg_torque);

            deleteBegin = true;

        }
    }

}
