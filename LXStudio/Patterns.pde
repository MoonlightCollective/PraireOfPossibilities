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
      case 0: colors[p.index] = this.colOutside.getColor(); break;
      case 1: colors[p.index] = this.colInside.getColor(); break;
      case 2: colors[p.index] = this.colOutside.getColor(); break;
      case 3: colors[p.index] = this.colOutside.getColor(); break;
      case 4: colors[p.index] = this.colOutside.getColor(); break;
      case 5: colors[p.index] = this.colInside.getColor(); break;
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
  
  public final CompoundParameter speed = new CompoundParameter("Speed", 0, 1)
    .setDescription("Speed of the rotation");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Width of the beam");
  
  public LighthousePattern(LX lx) {
    super(lx);
    addParameter("speed", this.speed);
    addParameter("width", this.wth);
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
      pAngle = p.theta / (2*PI); // angle between 0 and 1
      dist = LXUtils.wrapdistf(pAngle,angle,1.0);
//      dist = min(min(abs(pAngle - angle), abs(pAngle+1-angle)), abs(pAngle-1-angle));
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*dist)); 
    }
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
  
  public final CompoundParameter size = new CompoundParameter("Size", 0, 1)
    .setDescription("Size of the donut");
  
  public final CompoundParameter wth = new CompoundParameter("Width", .4, 0, 1)
    .setDescription("Width of the donut");
  
  public DonutPattern(LX lx) {
    super(lx);
    addParameter("Size", this.size);
    addParameter("Width", this.wth);
  }
  
  public void run(double deltaMs) {    
    float falloff = 100 / this.wth.getValuef();    
    float start = -this.wth.getValuef();
    float range = 1 + (2*this.wth.getValuef());
    float pos = start + (this.size.getValuef() * range);
    
    float n = 0;
    for (LXPoint p : model.points) {
      n = p.rcn;
      colors[p.index] = LXColor.gray(max(0, 100 - falloff*abs(n - pos))); 
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
