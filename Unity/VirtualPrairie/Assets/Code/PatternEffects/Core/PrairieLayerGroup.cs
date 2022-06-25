using System.Collections;
using System.Collections.Generic;
using NaughtyAttributes;
using PygmyMonkey.ColorPalette;
using UnityEngine;

[RequireComponent(typeof(ColorPaletteMixer))]
public class PrairieLayerGroup : MonoBehaviour
{
	public LayerGroupSettings GroupSettings;
	
	public virtual ColorPaletteMix GroupColors => _paletteMixer.ActiveColors;

	public virtual float GroupAlpha => GroupSettings.GroupAlpha;

	protected List<PrairiePatternLayer> _layers = new List<PrairiePatternLayer>();
	protected ColorPaletteMixer _paletteMixer;

	//===============
	// Maintain a list of patterns so we don't have to GetComponent every frame
	// on our children. We'll use the actual hierarchy to manage the patterns and
	// their order
	//===============
	public void OnTransformChildrenChanged()
	{
		rebuildLayerList();
	}

	public virtual void Start()
	{
		rebuildLayerList();
	}

	public virtual void Awake()
	{
		_paletteMixer = GetComponent<ColorPaletteMixer>();
	}

	//===============
	// Update - update all our patterns.
	//===============
	public virtual void Update()
	{
		if (!GroupSettings.Enabled)
		{
			return;
		}

		updateGroupPalette();
		
		foreach (var layer in _layers)
		{
			if (layer.gameObject.activeInHierarchy)
			{
				layer.Run(Time.deltaTime * layer.TimeSettings.TimeMult, this, PrairieUtil.Points);
			}
		}
	}
	
	//===============
	// Internal methods
	//===============

	// build our list of layers from transform's children
	protected void rebuildLayerList()
	{
		_layers.Clear();
		foreach (Transform child in transform)
		{
			PrairiePatternLayer pattern = child.GetComponent<PrairiePatternLayer>();
			if (pattern != null)
			{
				_layers.Add(pattern);
			}
		}
	}

	// based on our settings, figure out which color palette we should be using.
	protected virtual void updateGroupPalette()
	{
		if (_paletteMixer == null)
		{
			Debug.LogError($"LayerGroup {gameObject.name} requires a color palette mixer!");
			_paletteMixer = gameObject.AddComponent<ColorPaletteMixer>();
		}
	}
}