//
//  AccessDeviceIden.h
//  369HUI
//
//  Created by M J on 13-6-6.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AccessDeviceIden : NSObject{
    
}

@property (nonatomic, retain) NSString *DeviceName;
@property (nonatomic, retain) NSString *SystemName;
@property (nonatomic, retain) NSString *SystemVersion;
@property (nonatomic, assign) CGRect   ApplicationFrame;
@property (nonatomic, assign) CGRect   bounds;

+(AccessDeviceIden*)ShareDevice;


@end
