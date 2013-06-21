//
//  ExhibitionsNews.m
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "ExhibitionsNews.h"

@implementation ExhibitionsNews

@synthesize NewsKey;
@synthesize Icon;
@synthesize Title;
@synthesize Content;
@synthesize exKey;

- (id)initWithEXKey:(NSString*)_exKey
{
    if (self = [super init]) {
        self.exKey = _exKey;
    }
    return self;
}

- (void)dealloc
{
    self.NewsKey = nil;
    self.Icon    = nil;
    self.Title   = nil;
    self.Content = nil;
    self.exKey   = nil;
    [super dealloc];
}

@end
