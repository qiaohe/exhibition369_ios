//
//  MessagesTableCell.m
//  Exhibition369
//
//  Created by M J on 13-6-25.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "MessagesTableCell.h"

@implementation MessagesTableCell

@synthesize selectImage;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize backGroundImages;
@synthesize isExpand;
@synthesize CellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.CellHeight = 70.0f;
        [self initData];
    }
    return self;
}

- (void)dealloc
{
    [self.selectImage release];
    [self.titleLabel  release];
    [self.contentLabel release];
    [self.backGroundImages release];
    [super dealloc];
}

- (void)initData
{
    [self addObserver:self
           forKeyPath:@"CellHeight"
              options:NSKeyValueObservingOptionOld
                     |NSKeyValueObservingOptionNew context:nil];

    self.backgroundColor = [UIColor clearColor];
    self.textLabel.highlightedTextColor = [UIColor clearColor];
    
    backGroundImages = [[UIImageView alloc]init];
    [backGroundImages setHighlightedImage:[UIImage imageNamed:@"beijing.png"]];
    [self addSubview:backGroundImages];
    
    selectImage = [[UIImageView alloc]init];
    [self.selectImage setImage:[UIImage imageNamed:@"xinxikuang.png"]];
    [self.selectImage setHighlightedImage:[UIImage imageNamed:@"xinxikuang.png"]];
    [self addSubview:self.selectImage];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 300, 20)];
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    self.contentLabel.textColor = [UIColor darkGrayColor];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentLabel];
    
    [self ChangeCellHeightWithNum:[NSNumber numberWithFloat:-1]];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    CGFloat changeNum = self.CellHeight - 70.0f;
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height + changeNum);
    self.backGroundImages.frame = CGRectMake(0, 0, 320, self.CellHeight);
    self.selectImage.frame = CGRectMake(5, 5, 310, self.CellHeight - 10);
}

- (void)ChangeCellHeightWithNum:(NSNumber*)num
{
    //UIView setAnimation
    CGFloat number = [num floatValue];
    if (number <= 0) {
        self.titleLabel.frame = CGRectMake(10, 30, 300, 25);
        self.backGroundImages.frame = CGRectMake(0, 0, 320, 70);
        self.selectImage.frame = CGRectMake(5, 5, 310, 60);
    }else{
        self.titleLabel.frame = CGRectMake(10, 35, 300, 25 + number);
        self.backGroundImages.frame = CGRectMake(0, 0, 320, 70 + number);
        self.selectImage.frame = CGRectMake(5, 5, 310, 60 + number);
    }
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
