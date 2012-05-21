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

This extension and example license (UNLICENSE):

	This is free and unencumbered software released into the public domain.
	
	Anyone is free to copy, modify, publish, use, compile, sell, or
	distribute this software, either in source code form or as a compiled
	binary, for any purpose, commercial or non-commercial, and by any
	means.
	
	In jurisdictions that recognize copyright laws, the author or authors
	of this software dedicate any and all copyright interest in the
	software to the public domain. We make this dedication for the benefit
	of the public at large and to the detriment of our heirs and
	successors. We intend this dedication to be an overt act of
	relinquishment in perpetuity of all present and future rights to this
	software under copyright law.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
	OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
	ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
	
	For more information, please refer to <http://unlicense.org/>