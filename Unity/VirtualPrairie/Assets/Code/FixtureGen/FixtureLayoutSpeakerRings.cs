using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FixtureLayoutSpeakerRings : FixtureLayoutBase
{
	public float FalloffRadius = 25.0f;
	public float FalloffOverlapPct = 20.0f;
	float kDefaultFalloff = 20f;
	float kDefaultFalloffOverlapPct = 20;

	public override void LoadSettings()
	{
		FalloffRadius = PlayerPrefs.GetFloat("SpeakerFalloffRadius",kDefaultFalloff);
		FalloffOverlapPct = PlayerPrefs.GetFloat("FalloffOverlapPct", kDefaultFalloffOverlapPct);
	}

	public override void SaveSettings()
	{
		PlayerPrefs.SetFloat("SpeakerFalloffRadius",FalloffRadius);
		PlayerPrefs.SetFloat("FalloffOverlapPct", FalloffOverlapPct);
	}

	public override bool GenerateLayout(GameObject rootObj, GameObject fixturePrefab, GameObject portalPrefab = null, GameObject boothPrefab = null)
	{
		base.GenerateLayout(rootObj,fixturePrefab, portalPrefab, boothPrefab);

		// start radius is falloff radius plus overlap.
		

		return true;
	}
}
