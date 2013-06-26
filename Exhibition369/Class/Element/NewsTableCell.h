//
//  NewsTableCell.h
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableCell : UITableViewCell

@property (nonatomic, retain) UILabel     *titleLabel;
@property (nonatomic, retain) UILabel     *detailLabel;
@property (nonatomic, retain) UIImageView *theImage;
@property (nonatomic, retain) UIImageView *selectImage;

- (UIColor *)getColor:(NSString *)stringToConvert;

@end
