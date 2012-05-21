**Haxe NME VideoPlayer extension**

UNDER CONSTRUCTION ;)

This is a native extension for haxe NME which allows video playback on some targets.
(Currently iOS only)

The current implementation will show a fullscreen video with the default controls.

**Usage**

Reference the extension in your .nmml:
	<include path="path/to/VideoPlayer/Extension" />

Reference the following iOS frameworks in your .nmml:

	<dependency name="UIKit.framework" if="ios" />
	<dependency name="MediaPlayer.framework" if="ios" />
	<dependency name="CoreGraphics.framework" if="ios" />
	<dependency name="QuartzCore.framework" if="ios" />
	
Just call this static Method to use it:
    
	VideoPlayer.showVideo(YOUR_VIDEO_URL);

	Parameters:
	-----------
	url:String - The video URI. It can point to a remote http video or a local file.

	If you plan to use local files, copy all your video assets directly into the exported asseds folder once you've built your project.

**Running the test application**

    cd Project
    nme build VideoPlayerSample.nmml ios
    
    or 
    nme update VideoPlayerSample.nmml ios

**Recompiling the extension**

    cd Extension/project
    haxelib run hxcpp Build.xml
    
    or
	haxelib run hxcpp Build.xml -Diphoneos
	haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
	haxelib run hxcpp Build.xml -Diphonesim
	(depending on your target)


**Known Issues**

Right now you should only allow one device orientation for your project. An exception is thrown if the video viewController is closed using a screen orientation different from the one that was set when the video was called.

**License:**

This extension and example license:

    Unless indicated otherwise, this code was created by Emiliano Angelini and
    provided under a MIT-style license. 
    Copyright (c) Emiliano Angelini. All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.