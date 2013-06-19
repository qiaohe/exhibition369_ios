//
//  MainViewController.h
//  Exhibition369
//
//  Created by Jack Wang on 6/17/13.
//  Copyright (c) 2013 MobilyDaily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"

typedef NS_OPTIONS(NSUInteger, MainViewActiveTab) {
    MainViewActiveTabExhibitions           = 1 << 0,
    MainViewActiveTabAppliedExhibitions    = 1 << 1
};

@interface MainViewController : BaseUIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    MainViewActiveTab activeTab;
    
    NSMutableArray *typeGroup;
    NSMutableDictionary *typeVSExhibitions;
    
    
    NSMutableArray *unAppliedExhibitions;
}
@property (retain, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (retain, nonatomic) IBOutlet UITextField *searchInput;
- (IBAction)searchExhibition:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *tabImage;
@property (retain, nonatomic) IBOutlet UIButton *appliedBtn;
@property (retain, nonatomic) IBOutlet UIButton *unAppliedBtn;
- (IBAction)appliedTapped:(id)sender;
- (IBAction)unAppliedTapped:(id)sender;

@end
