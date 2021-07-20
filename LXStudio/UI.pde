final static int DUST_FILL = #523D29;

public class UIFloor extends UI3dComponent {

  private final PImage dust;
  private final PImage person;

  public UIFloor() {
    this.dust = loadImage("dust.png");
    this.person = loadImage("person.png");
  }

  @Override
  protected void onDraw(heronarts.p3lx.ui.UI ui, PGraphics pg) {
    pg.tint(DUST_FILL);
    pg.textureMode(NORMAL);
    pg.beginShape();
    pg.texture(dust);
    // x,y,z,u,v
    pg.vertex(-100*FEET, 0, -100*FEET, 0, 0);
    pg.vertex(100*FEET, 0, -100*FEET, 0, 1);
    pg.vertex(100*FEET, 0, 100*FEET, 1, 1);
    pg.vertex(-100*FEET, 0, 100*FEET, 1, 0);
    pg.endShape(CLOSE);
    
    float personY = 0;
    drawPerson(pg, -10*FEET, personY, 10*FEET, 1.5*FEET, 1.5*FEET);
    drawPerson(pg, 8*FEET, personY, 12*FEET, -1.5*FEET, 1.5*FEET);
    drawPerson(pg, 2*FEET, personY, 8*FEET, -2*FEET, 1*FEET);
    
    pg.noStroke();
  }
  
  void drawPerson(PGraphics pg, float personX, float personY, float personZ, float personXW, float personZW) {
    pg.tint(#393939);
    pg.beginShape();
    pg.texture(this.person);
    pg.vertex(personX, personY, personZ, 0, 1);
    pg.vertex(personX + personXW, personY, personZ + personZW, 1, 1);
    pg.vertex(personX + personXW, personY + 5*FEET, personZ + personZW, 1, 0);
    pg.vertex(personX, personY + 5*FEET, personZ, 0, 0);
    pg.endShape(CLOSE);
  }
}

public class UISimulation extends UI3dComponent {

  public static final float CENTER_RADIUS = 10*FEET;

  UISimulation() {
    addChild(new UIFloor());
    int layers = 4;
    float radius = CENTER_RADIUS;
    int bases = 10;
    for (int l = 0; l < layers; ++l) {
        for (int i = 0 ; i < bases; ++i) {
            float angle = i * TWO_PI / bases;
            addChild(new UILightBase(new LightBase(radius * cos(angle), 0, radius * sin(angle))));
        }
        radius += 8*FEET;
        bases *= 2;
    }
  }
  
  protected void beginDraw(UI ui, PGraphics pg) {
    float level = 255;
    pg.pointLight(level, level, level, -10*FEET, 30*FEET, -30*FEET);
    pg.pointLight(level, level, level, 30*FEET, 20*FEET, -20*FEET);
    pg.pointLight(level, level, level, 0, 0, 30*FEET);
  }
  
  protected void endDraw(UI ui, PGraphics pg) {
    pg.noLights();
  }
}

public class UILightStem extends UI3dComponent {
    public final LightStem model;

    UILightStem(LightStem model) {
        this.model = model;
    }
}

public class UILightStemTrio extends UILightStem {
  public static final float DIAMETER = 0.125*INCHES;
  public static final float HEIGHT = 60*INCHES;
  public static final int  DETAIL = 8;

  public final UICylinder[][] lightStems = new UICylinder[3][6];

  UILightStemTrio(LightStem model) {
    super(model);
    float  r = DIAMETER/2;
    float  h = HEIGHT;
    // 3 stems
    for (int i = 0; i < 3; ++i) {
        // the stem has 6 joints
        for (int j = 0; j < 6; j++) {
            this.lightStems[i][j] = new UICylinder(r, h/6.0, DETAIL);
        }
        h -= 5*INCHES;
    }
  }

  @Override
  protected void beginDraw(UI ui, PGraphics pg) {
    pg.pushMatrix();
    pg.translate(this.model.x, this.model.y, this.model.z);
  }

  @Override
  protected void onDraw(heronarts.p3lx.ui.UI ui, PGraphics pg) {
    pg.noStroke();

    pg.rotateY(this.model.azimuth);

    float bendAngle = 6;
    // 3 stems
    for (int i = 0; i < 3; ++i) {
        pg.pushMatrix();
        // 6 joints
        float angle = -PI/bendAngle;
        float k = 1.0;
        for (int j = 0; j < 6; j++) {
            pg.fill(this.model.rgb);
            this.lightStems[i][j].onDraw(ui, pg);
            pg.translate(0.125*INCHES, this.lightStems[i][j].len, 0);
            angle *= k;
            k -= 1.0/6.0;
            pg.rotateX(angle);
        }
        pg.popMatrix();

        bendAngle += 1;

        if (i == 0) {
            pg.rotateY(PI/6);
        }
        if (i == 1) {
            pg.rotateY(-2*PI/6);
        }
    }
  }

  @Override
  protected void endDraw(UI ui, PGraphics pg) {
    pg.popMatrix();
  }

}

public class UILightStemSingle extends UILightStem {
  public static final float DIAMETER = 0.25*INCHES;
  public static final float HEIGHT = 49*INCHES;
  public static final int  DETAIL = 8;

  UILightStemSingle(LightStem model) {
    super(model);
    addChild(new UICylinder(DIAMETER/2, HEIGHT, DETAIL));
  }

  @Override
  protected void beginDraw(UI ui, PGraphics pg) {
    pg.pushMatrix();
    pg.translate(this.model.x, this.model.y, this.model.z);
  }

  @Override
  protected void onDraw(heronarts.p3lx.ui.UI ui, PGraphics pg) {
    pg.fill(this.model.rgb);
    pg.noStroke();
  }

  @Override
  protected void endDraw(UI ui, PGraphics pg) {
    pg.popMatrix();
  }
}



/*
 *         0     1
 *            3
 *       2
 *             4
 *          5     6
 */      

public class UILightBase extends UI3dComponent {
  public static final float DIAMETER = 10.5*INCHES;
  public static final float HEIGHT = 3.5*INCHES;
 
  public final List<UILightStem> lightStems;
  public final LightBase model;

  UILightBase(LightBase model) {
      this.model = model;
      addChild(new UICylinder(DIAMETER/2, HEIGHT, 5));
      lightStems = new ArrayList<UILightStem>();
      lightStems.add(new UILightStemSingle(new LightStem(1,    3,  1, 0.0,     #154FF0)));      // 3
      lightStems.add(new UILightStemSingle(new LightStem(1,    3, -1, 0.0,     #E8F015)));      // 4
      lightStems.add(new UILightStemTrio(  new LightStem(3,    3,  2, -3*PI/4, #29FD10)));      // 1
      lightStems.add(new UILightStemTrio(  new LightStem(2.5,  3, -3, -PI/4,   #10FDE8)));      // 6
      lightStems.add(new UILightStemTrio(  new LightStem(-2.5, 3,  2, -5*PI/4, #F8FD10)));      // 0
      lightStems.add(new UILightStemTrio(  new LightStem(-2.5, 3, -3, -7*PI/4, #1040FD)));      // 5
      lightStems.add(new UILightStemTrio(  new LightStem(-3.5, 3,  0, -3*PI/2, #A010FD)));      // 2
      for (UILightStem stem : lightStems) {
          addChild(stem);
      }      
  }

  @Override
  protected void beginDraw(UI ui, PGraphics pg) {
    pg.pushMatrix();
    pg.translate(this.model.x, this.model.y, this.model.z);
  }

  @Override
  protected void onDraw(heronarts.p3lx.ui.UI ui, PGraphics pg) {
    pg.fill(#F01529);
    pg.noStroke();
  }

  @Override
  protected void endDraw(UI ui, PGraphics pg) {
    pg.popMatrix();
  }

}

/**
 * Utility class for drawing cylinders. Assumes the cylinder is oriented with the
 * y-axis vertical. Use transforms to position accordingly.
 */
public static class UICylinder extends UI3dComponent {
  
  private final PVector[] base;
  private final PVector[] top;
  private final int detail;
  public final float len;
  
  public UICylinder(float radius, float len, int detail) {
    this(radius, radius, 0, len, detail);
  }
  
  public UICylinder(float baseRadius, float topRadius, float len, int detail) {
    this(baseRadius, topRadius, 0, len, detail);
  }
  
  public UICylinder(float baseRadius, float topRadius, float yMin, float yMax, int detail) {
    this.base = new PVector[detail];
    this.top = new PVector[detail];
    this.detail = detail;
    this.len = yMax - yMin;
    for (int i = 0; i < detail; ++i) {
      float angle = i * TWO_PI / detail;
      this.base[i] = new PVector(baseRadius * cos(angle), yMin, baseRadius * sin(angle));
      this.top[i] = new PVector(topRadius * cos(angle), yMax, topRadius * sin(angle));
    }
  }
  
  public void onDraw(UI ui, PGraphics pg) {
    pg.beginShape(TRIANGLE_STRIP);
    for (int i = 0; i <= this.detail; ++i) {
      int ii = i % this.detail;
      pg.vertex(this.base[ii].x, this.base[ii].y, this.base[ii].z);
      pg.vertex(this.top[ii].x, this.top[ii].y, this.top[ii].z);
    }
    pg.endShape(CLOSE);
  }
}