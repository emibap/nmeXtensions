#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "ImageSaver.h"
#include <stdio.h>

using namespace imageSaver;

#ifdef IPHONE


static void imagesaver_save_image (value img, value w, value h) {
    buffer imgBuf = val_to_buffer(img);
    
    unsigned char *img_str = (unsigned char *)buffer_data(imgBuf);
    
	saveImage(img_str, val_int(w), val_int(h));
    
}
DEFINE_PRIM (imagesaver_save_image, 3);

#endif


extern "C" void imagesaver_main () {
	
	// Here you could do some initialization, if needed
	
}
DEFINE_ENTRY_POINT (imagesaver_main);


extern "C" int imagesaver_register_prims () { return 0; }