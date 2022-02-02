using System.Collections;
using UnityEngine;

public enum EFixtureLayoutAlgorithm
{
	Grid,
	Rings,
}

//
// FixtureLayoutGen - doesn't do the actual generation, but gives access to 
// 						layout algorithms. Called from either the editor UI
//						or the app/game itself.
//
public class FixtureLayoutGen : MonoBehaviour
{
	public EFixtureLayoutAlgorithm Algorithm;
	public GameObject FixturePrefab;
	
	protected FixtureLayoutGrid _gridLayout;

	public void Awake()
	{
		_gridLayout = GetComponent<FixtureLayoutGrid>();
	}

	public void GenerateLayout(GameObject parentObj)
	{
		switch (Algorithm)
		{
			case EFixtureLayoutAlgorithm.Grid:
				_gridLayout = GetComponent<FixtureLayoutGrid>();
				_gridLayout.GenerateLayout(parentObj,FixturePrefab);
				break;
			default:
			break;
		}
	}
}