{
  "version": "0.2.1",
  "timestamp": 1618513667376,
  "model": {
    "id": 2,
    "class": "heronarts.lx.structure.LXStructure",
    "internal": {
      "modulationColor": 0
    },
    "parameters": {
      "label": "LX",
      "syncModelFile": false
    },
    "children": {},
    "output": {
      "id": 3,
      "class": "heronarts.lx.structure.LXStructure$Output",
      "internal": {
        "modulationColor": 0
      },
      "parameters": {
        "label": "Output",
        "enabled": true,
        "brightness": 1.0,
        "fps": 0.0,
        "gamma": 1.0,
        "gammaMode": 1
      },
      "children": {}
    },
    "fixtures": [
      {
        "jsonFixtureType": "CustomStrip",
        "jsonParameters": {},
        "id": 31,
        "class": "heronarts.lx.structure.JsonFixture",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Custom strip 1",
          "x": 0.0,
          "y": 0.0,
          "z": 0.0,
          "yaw": 0.0,
          "pitch": 0.0,
          "roll": 0.0,
          "selected": true,
          "enabled": true,
          "brightness": 1.0,
          "identify": false,
          "mute": false,
          "solo": false,
          "fixtureType": "CustomStrip",
          "scale": 1.0
        },
        "children": {}
      }
    ]
  },
  "engine": {
    "id": 1,
    "class": "heronarts.lx.LXEngine",
    "internal": {
      "modulationColor": 0
    },
    "parameters": {
      "label": "Engine",
      "multithreaded": true,
      "channelMultithreaded": false,
      "networkMultithreaded": false,
      "framesPerSecond": 60.0,
      "speed": 1.0
    },
    "children": {
      "palette": {
        "id": 5,
        "class": "heronarts.lx.color.LXPalette",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Color Palette",
          "transitionEnabled": false,
          "transitionTimeSecs": 5.0,
          "transitionMode": 1,
          "autoCycleEnabled": false,
          "autoCycleMode": 0,
          "autoCycleTimeSecs": 60.0,
          "autoCycleCursor": -1,
          "triggerSwatchCycle": false
        },
        "children": {
          "swatch": {
            "id": 6,
            "class": "heronarts.lx.color.LXSwatch",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "Swatch",
              "recall": false,
              "autoCycleEligible": true
            },
            "children": {},
            "colors": [
              {
                "id": 7,
                "class": "heronarts.lx.color.LXDynamicColor",
                "internal": {
                  "modulationColor": 0
                },
                "parameters": {
                  "label": "LX",
                  "mode": 0,
                  "period": 30.0,
                  "primary/brightness": 100.0,
                  "primary/saturation": 100.0,
                  "primary/hue": 0.0,
                  "secondary/brightness": 100.0,
                  "secondary/saturation": 100.0,
                  "secondary/hue": 120.0
                },
                "children": {}
              }
            ]
          }
        },
        "swatches": []
      },
      "tempo": {
        "id": 9,
        "class": "heronarts.lx.Tempo",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Tempo",
          "clockSource": 0,
          "period": 500.0,
          "bpm": 120.0,
          "tap": false,
          "nudgeUp": false,
          "nudgeDown": false,
          "beatsPerMeasure": 4,
          "trigger": false,
          "enabled": false
        },
        "children": {
          "nudge": {
            "id": 10,
            "class": "heronarts.lx.modulator.LinearEnvelope",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "LENV",
              "running": false,
              "trigger": false,
              "loop": false,
              "tempoSync": false,
              "tempoMultiplier": 5,
              "tempoLock": true
            },
            "children": {},
            "basis": 0.0
          }
        }
      },
      "clips": {
        "id": 11,
        "class": "heronarts.lx.clip.LXClipEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "LX",
          "focusedClip": 0.0
        },
        "children": {}
      },
      "mixer": {
        "id": 12,
        "class": "heronarts.lx.mixer.LXMixerEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Mixer",
          "scene-1": false,
          "scene-2": false,
          "scene-3": false,
          "scene-4": false,
          "scene-5": false,
          "crossfader": 0.5,
          "crossfaderBlendMode": 0,
          "focusedChannel": 0,
          "cueA": false,
          "cueB": false,
          "viewCondensed": false
        },
        "children": {
          "master": {
            "id": 20,
            "class": "heronarts.lx.mixer.LXMasterBus",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "Master",
              "arm": false,
              "selected": false
            },
            "children": {},
            "effects": [],
            "clips": []
          }
        },
        "channels": [
          {
            "id": 37,
            "class": "heronarts.lx.mixer.LXChannel",
            "internal": {
              "modulationColor": 0,
              "controlsExpanded": true
            },
            "parameters": {
              "label": "Channel-1",
              "arm": false,
              "selected": true,
              "enabled": true,
              "cue": false,
              "fader": 1.0,
              "crossfadeGroup": 0,
              "blendMode": 0,
              "midiMonitor": false,
              "midiChannel": 16,
              "autoCycleEnabled": false,
              "autoCycleMode": 0,
              "autoCycleTimeSecs": 60.0,
              "transitionEnabled": false,
              "transitionTimeSecs": 5.0,
              "transitionBlendMode": 0,
              "focusedPattern": 1,
              "triggerPatternCycle": false
            },
            "children": {},
            "effects": [],
            "clips": [],
            "patternIndex": 1,
            "patterns": [
              {
                "id": 49,
                "class": "heronarts.lx.pattern.color.SolidPattern",
                "internal": {
                  "modulationColor": 0,
                  "expanded": true,
                  "modulationExpanded": false,
                  "autoCycleEligible": true
                },
                "parameters": {
                  "label": "Solid",
                  "color/brightness": 100.0,
                  "color/saturation": 100.0,
                  "color/hue": 237.00001525878906,
                  "colorMode": 0,
                  "paletteIndex": 1
                },
                "children": {
                  "modulation": {
                    "id": 50,
                    "class": "heronarts.lx.modulation.LXModulationEngine",
                    "internal": {
                      "modulationColor": 0
                    },
                    "parameters": {
                      "label": "Modulation"
                    },
                    "children": {},
                    "modulators": [],
                    "modulations": [],
                    "triggers": []
                  }
                },
                "deviceVersion": -1
              },
              {
                "id": 51,
                "class": "heronarts.lx.pattern.color.GradientPattern",
                "internal": {
                  "modulationColor": 0,
                  "expanded": true,
                  "modulationExpanded": false,
                  "autoCycleEligible": true
                },
                "parameters": {
                  "label": "Gradient",
                  "xAmount": -1.0,
                  "yAmount": -1.0,
                  "zAmount": 0.0,
                  "xOffset": -0.09523807838559151,
                  "yOffset": 0.0,
                  "zOffset": 0.0,
                  "colorMode": 1,
                  "blendMode": 1,
                  "gradient": 0.5238095335662365,
                  "fixedColor/brightness": 100.0,
                  "fixedColor/saturation": 100.0,
                  "fixedColor/hue": 0.0,
                  "xMode": 0,
                  "yMode": 0,
                  "zMode": 0,
                  "paletteIndex": 1,
                  "paletteStops": 5,
                  "gradientRange": 360.0
                },
                "children": {
                  "modulation": {
                    "id": 52,
                    "class": "heronarts.lx.modulation.LXModulationEngine",
                    "internal": {
                      "modulationColor": 0
                    },
                    "parameters": {
                      "label": "Modulation"
                    },
                    "children": {},
                    "modulators": [],
                    "modulations": [],
                    "triggers": []
                  }
                },
                "deviceVersion": -1
              }
            ]
          }
        ]
      },
      "modulation": {
        "id": 21,
        "class": "heronarts.lx.modulation.LXModulationEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Modulation"
        },
        "children": {},
        "modulators": [
          {
            "id": 34,
            "class": "heronarts.lx.modulator.VariableLFO",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "LFO",
              "running": true,
              "trigger": false,
              "loop": true,
              "tempoSync": false,
              "tempoMultiplier": 5,
              "tempoLock": true,
              "clockMode": 0,
              "periodFast": 1000.0,
              "periodSlow": 10000.0,
              "wave": 0,
              "skew": 0.0,
              "shape": 0.0,
              "bias": 0.0,
              "phase": 0.0,
              "exp": 0.0
            },
            "children": {},
            "basis": 0.21600000000022057
          }
        ],
        "modulations": [
          {
            "source": {
              "id": 34,
              "path": "/modulation/modulator/1"
            },
            "target": {
              "componentId": 51,
              "parameterPath": "xOffset",
              "path": "/mixer/channel/1/pattern/2/xOffset"
            },
            "id": 53,
            "class": "heronarts.lx.modulation.LXCompoundModulation",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "LX",
              "enabled": true,
              "Polarity": 1,
              "Range": 0.5750000150874257
            },
            "children": {}
          }
        ],
        "triggers": []
      },
      "output": {
        "id": 22,
        "class": "heronarts.lx.LXEngine$Output",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Output",
          "enabled": true,
          "brightness": 1.0,
          "fps": 0.0,
          "gamma": 1.0,
          "gammaMode": 1
        },
        "children": {}
      },
      "snapshots": {
        "id": 24,
        "class": "heronarts.lx.snapshot.LXSnapshotEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Snapshots",
          "recallMixer": true,
          "recallModulation": true,
          "recallPattern": true,
          "recallEffect": true,
          "channelMode": 0,
          "missingChannelMode": 0,
          "transitionEnabled": false,
          "transitionTimeSecs": 5.0,
          "autoCycleEnabled": false,
          "autoCycleMode": 0,
          "autoCycleTimeSecs": 60.0,
          "autoCycleCursor": -1,
          "triggerSnapshotCycle": false
        },
        "children": {},
        "snapshots": []
      },
      "midi": {
        "id": 25,
        "class": "heronarts.lx.midi.LXMidiEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "LX",
          "computerKeyboardEnabled": false
        },
        "children": {},
        "inputs": [],
        "surfaces": [],
        "mapping": []
      },
      "audio": {
        "id": 26,
        "class": "heronarts.lx.audio.LXAudioEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "Audio",
          "enabled": false,
          "mode": 0
        },
        "children": {
          "input": {
            "id": 27,
            "class": "heronarts.lx.audio.LXAudioInput",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "Input",
              "device": 0
            },
            "children": {}
          },
          "output": {
            "id": 28,
            "class": "heronarts.lx.audio.LXAudioOutput",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "Output",
              "file": "",
              "trigger": false,
              "looping": false,
              "play": false
            },
            "children": {}
          },
          "meter": {
            "id": 29,
            "class": "heronarts.lx.audio.GraphicMeter",
            "internal": {
              "modulationColor": 0
            },
            "parameters": {
              "label": "Meter",
              "running": false,
              "trigger": false,
              "gain": 0.0,
              "range": 48.0,
              "attack": 10.0,
              "release": 100.0,
              "slope": 4.5,
              "band-1": 0.0,
              "band-2": 0.0,
              "band-3": 0.0,
              "band-4": 0.0,
              "band-5": 0.0,
              "band-6": 0.0,
              "band-7": 0.0,
              "band-8": 0.0,
              "band-9": 0.0,
              "band-10": 0.0,
              "band-11": 0.0,
              "band-12": 0.0,
              "band-13": 0.0,
              "band-14": 0.0,
              "band-15": 0.0,
              "band-16": 0.0
            },
            "children": {}
          }
        }
      },
      "osc": {
        "id": 30,
        "class": "heronarts.lx.osc.LXOscEngine",
        "internal": {
          "modulationColor": 0
        },
        "parameters": {
          "label": "OSC",
          "receiveHost": "0.0.0.0",
          "receivePort": 3030,
          "receiveActive": false,
          "transmitHost": "localhost",
          "transmitPort": 3131,
          "transmitActive": false
        },
        "children": {}
      }
    }
  },
  "externals": {
    "ui": {
      "audioExpanded": true,
      "paletteExpanded": true,
      "cameraExpanded": true,
      "clipViewVisible": false,
      "modulatorExpanded": {
        "34": true
      },
      "preview": {
        "mode": 0,
        "animation": false,
        "animationTime": 1000.0,
        "projection": 0,
        "perspective": 60.0,
        "depth": 1.0,
        "phiLock": true,
        "centerPoint": false,
        "camera": {
          "active": false,
          "radius": 2475.0,
          "theta": 0.0,
          "phi": 0.0025146151892840862,
          "x": 825.0,
          "y": 405.0,
          "z": 0.0
        },
        "cue": [
          {
            "active": false,
            "radius": 2475.0,
            "theta": 0.0,
            "phi": 0.0025146151892840862,
            "x": 825.0,
            "y": 405.0,
            "z": 0.0
          },
          {
            "active": false,
            "radius": 120.0,
            "theta": 0.0,
            "phi": 0.0,
            "x": 0.0,
            "y": 0.0,
            "z": 0.0
          },
          {
            "active": false,
            "radius": 120.0,
            "theta": 0.0,
            "phi": 0.0,
            "x": 0.0,
            "y": 0.0,
            "z": 0.0
          },
          {
            "active": false,
            "radius": 120.0,
            "theta": 0.0,
            "phi": 0.0,
            "x": 0.0,
            "y": 0.0,
            "z": 0.0
          },
          {
            "active": false,
            "radius": 120.0,
            "theta": 0.0,
            "phi": 0.0,
            "x": 0.0,
            "y": 0.0,
            "z": 0.0
          },
          {
            "active": false,
            "radius": 120.0,
            "theta": 0.0,
            "phi": 0.0,
            "x": 0.0,
            "y": 0.0,
            "z": 0.0
          }
        ],
        "focus": 0,
        "pointCloud": {
          "pointSize": 3.0
        },
        "grid": {
          "visible": false,
          "spacing": 100.0,
          "planes": 1,
          "size": 10,
          "x": 0.0,
          "y": 0.0,
          "z": 0.0
        }
      }
    }
  }
}