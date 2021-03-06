from typing import List
import sys, getopt
import json
import math

class BaseFixture(object):
  def __init__(self, x:int, z:int, tags:str ):
    self.type = "7-pixel-base"
    self.x = x
    self.z = z
    self.tags = tags

class Protocol(object):
  def __init__(self, host:str, universe:int, start:int, num:int):
    self.host = host
    self.protocol = "artnet"
    self.byteOrder = "rgb"
    self.universe = universe
    self.start = start
    self.num = num

class Fixture(object):
  def __init__(self, label:str, comment:str, children:List[BaseFixture], outputs:List[Protocol]):
    self.label = label
    self.comment = comment
    self.children = children
    self.outputs = outputs

bases = []

FEET = 12 #using 1 = 1 inch
NUM_BASES = 436
POINTS_PER_BASE = 7
CENTER_DIAMETER = 60*FEET
BASE_SPACING = 8*FEET
CENTER_RADIUS = CENTER_DIAMETER/2
IP = "192.168.0.60"
AISLE_CURVE = 10 / 360 * 2 * math.pi    #how many degress to offset each ring from the previous; this will create the aisle curving
NUM_AISLES = 4
AISLE_WIDTH = 20*FEET
EYE_CENTER_X = -10 * FEET
EYE_CENTER_Z = 45 * FEET
EYE_SIZE = 14*FEET

basesLeftToAdd = NUM_BASES
basesAdded = 0
radius = CENTER_RADIUS
angle_offset = 0
ring = 0
last_ring = False
outputPolarFile = None

universe = 0
start = 0
startChannel = 1
remainingFreeChannels = 512
CHANNELS_PER_POINT = int(3) # 3 channels per point = RGB
CHANNELS_PER_BASE = int(POINTS_PER_BASE * CHANNELS_PER_POINT) 
BASES_PER_UNIVERSE = int(512 / CHANNELS_PER_BASE) 

outputs = []

for arg in sys.argv:
  if arg in ("-o"):
    outputPolarFile=open('polarCoordinates.txt','w')

while basesLeftToAdd > 0:
  perimeter = math.pi * 2 * radius
  angle = angle_offset
  light_run = ((perimeter / NUM_AISLES) - AISLE_WIDTH)       # distance covered by this consecutive run of lights
  ring_bases = int(light_run / BASE_SPACING) + 1             # number of bases used in this run -- with one base at start and finish of each run -- err on side of more density than less if not a perfect multiple
  aisle_angle = (AISLE_WIDTH  / perimeter) * 2 * math.pi     # angle of each aisle
  base_angle = ((light_run / (ring_bases - 1)) / perimeter) * 2 * math.pi   # figure out angle between bases on this particular stretch
  if (basesLeftToAdd <= (NUM_AISLES*ring_bases)):
    last_ring = True

  for k in range(NUM_AISLES):
    angle += aisle_angle                        # first take up the aisle width    

    for j in range(ring_bases):
      if (j==0 or j==(ring_bases-1)):     # figure out if light is on an edge (inner circle, outer circle, start or end of a run between aisles)
        tags = ["path","edge"]
      elif (ring == 0):
        tags = ["inner","edge"]
      elif (last_ring):
        tags = ["outer","edge"]
      else:
        tags = ["area"]
      
      x = radius * math.cos(angle)
      z = radius*math.sin(angle)

      if (k==0):
        if (math.sqrt((x-EYE_CENTER_X)*(x-EYE_CENTER_X) + (z-EYE_CENTER_Z)*(z-EYE_CENTER_Z)) >= EYE_SIZE):
          tags.append("yinyang")
      else:
        if (math.sqrt((x+EYE_CENTER_X)*(x+EYE_CENTER_X) + (z+EYE_CENTER_Z)*(z+EYE_CENTER_Z)) < EYE_SIZE or j==0 or j==(ring_bases-1) or ring==0 or last_ring):
          tags.append("yinyang")

      tags.append("section"+str(k))
      tags.append("ring"+str(ring))
      tags.append("base"+str(basesAdded))

      # do we have space in the current universe?
      if (remainingFreeChannels < CHANNELS_PER_BASE):
        # output the current universe
        points = int((512-remainingFreeChannels)/CHANNELS_PER_POINT)
        output = Protocol(IP, universe, start, points)
        outputs.append (output)
        # and bump to the next universe
        universe = universe + 1
        start = start + points
        startChannel = 1
        remainingFreeChannels = 512

      # output the polar field setup file
      if outputPolarFile:
        outputPolarFile.write("baseId:"+str(basesAdded+1)+",ring:"+str(ring)+",section:"+str(k)+",angle:"+str(round(math.degrees(angle))%360)+",radius:"+str(math.floor(radius/12))+"'"+str(math.floor(radius%12))+"\""+"\n")

      # use these channels
      remainingFreeChannels = remainingFreeChannels-CHANNELS_PER_BASE
      startChannel = startChannel+CHANNELS_PER_BASE

      # add the base
      base = BaseFixture(x=x, z=z, tags=tags)
      bases.append (base)
      basesLeftToAdd = basesLeftToAdd-1
      basesAdded = basesAdded+1
      angle += base_angle    # advance to the next base
    angle -= base_angle             # now move back when we get to the next aisle

  radius = radius + BASE_SPACING
  angle_offset += AISLE_CURVE       # each iteration, shift a little over so the aisle curves
  ring = ring + 1

# add the final universe
if remainingFreeChannels < 512:
  # output the current universe
  points = int((512-remainingFreeChannels)/CHANNELS_PER_POINT)
  output = Protocol(IP, universe, start, points)
  outputs.append (output)
  # and bump to the next universe
  universe = universe + 1
  start = start + points
  remainingFreeChannels = 512

spiral = Fixture(label="Rings", comment="Num Bases " + str(basesAdded), children=bases, outputs=outputs)
json_data = json.dumps(spiral, default=lambda o:o.__dict__, indent=4)
print(json_data)
if outputPolarFile:
  outputPolarFile.close()
  outputPolarFile = None
