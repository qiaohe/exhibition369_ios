//
//  ExhibitionNewsViewController.h
//  Exhibition369
//
//  Created by M J on 13-6-19.
//  Copyright (c) 2013年 MobilyDaily. All rights reserved.
//

#import "BaseUIViewController.h"
#import "NewsTableCell.h"
#import "NewsDetailViewController.h"
#import "Model.h"

@protocol NewsViewListDelegate <NSObject>

- (void)SuperViewPresentViewController:(UIViewController*)viewController;

@end

@interface ExhibitionNewsViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,newsDetailViewControllerDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic, assign) id<NewsViewListDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView     *tableView;
@property (nonatomic, retain) NSMutableArray           *NewsArray;
@property (nonatomic, retain) IBOutlet UIImageView *UnloadImage;

- (IBAction)BackView:(id)sender;
- (IBAction)JumpToApplyView:(id)sender;

@end
