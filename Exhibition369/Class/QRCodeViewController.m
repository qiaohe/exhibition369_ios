//
//  QRCodeViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-20.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

@synthesize QRCodeImage;
@synthesize RemindLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"二维码";
    }
    return self;
}

-(void)dealloc
{
    self.QRCodeImage = nil;
    self.RemindLabel = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateData
{
    NSString *urlString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/qrcode/%@.png",[Model sharedModel].selectExhibition.exKey,[Model sharedModel].systemConfig.token];
    NSLog(@"urlStr = %@",urlString);
    [self sendRequestWith:urlString params:nil method:RequestMethodGET];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
