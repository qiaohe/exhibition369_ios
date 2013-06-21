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
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)PressBackButton:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)PressPhoneButton:(id)sender
{
    
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
    NSData *data = [request responseData];
    [self.webView loadData:data MIMEType:nil textEncodingName:@"NSUTF8StringEncoding" baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
