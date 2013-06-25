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
@synthesize exhibitionImage;
@synthesize exhibitionTitle;
@synthesize exhibitionDate;
@synthesize exhibitionAddress;
@synthesize exhibitionOrganizer;
@synthesize addressLabel;
@synthesize dateLabel;

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
    self.QRCodeImage         = nil;
    self.RemindLabel         = nil;
    self.exhibitionImage     = nil;
    self.exhibitionTitle     = nil;
    self.exhibitionDate      = nil;
    self.exhibitionAddress   = nil;
    self.exhibitionOrganizer = nil;
    self.addressLabel        = nil;
    self.dateLabel           = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view.backgroundColor = [UIColor clearColor];*/
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateData
{
    Exhibition *e = [Model sharedModel].selectExhibition;

    [self.exhibitionImage setImage:e.icon];
    [self.exhibitionTitle setText:e.name];
    [self.exhibitionDate setText:e.date];
    [self.exhibitionAddress setText:e.address];
    [self.exhibitionOrganizer setText:e.organizer];
    
    [self.addressLabel setText:e.address];
    [self.dateLabel setText:e.date];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    NSString *urlString = [ServerURL stringByAppendingFormat:@"/%@/qrcode/%@.png",[Model sharedModel].selectExhibition.exKey,[Model sharedModel].systemConfig.token];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (IBAction)ReturnBtnPress:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)CallPhoneBtnPress:(id)sender
{
    NSString *phoneNum = @"10086";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    UIWebView *phoneCallWebView = nil;
    
    if (!phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [phoneCallWebView release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");

    NSLog(@"responseString = %@",[request responseStatusMessage]);
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        NSData *responseData = [request responseData];
        [self.QRCodeImage setImage:[UIImage imageWithData:responseData]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您还未报名" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
