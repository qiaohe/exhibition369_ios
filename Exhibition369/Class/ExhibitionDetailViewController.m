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
@synthesize exhibition = _exhibition;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
