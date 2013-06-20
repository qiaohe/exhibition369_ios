//
//  AccessDeviceIden.m
//  369HUI
//
//  Created by M J on 13-6-6.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "AccessDeviceIden.h"

@implementation AccessDeviceIden

@synthesize DeviceName;
@synthesize SystemName;
@synthesize SystemVersion;
@synthesize ApplicationFrame;
@synthesize bounds;

+(AccessDeviceIden*)ShareDevice{
    static AccessDeviceIden *ShareDevice;
    @synchronized(self){
        if (!ShareDevice) {
            ShareDevice = [[AccessDeviceIden alloc]init];
        }
        return ShareDevice;
    }
}

-(void)dealloc
{
    self.DeviceName    = nil;
    self.SystemName    = nil;
    self.SystemVersion = nil;
    [super          dealloc];
}

@end
