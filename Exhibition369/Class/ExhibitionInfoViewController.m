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
    [self requestData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)requestData
{
    
    [self sendRequestWith:[[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/brief.html",self.myExhibition.exKey] params:nil method:RequestMethodGET];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    NSString *responseStr = [request responseString];
    [self.webView loadHTMLString:responseStr baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
