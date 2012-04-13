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
//#ifdef IPHONE
static void mailsender_send_html_mail (value subject, value body, value to, value cc, value bcc) {
    SendHTMLMail(val_string (subject), val_string (body), val_string (to), val_string (cc), val_string (bcc));
	
}
DEFINE_PRIM (mailsender_send_html_mail, 5);

static void mailsender_send_plain_mail (value subject, value body, value to, value cc, value bcc) {
    SendHTMLMail(val_string (subject), val_string (body), val_string (to), val_string (cc), val_string (bcc));
	
}
DEFINE_PRIM (mailsender_send_plain_mail, 5);
//#endif

extern "C" void mailsender_main () {
	
	// Here you could do some initialization, if needed
	
}
DEFINE_ENTRY_POINT (mailsender_main);


extern "C" int mailsender_register_prims () { return 0; }