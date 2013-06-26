//
//  MessagesTableCell.h
//  Exhibition369
//
//  Created by M J on 13-6-25.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesTableCell : UITableViewCell

@property (nonatomic, retain) UIImageView *selectImage;
@property (nonatomic, retain) UILabel     *titleLabel;
@property (nonatomic, retain) UILabel     *contentLabel;

- (UIColor *)getColor:(NSString *)stringToConvert;

@end
