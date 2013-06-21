//
//  Model.h
//  CCBN
//
//  Created by Jack Wang on 2/28/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SystemConfig.h"
#import "MainViewController.h"
#import "TransitionController.h"
#import "Exhibition.h"
#import "IData.h"
#import "PlistProxy.h"
#import "SystemConfig.h"
#import "Exhibition369-Prefix.pch"
#import "SBJson.h"
#import "ExhibitionsNews.h"
#import <QuartzCore/QuartzCore.h>

@class HomePageViewController;

@interface Model : NSObject<ASIHTTPRequestDelegate> {
    BOOL sendingContent;
    //SystemSoundID messageSound;
}

+ (Model *)sharedModel;
@property (nonatomic, retain) NSMutableArray *appliedExhibitionList;
@property (nonatomic, retain) SystemConfig *systemConfig;
@property (nonatomic, retain) NSString *documentDirectory;
@property (nonatomic, retain) MainViewController *mainView;
@property (nonatomic, retain) Exhibition *selectExhibition;

- (void)createFolder:(NSArray *)pathComponents;
- (NSString *)createPath:(NSArray *)pathComponents;
- (void)initWithPlist;
- (void)displayTip:(NSString *)tip modal:(BOOL)modal;
- (void)pushView:(UIViewController *)view option:(ViewTrasitionEffect)options;
- (void)updateSystemConfig;
@end
