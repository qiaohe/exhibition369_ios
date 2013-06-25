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
        
        
        theButton = [[[DataButton alloc] initWithFrame:CGRectMake(270, 0, 40, 50)] autorelease];
        theButton.tag = 5;
        [self.contentView addSubview:theButton];
        
        
        theImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 45, 45)];
        theImage.tag = 6;
        [self.contentView addSubview:theImage];
        /*
        bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        bottomLine.frame = CGRectMake(10, 64, 300, 2);
        [self.contentView addSubview:bottomLine];
        
        theTabLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab.png"]];
        theTabLine.frame = CGRectMake(5, 11, 3, 43);
        [self.contentView addSubview:theTabLine];*/
    }
    return self;
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
