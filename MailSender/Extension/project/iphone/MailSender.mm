#include <MailSender.h>
#import <UIKit/UIKit.h>
#include <MailComposer.h>

namespace mailSender {
    
	void SendHTMLMail (const char *subject, const char *body, const char *to, const char *cc, const char *bcc) {
	    
	    MailComposer* mailC = [MailComposer sharedInstance];
	    [mailC showPicker:[NSString stringWithCString:subject encoding:NSUTF8StringEncoding] msgBody:[NSString stringWithCString:body encoding:NSUTF8StringEncoding] msgIsHTML:YES sndTo:[NSString stringWithCString:to encoding:NSUTF8StringEncoding] sndCC:[NSString stringWithCString:cc encoding:NSUTF8StringEncoding] sndBCC:[NSString stringWithCString:bcc encoding:NSUTF8StringEncoding]];
    }
    
	void SendPlainMail (const char *subject, const char *body, const char *to, const char *cc, const char *bcc) {
	    
	    MailComposer* mailC = [MailComposer sharedInstance];
	    [mailC showPicker:[NSString stringWithCString:subject encoding:NSUTF8StringEncoding] msgBody:[NSString stringWithCString:body encoding:NSUTF8StringEncoding] msgIsHTML:NO sndTo:[NSString stringWithCString:to encoding:NSUTF8StringEncoding] sndCC:[NSString stringWithCString:cc encoding:NSUTF8StringEncoding] sndBCC:[NSString stringWithCString:bcc encoding:NSUTF8StringEncoding]];
    }
}
