//
//  Utils.h
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

@interface Utils : NSObject
+ (NSDictionary *)parseJson:(NSString *)s;
+ (NSDate *)stringToDate:(NSString *)str;
+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format;
+ (NSDateFormatter *)getDateFormatter;
+ (int)getRandomInt:(int)value;
+ (NSString *)nilToEmpty:(NSString *)value;
+ (NSString *)NullToEmpty:(id)value;
+ (NSString *)lowercaseFirstLetter:(NSString *)s;
+ (int)compareDateString:(NSString *)s1 s2:(NSString *)s2;
+ (int)compareDate:(NSDate *)d1 d2:(NSDate *)d2;
CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect);
@end