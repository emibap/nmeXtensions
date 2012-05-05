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

import haxemap.core.Utils;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.display.Loader;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.net.URLRequest;
#if flash
import flash.system.LoaderContext;
#end
import flash.utils.Timer;
import flash.events.TimerEvent;

#if TILE_EVT_DBG
import flash.external.ExternalInterface;
#end

typedef TileIDT = {
   var x : Int;
   var y : Int;
   var z : Int;
   var tidx : Int;
   var ttl : Int;
   var priority: Int;
};


class TileLoadedEvent extends flash.events.Event 
{  
    public static var TILE_LOADED:String = "tileLoaded";

    public var x:Int;  
    public var y:Int;  
    public var z:Int;  
    public var p:Int;  
    public var tidx:Int;  
    public var data:Bitmap;
           
    public function new(x:Int, y:Int, z:Int, tidx:Int, p:Int, data:Bitmap) {  
         super(TILE_LOADED);  
         this.x = x;     
         this.y = y;     
         this.z = z;     
         this.p = p;     
         this.tidx = tidx;     
         this.data = data;
    }  
}     

class ImageLoader extends Loader 
{
   static var TIMEOUT:Int = 5; //10 sec

   public var used:Bool;
   public var ignore:Bool;
   public var id:Int;
   public var ttl:Int;
   public var tid:TileIDT;


   public function new(id:Int)
   {
      super();
      this.used = false;
      this.ignore = false;
      this.id = id;
      this.ttl = TIMEOUT;
   }

   public function loadImage(tid:TileIDT, url:String) {
      var urlRequest:URLRequest = new URLRequest(url);
      this.tid = tid;
      
	  try {

        #if TILE_EVT_DBG
        try {
            ExternalInterface.call("debugMessage", "loadImage "+id+" ("+tid.x+","+tid.y+","+tid.z+") prio:"+tid.priority);
        } catch (unknown : Dynamic)  { };
        #end

		#if flash
		this.load(urlRequest,  new LoaderContext(true));
        #else 
		this.load(urlRequest);
		#end
		
		this.used = true;
        this.ttl = TIMEOUT;

      } 
      catch (unknown : Dynamic)  
      {
        this.used = false;
      }
	  
	 /* this.load(urlRequest);
	  this.used = true;
	  this.ttl = TIMEOUT;*/
   }
 
   override public function toString() 
   {
      return "[ImageLoader id:" + id + "]";
   }

}

typedef TempTile = {
   var x : Int;
   var y : Int;
   var z : Int;
   var img : BitmapData;
   var ttl : Int;
   var original : Bool;
};

class TileLoader extends EventDispatcher
{
    public static var DEFAULT_TTL:Int = 3;
    public var mapservice:MapService;
    var loaders:Array<ImageLoader>;
    var queue:Array<TileIDT>;
    var tempqueue:Array<TempTile>;
    var enabled:Int;
    var watchdog:Timer;

    public function new(threads:Int = 18)
    {
       super();

       mapservice = null;
       enabled = 0;

       watchdog = new Timer(1000, 0);
       watchdog.addEventListener(TimerEvent.TIMER, checkLoaders);
       watchdog.stop();

       loaders = new Array<ImageLoader>();
       queue = new Array<TileIDT>();
       tempqueue = new Array<TempTile>();

       for (i in 0...threads) 
       {
           var l = new ImageLoader(i);
           l.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loaderComplete);
           l.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loaderError);
           loaders.push(l);

       }
    }

    /*============================================================================================== 
      PUBLIC methods
     *==============================================================================================*/

    public function clear()
    {
       clearQueue();

	   for (l in loaders)
           if (l.used) 
           {
              l.ignore = true;
              try {
				 //l.close(); //BUGGY!
                 
				 
				 if (l.parent != null)
					l.parent.removeChild(l);
				 
				 l.unload();
				 
				 //loaders.remove(l);
				
              } 
              catch (unknown : Dynamic)  
              { 
				//trace(unknown);  
				};
           }
 
    }

    public function enable()
    {
       if (enabled > 0)
          enabled--;
 
       if (enabled == 0)
       {
          sortQueue();
          processQueue();

          if (!watchdog.running)
             watchdog.start();
       }
    }

    public function disable()
    {
       if (watchdog.running)
          watchdog.stop();

       enabled++;
    }


    public function tidyQueue(minx:Int, maxx:Int, miny:Int, maxy:Int, z:Int) 
    {
       var i:Int = 0;
       while (i < queue.length)
       {
          var tid:TileIDT = queue[i];
          if (tid.z == z) 
          {
             if ((tid.x < minx) || (tid.x > maxx) || (tid.y < miny) || (tid.y > maxy)) 
                queue.remove(tid);
             else
                i += 1;
          } 
          else
             queue.remove(tid);
       }
    }

    public function addRequest(x:Int, y:Int, z:Int, tidx:Int, priority:Int = 0)
    {
       if ((x < 0) || (y < 0) || (z < 0)) return; 

       var q:TempTile = getTile(x, y, z);
       if (q != null) 
       {
          tempqueue.remove(q);
          dispatchEvent(new TileLoadedEvent(x,y,z,tidx,priority, new Bitmap(q.img)));
          if (q.original)
             return;
       }

       for (l in loaders)  
           if ((l.used) && (!l.ignore) && (l.tid.x == x) && (l.tid.y == y) && (l.tid.z == z))
              return;  //request already served, return

       var exists:Bool = false;
       for (tid in queue)
           if ((tid.x == x) && (tid.y == y) && (tid.z == z)) 
           {
              //request already in queue, update priority
              tid.priority = priority;
              exists = true;
              break;
           }

       if (!exists)
          queue.push({x:x,y:y,z:z,tidx:tidx,priority:priority,ttl:DEFAULT_TTL});

       if (enabled == 0) 
       {
          sortQueue();
          processQueue();
       }

    }

    public function addTile(x:Int, y:Int, z:Int, img:BitmapData, original:Bool = true)
    {
       //check if the tile image is not already in queue
       var tmp:TempTile = getTile(x,y,z);
       if (tmp != null) 
       {
          if (((!tmp.original) && (original)) || ((!tmp.original) && (!original)))
          {
             tmp.img = img; 
             tmp.original = original;
             tmp.ttl = DEFAULT_TTL;
          }
          return;
       }

       insertTile({x: x, y: y, z: z, img: img, ttl:DEFAULT_TTL, original:original});
    }

    override public function toString() : String
    {
       var used = 0;
       for (l in loaders)
            if (l.used) 
               used++;
      
       return "[TileLoader] threads total:" + loaders.length + ", active threads:" + used + ", enabled threads:" + enabled;
    }

    /*============================================================================================== 
      PRIVATE methods
     *==============================================================================================*/
    function clearQueue()
    {
       while (queue.length > 0) 
             queue.pop();
    }

    function checkLoaders(e:TimerEvent)
    {
        //watchdog timer event 

        //check for broken loaders
        var used = 0;
        for (l in loaders)
             if (l.used)  
             {
                if (l.ttl > 0) 
                   l.ttl--;
                else if (l.ttl == 0) 
                   loaderFailed(l);
                used++;
             }
 
        var i=0;
        var q:TempTile;
        //remove unused tiles in tempqueue
        while (i < tempqueue.length)
        {
            q = tempqueue[i];
			
            if (q.ttl > 0)
               q.ttl--;
            else if (q.ttl == 0) 
            {
               tempqueue.remove(q);
               continue;
            }
        
            i++;
            used++;
        }

        if ((used == 0) && (watchdog.running))
           watchdog.stop();
 
    }


    function sortQueue()
    {
       queue.sort(function(x:TileIDT,y:TileIDT):Int { return x.priority - y.priority;});
    }


    function processQueue()
    {

       if ((enabled != 0) || (queue.length == 0) || (mapservice == null))
          return;

       if (queue.length == 0) 
          return;

       var tid:TileIDT;
       for (l in loaders)  
       {
           if (l.used) 
              continue;

           #if TILE_EVT_DBG
           try {
                ExternalInterface.call("debugMessage", "processQueue  qlen:"+queue.length);
           } catch (unknown : Dynamic)  { };
           #end

           if (queue.length == 0) return;

           tid = queue.shift();

           var url:String = mapservice.tile2url(tid);
           if (url != "")
              l.loadImage(tid, url);

           if (!watchdog.running)
              watchdog.start();

       }

    }

    function loaderComplete(e:Event)
    {

        if ((e.target == null) || (e.target.loader == null))
           return;
 
        var loader:ImageLoader = e.target.loader;

		if (!loader.ignore) 
        {
           try {
               var x:Int = loader.tid.x;
               var y:Int = loader.tid.y;
               var z:Int = loader.tid.z;
               var t:Int = loader.tid.tidx;
               var p:Int = loader.tid.priority;

               #if TILE_EVT_DBG
               try {
                  ExternalInterface.call("debugMessage", "tileLoaded ("+x+","+y+","+z+") priority:"+p);
               } catch (unknown : Dynamic)  { };
               #end

               var bitmapc:Bitmap = new Bitmap(cast(loader.content, Bitmap).bitmapData.clone());
               
			   dispatchEvent(new TileLoadedEvent(x, y, z, t, p, bitmapc));
           } 
           catch (unknown : Dynamic)  
           { 

               //chyba, znovu do fronty, pokud jiz neni vycerpan poc. pokusu
               if (loader.tid.ttl > 0)
               {
                  queue.push({x:loader.tid.x, y:loader.tid.y, z:loader.tid.z, 
                              tidx:loader.tid.tidx,
                              ttl:loader.tid.ttl - 1,
                              priority:loader.tid.priority
                             });
                  if (enabled == 0) 
                     sortQueue();
               }

           };
        }
        else  
        {
           #if TILE_EVT_DBG
           try {
              ExternalInterface.call("debugMessage", "tileIgnored");
           } catch (unknown : Dynamic)  { };
           #end
        }

        try {
           loader.unload();
        } catch (unknown : Dynamic)  {};

        loader.used = false;
        loader.ignore = false;

        processQueue();
    }

    function loaderFailed(l:ImageLoader)
    {
        l.used = false;
        l.ignore = false;

		trace("failed " + l.tid);
		
        #if TILE_EVT_DBG
        try {
            ExternalInterface.call("debugMessage", "tileError " + l.tid.x + ","+l.tid.y+","+l.tid.z);
        } catch (unknown : Dynamic)  { };
        #end
             
        if ((l.tid.ttl > 0) && (!l.ignore)) 
        {
           //loading failed, return request back to the queue
           queue.push({x:l.tid.x,y:l.tid.y,z:l.tid.z,tidx:l.tid.tidx,ttl:l.tid.ttl - 1,priority:l.tid.priority});

           if (enabled == 0) 
              sortQueue();
        }

        processQueue();
    }


    function loaderError(e:IOErrorEvent)
    {

       for (l in loaders)
           if (l.contentLoaderInfo == e.target)
              loaderFailed(l);
    }

    function getTile(x:Int, y:Int, z:Int) : TempTile
    {
       //looking for a tile in the sorted array

       var min:Int = 0;
       var max:Int = tempqueue.length-1;
       var mid:Int;
       var val:Int; var cmp:Int;
       while (min <= max) {
          mid = Math.floor((min + max) / 2);
          
          cmp = (x - tempqueue[mid].x);
          if (cmp == 0) cmp = (y - tempqueue[mid].y);
          if (cmp == 0) cmp = (z - tempqueue[mid].z);

          if (cmp == 0)
             return tempqueue[mid]
          else if (cmp > 0)
             min = mid + 1;
          else
             max = mid - 1;

       }

       return null;
    }

    function insertTile(t:TempTile) 
    {
       //insert TempTile into the sorted array

       var min:Int = 0;
       var max:Int = tempqueue.length-1;
       var mid:Int;
       var val:Int; var cmp:Int;

       while (min <= max) {
          mid = Math.floor((min + max) / 2);

          cmp = (t.x - tempqueue[mid].x);
          if (cmp == 0) cmp = (t.y - tempqueue[mid].y);
          if (cmp == 0) cmp = (t.z - tempqueue[mid].z);
          
          if (cmp > 0)
             min = mid + 1;
          else
             max = mid - 1;

       }

       tempqueue.insert(min, t);
    }

}

