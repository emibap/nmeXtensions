#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include <hxcpp.h>

#include "VideoPlayer.h"

using namespace videoPlayer;

#ifdef IPHONE

static void videoplayer_show_video (value vidURL) {
    
	showVideo(val_string(vidURL));
    
}
DEFINE_PRIM (videoplayer_show_video, 1);

#endif

extern "C" void videoplayer_main () {
	
	// Here you could do some initialization, if needed
	
}
DEFINE_ENTRY_POINT (videoplayer_main);


extern "C" int videoplayer_register_prims () { return 0; }