//
//  SystemConfiguration.m
//  Exhibition369
//
//  Created by Jack Wang on 6/18/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "SystemConfig.h"
#import "Utils.h"

@implementation SystemConfig
@synthesize assetServer = _assetServer;
@synthesize tel = _tel;
@synthesize token = _token;
@synthesize upgrade = _upgrade;
@synthesize upgradeNote = _upgradeNote;

- (id)initWithJSONData:(NSDictionary *)data
{
    if ((self = [super init]))
    {
        _assetServer = [[(NSDictionary *)data objectForKey:@"assetServer"] retain];
        _tel = [[(NSDictionary *)data objectForKey:@"tel"] retain];
        _token = [[(NSDictionary *)data objectForKey:@"token"] retain];
        _upgrade = [[(NSDictionary *)data objectForKey:@"upgrade"] retain];
        _upgradeNote = [[(NSDictionary *)data objectForKey:@"upgradeNote"] retain];
    }
    
    return self;
}
@end
