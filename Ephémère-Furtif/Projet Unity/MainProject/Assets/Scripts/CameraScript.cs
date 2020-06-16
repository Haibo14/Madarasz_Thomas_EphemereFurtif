using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraScript : MonoBehaviour
{
    GameObject player;

    public bool lockCursor;
    bool rewinding;

    public Transform target;

    public float dstFromTarget = 10;
    public float fovSpeed;  

    float currentValue;
    float t;

    public float rotationSmoothTime = 0.12f;
    Vector3 rotationSmoothVelocity;
    Vector3 currentRotation;

    void Start()
    {
        Time.timeScale = 1f;

        player = GameObject.FindWithTag("Player");

        t = 0;

        Camera.main.fieldOfView = 60.0f;

        rewinding = false;

        if (lockCursor)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }

    // Update is called once per frame
    void LateUpdate()
    {
        currentValue = player.GetComponent<TimeBody>().currentValue;
        rewinding = player.GetComponent<TimeBody>().rewinding;
        

        if (currentValue <= 1 && rewinding == false)
        {
            t += (2f * Time.deltaTime);
            rotationSmoothTime = 0.5f;
            Camera.main.fieldOfView = Mathf.Lerp(Camera.main.fieldOfView, 60.0f, fovSpeed);
            dstFromTarget = 10;
            currentRotation = Vector3.SmoothDamp(currentRotation, new Vector3(0, t), ref rotationSmoothVelocity, rotationSmoothTime);
        }

        if (currentValue > 1)
        {
            t = 0;
            rotationSmoothTime = 0.5f;
            Camera.main.fieldOfView = Mathf.Lerp(Camera.main.fieldOfView, 120.0f, fovSpeed);
            dstFromTarget = 10;
            currentRotation = Vector3.SmoothDamp(currentRotation, new Vector3(15, 0), ref rotationSmoothVelocity, rotationSmoothTime);
        }

        if (rewinding == true)
        {
            t -= (2f * Time.deltaTime);
            rotationSmoothTime = 0.5f;
            Camera.main.fieldOfView = Mathf.Lerp(Camera.main.fieldOfView, 60.0f, fovSpeed);
            dstFromTarget = 10;
            currentRotation = Vector3.SmoothDamp(currentRotation, new Vector3(0, t), ref rotationSmoothVelocity, rotationSmoothTime);
        }

        transform.eulerAngles = currentRotation;

        transform.position = target.position - transform.forward * dstFromTarget;
    }
}
