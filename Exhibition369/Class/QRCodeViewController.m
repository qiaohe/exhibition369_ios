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
@synthesize exhibitionTextView;
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
    self.exhibitionTextView  = nil;
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
    self.addressLabel.textColor = [self getColor:@"344e78"];
    self.dateLabel.textColor = [self getColor:@"344e78"];
    
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
    NSString *status = [Model sharedModel].selectExhibition.status;
    if ([status isEqualToString:@"D"] || [status isEqualToString:@"N"]) {
        self.QRCodeImage.hidden = YES;
        self.exhibitionTextView.hidden = NO;
        [self.exhibitionTextView setText:@"您的审核未通过\n如需再次申请\n请整理好资料后再次报名"];
    }else if ([status isEqualToString:@"P"]){
        self.QRCodeImage.hidden = YES;
        self.exhibitionTextView.hidden = NO;
        [self.exhibitionTextView setText:@"您的资料正在审核中\n请关注消息通知"];
    }else{
        self.QRCodeImage.hidden = NO;
        self.exhibitionTextView.hidden = YES;
        NSString *urlString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/qrcode/%@.png",[Model sharedModel].selectExhibition.exKey,[Model sharedModel].systemConfig.token];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.delegate = self;
        [request startAsynchronous];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (IBAction)ReturnBtnPress:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)CallPhoneBtnPress:(id)sender
{
    NSString *phoneNum = @"10086";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    UIWebView *phoneCallWebView = nil;
    
    if (!phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] init];
        phoneCallWebView.delegate = self;
    }
    
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    [self.view addSubview:phoneCallWebView];
    [phoneCallWebView release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    
    NSString *requestResult = [request responseStatusMessage];
    NSRange range = [requestResult rangeOfString:@"404 Not Found"];
    if (range.location == NSNotFound) {
        NSData *responseData = [request responseData];
        [self.QRCodeImage setImage:[UIImage imageWithData:responseData]];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请求失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
