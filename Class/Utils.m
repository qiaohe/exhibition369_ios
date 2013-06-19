//
//  Utils.m
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "Utils.h"
#import "Constant.h"
#import "SBJsonParser.h"

const int secsPerMin = 60;
const int secsPerHour = secsPerMin * 60;
const int secsPerDay = 24 * secsPerHour;

static NSDateFormatter *dateFormat;

@implementation Utils

+ (NSDictionary *)parseJson:(NSString *)s
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *result = [parser objectWithString:s];
	return result;
}

+ (NSDate *)stringToDate:(NSString *)str
{
    NSDateFormatter *df = [self getDateFormatter];
    [df setDateFormat:DATE_FORMAT];
    return [df dateFromString:str];
}

+ (NSString *)dateToString:(NSDate *)date format:(NSString *)format
{
    if (!date)
    {
        return @"";
    }
    
    NSDateFormatter *df = [self getDateFormatter];
    [df setDateFormat:format];
    return [df stringFromDate:date];
}

+ (NSDateFormatter *)getDateFormatter
{
    if(dateFormat == nil)
    {
        dateFormat = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
        [dateFormat setLocale:enUSPOSIXLocale];
        //[dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return dateFormat;
}

+ (int)getRandomInt:(int)value
{
    return arc4random()%value;
}

+ (NSString *)nilToEmpty:(NSString *)value
{
    if(value == nil)
        return @"";
    else
        return value;
}

+ (NSString *)NullToEmpty:(id)value
{
	return ([value isKindOfClass:[NSNull class]] || value == nil ? @"" : value);
}

+ (NSString *)lowercaseFirstLetter:(NSString *)s
{
    return [s stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
                                      withString:[[s substringToIndex:1] lowercaseString]];
}

+ (int)compareDateString:(NSString *)s1 s2:(NSString *)s2
{
	NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormat setDateFormat:DATE_FORMAT];
	NSDate *d1 = [dateFormat dateFromString:s1];
	NSDate *d2 = [dateFormat dateFromString:s2];
	return [d1 compare:d2];
}

+ (int)compareDate:(NSDate *)d1 d2:(NSDate *)d2
{
    if(d1 == nil && d2 == nil)
    {
        return NSOrderedSame;
    }
    else if(d1 == nil && d2 != nil)
    {
        return NSOrderedAscending;
    }
    else if(d1 != nil && d2 == nil)
    {
        return NSOrderedDescending;
    }
    else
    {
        return [d1 compare:d2];
    }
}
CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect) {
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation =
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x,
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}
@end
