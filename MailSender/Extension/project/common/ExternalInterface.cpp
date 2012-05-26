#ifndef IPHONE
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "MailSender.h"
//#include <stdio.h>

using namespace mailSender;
#ifdef IPHONE
value mailsender_send_mail (value *arg,int count) {

   enum { aSubject, aBody, aIsHTML, aTo, aCC, aBCC, aAttImg, aImgW, aImgH };
    
    if (!val_is_null(arg[aAttImg])) {
    	buffer imgBuf = val_to_buffer(arg[aAttImg]);
    	unsigned char *img_str = (unsigned char *)buffer_data(imgBuf);
	    SendMail(val_string (arg[aSubject]), val_string (arg[aBody]), val_bool (arg[aIsHTML]), val_string (arg[aTo]), val_string (arg[aCC]), val_string(arg[aBCC]), img_str, val_int(arg[aImgW]), val_int(arg[aImgH]));
    } else {
	    SendMail(val_string (arg[aSubject]), val_string (arg[aBody]), val_bool (arg[aIsHTML]), val_string (arg[aTo]), val_string (arg[aCC]), val_string(arg[aBCC]), 0, 0, 0);
    }
    
	
	return alloc_null();
}
DEFINE_PRIM_MULT (mailsender_send_mail);
#endif

extern "C" void mailsender_main () {
	
	// Here you could do some initialization, if needed
	
}
DEFINE_ENTRY_POINT (mailsender_main);


extern "C" int mailsender_register_prims () { return 0; }