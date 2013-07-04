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
@synthesize ApplyButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_tabBar release];
    [self.titleLabel       release];
    [self.titleView        release];
    [self.titleImageView   release];
    [self.backImageView    release];
    [self.exhibition       release];
    [self.viewControllers  release];
    [self.messageUnReadNum release];
    [self.ApplyButton      release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{

    if (![[Model sharedModel] isConnectionAvailable]) {
        
    }
    if (![[Model sharedModel].selectExhibition.status isEqualToString:@"N"] && ![[Model sharedModel].selectExhibition.status isEqualToString:@"D"]) {
        self.ApplyButton.hidden = YES;
    }else {
        self.ApplyButton.hidden = NO;
    }
}

- (void)updateData
{
    [self ShowMessageUnReadWithNum:[Model sharedModel].selectExhibition.messageUnRead];
    [Model sharedModel].selectExhibition.messageUnRead = 0;
    for (Exhibition * e in [Model sharedModel].appliedExhibitionList){
        if (e.exKey == [Model sharedModel].selectExhibition.exKey) {
            e.messageUnRead = 0;
            [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
        }
    }
    
    CGRect subViewFrame = CGRectMake(0, 40, 320, baseHeight);
    ExhibitionInfoViewController *exhibitionInfoView = [[[ExhibitionInfoViewController alloc]initWithNibName:@"ExhibitionInfoViewController" bundle:nil]autorelease];
    exhibitionInfoView.view.tag = 101;
    exhibitionInfoView.view.frame = subViewFrame;
    
    ExhibitionScheduleViewController *ExhibitionScheduleView = [[[ExhibitionScheduleViewController alloc]initWithNibName:@"ExhibitionScheduleViewController" bundle:nil]autorelease];
    ExhibitionScheduleView.view.tag = 102;
    ExhibitionScheduleView.view.frame = subViewFrame;
    
    ExhibitionNewsViewController *ExhibitionNewsView = [[[ExhibitionNewsViewController alloc]initWithNibName:@"ExhibitionNewsViewController" bundle:nil]autorelease];
    ExhibitionNewsView.view.tag = 103;
    ExhibitionNewsView.view.frame = subViewFrame;
    ExhibitionNewsView.delegate = self;
    
    ExhibitionMessageViewController *ExhibitionMessageView = [[[ExhibitionMessageViewController alloc]initWithNibName:@"ExhibitionMessageViewController" bundle:nil]autorelease];
    ExhibitionMessageView.view.tag = 104;
    ExhibitionMessageView.delegate = self;
    ExhibitionMessageView.view.frame = subViewFrame;
    
    QRCodeViewController *QRCodeView = [[QRCodeViewController alloc]initWithNibName:@"QRCodeViewController" bundle:nil];
    QRCodeView.view.tag = 105;
    QRCodeView.view.frame = subViewFrame;
    
    self.viewControllers = [NSArray arrayWithObjects:exhibitionInfoView,ExhibitionScheduleView,ExhibitionNewsView,ExhibitionMessageView,QRCodeView, nil];
    
    for (int i = 0; i<[self.viewControllers count]; i++) {
        //UIBarButtonItem *buttonItem = [self.tabBar.items objectAtIndex:i];
        //UIViewController *controller = [self.viewControllers objectAtIndex:i];
        //buttonItem.title = controller.title;
    }
    
    self.prevIndex = 101;
    self.prevBtnIndex = 200;
    UIButton *btn = (UIButton*)[self.view viewWithTag:self.prevBtnIndex];
    btn.selected = YES;
    [self.view addSubview:exhibitionInfoView.view];
    self.titleLabel.text = exhibitionInfoView.title;
    //[self setTitleViewToTop];
}

- (void)ShowMessageUnReadWithNum:(NSInteger)num
{
    
    if (num > 0) {
        self.messageUnReadNum.hidden = NO;
        //self.messageUnReadNum.titleLabel.text = [[NSNumber numberWithInteger:num]stringValue];
    }else {
        self.messageUnReadNum.hidden = YES;
    }
}
/*
- (void)setTitleViewToTop
{
    NSInteger titleViewIndex = [self.view.subviews indexOfObject:self.titleView];
    NSInteger lastViewIndex = [self.view.subviews count];
    [self.view exchangeSubviewAtIndex:titleViewIndex withSubviewAtIndex:lastViewIndex];
}
*/
- (void)SuperViewPresentViewController:(UIViewController*)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)PressPhoneButton:(id)sender
{
    NSString *phoneNum = _PHONE_NUM_;// 电话号码
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
                NSString *phoneNum = _PHONE_NUM_;// 电话号码
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
        
         [[Model sharedModel] displayTip:@"您已报名" modal:NO];
    }
    
}

- (void)AppliedExhibition{
    [self tabBar:self.tabBar didSelectItem:[self.viewControllers objectAtIndex:4]];
}

-(void)error:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

-(void)done:(ASIHTTPRequest *)request
{
    UIAlertView *alertView = (UIAlertView*)[self.view viewWithTag:301];
    [alertView setMessage:@"申请成功！请关注审批结果"];
}

- (void)MessageJumpToApplyView
{
    NSString *status = [Model sharedModel].selectExhibition.status;
    if ([status isEqualToString:@"N"] || [status isEqualToString:@"D"]) {
        [self ApplyViewShow];
    }
    else{
        UIViewController *viewController = [self.viewControllers objectAtIndex:4];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}

- (IBAction)JumpToApplyView:(id)sender
{
    NSString *status = [Model sharedModel].selectExhibition.status;
    if ([status isEqualToString:@"N"] || [status isEqualToString:@"D"]) {
        [self ApplyViewShow];
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
    view.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
    view.view.tag = 106;
    view.delegate = self;
    [self presentViewController:view animated:YES completion:nil];
}

- (void) ApplyViewApplySuccess
{
    [self tabBar:self.tabBar didSelectItem:[self.tabBar.items objectAtIndex:4]];
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

- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}

#pragma mark- UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item // called when a new view is selected by the user (but not programatically)
{
    NSInteger index = [tabBar.items indexOfObject:item];
    [self SetButtonHeightLightWithIndex:(index + 200)];
    for (UIView * view in self.view.subviews) {
        if (view.tag == self.prevIndex) {
            [view removeFromSuperview];
        }
    }if (index == 3) {
        [self ShowMessageUnReadWithNum:0];
    }
    UIViewController *viewController = [self.viewControllers objectAtIndex:index];
    [self.view addSubview:viewController.view];
    self.titleLabel.text = viewController.title;
    self.prevIndex = viewController.view.tag;
}

- (void)SetButtonHeightLightWithIndex:(NSInteger)_index
{
    UIButton *btn = (UIButton*)[self.view viewWithTag:_index];
    UIButton *prevBtn = (UIButton*)[self.view viewWithTag:self.prevBtnIndex];
    prevBtn.selected = NO;
    btn.selected     = YES;
    self.prevBtnIndex = _index;
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
    [[Model sharedModel] pushView:[[Model sharedModel] getMainViewController] option:ViewTrasitionEffectMoveRight];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
