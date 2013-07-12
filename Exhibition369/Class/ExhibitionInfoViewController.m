//
//  ExhibitionInfoViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ExhibitionInfoViewController.h"

@interface ExhibitionInfoViewController ()

@end

@implementation ExhibitionInfoViewController

@synthesize webView;
@synthesize myExhibition;
@synthesize UnloadImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"展会简介";
    }
    return self;
}

-(void)dealloc
{
    [self.webView      release];
    [self.myExhibition release];
    [self.UnloadImage  release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    if ([[Model sharedModel] isConnectionAvailable]) {
        [self requestData];
    }else{
        //[[Model sharedModel] displayTip:@"未连接网络" modal:NO];
        self.UnloadImage.hidden = NO;
    }
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    //self.view.frame = CGRectMake(0, 40, 320, baseHeight);
    [super viewWillAppear:YES];
    /*
    if ([[Model sharedModel] isConnectionAvailable]) {
        [self requestData];
    }else{
        //[[Model sharedModel] displayTip:@"未连接网络" modal:NO];
        self.UnloadImage.hidden = NO;
    }*/
}

- (void)ExhibitionInfoShow:(BOOL)CanShow
{
    self.UnloadImage.hidden = CanShow;
}

- (void)requestData
{
    NSString *urlString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/brief.html",[Model sharedModel].selectExhibition.exKey];
    [self sendRequestWith:urlString params:nil method:RequestMethodGET];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self ExhibitionInfoShow:NO];
    [[Model sharedModel] displayTip:@"请求失败" modal:NO];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        NSData *responseData = [request responseData];
        [self ExhibitionInfoShow:YES];
        [self.webView loadData:responseData MIMEType:nil textEncodingName:@"NSUTF8StringEncoding" baseURL:nil];
    }else {
        [self ExhibitionInfoShow:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
