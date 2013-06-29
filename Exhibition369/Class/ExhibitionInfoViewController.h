//
//  ExhibitionInfoViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Model.h"

@interface ExhibitionInfoViewController : BaseUIViewController

@property (nonatomic, retain) IBOutlet UIWebView       *webView;
@property (nonatomic, retain) Exhibition               *myExhibition;
@property (nonatomic, retain) IBOutlet UIImageView *UnloadImage;

@end
