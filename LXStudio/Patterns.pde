import java.util.ArrayList;
import java.util.Iterator;

// In this file you can define your own custom patterns


// Here is a fairly basic example pattern that renders a plane that can be moved
// across one of the axes.
@LXCategory("Form")
public static class PlanePattern extends LXPattern {
  
  public enum Axis {
    X, Y, Z
  };
  
  public final EnumParameter<Axis> axis =
    new EnumParameter<Axis>("Axis", Axis.X)
    .setDescription("Which axis the plane is drawn across");
  
  public final CompoundParameter pos = new CompoundParameter("Pos", 0, 1)
    .setDescription("Position of the center of the plane");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Thickness of the plane");
  
  public PlanePattern(LX lx) {
    super(lx);
    addParameter("axis", this.axis);
    addParameter("pos", this.pos);
    addParameter("width", this.wth);
  }
  
  public void run(double deltaMs) {
    float falloff = 100 / this.wth.getValuef();
    float start = -this.wth.getValuef();
    float range = 1 + (2*this.wth.getValuef());
    float pos = start + (this.pos.getValuef() * range);
    
    float n = 0;
    for (LXPoint p : model.points) {
      switch (this.axis.getEnum()) {
      case X: n = p.xn; break;
      case Y: n = p.yn; break;
      case Z: n = p.zn; break;
      }
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*abs(n - pos))); 
    }
  }
}

// Creating a pattern to make grasses seem to bloom
@LXCategory("Form")
public static class BloomPattern extends LXPattern {
  
  public final ColorParameter colInside = new ColorParameter("Inside")
    .setDescription("Color of the inside stalks");
    
  public final ColorParameter colOutside = new ColorParameter("Outside")
    .setDescription("Color of the outside stalks");
    
  public BloomPattern(LX lx) {
    super(lx);
    addParameter("Inside", this.colInside);
    addParameter("Outside", this.colOutside);
  }
  
  public void run(double deltaMs) {    
    for (LXPoint p : model.points) {
      switch (p.index % 7) {
      case 0: colors[p.index] = this.colInside.getColor(); break;
      case 1: colors[p.index] = this.colInside.getColor(); break;
      case 2: colors[p.index] = this.colOutside.getColor(); break;
      case 3: colors[p.index] = this.colOutside.getColor(); break;
      case 4: colors[p.index] = this.colOutside.getColor(); break;
      case 5: colors[p.index] = this.colOutside.getColor(); break;
      case 6: colors[p.index] = this.colOutside.getColor(); break;
      }
    }
  }
}

// Creating a pattern that moves through the pixels on the light
@LXCategory("Form")
public static class SpinPattern extends LXPattern {

  private float pos = 0; // go between 0 and 1
  private static final double MOTION = .0005;
  
  public final CompoundParameter speed = new CompoundParameter("Speed", 0, 1)
    .setDescription("Speed of the rotation");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Width of the pulse");
  
  public SpinPattern(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("width", this.wth);
  }
  
  public void run(double deltaMs) {    
    float falloff = 100 / this.wth.getValuef();
    float speed = this.speed.getValuef();
    int posInt;
    
    pos += speed * deltaMs * MOTION;
    posInt = (int)pos;
    pos = pos - posInt;
    
    float n = 0;
    float dist = 0;
    for (LXPoint p : model.points) {
      n = (p.index % 7) / 7.0;
      dist = LXUtils.wrapdistf(n,pos,1.0);
      // dist = min(min(abs(n - pos), abs(n+1-pos)), abs(n-1-pos));
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*dist)); 
    }
  }
}


// Lighthouse pattern, that sweeps a beam of light around the field
@LXCategory("Form")
public static class LighthousePattern extends LXPattern {

  private float angle = 0; // go between 0 and 1
  private static final double MOTION = .0005;

  public enum Axis {
    Y,Z
  };
  
  public final EnumParameter<Axis> axis =
    new EnumParameter<Axis>("Axis", Axis.Y)
    .setDescription("What axis should the lighthouse beam revolve around");
  
  public final CompoundParameter speed = new CompoundParameter("Speed", 0, 1)
    .setDescription("Speed of the rotation");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Width of the beam");
  
  public LighthousePattern(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("width", this.wth);
    addParameter("axis", this.axis);
  }
  
  public void run(double deltaMs) {    
    float falloff = 100 / this.wth.getValuef();
    float speed = this.speed.getValuef();
    int posInt;
    
    angle += speed * deltaMs * MOTION;
    posInt = (int)angle;
    angle = angle - posInt; // map between 0 and 1
    
    float pAngle = 0;
    float dist = 0;
    for (LXPoint p : model.points) {
      switch (this.axis.getEnum()) 
      {
        case Y:
          pAngle = p.azimuth / (2*PI);
          break;
        case Z:
          pAngle = p.theta / (2*PI); // angle between 0 and 1
          break;
      }
      dist = LXUtils.wrapdistf(pAngle,angle,1.0);
//      dist = min(min(abs(pAngle - angle), abs(pAngle+1-angle)), abs(pAngle-1-angle));
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*dist)); 
    }
  }
}




// Sets brightness based on distance from the center
@LXCategory("Form")
public static class OnePointEachPattern extends LXPattern {

  int index = 0;

  public final CompoundParameter min = new CompoundParameter("Min", 0, 1)
    .setDescription("Minimum value of the brightness");
  
  public final CompoundParameter max = new CompoundParameter("Max", 1.0, 0, 1)
    .setDescription("Maximum value of the brightness");
  
  public OnePointEachPattern(LX lx) {
    super(lx);
    addParameter("min", this.min);
    addParameter("max", this.max);
  }
  
  public void run(double deltaMs) {    
    colors[this.index] = LXColor.rgb(0,0,0); 
    this.index += 1;
    if (this.index >= this.model.points.length) {
      this.index = 0;
    }
    colors[this.index] = LXColor.rgb(103,250,5);
  }
}


// Sets brightness based on distance from the center
@LXCategory("Form")
public static class RadiusPattern extends LXPattern {

    public final CompoundParameter min = new CompoundParameter("Min", 0, 1)
    .setDescription("Minimum value of the brightness");
  
  public final CompoundParameter max = new CompoundParameter("Max", 1.0, 0, 1)
    .setDescription("Maximum value of the brightness");
  
  public RadiusPattern(LX lx) {
    super(lx);
    addParameter("min", this.min);
    addParameter("max", this.max);
  }
  
  public void run(double deltaMs) {    
    float minf = this.min.getValuef();
    float maxf = this.max.getValuef();
    
    float val = 0;
    for (LXPoint p : model.points) {
      val = minf + (maxf-minf)*p.rcn; // set value based on normalized distance from center of the model
      colors[p.index] = LXColor.gray(100.0 * val); 
    }
  }
}

// Lighthouse pattern, that sweeps a beam of light around the field
@LXCategory("Form")
public static class DonutPattern extends LXPattern {
  
  public final CompoundParameter size = new CompoundParameter("Size", 0, 2)
    .setDescription("Size of the donut");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Width of the donut");
  
  public final CompoundParameter dist = new CompoundParameter("Dist", 0, 0, 1)
    .setDescription("Distance of origin from the center");
  
  public final CompoundParameter theta  = new CompoundParameter("Theta", 0, 0, 1)
    .setDescription("Angle of origin");
 
  public DonutPattern(LX lx) {
    super(lx);
    addParameter("Size", this.size);
    addParameter("Width", this.wth);
    addParameter("Dist", this.dist);
    addParameter("Theta", this.theta);
  }
  
  public void run(double deltaMs) {

    float dist = this.dist.getValuef();
    float theta = this.theta.getValuef() * 2 * PI;
    float originX = dist * LXUtils.cosf(theta);
    float originZ = dist * LXUtils.sinf(theta);
    
    float falloff = 100 / this.wth.getValuef();    
    float start = -this.wth.getValuef();
    float range = 1 + (2*this.wth.getValuef());
    float pos = start + (this.size.getValuef() * range);
    
    //float fade = min(1.0, ((1.0 - this.size.getValuef()) * 10.0)); 
    
    float n = 0;
    for (LXPoint p : model.points) {
      n = (float)LXUtils.distance ((p.xn*2.0)-1.0, (p.zn*2.0)-1.0, originX, originZ); // xn gives [0,1] so transform to [-1,1] 
      colors[p.index] = LXColor.gray(max(0, (100 - falloff*abs(n - pos)))); 
    }    
  }
}

@LXCategory("Form")
public static class ChasePattern extends LXPattern {
  
  public enum Mode {
    Solo,Add,Tail
  };
  
  public final EnumParameter<Mode> mode =
    new EnumParameter<Mode>("Mode", Mode.Solo)
    .setDescription("What mode to use for the chase effect");
  
  public final CompoundParameter pos = new CompoundParameter("Pos", 0, 1)
    .setDescription("Position of the chase head");
    
  public ChasePattern(LX lx) {
    super(lx);
    addParameter("mode", this.mode);
    addParameter("pos", this.pos);
  }
  
  public void run(double deltaMs) {
    float pos = this.pos.getValuef();
    int head = int(model.points.length * pos);
    
    for (LXPoint p : model.points) {
      switch (this.mode.getEnum()) {
      case Tail:
        if (p.index == head-1)
          colors[p.index] = LXColor.gray(100);
        else if (p.index == head-2)
          colors[p.index] = LXColor.gray(50);
        else if (p.index == head-3)
          colors[p.index] = LXColor.gray(25);
        else
          colors[p.index] = LXColor.BLACK;
        break;
      case Solo:
        if (p.index == head-1)
          colors[p.index] = LXColor.gray(100);
        else
          colors[p.index] = LXColor.BLACK;
        break;
      case Add:
        if (p.index <= head-1)
          colors[p.index] = LXColor.gray(100);
        else
          colors[p.index] = LXColor.BLACK;
      }
    }
  }
}


@LXCategory("Form")
public static class GrowPattern extends LXPattern {
  
  public enum Mode {
    Build
  };
  
  public final EnumParameter<Mode> mode =
    new EnumParameter<Mode>("Mode", Mode.Build)
    .setDescription("What mode to use for the build effect");
  
  public final CompoundParameter count = new CompoundParameter("Count", 0, 1)
    .setDescription("How many lights per base are on");
    
  public GrowPattern(LX lx) {
    super(lx);
    addParameter("mode", this.mode);
    addParameter("count", this.count);
  }
  
  public void run(double deltaMs) {
    float count = 700*this.count.getValuef();
    float n = 0;
    for (LXPoint p : model.points) {
      n = (p.index % 7) * 100.0;
      colors[p.index] = LXColor.gray(min(100,max(count-n,0)));
    }
  }
}


// LocalPing - meant to be mixed on top of other base patterns. Creates a circular
// pattern of set Brightness, centered around a normalized x,y position. Alpha
// controls what percentage of the circle is visible, so animate Alpha to see 
// the circle radiate outwards.  Also, brightness will fade at tail end of alpha
// to make it a little softer while animating. (ed)
@LXCategory("Form")
public class LocalPing extends LXPattern
{
  public final CompoundParameter posX = new CompoundParameter("PosX", 0, 1)
    .setDescription("X Position of ping center");

  public final CompoundParameter posY = new CompoundParameter("PosY",0,1)
    .setDescription("Y Position of ping center");
    
  public final CompoundParameter size = new CompoundParameter("Size",0,1).setDescription("Max size of ping (1 = full size of model)");
  public final CompoundParameter brightness = new CompoundParameter("Brightness",0,255).setDescription("Max brightness of ping");
  public final CompoundParameter alpha = new CompoundParameter("Alpha",0,1).setDescription("Alpha value to modulate to make the ping animate");
  
  public LocalPing(LX lx)
  {
      super(lx);
      addParameter("PosX",this.posX);
      addParameter("PosY",this.posY);
      addParameter("Size",this.size);
      addParameter("Alpha",this.alpha);
      addParameter("Brightness",this.brightness);
  }
   //<>// //<>//
  public void run(double deltaMs)
  {
    float fPosX = posX.getValuef(); //<>// //<>// //<>//
    float fPosY = posY.getValuef();
    float fAlpha = alpha.getValuef();
    float fAlphaBright = LXUtils.sinf(fAlpha*3.14);
    float fCurRadius = size.getValuef() * fAlpha;
    
    for (LXPoint p : model.points)
    {
      double dist = LXUtils.distance(p.xn,p.zn,fPosX,fPosY);
      if (dist <= fCurRadius)
      {
        colors[p.index] = LXColor.rgb((int)(fAlphaBright * 255),(int)(fAlphaBright * 255), (int)(fAlphaBright*255));
      }
      else
      {
        colors[p.index] = LXColor.gray(0);
      }
    }
  }
  
}

public class SolidPattern extends LXPattern {

  public final CompoundParameter h = new CompoundParameter("Hue", 0, 360);
  public final CompoundParameter s = new CompoundParameter("Sat", 0, 100);
  public final CompoundParameter b = new CompoundParameter("Brt", 100, 100);

  public SolidPattern(LX lx) {
    super(lx);
    addParameter("h", this.h);
    addParameter("s", this.s);
    addParameter("b", this.b);
  }

  public void run(double deltaMs) {
    setColors(LXColor.hsb(this.h.getValue(), this.s.getValue(), this.b.getValue()));
  }
}


//
// SpinEachBlade - a pattern where you can set a rotation time for a brightness "spinning" effect
//   that just runs on the blades.  Center stalk is it's own paramterized brightness. (still needs work)
// 
@LXCategory("Individual Plants")
public static class SpinEachBladePattern extends LXPattern {
    public final CompoundParameter rotTimeSec = new CompoundParameter("Rot Time", 1, 0.1, 5);
    public final CompoundParameter brightnessMax = new CompoundParameter("Max Bright", 100, 0, 100);
    public final CompoundParameter brightnessMin = new CompoundParameter("Min Bright", 0, 0, 100);
    public final CompoundParameter brightnessCenter = new CompoundParameter("Center Bright", 50, 0, 100);
    public final DiscreteParameter spinType = new DiscreteParameter("Spin Type",1, 0,3);

    private double timerMs = 0; // timer for the rotation animation
    private double rotTimeMs = 0; // cached value of sec->ms
    private final static int kNumRingLights = 5; // constant count of lights in base.
    private float[] brightPerLight = new float[kNumRingLights]; // array of brightness values for each light - to be applied to each base (rather than computing it for each base as we iterate)
    
    public SpinEachBladePattern(LX lx) {
        super(lx);
        addParameter("Rot Time",this.rotTimeSec);
        addParameter("Max Bright", this.brightnessMax);
        addParameter("Min Bright", this.brightnessMin);
        addParameter("Center Bright", this.brightnessCenter);
        addParameter("Spin Type", this.spinType);
    }

    void run(double deltaMs)
    {
        // update my timer
        timerMs += deltaMs;

        // convert my desired rotation time to ms
        rotTimeMs = rotTimeSec.getValuef() * 1000.0;
        
        // handle wrapping of timer
        while (timerMs >= rotTimeMs) {
            timerMs-= rotTimeMs;
        }

        // alpha = percentage of rotation (0->1)
        float alpha = (float)(timerMs / rotTimeMs);
        float fBrightMax = brightnessMax.getValuef(); // cache value we're going to use a lot
        float fBrightDelta = fBrightMax - brightnessMin.getValuef(); // cache value we use multiple times
        
        // figure out lighting levels for a single plant, depending on which algorithm is chosen by "spin type"
        for (int i = 0; i < kNumRingLights; i++)
        {
            switch ((int)spinType.getValue())
            {
                case 0:
                    //linear ramp, sharp edge
                    float offsetAlpha = (alpha + (float)i/(float)(kNumRingLights));
                    if (offsetAlpha > 1)
                        offsetAlpha -= 1;
                    brightPerLight[i] = fBrightMax - (offsetAlpha * fBrightDelta);
                    break;
                case 1:
                    // softer, with cos
                    float offsetAngle = (alpha + (float)i/kNumRingLights) * 2 * PI;
                    brightPerLight[i] = max(brightnessMin.getValuef(), fBrightMax * (1 + LXUtils.cosf(offsetAngle)) / 2);
                    break;
                case 2:
                    // only one light on at a time
                    int headDex = (int) (alpha * kNumRingLights);
                    if (i == headDex)
                        brightPerLight[i] = fBrightMax;
                    else
                        brightPerLight[i] = brightnessMin.getValuef();
            }
        }

        // apply the values computed above to all the plants in the layout.
        for (LXPoint p : model.points)
        {
            int lightDex = p.index % (kNumRingLights + 2);
            if (lightDex < 2)
            {
                colors[p.index] = LXColor.gray(brightnessCenter.getValuef());
            }
            else
            {
                colors[p.index] = LXColor.gray((int)brightPerLight[lightDex-2]);
            }
        }
    }
}


//
// MultiDonutRanom classes - also an example of a "triggered" effect using exposed boolean that can be modulated
//
@LXCategory("Form")
public static class MultiDonutRandomPattern extends LXPattern {
  
  public final CompoundParameter size = new CompoundParameter("Size", 0, 2)
    .setDescription("Size of the donut");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Width of the donut");
  
  public final CompoundParameter distMin = new CompoundParameter("DistMin", .5, 0, 1)
    .setDescription("Min distance of origin from the center");

  public final CompoundParameter distMax = new CompoundParameter("DistMax", 1, 0, 1)
    .setDescription("Max distance of origin from the center");
  
  public final CompoundParameter thetaMin  = new CompoundParameter("ThetaMin", 0, 0, 1)
    .setDescription("Angle of origin min");
    
  public final CompoundParameter thetaMax  = new CompoundParameter("ThetaMax", 1, 0, 1)
    .setDescription("Angle of origin max");

  
  
  public final CompoundParameter duration = new CompoundParameter("Duration", 0.1,2.0);
 
  public final BooleanParameter triggerBool = new BooleanParameter("Trigger",false);

  public class RingInfo
  {
    public boolean isOn;
    public float originTheta;
    public float thetaAngle;
    public float originDist;
    public float originX;
    public float originZ;
    
    public float falloff;
    public float start;
    public float range;
    
    public float curAlpha;
  
    private float duration;
    
    public void StartRandomRing(float minTheta,float maxTheta, float minDist, float maxDist, float ringDuration, float width)
    {
      isOn = true;
      originTheta = (float)LXUtils.random(minTheta,maxTheta);
      originDist = (float)LXUtils.random(minDist,maxDist);
      thetaAngle = originTheta * 2 * PI;
      originX = originDist * LXUtils.cosf(thetaAngle);
      originZ = originDist * LXUtils.sinf(thetaAngle);

      falloff = 100 / width;
      start = -width;
      range = 1 + (2*width);
      
      curAlpha = 0;
      duration = ringDuration;
    }
    
    public void UpdateRing(float deltaSec)
    {
      if (isOn)
      {
        curAlpha = min(1.0,(curAlpha + (float)deltaSec/duration));
        if (curAlpha >= 1.0)
        {
          isOn = false;
          curAlpha = 0.0f;    
        }
      }
    } 
  }
  private RingInfo ring = new RingInfo();
  private RingInfo[] rings = new RingInfo[4];
 
  public MultiDonutRandomPattern(LX lx) {
    super(lx);
    addParameter("Size", this.size);
    addParameter("Width", this.wth);
    addParameter("DistRangeMin", this.distMin);
    addParameter("ThetaRangeMin", this.thetaMin);
    addParameter("DistRangeMax", this.distMax);
    addParameter("ThetaRangeMax", this.thetaMax);
    addParameter("Duration",this.duration);
    triggerBool.setMode(BooleanParameter.Mode.TOGGLE);
    addParameter("Trigger",this.triggerBool);
    for (int i = 0; i < 4; i++)
    {
      rings[i] = new RingInfo();
    }
  }
  
  public void triggerNewRing()
  {
    for (int i = 0; i < 4; i++)
    {
      if (!rings[i].isOn)
      {
        rings[i].StartRandomRing(thetaMin.getValuef(),thetaMax.getValuef(),distMin.getValuef(),distMax.getValuef(),duration.getValuef(),wth.getValuef());
        triggerBool.setValue(false);
        return;
      }
    }
  }
  
  
  public void run(double deltaMs) 
  {
    for (int i = 0; i < 4; i++)
    {
      rings[i].UpdateRing((float)deltaMs/1000.0);
    }
    
    if (triggerBool.getValueb())
    {
      triggerNewRing();
    }
    
    float n = 0;
    for (LXPoint p : model.points) 
    {
      colors[p.index] = LXColor.gray(0);
      for (int i = 0; i < 4; i++)
      {
        RingInfo ring = rings[i];
        if (ring.isOn)
        {
          float pos = ring.start + (this.size.getValuef() * ring.range * ring.curAlpha);
          n = (float)LXUtils.distance ((p.xn*2.0)-1.0, (p.zn*2.0)-1.0, ring.originX, ring.originZ); 
          colors[p.index]=LXColor.add(colors[p.index],LXColor.gray(max(0, (100 - ring.falloff*abs(n - pos)))));
        }
      }
    }    
  }
}



//
// Fireball pattern -- sends random fireballs shooting across the field, from random directions, with variable size and falloff
//
@LXCategory("Form")
public static class FireballPattern extends LXPattern {
  
  public final CompoundParameter size = new CompoundParameter("Size", 0.1)
    .setDescription("Size of the fireball");
      
  public final CompoundParameter duration  = new CompoundParameter("Duration", 3, 10)
    .setDescription("Time for fireball to shoot across");

  public final CompoundParameter fuzzy  = new CompoundParameter("Fuzzy", 0)
    .setDescription("How soft the edge of the ball should be");

  public final BooleanParameter triggerBool = new BooleanParameter("Trigger",false)
    .setDescription("Triggers a new fireball to shoot across the field");

  public class ParticleInfo
  {
    public LXVector pos;
    public LXVector vel;
    public float size;      // from 0 to 1 representing size of the head of this fireball
    public float softness;     // how soft the edge should be. 0 = crisp edge; 1 = totally fuzzy
    private LXVector origin;
    
    ParticleInfo(float duration, float size, float fuzzy)
    {
      this.size = size;
      this.softness = fuzzy;

      float theta = (float)LXUtils.random(0,1.0) * 2.0 * PI;    // pick random direction to start
      float radius = 0.5 + (size / 2.0);                       // put origin of ball just outside the model (which has diameter 1)
      pos = new LXVector(0.5 + (radius * LXUtils.cosf(theta)), 0.5, 0.5 + (radius * LXUtils.sinf(theta)));

      float distToTravel = 1.0 + size;                         // ball has to travel from just outside, across the center, to just outside again
      float speed = distToTravel / duration;
      vel = new LXVector(-speed * LXUtils.cosf(theta), 0, -speed * LXUtils.sinf(theta));  // set vel opposite to the initial vector
  
      origin = new LXVector(0.5, 0.5, 0.5);
    }
    
    public void UpdateParticle(float deltaSec)
    {
      pos.x = pos.x + (vel.x * deltaSec);
      pos.z = pos.z + (vel.z * deltaSec);
    } //<>//

    // pass in a point, get back the color contribution from this particle to that point
    public int getColorValue(LXPoint pt)
    {
      LXVector p = new LXVector(pt.xn, pt.yn, pt.zn);   // do all math in normalized space
      float dist = pos.dist(p);

      if (dist > size / 2.0)      // quick out if this point is too far away from this particle //<>//
        return LXColor.BLACK;

      // otherwise the point is inside the range of this particle and will get a color contribution
      else
        return LXColor.gray(100); //<>//
    }

    boolean isDead() {    // check if this particle is out of bounds
      if (pos.dist( origin ) > 0.5 + (size / 2.0))
        return true;
      else
        return false;
    }

  }

  private ArrayList<ParticleInfo> particles = new ArrayList<ParticleInfo> ();
 
  public FireballPattern(LX lx) {
    super(lx);
    addParameter("Size", this.size);
    this.duration.setUnits(LXParameter.Units.SECONDS);
    addParameter("Duration", this.duration);
    addParameter("Fuzzy", this.fuzzy);
    triggerBool.setMode(BooleanParameter.Mode.TOGGLE);
    addParameter("Trigger",this.triggerBool);
  }
  
  public void triggerNewParticle()
  {
    particles.add(new ParticleInfo(duration.getValuef(), size.getValuef(), fuzzy.getValuef()));
    triggerBool.setValue(false);
  }  
  
  public void run(double deltaMs) 
  {
    for (int i = particles.size() - 1; i >= 0; i--)
    {
      ParticleInfo particle = particles.get(i);
      particle.UpdateParticle((float)deltaMs/1000.0);
      if (particle.isDead())
        particles.remove(i);
    }

    if (triggerBool.getValueb())
    {
      triggerNewParticle();
    }
        
    for (LXPoint p : model.points) 
    {
      colors[p.index] = LXColor.gray(0);
      for (ParticleInfo particle : particles)
      {
        int col = particle.getColorValue(p);
        colors[p.index] = LXColor.add(colors[p.index], col);
      }
    }    
  }
}
