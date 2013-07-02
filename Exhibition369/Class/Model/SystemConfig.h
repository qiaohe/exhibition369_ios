//
//  SystemConfiguration.h
//  Exhibition369
//
//  Created by Jack Wang on 6/18/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "IData.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface SystemConfig : IData
@property (nonatomic, retain) NSString *assetServer;
@property (nonatomic, retain) NSString *tel;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *upgrade;
@property (nonatomic, retain) NSString *upgradeNote;

@end
