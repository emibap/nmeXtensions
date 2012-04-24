**NME extensions Repo**

This is the place where I'll put all my NME extensions.

Usually I'll add 2 folders for each extension (based on Joshua Granick's structure):
- Extension: Source and perhaps some compiled ones.
- Project: A sample NME project to quickly test the extension.

**Usage**

Reference the extension in your .nmml:

    <extension name="appleRemote" path="path/to/desired/Extension" />

Sometimes you'll have to also add a reference to some native framework in your .nmml. For instance:

	<dependency name="MessageUI.framework" if="ios" />
	
Find specific APIs for each extension inside their folders.

**Running the test application**

    Go to the Project folder and run a build nme command for your desired nmml file.
    
    For instance: 
    cd Project
    nme build MailSenderSample.nmml ios
    
    or 
    nme update MailSenderSample.nmml ios

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