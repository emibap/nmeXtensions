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

class LngLat
{
    public var lat: Float;
    public var lng: Float;

    public function new(lng:Float, lat:Float)
    {
       this.lng = lng; 
       this.lat = lat;
    }

    inline public function clone()
    {
       return new LngLat(this.lng, this.lat);
    }

    public function toString():String
    {

       return "[LngLat] lng:" + fmtCoordinate(this.lng) + " lat:" + fmtCoordinate(this.lat);
    }
 
    //convert coordinate to string (format %.6f)
    static public function fmtCoordinate(value:Float) : String
    {
		var valuef:Float = value > 0 ? Math.floor(value) : Math.ceil(value);
       
	   var f:Float = value - valuef;
       var s:String = Std.string(valuef) + ".";
       for (i in 0...6)
       {
           f *= 10.0;
           s += Std.string(Math.floor(f));
           f = f - Math.floor(f);
       }
       return s;
    }

    //distance between two points in meters
    static public function distance(a:LngLat, b:LngLat) : Float 
    {
    	var dlat:Float = (b.lat - a.lat) * Math.PI / 180;
    	var dlon:Float = (b.lng - a.lng) * Math.PI / 180;

        dlat = Math.sin(dlat/2);
        dlon = Math.sin(dlon/2);
    	var a:Float = dlat*dlat + Math.cos(a.lat * Math.PI / 180 ) * Math.cos(b.lat * Math.PI / 180 ) * dlon*dlon;
    	var c:Float = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    	c = 6371000.0 * c; //avg. radius of the earth in meters

    	return c;
    }

}
