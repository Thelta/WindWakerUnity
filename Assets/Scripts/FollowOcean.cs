using UnityEngine;
using System.Collections;

public class FollowOcean : MonoBehaviour 
{
	
	public Transform ocean;
	
	Transform ship;
	Vector3 startPos;
	Vector3 relativeShipPos;

	void Start () 
	{
		ship = this.transform;
		startPos = ship.position;
		relativeShipPos = startPos - ocean.position;
	}
	
	void Update () 
	{
		
		float sin1 = Sin1(Time.timeSinceLevelLoad, relativeShipPos.z);
		float sin2 = Sin2(relativeShipPos.x, Time.timeSinceLevelLoad);

		ship.position = new Vector3(startPos.x, sin1 + sin2 + startPos.y, startPos.z);
	}

	float Sin1(float x, float t)
	{
		return (Mathf.Sin(x + 2*t) + Mathf.Sin(0.7f*x - 2*t + 0.2f) - Mathf.Sin(1.5f*x+0.93f - t) + Mathf.Sin(0.2f*t)) / 12;
	}

	float Sin2(float x, float t)
	{
		return (Mathf.Sin(0.7f*x) - Mathf.Sin(0.2f*x - 1 + 3*t) + Mathf.Sin(2*x - 0.93f) + Mathf.Sin(t + 5)) / 12;
	}
}
