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

@interface ExhibitionDetailViewController : BaseUIViewController
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (assign, nonatomic) Exhibition *exhibition;
- (IBAction)backToMainView:(id)sender;

@end
