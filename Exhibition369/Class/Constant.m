//
//  Constant.m
//  Tachosil
//
//  Created by Jack Wang on 6/25/12.
//  Copyright (c) 2012 HoverState. All rights reserved.
//

#import "Constant.h"

@implementation Constant

BOOL const DEBUGING = NO;

float const ANIMATION_DURATION = 0.5;
float const OPEN_BOOK_ANIMATION_DURATION = 1.0;

BOOL const HTTP_AUTHENTICATION = NO;
NSString *const HTTP_AUTHENTICATION_USER = @"user";
NSString *const HTTP_AUTHENTICATION_PASS = @"pass";

NSString *const DATE_FORMAT = @"yyyy-MM-dd'T'HH:mm:ss";

//是否已报名，Y 已报名，N 未报名
NSString *const EXHIBITION_APPLIED_Y = @"Y";
NSString *const EXHIBITION_APPLIED_N = @"N";

//审核状态，N 未报名(Not Applied)，P 审核中，A 审核通过，D 未通过
NSString *const EXHIBITION_STATUS_N = @"N";
NSString *const EXHIBITION_STATUS_P = @"P";
NSString *const EXHIBITION_STATUS_A = @"A";
NSString *const EXHIBITION_STATUS_D = @"D";

int const PAGE_LOAD_ITEM_SIZE = 5;

@end
