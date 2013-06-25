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
    self.titleLabel = nil;
    self.detailLabel = nil;
    self.theImage = nil;
    [super dealloc];
}

- (void)initData
{
    self.backgroundColor = [UIColor clearColor];
    
    theImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.height - 10, self.frame.size.height -10)];
    self.theImage.backgroundColor = [UIColor clearColor];
    
    selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.selectImage setHighlightedImage:[UIImage imageNamed:@"foucs.png"]];
    
    [self addSubview:self.selectImage];
    [self addSubview:self.theImage];

    //titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.theImage.frame.origin.x + self.theImage.frame.size.width + 5, 5, self.frame.size.width - 10 - self.theImage.frame.size.width, (self.frame.size.height - 10)/2)];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.theImage.frame.origin.x + self.theImage.frame.size.width + 5, 5, self.frame.size.width, self.frame.size.height - 10)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    detailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    detailLabel.backgroundColor = [UIColor clearColor];
    self.detailLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:detailLabel];
    
    UIImageView *footImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 48, 320, 2)];
    [footImage setImage:[UIImage imageNamed:@"line.png"]];
    [self addSubview:footImage];
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
