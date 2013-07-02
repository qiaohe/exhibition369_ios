//
//  MessagesTableCell.h
//  Exhibition369
//
//  Created by M J on 13-6-25.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>

#define _CHANGE_HEIGHT_ @"ChangeHeight"

@interface MessagesTableCell : UITableViewCell

@property (nonatomic, retain) UIImageView *selectImage;
@property (nonatomic, retain) UILabel     *titleLabel;
@property (nonatomic, retain) UILabel     *contentLabel;
@property (nonatomic, retain) UIImageView *backGroundImages;
@property (nonatomic, assign) BOOL        isExpand;
@property (nonatomic, assign) CGFloat     CellHeight;

- (UIColor *)getColor:(NSString *)stringToConvert;
- (void)ChangeCellHeightWithNum:(NSNumber*)num;

@end
