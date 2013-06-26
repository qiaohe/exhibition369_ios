//
//  ExhibitionDetailViewController.m
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "ExhibitionDetailViewController.h"
#import "Model.h"

@interface ExhibitionDetailViewController ()

@end

@implementation ExhibitionDetailViewController

@synthesize titleLabel;
@synthesize titleView;
@synthesize titleImageView;
@synthesize backImageView;
@synthesize exhibition = _exhibition;
@synthesize viewControllers;
@synthesize prevIndex;
@synthesize prevBtnIndex;
@synthesize messageUnReadNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateData
{    
    CGRect subViewFrame = CGRectMake(0, 44, 320, 366);
    ExhibitionInfoViewController *exhibitionInfoView = [[[ExhibitionInfoViewController alloc]initWithNibName:@"ExhibitionInfoViewController" bundle:nil]autorelease];
    exhibitionInfoView.view.tag = 101;
    exhibitionInfoView.view.frame = subViewFrame;
    ExhibitionMessageViewController *ExhibitionMessageView = [[[ExhibitionMessageViewController alloc]initWithNibName:@"ExhibitionMessageViewController" bundle:nil]autorelease];
    ExhibitionMessageView.view.tag = 102;
    ExhibitionMessageView.delegate = self;
    ExhibitionMessageView.view.frame = subViewFrame;
    ExhibitionNewsViewController *ExhibitionNewsView = [[[ExhibitionNewsViewController alloc]initWithNibName:@"ExhibitionNewsViewController" bundle:nil]autorelease];
    ExhibitionNewsView.view.tag = 103;
    ExhibitionNewsView.view.frame = subViewFrame;
    ExhibitionNewsView.delegate = self;
    ExhibitionScheduleViewController *ExhibitionScheduleView = [[[ExhibitionScheduleViewController alloc]initWithNibName:@"ExhibitionScheduleViewController" bundle:nil]autorelease];
    ExhibitionScheduleView.view.tag = 104;
    ExhibitionScheduleView.view.frame = CGRectMake(0, 44, 320, 355);
    QRCodeViewController *QRCodeView = [[QRCodeViewController alloc]initWithNibName:@"QRCodeViewController" bundle:nil];
    QRCodeView.view.tag = 104;
    QRCodeView.view.frame = subViewFrame;
    
    self.viewControllers = [NSArray arrayWithObjects:exhibitionInfoView,ExhibitionMessageView,ExhibitionNewsView,ExhibitionScheduleView,QRCodeView, nil];
    
    for (int i = 0; i<[self.viewControllers count]; i++) {
        UIBarButtonItem *buttonItem = [self.tabBar.items objectAtIndex:i];
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        buttonItem.title = controller.title;
    }
    
    self.prevIndex = 101;
    self.prevBtnIndex = 200;
    UIButton *btn = (UIButton*)[self.view viewWithTag:self.prevBtnIndex];
    btn.selected = YES;
    [self.view addSubview:exhibitionInfoView.view];
    self.titleLabel.text = exhibitionInfoView.title;
    [self setTitleViewToTop];
}

- (void)ShowMessageUnReadWithNum:(NSInteger)num
{
    /*
    if (num > 0) {
        self.messageUnReadNum.hidden = NO;
        self.messageUnReadNum.titleLabel.text = [[NSNumber numberWithInteger:num]stringValue];
    }else {
        self.messageUnReadNum.hidden = YES;
    }*/
}

- (void)setTitleViewToTop
{
    NSInteger titleViewIndex = [self.view.subviews indexOfObject:self.titleView];
    NSInteger lastViewIndex = [self.view.subviews count];
    [self.view exchangeSubviewAtIndex:titleViewIndex withSubviewAtIndex:lastViewIndex];
}

- (void)SuperViewPresentViewController:(UIViewController*)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)ButtonIsPress:(UIButton*)sender
{
    NSInteger selectIndex = sender.tag - 200;
    NSString *status = [Model sharedModel].selectExhibition.status;
    if (selectIndex == 4) {
        [self presentViewController:[self.viewControllers objectAtIndex:selectIndex] animated:YES completion:nil];
    }else if(selectIndex == 1){
        if ([status isEqualToString:@"N"]) {
            [self MessageJumpToApplyView];
        }else{
            UIButton *button = (UIButton*)[self.view viewWithTag:self.prevBtnIndex];
            button.selected = NO;
            sender.selected = YES;
            [self tabBar:self.tabBar didSelectItem:[self.tabBar.items objectAtIndex:selectIndex]];
            self.prevBtnIndex = sender.tag;
        }
    }else{
        UIButton *button = (UIButton*)[self.view viewWithTag:self.prevBtnIndex];
        button.selected = NO;
        sender.selected = YES;
        [self tabBar:self.tabBar didSelectItem:[self.tabBar.items objectAtIndex:selectIndex]];
        self.prevBtnIndex = sender.tag;
    }
}

- (IBAction)PressPhoneButton:(id)sender
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 201) {
        switch (buttonIndex) {
            case 1:{
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
                break;
            }
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) RequestWithURL:(NSString*)URL Params:(NSMutableDictionary*)dic Method:(RequestMethod)method
{
    if ([[Model sharedModel].selectExhibition.status isEqualToString:@"N"] || [[Model sharedModel].selectExhibition.status isEqualToString:@"D"]) {
        [self sendRequestWith:URL params:dic method:method];
        [[Model sharedModel].appliedExhibitionList addObject:[Model sharedModel].selectExhibition];
        [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您已报名，请等候通知" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        //[self sendRequestWith:URL params:dic method:method];
        //[[Model sharedModel].appliedExhibitionList addObject:[Model sharedModel].selectExhibition];
        //[[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
    }
    
}

- (void)AppliedExhibition{
    [self tabBar:self.tabBar didSelectItem:[self.viewControllers objectAtIndex:4]];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = (UIAlertView*)[self.view viewWithTag:301];
    [alertView setMessage:@"申请成功！请关注审批结果"];
}

- (void)MessageJumpToApplyView
{
    NSString *status = [Model sharedModel].selectExhibition.status;
    NSLog(@"status = %@",status);
    if ([status isEqualToString:@"N"] || [status isEqualToString:@"D"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 401;
        if ([status isEqualToString:@"N"]) {
            [alertView setMessage:@"您还未报名，请先报名"];
        }else{
            [alertView setMessage:@"报名未通过，请完善资料后再确定再次报名"];
        }
        [alertView show];
        [alertView release];
    }
    else{
        UIViewController *viewController = [self.viewControllers objectAtIndex:4];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (IBAction)JumpToApplyView:(id)sender
{
    NSString *status = [Model sharedModel].selectExhibition.status;
    NSLog(@"status = %@",status);
    if ([status isEqualToString:@"N"] || [status isEqualToString:@"D"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 401;
        if ([status isEqualToString:@"N"]) {
            [alertView setMessage:@"您还未报名，请先报名"];
        }else{
            [alertView setMessage:@"报名未通过，请完善资料后再确定再次报名"];
        }
        [alertView show];
        [alertView release];
    }
    else{
        UIViewController *viewController = [self.viewControllers objectAtIndex:4];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 401) {
        [self ApplyViewShow];
    }
}

- (void)ApplyViewShow
{
    ApplyViewController *view = [[ApplyViewController alloc]initWithNibName:@"ApplyViewController" bundle:nil];
    view.view.frame = CGRectMake(0, 40, view.view.frame.size.width, view.view.frame.size.height);
    view.view.tag = 106;
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
}

- (void) ApplyViewApplySuccess
{
    UIViewController *viewController = [self.viewControllers objectAtIndex:4];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void) ApplyRequestWithURL:(NSString*)URL Params:(NSMutableDictionary*)dic Method:(RequestMethod)method
{
    [self RequestWithURL:URL Params:dic Method:method];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [_tabBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}

#pragma mark- UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item // called when a new view is selected by the user (but not programatically)
{
    NSInteger index = [tabBar.items indexOfObject:item];
    for (UIView * view in self.view.subviews) {
        if (view.tag == self.prevIndex) {
            [view removeFromSuperview];
        }
    }
    UIViewController *viewController = [self.viewControllers objectAtIndex:index];
    [self.view addSubview:viewController.view];
    self.titleLabel.text = viewController.title;
    self.prevIndex = viewController.view.tag;
}

/* called when user shows or dismisses customize sheet. you can use the 'willEnd' to set up what appears underneath.
 changed is YES if there was some change to which items are visible or which order they appear. If selectedItem is no longer visible,
 it will be set to nil.
 */

- (void)tabBar:(UITabBar *)tabBar willBeginCustomizingItems:(NSArray *)items // called before customize sheet is shown. items is current item list
{
    
}
- (void)tabBar:(UITabBar *)tabBar didBeginCustomizingItems:(NSArray *)items                      // called after customize sheet is shown. items is current item list
{
    
}

- (void)tabBar:(UITabBar *)tabBar willEndCustomizingItems:(NSArray *)items changed:(BOOL)changed // called before customize sheet is hidden. items is new item list
{
    
}

- (void)tabBar:(UITabBar *)tabBar didEndCustomizingItems:(NSArray *)items changed:(BOOL)changed  // called after customize sheet is hidden. items is new item list
{
    
}
- (IBAction)backToMainView:(id)sender {
    [Model sharedModel].mainView = [[[MainViewController alloc] init] autorelease];
    [[Model sharedModel] pushView:[Model sharedModel].mainView option:ViewTrasitionEffectMoveRight];
}
@end
