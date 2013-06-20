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

@synthesize navigationBar;
@synthesize navigationItem;
@synthesize leftBarButtonItem;
@synthesize rightBarButtonItem;
@synthesize exhibition = _exhibition;
@synthesize viewControllers;

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
    [self updateData];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateData
{
    ExhibitionInfoViewController *exhibitionInfoView = [[[ExhibitionInfoViewController alloc]initWithNibName:@"ExhibitionInfoViewController" bundle:nil]autorelease];
    ExhibitionMessageViewController *ExhibitionMessageView = [[[ExhibitionMessageViewController alloc]initWithNibName:@"ExhibitionMessageViewController" bundle:nil]autorelease];
    ExhibitionNewsViewController *ExhibitionNewsView = [[[ExhibitionNewsViewController alloc]initWithNibName:@"ExhibitionNewsViewController" bundle:nil]autorelease];
    ExhibitionScheduleViewController *ExhibitionScheduleView = [[[ExhibitionScheduleViewController alloc]initWithNibName:@"ExhibitionScheduleViewController" bundle:nil]autorelease];
    QRCodeViewController *QRCodeView = [[QRCodeViewController alloc]initWithNibName:@"QRCodeViewController" bundle:nil];
    
    self.viewControllers = [NSArray arrayWithObjects:exhibitionInfoView,ExhibitionMessageView,ExhibitionNewsView,ExhibitionScheduleView,QRCodeView, nil];
    
    for (int i = 0; i<[self.viewControllers count]; i++) {
        UIBarButtonItem *buttonItem = [self.tabBar.items objectAtIndex:i];
        UIViewController *controller = [self.viewControllers objectAtIndex:i];
        buttonItem.title = controller.title;
    }
        
    //self.view = exhibitionInfoView.view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) RequestWithURL:(NSString*)URL Params:(NSMutableDictionary*)dic Method:(RequestMethod)method
{
    [Model sharedModel].selectExhibition.status = @"P";
    [self sendRequestWith:URL params:dic method:method];
    [[[Model sharedModel] appliedExhibitionList] addObject:[Model sharedModel].selectExhibition];
    [[PlistProxy sharedPlistProxy] updateAppliedExhibitions];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"failed");
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"finished");
    
}

- (IBAction)JumpToApplyView:(id)sender{
    ApplyView *viewController = [[ApplyView alloc]initWithFrame:CGRectMake(10, 44 + 10 + 60, 320 - 20, 365 - 60) andDelegate:self];
    [self.view addSubview:viewController];
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
    NSLog(@"item = %d",[tabBar.items indexOfObject:item]);
    UIViewController *viewController = [self.viewControllers objectAtIndex:index];
    [self presentViewController:viewController animated:YES completion:nil];
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
