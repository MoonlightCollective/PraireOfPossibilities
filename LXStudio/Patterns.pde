import java.util.ArrayList;
import java.util.Iterator;
import java.util.Stack;

// In this file you can define your own custom patterns

// Here is a fairly basic example pattern that renders a plane that can be moved
// across one of the axes.
@LXCategory("Form")
public static class PlanePattern extends LXPattern {
  public enum Axis {
    X, Y, Z
  };
  
  public final CompoundParameter pos = new CompoundParameter("Pos", 0, 1)
    .setDescription("Position of the center of the plane");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Thickness of the plane");

  public final CompoundParameter theta = new CompoundParameter("Theta", 0)
    .setDescription("Angle along which the plane moves");
  
  public final CompoundParameter origin = new CompoundParameter("Origin", 0)
    .setDescription("Origin where the planes converge");

  public PlanePattern(LX lx) {
    super(lx);
    addParameter("pos", this.pos);
    addParameter("width", this.wth);
    addParameter("theta", this.theta);
    addParameter("origin", this.origin);
  }
  
  public void run(double deltaMs) {
    float falloff = 100 / this.wth.getValuef();
    float start = -this.wth.getValuef();
    float range = 1 + (2*this.wth.getValuef());
    float pos = start + ((this.pos.getValuef() * (1.0f + this.origin.getValuef())) * range);
    float angle = theta.getValuef() * PI - (PI / 2.0f); // figure out angle of line perpindicular to theta
    float n, x, y, x1, y1;

    for (LXPoint p : model.points) {
      x = p.xn * 2.0 - 1.0f;      // shift to circle centered at origin
      y = p.zn * 2.0 - 1.0f;
      x1 = LXUtils.cosf(angle);
      y1 = LXUtils.sinf(angle);

      n = abs(y1 * x + x1 * y + origin.getValuef()) / sqrt(y1*y1 + x1 * x1);   // get distance from point to the line perindicular to theta going throug origin
      int b = (int) (max (0, (100 - falloff*abs(n - pos))) * 2.559f);
      colors[p.index] = LXColor.rgba(b, b, b, b);
    }
  }
}

// solid color pattern that only affects the edges
@LXCategory("Form")
public static class SolidEdgePattern extends LXPattern {
  
  public final ColorParameter col = new ColorParameter("Color")
    .setDescription("Solid color");
    
  public SolidEdgePattern(LX lx) {
    super(lx);
    addParameter("Color", this.col);
  }
  
  public void run(double deltaMs) {
    int edgeColor = LXColor.hsb( this.col.hue.getValuef(), this.col.saturation.getValuef(), this.col.brightness.getValuef() );
    
    for (LXModel m : model.sub("path")) {
      for (LXPoint p : m.points) {
        colors[p.index] = edgeColor;
      }
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
    int insideColor = LXColor.hsb( this.colInside.hue.getValuef(), this.colInside.saturation.getValuef(), this.colInside.brightness.getValuef() );
    int outsideColor = LXColor.hsb( this.colOutside.hue.getValuef(), this.colOutside.saturation.getValuef(), this.colOutside.brightness.getValuef() );
    
    for (LXPoint p : model.points) {
      switch (p.index % 7) {
      case 0: colors[p.index] = insideColor; break;
      case 1: colors[p.index] = insideColor; break;
      case 2: colors[p.index] = outsideColor; break;
      case 3: colors[p.index] = outsideColor; break;
      case 4: colors[p.index] = outsideColor; break;
      case 5: colors[p.index] = outsideColor; break;
      case 6: colors[p.index] = outsideColor; break;
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
      int b = (int) (max (0, (100 - falloff*dist)) * 2.559f);
      colors[p.index] = LXColor.rgba(b, b, b, b);
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
      int b = (int) (max (0, (100 - falloff*dist)) * 2.559f);
      colors[p.index] = LXColor.rgba(b, b, b, b);
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
      int b = (int) (255 * val);
      colors[p.index] = LXColor.rgba(b, b, b, b);

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
      int b = (int) (max (0, (100 - falloff*abs(n - pos))) * 2.559f);
      colors[p.index] = LXColor.rgba(b, b, b, b);
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
    int b = 0;
    
    for (LXPoint p : model.points) {
      switch (this.mode.getEnum()) {
      case Tail:
        if (p.index == head-1)
          b = 255;
        else if (p.index == head-2)
          b = 128;
        else if (p.index == head-3)
          b = 64;
        else
          b = 0;
        break;
      case Solo:
        if (p.index == head-1)
          b = 255;
        else
          b = 0;
        break;
      case Add:
        if (p.index <= head-1)
          b = 255;
        else
          b = 0;
      }
      colors[p.index] = LXColor.rgba(b, b, b, b);
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
      int b = (int) (min(100,max(count-n,0)) * 2.559f);
      colors[p.index] = LXColor.rgba(b, b, b, b);
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
        colors[p.index] = LXColor.rgba((int)(fAlphaBright * 255), (int)(fAlphaBright * 255),(int)(fAlphaBright * 255), (int)(fAlphaBright*255));
      }
      else
      {
        colors[p.index] = 0;
      }
    }
  }
  
}

public class SolidPattern extends LXPattern {

  public final CompoundParameter h = new CompoundParameter("Hue", 0, 360);
  public final CompoundParameter s = new CompoundParameter("Sat", 0, 100);
  public final CompoundParameter b = new CompoundParameter("Brt", 100, 100);
  public final BooleanParameter mapBtoA = new BooleanParameter("Brt->A").setDescription("Get alpha value from the brightness");
  
  public SolidPattern(LX lx) {
    super(lx);
    addParameter("h", this.h);
    addParameter("s", this.s);
    addParameter("b", this.b);
    addParameter("Brt->A",this.mapBtoA);
  }

  public void run(double deltaMs) {
    if (mapBtoA.getValueb()) {
      float a = (float)this.b.getValue()/100.0;
      setColors(LXColor.hsba(this.h.getValue(), this.s.getValue(), this.b.getValue(),(float)a));
    }
    else {
      setColors(LXColor.hsba(this.h.getValue(), this.s.getValue(), this.b.getValue(), 255));
    }
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
	public final BooleanParameter useRandOffset = new BooleanParameter("RandOffset",false);

    private double timerMs = 0; // timer for the rotation animation
    private double rotTimeMs = 0; // cached value of sec->ms
    private final static int kNumRingLights = 5; // constant count of lights in base.
    private float[] brightPerLight = new float[kNumRingLights]; // array of brightness values for each light - to be applied to each base (rather than computing it for each base as we iterate)
	private float randomOffset = 0.0f;

    public SpinEachBladePattern(LX lx) {
        super(lx);
        addParameter("Rot Time",this.rotTimeSec);
        addParameter("Max Bright", this.brightnessMax);
        addParameter("Min Bright", this.brightnessMin);
        addParameter("Center Bright", this.brightnessCenter);
        addParameter("Spin Type", this.spinType);
		addParameter("useRandOffset",this.useRandOffset);
		ModelUtils.Init(model);
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
                    float dist = LXUtils.wrapdistf((float)i/kNumRingLights,alpha,1.0);
					float b = max(0.0,(1-dist*1.5));
                    brightPerLight[i] = brightnessMin.getValuef() + (b * fBrightDelta);
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
                int b = (int) (brightnessCenter.getValuef() * 2.559f);
                colors[p.index] = LXColor.rgba(b,b,b,b);
            }
            else
            {
				if (!useRandOffset.getValueb())
				{
                	int b = (int) (brightPerLight[lightDex-2] * 2.559f);
	                colors[p.index] = LXColor.rgba(b,b,b,b);
				}
				else
				{
					float a = alpha + ModelUtils.RandomOffsetForPlantDex((int)(p.index/PrairieUtils.kNumLightsPerPlant));
					 if (a > 1)
						a -= 1.0f;
                    float dist = LXUtils.wrapdistf((float)(lightDex-2)/(float)kNumRingLights,a,1.0);
					float b = max(0.0,(1-dist*1.5));
                    float bpl = brightnessMin.getValuef() + (b * fBrightDelta);
					int bInt = (int)(bpl*2.559f);
					colors[p.index] = LXColor.rgba(bInt,bInt,bInt,bInt);
				}
            }
        }
    }
}

// A pattern that lets you flash either the inner or outer lights with triggers inputs. Attack and Decay for each flash can be
// tweaked or modulated with parmaters. Pairs well with TargetColorize effects
@LXCategory("Triggered")
public static class TriggeredFlashesPattern extends LXPattern 
{
	public final CompoundParameter outsideBrightMin = new CompoundParameter("OB Min",50,0,100).setDescription("Min brightness of outer lights (when not triggered)");
	public final CompoundParameter outsideBrightMax = new CompoundParameter("OB Max",100,0,100).setDescription("Max brightness of outer lights (when triggered)");
	public final CompoundParameter outsideAttack = new CompoundParameter("O Atk",0,0,3).setDescription("Attack time of outer light flash");
	public final CompoundParameter outsideDecay = new CompoundParameter("O Dcy",.5,0,3).setDescription("Decay time of outer light flash");

	public final CompoundParameter insideBrightMin = new CompoundParameter("IB Min",50, 0, 100).setDescription("Min brightness of inner lights (not triggered)");
	public final CompoundParameter insideBrightMax = new CompoundParameter("IB Max",100, 0, 100).setDescription("Max brightness of inner lights (triggered)");
	public final CompoundParameter insideAttack = new CompoundParameter("I Atk",0,0,3).setDescription("Attack time of inner light flash (sec)");
	public final CompoundParameter insideDecay = new CompoundParameter("I Dcy",.5,0,3).setDescription("Decay time of inner light flash (sec");

	public final BooleanParameter  triggerInside = new BooleanParameter("I Trg", false).setDescription("Set to TRUE to trigger one flash of inner lights.");
	public final BooleanParameter  triggerOutside = new BooleanParameter("O Trg",false).setDescription("Set to TRUE to trigger one flash of outer lights.");

	private final PrairieEnvAD outerEnv;
	private final PrairieEnvAD innerEnv;

	public TriggeredFlashesPattern(LX lx) {
    	super(lx);
		addParameter("OB Min",outsideBrightMin);
		addParameter("OB Max",outsideBrightMax);
		addParameter("O Atk",outsideAttack);
		addParameter("O Dcy",outsideDecay);
		
		addParameter("IB Min",insideBrightMin);
		addParameter("IB Max",insideBrightMax);
		addParameter("I Atk",insideAttack);
		addParameter("I Dcy",insideDecay);

		addParameter("I Trg", triggerInside);
		addParameter("O Trg",triggerOutside);

		outerEnv = new PrairieEnvAD(outsideAttack.getValuef() * 100,outsideDecay.getValuef() * 1000);
		innerEnv = new PrairieEnvAD(insideAttack.getValuef() * 100,insideDecay.getValuef() * 1000);
	}
  
	public void run(double deltaMs)
	{
		if (triggerInside.getValueb()) {
			innerEnv.AttackTimeMs = insideAttack.getValuef() * 1000;
			innerEnv.DecayTimeMs  = insideDecay.getValuef() * 1000;
			innerEnv.Trigger(true);
			triggerInside.setValue(false);
		}
		if (triggerOutside.getValueb()) {
			outerEnv.AttackTimeMs = outsideAttack.getValuef() * 1000;
			outerEnv.DecayTimeMs  = outsideDecay.getValuef() * 1000;
			outerEnv.Trigger(true);
			triggerOutside.setValue(false);
		}

		innerEnv.Update(deltaMs);
		outerEnv.Update(deltaMs);
		
		int outerB = (int)(outsideBrightMin.getValuef() + (outerEnv.CurVal * (outsideBrightMax.getValuef()-outsideBrightMin.getValuef())) * 2.559f);
		int innerB = (int)(insideBrightMin.getValuef() + (innerEnv.CurVal * (insideBrightMax.getValuef()-insideBrightMin.getValuef())) * 2.559f);
		
		for (LXPoint p : model.points) {
			if (PrairieUtils.IsInner(p.index)) {
				colors[p.index] = LXColor.rgba(innerB, innerB, innerB, innerB);
			}
			else {
				colors[p.index] = LXColor.rgba(outerB, outerB, outerB, outerB);
			}
		}
	}
}
