package 
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;
	
  [SWF(width=800, height=600, frameRate=60, backgroundColor=0x203040)]
  
	public class Main extends Sprite 
	{
    // particle display container
    private var container:DisplayObjectContainer;
    
    // particle emitter
    private var emitter:PointEmitter;
    
    // emitter path
    private var emitterRadius:Number = 200.0;
    private var emitterTheta:Number = 0.0;
    
    // emitter speed
    private var emitterSpeed:Number = EMITTER_SPEED_SLOW;
    private static const EMITTER_SPEED_SLOW:Number = 200.0;
    private static const EMITTER_SPEED_FAST:Number = 2000.0;
    private static const EMITTER_SPEED_SUPER_FAST:Number = 10000.0;
    
    // configuration
    private var config:uint;
    private static const COMMON_IMPLEMENTATION_SLOW        :uint = 0;
    private static const SUB_FRAME_INTERPOLATION_SLOW      :uint = 1;
    private static const COMMON_IMPLEMENTATION_FAST        :uint = 2;
    private static const SUB_FRAME_INTERPOLATION_FAST      :uint = 3;
    private static const COMMON_IMPLEMENTATION_SUPER_FAST  :uint = 4;
    private static const SUB_FRAME_INTERPOLATION_SUPER_FAST:uint = 5;
    
    // text field
    private var textField:TextField;
    private var textFormat:TextFormat;
    
		public function Main()
		{
      // create container
      container = createContainer();
      addChild(container);
      
      // create emitter
      emitter = new PointEmitter(container, Square);
      
      // set initial configuration
      setConfig(COMMON_IMPLEMENTATION_SLOW);
      
      // begin main update loop
      stage.addEventListener(Event.ENTER_FRAME, update);
      
      // listen for mouse click
      stage.addEventListener(MouseEvent.CLICK, changeConfig);
		}
    
    // main update loop
    public function update(e:Event):void
    {
      var dt:Number = 1.0 / stage.frameRate;
      
      // re-center container
      container.x = 0.5 * stage.stageWidth;
      container.y = 0.5 * stage.stageHeight;
      
      // move emitter
      emitterTheta += emitterSpeed * dt / emitterRadius;
      emitter.position.x = emitterRadius * Math.cos(emitterTheta);
      emitter.position.y = emitterRadius * Math.sin(emitterTheta);
      
      // update emitter
      emitter.update(dt);
    }
    
    private function changeConfig(e:MouseEvent):void 
    {
      switch (config)
      {
        case COMMON_IMPLEMENTATION_SLOW:
          setConfig(SUB_FRAME_INTERPOLATION_SLOW);
          break;
        case SUB_FRAME_INTERPOLATION_SLOW:
          setConfig(COMMON_IMPLEMENTATION_FAST);
          break;
        case COMMON_IMPLEMENTATION_FAST:
          setConfig(SUB_FRAME_INTERPOLATION_FAST);
          break;
        case SUB_FRAME_INTERPOLATION_FAST:
          setConfig(COMMON_IMPLEMENTATION_SUPER_FAST);
          break;
        case COMMON_IMPLEMENTATION_SUPER_FAST:
          setConfig(SUB_FRAME_INTERPOLATION_SUPER_FAST);
          break;
        case SUB_FRAME_INTERPOLATION_SUPER_FAST:
          setConfig(COMMON_IMPLEMENTATION_SLOW);
          break;
      }
    }
    
    private function createContainer():DisplayObjectContainer
    {
      var container:Sprite = new Sprite();
      container.x = 0.5 * stage.stageWidth;
      container.y = 0.5 * stage.stageHeight;
      
      // create text
      textField = new TextField();
      textField.selectable = false;
      textField.autoSize = TextFieldAutoSize.LEFT;
      textFormat = new TextFormat();
      textFormat.font = "Arial";
      textFormat.color = 0xFFFFFF;
      textFormat.size = 14.0;
      textFormat.align = TextFormatAlign.CENTER;
      textField.setTextFormat(textFormat);
      container.addChild(textField);
      
      // draw emitter path
      container.graphics.lineStyle(0, 0x808080);
      container.graphics.drawCircle(0.0, 0.0, emitterRadius);
      
      return container;
    }
    
    private function setConfig(config:uint):void
    {
      this.config = config;
      switch (config)
      {
        case COMMON_IMPLEMENTATION_SLOW:
          emitter.useSubFrameInterpolation = false;
          emitterSpeed = EMITTER_SPEED_SLOW;
          textField.text = "- Common Implementation / Slow -\nClick to change configuration.";
          break;
        case SUB_FRAME_INTERPOLATION_SLOW:
          emitter.useSubFrameInterpolation = true;
          emitterSpeed = EMITTER_SPEED_SLOW;
          textField.text = "- Sub-Frame Interpolation / Slow -\nClick to change configuration.";
          break;
        case COMMON_IMPLEMENTATION_FAST:
          emitter.useSubFrameInterpolation = false;
          emitterSpeed = EMITTER_SPEED_FAST;
          textField.text = "- Common Implementation / Fast -\nClick to change configuration.";
          break;
        case SUB_FRAME_INTERPOLATION_FAST:
          emitter.useSubFrameInterpolation = true;
          emitterSpeed = EMITTER_SPEED_FAST;
          textField.text = "- Sub-Frame Interpolation / Fast -\nClick to change configuration.";
          break;
        case COMMON_IMPLEMENTATION_SUPER_FAST:
          emitter.useSubFrameInterpolation = false;
          emitterSpeed = EMITTER_SPEED_SUPER_FAST;
          textField.text = "- Common Implementation / Super Fast -\nClick to change configuration.";
          break;
        case SUB_FRAME_INTERPOLATION_SUPER_FAST:
          emitter.useSubFrameInterpolation = true;
          emitterSpeed = EMITTER_SPEED_SUPER_FAST;
          textField.text = "- Sub-Frame Interpolation / Super Fast -\nClick to change configuration.";
          break;
      }
      textField.setTextFormat(textFormat);
      textField.x = -0.5 * textField.textWidth;
      textField.y = -0.5 * textField.textHeight;
    }
	}
}
