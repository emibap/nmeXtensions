**Haxe NME LocationManager extension**

This is a native extension for haxe NME which allows to obtain the location (Latitude / Longitude) of a device.
(Currently iOS only)

**Usage**

Reference the extension in your .nmml:
	<include path="path/to/LocationManager/Extension" />

Reference the following iOS framework in your .nmml:

	<dependency name="CoreLocation.framework" if="ios" />

LocationManager works in the following way:

	After a startUpdatingLocation static call, the locationUpdate process begins and for every location update a callback is called.
	The callback comes with 2 location objects, one for the new location and another for the previous one.

	The process can be stopped by using the stopUpdatingLocation() static method. And if there's an error It will be notified by another callback.

Just call this static Methods to use it:
    
	LocationManager.startUpdatingLocation(locationUpdateCB:Dynamic, finishedUpdatingCB:Dynamic, errorCB:Dynamic)

	Parameters:
	-----------
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
	haxelib run hxcpp Build.xml -Diphoneos
	haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
	haxelib run hxcpp Build.xml -Diphonesim
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
The sample code also uses the [haxemaps][2] library (see license information in the relevant
files).

**IMPORTANT**
If you use the sample code, dont't expect it to have the same functionality than a commercial GPS or Apple's Maps App.
This code simply returns location updates and marks them a the map. For a more accurate usage of the Location API you should read something like [this][3].

[1]: http://developer.apple.com/library/ios/#samplecode/LocateMe/Introduction/Intro.html
[2]: http://code.google.com/p/haxemaps/
[3]: http://stackoverflow.com/questions/1081219/optimizing-cllocationmanager-corelocation-to-retrieve-data-points-faster-on-the