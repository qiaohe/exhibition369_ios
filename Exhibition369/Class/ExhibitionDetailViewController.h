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

@interface ExhibitionDetailViewController : BaseUIViewController<UIAlertViewDelegate,UITabBarDelegate,UITextFieldDelegate,RequestDelegate,NewsViewListDelegate,ApplyRequestDelegate>

@property (retain, nonatomic) IBOutlet UILabel     *titleLabel;
@property (retain, nonatomic) IBOutlet UIView      *titleView;
@property (retain, nonatomic) IBOutlet UIImageView *titleImageView;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (assign, nonatomic) Exhibition *exhibition;
@property (retain, nonatomic) NSArray *viewControllers;
@property (assign, nonatomic) NSInteger prevIndex;
@property (assign, nonatomic) NSInteger prevBtnIndex;
- (IBAction)backToMainView:(id)sender;

- (IBAction)ButtonIsPress:(UIButton*)sender;

- (void)ApplyViewShow;

@end
