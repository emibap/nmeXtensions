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

import haxemap.ui.Component;
import haxemap.ui.Button;
import flash.text.TextField;

class ToolBar extends Component 
{
    var ofsx: Float;
    var spacing: Float;
    var tf: TextField;

    public function new(leftmargin:Float = 10, spacing:Float = 15)
    {
        super();

        this.spacing = spacing;
        this.ofsx = leftmargin;

        tf = new TextField();
        tf.y = 5;
        tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
        tf.text = "";
  
        var fmt = new flash.text.TextFormat();
        fmt.font="Arial";
        fmt.size=12;
        fmt.color = 0xFFFFFF;
        tf.defaultTextFormat = fmt;

        addChild(tf);

    }
 
    public function addButton(btn:CustomButton, hint:String = "", onClick:CustomButton->Void = null, space:Int = 0) : CustomButton
    {
        var sz = getSize();

        btn.x = this.ofsx;
        btn.y = 2;
        btn.hint = hint;
        btn.onClick = onClick;
        addChild(btn);
 
        this.ofsx += btn.width + this.spacing + space;

        return btn;
    }

    public function addTextField(width:Int = 100, text:String = "", label:String = "", space:Int = 0) : TextField
    {
        var sz = getSize();
          
        if (label != "")
        {
           var tf = new TextField();
           tf.y = 5;
           tf.x = this.ofsx;
           tf.autoSize = flash.text.TextFieldAutoSize.LEFT;
 
           var fmt = new flash.text.TextFormat();
           fmt.font="Arial";
           fmt.size=12;
           fmt.color = 0xFFFFFF;
           tf.defaultTextFormat = fmt;
           tf.text = label;

           addChild(tf);

           this.ofsx += tf.width + 5;

        }

        var tf = new TextField();
        tf.x = this.ofsx;
        tf.y = 5;
        tf.width = width;
        tf.height = sz.height - 10;
        tf.autoSize = flash.text.TextFieldAutoSize.NONE;
        tf.border = false;
        tf.background = true;
        tf.backgroundColor = 0xFFFFFF;
        tf.multiline = false;
        tf.type = flash.text.TextFieldType.INPUT;
        #if flash
		tf.mouseWheelEnabled = false;
		#end
		
        var fmt = new flash.text.TextFormat();
        fmt.font="Arial";
        fmt.size=12;
        fmt.color = 0x000000;
        tf.defaultTextFormat = fmt;
        tf.text = text;

        addChild(tf);
        this.ofsx += width + this.spacing + space;

        return tf;
    }

    public function addSeparator(size:Int = 10)
    {
        ofsx += size;
    }

    public function setText(text:String)
    {
        var sz = getSize();

        tf.text = text;
        tf.x = sz.width - tf.width - 10;
    }

    override function onResize(w:Float, h:Float)
    {
        graphics.clear();
        graphics.beginFill(0x000000, 0.5);
        graphics.drawRect(0,0, w, h);
        graphics.endFill();

        tf.x = w - tf.width - 10;
    }

}
