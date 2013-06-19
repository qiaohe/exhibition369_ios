//
//  PlistProxy.h
//  CCBN
//
//  Created by Jack Wang on 3/24/13.
//  Copyright (c) 2013 MobileDaily. All rights reserved.
//


@interface PlistProxy : NSObject
{
    NSString *appliedExhibitionsPlist;
    
    NSMutableDictionary *paths;
	NSMutableDictionary *datas;
	NSMutableDictionary *dataObjects;
}

+ (PlistProxy *)sharedPlistProxy;

- (NSArray *)getAppliedExhibitions;
- (void)updateAppliedExhibitions;
@end
