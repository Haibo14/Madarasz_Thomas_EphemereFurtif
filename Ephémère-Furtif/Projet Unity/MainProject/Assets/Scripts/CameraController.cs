using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public bool lockCursor;
    public float mouseSensivity = 10;
    public Transform target;
    public float dstFromTarget = 2;

    public Vector2 pitchMinMax = new Vector2(-40, 85);

    public float rotationSmoothTime = 0.12f;
    Vector3 rotationSmoothVelocity;
    Vector3 currentRotation;

    float yaw;
    float pitch;

    Transform cameraT;

    void Start()
    {
        
        Time.timeScale = 1f;

        if (lockCursor)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }

    // Update is called once per frame
    void LateUpdate()
    {
        yaw += Input.GetAxis("Mouse X") * mouseSensivity;
        pitch -= Input.GetAxis("Mouse Y") * mouseSensivity;
        pitch = Mathf.Clamp(pitch, pitchMinMax.x, pitchMinMax.y);

        currentRotation = Vector3.SmoothDamp(currentRotation, new Vector3(pitch, yaw), ref rotationSmoothVelocity, rotationSmoothTime);

        transform.eulerAngles = currentRotation;

        transform.position = target.position - transform.forward * dstFromTarget;
    }

}