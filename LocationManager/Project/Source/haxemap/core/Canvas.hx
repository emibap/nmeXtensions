/*******************************************************************************
Copyright (c) 2010, Zdenek Vasicek (vasicek AT fit.vutbr.cz)
                    Marek Vavrusa  (marek AT vavrusa.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the organization nor the names of its
      contributors may be used to endorse or promote products derived from this
      software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE. 
*******************************************************************************/

package haxemap.core;

import haxemap.ui.Component;

import haxemap.core.MapService;
import haxemap.core.LngLat;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.display.Shape;
import flash.display.BitmapData;

typedef ALayer = {
   var layer : Layer;
   var enabled : Bool;
}

class MapEvent extends flash.events.Event 
{  
    public static var MAP_CLICKED:String = "mapclicked";
    public static var MAP_MOUSEMOVE:String = "mapmousemove";
    public static var MAP_MOVE:String = "mapmove";
    public static var MAP_ZOOMCHANGED:String = "mapzoom";
    public static var MAP_CHANGED:String = "mapchanged";

    public var point:LngLat;  
           
    public function new(event:String, point:LngLat = null) {  
         super(event);  
         this.point = point;     
    }  
}     


class Canvas extends Component 
{
    var layers:Array<ALayer>; 
    var start:Point;
    var initialized:Bool;
    var zoom:Int;
    var animTimer : Timer;
    var animTo:LngLat;
    var center:LngLat;
    var thpassed:Bool;
    var thtimer:Timer;
    var mappoint:LngLat;
    public var mousethreshold:Int;  //the minimal number of pixels that have to be passed in order to start moving
    public var transparent(default, setTransparent):Bool;

    public function new(interactive:Bool = true)
    {
        super();

        this.initialized = false;
        this.start = null;
        this.zoom = 0;
        this.mousethreshold = 5;
        this.thpassed = false;
        this.thtimer = null;
        this.animTimer = new Timer(50, 0);
        this.center = new LngLat(16.722079,49.577496);
        this.layers = new Array<ALayer>();
        this.doubleClickEnabled = true;
        this.transparent = false;

		/*#if flash
        contextMenu = new flash.ui.ContextMenu();
        contextMenu.hideBuiltInItems();
        var itm = new flash.ui.ContextMenuItem("HaxeMaps");
        itm.addEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, 
                             function(e) { flash.Lib.getURL(new flash.net.URLRequest("http://code.google.com/p/haxemaps/")); });
        contextMenu.customItems.push(itm);
        var itm = new flash.ui.ContextMenuItem("  (C) 2010");
        itm.enabled = false;
        contextMenu.customItems.push(itm);

        if (interactive) 
        {
           addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
           addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
           addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);

           var me = this;
           var itm = new flash.ui.ContextMenuItem("HaxeMaps - zoom in");
           itm.separatorBefore = true;
           itm.addEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, 
                                function(e) { me.zoomIn(); });
           contextMenu.customItems.push(itm);
           var itm = new flash.ui.ContextMenuItem("HaxeMaps - Zoom out");
           itm.addEventListener(flash.events.ContextMenuEvent.MENU_ITEM_SELECT, 
                                function(e) { me.zoomOut(); });
           contextMenu.customItems.push(itm);

        }
		#else */
		if (interactive) 
        {
           addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
           addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
           addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
        }
		//#end
    }
    /*============================================================================================== 
      LAYER MANAGEMENT
     *==============================================================================================*/
    public function initialize()
    {
        if (initialized)
           return;
		
        var m:MapService = null;
		
        //find the first defined service
        for (l in layers)
            if (l.layer.mapservice != null)
            {
               m = l.layer.mapservice;                
               break;
            }

	//Check if there is a layer containing mapservice
        if (m == null)  
           return;

        //initialize the layers
        for (l in layers)
        {
           if (l.layer.mapservice == null)
              l.layer.mapservice = m;

           if (l.enabled) 
           {
              initializeLayer(l);
              addChild(l.layer);
           }
        }

        initialized = true;
        dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
    }

    public function addLayer(layer:Layer, enable:Bool=true)
    { 
        for (l in layers)
            if (l.layer == layer)
               return;

        var alayer:ALayer = {layer:layer, enabled:false};
        layers.push(alayer);
        layer.addEventListener(Layer.ZOOM_FINISHED, zoomFinished);

        if ((initialized) && (enable)) //synchronize
        {
           initializeLayer(alayer);
           dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
        }

        alayer.enabled = enable;
    }

    public function removeLayer(layer:Layer)
    { 
        for (l in layers)
        {
            if (l.layer == layer)
            {
               removeChild(layer);
               layer.removeEventListener(Layer.ZOOM_FINISHED, zoomFinished);
               layer.clear();
               layers.remove(l);
               return;
            }
        }
    }

    public function enableLayer(layer:Layer)
    { 
        var childidx = 0;
        for (i in 0...layers.length)
        {
            
            var l:ALayer = layers[i];
            if (l.layer == layer)
            {
               if (l.enabled)
                  break;              
               
               l.enabled = true;

               if (initialized)
               {
		  initializeLayer(l, false);
                  dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
               }

               if (i == layers.length - 1)
                  addChild(l.layer);
               else 
                  addChildAt(l.layer, childidx);              
               return;
            }

            if (l.enabled)
               childidx++;
        }
    }

    public function disableLayer(layer:Layer)
    { 
        for (l in layers)
            if (l.layer == layer)
            {
               if (!l.enabled)
                  break;              

               removeChild(l.layer);
               l.layer.clear();
               l.enabled = false;

               return;
            }
    }

    public function updateLayer(layer:Layer)
    {
        for (l in layers)
            if (l.layer == layer)
            {
               if (l.enabled)
                  l.layer.update();
               return;
            }
 
    }

    public function layerEnabled(layer:Layer)
    {
        for (l in layers)
            if (l.layer == layer)
               return l.enabled;

        return false;
    }

    function initializeLayer(alayer:ALayer, canAdd:Bool = true)
    {
		if (alayer.layer.canvas == null)
        {
			alayer.layer.canvas = this;
		}
		
		if (alayer.layer.mapservice == null)
        {
           for (l in layers)
               if (l.layer.mapservice != null)
               { 
                  alayer.layer.mapservice = l.layer.mapservice;
                  break;
               }
        }       
     
        if (alayer.layer.mapservice == null)
           return;
 
        var sz = getSize();
	var center:LngLat = this.center;

	if (initialized) 
	{
           //synchronize position
           for (l in layers)
               if ((l != alayer) && (l.enabled) && (l.layer.mapservice != null))
               {
                  center = l.layer.getCenter();
                  //trace("Init new center:"+center);
                  break;
               }
        }

        alayer.layer.finalize();
        alayer.layer.setCenter(center);
        alayer.layer.setBBox(new Rectangle(0,0,sz.width,sz.height));
        alayer.layer.setZoom(this.zoom);
        alayer.layer.initialize();

        if ((!alayer.enabled) && (canAdd))
           addChild(alayer.layer);
    }

    /*============================================================================================== 
      POSITION / ZOOM
     *==============================================================================================*/
    public function zoomIn()
    { 
        for (l in layers)
            if ((l.enabled) && (!l.layer.validZoom(this.zoom + 1)))
               return;
               
        this.zoom += 1; 
        for (l in layers)
            if (l.enabled)
               l.layer.zoomIn();
    }

    public function zoomOut()
    {
        for (l in layers)
            if ((l.enabled) && (!l.layer.validZoom(this.zoom - 1)))
               return;

        this.zoom -= 1;
        for (l in layers)
            if (l.enabled)
               l.layer.zoomOut();
    }

    public function getZoom() : Int
    {
        return this.zoom;
    }

    public function getMinZoom() : Int
    {
        var z:Int = this.zoom - 1;
        while (z > -16) 
        {
           var vld:Bool = true;

           for (l in layers)
               if ((l.enabled) && (!l.layer.validZoom(z)))
               {
                  vld = false;
                  break;
               }

           if (!vld)
              break;

           z--;
        }

        return z + 1;
    }

    public function getMaxZoom() : Int
    {
        var z:Int = this.zoom + 1;
        while (z > -16) 
        {
           var vld:Bool = true;

           for (l in layers)
               if ((l.enabled) && (!l.layer.validZoom(z)))
               {
                  vld = false;
                  break;
               }

           if (!vld)
              break;

           z++;
        }

        return z - 1;
    }

    public function setZoom(zoom:Int)
    {
        for (l in layers)
            if ((l.enabled) && (!l.layer.validZoom(zoom)) && (l.layer.mapservice != null))
               return;

        this.zoom = zoom;

        if (!initialized) return;

        for (l in layers)
            if (l.enabled)
               l.layer.setZoom(this.zoom);
    }

    public function setCenter(point:LngLat)
    { 
		trace("set: " + point);
		
        if (!initialized) 
        {
           center = point;
           return;
        }
		
        for (l in layers)
            if (l.enabled)
               l.layer.setCenter(point);

        dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
    }
	
	public function setCenterPoint(lng:Float, lat:Float)
    { 
		setCenter(new LngLat(lng, lat));
	}

    public function getCenter(): LngLat
    { 
        var c:LngLat = center.clone();
       
		trace(c);
		
		if (initialized)
           for (l in layers)
               if (l.enabled)
               {
                  c = l.layer.getCenter();
                  break;
               }

        return c;
    }

    public function getLngLat(global:Point) : LngLat
    {
        if (initialized)
           for (l in layers)
              if (l.enabled) 
                 return l.layer.getLngLat(l.layer.globalToLocal(global));
        return null;
    }

    public function getLeftTopCorner() : LngLat
    {
        return getLngLat(localToGlobal(new Point(0,0)));
    }

    public function getRightBottomCorner() : LngLat
    {
        var sz = getSize();
        return getLngLat(localToGlobal(new Point(sz.width,sz.height)));
    }

    public function panTo(point:LngLat)
    {
       if (this.animTimer.running)
       {
           this.animTo = point.clone();
           return;
       }

       for (l in layers)
           if (l.enabled)
           {
              this.animTo = point.clone();
              this.animTimer.addEventListener(TimerEvent.TIMER, animStep);
              this.animTimer.start();

              return;
           }
    }


    public function getBitmap() : BitmapData 
    {
        var sz = getSize();
        var bmp:BitmapData = new BitmapData(Std.int(sz.width), Std.int(sz.height), false, 0x00FFFFFF);
        bmp.draw(this);
        return bmp;
    }

    /*============================================================================================== 
      PRIVATE methods
     *==============================================================================================*/
    function setTransparent(val:Bool): Bool
    {
        this.transparent = val;

        graphics.clear();
        if (this.transparent)  
           return true;

        var sz = getSize();
        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0,0,sz.width,sz.height);
        graphics.endFill();

        return this.transparent;
    }

    override function onResize(w:Float, h:Float)
    {
        setTransparent(this.transparent);
        scrollRect = new Rectangle(0, 0, w, h);

        //trace("Canvas resized w:"+w+" h:"+h);
        for (l in layers)
            l.layer.setBBox(new Rectangle(0,0,w,h));
    }

    function onMouseDown(e:MouseEvent)
    {
        var tl:Point = localToGlobal(new Point(0,0));
        var br:Point = localToGlobal(new Point(width, height));

        start = new Point(e.stageX, e.stageY); 
        thpassed = false;

        removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        flash.Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
    }

    function onMouseUp(e:MouseEvent)
    {
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        flash.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        flash.Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);

        if ((!thpassed) && (thtimer == null))
        {
           mappoint = getLngLat(new Point(e.stageX, e.stageY));
           thtimer = new Timer(300, 1);
           thtimer.addEventListener(TimerEvent.TIMER_COMPLETE, fireMapClicked);
           thtimer.start();
        }
    }

    function fireMapClicked(e:TimerEvent)
    {
        dispatchEvent(new MapEvent(MapEvent.MAP_CLICKED, mappoint));

        if (thtimer != null)
        {
           thtimer.stop();
           thtimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fireMapClicked);
           thtimer = null;
        }
    }

    function onMouseDoubleClick(e:MouseEvent)
    {
        if (!doubleClickEnabled) return;

        if (thtimer != null)
        {
           thtimer.stop();
           thtimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fireMapClicked);
           thtimer = null;
        }

        if (e.ctrlKey)
           zoomOut()
        else
           zoomIn();
    }

    function onMouseMove(e:MouseEvent)
    {
       for (l in layers)
           if (l.enabled)
           {
              var pt = l.layer.globalToLocal(new Point(e.stageX, e.stageY));
              dispatchEvent(new MapEvent(MapEvent.MAP_MOUSEMOVE, l.layer.getLngLat(pt)));
              return;
           }   
    }

    function onStageMouseMove(e:MouseEvent)
    {
       var pt:Point = new Point(e.stageX, e.stageY);

       if (!thpassed) 
       {
          if (Point.distance(pt, start) < this.mousethreshold) 
             return;
          start = pt;
          thpassed = true;
          return;
       }

       animStop();

       var diff = pt.subtract(start);
       var cntr:LngLat = null;

       for (l in layers)
           if (l.enabled)
           {
              try 
              {
                  l.layer.moveRelative(diff.x, diff.y);
                  cntr = l.layer.getCenter();
                  center = cntr;
              }
              catch (unknown : Dynamic) 
              {}
           }

       if (cntr != null)
       {
          dispatchEvent(new MapEvent(MapEvent.MAP_MOVE, cntr));
          dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
       }
       start = pt;
    }


    function animStop()
    {
       if (animTimer.running)
       {
          animTimer.stop();
          animTimer.removeEventListener(TimerEvent.TIMER, animStep);
       }
    }

    function animStep(e:flash.events.Event)
    {
       for (l in layers)
           if (l.enabled)
           {
              try {
                 var a:Point = l.layer.getCenterXY();
                 var b:Point = l.layer.getPointXY(animTo);
                 var dist:Float = Point.distance(a, b);
                 if (dist < 1.0) 
                    animStop();
                 a = a.subtract(b);

                 var k:Float = (dist < 5) ? 1.0 : ((dist < 10) ? 5.0 : 10.0);
                 a.x = a.x / k;
                 if (a.x < -64) a.x = -64;
                 if (a.x > 64) a.x = 64;
                 a.y = a.y / k;
                 if (a.y < -64) a.y = -64;
                 if (a.y > 64) a.y = 64;

                 l.layer.moveRelative(a.x, a.y);
       
                 dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
              }
              catch (unknown : Dynamic) 
              {}
           }
    }


    function zoomFinished(e:Event)
    {
       dispatchEvent(new MapEvent(MapEvent.MAP_ZOOMCHANGED, null));
       dispatchEvent(new MapEvent(MapEvent.MAP_CHANGED, null));
    }
}
