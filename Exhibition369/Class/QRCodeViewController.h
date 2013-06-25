//
//  QRCodeViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-20.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Model.h"

@interface QRCodeViewController : BaseUIViewController

@property (nonatomic, retain) IBOutlet UIImageView    *QRCodeImage;
@property (nonatomic, retain) IBOutlet UILabel        *RemindLabel;
@property (nonatomic, retain) IBOutlet UIImageView    *exhibitionImage;
@property (nonatomic, retain) IBOutlet UILabel        *exhibitionTitle;
@property (nonatomic, retain) IBOutlet UILabel        *exhibitionDate;
@property (nonatomic, retain) IBOutlet UILabel        *exhibitionAddress;
@property (nonatomic, retain) IBOutlet UILabel        *exhibitionOrganizer;
@property (nonatomic, retain) IBOutlet UILabel        *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel        *dateLabel;

- (IBAction)ReturnBtnPress:(id)sender;
- (IBAction)CallPhoneBtnPress:(id)sender;

@end
