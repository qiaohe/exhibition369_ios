//
//  Message.h
//  CCBN
//
//  Created by Jack Wang on 4/5/13.
//  Copyright (c) 2013 MobileDaily. All rights reserved.
//

#import "IData.h"

@interface Exhibition : IData
@property (nonatomic, retain) NSString *exKey;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *organizer;
//是否已报名，Y 已报名，N 未报名
@property (nonatomic, retain) NSString *applied;
//审核状态，N 未报名(Not Applied)，P 审核中，A 审核通过，D 未通过
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *createdAt;
@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSString *logs;
@property (nonatomic, assign) NSInteger messageUnRead;
@property (nonatomic, retain) NSString *iconPath;

- (NSString *)getIconImageURL;

- (NSString *)description;
@end