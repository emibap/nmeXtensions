/*******************************************************************************
Copyright (c) 2010, Zdenek Vasicek (vasicek AT fit.vutbr.cz)

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

package haxemap.ui;

import flash.display.Shape;
import flash.display.Graphics;
import flash.display.SimpleButton;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;


class UpButton extends CustomButton {

    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) {
        var h:Float = (2*szh/5.0)/2;

        g.beginFill(color);
        g.moveTo(midx-4, midy+h);
        g.lineTo(midx+4, midy+h);
        g.lineTo(midx, midy-h);
        g.endFill();

        if (Std.is(this, RightButton)) { 
           curshape.rotation = 90;
           curshape.x += szh;
        }

        if (Std.is(this,  LeftButton)) { 
           curshape.rotation = 270;
           curshape.y += szh;
        }

        if (Std.is(this, DownButton)) { 
           curshape.rotation = 180;
           curshape.y += szh;
           curshape.x += szw;
        }

    }
}

class RightButton extends UpButton 
{
}

class LeftButton extends UpButton 
{
}

class DownButton extends UpButton 
{
}

class BarButton extends CustomButton 
{

    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) 
    {
        var h:Float = (szh/2.0)/2; 

        g.lineStyle(4, color);
        g.moveTo(midx, midy-h);
        g.lineTo(midx, midy+h);
 
    }

}

class PauseButton extends CustomButton 
{

    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) 
    {
        var h:Float = (szh/2.5)/2; 

        g.lineStyle(2, color);
        g.moveTo(midx-2, midy-h);
        g.lineTo(midx-2, midy+h);
        g.moveTo(midx+2, midy-h);
        g.lineTo(midx+2, midy+h);
 
    }

}



class SaveButton extends CustomButton 
{

    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) 
    {
        var h:Float = (szh/2.0)/2; 

        g.beginFill(color);
        g.moveTo(midx-h, midy-h);
        g.lineTo(midx+h, midy-h);
        g.lineTo(midx+h, midy+h);
        g.lineTo(midx+h-h/2.0, midy+h);
        g.lineTo(midx+h-h/2.0, midy+h-h/2);
        g.lineTo(midx-h+h/2.0, midy+h-h/2);
        g.lineTo(midx-h+h/2.0, midy+h);
        g.lineTo(midx-h, midy+h);
        g.drawRect(midx-h+h/2.0+1, midy+h-h/2+1, h/2, h/2-1);
        g.endFill();
    }

}

class PrintButton extends CustomButton 
{

    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) 
    {
        var h:Float = (szh/1.5)/2; 
        var oy:Float = -3;

        g.beginFill(color);
        g.moveTo(midx-h, midy+oy);
        g.lineTo(midx-h+h/2.0, midy+oy);
        g.lineTo(midx-h+h/2.0, midy+h-h/1.5+oy);
        g.lineTo(midx+h-h/2.0, midy+h-h/1.5+oy);
        g.lineTo(midx+h-h/2.0, midy+oy);
        g.lineTo(midx+h, midy+oy);
        g.lineTo(midx+h, midy+h+oy);
        g.lineTo(midx-h, midy+h+oy);

        g.drawRect(midx-h+h/2.0+1, midy-h/2.5+oy, h/2+1, h/2.5+h/1.5-1);
        g.drawRect(midx-h+h/2.0, midy+h+0.5+oy, h, 2);

        g.endFill();
    }

}

class MaximizeButton extends CustomButton 
{
    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool)
    {
        var h:Float = (szh/3.0)/2; // 1/4 vysky zabira symbol
        g.lineStyle(4, 0x888888);
        g.drawRect(midx-h-1, midy-h-1,2*h+2,2*h+2);

        g.lineStyle(2, color);
        g.drawRect(midx-h-1, midy-h-1,2*h+2,2*h+2);

    }
}

class ZoomInButton extends CustomButton 
{

    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) 
    {
        var h:Float = (szh/4.0)/2; // 1/4 vysky zabira symbol

        g.lineStyle(2, color);
        g.moveTo(midx, midy);
        g.lineTo(midx+h+4, midy+h+4);

        #if flash9
        g.moveTo(midx,midy); //bugfix
        #end
        g.beginFill(0x888888);
        g.drawCircle(midx, midy, 2*h);
        g.endFill();

        if (Std.is(this, SearchButton)) 
           return;

        g.moveTo(midx-h, midy);
        g.lineTo(midx+h, midy);

        if (!Std.is(this, ZoomOutButton)) 
        {
           g.moveTo(midx, midy-h);
           g.lineTo(midx, midy+h);
        }

    }
}

class ZoomOutButton extends ZoomInButton 
{
}


class SearchButton extends ZoomInButton 
{
}

class TextButton extends CustomButton {

    var text:String;

    public function new(text:String = "", width:Int = 45, size:Int = 25, bgColor:Null<Int> = null, bgColorHover:Null<Int> = null, fgColor:Int = 0xEEEEEE)
    {
        this.text = text;
        super(size, bgColor, bgColorHover, fgColor);
        this.szw = width;
        updateShapes();
    }


    override function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) 
    {
        g.clear();

        var tf:flash.text.TextField = new flash.text.TextField();
        tf.textColor = 0xFFFFFF; 
        tf.background = false;
        tf.border = false;
        tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
        var fmt = new flash.text.TextFormat();
        fmt.font = "Arial";
        fmt.size = 11;
        fmt.bold = true;
        tf.defaultTextFormat = fmt;
        tf.text = this.text; 

        var bd:BitmapData = new BitmapData(Std.int(tf.width),Std.int(tf.height), true, 0x00FFFFFF);
        bd.draw(tf);

        g.lineStyle(Math.NaN);
        g.beginBitmapFill(bd, null, false);
        g.drawRect(0, 0, bd.width, bd.height);
        g.endFill();

        if (checked)
        {
           g.lineStyle(2, 0xFFFFFF);
           g.moveTo(0, bd.height+2);
           g.lineTo(bd.width, bd.height+2);
        }
    }
}

class CustomButton extends SimpleButton {

    var fgColor:Int;
    var szw:Float;
    var szh:Float;
    var shint:Shape;
    var curshape:Shape;
    var canupdate:Bool;
    public var hint:String;
    public var checked(default, setChecked):Bool;
    public var onClick:Dynamic;
    public var bgColor(default, setBgColor):Null<Int>;
    public var bgColorHover(default, setBgColorHover):Null<Int>;

    public function new(size:Int = 25, bgColor:Null<Int> = null, bgColorHover:Null<Int> = null, fgColor:Int = 0xEEEEEE)//0x007BC8)
    {
        super();
        this.canupdate = false;
        downState = overState = upState = hitTestState = null;
        this.bgColor = bgColor; 
        this.bgColorHover = bgColorHover; 
        this.fgColor = fgColor;
        this.szw = (size == 0) ? 4 : size;
        this.szh = (size == 0) ? 25 : size;
        this.shint = null;
        this.hint = "";
        this.canupdate = true;
		
        updateShapes();

        useHandCursor  = true;
        onClick        = null;
        checked        = false;

        addEventListener(MouseEvent.CLICK, clicked);
        addEventListener(MouseEvent.MOUSE_OVER, mouseOver);

    }

    function mouseOver(e:MouseEvent) 
    {
        removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, mouseOut);

        if (this.hint == "") return;

        var tf:flash.text.TextField = new flash.text.TextField();
        tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
        tf.text = hint;

        var bd:BitmapData = new BitmapData(Std.int(tf.width),Std.int(tf.height), true, 0x00FFFFFF); //w,h
        bd.draw(tf);

        shint = new Shape();
        shint.graphics.lineStyle(1,0x808080);
        shint.graphics.beginFill(0xFDFECB);
        shint.graphics.drawRect(-2,-2, bd.width+4, bd.height+4);
        shint.graphics.endFill();

        shint.graphics.lineStyle(Math.NaN);
        shint.graphics.beginBitmapFill(bd, null, false);
        shint.graphics.drawRect(0, 0, bd.width, bd.height);
        shint.graphics.endFill();

        var p:flash.geom.Point = localToGlobal(new flash.geom.Point(szw/2, szh+10));
        if (p.x + shint.width > flash.Lib.current.stage.stageWidth) p.x = flash.Lib.current.stage.stageWidth - shint.width;
        if (p.y + shint.height > flash.Lib.current.stage.stageHeight) p.y = flash.Lib.current.stage.stageHeight - shint.height - szh;
        if (p.y < 2) p.y = 2;
        shint.x = p.x; shint.y = p.y;

        flash.Lib.current.stage.addChild(shint);
    }

    function mouseOut(e:MouseEvent) 
    {
        if (shint != null) {
           flash.Lib.current.stage.removeChild(shint);
           shint = null;
        }

        removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
        addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
    }

    function setBgColor(val:Null<Int>) : Null<Int>
    {
        if (val != bgColor) {
           bgColor = val;
           updateShapes();
        }
        return val;
    }

    function setBgColorHover(val:Null<Int>) : Null<Int>
    {
        if (val != bgColorHover) {
           bgColorHover = val;
           updateShapes();
        }
        return val;
    }

    function setChecked(val:Bool) : Bool 
    {
        if (val != checked) {
           checked = val;
           updateShapes();
        }
        return val;
    }

    function updateShapes()
    {
        if (!this.canupdate) return;
        downState      = getShape(bgColorHover, fgColor, true);
        overState      = getShape(checked ? 0xFF8000 : bgColorHover, 0xeeeeee /*fgColor*/);
        overState.filters = [new GlowFilter(0xFFFFFF, 0.75, 5, 5, 2, 2, false, false)];
        upState        = getShape(checked ? 0xFF8000 : bgColor, fgColor);
        hitTestState   = getHitTestShape();
    }

    public function setSize(w:Float, h:Float) 
    {
        szw = w;
        szh = h;
        updateShapes();
    }

    function clicked(event:MouseEvent) {
        
		if (onClick != null) 
           onClick(this);
    }

    function getHitTestShape() {
        var s = new Shape();

        s.graphics.beginFill(0x000000);
        s.graphics.drawRect(0, 0, szw, szh);
        s.graphics.endFill();

        return s;
    }

    function getShape(bgColor:Null<Int>, fgColor:Int, ?down:Bool = false):Shape {
        curshape = new Shape();

        if (bgColor != null)
        {
           curshape.graphics.beginFill(bgColor);
           curshape.graphics.drawRect(0, 0, szw, szh);
           curshape.graphics.endFill();
        }

        var x:Float = szw/2;
        var y:Float = szh/2;

        if (down) { x += 1; y += 1; }

        drawSymbol(curshape.graphics, fgColor, x, y, down);

        return curshape;
    }

    function drawSymbol(g:Graphics, color:Int, midx:Float, midy:Float, down:Bool) {
    }
}
