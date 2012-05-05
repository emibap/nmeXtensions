package haxemap;
import nme.display.Sprite;
import haxemap.core.Canvas;
import haxemap.core.LngLat;
import haxemap.core.TileLayer;
import haxemap.core.MapService;
import haxemap.ui.Button;
import haxemap.ui.ToolBar;
import haxemap.ui.StatusBar;
import nme.events.Event;

/**
 * ...
 * @author Tony Polinelli
 */

class Map extends Sprite
{
	public var canvas:Canvas;
    public var toolbar:Sprite;
    public var layer:InteractiveLayer;

	public function new()  
	{
		super();
	}
	
	public function init()
	{
		//toolbar = new ToolBar();
		toolbar = new Sprite();
        canvas = new Canvas();
        layer = new InteractiveLayer();
		
        toolbar.x = toolbar.y = 20;
        canvas.move(0, 0);
        //canvas.setCenter(new LngLat(16.685218,49.482312));
        canvas.setCenter(new LngLat(144.9630, -37.8139));
		
		canvas.addLayer(new TileLayer(new OpenStreetMapService(14), 8));
        canvas.addLayer(layer);

        stageResized(null);
        initToolbar();
		
        addChild(canvas);
        addChild(toolbar);
		
        canvas.initialize();
		
		// test - click to add Points
        //canvas.addEventListener(MapEvent.MAP_CLICKED, function(e:MapEvent) { layer.addPoint(e.point.lng,e.point.lat); });
        canvas.addEventListener(MapEvent.MAP_MOUSEMOVE, mouseMove);
		
		layer.update();
	}
	
	public function stageResized(e:Event)
    {
		//toolbar.setSize(640, 30);
		canvas.setSize(640, 960);
		
        //toolbar.setSize(flash.Lib.current.stage.stageWidth, 30);
        //canvas.setSize(flash.Lib.current.stage.stageWidth, flash.Lib.current.stage.stageHeight);
    }

    function mouseMove(e:haxemap.core.MapEvent)
    {
       //toolbar.setText("longitude:" + LngLat.fmtCoordinate(e.point.lng) + 
                       //" latitude:" + LngLat.fmtCoordinate(e.point.lat));
		trace("toolbar.width: " + toolbar.width);
		trace("toolbar.scaleX: " + toolbar.scaleX);

    }

    function initToolbar()
    {
    
		var b1 = new ZoomOutButton();
		b1.width = b1.height = 60;
		b1.x = 5;
		b1.y = 3;
		b1.addEventListener(flash.events.MouseEvent.CLICK, function(e) { canvas.zoomOut(); } );
		toolbar.addChild(b1);
		
		var b2 = new ZoomInButton();
		b2.width = b2.height = 60;
		b2.x = 100;
		b2.y = 3;
		b2.addEventListener(flash.events.MouseEvent.CLICK, function(e) { canvas.zoomIn(); } );
		toolbar.addChild(b2);

       	toolbar.graphics.beginFill(0x000000, .5);
    	toolbar.graphics.drawRoundRect(0, 0, toolbar.width + 50, toolbar.height + 40, 12, 12);
		toolbar.graphics.endFill();
    }

}


class CircleButton extends flash.display.Sprite 
{
	public function new()
	{
		super();
		
		this.graphics.beginFill(Std.int(Math.random() * 255), 1);
		this.graphics.drawCircle(0, 0, 30);
	}
}

import haxemap.core.Layer;
import flash.geom.Point;
import flash.events.MouseEvent;

class InteractiveLayer extends Layer
{
    var points:Array<LngLat>;
   
    public function new()
    { 
        super();
 
        points = [];

   }
  
   public function addPoint(lng:Float, lat:Float, forceUpdate:Bool=true )
   {
       points.push(new LngLat(lng, lat));
	   
	   updateContent(forceUpdate);
   }

   override function updateContent(forceUpdate:Bool=true)
   {
        if (!forceUpdate) 
			return;
		if (points.length == 0)
			return;
			
        graphics.clear();
        
        var a:Point = getOriginXY();
        var b:Point = null;
		
        //draw path
        graphics.lineStyle(3,0xff0000, 0.8);
        
        for (i in 0...points.length) 
        {
            if (b == null) 
            { 
			   // first point
			   b = mapservice.lonlat2XY(points[i].lng, points[i].lat, mapservice.zoom_def + zoom);
               b = b.subtract(a);
			   
			   // dot
			   graphics.lineStyle(3,0xff0000, 0);
			   graphics.beginFill(0xff0000, 0.8);
			   graphics.drawCircle(b.x, b.y, 5);
			   graphics.endFill();
			   
			   
			   // move
               graphics.moveTo(b.x, b.y);
            } 
            else
            {
			   // next points
               b = mapservice.lonlat2XY(points[i].lng, points[i].lat, mapservice.zoom_def + zoom);
               b = b.subtract(a);
               
			   //line
			   graphics.lineStyle(3, 0xff0000, 1);
			   graphics.lineTo(b.x, b.y);
			   
			   //end dot
			   if (i == points.length -1)
			   {
				   graphics.lineStyle(3,0xff0000, 0);
				   graphics.beginFill(0x0000ff, 1);
				   graphics.drawCircle(b.x, b.y, 5);
				   graphics.endFill();
			   }
            }
        }

        if (zoom < -2) return;
   }

}
