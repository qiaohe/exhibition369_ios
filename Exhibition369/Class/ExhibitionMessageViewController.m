//
//  ExhibitionMessageViewController.m
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "ExhibitionMessageViewController.h"

@interface ExhibitionMessageViewController ()

@end

@implementation ExhibitionMessageViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
    }
    return self;
}

-(void)dealloc
{
    self.webView = nil;
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
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.borderWidth = 1.0;
    self.view.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
