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
    UIImageView *bottomLine;
}

@end
