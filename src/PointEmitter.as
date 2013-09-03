package
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.geom.Point;
  
  public class PointEmitter
  {
    // sub-frame interpolation flag
    public var useSubFrameInterpolation:Boolean = false;
    
    // particles per second
    public var emissionRate:Number = 500.0;
    
    // position of emitter
    public var position:Point = new Point(0.0, 0.0);
    
    // previous position of emitter
    private var prevPosition:Point;
    
    // particle life & variation in seconds
    public var particleLife:Number = 0.3;
    public var particleLifeVar:Number = 0.2;
    
    // particle scale & variation
    public var particleScale:Number = 1.0;
    public var particleScaleVar:Number = 0.5;
    
    // particle grow & shrink time in lifetime percentage (0.0 to 1.0)
    public var particleGrowRatio:Number = 0.05;
    public var particleShrinkRatio:Number = 0.4;
    
    // particle speed & variation
    public var particleSpeed:Number = 30.0;
    public var particleSpeedVar:Number = 30.0;
    
    // particle angular velocity variation in degrees per second
    public var particleOmegaVar:Number = 50.0;
    
    // the container new particles are added to
    private var container:DisplayObjectContainer;
    
    // the class object for instantiating new particles
    private var displayClass:Class;
    
    // vector that contains particle objects
    private var particles:Vector.<Particle>;
    
    // constructor
    public function PointEmitter
    (
      container:DisplayObjectContainer, 
      displayClass:Class
    )
    {
      this.container = container;
      this.displayClass = displayClass;
      this.particles = new Vector.<Particle>();
    }
    
    // creates a new particle
    private function createParticles(numParticles:uint, dt:Number):void
    {
      for (var i:uint = 0; i < numParticles; ++i)
      {
        var p:Particle = new Particle(new displayClass());
        container.addChild(p.display);
        particles.push(p);
        
        // initialize rotation & scale
        p.rotation = random(0.0, 180.0);
        p.initScale = p.scale = random(particleScale, particleScaleVar);
        
        // initialize life & grow & shrink time
        p.initLife = random(particleLife, particleLifeVar);
        p.growTime = particleGrowRatio * p.initLife;
        p.shrinkTime = particleShrinkRatio * p.initLife;
        
        // initialize linear & angular velocity
        var velocityDirectionAngle:Number = random(0.0, Math.PI);
        var speed:Number = random(particleSpeed, particleSpeedVar);
        p.vx = speed * Math.cos(velocityDirectionAngle);
        p.vy = speed * Math.sin(velocityDirectionAngle);
        p.omega = random(0.0, particleOmegaVar);
        
        // initialize position & current life
        if (useSubFrameInterpolation)
        {
          // sub-frame interpolation
          var t:Number = Number(i) / Number(numParticles);
          var timeElapsed:Number = (1.0 - t) * dt;
          p.x = lerp(prevPosition.x, position.x, t);
          p.y = lerp(prevPosition.y, position.y, t);
          p.x += p.vx * timeElapsed;
          p.y += p.vy * timeElapsed;
          p.life = p.initLife - timeElapsed;
        }
        else
        {
          // regular initialization
          p.x = position.x;
          p.y = position.y;
          p.life = p.initLife;
        }
      }
    }
    
    // removes dead particles
    private function removeDeadParticles():void
    {
      // It's easy to loop backwards with splicing going on.
      // Splicing is not efficient, 
      // but I use it here for simplicity's sake.
      var i:int = particles.length;
      while (--i >= 0)
      {
        var p:Particle = particles[i];
        
        // check if particle's dead
        if (p.life < 0.0)
        {
          // remove from container
          container.removeChild(p.display);
          
          // splice it out
          particles.splice(i, 1);
        }
      }
    }
    
    // main update loop
    public function update(dt:Number):void
    {
      // first-time initialization
      if (!prevPosition)
        prevPosition = position.clone();
      
      // calculate number of new particles per frame
      var newParticlesPerFrame:Number = emissionRate * dt;
      
      // extract integer part
      var numNewParticles:uint = uint(newParticlesPerFrame);
      
      // possibly add one based on fraction part
      if (Math.random() < newParticlesPerFrame - numNewParticles)
        ++numNewParticles;
      
      // first, create new particles
      createParticles(numNewParticles, dt);
      
      // next, update particles
      for each (var p:Particle in particles)
        p.update(dt);
      
      // finally, remove all dead particles
      removeDeadParticles();
      
      // record previous position
      prevPosition = position.clone();
    }
  }
}
