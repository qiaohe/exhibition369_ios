//
//  NewsTableCell.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "NewsTableCell.h"

@implementation NewsTableCell

@synthesize titleLabel;
@synthesize detailLabel;
@synthesize theImage;
@synthesize selectImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)dealloc
{
    [self.titleLabel release];
    [self.detailLabel release];
    [self.theImage release];
    [self.selectImage release];
    [super dealloc];
}

- (void)initData
{
    self.backgroundColor = [UIColor clearColor];
    
    self.textLabel.highlightedTextColor = [UIColor clearColor];
    
    UIImageView *backGroundImage = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)]autorelease];
    [backGroundImage setHighlightedImage:[UIImage imageNamed:@"beijing.png"]];
    [self addSubview:backGroundImage];
    
    theImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 45, 45)];
    self.theImage.backgroundColor = [UIColor clearColor];
    
    selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 60)];
    [self.selectImage setImage:[UIImage imageNamed:@"xinxikuang.png"]];
    [self.selectImage setHighlightedImage:[UIImage imageNamed:@"anxiaxinxikuang.png"]];
    
    [self addSubview:self.selectImage];
    [self addSubview:self.theImage];

    //titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.theImage.frame.origin.x + self.theImage.frame.size.width + 5, 5, self.frame.size.width - 10 - self.theImage.frame.size.width, (self.frame.size.height - 10)/2)];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.theImage.frame.origin.x + self.theImage.frame.size.width + 5, 10, 320 - (self.theImage.frame.origin.x + self.theImage.frame.size.width + 5) - 10, 30)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, 30, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    detailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:detailLabel];
}


- (UIColor *)getColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touch began");
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //self.selectImage.highlighted = selected;
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}


@end
