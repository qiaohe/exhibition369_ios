//
//  ExhibitionManager.h
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exhibitions.h"

@interface ExhibitionManager : NSObject

@property (nonatomic, retain) NSArray   *ExhibitionArray;
@property (nonatomic, assign) int       Size;
@property (nonatomic, assign) double    Last;
@property (nonatomic, retain) NSString  *Name;
@property (nonatomic, retain) NSString  *dateFrom;
@property (nonatomic, retain) NSString  *dateTo;

@end
