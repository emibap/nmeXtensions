#include <ImageSaver.h>
#import <UIKit/UIKit.h>

namespace imageSaver {
    
	void saveImage(unsigned char *outputData, int w, int h) {
	    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
	    CGContextRef bitmapContext=CGBitmapContextCreate(outputData, w, h, 8, 4*w, colorSpace,  kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
	    CFRelease(colorSpace);
	    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
	    CGContextRelease(bitmapContext);
	
	    UIImage * newimage = [UIImage imageWithCGImage:cgImage];
	    CGImageRelease(cgImage);
	    
	    UIImageWriteToSavedPhotosAlbum(newimage, nil, nil, nil);
    }
}