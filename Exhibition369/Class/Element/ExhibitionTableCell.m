//
//  ExhibitionTableCell.m
//  Exhibition369
//
//  Created by Jack Wang on 6/19/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "ExhibitionTableCell.h"
#import "DataButton.h"

@implementation ExhibitionTableCell

@synthesize ApplyStatus;
@synthesize NumOfMessageUnRead;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
		self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        selectedBG = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 60)];
        [selectedBG setImage:[UIImage imageNamed:@"xinxikuang.png"]];
        [selectedBG setHighlightedImage:[UIImage imageNamed:@"anxiaxinxikuang.png"]];
        [self.contentView addSubview:selectedBG];
        //[self setSelectedBackgroundView:selectedBG];
		
		theTitle = [[[UILabel alloc] initWithFrame:CGRectMake(75, 11, 220, 13)] autorelease];
        theTitle.minimumFontSize = 13;
        theTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        theTitle.backgroundColor = [UIColor clearColor];
		theTitle.tag = 1;
		[self.contentView addSubview:theTitle];
        
        theDate = [[[UILabel alloc] initWithFrame:CGRectMake(75, 25, 220, 12)] autorelease];
        theDate.minimumFontSize = 11;
        theDate.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        theDate.backgroundColor = [UIColor clearColor];
        theDate.textColor = [UIColor darkGrayColor];
        theDate.tag = 2;
        [self.contentView addSubview:theDate];
        
        theAddress = [[[UILabel alloc] initWithFrame:CGRectMake(75, 37, 220, 12)] autorelease];
        theAddress.minimumFontSize = 11;
        theAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        theAddress.backgroundColor = [UIColor clearColor];
        theAddress.textColor = [UIColor darkGrayColor];
        theAddress.tag = 3;
        [self.contentView addSubview:theAddress];
        
        theOrganizer = [[[UILabel alloc] initWithFrame:CGRectMake(75, 49, 220, 12)] autorelease];
        theOrganizer.minimumFontSize = 11;
        theOrganizer.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        theOrganizer.backgroundColor = [UIColor clearColor];
        theOrganizer.textColor = [UIColor darkGrayColor];
        theOrganizer.tag = 4;
        [self.contentView addSubview:theOrganizer];
        
        
        theButton = [[[DataButton alloc] initWithFrame:CGRectMake(270, 4, 40, 50)] autorelease];
        theButton.tag = 5;
        theButton.hidden = YES;
        [self.contentView addSubview:theButton];
        
        
        theImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 45, 45)];
        theImage.tag = 6;
        [self.contentView addSubview:theImage];
        
        NumOfMessageUnRead = [[UIImageView alloc]initWithFrame:CGRectMake(45, 3, 25, 25)];
        self.NumOfMessageUnRead.hidden = YES;
        [self.NumOfMessageUnRead setImage:[UIImage imageNamed:@"new message.png"]];
        [self.contentView addSubview:self.NumOfMessageUnRead];
        
    }
    return self;
}

- (void)setApplyStatusWithString:(NSString*)Status{
    if ([Status isEqualToString:@"N"]) {
        
    }else if ([Status isEqualToString:@"P"]) {
        if (!self.ApplyStatus) {
            self.ApplyStatus = [[UIImageView alloc]init];
        }
        self.ApplyStatus.frame = CGRectMake(270, 26, 40, 18);
        [self.ApplyStatus setImage:[UIImage imageNamed:@"shenhezhong.png"]];
        [self addSubview:self.ApplyStatus];
    }else if ([Status isEqualToString:@"A"]) {
        if (!self.ApplyStatus) {
            self.ApplyStatus = [[UIImageView alloc]init];
        }
        self.ApplyStatus.frame = CGRectMake(263, 7, 50, 50);
        [self.ApplyStatus setImage:[UIImage imageNamed:@"tonguo.png"]];
        [self addSubview:self.ApplyStatus];
    }else if ([Status isEqualToString:@"D"]) {
        if (!self.ApplyStatus) {
            self.ApplyStatus = [[UIImageView alloc]init];
        }
        self.ApplyStatus.frame = CGRectMake(265, 26, 40, 18);
        [self.ApplyStatus setImage:[UIImage imageNamed:@"weitongguo.png"]];
        [self addSubview:self.ApplyStatus];
    }else{
        
    }
}

-(void)dealloc
{
    [theTitle     release];
    [theDate      release];
    [theAddress   release];
    [theOrganizer release];
    [theButton    release];
    [theImage     release];
    [selectedBG   release];
    self.ApplyStatus = nil;
    self.NumOfMessageUnRead = nil;
    [super dealloc];
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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    theButton.highlighted = NO;
    selectedBG.highlighted = highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    theButton.selected = NO;
    selectedBG.highlighted = selected;
    // If you don't set highlighted to NO in this method,
    // for some reason it'll be highlighed while the
    // table cell selection animates out
    theButton.highlighted = NO;
}

@end
