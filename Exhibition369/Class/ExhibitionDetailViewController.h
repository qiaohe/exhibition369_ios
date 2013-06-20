//
//  ExhibitionDetailViewController.h
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "Exhibition.h"
#import "ExhibitionInfoViewController.h"
#import "ExhibitionMessageViewController.h"
#import "ExhibitionNewsViewController.h"
#import "ExhibitionScheduleViewController.h"
#import "QRCodeViewController.h"
#import "ApplyViewController.h"

@interface ExhibitionDetailViewController : BaseUIViewController<UITabBarDelegate,UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UINavigationBar  *navigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *leftBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *rightBarButtonItem;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (assign, nonatomic) Exhibition *exhibition;
@property (retain, nonatomic) NSArray *viewControllers;
- (IBAction)backToMainView:(id)sender;

@end
