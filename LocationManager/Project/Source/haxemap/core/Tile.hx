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
import flash.display.Bitmap;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class Tile extends Sprite
{
    #if TILE_DBG
    var t:TextField;
    #end

    var size:Int;
    var valid:Bool;
    public var tx(default, settx):Int;
    public var ty(default, setty):Int;
    public var tidx(default, null):Int;
    public var image(default, null):Bitmap;

    public var rtidx:Int; //right neighbour tidx
    public var ltidx:Int; //left neighbour tidx
    public var ttidx:Int; //top neighbour tidx
    public var btidx:Int; //bottom neighbour tidx

    override public function new(tidx:Int, size:Int = 256, x:Int = 0, y:Int = 0)
    {
        super();

        #if TILE_DBG
        var s:Sprite = new Sprite();
        s.graphics.lineStyle(2, (tidx == 0) ? 0xFF0000 : 0x008000);
        s.graphics.moveTo(0,0);
        s.graphics.lineTo(size,size);
        s.graphics.moveTo(size,0);
        s.graphics.lineTo(0,size);
        s.graphics.moveTo(size-1,0);
        s.graphics.lineTo(size-1,size);
        s.graphics.moveTo(0,size-1);
        s.graphics.lineTo(size,size-1);
        addChild(s);

        t = new TextField();
        t.autoSize = TextFieldAutoSize.LEFT;
        t.mouseEnabled = false;
        addChild(t);
        #end
         
        this.tidx = tidx;
        this.rtidx = -1; 
        this.ltidx = -1;
        this.ttidx = -1;
        this.btidx = -1;

        this.tx = x;
        this.ty = y;
        this.size = size;
        this.image = null;
        this.valid = false;
        mouseEnabled = false;

        update();
    }
 
    /*============================================================================================== 
      PUBLIC methods
     *==============================================================================================*/
    public function assignImage(image:Bitmap) 
    {
        graphics.clear();

        if (this.image != null) 
        {
           removeChild(this.image);
           this.image = null;
		}   
		
		if (image != null)
		{
		   this.image = image;
           this.image.smoothing = true;
		   
		   addChildAt(this.image, 0);
        }
        else 
        {
           graphics.lineStyle(2, 0xF0F0F0);
           graphics.drawCircle(size/2,size/2, 10);
        }
		
        this.valid = (this.image != null); 
    }

    //returns True iff the tile waits for an image
    public function needImage():Bool
    {
        return !this.valid;
    }

    //tile is being loaded
    public function waitForImage()
    {
    }

    public function invalidate()
    {
        this.valid = false;
    }

    /*============================================================================================== 
      PRIVATE methods
     *==============================================================================================*/
    function update()
    {
        #if TILE_DBG
        t.text = "("+tx+","+ty+")";
        t.x = (size - t.width)/2;
        t.y = (size - t.height)/2;
        #end
    }


    function settx(val:Int) : Int 
    {
        if (val != tx) 
        {
           tx = val;
           update();
           assignImage(null);
        }
        return val;  
    }

    function setty(val:Int) : Int 
    {
        if (val != ty) 
        {
           ty = val;
           update();
           assignImage(null);
        }
        return val;  
    }

}
