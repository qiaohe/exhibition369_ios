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
    ExhibitionMessageView.view.frame = subViewFrame;
    ExhibitionNewsViewController *ExhibitionNewsView = [[[ExhibitionNewsViewController alloc]initWithNibName:@"ExhibitionNewsViewController" bundle:nil]autorelease];
    ExhibitionNewsView.view.tag = 103;
    ExhibitionNewsView.view.frame = subViewFrame;
    ExhibitionNewsView.delegate = self;
    ExhibitionScheduleViewController *ExhibitionScheduleView = [[[ExhibitionScheduleViewController alloc]initWithNibName:@"ExhibitionScheduleViewController" bundle:nil]autorelease];
    ExhibitionScheduleView.view.tag = 104;
    ExhibitionScheduleView.view.frame = subViewFrame;
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
    [self.view addSubview:exhibitionInfoView.view];
    self.titleLabel.text = exhibitionInfoView.title;
    [self setTitleViewToTop];
}

- (void)setTitleViewToTop
{
    NSInteger titleViewIndex = [self.view.subviews indexOfObject:self.titleView];
    NSInteger lastViewIndex = [self.view.subviews count];
    [self.view exchangeSubviewAtIndex:titleViewIndex withSubviewAtIndex:lastViewIndex];
}

- (void)SuperViewPresentViewController:(UIViewController*)viewController
{
    [self presentModalViewController:viewController animated:YES];
}

- (IBAction)ButtonIsPress:(UIButton*)sender
{
    NSInteger selectIndex = sender.tag - 200;
    if (selectIndex == 4) {
        [self presentModalViewController:[self.viewControllers objectAtIndex:selectIndex] animated:YES];
    }else
        [self tabBar:self.tabBar didSelectItem:[self.tabBar.items objectAtIndex:selectIndex]];
}

- (IBAction)PressPhoneButton:(id)sender
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
    NSLog(@"finished\nrequestResponseStr = %@",[request responseString]);
    UIAlertView *alertView = (UIAlertView*)[self.view viewWithTag:301];
    [alertView setMessage:@"申请成功！请关注审批结果"];
}

- (IBAction)JumpToApplyView:(id)sender{
    NSString *status = [Model sharedModel].selectExhibition.status;
    if ([status isEqualToString:@"N"]) {
        [self ApplyViewShowOrDismiss];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您已报名，请在二维码页面查询审核状态" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.delegate = self;
        alertView.tag = 401;
        [alertView show];
        [alertView release];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 401) {
        [self tabBar:self.tabBar didSelectItem:[self.tabBar.items objectAtIndex:4]];
    }
}

- (void)ApplyViewShowOrDismiss
{
    static BOOL showOrDismiss = NO;
    showOrDismiss = showOrDismiss?NO:YES;
    //if (showOrDismiss) {
        
        ApplyViewController *view = [[ApplyViewController alloc]initWithNibName:@"ApplyViewController" bundle:nil];
        view.view.frame = CGRectMake(0, 40, view.view.frame.size.width, view.view.frame.size.height);
        view.delegate = self;
        view.view.tag = 106;
        [self presentModalViewController:view animated:YES];
        /*
        for (UIView * view in self.view.subviews) {
            if (view.tag == self.prevIndex) {
                [view removeFromSuperview];
            }
        }
        self.titleLabel.text = view.title;
        [self.view addSubview:view.view];
        self.prevIndex = view.view.tag;*/
        /*
         ApplyView *viewController = [[ApplyView alloc]initWithFrame:CGRectMake(5, 40, 320 - 10, 355) andDelegate:self];
         viewController.tag = 106;
         for (UIView * view in self.view.subviews) {
         if (view.tag == self.prevIndex) {
         [view removeFromSuperview];
         }
         }
         self.titleLabel.text = viewController.title;
         [self.view addSubview:viewController];
         self.prevIndex = viewController.tag;
    }else{
        [self tabBar:self.tabBar didSelectItem:[self.tabBar.items objectAtIndex:0]];
    }*/
}

- (void) ApplyRequestWithURL:(NSString*)URL Params:(NSMutableDictionary*)dic Method:(RequestMethod)method
{
    [self RequestWithURL:URL Params:dic Method:method];
}

- (void)ApplyViewPressCancleButton
{
    [self ApplyViewShowOrDismiss];
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
