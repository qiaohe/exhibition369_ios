//
//  Message.m
//  CCBN
//
//  Created by Jack Wang on 4/5/13.
//  Copyright (c) 2013 MobileDaily. All rights reserved.
//

#import "Exhibition.h"
#import "Utils.h"
#import "Model.h"

@implementation Exhibition
@synthesize exKey = _exKey;
@synthesize name = _name;
@synthesize date = _date;
@synthesize address = _address;
@synthesize organizer = _organizer;
@synthesize status = _status;
@synthesize createdAt = _createdAt;
@synthesize icon = _icon;
@synthesize logs;

- (id)initWithPData:(NSObject *)data
{
    if ((self = [super init]))
    {
        _exKey = [[(NSDictionary *)data objectForKey:@"exKey"] retain];
        _name = [[(NSDictionary *)data objectForKey:@"name"] retain];
        _date = [[(NSDictionary *)data objectForKey:@"date"] retain];
        _address = [[(NSDictionary *)data objectForKey:@"address"] retain];
        _organizer = [[(NSDictionary *)data objectForKey:@"organizer"] retain];
        _status = [[(NSDictionary *)data objectForKey:@"status"] retain];
        _createdAt = [[(NSDictionary *)data objectForKey:@"createdAt"] retain];//[[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createdAt"] doubleValue]/1000] retain];
        self.logs = @"";
    }
    
    return self;
}

- (void)dealloc
{
    self.exKey = nil;
    self.name = nil;
    self.date = nil;
    self.address = nil;
    self.organizer = nil;
    self.status = nil;
    self.createdAt = nil;
    self.icon = nil;
    self.logs = nil;
    [super dealloc];
}

- (id)initWithJSONData:(NSDictionary *)data
{
    if ((self = [super init]))
    {
        _exKey = [[(NSDictionary *)data objectForKey:@"exKey"] retain];
        _name = [[(NSDictionary *)data objectForKey:@"name"] retain];
        _date = [[(NSDictionary *)data objectForKey:@"date"] retain];
        _address = [[(NSDictionary *)data objectForKey:@"address"] retain];
        _organizer = [[(NSDictionary *)data objectForKey:@"organizer"] retain];
        _status = [[(NSDictionary *)data objectForKey:@"status"] retain];
        //_status = @"N";
        _createdAt = [[(NSDictionary *)data objectForKey:@"createdAt"] retain];//[[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"createdAt"] doubleValue]/1000] retain];
    }
    
    return self;
}

- (NSObject *)getPData {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [Utils NullToEmpty:_exKey], @"exKey",
            [Utils NullToEmpty:_name], @"name",
            [Utils NullToEmpty:_date], @"date",
            [Utils NullToEmpty:_address], @"address",
            [Utils NullToEmpty:_organizer], @"organizer",
            [Utils NullToEmpty:_status], @"status",
            [Utils NullToEmpty:_createdAt], @"createdAt",
            nil];
            
}

- (NSString *)getIconImageURL{
    return [NSString stringWithFormat:@"%@/%@/icon.png", [Model sharedModel].systemConfig.assetServer, _exKey];
}


@end
