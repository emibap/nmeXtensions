**Haxe NME LocationManager extension**

This is a native extension for haxe NME which allows to obtain the location (Latitude / Longitude) of a device.
(Currently iOS only)

**Usage**

Reference the extension in your .nmml:
	<include path="path/to/LocationManager/Extension" />

Reference the following iOS framework in your .nmml:

	<dependency name="CoreLocation.framework" if="ios" />

LocationManager works in the following way:

	After a startUpdatingLocation static call, the locationUpdate process begins and for every location update a callback is called, until a timeout is reached.
	The duration of the process can be specified in the call.
	There's also the possibility to stop the locationUpdate process by using the stopUpdatingLocation() static method.

Just call this static Methods to use it:
    
	LocationManager.startUpdatingLocation(totalTimer:Int = 30, locationUpdateCB:Dynamic, finishedUpdatingCB:Dynamic, errorCB:Dynamic)

	Parameters:
	-----------
	totalTimer:Int - The desired time in seconds for the location
	locationUpdateCB:Dynamic - A callback for each location update. Has 2 Float parameters for latitude and longitude.
	finishedUpdatingCB:Dynamic - A callback that notifies when the location update has finished. Has a status String parameter.
	errorCB:Dynamic - A callback that reports an error. Has a status String parameter.

	LocationManager.stopUpdatingLocation();

**Running the test application**

    cd Project
    nme build LocationManagerSample.nmml ios
    
    or 
    nme update LocationManagerSample.nmml ios

	For the flash target a mailto: URL call is being used.

**Recompiling the extension**

    cd Extension/project
    haxelib run hxcpp Build.xml
    
    or
    
	haxelib run hxcpp Build.xml -DHXCPP_M64
	haxelib run hxcpp Build.xml -Diphoneos
	haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
	haxelib run hxcpp Build.xml -Diphonesim
	haxelib run hxcpp Build.xml -Dwebos
	haxelib run hxcpp Build.xml -Dandroid
	haxelib run hxcpp Build.xml -Dblackberry
	(depending on your target)
    

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

The extension includes a copy of some classes from Apple's [LocateMe sample][1] (see license information in the relevant
files).

[1]: http://developer.apple.com/library/ios/#samplecode/LocateMe/Introduction/Intro.html