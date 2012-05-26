#include <MailSender.h>
#import <UIKit/UIKit.h>
#include <MailComposer.h>

namespace mailSender {
    
	void SendMail (const char *subject, const char *body, bool isHTML, const char *to, const char *cc, const char *bcc, unsigned char *attImg, int w, int h) {
	    
	    // Creating the image attachment (if present)
	    NSData *imgData = NULL;
	    if (attImg != 0) {
	    
		    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
		    
		    CGContextRef bitmapContext=CGBitmapContextCreate(attImg, w, h, 8, 4*w, colorSpace,  kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
		    CFRelease(colorSpace);
		    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
		    CGContextRelease(bitmapContext);
		
		    UIImage * newimage = [UIImage imageWithCGImage:cgImage];
		    CGImageRelease(cgImage);
		    
		    imgData = UIImagePNGRepresentation(newimage);
		    
	    }
	    
	    BOOL bIsHTML = isHTML? YES : NO;
	    
	    MailComposer* mailC = [MailComposer sharedInstance];
	    [mailC showPicker:[NSString stringWithCString:subject encoding:NSUTF8StringEncoding] msgBody:[NSString stringWithCString:body encoding:NSUTF8StringEncoding] msgIsHTML:bIsHTML sndTo:[NSString stringWithCString:to encoding:NSUTF8StringEncoding] sndCC:[NSString stringWithCString:cc encoding:NSUTF8StringEncoding] sndBCC:[NSString stringWithCString:bcc encoding:NSUTF8StringEncoding] attImgData:imgData];
    }
}
