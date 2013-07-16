//
//  ExhibitionTableCell.h
//  Exhibition369
//
//  Created by Jack Wang on 6/19/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataButton;

@interface ExhibitionTableCell : UITableViewCell{
    UILabel *theTitle;
    UILabel *theDate;
    UILabel *theAddress;
    UILabel *theOrganizer;
    DataButton *theButton;
    
    UIImageView *theImage;
    UIImageView *selectedBG;
    
}

@property (nonatomic, retain) DataButton *ApplyStatus;
@property (nonatomic, retain) UIImageView *NumOfMessageUnRead;

- (void)setApplyStatusWithString:(NSString*)Status;

- (UIColor *)getColor:(NSString *)stringToConvert;

@end
