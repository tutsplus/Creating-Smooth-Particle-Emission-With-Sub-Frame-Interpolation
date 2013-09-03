package  
{
	// helper function for linear interpolation
  public function lerp(a:Number, b:Number, t:Number):Number
  {
    return a + (b - a) * t;
  }
}
