//
//  ExhibitionScheduleViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ExhibitionScheduleViewController.h"

@interface ExhibitionScheduleViewController ()

@end

@implementation ExhibitionScheduleViewController

@synthesize webView;
@synthesize myExhibition;
@synthesize UnloadImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"展会日程";
    }
    return self;
}

- (void)dealloc
{
    [self.webView      release];
    [self.myExhibition release];
    [self.UnloadImage  release];
    [super dealloc];
}

- (IBAction)BackView:(id)sender
{
    [Model sharedModel].mainView = [[[MainViewController alloc] init] autorelease];

    [[Model sharedModel] pushView:[Model sharedModel].mainView option:ViewTrasitionEffectMoveRight];
}

- (IBAction)JumpToApplyView:(id)sender{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[Model sharedModel] isConnectionAvailable]) {
        [self requestData];
    }else{
        self.UnloadImage.hidden = NO;
    }
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)requestData
{
    [self sendRequestWith:[[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/schedule.html",[Model sharedModel].selectExhibition.exKey] params:nil method:RequestMethodGET];
}

- (void)error:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
    [[Model sharedModel] displayTip:@"请求失败" modal:NO];
}

-(void)done:(ASIHTTPRequest *)request
{
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        NSData *responseData = [request responseData];
        [self.webView loadData:responseData MIMEType:nil textEncodingName:@"NSUTF8StringEncoding" baseURL:nil];
    }else {
        [[Model sharedModel] displayTip:@"此页面不存在" modal:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
