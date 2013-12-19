import java.awt.Color;

public enum TerrainType {
  OCEAN(0f, Color.BLUE.getRGB()), 
  BEACH(0.1f, Color.YELLOW.getRGB()), 
  LAND(0.7f, Color.GREEN.getRGB()),
  CITY(0.7f, Color.GRAY.getRGB());
  
  public final float height; // Represents upper bound height
  public final int typeColor;
  
  private TerrainType(float height, int typeColor) {
    this.height = height;
    this.typeColor = typeColor;
  }
  
  public static TerrainType getType(float height) {
    for(TerrainType t : TerrainType.values()) {
      System.out.println("" + t + height);
      if(height < t.height) return t;
    }
    return TerrainType.OCEAN;
  }
}
