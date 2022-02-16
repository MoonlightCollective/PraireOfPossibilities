﻿using System.Collections;
using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

//
// StemColorManager represents a single DmxPoint that effects one or more light stems (fibers).
//  Handles DMX->color conversions, and making sure all appropriate materials are set.
//  Pulls from some global settings for things like glow intensity, etc.  This is basically
//  a single POINT of LXStudio, but rendered as a fiber.
//
public class StemColorManager : DmxColorPoint
{
	public List<Material> Materials = new List<Material>();
	public Material GlowMat;
	private List<Material> _groundGlowMats = new List<Material>();

	private Transform _rootTransform;

	// 
	// SetColor - set colors in the instanced materials for all mesh renderers associated with me.
	// 
	public void SetColor(Color color, float GlowIntensity, float Alpha)
	{
		Color mainColor = new Color(color.r,color.g,color.b,Alpha);
		foreach (var mat in Materials)
		{
			mat.SetColor("MainColor",mainColor);
			mat.SetColor("GlowColor", new Color(color.r*GlowIntensity, color.g*GlowIntensity, color.b*GlowIntensity));
			mat.SetFloat("GlowIntensity",GlowIntensity);
		}
		foreach (var gp in _groundGlowMats)
		{
			gp.SetColor("_GlowColor",new Color(color.r,color.g,color.b,GlobalPlantSettings.Instance.GroundGlowAlpha));
		}
	}

	//
	// SetFromDmx - calls Set Color using the data packet passed in new Data (rgb)
	// 
	public override void SetFromDmx(byte[] newData)
	{
		var settings = GlobalPlantSettings.Instance;
		float alpha = settings.StemAlpha;
		float glow = settings.GlowIntensity;

		SetColor(new Color(newData[0]/256f, newData[1]/256f, newData[2]/256f), glow, alpha);
	}

	public override void SetFromDmx(ArraySegment<byte> newData)
	{
		var settings = GlobalPlantSettings.Instance;
		float alpha = settings.StemAlpha;
		float glow = settings.GlowIntensity;
		int offset = newData.Offset;

		SetColor(new Color(newData.Array[offset]/256f, newData.Array[offset+1]/256f, newData.Array[offset+2]/256f), glow, alpha);
	}

	//
	// InitMaterials() - this happens separately from the construction, because we only want 
	//  				 to do this at runtime.  Find all our materials.
	//
	public void InitMaterials()
	{
		var meshes = transform.GetComponentsInChildren<MeshRenderer>();
		foreach (var mesh in meshes)
		{
			Materials.Add(mesh.material);
		}

		foreach (Transform child in transform)
		{
			var dp = child.GetComponent<DecalProjector>();
			if (dp != null)
			{
				dp.material = new Material(GlowMat);
				_groundGlowMats.Add(dp.material);
			}
		}
	}

}