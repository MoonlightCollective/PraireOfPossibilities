using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using M2MqttUnity;
using uPLibrary.Networking.M2Mqtt.Messages;
using UnityEngine.Events;
using NaughtyAttributes;

/// <summary>
/// Examples for the M2MQTT library (https://github.com/eclipse/paho.mqtt.m2mqtt),
/// </summary>

[System.Serializable]
public class TopicToEventEntry
{
	public string Topic;
	public UnityEvent<string> OnMessage;
}

public class MqttController : M2MqttUnityClient
{
	public List<TopicToEventEntry> TopicEvents;
	protected UIMqttStatus _statusUI;
	
	protected Dictionary<string,UnityEvent<string>> _eventMap = new Dictionary<string,UnityEvent<string>>();

	protected override void Awake()
	{
		_statusUI = GameObject.FindObjectOfType<UIMqttStatus>();
		base.Awake();
	}

	protected override void Start()
	{
		base.Start();
		if (!autoConnect)
		{
			DebugLogWarning("AutoConnect Disabled");
		}
	}

	protected override void OnConnected()
	{
		base.OnConnected();
		DebugLog("MQTT connected");
	}

	[Button("Resubscribe")]
	protected override void SubscribeTopics()
	{
		base.SubscribeTopics();
		List<string> topics = new List<string>();
		_eventMap.Clear();
		foreach (var entry in TopicEvents)
		{
			topics.Add(entry.Topic);
			_eventMap[entry.Topic] = entry.OnMessage;
		}
		if (topics.Count > 0)
		{
			client.Subscribe(topics.ToArray(),new byte[] { MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE });
			Debug.Log($"MqttControllerSubscribeTopics- subscribed to {topics.Count} mqtt topics");
		}
	}

	protected override void DecodeMessage(string topic, byte[] message)
	{
		base.DecodeMessage(topic, message);
		if (_eventMap.ContainsKey(topic))
		{
			string messageStr = new string(System.Text.UTF8Encoding.UTF8.GetString(message));
			DebugLog($"Event:{topic}.{messageStr}");
			_eventMap[topic].Invoke(messageStr);
		}
		else
		{
			string messageStr = new string(System.Text.UTF8Encoding.UTF8.GetString(message));
			DebugLog($"Ignoring: {topic}/{messageStr}");
		}
	}

	protected override void DebugLog(string dbgStr)
	{
		_statusUI?.NotifyDebug(dbgStr);
		Debug.Log(dbgStr);
	}

	protected override void DebugLogWarning(string warnStr)
	{
		_statusUI?.NotifyWarning(warnStr);
		Debug.LogWarning(warnStr);
	}

	protected override void DebugLogError(string errorStr)
	{
		_statusUI?.NotifyWarning(errorStr);
		Debug.LogError(errorStr);
	}
}