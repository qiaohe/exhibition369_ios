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
    self.selectImage = nil;
    [super dealloc];
}

- (void)initData
{
    theImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.height - 10, self.frame.size.height -10)];
    [self addSubview:self.theImage];
    
    selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.selectImage];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.theImage.frame.origin.x + self.theImage.frame.size.width + 5, 5, self.frame.size.width - 10 - self.theImage.frame.size.width, (self.frame.size.height - 10)/2)];
    [self addSubview:self.titleLabel];
    
    detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height, titleLabel.frame.size.width, titleLabel.frame.size.height)];
    [self addSubview:detailLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
