package  
{
	// helper function that returns a uniform random number
  public function random(average:Number, variation:Number):Number
  {
    return average + 2.0 * (Math.random() - 0.5) * variation;
  }
}
