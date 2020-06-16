using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeBody : MonoBehaviour {

	public static float ScrollWheel { get { return Input.mouseScrollDelta.y; } }

	public float potentiometer;

	public float currentValue;
	public float currentTime;

	public int pressedButton;

	GameObject player;
	GameObject arduinoMaster;
	GameObject arduinoMaster2;
	GameObject skySea;


	bool isRewinding = false;

	bool canRewind;
	public bool rewinding;

	public float recordTime = 5f;

	List<PointInTime> pointsInTime;

	Rigidbody rb;

	// Use this for initialization
	void Start () {

		pointsInTime = new List<PointInTime>();
		rb = GetComponent<Rigidbody>();

		player = GameObject.FindWithTag("Player");
		arduinoMaster = GameObject.FindWithTag("ArduinoMaster");
		arduinoMaster2 = GameObject.FindWithTag("ArduinoMaster2");
		skySea = GameObject.FindWithTag("SkySea");

		rewinding = false;

	}
	
	// Update is called once per frame
	void Update () {

		pressedButton = arduinoMaster2.GetComponent<TestArduino2>()._pressedButton;
		potentiometer = arduinoMaster.GetComponent<TestArduino>()._potentiometerNumber;

		currentValue = potentiometer/200;
		

		if (currentValue <= 1)
		{
			currentValue = 1;
		}
		if (currentValue >= 5)
		{
			currentValue = 4;
		}

		currentTime = currentValue;

		player.GetComponent<Move>().speed = 8.0f * currentTime;
		skySea.GetComponent<Move>().speed = 4.0f * currentTime;

		if (Input.GetKeyDown(KeyCode.Return) || pressedButton == 1)
		{

			if (currentValue == 1)
			{
				rewinding = true;
				StartRewind();

			}
		}
		if (Input.GetKeyUp(KeyCode.Return))
		{
			StopRewind();
		}
		
		
	}

	void FixedUpdate ()
	{

		

		if (isRewinding)
			Rewind();
		else
			Record();
	}



	public void Rewind ()
	{
	

			if (pointsInTime.Count > 0)
			{
				PointInTime pointInTime = pointsInTime[0];
				transform.position = pointInTime.position;
				transform.rotation = pointInTime.rotation;
				pointsInTime.RemoveAt(0);
				//Time.timeScale = 2;
			}
			else
			{
				StopRewind();
			}
		
		
	}

	void Record ()
	{
		if (pointsInTime.Count > Mathf.Round(recordTime / Time.fixedDeltaTime))
		{
			pointsInTime.RemoveAt(pointsInTime.Count - 1);
		}

		pointsInTime.Insert(0, new PointInTime(transform.position, transform.rotation));
	}

	public void StartRewind ()
	{
		isRewinding = true;
		rb.isKinematic = true;
		player.GetComponent<Move>().speed = 0.0f;
	}

	public void StopRewind ()
	{
		currentValue = 1;

		isRewinding = false;
		rb.isKinematic = false;

		rewinding = false;
		

		//Time.timeScale = 1;
	}
}
