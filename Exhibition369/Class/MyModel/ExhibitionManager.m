//
//  ExhibitionManager.m
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "ExhibitionManager.h"

@implementation ExhibitionManager

@synthesize ExhibitionArray;
@synthesize Size;
@synthesize Last;
@synthesize Name;
@synthesize dateFrom;
@synthesize dateTo;

-(void)dealloc
{
    self.ExhibitionArray = nil;
    self.Name            = nil;
    self.dateFrom        = nil;
    self.dateTo          = nil;
    [super dealloc];
}

@end
