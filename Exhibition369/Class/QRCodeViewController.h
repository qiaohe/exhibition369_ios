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
@property (nonatomic, retain) IBOutlet NSMutableArray *statusArray;
@property (nonatomic, retain) IBOutlet UILabel        *ApplyStatusLabel;
@property (nonatomic, retain) IBOutlet UITextView     *ApplyStatusTextView;

@end
