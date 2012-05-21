#include <VideoPlayer.h>
//#include <MyMovieViewController.h>

#import "MediaPlayer/MPMoviePlayerViewController.h"

namespace videoPlayer {
    
    void showVideo(const char* vidURL) {
	    NSString *vidStr = [NSString stringWithCString:vidURL encoding:NSUTF8StringEncoding];
	    MPMoviePlayerViewController *player;
	    
    	if([vidStr rangeOfString:@"http"].length > 0) {
	    
	    	player = [[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:vidStr]] autorelease];
    	} else {
	    	NSArray *nameAndExt = [vidStr componentsSeparatedByString:@"."];
	        NSString *fileURIStr = [[NSBundle mainBundle] pathForResource:[nameAndExt objectAtIndex:0] ofType:[nameAndExt objectAtIndex:1]];
            player = [[[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:fileURIStr]] autorelease];
    	}
	    
	    id rootVC = [[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0] nextResponder];
        [rootVC presentMoviePlayerViewControllerAnimated:player];
    }
    
    
}