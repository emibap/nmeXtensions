/*
     File: MailComposer.m
 Abstract: 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "MailComposer.h"

@implementation MailComposer
//@synthesize message;

static MailComposer *sharedInstance = nil;

+ (MailComposer *)sharedInstance
{
	if (sharedInstance == nil)
	{
		sharedInstance = [[MailComposer alloc] init];
	}
	
	NSLog(@"get sharedInstance");
	
	return sharedInstance;
}

-(void)showPicker:(NSString *)subject msgBody:(NSString *)body msgIsHTML:(BOOL)isHTML sndTo:(NSString *)to sndCC:(NSString *)cc sndBCC:(NSString *)bcc attImgData:(NSData *)imgData
{
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet:subject msgBody:body msgIsHTML:isHTML sndTo:to sndCC:cc sndBCC:bcc attImgData:imgData];
		}
		else
		{
			[self launchMailAppOnDevice];
		}
	}
	else
	{
		[self launchMailAppOnDevice];
	}
}


#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet:(NSString *)subject msgBody:(NSString *)body msgIsHTML:(BOOL)isHTML sndTo:(NSString *)to sndCC:(NSString *)cc sndBCC:(NSString *)bcc attImgData:(NSData *)imgData
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:subject];
	
	// Set up recipients
	if ([to length] > 0){
		NSArray *toRecipients = [to componentsSeparatedByString:@","];
		[picker setToRecipients:toRecipients];
	}
	if ([cc length] > 0){
		NSArray *ccRecipients = [cc componentsSeparatedByString:@","];
		[picker setCcRecipients:ccRecipients];
	}
	if ([bcc length] > 0){
		NSArray *bccRecipients = [bcc componentsSeparatedByString:@","];
		[picker setBccRecipients:bccRecipients];
	}

	// Fill out the email body text
	[picker setMessageBody:body isHTML:isHTML];
	
	// Attach an image to the email (if present)
	if (imgData != NULL) {
		[picker addAttachmentData:imgData mimeType:@"image/png" fileName:@"route"];
	}

	id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
	[rootVC presentModalViewController:picker animated:YES];
	
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
	[rootVC dismissModalViewControllerAnimated:YES];
	NSLog(@"didFinishWithResult");
	controller.mailComposeDelegate = nil;
	//[controller release];
	[sharedInstance release];
	rootVC = nil;
	sharedInstance = nil;
	
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	//TODO...
	NSLog(@"launchMailAppOnDevice");
	
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


#pragma mark -
#pragma mark Unload views

- (void)viewDidUnload 
{
	NSLog(@"viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc 
{
	NSLog(@"dealloc");
	[super dealloc];
}

@end
