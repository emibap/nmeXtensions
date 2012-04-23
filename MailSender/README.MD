**Haxe NME MailSender extension**

This is a native extension for haxe NME which allows to call a native mail window.
(Currently iOS only)

**Usage**

Reference the extension in your .nmml:

    <extension name="appleRemote" path="path/to/mailSender/Extension" />

Reference the following iOS framework in your .nmml:

	<dependency name="MessageUI.framework" if="ios" />

Add a listener in your code:

    Just call this static Method:
    
    MailSender.sendMail("MailSender sendMail sample", "Howdy, partner\n", false, "youremail@gmail.com", "youremail@gmail.com", "youremail@gmail.com");
	
	Parameters:
	-----------
	Subject:String
	Body:String
	isHTML:Boolean
	to:String
	cc:String
	bcc:String


**Running the test application**

    cd Project
    nme build MailSenderSample.nmml ios
    
    or 
    nme update MailSenderSample.nmml ios

	For the flash target a mailto: URL call is being used.

**Recompiling the extension**

    cd Extension/project
    haxelib run hxcpp Build.xml

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

The extension includes a copy of some classes from Apple's [MailComposer sample][1] (see license information in the relevant
files).

[1]: http://developer.apple.com/library/ios/#samplecode/MailComposer/Introduction/Intro.html