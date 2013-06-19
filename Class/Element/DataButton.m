//
//  DataButton.m
//  ChatClient
//
//  Created by Jack Wang on 6/8/13.
//
//

#import "DataButton.h"

@implementation DataButton
@synthesize data;

- (id)initWithFrame:(CGRect)frame data:(NSObject *)inObject
{
    self = [super initWithFrame:frame];
    if (self) {
        data = inObject;
    }
    return self;
}

@end
