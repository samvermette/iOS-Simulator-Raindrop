//
//  SVSimulatorRaindrop.m
//  iOS Simulator Raindrop
//
//  Created by Sam Vermette on 31.03.11.
//  Copyright 2011 Sam Vermette. All rights reserved.
//

#import "SVSimulatorRaindrop.h"
#import "SVSimulatorDeviceSizes.h"

@implementation SVSimulatorRaindrop

- (NSString *)pasteboardNameForTriggeredRaindrop {
	
	CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
	
	for(NSDictionary *entry in (__bridge NSArray*)windowList) {
		
		NSString *applicationName = [entry objectForKey:(id)kCGWindowOwnerName];
		
		if(applicationName != NULL && ([applicationName isEqualToString:NSLocalizedString(@"iOS Simulator", nil)])) {
			CGWindowID windowID = [[entry objectForKey:(id)kCGWindowNumber] unsignedIntValue];
			NSLog(@"%@ (%i)", applicationName, windowID);
			
			CGImageRef windowImage = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault);
			CGSize windowSize = CGSizeMake(CGImageGetWidth(windowImage), CGImageGetHeight(windowImage));
			CGRect cropRect = CGRectNull;
            
      NSLog(@"windowSize = %@", NSStringFromSize(windowSize));
			
			if(CGSizeEqualToSize(windowSize, kWindowSizePhone))
				cropRect = kViewRectPhone;
			else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneLandscape))
				cropRect = kViewRectPhoneLandscape;
			else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneRetina))
				cropRect = kViewRectPhoneRetina;
			else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneRetinaLandscape))
				cropRect = kViewRectPhoneRetinaLandscape;
			else if(CGSizeEqualToSize(windowSize, kWindowSizeTablet))
				cropRect = kViewRectTablet;
			else if(CGSizeEqualToSize(windowSize, kWindowSizeTabletLandscape))
				cropRect = kViewRectTabletLandscape;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneRetina50))
        cropRect = kViewRectPhoneRetina50;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneRetina50Landscape))
        cropRect = kViewRectPhoneRetina50Landscape;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneFive))
        cropRect = kViewRectPhoneFive;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneFiveLandscape))
        cropRect = kViewRectPhoneFiveLandscape;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneFive50))
        cropRect = kViewRectPhoneFive50;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneFive50Landscape))
        cropRect = kViewRectPhoneFive50Landscape;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneFive75))
        cropRect = kViewRectPhoneFive75;
      else if(CGSizeEqualToSize(windowSize, kWindowSizePhoneFive75Landscape))
        cropRect = kViewRectPhoneFive75Landscape;
      
        NSLog(@"cropRect = %@", NSStringFromRect(cropRect));
			
			if(!CGRectIsNull(cropRect)) {
				
				NSString *plistPath = [NSString stringWithFormat:@"%@/Library/Preferences/com.apple.screencapture.plist", NSHomeDirectory()];
				NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                NSString *savePath = [plistData valueForKeyPath:@"location"];
                
                if(!savePath) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
                    savePath = [paths objectAtIndex:0];
                }

				NSString *screenshotPath = [NSString stringWithFormat:@"%@/iOS Screenshot %@.png", savePath, [NSDate date]];
				
				NSURL *tempURL = [NSURL fileURLWithPath:screenshotPath];
				CGImageRef croppedImage = CGImageCreateWithImageInRect(windowImage, cropRect);
				CGImageRelease(windowImage);
				
				CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL((__bridge CFURLRef)tempURL, kUTTypePNG, 1, NULL);
				CGImageDestinationAddImage(imageDestination, croppedImage, NULL);
				CGImageDestinationFinalize(imageDestination);
				CGImageRelease(croppedImage);
                
                //NSLog(@"savePath = %@", screenshotPath);
				
				NSData *imageData = [NSData dataWithContentsOfFile:screenshotPath];
				
				NSPasteboard *pasteboard = [NSPasteboard pasteboardWithUniqueName];
				NSPasteboardItem *item = [[NSPasteboardItem alloc] init];
				[item setData:imageData forType:(NSString *)kUTTypePNG];
				[item setString:@"simulator.png" forType:@"public.url-name"];
				[pasteboard writeObjects:[NSArray arrayWithObject:item]];
				
				return [pasteboard name];
			}
		}
	}
	
	return nil;
}

@end
