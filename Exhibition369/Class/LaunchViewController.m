//
//  LaunchViewController.m
//  Exhibition369
//
//  Created by Jack Wang on 6/19/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import "LaunchViewController.h"
#import "MainViewController.h"
#import "Model.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (id)init
{
	if ((self = [super init]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(launchApp:)
                                                     name:NotificationAppConfigRecived
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(failedGetAppConfig:)
                                                     name:NotificationAppConfigRecivedFailed
                                                   object:nil];
        
	}
	
	return self;
}

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

- (void)launchApp:(NSNotification *)notification
{
    
    [Model sharedModel].mainView = [[[MainViewController alloc] init] autorelease];
    /*[[Model sharedModel] pushView:[Model sharedModel].mainView option:ViewTrasitionEffectNone];*/
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:[Model sharedModel].mainView];
    navigationController.navigationBarHidden = YES;
    [self presentViewController:navigationController animated:NO completion:nil];
}

- (void)failedGetAppConfig:(NSNotification *)notification
{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    if([userInfo stringForKey:@"SystemConfig_assetServer"]){
        //used old config
        [self launchApp:nil];
    } else {
        [[Model sharedModel] displayTip:@"设备注册失败，请检查网络连接或者稍后在试。" modal:YES];
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
