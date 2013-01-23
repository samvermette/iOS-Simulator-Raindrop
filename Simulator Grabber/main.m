//
//  main.m
//  Simulator Grabber
//
//  Created by Sam Vermette on 22.01.13.
//
//

#import <Foundation/Foundation.h>
#import "SVSimulatorDeviceSizes.h"
#import "SVSimulatorRaindrop.h"
#import <Cocoa/Cocoa.h>
#import <CoreGraphics/CoreGraphics.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        SVSimulatorRaindrop *simulatorRaindrop = [[SVSimulatorRaindrop alloc] init];
        [simulatorRaindrop pasteboardNameForTriggeredRaindrop];
    }
    return 0;
}

