//
//  Exhibitions.h
//  369HUI
//
//  Created by M J on 13-6-13.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitionsNews.h"
#import "Message.h"

@interface Exhibitions : NSObject

@property (nonatomic, retain) NSString *PWD;
@property (nonatomic, retain) NSString *EXKey;
@property (nonatomic, retain) NSString *Token;
@property (nonatomic, retain) NSString *Icon;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *DateFrom;
@property (nonatomic, retain) NSString *DateTo;
@property (nonatomic, retain) NSString *Address;
@property (nonatomic, retain) NSString *Organizer;
@property (nonatomic, retain) NSString *Brief;
@property (nonatomic, retain) NSString *Schedule;
@property (nonatomic, retain) NSArray  *ExhibitionNewsList;
@property (nonatomic, retain) NSArray  *ExhibitionMessageList;

@end
