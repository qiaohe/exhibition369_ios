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
@synthesize statusArray;
@synthesize ApplyStatusLabel;
@synthesize ApplyStatusTextView;

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
    self.QRCodeImage     = nil;
    self.RemindLabel     = nil;
    self.exhibitionImage = nil;
    self.exhibitionTitle = nil;
    self.statusArray     = nil;
    self.ApplyStatusLabel = nil;
    self.ApplyStatusTextView = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateData
{
    self.statusArray = [NSArray arrayWithObjects:[self.view viewWithTag:101],[self.view viewWithTag:102],[self.view viewWithTag:103],[self.view viewWithTag:104],[self.view viewWithTag:105], nil];
    [self.exhibitionImage setImage:[Model sharedModel].selectExhibition.icon];
    [self.exhibitionTitle setText:[Model sharedModel].selectExhibition.name];
    statusArray = [[NSMutableArray alloc]init];
    for (int i = 101; i < 106; i++) {
        UIImageView *view = (UIImageView*)[self.view viewWithTag:i];
        [statusArray addObject:view];
    }
    NSString *applyStatus = [Model sharedModel].selectExhibition.status;
    [self SetApplyStatus:applyStatus];

    if ([applyStatus isEqualToString:@"N"]) {
        self.RemindLabel.hidden = YES;
        self.QRCodeImage.hidden = YES;
        self.ApplyStatusLabel.hidden = YES;
        self.ApplyStatusTextView.text = @"您还未报名，请先报名";
    }else if ([applyStatus isEqualToString:@"P"]){
        self.RemindLabel.hidden = YES;
        self.QRCodeImage.hidden = YES;
        self.ApplyStatusLabel.hidden = YES;
        self.ApplyStatusTextView.text = @"资料正在审核中，如有疑问请拨打咨询电话";
    }else if ([applyStatus isEqualToString:@"A"]){
        self.RemindLabel.text = @"入会尝试，凭此二维码进入，请妥善保存";
        self.ApplyStatusLabel.text = @"恭喜您，审核通过";
        NSString *urlString = [[Model sharedModel].systemConfig.assetServer stringByAppendingFormat:@"/%@/qrcode/%@.png",[Model sharedModel].selectExhibition.exKey,[Model sharedModel].systemConfig.token];
        [self sendRequestWith:urlString params:nil method:RequestMethodGET];
        self.ApplyStatusTextView.hidden = YES;
    }else if ([applyStatus isEqualToString:@"D"]){
        self.RemindLabel.hidden = YES;
        self.QRCodeImage.hidden = YES;
        self.ApplyStatusLabel.hidden = YES;
        self.ApplyStatusTextView.text = @"非常抱歉!\n由于您信息资料不完整，未能通过审查!\n如有疑问请拨打咨询热线,谢谢!";
    }
}

- (void)SetApplyStatus:(NSString*)Status
{
    if ([Status isEqualToString:@"N"]) {
        for (UIImageView *e in self.statusArray) {
            e.highlighted = NO;
        }
    }else if ([Status isEqualToString:@"P"]) {
        for (int i = 0; i<5; i++) {
            UIImageView *e = [self.statusArray objectAtIndex:i];
            if (i < 3) {
                e.highlighted = YES;
            }
        }
    }else if ([Status isEqualToString:@"A"]) {
        for (UIImageView *e in self.statusArray) {
            e.highlighted = YES;
        }
    }else if ([Status isEqualToString:@"D"]) {
        for (UIImageView *e in self.statusArray) {
            e.highlighted = YES;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    [self.QRCodeImage setImage:[UIImage imageWithData:[request responseData]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
