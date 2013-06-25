//
//  NewsDetailViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-21.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController

@synthesize webView;
@synthesize aNew;
@synthesize title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = self.aNew.Title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.aNew.Title;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateData];
}

- (IBAction)PressBackButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)updateData
{
    NSString *urlString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/news/%@.html",[Model sharedModel].selectExhibition.exKey,aNew.NewsKey];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    [request startAsynchronous];
    [request release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseString = %@",[request responseStatusMessage]);
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
