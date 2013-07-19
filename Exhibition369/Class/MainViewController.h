//
//  MainViewController.h
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseUIViewController.h"
#import "QRCodeScanViewController.h"


#define _BASE_STRING_ @"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
#define _BASE_ASCII_  @"0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f"
#define SCAN_BASE_HEADER_HEIGHT  (appFrame.size.height/460 - 1)*120
#define SCAN_BASE_FOOTER_HEIGHT  (appFrame.size.height/460 - 1)*345

@class ApplyViewController;
@protocol LoadingMoreTableFooterDelegate;

typedef enum{
    RequestUnApplyExhibitionsList = 1,
    RequestApplyExhibitionList,
    RequestUnApplyExhibitionsLoadingMore,
    RequestScanExhibition,
}MainViewRequestType;

typedef NS_OPTIONS(NSUInteger, MainViewActiveTab) {
    MainViewActiveTabExhibitions           = 1 << 0,
    MainViewActiveTabAppliedExhibitions    = 1 << 1
};

@interface MainViewController : BaseUIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UITextFieldDelegate,EGORefreshTableHeaderDelegate, LoadingMoreTableFooterDelegate,ZBarReaderDelegate,UIAlertViewDelegate> {
    MainViewActiveTab activeTab;
    
    NSMutableArray *typeGroup;
    NSMutableDictionary *typeVSExhibitions;
    
    
    NSMutableArray *unAppliedExhibitions;    
}

@property (retain, nonatomic) IBOutlet UITableView      *theTableView;
@property (nonatomic, strong) NSMutableDictionary       *imageDownloadsInProgress;
@property (retain, nonatomic) IBOutlet UITextField      *searchInput;
- (IBAction)searchExhibition:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView      *tabImage;
@property (retain, nonatomic) IBOutlet UIButton         *appliedBtn;
@property (retain, nonatomic) IBOutlet UIButton         *unAppliedBtn;
@property (retain, nonatomic) IBOutlet UIButton         *appliedStateBtn;
@property (retain, nonatomic) NSMutableArray            *appliedExhibitions;
@property (retain, nonatomic) NSMutableArray            *scanArray;
@property (retain, nonatomic) NSString                  *applyListOldSearchKey;
@property (retain, nonatomic) NSString                  *unapplyListOldSearchKey;
@property (retain, nonatomic) NSUserDefaults            *userDefault;
@property (retain, nonatomic) NSString                  *userDefaultURL;
@property (retain, nonatomic) ZBarReaderViewController  *reader;
@property (retain, nonatomic) IBOutlet UIImageView      *exhibitionNonentity;
@property (retain, nonatomic) NSIndexPath               *editCell;

- (IBAction)appliedTapped:(id)sender;
- (IBAction)unAppliedTapped:(id)sender;
- (IBAction)qrcodeScan:(id)sender;
- (void)applySuccess;

@end
