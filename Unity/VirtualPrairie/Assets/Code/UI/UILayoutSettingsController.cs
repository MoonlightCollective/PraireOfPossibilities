using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
public class UILayoutSettingsController : MonoBehaviour
{
	[Header("Base")]
	public FixtureLayoutGen LayoutGenObj;

	[Header("Mode")]
	public TMP_Dropdown LayoutDropdown;

	[Header("Rings UI")]
	public GameObject RingsLayoutRoot;
	public UILabelSlider RingsFixtureCountSlider;
	public UILabelSlider RingsSpacingSlider;
	public UILabelSlider RingsCenterRadiusSlider;
	public UILabelSlider RingsAisleCountSlider;
	public UILabelSlider RingsAisleWidthSlider;
	public UILabelSlider RingsAisleCurveSlider;

	[Header("Grid UI")]
	public GameObject RowsLayoutRoot;
	public UILabelSlider RowsFixtureCountSlider;
	public UILabelSlider RowsSpacingSlider;
	public UILabelSlider RowsRowCountSlider;
	public UILabelSlider RowsRowSpacingSlider;

	bool _didFirstUpdate = false;

	public void Awake()
	{
		LayoutRebuilder.ForceRebuildLayoutImmediate(GetComponent<RectTransform>());
		LayoutDropdown.onValueChanged.AddListener(DropdownChanged);

		Slider[] sliders = GetComponentsInChildren<Slider>();
		foreach (var s in sliders)
		{
			s.onValueChanged.AddListener(SliderChanged);
		}

	}

	void Start()
	{
		updateUIFromSettings();
		RowsLayoutRoot.SetActive(true);
	}

	public void DropdownChanged(int val)
	{
		switch (LayoutDropdown.options[val].text)
		{
			case "Rings":
			default:
				LayoutGenObj.Algorithm = EFixtureLayoutAlgorithm.Rings;
				break;
			case "Grid":
				LayoutGenObj.Algorithm = EFixtureLayoutAlgorithm.Grid;
				break;
		}
		updateUIFromSettings();
	}

	public void SliderChanged(float val)
	{
		updateSettingsFromUI();
	}

	public void DoGenLayout()
	{
		var root = GameObject.Find("Layout").gameObject;
		LayoutGenObj.GenerateLayout(root);
	}
	public void Update()
	{
		if (!_didFirstUpdate)
		{
			updateUIFromSettings();
			_didFirstUpdate = true;
		}
	}

	void updateUIFromSettings()
	{
		LayoutGenObj.LoadLayoutSettings();
		switch (LayoutGenObj.Algorithm)
		{
			case EFixtureLayoutAlgorithm.Grid:
				RingsLayoutRoot.SetActive(false);
				RowsLayoutRoot.SetActive(true);
				break;
			default:
				RingsLayoutRoot.SetActive(true);
				RowsLayoutRoot.SetActive(false);
			break;
		}

		FixtureLayoutRings flr = LayoutGenObj.RingsLayout;
		RingsFixtureCountSlider.Slider.SetValueWithoutNotify(flr.NumFixtures);
		RingsSpacingSlider.Slider.SetValueWithoutNotify(flr.BaseSpacingFt);
		RingsCenterRadiusSlider.Slider.SetValueWithoutNotify(flr.CenterRadiusFt);
		RingsAisleWidthSlider.Slider.SetValueWithoutNotify(flr.AisleWidthFt);
		RingsAisleCurveSlider.Slider.SetValueWithoutNotify(flr.AisleCurve);
		RingsAisleCountSlider.Slider.SetValueWithoutNotify(flr.NumAisles);

		FixtureLayoutGrid glr = LayoutGenObj.GridLayout;
		RowsFixtureCountSlider.Slider.SetValueWithoutNotify(glr.NumFixtures);
		RowsSpacingSlider.Slider.SetValueWithoutNotify(glr.BaseSpacingFt);
		RowsRowCountSlider.Slider.SetValueWithoutNotify(glr.NumRows);
		RowsRowSpacingSlider.Slider.SetValueWithoutNotify(glr.RowSpacingFt);

		UILabelSlider[] sliders = GetComponentsInChildren<UILabelSlider>();
		foreach (var s in sliders)
		{
			s.OnUpdateValue(s.Slider.value);
		}

		LayoutRebuilder.ForceRebuildLayoutImmediate(GetComponent<RectTransform>());
	}

	void updateSettingsFromUI()
	{

		FixtureLayoutRings flr = LayoutGenObj.RingsLayout;
		flr.NumFixtures = (int) RingsFixtureCountSlider.Slider.value;
		flr.BaseSpacingFt = RingsSpacingSlider.Slider.value;
		flr.CenterRadiusFt = RingsCenterRadiusSlider.Slider.value;
		flr.AisleWidthFt = RingsAisleWidthSlider.Slider.value;
		flr.AisleCurve = RingsAisleCurveSlider.Slider.value;
		flr.NumAisles = (int) RingsAisleCountSlider.Slider.value;

		FixtureLayoutGrid glr = LayoutGenObj.GridLayout;
		glr.NumFixtures = (int) RowsFixtureCountSlider.Slider.value;
		glr.BaseSpacingFt = RowsSpacingSlider.Slider.value;
		glr.NumRows = (int)RowsRowCountSlider.Slider.value;
		glr.RowSpacingFt = RowsRowSpacingSlider.Slider.value;

		LayoutGenObj.SaveLayoutSettings();
	}

}
