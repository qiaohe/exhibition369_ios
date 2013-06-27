//
//  MainViewController.h
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "EGORefreshTableHeaderView.h"

@class ApplyViewController;

typedef enum{
    RequestUnApplyExhibitionsList = 1,
    RequestApplyExhibitionList,
    RequestApplyStatus,
    RequestExhibitonIcon,
}MainViewRequestType;
typedef NS_OPTIONS(NSUInteger, MainViewActiveTab) {
    MainViewActiveTabExhibitions           = 1 << 0,
    MainViewActiveTabAppliedExhibitions    = 1 << 1
};

@interface MainViewController : BaseUIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UITextFieldDelegate,EGORefreshTableHeaderDelegate> {
    MainViewActiveTab activeTab;
    
    NSMutableArray *typeGroup;
    NSMutableDictionary *typeVSExhibitions;
    
    
    NSMutableArray *unAppliedExhibitions;
    NSMutableArray *AppliedExhibitions;
    
}
@property (retain, nonatomic) IBOutlet UITableView      *theTableView;
@property (nonatomic, strong) NSMutableDictionary       *imageDownloadsInProgress;
@property (retain, nonatomic) IBOutlet UITextField      *searchInput;
- (IBAction)searchExhibition:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView      *tabImage;
@property (retain, nonatomic) IBOutlet UIButton         *appliedBtn;
@property (retain, nonatomic) IBOutlet UIButton         *unAppliedBtn;
@property (retain, nonatomic) IBOutlet UIButton         *appliedStateBtn;
@property (retain, nonatomic) NSMutableArray            *AppliedExhibitions;
@property (retain, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic) BOOL                      reloading;
@property (retain, nonatomic) ASINetworkQueue           *requestQueue;
- (IBAction)appliedTapped:(id)sender;
- (IBAction)unAppliedTapped:(id)sender;
- (void) ApplyViewApplySuccess;

@end
