//
//  NewsDetailViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-21.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Model.h"

@interface NewsDetailViewController : BaseUIViewController<ASIHTTPRequestDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) ExhibitionsNews    *aNew;
@property (nonatomic, retain) IBOutlet UILabel   *titleLabel;

- (IBAction)PressBackButton:(id)sender;

@end
