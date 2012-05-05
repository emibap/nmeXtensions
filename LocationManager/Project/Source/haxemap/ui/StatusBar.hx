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
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
import flash.events.TimerEvent;
import haxemap.ui.Component;

class StatusBar extends Component 
{
    var text:TextField;
    var timer:Timer;

    public function new()
    {
    	var format = new TextFormat();
        format.font = "Arial";        
        format.size = 12;

        text = new TextField();
	text.defaultTextFormat = format;
        text.selectable = false;
        text.border = false;
        text.background = false; 
        text.textColor = 0x444444;
        text.autoSize = flash.text.TextFieldAutoSize.LEFT;
        text.text = '';
        text.x = 2;
        text.x = 2;
        this.addChild(text);

        timer = new Timer(2000, 1);
	timer.addEventListener(TimerEvent.TIMER, timeOut);

        super();
    }
 
    public function clear()
    {
        text.text = '';
    }
      
    public function setText(s:String)
    {
        text.text = s;

        if (timer.running)
           timer.stop();
        timer.start();
    }  

    function timeOut(e:flash.events.Event)
    {
        clear();
    }

    override function onResize(w:Float, h:Float)
    {
        graphics.clear();
        graphics.beginFill(0xE0E0E0);
        graphics.drawRect(0,0,w, h);
        graphics.endFill();
    }

}
