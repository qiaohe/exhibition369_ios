//
//  Message.m
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize exKey;
@synthesize messageTitle;
@synthesize messageDate;
@synthesize messageState;
@synthesize MsgKey;
@synthesize Content;



- (void)dealloc
{
    self.exKey        = nil;
    self.messageTitle = nil;
    self.messageDate  = nil;
    self.MsgKey       = nil;
    self.Content      = nil;
    [super dealloc];
}

@end
