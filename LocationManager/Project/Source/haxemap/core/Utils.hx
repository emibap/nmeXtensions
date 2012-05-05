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

import flash.geom.Point;

#if !cpp
import flash.filters.ColorMatrixFilter;
#end

class Utils
{
    public static function dec2hex(i:Int, digits:Int)  
    {
        var c = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
        var s:String = '';  
        var val = i;
        for (j in 0...digits) 
        {
            s = c[val % 16] + s;
            val = val >> 4;
        }
        return s;
    }

    public static function desaturationFilter(sat:Float = 1.0)
    {
       #if !cpp
		var r = 0.212671;
       var g = 0.715160;
       var b = 0.072169;
       return new ColorMatrixFilter( 
               [/* R */ sat*r+1-sat, sat*g, sat*b, 0, 0, 
                /* G */ sat*r, sat*g+1-sat, sat*b, 0, 0, 
                /* B */  sat*r, sat*g, sat*b+1-sat, 0, 0,
                /* A */ 0, 0, 0, 1, 0
               ]
              );
		#else 
		return null;
		#end
    }

}

typedef LonLat = Point; /* for internal usage */

typedef TileID = {
   var x : Int;
   var y : Int;
   var z : Int;
};

