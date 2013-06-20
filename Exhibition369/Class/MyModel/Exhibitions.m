//
//  Exhibitions.m
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "Exhibitions.h"

@implementation Exhibitions

@synthesize PWD;
@synthesize EXKey;
@synthesize Token;
@synthesize Icon;
@synthesize Name;
@synthesize DateFrom;
@synthesize DateTo;
@synthesize Address;
@synthesize Organizer;
@synthesize Brief;
@synthesize Schedule;
@synthesize ExhibitionNewsList;
@synthesize ExhibitionMessageList;

- (void) dealloc
{
    self.PWD                    = nil;
    self.EXKey                  = nil;
    self.Token                  = nil;
    self.Icon                   = nil;
    self.Name                   = nil;
    self.DateFrom               = nil;
    self.DateTo                 = nil;
    self.Address                = nil;
    self.Organizer              = nil;
    self.Brief                  = nil;
    self.Schedule               = nil;
    self.ExhibitionNewsList     = nil;
    self.ExhibitionMessageList  = nil;
    [super dealloc];
}

@end
