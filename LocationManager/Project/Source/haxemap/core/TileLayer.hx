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

import haxemap.core.Tile;
import haxemap.core.TileLoader;
import haxemap.core.Layer;
import haxemap.core.Utils;
import flash.events.Event;
import flash.geom.Point;
import flash.display.Bitmap;

#if TILE_EVT_DBG
import flash.external.ExternalInterface;
#end

class TileLayer extends Layer
{
    var tiles:Array<Tile>;
    var tilecnt:Int;
    var loader:TileLoader;

    var tofs:Int; /* kdy presunout tiles zprava doleva (kolik za obrazem musi min. byt) */
    var lx:Int;
    var rx:Int;
    var ty:Int;
    var by:Int;
    var tilesize:Int;
    var basetid:TileID;
    var ofsx:Float;
    var ofsy:Float;
    var smooth:Bool;

    public function new(map_service:MapService = null, tiles:Int = 8, smooth_zoom:Bool = false)
    {
        super(map_service);

        this.tilecnt = tiles;
        this.tiles = new Array<Tile>();
        this.tilesize = 256;
        this.tofs = 1;
        this.basetid = {x:0,y:0,z:0};
        this.ofsx = this.ofsy = 0;
        this.tofs = 0;
        this.smooth = smooth_zoom;
        
        while (this.tiles.length < this.tilecnt*this.tilecnt)
        {
            var t:Tile = new Tile(this.tiles.length, this.tilesize);
            this.tiles.push(t);
            addChild(t);
        }
        initTile();

        this.loader = new TileLoader();
	this.loader.addEventListener(TileLoadedEvent.TILE_LOADED, tileLoaded);
    }

    /*============================================================================================== 
      PUBLIC methods
     *==============================================================================================*/
    override public function initialize(update:Bool=true) : Int
    {
       var res = super.initialize(false);
       if (res != 0) 
          return res;
 
       loader.mapservice = mapservice;
       basetid.z = mapservice.zoom_def;
       tilesize = mapservice.tile_size;

       alignLayer();

       initialized = true;
       updateEnabled = true;

       if (update)
          updateContent(true);

       return 0;
    }

    override public function clear()
    {
        //clean loader queue
        loader.clear();

        //release used images
        for (t in tiles) 
            t.assignImage(null);
    }

    override public function getOffset() : Point
    {
       var tp = tiles.length >> 1;
       return new Point(this.x - (this.canvascenter.x - (scaleX*this.tilesize)/2), this.y - (this.canvascenter.y - (scaleY*this.tilesize)/2));
    }

    /*============================================================================================== 
      PRIVATE methods
     *==============================================================================================*/
    function initTile()
    {
        this.lx = -this.tofs;
        this.rx = this.tilecnt-1-this.tofs;
        this.ty = -this.tofs;
        this.by = this.tilecnt-1-this.tofs;

        var tp = this.tilecnt >> 1;
        this.lx = -tp;
        this.ty = -tp;
        tp = this.tilecnt - tp;
        this.rx = tp-1;
        this.by = tp-1;

        var i:Int = 0;
        var j:Int = 0;
        var idx:Int = 0;

        for (t in tiles)
        {
            if (i == this.tilecnt) 
            {
               i = 0;
               j++;
            }

            t.tx = this.lx + i;
            t.ty = this.ty + j;

            t.ltidx = (i == 0) ? idx + this.tilecnt - 1 : idx - 1;
            t.rtidx = (i < this.tilecnt-1) ? idx + 1 : idx - this.tilecnt + 1;
            t.ttidx = (j == 0) ? idx + ((this.tilecnt-1) * this.tilecnt) : idx - this.tilecnt;
            t.btidx = (j < this.tilecnt-1) ? idx + this.tilecnt : idx;

            t.x = tilesize*t.tx + ofsx;
            t.y = tilesize*t.ty + ofsy;

            i++;
            idx++;
        }

    }
   
    override function centerUpdated(clearQueue:Bool)
    { 
       if (!this.initialized) 
          return;

       if (clearQueue)
       {
          saveImages();
          clear();
       }

       alignLayer();

       initTile();
       emitRequests();
    }



    override function updateContent(forceUpdate:Bool=false)
    {
        var i = 0;

        //move tiles if it is needed
        while (i < tiles.length / 2) 
        {
           if (!testAndShift())
              break;

           i++;
        }

        if ((i == 0) && (!forceUpdate))
           return;

        //update tile positions
        for (t in tiles) 
        { 
            t.x = tilesize*t.tx + ofsx;
            t.y = tilesize*t.ty + ofsy;
        }

        //load required images
        emitRequests();
    }

    override function updateChanged()
    {
        if (!this.updateEnabled) 
           loader.clear();
    }

    override function zoomChanged(prevEnabled:Bool, newZoom:Int)
    {
        var lp:Int = 0;
        var tp:Int = 0;
        var tilehsize:Float = tilesize / 2;

        if (this.zoom > newZoom)
        {
           if (smooth) {
               //smooth zoom - combines four tiles into one
 
               var bx:Int = (basetid.x & 1) ^ 1;
               var by:Int = (basetid.y & 1) ^ 1;

               for (t in tiles)
               {
                   if ((t.tx & 1 == bx) || (t.ty & 1 == by)) continue;
 
                   var bd = new flash.display.BitmapData(tilesize, tilesize, false, 0xFFFFFF);
                   var scaleMatrix = new flash.geom.Matrix(); 
                   scaleMatrix.scale(0.5, 0.5);
                   if (t.image != null)
                      bd.draw(t.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(0,0,tilehsize,tilehsize), false);

                   var scaleMatrix = new flash.geom.Matrix(); 
                   scaleMatrix.scale(0.5, 0.5);
                   scaleMatrix.translate(tilehsize,0);
                   var tt = tiles[t.rtidx];
                   if ((tt.tx != this.lx) && (tt.image != null))
                      bd.draw(tt.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(tilehsize,0,tilehsize,tilehsize), false);


                   var scaleMatrix = new flash.geom.Matrix(); 
                   scaleMatrix.scale(0.5, 0.5);
                   scaleMatrix.translate(0,tilehsize);
                   var tt = tiles[t.btidx];
                   if ((tt.ty != this.ty) && (tt.image != null))
                      bd.draw(tt.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(0,tilehsize,tilehsize,tilehsize), false);

                   var scaleMatrix = new flash.geom.Matrix(); 
                   scaleMatrix.scale(0.5, 0.5);
                   scaleMatrix.translate(tilehsize,tilehsize);
                   var tt = tiles[tiles[t.btidx].rtidx];
                   if ((tt.tx != this.lx) && (tt.ty != this.ty) && (tt.image != null))
                      bd.draw(tt.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(tilehsize,tilehsize,tilehsize,tilehsize), false);

                   loader.addTile((((mapservice.invert_x) ? -t.tx : t.tx) + basetid.x) >> 1,
                                    (((mapservice.invert_y) ? -t.ty : t.ty) + basetid.y) >> 1, 
                                    newZoom + basetid.z,
                                    bd, false
                                   );

                }
           }

           //zoom out
           if (basetid.x & 1 == 1) x -= tilesize/2;
           if (basetid.y & 1 == 1) y -= tilesize/2;
           basetid.x = basetid.x >> 1;
           basetid.y = basetid.y >> 1;

           ofsx = ofsx / 2.0;
           ofsy = ofsy / 2.0;

           //coeficients for the /2 transformation
           //   x' = x/2 == x - x/2
           //   y' = y/2 == y - y/2
           lp = - Std.int(this.lx/2);
           tp = - Std.int(this.ty/2);

        }
        else 
        {

           if (smooth) 
           {
              //smooth zoom - each tile is splited into the four tiles
              var mintx:Int = Std.int((3*this.lx + this.rx + 1) / 4);
              var maxtx:Int = Std.int((3*this.rx + this.lx + 3) / 4);
              var minty:Int = Std.int((3*this.ty + this.by + 1) / 4);
              var maxty:Int = Std.int((3*this.by + this.ty + 3) / 4);
              for (t in tiles)
                  if ((t.image != null) && (t.tx >= mintx) && (t.tx <= maxtx) && (t.ty >= minty) && (t.ty <= maxty))
                  {
                     var bd = new flash.display.BitmapData(tilesize, tilesize, false, 0xFFFFFF);
                     var scaleMatrix = new flash.geom.Matrix(); 
                     scaleMatrix.scale(2, 2);
                     bd.draw(t.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(0,0,tilesize,tilesize), false);
                     loader.addTile((((mapservice.invert_x) ? -t.tx : t.tx) + basetid.x)*2,
                                    (((mapservice.invert_y) ? -t.ty : t.ty) + basetid.y)*2, 
                                    newZoom + basetid.z, bd, false
                                   );


                     var bd = new flash.display.BitmapData(tilesize, tilesize, false, 0xFFFFFF);
                     var scaleMatrix = new flash.geom.Matrix(); 
                     scaleMatrix.scale(2, 2);
                     scaleMatrix.translate(-tilesize,0);
                     bd.draw(t.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(0,0,tilesize,tilesize), false);
                     loader.addTile((((mapservice.invert_x) ? -t.tx : t.tx) + basetid.x)*2 + 1,
                                    (((mapservice.invert_y) ? -t.ty : t.ty) + basetid.y)*2, 
                                    newZoom + basetid.z, bd, false
                                   );


                     var bd = new flash.display.BitmapData(tilesize, tilesize, false, 0xFFFFFF);
                     var scaleMatrix = new flash.geom.Matrix(); 
                     scaleMatrix.scale(2, 2);
                     scaleMatrix.translate(0,-tilesize);
                     bd.draw(t.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(0,0,tilesize,tilesize), false);
                     loader.addTile((((mapservice.invert_x) ? -t.tx : t.tx) + basetid.x)*2,
                                    (((mapservice.invert_y) ? -t.ty : t.ty) + basetid.y)*2 + 1, 
                                    newZoom + basetid.z, bd, false
                                  );


                     var bd = new flash.display.BitmapData(tilesize, tilesize, false, 0x00FF00);
                     var scaleMatrix = new flash.geom.Matrix(); 
                     scaleMatrix.scale(2, 2);
                     scaleMatrix.translate(-tilesize,-tilesize);
                     bd.draw(t.image.bitmapData, scaleMatrix, null, null, new flash.geom.Rectangle(0,0,tilesize,tilesize), false);
                     loader.addTile((((mapservice.invert_x) ? -t.tx : t.tx) + basetid.x)*2 + 1,
                                    (((mapservice.invert_y) ? -t.ty : t.ty) + basetid.y)*2 + 1, 
                                    newZoom + basetid.z, bd, false
                                  );

              }
           }

           //zoom in
           basetid.x = basetid.x << 1;
           basetid.y = basetid.y << 1;

           ofsx = ofsx * 2.0;
           ofsy = ofsy * 2.0;

           //coeficients for the *2 transformation
           //   x' = x*2 == x + x
           //   y' = y*2 == y + y
           lp = this.lx;
           tp = this.ty;


        }

        //transform tile id's
        for (t in tiles)
        {
            t.tx += lp;
            t.ty += tp;
        }

        this.rx += lp;
        this.by += tp;
        this.lx += lp;
        this.ty += tp;

        //update zoom, reset scale
        this.zoom = newZoom;

        scaleX = 1; 
        scaleY = 1;

        clear();
        center = this.lastcenter;
        centerUpdated(false);

        dispatchEvent(new Event(Layer.ZOOM_FINISHED));

        if ((prevEnabled) && (!this.updateEnabled))
        {
           this.updateEnabled = true;
           updateChanged();
        }

        updateContent(true);
    }

    function testAndShift() : Bool
    {
        var mv_left = ((this.lx+this.tofs)*tilesize*scaleX + this.x > bbox.x);
        var mv_right = ((this.rx-this.tofs)*tilesize*scaleX + this.x < (bbox.x+bbox.width));
        var mv_up = ((this.ty+this.tofs)*tilesize*scaleY + this.y > bbox.y);
        var mv_down = ((this.by-this.tofs)*tilesize*scaleY + this.y < (bbox.y+bbox.height));
 
        if ((mv_left) && ((this.rx-1)*tilesize*scaleX + this.x < (bbox.x+bbox.width)))
           mv_left = false;
        if ((mv_up) && ((this.by-1)*tilesize*scaleY + this.y < (bbox.y+bbox.height)))
           mv_up = false;
        if ((mv_right) && ((this.lx+1)*tilesize*scaleX + this.x > bbox.x))
           mv_right = false;
        if ((mv_down) && ((this.ty+1)*tilesize*scaleY + this.y > bbox.y))
           mv_down = false;

        if (mv_left && mv_right) mv_right = false;
        if (mv_up && mv_down) mv_down = false;

        if (!(mv_left || mv_right || mv_up || mv_down)) return false;

        for (t in tiles)  
        {
            if ((mv_left) && (t.tx == rx))
               t.tx = lx - 1;
            if ((mv_right) && (t.tx == lx))
               t.tx = rx + 1;
            if ((mv_up) && (t.ty == by))
               t.ty = ty - 1;
            if ((mv_down) && (t.ty == ty))
               t.ty = by + 1;
        }
        var dx = (mv_left) ? -1 : ((mv_right) ? 1 : 0);
        var dy = (mv_up) ? -1 : ((mv_down) ? 1 : 0);

        lx += dx;
        rx += dx;
        ty += dy;
        by += dy;

        return true;
    }

    function alignLayer()
    {

       if (center == null) return;

       x = this.canvascenter.x;
       y = this.canvascenter.y;

       basetid = mapservice.lonlat2tile(center.lng, center.lat, basetid.z+zoom);
       var ptc = mapservice.lonlat2XY(center.lng, center.lat, basetid.z);
       var ll = mapservice.tile2lonlat(basetid);
       var ptt = mapservice.lonlat2XY(ll.x, ll.y, basetid.z);
       basetid.z -= zoom;
       ptt = ptt.subtract(ptc);
       ofsx = ptt.x;
       ofsy = ptt.y;
    }


    function emitRequests()
    {
        var prio:Int = 0;
        var xx:Float;
        var yy:Float;

        loader.disable();

        try
        {
	    loader.tidyQueue(((mapservice.invert_x) ? -lx : lx) + basetid.x, ((mapservice.invert_x) ? -rx : rx) + basetid.x, 
                             ((mapservice.invert_y) ? -ty : ty) + basetid.y, ((mapservice.invert_y) ? -by : by) + basetid.y, 
                             zoom + basetid.z
                            );

            for (tile in tiles)
            {
                if (tile.needImage())
                {


                    xx = (tile.x + x - ofsx - this.canvascenter.x);
                    yy = (tile.y + y - ofsy - this.canvascenter.y);
                    prio = Std.int(Math.sqrt(xx*xx + yy*yy));

                    loader.addRequest( ((mapservice.invert_x) ? -tile.tx : tile.tx) + basetid.x, 
                                       ((mapservice.invert_y) ? -tile.ty : tile.ty) + basetid.y, 
                                       zoom + basetid.z, 
                                       tile.tidx, 
                                       prio
                                     );

                    tile.waitForImage();
                }
            }

        } catch (unknown : Dynamic) {};

        loader.enable();
    }


    function tileLoaded(e:TileLoadedEvent)
    {
        if ((e.tidx >= 0) && (e.tidx < tiles.length)) 
        {

            var t:Tile = tiles[e.tidx];
            if ((t != null) &&  
                (((mapservice.invert_x) ? -t.tx : t.tx)  == e.x - basetid.x) &&  //check x-id
                (((mapservice.invert_y) ? -t.ty : t.ty) == e.y - basetid.y) &&   //check y-id
                (e.z - basetid.z == zoom)                                        //check z
               ) 
            { 

               #if TILE_EVT_DBG
               try {
                  ExternalInterface.call("debugMessage", "tileLoaded "+e.data+" x:"+t.tx+" y:"+t.ty+" ("+e.x+","+e.y+","+e.z+") priority:"+e.p);
               } catch (unknown : Dynamic)  { };
               #end

               t.assignImage(e.data);
            }
       }
    }


    function saveImages()
    {
       for (t in tiles) 
           if (t.image != null) 
              loader.addTile(((mapservice.invert_x) ? -t.tx : t.tx) + basetid.x,
                              ((mapservice.invert_y) ? -t.ty : t.ty) + basetid.y, 
                              zoom + basetid.z,
                              t.image.bitmapData
                             );
      
      
    }

}
