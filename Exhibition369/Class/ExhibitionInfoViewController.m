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
    self.webView = nil;
    self.myExhibition = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestData];
    self.webView.layer.masksToBounds = YES;
    self.webView.layer.cornerRadius = 6.0;
    self.webView.layer.borderWidth = 1.0;
    self.webView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)requestData
{
    NSString *urlString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/brief.html",[Model sharedModel].selectExhibition.exKey];
    [self sendRequestWith:urlString params:nil method:RequestMethodGET];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        NSData *responseData = [request responseData];
        [self.webView loadData:responseData MIMEType:nil textEncodingName:@"NSUTF8StringEncoding" baseURL:nil];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"此页面不存在" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
