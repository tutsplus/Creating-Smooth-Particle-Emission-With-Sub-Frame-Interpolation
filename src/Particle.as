package  
{
  import flash.display.DisplayObject;
	
  public class Particle 
  {
    // display object represented by this particle
    public var display:DisplayObject;
    
    // current & initial life in seconds
    public var initLife:Number;
    public var life:Number;
    
    // grow time in seconds
    public var growTime:Number;
    
    // shrink time in seconds
    public var shrinkTime:Number;
    
    // position
    public var x:Number;
    public var y:Number;
    
    // linear velocity
    public var vx:Number;
    public var vy:Number;
    
    // orientation angle in degrees
    public var rotation:Number;
    
    // angular velocity
    public var omega:Number;
    
    // initial & current scale
    public var initScale:Number;
    public var scale:Number;
    
    // constructor
    public function Particle(display:DisplayObject)
    {
      this.display = display;
    }
    
    // main update loop
    public function update(dt:Number):void
    {
      // integrate position
      x += vx * dt;
      y += vy * dt;
      
      // integrate orientation
      rotation += omega * dt;
      
      // decrement life
      life -= dt;
      
      // calculate scale
      if (life > initLife - growTime)
        scale = lerp(0.0, initScale, (initLife - life) / growTime);
      else if (life < shrinkTime)
        scale = lerp(initScale, 0.0, (shrinkTime - life) / shrinkTime);
      else
        scale = initScale;
      
      // dump particle data into display object
      display.x = x;
      display.y = y;
      display.rotation = rotation;
      display.scaleX = display.scaleY = scale;
    }
  }
}
