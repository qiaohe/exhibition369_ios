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
        
        selectedBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foucs.png"]];
        selectedBG.frame = CGRectMake(5, 0, 310, 65);
        selectedBG.hidden = YES;
        [self.contentView addSubview:selectedBG];
        //[self setSelectedBackgroundView:selectedBG];
		
		theTitle = [[[UILabel alloc] initWithFrame:CGRectMake(75, 5, 220, 13)] autorelease];
        theTitle.minimumFontSize = 13;
        theTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        theTitle.backgroundColor = [UIColor clearColor];
		theTitle.tag = 1;
		[self.contentView addSubview:theTitle];
        
        theDate = [[[UILabel alloc] initWithFrame:CGRectMake(75, 22, 220, 12)] autorelease];
        theDate.minimumFontSize = 11;
        theDate.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        theDate.backgroundColor = [UIColor clearColor];
        theDate.tag = 2;
        [self.contentView addSubview:theDate];
        
        theAddress = [[[UILabel alloc] initWithFrame:CGRectMake(75, 34, 220, 12)] autorelease];
        theAddress.minimumFontSize = 11;
        theAddress.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        theAddress.backgroundColor = [UIColor clearColor];
        theAddress.tag = 3;
        [self.contentView addSubview:theAddress];
        
        theOrganizer = [[[UILabel alloc] initWithFrame:CGRectMake(75, 46, 220, 12)] autorelease];
        theOrganizer.minimumFontSize = 11;
        theOrganizer.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        theOrganizer.backgroundColor = [UIColor clearColor];
        theOrganizer.tag = 4;
        [self.contentView addSubview:theOrganizer];
        
        
        theButton = [[[DataButton alloc] initWithFrame:CGRectMake(279, 13, 40, 40)] autorelease];
        theButton.tag = 5;
        [self.contentView addSubview:theButton];
        
        
        theImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 50, 50)];
        theImage.tag = 6;
        [self.contentView addSubview:theImage];
        
        bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        bottomLine.frame = CGRectMake(10, 64, 300, 2);
        [self.contentView addSubview:bottomLine];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    theButton.highlighted = NO;
    selectedBG.hidden = !highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    theButton.selected = NO;
    selectedBG.hidden = !selected;
    // If you don't set highlighted to NO in this method,
    // for some reason it'll be highlighed while the
    // table cell selection animates out
    theButton.highlighted = NO;
}

@end
