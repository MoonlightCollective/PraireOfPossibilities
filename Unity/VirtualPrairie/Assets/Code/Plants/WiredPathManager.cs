using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WiredPathManager : MonoBehaviour
{
	static private WiredPathManager s_instance;
	static public WiredPathManager Instance => s_instance;

	public List<WiredPath> Paths = new List<WiredPath>();
	public GameObject WiredPathFab;

	public static WiredPath NewPathInstance()
	{
		GameObject go = GameObject.Instantiate(Instance.WiredPathFab);
		return go.GetComponent<WiredPath>();
	}

	void Awake()
	{
		s_instance = this;
	}

	public void ShowAllPaths()
	{
		foreach (var path in Paths)
		{
			path.SetVisibility(WiredPath.EPathVisState.Visible);
		}
	}
	public void HideAllPaths()
	{
		foreach (var path in Paths)
		{
			path.SetVisibility(WiredPath.EPathVisState.Hidden);
		}
	}
}
