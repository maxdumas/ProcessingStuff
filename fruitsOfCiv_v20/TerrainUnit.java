public class TerrainUnit {
  public TerrainType type;
  public final float height;
  
  public TerrainUnit(float height) {
    this.height = height;
    this.type = TerrainType.getType(height);
  }
}
