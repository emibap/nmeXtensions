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

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.events.TimerEvent;
import haxemap.core.Utils;
import haxemap.core.LngLat;

class Layer extends Sprite
{
    public static var ZOOM_FINISHED:String = "zoomfinished";

    public var canvas:Canvas;
    
	public var bbox(default, null):Rectangle;
    
	var zoom:Int;
    var animTimer:Timer;
    var animState:Int;
    var animTmp:Float;
    var initialized:Bool;
    var updateEnabled:Bool;
    var center:LngLat;
    var lastcenter:LngLat;
    var canvascenter:Point;
    var lastxy:Point;
    var lastcxy:Point;
    var scalable:Bool;
    public var mapservice:MapService;

    public function new(map_service:MapService = null, scalable:Bool = false)
    {
        super();

        this.scalable = scalable;        
        this.mapservice = map_service;
 	this.initialized = false;
        this.updateEnabled = false;
        
		//this.bbox = new Rectangle(0,0,flash.Lib.current.stage.width, flash.Lib.current.stage.height);
        //this.canvascenter = new Point(this.bbox.width/2.0,this.bbox.height/2.0);
        //this.center = null;
        this.zoom = 0;
        this.lastxy = null;
        this.lastcxy = null;

        animTimer = new Timer(15, 0);
	animTimer.addEventListener(TimerEvent.TIMER, animStep);

        mouseEnabled = false;

    }

    /*============================================================================================== 
      INITIALIZATION / FINALIZATION / MISC
     *==============================================================================================*/

    public function initialize(update:Bool=true) : Int
    {

       if (mapservice == null)
          return 1;

       if (this.initialized)
          finalize();

       
		setBBox(new Rectangle(0, 0, canvas.getSize().width, canvas.getSize().height));
		  
	   this.x = this.canvascenter.x;
       this.y = this.canvascenter.y;

       synchronizeScale(true);

       if (Std.is(this, Layer)) 
       {
          this.initialized = true;
          if (!this.updateEnabled)
          {
             this.updateEnabled = true;
             updateChanged();
          }

          if (update)
             updateContent(true);
       }

       return 0;
    }

    public function finalize()
    {
       if (this.initialized)
          clear();

       this.initialized = false;
    }


    public function setBBox(bbox:Rectangle)
    {
        if (bbox != null) 
        {
           var force:Bool = false;
           if ((this.bbox != null) && (this.center != null) && (this.initialized))
           {
	      var ptc = getCenter();
              if ((ptc.lng != this.center.lng) || (ptc.lat != this.center.lat)) force = true;
              this.center = ptc;
           }
           this.bbox = bbox;
           this.canvascenter = new Point(this.bbox.x + this.bbox.width/2.0, this.bbox.y + this.bbox.height/2.0);
           centerUpdated(force);
        }
    }


    public function clear()
    {
    }

    /*============================================================================================== 
      POSITION
     *==============================================================================================*/

    public function getOriginXY() : Point
    {
       if (this.mapservice == null)
          return new Point(0,0);

       return mapservice.lonlat2XY(center.lng, center.lat, mapservice.zoom_def + zoom);
    }

    public function getCenterXY() : Point
    {
       var pta:Point = getOriginXY();
       pta.offset(-x + this.canvascenter.x, - y + this.canvascenter.y);
       return pta;
    }

    public function getPointXY(point:LngLat) : Point
    {
       if (this.mapservice == null)
          return new Point(0,0);

       return mapservice.lonlat2XY(point.lng, point.lat, mapservice.zoom_def + zoom);
    }

    public function getCenter() : LngLat
    {
       if (this.mapservice == null)
          return null;

       if ((x == this.canvascenter.x) && (y == this.canvascenter.y))
          return center.clone();

       var z:Int = mapservice.zoom_def + zoom;
       var pta:Point = getCenterXY();
       var ptb:LonLat = mapservice.XY2lonlat(pta.x, pta.y, z);
 
       return new LngLat(ptb.x, ptb.y);
    }

    public function getXY(local:Point) : Point
    {
        var z:Int = mapservice.zoom_def + zoom;
        var pta:Point = mapservice.lonlat2XY(center.lng, center.lat, z);
        pta.offset(scaleX*local.x, scaleY*local.y);
        return pta;
    }

    public function getLngLat(local:Point) : LngLat
    {
        var z:Int = mapservice.zoom_def + zoom;
        var pta:Point = mapservice.lonlat2XY(center.lng, center.lat, z);
        var ptb:Point = mapservice.XY2lonlat(pta.x + scaleX*local.x, pta.y + scaleY*local.y, z);
        return new LngLat(ptb.x, ptb.y);
    }

    public function setCenter(point:LngLat)
    {
       if ((this.scalable) && (initialized)) 
          synchronizeCenter(point);
       else 
          this.center = point.clone();
		  
       centerUpdated(true);
    }

    public function moveTo(x:Float, y:Float) 
    { 
        if ((this.animTimer.running) || ((this.x == x) && (this.y == y)))
           return;


        this.x = x;
        this.y = y;

        if (this.updateEnabled)
           updateContent();
    }

    public function moveRelative(dx:Float, dy:Float) 
    { 
        if ((this.animTimer.running) || ((dx == 0) && (dy == 0)))
           return;

        this.x += dx;
        this.y += dy;

        if (this.updateEnabled)
           updateContent();
    }

    public function getOffset() : Point
    {
       return new Point(this.x - this.canvascenter.x, this.y - this.canvascenter.y);
    }

    public function getLeftTopCorner(margin:Float = 0.0) : LngLat
    {
       if (!initialized) return null;

       var x:Float = this.canvascenter.x - this.x - this.bbox.width/2.0 + margin;
       var y:Float = this.canvascenter.y - this.y - this.bbox.height/2.0 + margin;

       var z:Int = mapservice.zoom_def + zoom;
       var pta:Point = mapservice.lonlat2XY(center.lng, center.lat, z);
       var ptb:Point = mapservice.XY2lonlat(pta.x + scaleX*x, pta.y + scaleY*y, z);

       return new LngLat(ptb.x, ptb.y);
    }

    public function getRightBottomCorner(margin:Float = 0.0) : LngLat
    {
       if (!initialized) return null;

       var x:Float = this.canvascenter.x - this.x + this.bbox.width/2.0 + margin;
       var y:Float = this.canvascenter.y - this.y + this.bbox.height/2.0 + margin;

       var z:Int = mapservice.zoom_def + zoom;
       var pta:Point = mapservice.lonlat2XY(center.lng, center.lat, z);
       var ptb:Point = mapservice.XY2lonlat(pta.x + scaleX*x, pta.y + scaleY*y, z);

       return new LngLat(ptb.x, ptb.y);
    }


    /*============================================================================================== 
      ZOOM
     *==============================================================================================*/

    public function validZoom(zoom:Int) : Bool
    {
        return ((!this.animTimer.running) && (this.mapservice != null) && (this.mapservice.validZoom(zoom)));
    }

    public function setZoom(zoom:Int)
    {
        if (!validZoom(zoom)) return;
 
        this.zoom = zoom;
        if (this.scalable) 
           synchronizeScale();

        if (!this.initialized)
           return;

        this.center = getCenter(); //get actual center & update layer content
        centerUpdated(true);
    }

    public function zoomIn(animate:Bool = true)
    {
        if ((this.animTimer.running) || (!this.initialized) || (this.mapservice == null) || (!this.mapservice.validZoom(zoom+1)))
           return;

        this.lastxy = new Point(x,y);
        this.lastcenter = getCenter();
        this.lastcxy = new Point(this.canvascenter.x, this.canvascenter.y);

        if (!animate)
        {
           scaleX = scaleX * 2.0;
           scaleY = scaleY * 2.0;

           x = lastcxy.x + (lastxy.x - lastcxy.x) * 2.0;
           y = lastcxy.y + (lastxy.y - lastcxy.y) * 2.0;

           zoomChanged(this.updateEnabled, zoom + 1);

           return;
        }


        this.animState = 0x0000;

        if (this.updateEnabled)
        {
           this.updateEnabled = false;
           updateChanged();
           this.animState += 0x0100;
        }

        this.animTmp = scaleX;
        this.animTimer.start();
    }

    public function zoomOut(animate:Bool = true)
    {
        if ((this.animTimer.running) || (!this.initialized) || (this.mapservice == null) || (!this.mapservice.validZoom(zoom-1)))
           return;

        this.lastxy = new Point(x,y);
        this.lastcenter = getCenter();
        this.lastcxy = new Point(this.canvascenter.x, this.canvascenter.y);

        if (!animate)
        {
           scaleX = scaleX / 2.0;
           scaleY = scaleY / 2.0;

           x = lastcxy.x + (lastxy.x - lastcxy.x) / 2.0;
           y = lastcxy.y + (lastxy.y - lastcxy.y) / 2.0;

           zoomChanged(this.updateEnabled, zoom - 1);

           return;
        }

        this.animState = 0x1000;
        if (this.updateEnabled)
        {
           this.updateEnabled = false;
           updateChanged();
           this.animState += 0x0100;
        }

        this.animTmp = scaleX;
        this.animTimer.start();
    }
 
    public function update()
    {
        updateContent(true);
    }
 
    /*============================================================================================== 
      PRIVATE
     *==============================================================================================*/
    function updateContent(forceUpdate:Bool=false)
    {
    }
 
    function updateChanged()
    {
    }

    function zoomChanged(prevEnabled:Bool, newZoom:Int)
    {
        this.zoom = newZoom;
        if (!scalable)
        {
           scaleX = scaleY = 1.0;      

           center = this.lastcenter;
           centerUpdated(false);
        }
        else
           synchronizeCenter(this.lastcenter);

        dispatchEvent(new Event(ZOOM_FINISHED));

        if ((prevEnabled) && (!this.updateEnabled))
        {
           this.updateEnabled = true;
           updateContent(!scalable);
           updateChanged();
        }
    }

    /*============================================================================================== 
      PRIVATE
     *==============================================================================================*/

    function synchronizeCenter(point:LngLat)
    {
		if (!this.scalable)
          return;

       var pta:Point = getOriginXY();
       var ptb:Point = getPointXY(point);
       
	   this.x = pta.x - ptb.x + canvascenter.x;
       this.y = pta.y - ptb.y + canvascenter.y;
    }

    function synchronizeScale(init:Bool=false)
    {
    
       if (this.scalable)
       {
           if (this.zoom < 0) {
              scaleX = 1.0 / (1 << (-this.zoom));
              scaleY = 1.0 / (1 << (-this.zoom));
           } else {
              scaleX = (1 << this.zoom);
              scaleY = (1 << this.zoom);
           }

       } 
       else if ((!this.scalable) && (init))
       {
          this.scaleX = 1.0;
          this.scaleY = 1.0;
       }

    }

    function centerUpdated(clearQueue:Bool)
    { 
       if (!this.initialized)
          return;

       if (!this.scalable) 
       {
          this.x = this.canvascenter.x;
          this.y = this.canvascenter.y;
       }

       if (this.updateEnabled)
          updateContent((clearQueue) && (!scalable));
    }

    function animStep(e:flash.events.Event)
    {
        var steps:Float = 10.0;

        var act = (animState >> 12) & 0x0F;
        var en  = (animState >> 8) & 0x0F;
        var st  = (animState & 0xFF);

        if (act == 0) 
        {
           if (st < steps) 
           {
              var scale:Float = (1.0 + (st + 1)/steps);

              scaleX = animTmp * scale;
              scaleY = scaleX;

              x = lastcxy.x + (lastxy.x - lastcxy.x) * scale;
              y = lastcxy.y + (lastxy.y - lastcxy.y) * scale;

              animState += 1;
           } 
           else if (st == steps) 
           {
              animTimer.stop();

              scaleX = animTmp * 2.0;
              scaleY = animTmp * 2.0;

              x = lastcxy.x + (lastxy.x - lastcxy.x) * 2.0;
              y = lastcxy.y + (lastxy.y - lastcxy.y) * 2.0;

              zoomChanged(en == 1, zoom + 1);
           }
        }
        else if (act == 1) 
        {
           if (st < steps) 
           {
              var scale:Float = (1.0 + (st + 1)/steps);

              scaleX = animTmp / scale;
              scaleY = scaleX;

              x = lastcxy.x + (lastxy.x - lastcxy.x) / scale;
              y = lastcxy.y + (lastxy.y - lastcxy.y) / scale;

              animState += 1;
           } 
           else if (st == steps) 
           {
              animTimer.stop();

              scaleX = animTmp / 2.0;
              scaleY = animTmp / 2.0;

              x = lastcxy.x + (lastxy.x - lastcxy.x) / 2.0;
              y = lastcxy.y + (lastxy.y - lastcxy.y) / 2.0;

              zoomChanged(en == 1, zoom - 1);
           }
        }
    }
 
}
