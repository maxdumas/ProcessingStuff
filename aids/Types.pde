public class Type{
  public static final Type OCEAN = new Type(color(71, 130, 180));
  public static final Type INFECTED_OCEAN = new Type(color(60, 140, 170));
  public static final Type VACCINATED_OCEAN = new Type(color(80, 110, 190));
  public static final Type UNINFECTED = new Type(color(0));
  public static final Type UNDIAGNOSED = new Type(color(0, 255, 0));
  public static final Type DIAGNOSED = new Type(color(255, 0, 0));
  public static final Type VACCINATED = new Type(color(255, 0, 255));
  public static final Type DEAD = new Type(color(128));
  
  color value;
  
  Types(color c) { value = c; }
  
  color getValue() { return value; }
}
