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
import flash.geom.Point;

interface MapService 
{
    var id(default,null):String;
    var zoom_min(default,null):Int;
    var zoom_max(default,null):Int;
    var zoom_def(default,null):Int;
    var tile_size(default,null):Int;
    var invert_x(default,null):Bool;
    var invert_y(default,null):Bool;

    function lonlat2tile(lon:Float, lat:Float, zoom:Int) : TileID;
    function tile2lonlat(t:TileID) : LonLat;
    function lonlat2XY(lon:Float, lat:Float, zoom:Int) : Point;
    function XY2lonlat(x:Float, y:Float, zoom:Int) : LonLat;
    function validZoom(z:Int) : Bool;
    function tile2url(t:TileID) : String;
}

class BaseMapService {

    public var id(default,null):String;
    public var zoom_min(default,null):Int;
    public var zoom_max(default,null):Int;
    public var zoom_def(default,null):Int;
    public var tile_size(default,null):Int;
    public var invert_x(default,null):Bool;
    public var invert_y(default,null):Bool;

    var proxy:Bool;
    var proxy_url:String;

    public function new(id:String, abbrev:String, zoom_min:Int, zoom_max:Int, zoom_def:Int, tile_size:Int=256)
    {
       setInfo(id, abbrev, zoom_min, zoom_max, zoom_def, tile_size);
    } 
  
    function setInfo(id:String, abbrev:String, zoom_min:Int, zoom_max:Int, zoom_def:Int, tile_size:Int=256)
    {
       this.id = id;
       this.zoom_min = zoom_min;
       this.zoom_max = zoom_max;
       this.zoom_def = zoom_def;
       this.tile_size = tile_size;
       this.invert_x = false;
       this.invert_y = false;
       this.proxy = false;

       /*tony*/			
	   #if !cpp
	   if (flash.Lib.current.loaderInfo != null)
	   {
		 //check if the proxy parameter is set
	     var params = flash.Lib.current.loaderInfo.parameters;
		   if ((params != null)  && (params.proxy != null) && (params.proxy != ""))
		   {
			   this.proxy_url = params.proxy;
			   if (this.proxy_url.charAt(proxy_url.length-1) != '/')
				  this.proxy_url += '/';
			   this.proxy_url += abbrev + "/";
			   this.id += " (Proxy)";
			   this.proxy = true;
		   }
	   }
	   #end
    }

    public function validZoom(z:Int) : Bool
    {
       return (((zoom_def + z) >= zoom_min) && ((zoom_def + z) <= zoom_max));
    }

}

class OpenStreetMapService extends BaseMapService, implements MapService
{
    // Details:
    // ---------------------------------------------------------
    //   http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames

    override public function new(default_zoom:Int = 13)
    {
       super("Open Street Map", "osm", 0, 18, default_zoom, 256);
    }

    public inline function lonlat2tile(lon:Float, lat:Float, zoom:Int) : TileID
    {
       var z:Float = Math.pow(2,zoom);
       var lr:Float = lat*Math.PI/180;
       return {x: (Math.floor((lon+180)/360*z)), 
               y: (Math.floor(z*(1-Math.log(Math.tan(lr) + 1/Math.cos(lr))/Math.PI)/2)), 
               z: zoom};
    }

    public inline function lonlat2XY(lon:Float, lat:Float, zoom:Int) : Point
    {
       var z:Float = tile_size * Math.pow(2,zoom);
       var lr:Float = lat*Math.PI/180;
       return new Point((Math.floor(z*(lon+180)/360)), 
                        (Math.floor(z*(1-Math.log(Math.tan(lr) + 1/Math.cos(lr))/Math.PI)/2)));
    }

    public inline function tile2lonlat(t:TileID) : LonLat
    {
       var z = Math.pow(2,t.z);
       var n  = Math.PI-2*Math.PI*t.y/z;  
       return new LonLat(t.x/z*360-180, 180/Math.PI*Math.atan(0.5*(Math.exp(n)-Math.exp(-n))));
    }

    public inline function XY2lonlat(x:Float, y:Float, zoom:Int) : LonLat
    {
       var z = tile_size * Math.pow(2, zoom);
       var n  = Math.PI-2*Math.PI*y/z;  
       return new LonLat(x/z*360-180, 180/Math.PI*Math.atan(0.5*(Math.exp(n)-Math.exp(-n))));
    }

    public function tile2url(t:TileID) : String
    {
       if (!isValid(t)) return "";
 
	   //trace("http://tile.openstreetmap.org/" + (t.z) + "/" + (t.x) + "/" + (t.y) + ".png");
	   
       //if (!proxy)
        //  return "http://tile.openstreetmap.org/" + (t.z) + "/" + (t.x) + "/" + (t.y) + ".png";

		var num = Math.ceil(Math.random() * 4); 
		
	   if (!proxy)
			return "http://otile" + num + ".mqcdn.com/tiles/1.0.0/osm/" + (t.z) + "/" + (t.x) + "/" + (t.y) + ".png";
		  
       return this.proxy_url + (t.z) + "_" + (t.x) + "_" + (t.y);
    }

    function isValid(t:TileID) : Bool
    {
       //check zoom
       if ((t.z < zoom_min) || (t.z > zoom_max)) return false;

       //check bounds
       var z:Float = Math.pow(2, t.z);
       if ((t.x < 0) || (t.x >= z) || (t.y < 0) || (t.y >= z)) return false;

       return true;
    }

}

class BingMapService extends OpenStreetMapService
{

    // Details:
    // ---------------------------------------------------------
    //   http://msdn.microsoft.com/en-us/library/bb545006.aspx

    var hybrid:Bool;

    override public function new(default_zoom:Int = 13, hybrid:Bool = false)
    {
       super();
       this.hybrid = hybrid;
       setInfo("Bink Maps", "bnk", 1, 18, default_zoom, 256);

    }

    override public function tile2url(t:TileID) : String
    {
       if (!isValid(t)) return "";

       if (!proxy)
       {
          var xx:Int = t.x;
          var yy:Int = t.y;
          var  tid:String = "";
          for (i in 0...t.z)
          {
              var q:Int = 0;
              if ((xx & 1) == 1) q += 1;
              if ((yy & 1) == 1) q += 2;
              tid = q + tid;
   
              xx = xx >> 1;
              yy = yy >> 1;
          }
		  
          return "http://tiles.virtualearth.net/tiles/"+(hybrid ? "h" : "r")+tid+".png?g=414&mkt=en-us&shading=hill&n=z";
       }

       return this.proxy_url + (t.z) + "_" + (t.x) + "_" + (t.y);
    }

}

class GoogleMapService extends OpenStreetMapService
{
	
    // Details:
    // ---------------------------------------------------------
    //   http://msdn.microsoft.com/en-us/library/bb545006.aspx

    var hybrid:Bool;

    override public function new(default_zoom:Int = 13, hybrid:Bool = false)
    {
       super();
       this.hybrid = hybrid;
       setInfo("Bink Maps", "bnk", 1, 18, default_zoom, 256);
		
    }

    override public function tile2url(t:TileID) : String
    {
		if (!isValid(t)) return "";
		
		if (!proxy)
			return "http://khm1.google.com/kh/v=109&src=app&x=" + t.x + "&y=" + t.y + "&z=" + t.z + "&s=Galileo.jpg";
		
		return this.proxy_url + (t.z) + "_" + (t.x) + "_" + (t.y);
    }
}
