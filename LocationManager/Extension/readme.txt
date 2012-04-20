=======================
  LocationManager NME extension
=======================

In NME 3.2 and greater, "include.nmml" is the sign for an extension.

This file follows the standard NMML project file format, but paths you
use are relative to the extension directory. You can push assets into
a project, add defines, add haxelib dependencies, include NDLLs, Java
code or other things you may need to boost a developer's project.

If an extension is loaded locally, the "include" tag will work:
	
	<include path="to/my-extension" />
	
Otherwise, it will automatically work if you publish to haxelib:
	
	<haxelib name="my-extension" />


This extension is being referenced using the former, with a local
include. It uses a compiled C++ library to return the language name and
the result of two plus two. Those are both simple examples of calls to
native code.

For iOS, these methods could have been defined in a Test.mm file instead
of a Test.cpp file, but I've chosen to show that the same C++ code could
easily be used across all C++ targets.

For Android, I've also added a Java class to return these same values. 
The sample project uses both C++ and Java to show that both are valid
ways of calling native code on the platform.


include.nmml
---------------

The "include.nmml" file for this sample extension is very simple:
	
	<?xml version="1.0" encoding="utf-8"?>
	<project>
		
		<ndll name="test" />
		<java path="project/android" />
		
	</project>
	
This shows that the extension includes an "NDLL" file, called "test",
as well as Java classes under the path "project/android"

If you look, you'll find that under "project/android" is a "Test.java"
class. This will be included directly into the Android project before
compiling.

When an NDLL is present, NME will look for an "ndll" directory, then 
for a sub-directory depending on the current target platform. These
folders will be empty unless you have compiled the native library
for these platforms. I'll explain this soon.


"project" Folder Structure
---------------------------

The structure under "project" is not a requirement of native extensions.
When you specify an <ndll /> tag, NME will look for the library in an
"ndll" directory, as noted above. How those files get there, or are 
created, is up to you.

I've chosen to mirror the basic structure of NME in how this extension
is composed. NME also uses a "project" folder, which includes the
native code. NME also has a "Build.xml" file, which is used to instruct
HXCPP in how this native C and C++ code should be compiled for each
platform.

NME also uses "ExternalInterface.cpp" as the "glue" between the higher-
level haxe code, and linking into native C/C++ methods. This isn't
because it is the way it has to be done, its just a convention. I
thought that mirroring this structure, here, would help you understand
NME if you ever decide you want to know it better or improve it yourself.


Test.hx
-----------

The root directory of an extension is included as a classpath by default,
similar to how haxelib operates. In NME, you'll find an "nme" directory,
which includes all of the nme.* classes. If you didn't use a package
(which is generally recommended), you would put these files at the root
folder.

My "Test" class does not have a package, so that's why its at the root
level. It uses "Lib.load" in order to gain access to native methods.

If you look, you'll find that each of the native method names it 
references have been defined inside of my "ExternalInterface.cpp" file,
which calls DEFINE_PRIM to expose these methods to haxe.

This interface between haxe and native code is called "CFFI". If you 
like, you can look at "cffi.h", located under "include/hx" inside
HXCPP, to get a better idea of all the methods that are available
to help convert between haxe data types and C/C++ data types.


How to Compile
------------------

The recommended way to compile a library is to use HXCPP, which makes it
simple (better than a makefile, IMO) to compile for multiple toolchains.

This also will mirror the flags and settings used when you compile an 
application using NME, so you'll limit any possible incompatibilies
between your library and a developer's own application.

The basic syntax to use the file is simple:
	
	haxelib run hxcpp Build.xml
	haxelib run hxcpp Build.xml -Ddebug
	haxelib run hxcpp Build.xml -DHXCPP_M64
	haxelib run hxcpp Build.xml -Diphoneos
	haxelib run hxcpp Build.xml -Diphoneos -DHXCPP_ARMV7
	haxelib run hxcpp Build.xml -Diphonesim
	haxelib run hxcpp Build.xml -Dwebos
	haxelib run hxcpp Build.xml -Dandroid
	haxelib run hxcpp Build.xml -Dblackberry
	
If you call HXCPP without any defines, it builds for your current desktop
platform.

If you add "debug", it will compile for debugging instead of release. This
can be added in combination with any other defines. Adding "HXCPP_M64"
specifies that you wish to create a 64-bit build instead of 32-bit, and
is generally only required for doing Linux 64 builds.

The new version of HXCPP supports armv6 and armv7 builds for iOS. You can
specify that you wish to build an armv7 binary by adding the "HXCPP_ARMV7"
define.

Most other platform defines are pretty self-explanatory, building for the
iOS simulator, webOS, Android or BlackBerry.
	
You have a fair level of control inside of the Build.xml file in order
to control which files are used, which special flags, and other things
you may need to build your project.

The command-line tools in NME were originally based from HXCPP's build
tool, so some of the conventions (like "if" and "unless" attributes)
may feel similar.

